from __future__ import annotations

from pathlib import Path

from app.services.parser_service import ParserService
from app.utils.cache_manager import CacheManager


def _serialized_table(full_name: str) -> dict:
    schema, table_name = full_name.split(".", 1)
    return {
        "schema": schema,
        "table_name": table_name,
        "full_name": full_name,
        "columns": [{"name": "ID"}],
    }


def _serialized_data(*table_names: str) -> dict:
    return {
        "tables": [_serialized_table(name) for name in table_names],
        "procedures": [],
        "table_lineages": [],
        "field_mappings": [],
        "caliber_infos": [],
    }


def test_parser_service_rebuilds_unified_tracer_after_data_reload(tmp_path: Path) -> None:
    parser = ParserService(
        data_dir=str(tmp_path / "data"),
        schema_dirs=[],
        output_dir=str(tmp_path / "output"),
    )
    parser._populate_result_from_data(_serialized_data("OLD_SCHEMA.OLD_TABLE"))
    old_tracer = parser.get_unified_tracer()

    parser._populate_result_from_data(_serialized_data("NEW_SCHEMA.NEW_TABLE"))
    new_tracer = parser.get_unified_tracer()

    assert old_tracer is not None
    assert new_tracer is not None
    assert new_tracer is not old_tracer
    assert new_tracer.get_node_detail("NEW_SCHEMA.NEW_TABLE")["table"] == "NEW_SCHEMA.NEW_TABLE"
    assert old_tracer.get_node_detail("OLD_SCHEMA.OLD_TABLE")["table"] == "OLD_SCHEMA.OLD_TABLE"


def test_cache_manager_keeps_only_ttl_lru_cache_responsibilities() -> None:
    cache = CacheManager(max_size=2)
    cache.set("first", {"value": 1})
    cache.set("second", {"value": 2})

    assert cache.get("first") == {"value": 1}

    cache.set("third", {"value": 3})

    assert cache.get("second") is None
    assert cache.get("first") == {"value": 1}
    assert cache.get("third") == {"value": 3}
    assert cache.stats == {"size": 2, "max_size": 2, "ttl": 3600}
