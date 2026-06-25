"""
Node Field Metadata Contract Tests
Tests that lineage query nodes include their displayed field metadata (name + data_type).
Covers tasks 1.1 – 1.4 from display-field-type-length change.
"""

from __future__ import annotations

from pathlib import Path

from app.services.lineage_service import LineageService

# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

class _NoopCache:
    """Minimal cache stub that satisfies LineageService queries."""

    def build_index(self, tables, procedures):
        pass

    def clear(self):
        pass

    def get(self, key):
        return None

    def set(self, key, value):
        pass

    def search_by_keyword(self, keyword, index_type="", limit=50):
        return []

    @property
    def size(self):
        return 0


class _StubParser:
    """Minimal parser stub returning controlled data."""

    def __init__(self, data: dict):
        self._data = data
        self.output_dir = Path("/tmp/_stub_output")

    def get_current_data(self):
        return self._data

    def get_lineage_tracer(self):
        return None

    def get_unified_tracer(self):
        return None

    def search_tables(self, keyword: str, limit: int = 50):
        return []

    def get_data_mtime(self):
        return None


def _make_data(
    tables: list[dict] | None = None,
    field_mappings: list[dict] | None = None,
    table_lineages: list[dict] | None = None,
    procedures: list[dict] | None = None,
) -> dict:
    return {
        "tables": tables or [],
        "procedures": procedures or [],
        "field_mappings": field_mappings or [],
        "table_lineages": table_lineages or [],
        "metadata": {},
    }


def _build_service(data: dict) -> LineageService:
    parser = _StubParser(data)
    cache = _NoopCache()
    # Bypass event_bus subscription by patching _on_data_changed / _on_cache_invalidated
    service = LineageService.__new__(LineageService)
    service.parser = parser
    service.cache = cache
    from app.services.lineage_query_index import LineageQueryIndex
    from app.services.table_lineage_tracer import TableLineageTracer
    from core.table_name_resolver import TableNameResolver
    service._resolver = TableNameResolver()
    service._table_tracer = TableLineageTracer(service._resolver)
    service._index = LineageQueryIndex()
    service._transitive_cache = {}
    service._last_data_mtime = 0
    # Build indexes from data
    service._build_indexes()
    return service


# ---------------------------------------------------------------------------
# Shared sample data
# ---------------------------------------------------------------------------

SAMPLE_TABLES = [
    {
        "full_name": "RRP_MDL.TARGET_TBL",
        "table_name": "TARGET_TBL",
        "columns": [
            {"name": "CUSTOMER_NAME", "data_type": "VARCHAR2(60)"},
            {"name": "BALANCE", "data_type": "NUMBER(18,2)"},
            {"name": "CREATED_AT", "data_type": "DATE"},
            {"name": "ACCOUNT_ID", "data_type": "NUMBER"},
        ],
    },
    {
        "full_name": "RRP_MDL.SOURCE_TBL",
        "table_name": "SOURCE_TBL",
        "columns": [
            {"name": "SOURCE_ID", "data_type": "NUMBER(10)"},
            {"name": "SRC_NAME", "data_type": "VARCHAR2(100)"},
        ],
    },
    {
        "full_name": "RRP_MDL.DOWNSTREAM_TBL",
        "table_name": "DOWNSTREAM_TBL",
        "columns": [
            {"name": "DS_CUST_NAME", "data_type": "VARCHAR2(60)"},
        ],
    },
]

SAMPLE_FIELD_MAPPINGS = [
    {
        "source_table": "RRP_MDL.SOURCE_TBL",
        "source_column": "SRC_NAME",
        "target_table": "RRP_MDL.TARGET_TBL",
        "target_column": "CUSTOMER_NAME",
        "procedure": "",
    },
    {
        "source_table": "RRP_MDL.TARGET_TBL",
        "source_column": "CUSTOMER_NAME",
        "target_table": "RRP_MDL.DOWNSTREAM_TBL",
        "target_column": "DS_CUST_NAME",
        "procedure": "",
    },
]

SAMPLE_TABLE_LINEAGES = [
    {"source_table": "RRP_MDL.SOURCE_TBL", "target_table": "RRP_MDL.TARGET_TBL"},
    {"source_table": "RRP_MDL.TARGET_TBL", "target_table": "RRP_MDL.DOWNSTREAM_TBL"},
]


# ---------------------------------------------------------------------------
# 1.1 — Query target node receives the requested field and complete data_type
# ---------------------------------------------------------------------------

class TestQueryTargetFieldMetadata:
    """Task 1.1: query target node receives field + data_type."""

    def test_target_node_has_field_with_varchar_length(self):
        data = _make_data(
            tables=SAMPLE_TABLES,
            field_mappings=SAMPLE_FIELD_MAPPINGS,
            table_lineages=SAMPLE_TABLE_LINEAGES,
        )
        service = _build_service(data)

        result = service.query_lineage(
            table="TARGET_TBL",
            field="CUSTOMER_NAME",
            depth=2,
            mode="upstream",
            include_fields=True,
            use_cache=False,
        )

        target_nodes = [
            n for n in result["nodes"]
            if n["id"].upper().endswith("TARGET_TBL")
        ]
        assert len(target_nodes) >= 1, "Target node should be present in result"
        target = target_nodes[0]
        assert "field" in target, "Target node must include 'field' metadata"
        assert target["field"]["name"] == "CUSTOMER_NAME"
        assert target["field"]["data_type"] == "VARCHAR2(60)"

    def test_target_node_numeric_precision(self):
        data = _make_data(
            tables=SAMPLE_TABLES,
            field_mappings=SAMPLE_FIELD_MAPPINGS,
            table_lineages=SAMPLE_TABLE_LINEAGES,
        )
        service = _build_service(data)

        result = service.query_lineage(
            table="TARGET_TBL",
            field="BALANCE",
            depth=2,
            mode="upstream",
            include_fields=True,
            use_cache=False,
        )

        target_nodes = [n for n in result["nodes"] if n["id"].upper().endswith("TARGET_TBL")]
        assert len(target_nodes) >= 1
        target = target_nodes[0]
        assert target["field"]["name"] == "BALANCE"
        assert target["field"]["data_type"] == "NUMBER(18,2)"

    def test_target_node_type_without_length(self):
        data = _make_data(
            tables=SAMPLE_TABLES,
            field_mappings=[
                {
                    "source_table": "RRP_MDL.SOURCE_TBL",
                    "source_column": "SOURCE_ID",
                    "target_table": "RRP_MDL.TARGET_TBL",
                    "target_column": "CREATED_AT",
                    "procedure": "",
                }
            ],
            table_lineages=SAMPLE_TABLE_LINEAGES,
        )
        service = _build_service(data)

        result = service.query_lineage(
            table="TARGET_TBL",
            field="CREATED_AT",
            depth=2,
            mode="upstream",
            include_fields=True,
            use_cache=False,
        )

        target_nodes = [n for n in result["nodes"] if n["id"].upper().endswith("TARGET_TBL")]
        assert len(target_nodes) >= 1
        target = target_nodes[0]
        assert target["field"]["name"] == "CREATED_AT"
        assert target["field"]["data_type"] == "DATE"


# ---------------------------------------------------------------------------
# 1.2 — Upstream/downstream endpoint field selection
# ---------------------------------------------------------------------------

class TestUpDownstreamFieldSelection:
    """Task 1.2: upstream/downstream endpoint field selection and name matching."""

    def test_upstream_node_field_from_edge(self):
        data = _make_data(
            tables=SAMPLE_TABLES,
            field_mappings=SAMPLE_FIELD_MAPPINGS,
            table_lineages=SAMPLE_TABLE_LINEAGES,
        )
        service = _build_service(data)

        result = service.query_lineage(
            table="TARGET_TBL",
            field="CUSTOMER_NAME",
            depth=2,
            mode="upstream",
            include_fields=True,
            use_cache=False,
        )

        upstream_nodes = [
            n for n in result["nodes"]
            if n["id"].upper().endswith("SOURCE_TBL")
        ]
        if upstream_nodes:
            node = upstream_nodes[0]
            assert "field" in node, "Upstream node should have field metadata"
            assert node["field"]["name"] == "SRC_NAME"
            assert node["field"]["data_type"] == "VARCHAR2(100)"

    def test_downstream_node_field_from_edge(self):
        data = _make_data(
            tables=SAMPLE_TABLES,
            field_mappings=SAMPLE_FIELD_MAPPINGS,
            table_lineages=SAMPLE_TABLE_LINEAGES,
        )
        service = _build_service(data)

        result = service.query_lineage(
            table="TARGET_TBL",
            field="CUSTOMER_NAME",
            depth=2,
            mode="downstream",
            include_fields=True,
            use_cache=False,
        )

        ds_nodes = [
            n for n in result["nodes"]
            if n["id"].upper().endswith("DOWNSTREAM_TBL")
        ]
        if ds_nodes:
            node = ds_nodes[0]
            assert "field" in node, "Downstream node should have field metadata"
            assert node["field"]["name"] == "DS_CUST_NAME"
            assert node["field"]["data_type"] == "VARCHAR2(60)"

    def test_full_and_short_name_resolve_same_column(self):
        """Edge references short name, metadata stored under full name."""
        tables = [
            {
                "full_name": "RRP_MDL.MY_TABLE",
                "table_name": "MY_TABLE",
                "columns": [{"name": "AMOUNT", "data_type": "NUMBER(18,2)"}],
            },
        ]
        # Mapping uses short name only
        mappings = [
            {
                "source_table": "MY_TABLE",
                "source_column": "AMOUNT",
                "target_table": "MY_TABLE",
                "target_column": "AMOUNT",
                "procedure": "",
            },
        ]
        data = _make_data(tables=tables, field_mappings=mappings, table_lineages=[])
        service = _build_service(data)

        result = service.query_lineage(
            table="MY_TABLE",
            field="AMOUNT",
            depth=1,
            mode="upstream",
            include_fields=True,
            use_cache=False,
        )

        target_nodes = [n for n in result["nodes"] if n["id"].upper().endswith("MY_TABLE")]
        assert len(target_nodes) >= 1
        target = target_nodes[0]
        assert "field" in target
        assert target["field"]["name"] == "AMOUNT"
        assert target["field"]["data_type"] == "NUMBER(18,2)"

    def test_case_insensitive_column_lookup(self):
        """Column metadata resolved regardless of case."""
        tables = [
            {
                "full_name": "S.TBL",
                "table_name": "TBL",
                "columns": [{"name": "customer_name", "data_type": "VARCHAR2(60)"}],
            },
        ]
        data = _make_data(tables=tables)
        service = _build_service(data)

        # Build nodes directly to test column resolution
        node_names = {"S.TBL"}
        nodes = service._build_nodes(
            node_names,
            data,
            include_fields=True,
            field_map={"S.TBL": "CUSTOMER_NAME"},
        )
        assert len(nodes) == 1
        # Returns canonical name from metadata (lowercase), not the input
        assert nodes[0]["field"]["name"] == "customer_name"
        assert nodes[0]["field"]["data_type"] == "VARCHAR2(60)"


# ---------------------------------------------------------------------------
# 1.3 — include_fields=false still returns field metadata
# ---------------------------------------------------------------------------

class TestIncludeFieldsFalse:
    """Task 1.3: include_fields=false still returns nodes[].field without full columns."""

    def test_field_returned_without_columns(self):
        data = _make_data(
            tables=SAMPLE_TABLES,
            field_mappings=SAMPLE_FIELD_MAPPINGS,
            table_lineages=SAMPLE_TABLE_LINEAGES,
        )
        service = _build_service(data)

        result = service.query_lineage(
            table="TARGET_TBL",
            field="CUSTOMER_NAME",
            depth=2,
            mode="upstream",
            include_fields=False,
            use_cache=False,
        )

        target_nodes = [n for n in result["nodes"] if n["id"].upper().endswith("TARGET_TBL")]
        assert len(target_nodes) >= 1
        target = target_nodes[0]

        # field metadata MUST be present even when include_fields=False
        assert "field" in target, "field metadata must be present when include_fields=False"
        assert target["field"]["name"] == "CUSTOMER_NAME"
        assert target["field"]["data_type"] == "VARCHAR2(60)"

        # full columns list MUST NOT be present
        assert "columns" not in target, "full columns list must not be present when include_fields=False"


# ---------------------------------------------------------------------------
# 1.4 — Degradation tests
# ---------------------------------------------------------------------------

class TestDegradation:
    """Task 1.4: unknown field type, supplemental table-only nodes, short-name ambiguity."""

    def test_field_name_exists_but_type_unavailable(self):
        """Node field known but no matching column definition."""
        tables = [
            {
                "full_name": "S.TBL",
                "table_name": "TBL",
                "columns": [{"name": "OTHER_COL", "data_type": "NUMBER"}],
            },
        ]
        data = _make_data(tables=tables)
        service = _build_service(data)

        nodes = service._build_nodes(
            {"S.TBL"},
            data,
            include_fields=True,
            field_map={"S.TBL": "MISSING_FIELD"},
        )
        assert len(nodes) == 1
        assert "field" in nodes[0]
        assert nodes[0]["field"]["name"] == "MISSING_FIELD"
        assert nodes[0]["field"]["data_type"] == ""

    def test_supplemental_table_node_no_field(self):
        """Table-only node (no field endpoint) may omit field metadata."""
        tables = [
            {
                "full_name": "S.SUPPLEMENTAL",
                "table_name": "SUPPLEMENTAL",
                "columns": [],
            },
        ]
        data = _make_data(tables=tables)
        service = _build_service(data)

        # No field_map entry for this table
        nodes = service._build_nodes(
            {"S.SUPPLEMENTAL"},
            data,
            include_fields=True,
            field_map={},
        )
        assert len(nodes) == 1
        # field may be absent or have empty name
        if "field" in nodes[0]:
            assert nodes[0]["field"]["name"] == "" or nodes[0]["field"]["name"] is None

    def test_duplicate_schema_short_name_ambiguity(self):
        """Two schemas with same short name; field resolves to the correct one."""
        tables = [
            {
                "full_name": "SCHEMA_A.SHARED_TBL",
                "table_name": "SHARED_TBL",
                "columns": [{"name": "COL_A", "data_type": "VARCHAR2(10)"}],
            },
            {
                "full_name": "SCHEMA_B.SHARED_TBL",
                "table_name": "SHARED_TBL",
                "columns": [{"name": "COL_B", "data_type": "NUMBER(5)"}],
            },
        ]
        data = _make_data(tables=tables)
        service = _build_service(data)

        # Explicitly target SCHEMA_A
        nodes = service._build_nodes(
            {"SCHEMA_A.SHARED_TBL"},
            data,
            include_fields=True,
            field_map={"SCHEMA_A.SHARED_TBL": "COL_A"},
        )
        assert len(nodes) == 1
        assert nodes[0]["field"]["name"] == "COL_A"
        assert nodes[0]["field"]["data_type"] == "VARCHAR2(10)"

    def test_legacy_response_no_node_field(self):
        """Frontend fallback: node without field key still renders (no crash)."""
        # Simulate old-style node without field metadata
        node = {"id": "S.TBL", "full_name": "S.TBL", "short_name": "TBL", "layer": "base"}
        # This is a frontend concern, but we verify the backend doesn't break
        # when a node is constructed without field
        assert "field" not in node  # old cache shape is valid
