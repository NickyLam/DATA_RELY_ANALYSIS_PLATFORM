from __future__ import annotations

from pathlib import Path

import pytest

from app.config import _load_datasource_configs_from_manifest
from app.services.parser_service import ParseResult
from app.services.table_query_service import TableQueryService
from core.models import FieldMapping, TableInfo
from core.parser_protocol import ParseOutput


class _Parser:
    def __init__(self, data: dict):
        self._data = data

    def get_current_data(self) -> dict:
        return self._data


class _Cache:
    size = 0

    def search_by_keyword(self, *args, **kwargs):
        return []


def test_manifest_loader_prefers_child_manifest_parser(tmp_path: Path):
    source_data = tmp_path / "SOURCE_DATA"
    fdm = source_data / "FDM"
    fdm.mkdir(parents=True)
    (source_data / "manifest.yml").write_text(
        """
version: "1.0"
sources:
  - name: fdm
    display_name: "财务数据集市"
    path: FDM
    enabled: true
    parser: warehouse
    file_extensions: [".sql", ".xlsx", ".proc"]
""",
        encoding="utf-8",
    )
    (fdm / "manifest.yml").write_text(
        """
version: "1.0"
system: fdm
parser: indicator
file_extensions:
  config: [".xlsx"]
  dml: [".proc"]
schemas:
  - name: fdm_indicator
""",
        encoding="utf-8",
    )

    configs = _load_datasource_configs_from_manifest(source_data)

    fdm_config = next(c for c in configs if c.name == "fdm")
    assert fdm_config.parser == "indicator"
    assert fdm_config.file_extensions == [".xlsx", ".proc"]


def test_system_table_counts_prefer_data_source_over_schema():
    parser = _Parser(
        {
            "tables": [
                {
                    "full_name": "IDL.EDW_TABLE",
                    "table_name": "EDW_TABLE",
                    "data_source": "edw",
                    "columns": [{"name": "ID"}],
                },
                {
                    "full_name": "IDL.MCS_TABLE",
                    "table_name": "MCS_TABLE",
                    "data_source": "mcs",
                    "columns": [{"name": "ID"}],
                },
                {
                    "full_name": "RRP_MDL.RRP_TABLE",
                    "table_name": "RRP_TABLE",
                    "data_source": "rrp",
                    "columns": [{"name": "ID"}],
                },
            ],
            "procedures": [],
            "table_lineages": [],
            "field_mappings": [],
            "caliber_infos": [],
        }
    )
    service = TableQueryService(parser, _Cache())

    systems = {item["name"]: item for item in service.get_systems()}

    assert systems["rrp"]["table_count"] == 1
    assert systems["edw"]["table_count"] == 1
    assert systems["mcs"]["table_count"] == 1
    assert service.get_tables_by_system("edw") == [
        {
            "full_name": "IDL.EDW_TABLE",
            "short_name": "EDW_TABLE",
            "layer": "idl",
            "field_count": 1,
        }
    ]


def test_system_table_counts_infer_system_from_schema_prefix_without_data_source():
    parser = _Parser(
        {
            "tables": [
                {
                    "full_name": "RRP_EAST.EAST5_1002_JRGJXXB",
                    "table_name": "EAST5_1002_JRGJXXB",
                    "columns": [{"name": "ID"}],
                },
                {
                    "full_name": "EDW_ICL.DW_ICL_ACCT",
                    "table_name": "DW_ICL_ACCT",
                    "columns": [{"name": "ACCT_NO"}],
                },
                {
                    "full_name": "MCS_IDL.DM_IDL_RPT",
                    "table_name": "DM_IDL_RPT",
                    "columns": [{"name": "RPT_ID"}],
                },
            ],
            "procedures": [],
            "table_lineages": [],
            "field_mappings": [],
            "caliber_infos": [],
        }
    )
    service = TableQueryService(parser, _Cache())

    systems = {item["name"]: item for item in service.get_systems()}

    assert systems["rrp"]["table_count"] == 1
    assert systems["edw"]["table_count"] == 1
    assert systems["mcs"]["table_count"] == 1
    assert [t["full_name"] for t in service.get_tables_by_system("rrp")] == [
        "RRP_EAST.EAST5_1002_JRGJXXB"
    ]


def test_parse_result_merge_keeps_same_mapping_from_different_procedures():
    result = ParseResult()
    first = ParseResult()
    first.field_mappings = [
        FieldMapping(
            source_table="SRC",
            source_column="ID",
            target_table="TGT",
            target_column="ID",
            procedure="PROC_A",
        )
    ]
    second = ParseResult()
    second.field_mappings = [
        FieldMapping(
            source_table="SRC",
            source_column="ID",
            target_table="TGT",
            target_column="ID",
            procedure="PROC_B",
        )
    ]

    result.merge(first)
    result.merge(second)

    assert [fm.procedure for fm in result.field_mappings] == ["PROC_A", "PROC_B"]


def test_parse_result_merge_keeps_caliber_infos_with_nested_source_location():
    result = ParseResult()
    first = ParseResult()
    first.caliber_infos = [
        {
            "target_table": "TGT",
            "target_column": "ID",
            "source_location": {"source_table": "SRC_A", "source_column": "ID"},
            "procedure": "PROC_A",
            "step_num": 0,
        }
    ]
    second = ParseResult()
    second.caliber_infos = [
        {
            "target_table": "TGT",
            "target_column": "ID",
            "source_location": {"source_table": "SRC_B", "source_column": "ID"},
            "procedure": "PROC_A",
            "step_num": 0,
        }
    ]

    result.merge(first)
    result.merge(second)

    assert len(result.caliber_infos) == 2


def test_table_info_preserves_data_source_round_trip():
    table = TableInfo(
        schema="IDL",
        table_name="EDW_TABLE",
        full_name="IDL.EDW_TABLE",
        data_source="edw",
    )

    assert TableInfo.from_dict(table.to_dict()).data_source == "edw"


def test_parse_output_data_source_survives_merge(tmp_path: Path):
    from app.services.parser_service import ParserService

    parser = ParserService(
        data_dir=str(tmp_path / "data"),
        schema_dirs=[],
        output_dir=str(tmp_path / "output"),
    )
    result = ParseResult()
    output = ParseOutput(
        tables=[
            {
                "full_name": "IDL.EDW_TABLE",
                "schema": "IDL",
                "table_name": "EDW_TABLE",
                "columns": [],
            }
        ],
        table_lineages=[
            {
                "source_table": "IML.SRC",
                "target_table": "IDL.EDW_TABLE",
                "procedure": "PROC_A",
            }
        ],
        field_mappings=[
            {
                "source_table": "IML.SRC",
                "source_column": "ID",
                "target_table": "IDL.EDW_TABLE",
                "target_column": "ID",
                "procedure": "PROC_A",
            }
        ],
    )

    try:
        parser._tag_output_data_source(output, "edw")
        parser._merge_output_to_result(output, result)
    finally:
        parser.shutdown()

    assert result.tables[0].to_dict()["data_source"] == "edw"
    assert result.table_lineages[0].to_dict()["data_source"] == "edw"
    assert result.field_mappings[0].to_dict()["data_source"] == "edw"


def test_sqlite_store_preserves_caliber_infos_with_nested_source_location(tmp_path: Path):
    from app.services.storage.sqlite_store import SQLiteResultStore

    store = SQLiteResultStore(tmp_path / "lineage.db")
    store.save(
        {
            "metadata": {"total_tables": 1},
            "tables": [{"full_name": "TGT", "table_name": "TGT"}],
            "procedures": [],
            "table_lineages": [],
            "field_mappings": [],
            "caliber_infos": [
                {
                    "target_table": "TGT",
                    "target_column": "ID",
                    "source_location": {"source_table": "SRC_A", "source_column": "ID"},
                    "procedure": "PROC_A",
                    "step_num": 0,
                },
                {
                    "target_table": "TGT",
                    "target_column": "ID",
                    "source_location": {"source_table": "SRC_B", "source_column": "ID"},
                    "procedure": "PROC_A",
                    "step_num": 0,
                },
            ],
        }
    )

    loaded = store.load()

    assert loaded is not None
    assert len(loaded["caliber_infos"]) == 2
