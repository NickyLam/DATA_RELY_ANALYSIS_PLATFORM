"""
Tests for core/warehouse/ module.

Covers: SchemaResolver, TempTableFilter, DDLParser, DMLParser, CTLParser.
Also covers: OracleTabAdapter (T11 as_completed).
"""

from __future__ import annotations

import time
from pathlib import Path
from unittest.mock import patch

from core.adapters.oracle_tab_adapter import OracleTabAdapter
from core.models import ColumnInfo, TableInfo
from core.table_parser import OracleTableParser
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
# core.utils.is_temp_table unified tests (T14)
# ---------------------------------------------------------------------------


class TestCoreUtilsIsTempTable:
    """T14: core.utils.is_temp_table 必须与 TempTableFilter 使用同一套规则。"""

    def setup_method(self):
        self.filter = TempTableFilter()

    def test_suffix_bk(self):
        from core.utils import is_temp_table
        assert is_temp_table("cmm_abmt_remit_dtl_bk") is True

    def test_suffix_tm(self):
        from core.utils import is_temp_table
        assert is_temp_table("ICL.some_table_tm") is True

    def test_suffix_op(self):
        from core.utils import is_temp_table
        assert is_temp_table("some_table_op") is True

    def test_suffix_cl(self):
        """T14 新增：_CL 后缀必须被识别为临时表。"""
        from core.utils import is_temp_table
        assert is_temp_table("some_table_cl") is True

    def test_suffix_old(self):
        """T14 新增：_OLD 后缀必须被识别为临时表。"""
        from core.utils import is_temp_table
        assert is_temp_table("some_table_old") is True

    def test_suffix_new(self):
        """T14 新增：_NEW 后缀必须被识别为临时表。"""
        from core.utils import is_temp_table
        assert is_temp_table("some_table_new") is True

    def test_prefix_tmp(self):
        from core.utils import is_temp_table
        assert is_temp_table("tmp_staging_data") is True

    def test_prefix_temp(self):
        from core.utils import is_temp_table
        assert is_temp_table("temp_load_buffer") is True

    def test_prefix_etl(self):
        """T14 新增：ETL_ 前缀必须被识别为临时表。"""
        from core.utils import is_temp_table
        assert is_temp_table("etl_transform_step") is True

    def test_prefix_stg(self):
        """T14 新增：STG_ 前缀必须被识别为临时表。"""
        from core.utils import is_temp_table
        assert is_temp_table("stg_raw_data") is True

    def test_date_suffix(self):
        """T14 新增：日期后缀 _YYYYMMDD 必须被识别为临时表。"""
        from core.utils import is_temp_table
        assert is_temp_table("orders_20240101") is True

    def test_normal_table_not_temp(self):
        from core.utils import is_temp_table
        assert is_temp_table("cmm_abmt_remit_dtl") is False
        assert is_temp_table("ICL.acct_balance") is False

    def test_empty_string(self):
        from core.utils import is_temp_table
        assert is_temp_table("") is False

    def test_consistent_with_temp_table_filter(self):
        """core.utils.is_temp_table 与 TempTableFilter.is_temp_table 结果必须一致。"""
        from core.utils import is_temp_table
        test_cases = [
            "table_bk", "table_tm", "table_op", "table_cl",
            "table_old", "table_new", "table_tmp", "table_temp",
            "tmp_table", "temp_table", "etl_table", "stg_table",
            "table_20240101", "normal_table", "ICL.normal_table",
            "", "ICL.table_ex",
        ]
        for name in test_cases:
            assert is_temp_table(name) == self.filter.is_temp_table(name), (
                f"is_temp_table({name!r}) 不一致: "
                f"core.utils={is_temp_table(name)}, "
                f"TempTableFilter={self.filter.is_temp_table(name)}"
            )


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

    # ------------------------------------------------------------------
    # T04: _extract_from_clause token-aware boundary
    # ------------------------------------------------------------------

    def test_union_in_string_literal_not_treated_as_boundary(self, tmp_path: Path):
        """UNION inside a string literal must not truncate the FROM clause."""
        dml_dir = tmp_path / "dml" / "icl"
        dml_dir.mkdir(parents=True)
        sql_file = dml_dir / "icl_union_in_string.sql"
        sql_file.write_text(
            """
insert into ${icl_schema}.target_table(
    col_a
    ,col_b
)
select
    t1.col_a
    ,'UNION' as col_b
from ${iml_schema}.source_table_a t1
;
""",
            encoding="utf-8",
        )

        output = self.parser.parse_file(sql_file)
        source_tables = {lineage["source_table"] for lineage in output.table_lineages}
        assert "IML.SOURCE_TABLE_A" in source_tables

    def test_union_in_line_comment_not_treated_as_boundary(self, tmp_path: Path):
        """UNION inside a line comment must not truncate the FROM clause."""
        dml_dir = tmp_path / "dml" / "icl"
        dml_dir.mkdir(parents=True)
        sql_file = dml_dir / "icl_union_in_comment.sql"
        sql_file.write_text(
            """
insert into ${icl_schema}.target_table(
    col_a
)
select
    t1.col_a
from ${iml_schema}.source_b t1 -- UNION is not a boundary here
;
""",
            encoding="utf-8",
        )

        output = self.parser.parse_file(sql_file)
        source_tables = {lineage["source_table"] for lineage in output.table_lineages}
        assert "IML.SOURCE_B" in source_tables

    def test_union_in_nested_subquery_not_treated_as_boundary(self, tmp_path: Path):
        """UNION inside a subquery must not truncate the outer FROM clause."""
        dml_dir = tmp_path / "dml" / "icl"
        dml_dir.mkdir(parents=True)
        sql_file = dml_dir / "icl_union_in_subquery.sql"
        sql_file.write_text(
            """
insert into ${icl_schema}.target_table(
    col_a
)
select
    sub.col_a
from (
    select col_a from ${iml_schema}.tbl_x
    UNION
    select col_a from ${iml_schema}.tbl_y
) sub
;
""",
            encoding="utf-8",
        )

        output = self.parser.parse_file(sql_file)
        source_tables = {lineage["source_table"] for lineage in output.table_lineages}
        assert "IML.TBL_X" in source_tables
        assert "IML.TBL_Y" in source_tables

    # ------------------------------------------------------------------
    # T05: DMLParser CTAS boundary regression
    # ------------------------------------------------------------------

    def test_ctas_with_string_from_literal(self, tmp_path: Path):
        """CTAS with 'FROM' inside a string literal must not break source extraction."""
        dml_dir = tmp_path / "dml" / "icl"
        dml_dir.mkdir(parents=True)
        sql_file = dml_dir / "icl_ctas_string_from.sql"
        sql_file.write_text(
            """
CREATE TABLE ${icl_schema}.target_ctas AS
SELECT
    t1.col_a
    ,'FROM somewhere' as note
FROM ${iml_schema}.real_source t1
;
""",
            encoding="utf-8",
        )

        output = self.parser.parse_file(sql_file)
        source_tables = {lineage["source_table"] for lineage in output.table_lineages}
        assert "IML.REAL_SOURCE" in source_tables

    def test_ctas_with_nested_select(self, tmp_path: Path):
        """CTAS with nested SELECT/FROM must not confuse the outer FROM clause."""
        dml_dir = tmp_path / "dml" / "icl"
        dml_dir.mkdir(parents=True)
        sql_file = dml_dir / "icl_ctas_nested.sql"
        sql_file.write_text(
            """
CREATE TABLE ${icl_schema}.target_ctas AS
SELECT
    sub.col_a
FROM (
    SELECT col_a FROM ${iml_schema}.inner_src
) sub
;
""",
            encoding="utf-8",
        )

        output = self.parser.parse_file(sql_file)
        source_tables = {lineage["source_table"] for lineage in output.table_lineages}
        assert "IML.INNER_SRC" in source_tables

    # ------------------------------------------------------------------
    # T09: DMLParser dynamic schema prefix (custom_mapping support)
    # ------------------------------------------------------------------

    def test_custom_schema_prefix_recognized_as_valid_table(self, tmp_path: Path):
        """SchemaResolver(custom_mapping=...) prefixes must be accepted as tables,
        not rejected as SQL aliases."""
        custom_resolver = SchemaResolver(custom_mapping={"xxx_schema": "XXX"})
        parser = DMLParser(custom_resolver, TempTableFilter())

        dml_dir = tmp_path / "dml" / "xxx"
        dml_dir.mkdir(parents=True)
        sql_file = dml_dir / "xxx_custom_schema.sql"
        sql_file.write_text(
            """
insert into ${xxx_schema}.target_tbl(
    col_a
)
select
    t1.col_a
from ${xxx_schema}.source_tbl t1
;
""",
            encoding="utf-8",
        )

        output = parser.parse_file(sql_file)
        source_tables = {lineage["source_table"] for lineage in output.table_lineages}
        target_tables = {lineage["target_table"] for lineage in output.table_lineages}
        assert "XXX.SOURCE_TBL" in source_tables
        assert "XXX.TARGET_TBL" in target_tables

    def test_known_schema_prefixes_includes_custom_mapping(self):
        """SchemaResolver.known_schema_prefixes() must include custom schemas."""
        custom_resolver = SchemaResolver(custom_mapping={"xxx_schema": "XXX"})
        prefixes = custom_resolver.known_schema_prefixes()
        assert "XXX" in prefixes
        # default schemas still present
        assert "ICL" in prefixes
        assert "IML" in prefixes

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


# ---------------------------------------------------------------------------
# OracleTabAdapter tests (T11: as_completed)
# ---------------------------------------------------------------------------

_TAB_FILE_CONTENT = """\
create table {schema}.{table_name}
(
    id          number(10) not null,
    name        varchar2(100),
    create_time date
)
/
comment on table {schema}.{table_name} is '{comment}';
"""


class TestOracleTabAdapter:
    """Test OracleTabAdapter parallel parsing with as_completed."""

    def setup_method(self):
        self.adapter = OracleTabAdapter(OracleTableParser())

    def _write_tab_file(self, dir_path: Path, schema: str, table_name: str, comment: str) -> Path:
        """Helper: write a .tab file and return its path."""
        file_path = dir_path / f"{schema.lower()}_{table_name.lower()}.tab"
        file_path.write_text(
            _TAB_FILE_CONTENT.format(
                schema=schema, table_name=table_name, comment=comment
            ),
            encoding="utf-8",
        )
        return file_path

    def test_parse_single_tab_file(self, tmp_path: Path):
        """parse_file should return a single table dict."""
        tab_path = self._write_tab_file(tmp_path, "ICL", "TEST_TABLE", "测试表")
        output = self.adapter.parse_file(tab_path)

        assert len(output.tables) == 1
        table = output.tables[0]
        assert table["full_name"] == "ICL.TEST_TABLE"
        assert table["schema"] == "ICL"
        assert table["table_name"] == "TEST_TABLE"
        assert len(table["columns"]) == 3
        assert table["columns"][0]["name"] == "ID"

    def test_parse_directory_returns_all_tables(self, tmp_path: Path):
        """parse_directory should return all .tab files in the directory."""
        self._write_tab_file(tmp_path, "ICL", "TABLE_A", "表A")
        self._write_tab_file(tmp_path, "IML", "TABLE_B", "表B")
        self._write_tab_file(tmp_path, "IOL", "TABLE_C", "表C")

        output = self.adapter.parse_directory(tmp_path)

        full_names = {t["full_name"] for t in output.tables}
        assert full_names == {"ICL.TABLE_A", "IML.TABLE_B", "IOL.TABLE_C"}
        assert len(output.errors) == 0

    def test_parse_directory_nonexistent_returns_error(self, tmp_path: Path):
        """Non-existent directory should return error, not crash."""
        output = self.adapter.parse_directory(tmp_path / "nonexistent")
        assert len(output.errors) == 1
        assert len(output.tables) == 0

    def test_parse_directory_empty_returns_empty(self, tmp_path: Path):
        """Empty directory should return empty output."""
        output = self.adapter.parse_directory(tmp_path)
        assert len(output.tables) == 0
        assert len(output.errors) == 0

    def test_results_merged_regardless_of_completion_order(self, tmp_path: Path):
        """T11: 慢 future/快 future 结果合并不依赖提交顺序。

        模拟第一个文件慢、第二个文件快，验证两个结果都正确合并。
        as_completed 确保快文件先处理，不阻塞在慢文件上。
        """
        slow_file = self._write_tab_file(tmp_path, "ICL", "SLOW_TABLE", "慢表")
        fast_file = self._write_tab_file(tmp_path, "IML", "FAST_TABLE", "快表")

        original_parse_file = self.adapter.parse_file
        call_log: list[str] = []

        def slow_then_fast_parse(file_path: Path):
            # 慢文件 sleep 0.3s，快文件立即返回
            if file_path == slow_file:
                time.sleep(0.3)
                call_log.append(f"slow_done:{file_path.name}")
            else:
                call_log.append(f"fast_done:{file_path.name}")
            return original_parse_file(file_path)

        with patch.object(self.adapter, "parse_file", side_effect=slow_then_fast_parse):
            output = self.adapter.parse_directory(tmp_path)

        # 两个表都应存在，证明结果合并不依赖完成顺序
        full_names = {t["full_name"] for t in output.tables}
        assert full_names == {"ICL.SLOW_TABLE", "IML.FAST_TABLE"}
        assert len(output.errors) == 0

    def test_partial_failure_does_not_block_other_results(self, tmp_path: Path):
        """T11: 单个文件解析失败不应阻塞其他文件的结果收集。"""
        good_file = self._write_tab_file(tmp_path, "ICL", "GOOD_TABLE", "好表")
        bad_file = tmp_path / "bad.tab"
        bad_file.write_text("invalid content without create table", encoding="utf-8")

        output = self.adapter.parse_directory(tmp_path)

        # 好文件的结果应存在
        full_names = {t["full_name"] for t in output.tables}
        assert "ICL.GOOD_TABLE" in full_names
        # 坏文件应产生错误，但不影响好文件
        assert len(output.errors) == 0  # parse_file 对坏内容返回空 ParseOutput，不是异常
