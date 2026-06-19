"""
SQLite 存储后端单元测试

覆盖:
- SQLiteResultStore 的 save/load/clear/export_json 全流程
- 数据库 schema 初始化
- 元数据读写
- 批量写入
- CacheStore 后端选择
"""

from __future__ import annotations

import json
import tempfile
import threading
from pathlib import Path
from typing import Any

import pytest

# ── Fixtures ───────────────────────────────────────────────────────


@pytest.fixture
def sample_result_data() -> dict[str, Any]:
    """小型测试解析结果 fixture。"""
    return {
        "metadata": {
            "cache_schema_version": "v4",
            "total_tables": 3,
            "total_procedures": 2,
            "total_table_lineages": 4,
            "total_field_mappings": 5,
            "total_caliber_infos": 3,
            "data_sources": ["rrp", "edw"],
            "last_updated": "2026-05-25 14:30:00",
            "parser_version": "2.2.0",
        },
        "tables": [
            {
                "full_name": "RRP_EAST.EAST5_D01_DEP_INFO",
                "table_name": "EAST5_D01_DEP_INFO",
                "description": "存款信息表",
                "layer": "SRC",
                "data_source": "rrp",
                "columns": [
                    {"name": "DEP_ID", "type": "VARCHAR2(32)"},
                    {"name": "AMT", "type": "NUMBER(18,2)"},
                ],
            },
            {
                "full_name": "DW.DIM_DEPARTMENT",
                "table_name": "DIM_DEPARTMENT",
                "description": "部门维度",
                "layer": "IDL",
                "data_source": "edw",
                "columns": [],
            },
            {
                "full_name": "RRP_MDL.ICL_DEP_SUM",
                "table_name": "ICL_DEP_SUM",
                "description": "存款汇总",
                "layer": "ICL",
                "data_source": "rrp",
                "columns": [],
            },
        ],
        "procedures": [
            {
                "full_name": "RRP_EAST.SP_LOAD_DEP",
                "description": "加载存款数据",
                "data_source": "rrp",
                "source_tables": ["RRP_EAST.EAST5_D01_DEP_INFO"],
                "target_tables": ["DW.DIM_DEPARTMENT"],
            },
            {
                "full_name": "DW.SP_TRANSFORM_DEP",
                "description": "转换存款",
                "data_source": "edw",
                "source_tables": ["DW.DIM_DEPARTMENT"],
                "target_tables": ["RRP_MDL.ICL_DEP_SUM"],
            },
        ],
        "table_lineages": [
            {
                "source_table": "RRP_EAST.EAST5_D01_DEP_INFO",
                "target_table": "DW.DIM_DEPARTMENT",
                "procedure": "RRP_EAST.SP_LOAD_DEP",
                "data_source": "rrp",
            },
            {
                "source_table": "DW.DIM_DEPARTMENT",
                "target_table": "RRP_MDL.ICL_DEP_SUM",
                "procedure": "DW.SP_TRANSFORM_DEP",
                "data_source": "edw",
            },
            {
                "source_table": "RRP_EAST.EAST5_D01_DEP_INFO",
                "target_table": "RRP_MDL.ICL_DEP_SUM",
                "procedure": "RRP_EAST.SP_LOAD_DEP",
                "data_source": "rrp",
            },
            {
                "source_table": "DW.DIM_DEPARTMENT",
                "target_table": "RRP_MDL.ICL_DEP_SUM",
                "procedure": "RRP_EAST.SP_LOAD_DEP",
                "data_source": "edw",
            },
        ],
        "field_mappings": [
            {
                "source_table": "RRP_EAST.EAST5_D01_DEP_INFO",
                "source_column": "DEP_ID",
                "target_table": "DW.DIM_DEPARTMENT",
                "target_column": "DEP_KEY",
                "procedure": "RRP_EAST.SP_LOAD_DEP",
                "confidence": 1.0,
                "transform_logic": "DIRECT",
            },
            {
                "source_table": "RRP_EAST.EAST5_D01_DEP_INFO",
                "source_column": "AMT",
                "target_table": "DW.DIM_DEPARTMENT",
                "target_column": "DEP_AMT",
                "procedure": "RRP_EAST.SP_LOAD_DEP",
                "confidence": 0.9,
                "transform_logic": "SUM",
            },
            {
                "source_table": "DW.DIM_DEPARTMENT",
                "source_column": "DEP_KEY",
                "target_table": "RRP_MDL.ICL_DEP_SUM",
                "target_column": "KEY",
                "procedure": "DW.SP_TRANSFORM_DEP",
                "confidence": 1.0,
                "transform_logic": "DIRECT",
            },
            {
                "source_table": "DW.DIM_DEPARTMENT",
                "source_column": "DEP_AMT",
                "target_table": "RRP_MDL.ICL_DEP_SUM",
                "target_column": "TOTAL_AMT",
                "procedure": "DW.SP_TRANSFORM_DEP",
                "confidence": 0.8,
                "transform_logic": "AGG",
            },
            {
                "source_table": "RRP_EAST.EAST5_D01_DEP_INFO",
                "source_column": "AMT",
                "target_table": "RRP_MDL.ICL_DEP_SUM",
                "target_column": "TOTAL_AMT",
                "procedure": "RRP_EAST.SP_LOAD_DEP",
                "confidence": 0.7,
                "transform_logic": "SUM",
            },
        ],
        "caliber_infos": [
            {
                "target_table": "DW.DIM_DEPARTMENT",
                "target_column": "DEP_AMT",
                "source_table": "RRP_EAST.EAST5_D01_DEP_INFO",
                "source_column": "AMT",
                "procedure": "RRP_EAST.SP_LOAD_DEP",
                "step_num": 1,
                "data_source": "rrp",
            },
            {
                "target_table": "RRP_MDL.ICL_DEP_SUM",
                "target_column": "TOTAL_AMT",
                "source_table": "DW.DIM_DEPARTMENT",
                "source_column": "DEP_AMT",
                "procedure": "DW.SP_TRANSFORM_DEP",
                "step_num": 1,
                "data_source": "edw",
            },
            {
                "target_table": "RRP_MDL.ICL_DEP_SUM",
                "target_column": "TOTAL_AMT",
                "source_table": "RRP_EAST.EAST5_D01_DEP_INFO",
                "source_column": "AMT",
                "procedure": "RRP_EAST.SP_LOAD_DEP",
                "step_num": 2,
                "data_source": "rrp",
            },
        ],
    }


@pytest.fixture
def temp_dir():
    with tempfile.TemporaryDirectory() as d:
        yield Path(d)


# ── SQLiteResultStore 测试 ────────────────────────────────────────


class TestSQLiteResultStore:
    def test_save_and_load(self, temp_dir, sample_result_data):
        from app.services.storage.sqlite_store import SQLiteResultStore

        db_path = temp_dir / "test.db"
        store = SQLiteResultStore(db_path)

        store.save(sample_result_data)
        loaded = store.load()

        assert loaded is not None
        assert len(loaded["tables"]) == 3
        assert len(loaded["procedures"]) == 2
        assert len(loaded["table_lineages"]) == 4
        assert len(loaded["field_mappings"]) == 5
        assert len(loaded["caliber_infos"]) == 3

    def test_metadata_preserved(self, temp_dir, sample_result_data):
        from app.services.storage.sqlite_store import SQLiteResultStore

        db_path = temp_dir / "test.db"
        store = SQLiteResultStore(db_path)

        store.save(sample_result_data)
        loaded = store.load()

        metadata = loaded["metadata"]
        assert metadata["cache_schema_version"] == "v4"
        assert metadata["total_tables"] == 3
        assert metadata["total_procedures"] == 2
        assert "last_updated" in metadata

    def test_table_data_integrity(self, temp_dir, sample_result_data):
        from app.services.storage.sqlite_store import SQLiteResultStore

        db_path = temp_dir / "test.db"
        store = SQLiteResultStore(db_path)

        store.save(sample_result_data)
        loaded = store.load()

        table = loaded["tables"][0]
        assert table["full_name"] == "RRP_EAST.EAST5_D01_DEP_INFO"
        assert table["table_name"] == "EAST5_D01_DEP_INFO"
        assert table["layer"] == "SRC"
        assert len(table["columns"]) == 2

    def test_lineage_data_integrity(self, temp_dir, sample_result_data):
        from app.services.storage.sqlite_store import SQLiteResultStore

        db_path = temp_dir / "test.db"
        store = SQLiteResultStore(db_path)

        store.save(sample_result_data)
        loaded = store.load()

        lineage = loaded["table_lineages"][0]
        assert "source_table" in lineage
        assert "target_table" in lineage
        assert "procedure" in lineage

    def test_field_mapping_data_integrity(self, temp_dir, sample_result_data):
        from app.services.storage.sqlite_store import SQLiteResultStore

        db_path = temp_dir / "test.db"
        store = SQLiteResultStore(db_path)

        store.save(sample_result_data)
        loaded = store.load()

        mapping = loaded["field_mappings"][0]
        assert mapping["source_table"] == "RRP_EAST.EAST5_D01_DEP_INFO"
        assert mapping["source_column"] == "DEP_ID"
        assert mapping["target_column"] == "DEP_KEY"
        assert mapping["confidence"] == 1.0

    def test_clear(self, temp_dir, sample_result_data):
        from app.services.storage.sqlite_store import SQLiteResultStore

        db_path = temp_dir / "test.db"
        store = SQLiteResultStore(db_path)

        store.save(sample_result_data)
        assert store.load() is not None

        store.clear()
        assert store.load() is None

    def test_export_json(self, temp_dir, sample_result_data):
        from app.services.storage.sqlite_store import SQLiteResultStore

        db_path = temp_dir / "test.db"
        json_path = temp_dir / "export.json"
        store = SQLiteResultStore(db_path)

        store.save(sample_result_data)
        store.export_json(json_path)

        assert json_path.exists()
        with open(json_path, encoding="utf-8") as f:
            exported = json.load(f)
        assert len(exported["tables"]) == 3

    def test_load_empty_db(self, temp_dir):
        from app.services.storage.sqlite_store import SQLiteResultStore

        db_path = temp_dir / "empty.db"
        store = SQLiteResultStore(db_path)

        result = store.load()
        assert result is None

    def test_overwrite_save(self, temp_dir, sample_result_data):
        from app.services.storage.sqlite_store import SQLiteResultStore

        db_path = temp_dir / "test.db"
        store = SQLiteResultStore(db_path)

        store.save(sample_result_data)

        # 修改后再次保存
        modified = {**sample_result_data, "tables": sample_result_data["tables"][:1]}
        modified["metadata"] = {**sample_result_data["metadata"], "total_tables": 1}
        store.save(modified)

        loaded = store.load()
        assert len(loaded["tables"]) == 1

    def test_thread_safety(self, temp_dir, sample_result_data):
        """多线程并发读写测试。"""
        from app.services.storage.sqlite_store import SQLiteResultStore

        db_path = temp_dir / "concurrent.db"
        store = SQLiteResultStore(db_path)

        store.save(sample_result_data)

        errors = []

        def read_data():
            try:
                data = store.load()
                if data is None:
                    errors.append("load returned None")
            except Exception as e:
                errors.append(str(e))

        threads = [threading.Thread(target=read_data) for _ in range(10)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()

        assert len(errors) == 0, f"线程安全错误: {errors}"


# ── CacheStore 后端选择测试 ───────────────────────────────────────


class TestCacheStoreBackend:
    def test_sqlite_backend(self, temp_dir, sample_result_data):
        from app.services.cache_store import CacheStore

        class MockConfig:
            storage_backend = "sqlite"
            sqlite_db_path = str(temp_dir / "lineage.db")
            enable_legacy_cache_write = False

        store = CacheStore(temp_dir, config=MockConfig())
        store.save_to_cache(sample_result_data)

        loaded = store.load_from_cache()
        assert loaded is not None
        assert len(loaded["tables"]) == 3

    def test_legacy_backend(self, temp_dir, sample_result_data):
        from app.services.cache_store import CacheStore

        class MockConfig:
            storage_backend = "legacy"
            sqlite_db_path = ""
            enable_legacy_cache_write = False

        store = CacheStore(temp_dir, config=MockConfig())
        store.save_to_cache(sample_result_data)

        loaded = store.load_from_cache()
        assert loaded is not None
        assert len(loaded["tables"]) == 3

        # 验证文件存在
        assert (temp_dir / "lineage_data.json").exists()

    def test_clear_cache(self, temp_dir, sample_result_data):
        from app.services.cache_store import CacheStore

        class MockConfig:
            storage_backend = "sqlite"
            sqlite_db_path = str(temp_dir / "lineage.db")
            enable_legacy_cache_write = False

        store = CacheStore(temp_dir, config=MockConfig())
        store.save_to_cache(sample_result_data)
        store.clear_cache()

        loaded = store.load_from_cache()
        assert loaded is None

    def test_save_to_cache_propagates_store_failures(self, temp_dir, sample_result_data):
        from app.services.cache_store import CacheStore

        class MockConfig:
            storage_backend = "sqlite"
            sqlite_db_path = str(temp_dir / "lineage.db")
            enable_legacy_cache_write = False

        class BrokenStore:
            def load(self):
                return None

            def save(self, result_data):
                raise OSError("disk full")

            def clear(self):
                pass

            def export_json(self, path):
                pass

        store = CacheStore(temp_dir, config=MockConfig())
        store._store = BrokenStore()

        with pytest.raises(OSError, match="disk full"):
            store.save_to_cache(sample_result_data)

    def test_parser_service_cache_save_propagates_failures(self, tmp_path):
        from app.services.parser_service import ParseResult, ParserService

        class BrokenCacheStore:
            def save_to_cache(self, data):
                raise RuntimeError("cache backend unavailable")

        parser = ParserService(
            data_dir=str(tmp_path / "data"),
            schema_dirs=[],
            output_dir=str(tmp_path / "output"),
        )
        parser._cache_store = BrokenCacheStore()

        try:
            with pytest.raises(RuntimeError, match="cache backend unavailable"):
                parser._save_result_to_cache(ParseResult())

            assert parser._current_data_cache is None
        finally:
            parser.shutdown()


# ── DataRepository 测试 ────────────────────────────────────────────


class TestDataRepository:
    def test_load_from_dict(self, sample_result_data):
        from app.repository import DataRepository

        repo = DataRepository()
        result = repo.load_from_dict(sample_result_data)

        assert result is True
        assert repo.is_loaded
        assert len(repo.get_all_tables()) == 3
        assert len(repo.get_all_procedures()) == 2

    def test_get_table(self, sample_result_data):
        from app.repository import DataRepository

        repo = DataRepository()
        repo.load_from_dict(sample_result_data)

        table = repo.get_table("RRP_EAST.EAST5_D01_DEP_INFO")
        assert table is not None
        assert table["layer"] == "SRC"

    def test_search_tables(self, sample_result_data):
        from app.repository import DataRepository

        repo = DataRepository()
        repo.load_from_dict(sample_result_data)

        results = repo.search_tables("EAST5")
        assert len(results) > 0
        assert results[0]["table_name"] == "EAST5_D01_DEP_INFO"

    def test_get_metadata(self, sample_result_data):
        from app.repository import DataRepository

        repo = DataRepository()
        repo.load_from_dict(sample_result_data)

        metadata = repo.get_metadata()
        assert metadata["total_tables"] == 3

    def test_empty_repository(self):
        from app.repository import DataRepository

        repo = DataRepository()
        assert repo.is_loaded is False
        assert repo.get_all_tables() == []
        assert repo.get_metadata() == {}

    def test_load_from_json(self, temp_dir, sample_result_data):
        from app.repository import DataRepository

        json_path = temp_dir / "test_data.json"
        with open(json_path, "w", encoding="utf-8") as f:
            json.dump(sample_result_data, f)

        repo = DataRepository()
        result = repo.load_from_json(json_path)
        assert result is True
        assert repo.is_loaded


# ── Schema 测试 ────────────────────────────────────────────────────


class TestMigrations:
    def test_schema_creation(self, temp_dir):
        import sqlite3

        from app.services.storage.migrations import init_schema

        db_path = temp_dir / "schema_test.db"
        conn = sqlite3.connect(str(db_path))
        init_schema(conn)

        # 验证所有表已创建
        tables = conn.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name").fetchall()
        table_names = [t[0] for t in tables]
        assert "tables" in table_names
        assert "procedures" in table_names
        assert "table_lineages" in table_names
        assert "field_mappings" in table_names
        assert "caliber_infos" in table_names
        assert "storage_metadata" in table_names

        conn.close()
