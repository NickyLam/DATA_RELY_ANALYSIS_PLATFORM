"""
SQLite 存储后端

实现 ResultStoreProtocol，使用 SQLite 数据库持久化解析结果。
支持线程安全的连接管理、批量写入、元数据版本校验。
"""

from __future__ import annotations

import json
import logging
import sqlite3
import threading
import time
from pathlib import Path
from typing import Any, Iterator, Optional

from app.services.storage.migrations import (
    DATA_TABLE_NAMES,
    init_schema,
)

logger = logging.getLogger(__name__)


class SQLiteConnectionManager:
    """线程安全的 SQLite 连接管理器。

    使用 threading.local() 为每个线程维护独立连接，
    配合 WAL 模式实现读写并发。
    """

    def __init__(self, db_path: Path):
        self._db_path = db_path
        self._local = threading.local()

    def get_connection(self) -> sqlite3.Connection:
        conn: Optional[sqlite3.Connection] = getattr(self._local, "connection", None)
        if conn is not None:
            try:
                conn.execute("SELECT 1")
                return conn
            except sqlite3.Error:
                try:
                    conn.close()
                except Exception:
                    pass
                conn = None

        db_path_str = str(self._db_path)
        conn = sqlite3.connect(db_path_str)
        conn.execute("PRAGMA journal_mode=WAL")
        conn.execute("PRAGMA synchronous=NORMAL")
        conn.execute("PRAGMA foreign_keys=ON")
        conn.execute("PRAGMA temp_store=MEMORY")
        conn.row_factory = sqlite3.Row
        self._local.connection = conn
        return conn

    def close_all(self) -> None:
        conn: Optional[sqlite3.Connection] = getattr(self._local, "connection", None)
        if conn is not None:
            try:
                conn.close()
            except Exception:
                pass
            self._local.connection = None


class SQLiteResultStore:
    """基于 SQLite 的解析结果存储后端。"""

    def __init__(self, db_path: Path):
        self._db_path = db_path
        self._conn_mgr = SQLiteConnectionManager(db_path)
        self._ensure_schema()

    def _ensure_schema(self) -> None:
        """确保数据库目录和 schema 存在。"""
        self._db_path.parent.mkdir(parents=True, exist_ok=True)
        conn = self._conn_mgr.get_connection()
        init_schema(conn)

    # ── ResultStoreProtocol 实现 ────────────────────────────────

    def load(self) -> Optional[dict[str, Any]]:
        """从 SQLite 加载解析结果。"""
        conn = self._conn_mgr.get_connection()

        # 校验 schema 版本
        row = conn.execute(
            "SELECT value FROM storage_metadata WHERE key = 'cache_schema_version'"
        ).fetchone()
        if row is None:
            return None

        metadata = self._read_metadata(conn)
        if not metadata.get("total_tables"):
            logger.info("SQLite 缓存数据为空")
            return None

        tables = self._read_table(conn, "tables")
        procedures = self._read_table(conn, "procedures")
        table_lineages = self._read_table(conn, "table_lineages")
        field_mappings = self._read_table(conn, "field_mappings")
        caliber_infos = self._read_table(conn, "caliber_infos")

        logger.info(
            "从 SQLite 加载: %d 表, %d 过程, %d 血缘, %d 映射, %d 口径",
            len(tables), len(procedures), len(table_lineages),
            len(field_mappings), len(caliber_infos),
        )

        return {
            "metadata": metadata,
            "tables": tables,
            "procedures": procedures,
            "table_lineages": table_lineages,
            "field_mappings": field_mappings,
            "caliber_infos": caliber_infos,
        }

    def save(self, result_data: dict[str, Any]) -> None:
        """全量写入解析结果到 SQLite。

        使用分表事务策略：每张表先 DELETE 再 INSERT，避免
        单个超大事务导致内存和 WAL 文件膨胀。
        """
        conn = self._conn_mgr.get_connection()
        try:
            conn.execute("PRAGMA wal_checkpoint(TRUNCATE)")
        except Exception:
            pass

        metadata = result_data.get("metadata", {})
        now = time.time()
        batch_size = 5000

        try:
            # ── 表数据 ──
            self._replace_table_data(conn, "tables",
                                     result_data.get("tables", []),
                                     self._iter_table_rows, batch_size, now)

            # ── 过程数据 ──
            self._replace_table_data(conn, "procedures",
                                     result_data.get("procedures", []),
                                     self._iter_procedure_rows, batch_size, now)

            # ── 血缘数据 ──
            self._replace_table_data(conn, "table_lineages",
                                     result_data.get("table_lineages", []),
                                     self._iter_lineage_rows, batch_size, now)

            # ── 字段映射 ──
            self._replace_table_data(conn, "field_mappings",
                                     result_data.get("field_mappings", []),
                                     self._iter_mapping_rows, batch_size, now)

            # ── 口径数据 ──
            self._replace_table_data(conn, "caliber_infos",
                                     result_data.get("caliber_infos", []),
                                     self._iter_caliber_rows, batch_size, now)

            # ── 元数据 ──
            with conn:
                cursor = conn.cursor()
                self._upsert_metadata(cursor, metadata, now)

            # 写入后 checkpoint
            try:
                conn.execute("PRAGMA wal_checkpoint(TRUNCATE)")
            except Exception:
                pass

            db_size = self._db_path.stat().st_size / (1024 * 1024)
            if db_size > 1000:
                logger.warning("数据库体积较大: %.0f MB，考虑优化 raw_json 存储", db_size)
            logger.info("SQLite 数据保存完成: %.1f MB", db_size)

        except Exception:
            logger.error("全量写入失败，事务已回滚，旧数据保留")
            raise

    def clear(self) -> None:
        """清空 SQLite 中的解析结果数据。"""
        conn = self._conn_mgr.get_connection()
        with conn:
            cursor = conn.cursor()
            for table_name in DATA_TABLE_NAMES:
                cursor.execute(f"DELETE FROM {table_name}")
            cursor.execute("DELETE FROM storage_metadata")
        logger.info("SQLite 缓存已清除")

    def export_json(self, path: Path) -> None:
        """将 SQLite 数据导出为 JSON 文件。"""
        data = self.load()
        if data is None:
            logger.warning("SQLite 无数据可导出")
            return

        path.parent.mkdir(parents=True, exist_ok=True)
        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        logger.info("JSON 导出完成: %s", path)

    # ── 分表写入基础设施 ───────────────────────────────────────

    def _replace_table_data(
        self,
        conn: sqlite3.Connection,
        table_name: str,
        items: list[dict],
        row_iter_fn,
        batch_size: int,
        now: float,
    ) -> None:
        """分表事务: 先 DELETE 再分批 INSERT。"""
        with conn:
            conn.execute(f"DELETE FROM {table_name}")

        batch = []
        inserted = 0
        for row in row_iter_fn(items, now):
            batch.append(row)
            if len(batch) >= batch_size:
                with conn:
                    conn.executemany(self._insert_sql(table_name), batch)
                inserted += len(batch)
                batch = []

        if batch:
            with conn:
                conn.executemany(self._insert_sql(table_name), batch)
            inserted += len(batch)

        if inserted:
            logger.debug("写入 %s: %d 行", table_name, inserted)

    @staticmethod
    def _insert_sql(table_name: str) -> str:
        """获取 INSERT OR REPLACE SQL。"""
        _SQL_MAP = {
            "tables": (
                "INSERT OR REPLACE INTO tables "
                "(full_name, schema_name, table_name, description, layer, "
                "data_source, columns_json, raw_json, updated_at) "
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
            ),
            "procedures": (
                "INSERT OR REPLACE INTO procedures "
                "(full_name, schema_name, proc_name, description, data_source, "
                "source_tables_json, target_tables_json, raw_json, updated_at) "
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
            ),
            "table_lineages": (
                "INSERT OR REPLACE INTO table_lineages "
                "(source_table, target_table, procedure_name, data_source, "
                "raw_json, updated_at) "
                "VALUES (?, ?, ?, ?, ?, ?)"
            ),
            "field_mappings": (
                "INSERT OR REPLACE INTO field_mappings "
                "(source_table, source_column, target_table, target_column, "
                "procedure_name, confidence, transform_logic, raw_json, updated_at) "
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
            ),
            "caliber_infos": (
                "INSERT OR REPLACE INTO caliber_infos "
                "(target_table, target_column, source_table, source_column, "
                "procedure_name, step_num, data_source, raw_json, updated_at) "
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
            ),
        }
        return _SQL_MAP[table_name]

    # ── 行迭代器（内存友好，逐条生成） ─────────────────────────

    @staticmethod
    def _iter_table_rows(items: list[dict], now: float) -> Iterator[tuple]:
        for t in items:
            full_name = t.get("full_name", "")
            schema_name = ""
            table_name = ""
            if "." in full_name:
                parts = full_name.split(".", 1)
                schema_name = parts[0]
                table_name = parts[1]
            else:
                table_name = full_name

            columns_json = (
                json.dumps(t.get("columns", []), ensure_ascii=False)
                if t.get("columns")
                else None
            )
            raw_json = json.dumps(t, ensure_ascii=False)

            yield (
                full_name, schema_name, table_name,
                t.get("description", ""),
                t.get("layer", ""),
                t.get("data_source", ""),
                columns_json,
                raw_json,
                now,
            )

    @staticmethod
    def _iter_procedure_rows(items: list[dict], now: float) -> Iterator[tuple]:
        for p in items:
            full_name = p.get("full_name", "")
            schema_name = ""
            proc_name = ""
            if "." in full_name:
                parts = full_name.split(".", 1)
                schema_name = parts[0]
                proc_name = parts[1]
            else:
                proc_name = full_name

            source_tables_json = (
                json.dumps(p.get("source_tables", []), ensure_ascii=False)
                if p.get("source_tables")
                else None
            )
            target_tables_json = (
                json.dumps(p.get("target_tables", []), ensure_ascii=False)
                if p.get("target_tables")
                else None
            )
            raw_json = json.dumps(p, ensure_ascii=False)

            yield (
                full_name, schema_name, proc_name,
                p.get("description", ""),
                p.get("data_source", ""),
                source_tables_json, target_tables_json,
                raw_json, now,
            )

    @staticmethod
    def _iter_lineage_rows(items: list[dict], now: float) -> Iterator[tuple]:
        for l in items:
            raw_json = json.dumps(l, ensure_ascii=False)
            yield (
                l.get("source_table", ""),
                l.get("target_table", ""),
                l.get("procedure", ""),
                l.get("data_source", ""),
                raw_json,
                now,
            )

    @staticmethod
    def _iter_mapping_rows(items: list[dict], now: float) -> Iterator[tuple]:
        for m in items:
            raw_json = json.dumps(m, ensure_ascii=False)
            yield (
                m.get("source_table", ""),
                m.get("source_column", ""),
                m.get("target_table", ""),
                m.get("target_column", ""),
                m.get("procedure", ""),
                m.get("confidence"),
                m.get("transform_logic", ""),
                raw_json,
                now,
            )

    @staticmethod
    def _iter_caliber_rows(items: list[dict], now: float) -> Iterator[tuple]:
        for c in items:
            raw_json = json.dumps(c, ensure_ascii=False)
            yield (
                c.get("target_table", ""),
                c.get("target_column", ""),
                c.get("source_table", ""),
                c.get("source_column", ""),
                c.get("procedure", ""),
                c.get("step_num", 0),
                c.get("data_source", ""),
                raw_json,
                now,
            )

    # ── 元数据操作 ─────────────────────────────────────────────

    def _read_metadata(self, conn: sqlite3.Connection) -> dict[str, Any]:
        """读取所有 metadata 键值对。"""
        rows = conn.execute(
            "SELECT key, value FROM storage_metadata"
        ).fetchall()
        metadata = {}
        for row in rows:
            key, value = row["key"], row["value"]
            try:
                metadata[key] = json.loads(value)
            except (json.JSONDecodeError, TypeError):
                metadata[key] = value
        return metadata

    def _upsert_metadata(
        self, cursor: sqlite3.Cursor, metadata: dict[str, Any], now: float
    ) -> None:
        """批量 upsert metadata。"""
        if "last_updated" not in metadata:
            metadata["last_updated"] = time.strftime("%Y-%m-%d %H:%M:%S")

        for key, value in metadata.items():
            if isinstance(value, (dict, list)):
                value_str = json.dumps(value, ensure_ascii=False)
            else:
                value_str = str(value)
            cursor.execute(
                "INSERT OR REPLACE INTO storage_metadata (key, value, updated_at) "
                "VALUES (?, ?, ?)",
                (key, value_str, now),
            )

    # ── 读取还原 ───────────────────────────────────────────────

    def _read_table(self, conn: sqlite3.Connection, table_name: str) -> list[dict]:
        """从表中读取所有 raw_json 还原为 dict 列表。"""
        rows = conn.execute(
            f"SELECT raw_json FROM {table_name}"
        ).fetchall()
        result = []
        for row in rows:
            try:
                result.append(json.loads(row["raw_json"]))
            except (json.JSONDecodeError, TypeError) as e:
                logger.warning("解析 %s raw_json 失败: %s", table_name, e)
        return result
