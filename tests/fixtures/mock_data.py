"""
Reusable mock data factories for tests.

Provides consistent sample data across test suites so individual test files
don't need to duplicate fixture definitions.
"""

from __future__ import annotations

from core.models import (
    ColumnInfo,
    FieldMapping,
    ProcedureInfo,
    TableInfo,
    TableLineage,
)


def create_mock_tables() -> dict[str, TableInfo]:
    """Create a minimal set of tables spanning ODS -> MDL -> EAST layers."""
    _tables = [
        TableInfo(
            schema="RRP_ODS",
            table_name="SRC_TBL",
            full_name="RRP_ODS.SRC_TBL",
            columns=[
                ColumnInfo(name="SRC_COL", data_type="VARCHAR2(10)", comment="source field"),
                ColumnInfo(name="SRC_ID", data_type="NUMBER(10)", comment="PK"),
            ],
        ),
        TableInfo(
            schema="RRP_MDL",
            table_name="MID_TBL",
            full_name="RRP_MDL.MID_TBL",
            columns=[
                ColumnInfo(name="MID_COL", data_type="VARCHAR2(10)"),
                ColumnInfo(name="MID_ID", data_type="NUMBER(10)"),
            ],
        ),
        TableInfo(
            schema="RRP_EAST",
            table_name="TGT_TBL",
            full_name="RRP_EAST.TGT_TBL",
            columns=[
                ColumnInfo(name="TGT_COL", data_type="VARCHAR2(10)"),
                ColumnInfo(name="TGT_ID", data_type="NUMBER(10)"),
            ],
        ),
    ]
    result: dict[str, TableInfo] = {}
    for t in _tables:
        result[t.full_name] = t
        result[t.table_name] = t
    return result


def create_mock_procedures() -> dict[str, ProcedureInfo]:
    """Create mock procedures."""
    proc = ProcedureInfo(
        schema="RRP_PROC",
        proc_name="P_DEMO",
        full_name="RRP_PROC.P_DEMO",
        source_tables=["RRP_ODS.SRC_TBL", "RRP_MDL.MID_TBL"],
        target_tables=["RRP_MDL.MID_TBL", "RRP_EAST.TGT_TBL"],
    )
    return {"RRP_PROC.P_DEMO": proc}


def create_mock_table_lineages() -> list[TableLineage]:
    """Create table-level lineage edges."""
    return [
        TableLineage(
            source_table="RRP_ODS.SRC_TBL",
            target_table="RRP_MDL.MID_TBL",
            procedure="RRP_PROC.P_DEMO",
        ),
        TableLineage(
            source_table="RRP_MDL.MID_TBL",
            target_table="RRP_EAST.TGT_TBL",
            procedure="RRP_PROC.P_DEMO",
        ),
    ]


def create_mock_field_mappings() -> list[FieldMapping]:
    """Create field-level lineage mappings."""
    return [
        FieldMapping(
            source_table="RRP_ODS.SRC_TBL",
            source_column="SRC_COL",
            target_table="RRP_MDL.MID_TBL",
            target_column="MID_COL",
            transform_logic="NVL(SRC_COL, 0)",
            procedure="RRP_PROC.P_DEMO",
        ),
        FieldMapping(
            source_table="RRP_MDL.MID_TBL",
            source_column="MID_COL",
            target_table="RRP_EAST.TGT_TBL",
            target_column="TGT_COL",
            transform_logic="",
            procedure="RRP_PROC.P_DEMO",
        ),
    ]


def create_mock_caliber_infos() -> list[dict]:
    """Create caliber (transform metadata) info dicts."""
    return [
        {
            "target_table": "RRP_MDL.MID_TBL",
            "target_column": "MID_COL",
            "source_table": "RRP_ODS.SRC_TBL",
            "source_column": "SRC_COL",
            "transform_logic": "NVL(SRC_COL, 0)",
            "procedure": "RRP_PROC.P_DEMO",
            "data_source": "oracle",
            "join_conditions": [],
            "confidence": 1.0,
        },
    ]


def create_mock_data_repository() -> dict:
    """
    Create a complete mock data repository dict suitable for
    patching ParserService.get_current_data().

    Returns the same shape as the real parsed data output.
    """
    tables = create_mock_tables()
    table_list = []
    seen: set[str] = set()
    for t in tables.values():
        if t.full_name not in seen:
            seen.add(t.full_name)
            table_list.append(
                {
                    "table_name": t.table_name,
                    "full_name": t.full_name,
                    "schema": t.schema,
                    "columns": [{"name": c.name, "data_type": c.data_type, "comment": c.comment} for c in t.columns],
                }
            )

    procedures = create_mock_procedures()
    proc_list = []
    for p in procedures.values():
        proc_list.append(
            {
                "full_name": p.full_name,
                "schema": p.schema,
                "proc_name": p.proc_name,
                "source_tables": p.source_tables,
                "target_tables": p.target_tables,
            }
        )

    return {
        "tables": table_list,
        "procedures": proc_list,
        "field_mappings": [fm.__dict__ if hasattr(fm, "__dict__") else fm for fm in create_mock_field_mappings()],
        "table_lineages": [tl.__dict__ if hasattr(tl, "__dict__") else tl for tl in create_mock_table_lineages()],
        "caliber_infos": create_mock_caliber_infos(),
        "metadata": {
            "total_tables": 3,
            "total_procedures": 1,
        },
    }
