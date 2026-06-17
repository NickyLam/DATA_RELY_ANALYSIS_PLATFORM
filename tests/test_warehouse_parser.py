"""
Tests for core/warehouse/ module.

Covers: SchemaResolver, TempTableFilter, DDLParser, DMLParser, CTLParser.
"""

from __future__ import annotations

from pathlib import Path

from core.models import ColumnInfo, TableInfo
from core.warehouse.dml_parser import DMLParser
from core.warehouse.schema_resolver import SCHEMA_LAYER_MAP, SchemaResolver
from core.warehouse.temp_table_filter import TempTableFilter
from core.warehouse.warehouse_parser import WarehouseSQLParser

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

    def test_suffix_tmp(self):
        assert self.filter.is_temp_table("ICL.some_table_tmp") is True

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


# ---------------------------------------------------------------------------
# DMLParser regression tests
# ---------------------------------------------------------------------------


class TestDMLParser:
    """Test warehouse DML table and field lineage extraction."""

    def setup_method(self):
        self.parser = DMLParser(SchemaResolver(), TempTableFilter())

    def test_insert_select_uses_real_three_letter_schema_tables_and_ignores_comments(
        self,
        tmp_path: Path,
    ):
        dml_dir = tmp_path / "dml" / "icl"
        dml_dir.mkdir(parents=True)
        sql_file = dml_dir / "icl_cmm_indv_cust_basic_info.sql"
        sql_file.write_text(
            """
insert /*+ append */ into ${icl_schema}.cmm_indv_cust_basic_info_ex(
    etl_dt                                  --数据日期
    ,cust_id                                --客户编号
    ,loan_class_cust_flg                    --贷款类客户标志
)
select
    to_date('${batch_date}','yyyymmdd')     --数据日期
    ,t1.party_id                            --客户编号
    ,tb.aml_loan_flag                       --贷款类客户标志
from ${iml_schema}.pty_indv t1  --个人当事人
left join ${iol_schema}.eifs_t01_per_cust_info tb
  on t1.party_id = tb.party_id
where t1.indv_party_type_cd in ('1','5') --个人客户,对私担保客户
;

alter table ${icl_schema}.cmm_indv_cust_basic_info
  exchange partition p_${batch_date}
  with table ${icl_schema}.cmm_indv_cust_basic_info_ex;
""",
            encoding="utf-8",
        )

        output = self.parser.parse_file(sql_file)

        source_tables = {lineage["source_table"] for lineage in output.table_lineages}
        assert "IML.PTY_INDV" in source_tables
        assert "IOL.EIFS_T01_PER_CUST_INFO" in source_tables
        assert "对私担保客户" not in source_tables
        assert ("ICL.CMM_INDV_CUST_BASIC_INFO", "ICL.CMM_INDV_CUST_BASIC_INFO") not in {
            (lineage["source_table"], lineage["target_table"])
            for lineage in output.table_lineages
        }

        cust_id_mappings = [
            mapping
            for mapping in output.field_mappings
            if mapping["target_table"] == "ICL.CMM_INDV_CUST_BASIC_INFO"
            and mapping["target_column"] == "CUST_ID"
        ]
        assert cust_id_mappings == [
            {
                "source_table": "IML.PTY_INDV",
                "source_column": "PARTY_ID",
                "target_table": "ICL.CMM_INDV_CUST_BASIC_INFO",
                "target_column": "CUST_ID",
                "transform_logic": "",
                "procedure": "ICL_CMM_INDV_CUST_BASIC_INFO",
                "confidence": 0.95,
            }
        ]

    def test_subquery_select_columns_are_not_extracted_as_source_tables(
        self,
        tmp_path: Path,
    ):
        dml_dir = tmp_path / "dml" / "icl"
        dml_dir.mkdir(parents=True)
        sql_file = dml_dir / "icl_subquery_sources.sql"
        sql_file.write_text(
            """
insert into ${icl_schema}.target_table(
    cust_id
    ,nav
)
select
    t1.cust_id
    ,nvl(t2.nav, 1)
from ${iml_schema}.customer_lot_h t1
left join (
    select prod_id as prd_code,
           ta_cd as ta_code,
           prod_nv as nav,
           start_dt as cfm_date,
           issue_dt as iss_date,
           row_number() over(partition by prod_id, ta_cd order by start_dt desc) rn
      from ${iml_schema}.product_day_sell_h
) t2
  on t1.prod_id = t2.prd_code
;
""",
            encoding="utf-8",
        )

        output = self.parser.parse_file(sql_file)

        source_tables = {lineage["source_table"] for lineage in output.table_lineages}
        assert "IML.CUSTOMER_LOT_H" in source_tables
        assert "IML.PRODUCT_DAY_SELL_H" in source_tables
        assert "PROD_NV" not in source_tables
        assert "START_DT" not in source_tables
        assert "ISSUE_DT" not in source_tables

    def test_comma_join_tables_and_aliases_are_preserved(
        self,
        tmp_path: Path,
    ):
        dml_dir = tmp_path / "dml" / "icl"
        dml_dir.mkdir(parents=True)
        sql_file = dml_dir / "icl_comma_join.sql"
        sql_file.write_text(
            """
insert into ${icl_schema}.target_table(
    cust_id
    ,acct_id
)
select
    c.cust_id
    ,a.acct_id
from ${iml_schema}.customer c,
     ${iol_schema}.account a
where c.cust_id = a.cust_id
;
""",
            encoding="utf-8",
        )

        output = self.parser.parse_file(sql_file)

        source_tables = {lineage["source_table"] for lineage in output.table_lineages}
        assert "IML.CUSTOMER" in source_tables
        assert "IOL.ACCOUNT" in source_tables
        assert {
            "source_table": "IOL.ACCOUNT",
            "source_column": "ACCT_ID",
            "target_table": "ICL.TARGET_TABLE",
            "target_column": "ACCT_ID",
            "transform_logic": "",
            "procedure": "ICL_COMMA_JOIN",
            "confidence": 0.95,
        } in output.field_mappings

    def test_generated_temp_target_maps_to_existing_formal_table(
        self,
        tmp_path: Path,
    ):
        parser = DMLParser(
            SchemaResolver(),
            TempTableFilter(),
            {
                "IML.PTY_INDV": TableInfo(
                    schema="IML",
                    table_name="PTY_INDV",
                    full_name="IML.PTY_INDV",
                    columns=[
                        ColumnInfo(name="PARTY_ID", data_type="VARCHAR2(60)"),
                    ],
                )
            },
        )
        dml_dir = tmp_path / "dml" / "iml"
        dml_dir.mkdir(parents=True)
        sql_file = dml_dir / "iml_pty_indv_eifsf1.sql"
        sql_file.write_text(
            """
insert into ${iml_schema}.pty_indv_eifsf1_tm(
    party_id -- 当事人编号
)
select
    p1.party_id -- 当事人编号
from ${iol_schema}.eifs_person p1
;
""",
            encoding="utf-8",
        )

        output = parser.parse_file(sql_file)

        assert {
            "source_table": "IOL.EIFS_PERSON",
            "source_column": "PARTY_ID",
            "target_table": "IML.PTY_INDV",
            "target_column": "PARTY_ID",
            "transform_logic": "",
            "procedure": "IML_PTY_INDV_EIFSF1",
            "confidence": 0.95,
        } in output.field_mappings

    def test_insert_all_operational_targets_map_to_formal_table(
        self,
        tmp_path: Path,
    ):
        parser = DMLParser(
            SchemaResolver(),
            TempTableFilter(),
            {
                "IOL.EIFS_T00_PER_CUST_NO_REF": TableInfo(
                    schema="IOL",
                    table_name="EIFS_T00_PER_CUST_NO_REF",
                    full_name="IOL.EIFS_T00_PER_CUST_NO_REF",
                    columns=[
                        ColumnInfo(name="CUST_NUM", data_type="VARCHAR2(24)"),
                    ],
                )
            },
        )
        dml_dir = tmp_path / "dml" / "iol"
        dml_dir.mkdir(parents=True)
        sql_file = dml_dir / "iol_eifs_t00_per_cust_no_ref.sql"
        sql_file.write_text(
            """
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t00_per_cust_no_ref_cl(
            cust_num -- 客户编号
        )
    else
        into ${iol_schema}.eifs_t00_per_cust_no_ref_op(
            cust_num -- 客户编号
        )
select
    nvl(n.cust_num, o.cust_num) as cust_num -- 客户编号
from (select * from ${iol_schema}.eifs_t00_per_cust_no_ref_bk) o
    full join (
        select * from ${itl_schema}.eifs_t00_per_cust_no_ref
    ) n on o.cust_num = n.cust_num
;
""",
            encoding="utf-8",
        )

        output = parser.parse_file(sql_file)

        assert {
            "source_table": "ITL.EIFS_T00_PER_CUST_NO_REF",
            "source_column": "CUST_NUM",
            "target_table": "IOL.EIFS_T00_PER_CUST_NO_REF",
            "target_column": "CUST_NUM",
            "transform_logic": "",
            "procedure": "IOL_EIFS_T00_PER_CUST_NO_REF",
            "confidence": 0.95,
        } in output.field_mappings


# ---------------------------------------------------------------------------
# WarehouseSQLParser regression tests
# ---------------------------------------------------------------------------


class TestWarehouseSQLParser:
    """Test cross-file warehouse parse assembly."""

    def test_referenced_upstream_layer_table_inherits_known_column_metadata(
        self,
        tmp_path: Path,
    ):
        ddl_dir = tmp_path / "ddl" / "iol"
        dml_dir = tmp_path / "dml" / "iol"
        ddl_dir.mkdir(parents=True)
        dml_dir.mkdir(parents=True)
        (ddl_dir / "iol_eifs_t00_per_cust_no_ref.sql").write_text(
            """
create table ${iol_schema}.eifs_t00_per_cust_no_ref (
    party_id varchar2(60)
    ,cust_num varchar2(24)
);
""",
            encoding="utf-8",
        )
        (dml_dir / "iol_eifs_t00_per_cust_no_ref.sql").write_text(
            """
insert into ${iol_schema}.eifs_t00_per_cust_no_ref(
    cust_num
)
select
    n.cust_num
from ${itl_schema}.eifs_t00_per_cust_no_ref n
;
""",
            encoding="utf-8",
        )

        output = WarehouseSQLParser(system="edw").parse_directory(tmp_path)

        tables = {table["full_name"]: table for table in output.tables}
        assert "ITL.EIFS_T00_PER_CUST_NO_REF" in tables
        assert tables["ITL.EIFS_T00_PER_CUST_NO_REF"]["columns"] == [
            {"name": "CUST_NUM", "data_type": "VARCHAR2(24)", "comment": ""},
        ]
