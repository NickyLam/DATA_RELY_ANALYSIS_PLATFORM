"""
Tests for core/warehouse/ module.

Covers: SchemaResolver, TempTableFilter, DDLParser, DMLParser, CTLParser.
"""

from __future__ import annotations

from core.warehouse.schema_resolver import SCHEMA_LAYER_MAP, SchemaResolver
from core.warehouse.temp_table_filter import TempTableFilter

# ---------------------------------------------------------------------------
# SchemaResolver tests
# ---------------------------------------------------------------------------


class TestSchemaResolver:
    """Test ${xxx_schema} variable resolution."""

    def setup_method(self):
        self.resolver = SchemaResolver()

    def test_resolve_single_variable(self):
        result = self.resolver.resolve_table_name("${icl_schema}.cmm_abmt_remit_dtl")
        assert result is not None
        assert result.schema == "ICL"
        assert result.table_name == "CMM_ABMT_REMIT_DTL"
        assert result.full_name == "ICL.CMM_ABMT_REMIT_DTL"
        assert result.layer == "ICL"

    def test_resolve_all_known_schemas(self):
        """All 9 known schema variables should resolve correctly."""
        for var_name, expected_schema in SCHEMA_LAYER_MAP.items():
            raw = f"${{{var_name}}}.test_table"
            result = self.resolver.resolve_table_name(raw)
            assert result is not None, f"Failed to resolve {raw}"
            assert result.schema == expected_schema
            assert result.table_name == "TEST_TABLE"

    def test_resolve_plain_schema_prefix(self):
        """Already-resolved schema.table should also parse."""
        result = self.resolver.resolve_table_name("ICL.some_table")
        assert result is not None
        assert result.schema == "ICL"
        assert result.table_name == "SOME_TABLE"

    def test_resolve_bare_table_name(self):
        """Table without schema should still resolve."""
        result = self.resolver.resolve_table_name("plain_table")
        assert result is not None
        assert result.table_name == "PLAIN_TABLE"

    def test_resolve_empty_returns_none(self):
        assert self.resolver.resolve_table_name("") is None
        assert self.resolver.resolve_table_name("   ") is None

    def test_custom_mapping_override(self):
        custom = SchemaResolver(custom_mapping={"icl_schema": "CUSTOM_ICL"})
        result = custom.resolve_table_name("${icl_schema}.my_table")
        assert result is not None
        assert result.schema == "CUSTOM_ICL"


# ---------------------------------------------------------------------------
# TempTableFilter tests
# ---------------------------------------------------------------------------


class TestTempTableFilter:
    """Test temporary table identification."""

    def setup_method(self):
        self.filter = TempTableFilter()

    def test_suffix_bk(self):
        assert self.filter.is_temp_table("cmm_abmt_remit_dtl_bk") is True

    def test_suffix_tm(self):
        assert self.filter.is_temp_table("ICL.some_table_tm") is True

    def test_suffix_op(self):
        assert self.filter.is_temp_table("some_table_op") is True

    def test_prefix_tmp(self):
        assert self.filter.is_temp_table("tmp_staging_data") is True

    def test_prefix_temp(self):
        assert self.filter.is_temp_table("temp_load_buffer") is True

    def test_pattern_date_suffix(self):
        assert self.filter.is_temp_table("orders_20240101") is True

    def test_pattern_etl_prefix(self):
        assert self.filter.is_temp_table("etl_transform_step") is True

    def test_pattern_stg_prefix(self):
        assert self.filter.is_temp_table("stg_raw_data") is True

    def test_preserve_normal_table(self):
        assert self.filter.is_temp_table("cmm_abmt_remit_dtl") is False
        assert self.filter.is_temp_table("ICL.acct_balance") is False

    def test_exchange_table_detection(self):
        assert self.filter.is_exchange_table("cmm_abmt_remit_dtl_ex") is True
        assert self.filter.is_exchange_table("cmm_abmt_remit_dtl_ex01") is True
        assert self.filter.is_exchange_table("cmm_abmt_remit_dtl") is False

    def test_resolve_exchange_table(self):
        result = self.filter.resolve_exchange_table("ICL.cmm_abmt_remit_dtl_ex")
        assert result == "ICL.cmm_abmt_remit_dtl"

    def test_empty_input(self):
        assert self.filter.is_temp_table("") is False
        assert self.filter.is_exchange_table("") is False
