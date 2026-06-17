"""Warehouse lineage tracer regressions."""

from __future__ import annotations

from core.lineage_tracer import LineageTracer
from core.models import ColumnInfo, FieldMapping, TableInfo


def _table(full_name: str, column: str) -> TableInfo:
    schema, table_name = full_name.split(".", 1)
    return TableInfo(
        schema=schema,
        table_name=table_name,
        full_name=full_name,
        columns=[ColumnInfo(name=column, data_type="VARCHAR2(60)")],
    )


def test_upstream_keeps_cross_layer_table_with_same_bare_name():
    """EDW layers often reuse the same table name across schemas: ITL.T -> IOL.T."""
    tables = {
        name: _table(name, "CUST_ID")
        for name in [
            "ITL.CUSTOMER",
            "IOL.CUSTOMER",
            "IML.CUSTOMER_MASTER",
            "ICL.CUSTOMER_BASIC",
        ]
    }
    mappings = [
        FieldMapping(
            source_table="ITL.CUSTOMER",
            source_column="CUST_ID",
            target_table="IOL.CUSTOMER",
            target_column="CUST_ID",
            procedure="IOL_CUSTOMER",
        ),
        FieldMapping(
            source_table="IOL.CUSTOMER",
            source_column="CUST_ID",
            target_table="IML.CUSTOMER_MASTER",
            target_column="CUST_ID",
            procedure="IML_CUSTOMER_MASTER",
        ),
        FieldMapping(
            source_table="IML.CUSTOMER_MASTER",
            source_column="CUST_ID",
            target_table="ICL.CUSTOMER_BASIC",
            target_column="CUST_ID",
            procedure="ICL_CUSTOMER_BASIC",
        ),
    ]

    tracer = LineageTracer(tables, {}, [], mappings, max_depth=5)
    chains = tracer.trace_field_upstream("ICL.CUSTOMER_BASIC", "CUST_ID", max_depth=5)

    paths = [
        [(node.table_name, node.field_name) for node in chain.chain]
        for chain in chains
    ]
    assert [
        ("ITL.CUSTOMER", "CUST_ID"),
        ("IOL.CUSTOMER", "CUST_ID"),
        ("IML.CUSTOMER_MASTER", "CUST_ID"),
        ("ICL.CUSTOMER_BASIC", "CUST_ID"),
    ] in paths
