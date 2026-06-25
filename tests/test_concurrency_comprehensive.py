"""
并发解析策略改造 — 功能测试、数据准确性与一致性测试

覆盖范围:
  1. WarehouseSQLParser 两阶段解析（DDL→DML）正确性
  2. 多数据源并发解析功能正确性
  3. DDL 结果注入 DML 的数据准确性
  4. 并发场景下 DDL 结果不跨系统污染（一致性）
  5. 竞态条件压力测试
  6. ParserService 线程池配置与生命周期
"""

from __future__ import annotations

import threading
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

from app.services.parser_service import ParseResult, ParserService
from core.models import ColumnInfo, TableInfo, TableLineage
from core.parser_protocol import ParseOutput
from core.warehouse.ddl_parser import DDLParser
from core.warehouse.dml_parser import DMLParser
from core.warehouse.schema_resolver import SchemaResolver
from core.warehouse.temp_table_filter import TempTableFilter
from core.warehouse.warehouse_parser import WarehouseSQLParser

# ---------------------------------------------------------------------------
# 测试数据工厂
# ---------------------------------------------------------------------------


def _create_ddl_sql(schema_var: str, table_name: str, columns: list[tuple[str, str]], comment: str = "") -> str:
    _col_defs = "\n".join(f"    ,{name} {dtype}" for name, dtype in columns)
    first_col_name, first_col_dtype = columns[0]
    rest_cols = "\n".join(f"    ,{name} {dtype}" for name, dtype in columns[1:])
    lines = [
        f"CREATE TABLE ${{{schema_var}}}.{table_name}(",
        f"    {first_col_name} {first_col_dtype}",
    ]
    if rest_cols:
        lines.append(rest_cols)
    lines.append(")")
    if comment:
        lines.append(f"COMMENT ON TABLE ${{{schema_var}}}.{table_name} IS '{comment}'")
    return "\n".join(lines) + "\n"


def _create_insert_dml(
    target_schema_var: str,
    target_table: str,
    target_cols: list[str],
    source_schema_var: str,
    source_table: str,
) -> str:
    cols = ", ".join(target_cols)
    return (
        f"INSERT INTO ${{{target_schema_var}}}.{target_table} ({cols})\n"
        f"SELECT {cols}\n"
        f"FROM ${{{source_schema_var}}}.{source_table}\n;\n"
    )


def _create_merge_dml(
    target_schema_var: str,
    target_table: str,
    source_schema_var: str,
    source_table: str,
) -> str:
    return (
        f"MERGE INTO ${{{target_schema_var}}}.{target_table}\n"
        f"USING ${{{source_schema_var}}}.{source_table} src\n"
        f"ON (1=0)\n;\n"
    )


def _create_ctl_file(schema_var: str, table_name: str, columns: list[str]) -> str:
    fields = "\n".join(f"  {col} CHAR," for col in columns)
    return (
        f"OPTIONS (DIRECT=TRUE)\n"
        f"LOAD DATA\n"
        f"INFILE 'data.dat'\n"
        f"TRUNCATE INTO TABLE ${{{schema_var}}}.{table_name}\n"
        f"FIELDS TERMINATED BY '|'\n"
        f"TRAILING NULLCOLS\n"
        f"(\n{fields}\n)\n"
    )


def _setup_datasource_dir(
    base_dir: Path,
    ds_name: str,
    ddl_tables: list[tuple[str, str, list[tuple[str, str]]]] | None = None,
    dml_inserts: list[tuple[str, str, list[str], str, str]] | None = None,
    dml_merges: list[tuple[str, str, str, str]] | None = None,
    ctl_files: list[tuple[str, str, list[str]]] | None = None,
) -> Path:
    ds_dir = base_dir / ds_name
    ds_dir.mkdir(parents=True, exist_ok=True)

    if ddl_tables:
        ddl_dir = ds_dir / "ddl"
        ddl_dir.mkdir(exist_ok=True)
        for schema_var, table_name, columns in ddl_tables:
            sql_file = ddl_dir / f"{table_name}.sql"
            sql_file.write_text(_create_ddl_sql(schema_var, table_name, columns), encoding="utf-8")

    if dml_inserts:
        dml_dir = ds_dir / "dml"
        dml_dir.mkdir(exist_ok=True)
        for target_var, target_tbl, cols, src_var, src_tbl in dml_inserts:
            sql_file = dml_dir / f"ins_{target_tbl}.sql"
            sql_file.write_text(
                _create_insert_dml(target_var, target_tbl, cols, src_var, src_tbl),
                encoding="utf-8",
            )

    if dml_merges:
        dml_dir = ds_dir / "dml"
        dml_dir.mkdir(exist_ok=True)
        for target_var, target_tbl, src_var, src_tbl in dml_merges:
            sql_file = dml_dir / f"mrg_{target_tbl}.sql"
            sql_file.write_text(
                _create_merge_dml(target_var, target_tbl, src_var, src_tbl),
                encoding="utf-8",
            )

    if ctl_files:
        for schema_var, table_name, columns in ctl_files:
            ctl_file = ds_dir / f"{table_name}.ctl"
            ctl_file.write_text(_create_ctl_file(schema_var, table_name, columns), encoding="utf-8")

    return ds_dir


# ---------------------------------------------------------------------------
# 1. 两阶段解析正确性测试
# ---------------------------------------------------------------------------


class TestTwoPhaseParsing:
    """验证 DDL→DML 两阶段解析逻辑正确"""

    def test_ddl_parsed_before_dml(self, tmp_path: Path):
        _setup_datasource_dir(
            tmp_path,
            "EDW",
            ddl_tables=[("idl_schema", "cust_info", [("CUST_ID", "VARCHAR2(32)"), ("CUST_NAME", "VARCHAR2(100)")])],
            dml_inserts=[("idl_schema", "cust_info", ["CUST_ID", "CUST_NAME"], "src_schema", "src_cust")],
        )
        parser = WarehouseSQLParser(schema_resolver=SchemaResolver(), system="edw")
        output = parser.parse_directory(tmp_path / "EDW")

        table_names = [t["full_name"] for t in output.tables]
        assert "IDL.CUST_INFO" in table_names

    def test_ddl_columns_extracted_correctly(self, tmp_path: Path):
        _setup_datasource_dir(
            tmp_path,
            "BRT",
            ddl_tables=[
                (
                    "iml_schema",
                    "loan_base",
                    [("LOAN_ID", "NUMBER(22)"), ("AMT", "NUMBER(18,2)"), ("STATUS", "VARCHAR2(10)")],
                )
            ],
        )
        parser = WarehouseSQLParser(schema_resolver=SchemaResolver(), system="brt")
        output = parser.parse_directory(tmp_path / "BRT")

        cust_table = next(t for t in output.tables if t["table_name"] == "LOAN_BASE")
        col_names = [c["name"] for c in cust_table["columns"]]
        assert "LOAN_ID" in col_names
        assert "AMT" in col_names
        assert "STATUS" in col_names

    def test_dml_lineage_extracted_correctly(self, tmp_path: Path):
        _setup_datasource_dir(
            tmp_path,
            "PAM",
            ddl_tables=[("icl_schema", "rpt_data", [("ID", "NUMBER(22)"), ("VAL", "NUMBER(18,2)")])],
            dml_inserts=[("icl_schema", "rpt_data", ["ID", "VAL"], "iol_schema", "raw_data")],
        )
        parser = WarehouseSQLParser(schema_resolver=SchemaResolver(), system="pam")
        output = parser.parse_directory(tmp_path / "PAM")

        lineage_pairs = {(tl["source_table"], tl["target_table"]) for tl in output.table_lineages}
        assert ("IOL.RAW_DATA", "ICL.RPT_DATA") in lineage_pairs

    def test_merge_dml_lineage(self, tmp_path: Path):
        _setup_datasource_dir(
            tmp_path,
            "GBASE",
            ddl_tables=[("idl_schema", "target_tbl", [("ID", "NUMBER(22)")])],
            dml_merges=[("idl_schema", "target_tbl", "iml_schema", "source_tbl")],
        )
        parser = WarehouseSQLParser(schema_resolver=SchemaResolver(), system="gbase")
        output = parser.parse_directory(tmp_path / "GBASE")

        lineage_pairs = {(tl["source_table"], tl["target_table"]) for tl in output.table_lineages}
        assert ("IML.SOURCE_TBL", "IDL.TARGET_TBL") in lineage_pairs

    def test_no_ddl_dir_dml_still_works(self, tmp_path: Path):
        _setup_datasource_dir(
            tmp_path,
            "SIMPLE",
            dml_inserts=[("idl_schema", "some_target", ["COL_A"], "src_schema", "some_source")],
        )
        parser = WarehouseSQLParser(schema_resolver=SchemaResolver(), system="simple")
        output = parser.parse_directory(tmp_path / "SIMPLE")

        lineage_pairs = {(tl["source_table"], tl["target_table"]) for tl in output.table_lineages}
        assert ("SRC.SOME_SOURCE", "IDL.SOME_TARGET") in lineage_pairs

    def test_ctl_files_parsed(self, tmp_path: Path):
        _setup_datasource_dir(
            tmp_path,
            "MSL",
            ctl_files=[("msl_schema", "msl_load_table", ["FIELD_A", "FIELD_B"])],
        )
        parser = WarehouseSQLParser(schema_resolver=SchemaResolver(), system="msl")
        output = parser.parse_directory(tmp_path / "MSL")

        table_names = [t["full_name"] for t in output.tables]
        assert "MSL.MSL_LOAD_TABLE" in table_names


# ---------------------------------------------------------------------------
# 2. 多数据源并发解析功能测试
# ---------------------------------------------------------------------------


class TestConcurrentMultiDatasource:
    """验证多个数据源并发解析的功能正确性"""

    def _create_three_datasources(self, base_dir: Path) -> dict[str, Path]:
        datasources = {}

        datasources["EDW"] = _setup_datasource_dir(
            base_dir,
            "EDW",
            ddl_tables=[("idl_schema", "edw_table_a", [("ID", "NUMBER(22)"), ("NAME", "VARCHAR2(60)")])],
            dml_inserts=[("idl_schema", "edw_table_a", ["ID", "NAME"], "src_schema", "src_edw_a")],
        )

        datasources["BRT"] = _setup_datasource_dir(
            base_dir,
            "BRT",
            ddl_tables=[("iml_schema", "brt_table_b", [("CODE", "VARCHAR2(20)"), ("AMT", "NUMBER(18,2)")])],
            dml_inserts=[("iml_schema", "brt_table_b", ["CODE", "AMT"], "iol_schema", "raw_brt_b")],
        )

        datasources["PAM"] = _setup_datasource_dir(
            base_dir,
            "PAM",
            ddl_tables=[("icl_schema", "pam_table_c", [("KEY", "VARCHAR2(32)"), ("VALUE", "NUMBER(18,2)")])],
            dml_inserts=[("icl_schema", "pam_table_c", ["KEY", "VALUE"], "itl_schema", "itl_data_c")],
        )

        return datasources

    def test_concurrent_parse_produces_correct_tables(self, tmp_path: Path):
        datasources = self._create_three_datasources(tmp_path)
        resolver = SchemaResolver()
        parser = WarehouseSQLParser(schema_resolver=resolver, system="edw")

        all_tables: list[dict] = []
        all_lineages: list[dict] = []
        lock = threading.Lock()

        def _parse(name: str, path: Path) -> tuple[str, ParseOutput]:
            output = parser.parse_directory(path)
            return name, output

        with ThreadPoolExecutor(max_workers=3) as pool:
            futures = {pool.submit(_parse, n, p): n for n, p in datasources.items()}
            for future in as_completed(futures):
                name, output = future.result()
                with lock:
                    all_tables.extend(output.tables)
                    all_lineages.extend(output.table_lineages)

        table_names = {t["full_name"] for t in all_tables}
        assert "IDL.EDW_TABLE_A" in table_names
        assert "IML.BRT_TABLE_B" in table_names
        assert "ICL.PAM_TABLE_C" in table_names

    def test_concurrent_parse_produces_correct_lineages(self, tmp_path: Path):
        datasources = self._create_three_datasources(tmp_path)
        resolver = SchemaResolver()
        parser = WarehouseSQLParser(schema_resolver=resolver, system="edw")

        all_lineages: list[dict] = []
        lock = threading.Lock()

        with ThreadPoolExecutor(max_workers=3) as pool:
            futures = []
            for _name, path in datasources.items():
                futures.append(pool.submit(parser.parse_directory, path))
            for future in as_completed(futures):
                output = future.result()
                with lock:
                    all_lineages.extend(output.table_lineages)

        lineage_pairs = {(tl["source_table"], tl["target_table"]) for tl in all_lineages}
        assert ("SRC.SRC_EDW_A", "IDL.EDW_TABLE_A") in lineage_pairs
        assert ("IOL.RAW_BRT_B", "IML.BRT_TABLE_B") in lineage_pairs
        assert ("ITL.ITL_DATA_C", "ICL.PAM_TABLE_C") in lineage_pairs


# ---------------------------------------------------------------------------
# 3. DDL 结果注入 DML 的数据准确性测试
# ---------------------------------------------------------------------------


class TestDDLInjectionAccuracy:
    """验证 DDL 解析结果正确注入 DML 解析器"""

    def test_ddl_tables_passed_to_dml_parser(self, tmp_path: Path):
        _setup_datasource_dir(
            tmp_path,
            "ACC",
            ddl_tables=[
                ("icl_schema", "acc_target", [("ID", "NUMBER(22)"), ("NAME", "VARCHAR2(60)")]),
            ],
            dml_inserts=[
                ("icl_schema", "acc_target", ["ID", "NAME"], "iol_schema", "acc_source"),
            ],
        )

        resolver = SchemaResolver()
        ddl_parser = DDLParser(resolver)
        temp_filter = TempTableFilter()

        ddl_dir = tmp_path / "ACC" / "ddl"
        ddl_tables = ddl_parser.parse_directory(ddl_dir)

        assert "ICL.ACC_TARGET" in ddl_tables
        assert len(ddl_tables["ICL.ACC_TARGET"].columns) == 2

        dml_parser_with_ddl = DMLParser(resolver, temp_filter, ddl_tables)
        dml_parser_without_ddl = DMLParser(resolver, temp_filter, {})

        dml_dir = tmp_path / "ACC" / "dml"
        output_with = dml_parser_with_ddl.parse_directory(dml_dir)
        output_without = dml_parser_without_ddl.parse_directory(dml_dir)

        assert len(output_with.table_lineages) > 0
        assert len(output_without.table_lineages) > 0

    def test_ddl_columns_match_dml_targets(self, tmp_path: Path):
        _setup_datasource_dir(
            tmp_path,
            "COL",
            ddl_tables=[
                ("idl_schema", "col_target", [("COL_A", "VARCHAR2(30)"), ("COL_B", "NUMBER(22)"), ("COL_C", "DATE")]),
            ],
            dml_inserts=[
                ("idl_schema", "col_target", ["COL_A", "COL_B", "COL_C"], "src_schema", "col_source"),
            ],
        )

        parser = WarehouseSQLParser(schema_resolver=SchemaResolver(), system="col")
        output = parser.parse_directory(tmp_path / "COL")

        target_table = next(t for t in output.tables if t["table_name"] == "COL_TARGET")
        col_names = {c["name"] for c in target_table["columns"]}
        assert col_names == {"COL_A", "COL_B", "COL_C"}

        lineage = next(tl for tl in output.table_lineages if tl["target_table"] == "IDL.COL_TARGET")
        assert lineage["source_table"] == "SRC.COL_SOURCE"

    def test_multiple_ddl_tables_injected(self, tmp_path: Path):
        _setup_datasource_dir(
            tmp_path,
            "MULTI",
            ddl_tables=[
                ("icl_schema", "multi_t1", [("ID", "NUMBER(22)")]),
                ("icl_schema", "multi_t2", [("CODE", "VARCHAR2(20)")]),
            ],
            dml_inserts=[
                ("icl_schema", "multi_t1", ["ID"], "iol_schema", "src_t1"),
                ("icl_schema", "multi_t2", ["CODE"], "iol_schema", "src_t2"),
            ],
        )

        parser = WarehouseSQLParser(schema_resolver=SchemaResolver(), system="multi")
        output = parser.parse_directory(tmp_path / "MULTI")

        table_names = {t["table_name"] for t in output.tables}
        assert "MULTI_T1" in table_names
        assert "MULTI_T2" in table_names

        lineage_pairs = {(tl["source_table"], tl["target_table"]) for tl in output.table_lineages}
        assert ("IOL.SRC_T1", "ICL.MULTI_T1") in lineage_pairs
        assert ("IOL.SRC_T2", "ICL.MULTI_T2") in lineage_pairs


# ---------------------------------------------------------------------------
# 4. 并发场景下数据一致性测试（DDL 结果不跨系统污染）
# ---------------------------------------------------------------------------


class TestConcurrentDataConsistency:
    """验证并发解析时 DDL 结果不会跨数据源污染"""

    def test_no_cross_datasource_ddl_pollution(self, tmp_path: Path):
        ds_a = _setup_datasource_dir(
            tmp_path,
            "SYS_A",
            ddl_tables=[("idl_schema", "table_a", [("ID", "NUMBER(22)")])],
            dml_inserts=[("idl_schema", "table_a", ["ID"], "src_schema", "src_a")],
        )
        ds_b = _setup_datasource_dir(
            tmp_path,
            "SYS_B",
            ddl_tables=[("iml_schema", "table_b", [("CODE", "VARCHAR2(20)")])],
            dml_inserts=[("iml_schema", "table_b", ["CODE"], "iol_schema", "src_b")],
        )

        resolver = SchemaResolver()
        parser = WarehouseSQLParser(schema_resolver=resolver, system="test")

        results: dict[str, ParseOutput] = {}
        lock = threading.Lock()

        def _parse_and_store(name: str, path: Path):
            output = parser.parse_directory(path)
            with lock:
                results[name] = output

        with ThreadPoolExecutor(max_workers=2) as pool:
            pool.submit(_parse_and_store, "SYS_A", ds_a).result()
            pool.submit(_parse_and_store, "SYS_B", ds_b).result()

        a_tables = {t["full_name"] for t in results["SYS_A"].tables}
        b_tables = {t["full_name"] for t in results["SYS_B"].tables}

        assert "IDL.TABLE_A" in a_tables
        assert "IML.TABLE_B" not in a_tables, "SYS_B 的 DDL 表不应出现在 SYS_A 结果中"

        assert "IML.TABLE_B" in b_tables
        assert "IDL.TABLE_A" not in b_tables, "SYS_A 的 DDL 表不应出现在 SYS_B 结果中"

    def test_no_cross_datasource_lineage_pollution(self, tmp_path: Path):
        ds_x = _setup_datasource_dir(
            tmp_path,
            "SYS_X",
            ddl_tables=[("icl_schema", "target_x", [("ID", "NUMBER(22)")])],
            dml_inserts=[("icl_schema", "target_x", ["ID"], "iol_schema", "source_x")],
        )
        ds_y = _setup_datasource_dir(
            tmp_path,
            "SYS_Y",
            ddl_tables=[("itl_schema", "target_y", [("CODE", "VARCHAR2(20)")])],
            dml_inserts=[("itl_schema", "target_y", ["CODE"], "msl_schema", "source_y")],
        )

        resolver = SchemaResolver()
        parser = WarehouseSQLParser(schema_resolver=resolver, system="test")

        results: dict[str, ParseOutput] = {}
        lock = threading.Lock()

        def _parse_and_store(name: str, path: Path):
            output = parser.parse_directory(path)
            with lock:
                results[name] = output

        with ThreadPoolExecutor(max_workers=2) as pool:
            pool.submit(_parse_and_store, "SYS_X", ds_x).result()
            pool.submit(_parse_and_store, "SYS_Y", ds_y).result()

        x_lineages = {(tl["source_table"], tl["target_table"]) for tl in results["SYS_X"].table_lineages}
        y_lineages = {(tl["source_table"], tl["target_table"]) for tl in results["SYS_Y"].table_lineages}

        assert ("IOL.SOURCE_X", "ICL.TARGET_X") in x_lineages
        assert ("MSL.SOURCE_Y", "ITL.TARGET_Y") not in x_lineages, "SYS_Y 的血缘不应出现在 SYS_X 结果中"

        assert ("MSL.SOURCE_Y", "ITL.TARGET_Y") in y_lineages
        assert ("IOL.SOURCE_X", "ICL.TARGET_X") not in y_lineages, "SYS_X 的血缘不应出现在 SYS_Y 结果中"

    def test_local_dml_parser_isolation(self, tmp_path: Path):
        """直接验证 parse_directory 使用局部 DMLParser 而非实例变量"""
        ds_a = _setup_datasource_dir(
            tmp_path,
            "ISO_A",
            ddl_tables=[("idl_schema", "iso_tbl_a", [("ID", "NUMBER(22)")])],
            dml_inserts=[("idl_schema", "iso_tbl_a", ["ID"], "src_schema", "iso_src_a")],
        )
        ds_b = _setup_datasource_dir(
            tmp_path,
            "ISO_B",
            ddl_tables=[("iml_schema", "iso_tbl_b", [("CODE", "VARCHAR2(20)")])],
            dml_inserts=[("iml_schema", "iso_tbl_b", ["CODE"], "iol_schema", "iso_src_b")],
        )

        resolver = SchemaResolver()
        parser = WarehouseSQLParser(schema_resolver=resolver, system="test")

        original_dml_parser = parser._dml_parser

        output_a = parser.parse_directory(ds_a)
        output_b = parser.parse_directory(ds_b)

        assert parser._dml_parser is original_dml_parser, "parse_directory 不应修改 self._dml_parser"

        a_tables = {t["full_name"] for t in output_a.tables}
        b_tables = {t["full_name"] for t in output_b.tables}
        assert "IDL.ISO_TBL_A" in a_tables
        assert "IML.ISO_TBL_B" in b_tables


# ---------------------------------------------------------------------------
# 5. 竞态条件压力测试
# ---------------------------------------------------------------------------


class TestRaceConditionStress:
    """高并发压力测试，验证无竞态条件导致的数据错误"""

    def test_six_datasources_concurrent_stress(self, tmp_path: Path):
        ds_names = ["EDW", "BRT", "PAM", "GBASE", "CCR", "ICR"]
        schema_vars = ["idl_schema", "iml_schema", "icl_schema", "iol_schema", "itl_schema", "msl_schema"]
        src_vars = ["src_schema", "msl_schema", "itl_schema", "iol_schema", "src_schema", "src_schema"]

        datasources: dict[str, Path] = {}
        for ds_name, schema_var, src_var in zip(ds_names, schema_vars, src_vars, strict=True):
            table_name = f"stress_tbl_{ds_name.lower()}"
            _setup_datasource_dir(
                tmp_path,
                ds_name,
                ddl_tables=[(schema_var, table_name, [("ID", "NUMBER(22)"), ("VAL", "VARCHAR2(50)")])],
                dml_inserts=[(schema_var, table_name, ["ID", "VAL"], src_var, f"stress_src_{ds_name.lower()}")],
            )
            datasources[ds_name] = tmp_path / ds_name

        resolver = SchemaResolver()
        parser = WarehouseSQLParser(schema_resolver=resolver, system="stress")

        results: dict[str, ParseOutput] = {}
        lock = threading.Lock()
        errors: list[Exception] = []

        def _parse(name: str, path: Path):
            try:
                output = parser.parse_directory(path)
                with lock:
                    results[name] = output
            except Exception as e:
                with lock:
                    errors.append(e)

        with ThreadPoolExecutor(max_workers=6) as pool:
            futures = [pool.submit(_parse, n, p) for n, p in datasources.items()]
            for f in as_completed(futures):
                f.result()

        assert not errors, f"并发解析出错: {errors}"
        assert len(results) == 6, f"期望 6 个结果，实际 {len(results)}"

        for ds_name, _schema_var in zip(ds_names, schema_vars, strict=True):
            output = results[ds_name]
            table_names = {t["table_name"] for t in output.tables}
            expected_table = f"STRESS_TBL_{ds_name.upper()}"
            assert expected_table in table_names, f"{ds_name} 缺少表 {expected_table}"

    def test_repeated_concurrent_parse_consistency(self, tmp_path: Path):
        """多次并发解析，结果应一致"""
        _setup_datasource_dir(
            tmp_path,
            "REPEAT",
            ddl_tables=[("icl_schema", "repeat_tbl", [("ID", "NUMBER(22)")])],
            dml_inserts=[("icl_schema", "repeat_tbl", ["ID"], "iol_schema", "repeat_src")],
        )

        resolver = SchemaResolver()
        all_results: list[set[tuple[str, str]]] = []

        for _ in range(5):
            parser = WarehouseSQLParser(schema_resolver=resolver, system="repeat")
            output = parser.parse_directory(tmp_path / "REPEAT")
            lineage_pairs = {(tl["source_table"], tl["target_table"]) for tl in output.table_lineages}
            all_results.append(lineage_pairs)

        first = all_results[0]
        for i, result in enumerate(all_results[1:], 1):
            assert result == first, f"第 {i + 1} 次解析结果与第 1 次不一致: {result} != {first}"

    def test_interleaved_ddl_dml_parse_order(self, tmp_path: Path):
        """验证即使线程交错执行，DDL 仍在 DML 之前完成"""
        execution_order: list[str] = []  # noqa: F841
        _order_lock = threading.Lock()

        ds_a = _setup_datasource_dir(
            tmp_path,
            "ORDER_A",
            ddl_tables=[("idl_schema", "order_tbl_a", [("ID", "NUMBER(22)")])],
            dml_inserts=[("idl_schema", "order_tbl_a", ["ID"], "src_schema", "order_src_a")],
        )
        ds_b = _setup_datasource_dir(
            tmp_path,
            "ORDER_B",
            ddl_tables=[("iml_schema", "order_tbl_b", [("CODE", "VARCHAR2(20)")])],
            dml_inserts=[("iml_schema", "order_tbl_b", ["CODE"], "msl_schema", "order_src_b")],
        )

        resolver = SchemaResolver()

        parser_a = WarehouseSQLParser(schema_resolver=resolver, system="order_a")
        parser_b = WarehouseSQLParser(schema_resolver=resolver, system="order_b")

        with ThreadPoolExecutor(max_workers=2) as pool:
            f_a = pool.submit(parser_a.parse_directory, ds_a)
            f_b = pool.submit(parser_b.parse_directory, ds_b)
            output_a = f_a.result()
            output_b = f_b.result()

        a_tables = {t["full_name"] for t in output_a.tables}
        b_tables = {t["full_name"] for t in output_b.tables}

        assert "IDL.ORDER_TBL_A" in a_tables
        assert "IML.ORDER_TBL_B" in b_tables

        a_lineages = {(tl["source_table"], tl["target_table"]) for tl in output_a.table_lineages}
        b_lineages = {(tl["source_table"], tl["target_table"]) for tl in output_b.table_lineages}
        assert ("SRC.ORDER_SRC_A", "IDL.ORDER_TBL_A") in a_lineages
        assert ("MSL.ORDER_SRC_B", "IML.ORDER_TBL_B") in b_lineages


# ---------------------------------------------------------------------------
# 6. ParserService 线程池配置与生命周期测试
# ---------------------------------------------------------------------------


class TestParserServiceThreadPool:
    """验证 ParserService 的线程池配置和生命周期管理"""

    def test_executor_max_workers_matches_config(self, tmp_path: Path):
        parser = ParserService(
            data_dir=str(tmp_path / "data"),
            schema_dirs=[],
            output_dir=str(tmp_path / "output"),
        )
        assert parser._executor._max_workers == 6
        parser.shutdown()

    def test_shutdown_sets_executor_to_none(self, tmp_path: Path):
        parser = ParserService(
            data_dir=str(tmp_path / "data"),
            schema_dirs=[],
            output_dir=str(tmp_path / "output"),
        )
        assert parser._executor is not None
        parser.shutdown()
        assert parser._executor is None

    def test_shutdown_is_idempotent(self, tmp_path: Path):
        parser = ParserService(
            data_dir=str(tmp_path / "data"),
            schema_dirs=[],
            output_dir=str(tmp_path / "output"),
        )
        parser.shutdown()
        parser.shutdown()
        parser.shutdown()
        assert parser._executor is None

    def test_two_instances_have_separate_executors(self, tmp_path: Path):
        p1 = ParserService(
            data_dir=str(tmp_path / "data1"),
            schema_dirs=[],
            output_dir=str(tmp_path / "out1"),
        )
        p2 = ParserService(
            data_dir=str(tmp_path / "data2"),
            schema_dirs=[],
            output_dir=str(tmp_path / "out2"),
        )
        assert p1._executor is not p2._executor
        p1.shutdown()
        p2.shutdown()

    def test_no_shared_class_variable(self):
        assert not hasattr(ParserService, "_shared_executor")

    def test_parse_result_merge_thread_safety(self):
        result = ParseResult()
        errors: list[Exception] = []

        def _add_tables(batch_idx: int):
            try:
                for i in range(50):
                    t = TableInfo(
                        schema=f"S{batch_idx}",
                        table_name=f"T{i}",
                        full_name=f"S{batch_idx}.T{i}",
                        columns=[ColumnInfo(name="ID", data_type="NUMBER")],
                    )
                    result.tables.append(t)
                    tl = TableLineage(
                        source_table=f"S{batch_idx}.SRC{i}",
                        target_table=f"S{batch_idx}.TGT{i}",
                        procedure=f"PROC_{batch_idx}_{i}",
                    )
                    result.table_lineages.append(tl)
            except Exception as e:
                errors.append(e)

        threads = [threading.Thread(target=_add_tables, args=(i,)) for i in range(4)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()

        assert not errors, f"并发 merge 出错: {errors}"
        assert len(result.tables) == 200
        assert len(result.table_lineages) == 200


# ---------------------------------------------------------------------------
# 7. DDLParser / DMLParser 独立并发测试
# ---------------------------------------------------------------------------


class TestSubParserConcurrency:
    """验证 DDLParser 和 DMLParser 各自的文件级并发正确性"""

    def test_ddl_parser_concurrent_file_parse(self, tmp_path: Path):
        ddl_dir = tmp_path / "ddl"
        ddl_dir.mkdir()

        for i in range(10):
            sql = _create_ddl_sql("icl_schema", f"conc_tbl_{i}", [("ID", "NUMBER(22)")])
            (ddl_dir / f"conc_tbl_{i}.sql").write_text(sql, encoding="utf-8")

        resolver = SchemaResolver()
        parser = DDLParser(resolver)
        tables = parser.parse_directory(ddl_dir)

        assert len(tables) == 10
        for i in range(10):
            assert f"ICL.CONC_TBL_{i}" in tables

    def test_dml_parser_concurrent_file_parse(self, tmp_path: Path):
        dml_dir = tmp_path / "dml"
        dml_dir.mkdir()

        for i in range(10):
            sql = _create_insert_dml(
                "icl_schema",
                f"dml_target_{i}",
                ["ID"],
                "iol_schema",
                f"dml_source_{i}",
            )
            (dml_dir / f"dml_target_{i}.sql").write_text(sql, encoding="utf-8")

        resolver = SchemaResolver()
        temp_filter = TempTableFilter()
        parser = DMLParser(resolver, temp_filter)
        output = parser.parse_directory(dml_dir)

        assert len(output.table_lineages) == 10
        lineage_pairs = {(tl["source_table"], tl["target_table"]) for tl in output.table_lineages}
        for i in range(10):
            assert (f"IOL.DML_SOURCE_{i}", f"ICL.DML_TARGET_{i}") in lineage_pairs
