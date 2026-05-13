"""
数据仓库层
统一管理数据的加载、缓存和访问，提供类型安全的接口。
替代原先 ParserService.get_current_data() 每次从 JSON 文件读取的方式。
"""

from __future__ import annotations

import json
import logging
import threading
import time
from pathlib import Path
from typing import Any, Optional

logger = logging.getLogger(__name__)

SCHEMA_VERSION = 1


_MIGRATIONS: dict[int, list] = {}


def search_table_dicts(tables: list[dict], keyword: str, limit: int = 50) -> list[dict]:
    """搜索表名（智能排序 - 精确匹配优先）。"""
    keyword_upper = keyword.upper()
    matched: list[tuple[dict, float]] = []

    for table in tables:
        full_name = table.get("full_name", "").upper()
        short_name = table.get("table_name", "").upper()

        if keyword_upper not in full_name and keyword_upper not in short_name:
            continue

        if short_name == keyword_upper:
            score = 100.0
        elif full_name.endswith("." + keyword_upper):
            score = 80.0
        elif full_name.endswith("_" + keyword_upper):
            score = 60.0
        else:
            score = 40.0

        score -= len(full_name) * 0.1
        matched.append((table, score))

    matched.sort(key=lambda x: x[1], reverse=True)
    return [item[0] for item in matched[:limit]]


class DataRepository:
    """统一的数据访问层，提供内存缓存和类型安全的数据接口。

    职责：
      - 从 JSON 文件加载数据到内存
      - 提供按表名/字段名/过程名查询的接口
      - 支持增量更新
      - 线程安全
    """

    def __init__(self, data_path: Path):
        self._data_path = data_path
        self._lock = threading.Lock()
        self._data: Optional[dict[str, Any]] = None
        self._table_map: dict[str, dict] = {}
        self._procedure_map: dict[str, dict] = {}
        self._loaded_at: float = 0.0

    @property
    def is_loaded(self) -> bool:
        return self._data is not None

    @property
    def loaded_at(self) -> float:
        return self._loaded_at

    def load(self) -> bool:
        """从 JSON 文件加载数据到内存。"""
        with self._lock:
            if not self._data_path.exists():
                logger.warning("数据文件不存在: %s", self._data_path)
                return False

            try:
                t0 = time.time()
                with open(self._data_path, "r", encoding="utf-8") as f:
                    self._data = json.load(f)

                self._migrate_if_needed()
                self._build_indexes()
                self._loaded_at = time.time()
                elapsed = self._loaded_at - t0

                metadata = self._data.get("metadata", {})
                logger.info(
                    "数据加载完成: %d 张表, %d 个过程, 耗时 %.2fs",
                    metadata.get("total_tables", 0),
                    metadata.get("total_procedures", 0),
                    elapsed,
                )
                return True

            except Exception as e:
                logger.error("加载数据失败: %s", e, exc_info=True)
                return False

    def update(self, data: dict[str, Any]) -> None:
        """用新数据替换内存中的数据（不写文件）。"""
        with self._lock:
            self._data = data
            self._build_indexes()
            self._loaded_at = time.time()

    def get_raw_data(self) -> Optional[dict[str, Any]]:
        """获取原始数据字典（向后兼容）。"""
        with self._lock:
            return self._data

    def get_metadata(self) -> dict[str, Any]:
        """获取元数据。"""
        with self._lock:
            if not self._data:
                return {}
            return self._data.get("metadata", {})

    def get_all_tables(self) -> list[dict]:
        """获取所有表列表。"""
        with self._lock:
            if not self._data:
                return []
            return self._data.get("tables", [])

    def get_all_procedures(self) -> list[dict]:
        """获取所有存储过程列表。"""
        with self._lock:
            if not self._data:
                return []
            return self._data.get("procedures", [])

    def get_all_table_lineages(self) -> list[dict]:
        """获取所有表级血缘。"""
        with self._lock:
            if not self._data:
                return []
            return self._data.get("table_lineages", [])

    def get_all_field_mappings(self) -> list[dict]:
        """获取所有字段映射。"""
        with self._lock:
            if not self._data:
                return []
            return self._data.get("field_mappings", [])

    def get_all_caliber_infos(self) -> list[dict]:
        """获取所有口径信息。"""
        with self._lock:
            if not self._data:
                return []
            return self._data.get("caliber_infos", [])

    def search_caliber(
        self, table: str, field: str = "", limit: int = 200
    ) -> list[dict]:
        """按表名+字段名搜索口径信息。"""
        with self._lock:
            if not self._data:
                return []

            caliber_infos = self._data.get("caliber_infos", [])
            table_upper = table.upper()
            field_upper = field.upper() if field else ""

            matched: list[dict] = []
            for ci in caliber_infos:
                target_table = ci.get("target_table", "").upper()
                target_column = ci.get("target_column", "").upper()
                source_table = ci.get("source_table", "").upper()
                source_column = ci.get("source_column", "").upper()

                table_hit = (
                    table_upper in target_table
                    or table_upper in source_table
                    or table_upper in target_table.split(".")[-1]
                    or table_upper in source_table.split(".")[-1]
                )
                if not table_hit:
                    continue

                if field_upper:
                    field_hit = (
                        field_upper in target_column
                        or field_upper in source_column
                    )
                    if not field_hit:
                        continue

                matched.append(ci)
                if len(matched) >= limit:
                    break

            return matched

    def get_table(self, full_name: str) -> Optional[dict]:
        """按全名获取表信息。"""
        with self._lock:
            return self._table_map.get(full_name.upper())

    def get_procedure(self, full_name: str) -> Optional[dict]:
        """按全名获取存储过程信息。"""
        with self._lock:
            return self._procedure_map.get(full_name.upper())

    def search_tables(self, keyword: str, limit: int = 50) -> list[dict]:
        """搜索表名（智能排序 - 精确匹配优先）。"""
        with self._lock:
            if not self._data:
                return []
            return search_table_dicts(self._data.get("tables", []), keyword, limit)

    def _build_indexes(self) -> None:
        """构建内存索引。"""
        self._table_map.clear()
        self._procedure_map.clear()

        if not self._data:
            return

        for table in self._data.get("tables", []):
            full_name = table.get("full_name", "").upper()
            if full_name:
                self._table_map[full_name] = table

        for proc in self._data.get("procedures", []):
            full_name = proc.get("full_name", "").upper()
            if full_name:
                self._procedure_map[full_name] = proc

    def _migrate_if_needed(self) -> None:
        """检查数据版本并执行迁移。"""
        if not self._data:
            return

        metadata = self._data.setdefault("metadata", {})
        current_version = metadata.get("schema_version", 0)

        if current_version < SCHEMA_VERSION:
            logger.info("数据版本 %d → %d, 执行迁移...", current_version, SCHEMA_VERSION)

            for version in range(current_version + 1, SCHEMA_VERSION + 1):
                migrations = _MIGRATIONS.get(version, [])
                for migration_fn in migrations:
                    migration_fn(self._data)

            metadata["schema_version"] = SCHEMA_VERSION
            logger.info("数据迁移完成: 版本 %d", SCHEMA_VERSION)
