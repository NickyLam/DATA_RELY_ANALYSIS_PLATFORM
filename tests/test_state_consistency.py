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


def test_cache_manager_build_index_replaces_old_table_and_procedure_indexes() -> None:
    cache = CacheManager()
    cache.build_index(
        tables=[{"full_name": "OLD_SCHEMA.OLD_TABLE"}],
        procedures=[{"full_name": "OLD_PROC.P_OLD"}],
    )

    assert cache.search_by_keyword("OLD_TABLE") == ["OLD_SCHEMA.OLD_TABLE"]
    assert cache.search_by_keyword("P_OLD", index_type="procedure_name") == ["OLD_PROC.P_OLD"]

    cache.build_index(
        tables=[{"full_name": "NEW_SCHEMA.NEW_TABLE"}],
        procedures=[{"full_name": "NEW_PROC.P_NEW"}],
    )

    assert "OLD_SCHEMA.OLD_TABLE" not in cache.search_by_keyword("OLD_TABLE")
    assert "OLD_PROC.P_OLD" not in cache.search_by_keyword("P_OLD", index_type="procedure_name")
    assert cache.search_by_keyword("NEW_TABLE") == ["NEW_SCHEMA.NEW_TABLE"]
    assert cache.search_by_keyword("P_NEW", index_type="procedure_name") == ["NEW_PROC.P_NEW"]
