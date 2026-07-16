from __future__ import annotations

import threading
from pathlib import Path

import pytest

from app.repository import search_table_dicts
from app.services.index_snapshot import IndexSnapshot
from app.services.parser_service import ParseResult, ParserService
from core.models import ColumnInfo, FieldMapping, ProcedureInfo, TableInfo, TableLineage


def _result(version: int, *, with_edges: bool = True) -> ParseResult:
    source_name = f"SRC.GEN_{version}"
    target_name = f"DWH.RESULT_{version}"
    result = ParseResult()
    result.tables = [
        TableInfo(
            schema="SRC",
            table_name=f"GEN_{version}",
            full_name=source_name,
            columns=[ColumnInfo(name="ID", data_type="NUMBER")],
        ),
        TableInfo(
            schema="DWH",
            table_name=f"RESULT_{version}",
            full_name=target_name,
            columns=[ColumnInfo(name="ID", data_type="NUMBER")],
        ),
        TableInfo(
            schema="DWH",
            table_name=f"RESULT_{version}_ARCHIVE",
            full_name=f"DWH.RESULT_{version}_ARCHIVE",
            columns=[ColumnInfo(name="ID", data_type="NUMBER")],
        ),
    ]
    result.procedures = [
        ProcedureInfo(
            schema="ETL",
            proc_name=f"LOAD_{version}",
            full_name=f"ETL.LOAD_{version}",
            source_tables=[source_name],
            target_tables=[target_name],
        )
    ]
    if with_edges:
        result.table_lineages = [
            TableLineage(
                source_table=source_name,
                target_table=target_name,
                procedure=f"ETL.LOAD_{version}",
            )
        ]
        result.field_mappings = [
            FieldMapping(
                source_table=source_name,
                source_column="ID",
                target_table=target_name,
                target_column="ID",
                procedure=f"ETL.LOAD_{version}",
            )
        ]
    return result


@pytest.fixture
def parser(tmp_path: Path):
    service = ParserService(
        data_dir=str(tmp_path / "data"),
        schema_dirs=[],
        output_dir=str(tmp_path / "output"),
    )
    try:
        yield service
    finally:
        service.shutdown()


def _snapshot(parser: ParserService, version: int = 1, *, with_edges: bool = True) -> IndexSnapshot:
    parser._set_current_result(_result(version, with_edges=with_edges))
    capture = parser.capture_query_state()
    assert capture is not None
    return IndexSnapshot.build(capture, publication_revision=7)


def test_snapshot_binds_generation_data_and_all_query_projections(parser: ParserService):
    snapshot = _snapshot(parser)

    assert snapshot.generation == 1
    assert snapshot.publication_namespace == (1, 7)
    assert snapshot.is_ready
    with pytest.raises(AttributeError):
        snapshot.generation = 99  # type: ignore[misc]
    assert [table["full_name"] for table in snapshot.search_tables("result_1")] == [
        "DWH.RESULT_1",
        "DWH.RESULT_1_ARCHIVE",
    ]
    assert snapshot.query_index.get_table_by_full("dwh.result_1")["table_name"] == "RESULT_1"

    nodes, edges = snapshot.trace_tables("RESULT_1", max_depth=2, direction="up")
    assert nodes == {"DWH.RESULT_1", "SRC.GEN_1"}
    assert edges == [{"source_table": "SRC.GEN_1", "target_table": "DWH.RESULT_1"}]

    chains = snapshot.field_tracing.trace_field_upstream("DWH.RESULT_1", "ID", 2)
    assert len(chains) == 1
    assert chains[0].chain[0].table_name == "SRC.GEN_1"


def test_procedure_search_preserves_legacy_token_intersection_semantics(parser: ParserService):
    result = _result(1)
    result.procedures = [
        ProcedureInfo(schema="ETL_DAILY", proc_name="P_LOAD_CUSTOMER", full_name="ETL_DAILY.P_LOAD_CUSTOMER"),
        ProcedureInfo(schema="ETL_DAILY", proc_name="P_LOAD_ACCOUNT", full_name="ETL_DAILY.P_LOAD_ACCOUNT"),
        ProcedureInfo(schema="OPS", proc_name="P_REBUILD_CUSTOMER", full_name="OPS.P_REBUILD_CUSTOMER"),
    ]
    parser._set_current_result(result)
    capture = parser.capture_query_state()
    assert capture is not None
    snapshot = IndexSnapshot.build(capture, publication_revision=1)

    assert {item["full_name"] for item in snapshot.search_procedures("ETL_DAILY")} == {
        "ETL_DAILY.P_LOAD_CUSTOMER",
        "ETL_DAILY.P_LOAD_ACCOUNT",
    }
    assert {item["full_name"] for item in snapshot.search_procedures("LOAD")} == {
        "ETL_DAILY.P_LOAD_CUSTOMER",
        "ETL_DAILY.P_LOAD_ACCOUNT",
    }
    assert [item["full_name"] for item in snapshot.search_procedures("LOAD_CUSTOMER")] == [
        "ETL_DAILY.P_LOAD_CUSTOMER"
    ]
    assert snapshot.search_procedures("OAD") == []
    assert snapshot.search_procedures("  ") == []

    limited = snapshot.search_procedures("ETL_DAILY", limit=1)
    assert len(limited) == 1
    assert limited[0]["full_name"] in {
        "ETL_DAILY.P_LOAD_CUSTOMER",
        "ETL_DAILY.P_LOAD_ACCOUNT",
    }


def test_zero_edge_snapshot_is_complete_and_queryable(parser: ParserService):
    snapshot = _snapshot(parser, with_edges=False)

    assert snapshot.is_ready
    assert snapshot.adjacency_up == {}
    assert snapshot.adjacency_down == {}
    assert snapshot.trace_tables("DWH.RESULT_1", max_depth=3, direction="up") == (
        {"DWH.RESULT_1"},
        [],
    )


def test_snapshot_does_not_share_input_or_returned_mutable_collections(parser: ParserService):
    result = _result(1)
    parser._set_current_result(result)
    capture = parser.capture_query_state()
    assert capture is not None
    snapshot = IndexSnapshot.build(capture, publication_revision=1)

    result.tables[1].table_name = "MUTATED"
    result.field_mappings[0].source_table = "MUTATED.SOURCE"

    data = snapshot.get_source_data()
    data["tables"][1]["table_name"] = "RETURN_VALUE_MUTATED"
    search_results = snapshot.search_tables("RESULT_1")
    search_results[0]["table_name"] = "RETURN_VALUE_MUTATED"
    mappings = snapshot.query_index.get_field_mappings_by_target("DWH.RESULT_1", "ID")
    mappings[0]["source_table"] = "RETURN_VALUE_MUTATED"
    nodes, edges = snapshot.trace_tables("RESULT_1", max_depth=2, direction="up")
    nodes.clear()
    edges.clear()

    assert snapshot.get_source_data()["tables"][1]["table_name"] == "RESULT_1"
    assert snapshot.search_tables("RESULT_1")[0]["table_name"] == "RESULT_1"
    assert snapshot.query_index.get_field_mappings_by_target("DWH.RESULT_1", "ID")[0][
        "source_table"
    ] == "SRC.GEN_1"
    assert snapshot.trace_tables("RESULT_1", max_depth=2, direction="up")[0] == {
        "DWH.RESULT_1",
        "SRC.GEN_1",
    }


@pytest.mark.parametrize(
    ("keyword", "limit"),
    [
        ("RESULT_1", 50),
        ("RESULT", 50),
        ("DWH.RESULT_1", 50),
        ("RESULT", 1),
        ("NO_MATCH", 50),
    ],
)
def test_snapshot_search_preserves_legacy_order_and_limit(
    parser: ParserService,
    keyword: str,
    limit: int,
):
    snapshot = _snapshot(parser)
    legacy_data = parser.get_current_data()
    assert legacy_data is not None

    assert snapshot.search_tables(keyword, limit) == search_table_dicts(
        legacy_data["tables"], keyword, limit
    )


def test_parser_capture_never_pairs_generation_with_other_generation_data(parser: ParserService):
    parser._set_current_result(_result(1))
    start = threading.Barrier(2)

    def publish_generations() -> None:
        start.wait()
        for version in range(2, 80):
            parser._set_current_result(_result(version))

    writer = threading.Thread(target=publish_generations)
    writer.start()
    start.wait()

    captures = [parser.capture_query_state() for _ in range(200)]
    writer.join()

    for capture in captures:
        assert capture is not None
        table_names = {table["full_name"] for table in capture.get_source_data()["tables"]}
        assert f"SRC.GEN_{capture.generation}" in table_names
        assert f"DWH.RESULT_{capture.generation}" in table_names
        chains = capture.field_tracing.trace_field_upstream(
            f"DWH.RESULT_{capture.generation}",
            "ID",
            2,
        )
        assert {node.table_name for chain in chains for node in chain.chain} == {
            f"DWH.RESULT_{capture.generation}",
            f"SRC.GEN_{capture.generation}",
        }


def test_old_field_tracing_view_remains_bound_after_parser_advances(parser: ParserService):
    current_result = _result(1)
    parser._set_current_result(current_result)
    old_capture = parser.capture_query_state()
    assert old_capture is not None

    # 模拟生产增量路径：原 ParseResult 原地 merge 后作为下一代重新发布。
    current_result.merge(_result(2))
    parser._set_current_result(current_result)
    new_capture = parser.capture_query_state()
    assert new_capture is not None

    old_chains = old_capture.field_tracing.trace_field_upstream("DWH.RESULT_1", "ID", 2)
    new_chains = new_capture.field_tracing.trace_field_upstream("DWH.RESULT_2", "ID", 2)

    assert old_capture.generation == 1
    assert new_capture.generation == 2
    assert {node.table_name for chain in old_chains for node in chain.chain} == {
        "DWH.RESULT_1",
        "SRC.GEN_1",
    }
    assert {node.table_name for chain in new_chains for node in chain.chain} == {
        "DWH.RESULT_2",
        "SRC.GEN_2",
    }


def test_snapshot_accepts_external_and_unresolved_mapping_endpoints(parser: ParserService):
    result = _result(1, with_edges=False)
    result.field_mappings = [
        FieldMapping(
            source_table="EXTERNAL.UNKNOWN_SOURCE",
            source_column="ID",
            target_table="DWH.RESULT_1",
            target_column="ID",
        )
    ]
    parser._set_current_result(result)
    capture = parser.capture_query_state()
    assert capture is not None

    snapshot = IndexSnapshot.build(capture, publication_revision=1)

    assert snapshot.is_ready
    assert snapshot.query_index.get_field_mappings_by_target("DWH.RESULT_1", "ID")[0][
        "source_table"
    ] == "EXTERNAL.UNKNOWN_SOURCE"


def test_snapshot_build_rejects_missing_parser_capture():
    with pytest.raises(ValueError, match="parser capture"):
        IndexSnapshot.build(None, publication_revision=1)
