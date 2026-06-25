"""Tests for core/pam/pam_parser.py.

Covers T13 (PamParser DDL 阶段并行):
  - 多 DDL 文件目录并行解析，表数量一致
  - DDL + DML 两阶段解析正确性
  - 坏 DDL 文件不阻塞其他文件
  - 重复解析结果一致性
"""

from __future__ import annotations

from pathlib import Path

from core.pam.pam_parser import PamParser


def _create_pam_ddl_sql(table_name: str, columns: list[tuple[str, str]], comment: str = "") -> str:
    """生成 PAM 格式 DDL（无 schema 前缀，parser 自动补 default_schema）。"""
    col_lines = []
    for i, (name, dtype) in enumerate(columns):
        prefix = "" if i == 0 else ","
        col_lines.append(f"{prefix}{name} {dtype}")
    body = "\n".join(col_lines)
    lines = [
        f"create table {table_name}(",
        body,
        ")",
    ]
    if comment:
        lines.append(f"comment on table {table_name} is '{comment}'")
    return "\n".join(lines) + "\n"


def _create_pam_dml_sql(
    proc_name: str,
    target_table: str,
    target_cols: list[str],
    source_table: str,
    source_cols: list[str],
) -> str:
    """生成 PAM 格式 DML（PL/SQL 过程包装的动态 SQL）。

    PAM DML 解析器只处理 CREATE PROCEDURE 块中的 v_sql/execute immediate 语句。
    """
    tgt_cols = ", ".join(target_cols)
    src_cols = ", ".join(source_cols)
    inner_sql = f"insert into {target_table} ({tgt_cols}) select {src_cols} from {source_table}"
    return (
        f"CREATE OR REPLACE PROCEDURE {proc_name} AS\n"
        f"  v_sql varchar2(4000);\n"
        f"BEGIN\n"
        f"  v_sql := '{inner_sql}';\n"
        f"  execute immediate v_sql;\n"
        f"END;\n"
        f"/\n"
    )


class TestPamParserDDLMultiFile:
    """T13: 多 DDL 文件并行解析，表数量和错误收集一致。"""

    def test_multiple_ddl_files_all_tables_parsed(self, tmp_path: Path):
        """多个 DDL 文件应全部被解析，表数量正确。"""
        ddl_dir = tmp_path / "ddl"
        ddl_dir.mkdir()

        for i in range(5):
            sql = _create_pam_ddl_sql(
                f"multi_tbl_{i}",
                [("ID", "number(22)"), ("NAME", "varchar2(100)")],
                comment=f"表{i}",
            )
            (ddl_dir / f"multi_tbl_{i}.sql").write_text(sql, encoding="utf-8")

        parser = PamParser(default_schema="pam")
        output = parser.parse_directory(tmp_path)

        table_names = {t["table_name"] for t in output.tables}
        assert len(output.tables) == 5
        for i in range(5):
            assert f"MULTI_TBL_{i}" in table_names
        assert len(output.errors) == 0

    def test_ddl_files_in_nested_ddl_directory(self, tmp_path: Path):
        """DDL 文件在嵌套 ddl/ 子目录中应被正确解析。"""
        sub_dir = tmp_path / "sub" / "ddl"
        sub_dir.mkdir(parents=True)

        sql = _create_pam_ddl_sql(
            "nested_tbl",
            [("CODE", "varchar2(20)"), ("VAL", "number(18,2)")],
        )
        (sub_dir / "nested_tbl.sql").write_text(sql, encoding="utf-8")

        parser = PamParser(default_schema="pam")
        output = parser.parse_directory(tmp_path)

        assert len(output.tables) == 1
        assert output.tables[0]["table_name"] == "NESTED_TBL"

    def test_bad_ddl_file_does_not_block_others(self, tmp_path: Path):
        """坏 DDL 文件不应阻塞其他好文件的解析。"""
        ddl_dir = tmp_path / "ddl"
        ddl_dir.mkdir()

        good_sql = _create_pam_ddl_sql("good_tbl", [("ID", "number(22)")])
        (ddl_dir / "good_tbl.sql").write_text(good_sql, encoding="utf-8")

        bad_sql = "this is not valid DDL content"
        (ddl_dir / "bad_file.sql").write_text(bad_sql, encoding="utf-8")

        another_good = _create_pam_ddl_sql("another_tbl", [("CODE", "varchar2(20)")])
        (ddl_dir / "another_tbl.sql").write_text(another_good, encoding="utf-8")

        parser = PamParser(default_schema="pam")
        output = parser.parse_directory(tmp_path)

        table_names = {t["table_name"] for t in output.tables}
        assert "GOOD_TBL" in table_names
        assert "ANOTHER_TBL" in table_names
        assert len(output.tables) == 2

    def test_empty_ddl_directory_returns_no_tables(self, tmp_path: Path):
        """空 DDL 目录应返回 0 张表，无错误。"""
        ddl_dir = tmp_path / "ddl"
        ddl_dir.mkdir()

        parser = PamParser(default_schema="pam")
        output = parser.parse_directory(tmp_path)

        assert len(output.tables) == 0
        assert len(output.errors) == 0


class TestPamParserTwoPhase:
    """T13: DDL + DML 两阶段解析正确性。"""

    def test_ddl_then_dml_lineage_extracted(self, tmp_path: Path):
        """DDL 阶段解析表结构，DML 阶段提取血缘。"""
        ddl_dir = tmp_path / "ddl"
        ddl_dir.mkdir()
        ddl_sql = _create_pam_ddl_sql(
            "rpt_data",
            [("ID", "number(22)"), ("VAL", "number(18,2)")],
        )
        (ddl_dir / "rpt_data.sql").write_text(ddl_sql, encoding="utf-8")

        dml_dir = tmp_path / "dml"
        dml_dir.mkdir()
        dml_sql = _create_pam_dml_sql(
            "sp_rpt_data",
            "pam.rpt_data",
            ["ID", "VAL"],
            "pam.raw_data",
            ["RAW_ID", "RAW_VAL"],
        )
        (dml_dir / "ins_rpt_data.sql").write_text(dml_sql, encoding="utf-8")

        parser = PamParser(default_schema="pam")
        output = parser.parse_directory(tmp_path)

        table_names = {t["table_name"] for t in output.tables}
        assert "RPT_DATA" in table_names

        lineage_pairs = {(tl["source_table"], tl["target_table"]) for tl in output.table_lineages}
        assert ("PAM.RAW_DATA", "PAM.RPT_DATA") in lineage_pairs

    def test_multiple_ddl_and_dml_files(self, tmp_path: Path):
        """多 DDL + 多 DML 文件混合，结果完整。"""
        ddl_dir = tmp_path / "ddl"
        ddl_dir.mkdir()
        for name, cols in [
            ("tbl_a", [("ID", "number(22)")]),
            ("tbl_b", [("CODE", "varchar2(20)")]),
            ("tbl_c", [("VAL", "number(18,2)")]),
        ]:
            (ddl_dir / f"{name}.sql").write_text(
                _create_pam_ddl_sql(name, cols), encoding="utf-8"
            )

        dml_dir = tmp_path / "dml"
        dml_dir.mkdir()
        for tgt, src, proc in [
            ("pam.tbl_a", "pam.src_a", "sp_ins_a"),
            ("pam.tbl_b", "pam.src_b", "sp_ins_b"),
        ]:
            col = "ID" if "tbl_a" in tgt else "CODE"
            (dml_dir / f"ins_{tgt.split('.')[1]}.sql").write_text(
                _create_pam_dml_sql(proc, tgt, [col], src, ["SRC_COL"]),
                encoding="utf-8",
            )

        parser = PamParser(default_schema="pam")
        output = parser.parse_directory(tmp_path)

        assert len(output.tables) == 3
        lineage_pairs = {(tl["source_table"], tl["target_table"]) for tl in output.table_lineages}
        assert ("PAM.SRC_A", "PAM.TBL_A") in lineage_pairs
        assert ("PAM.SRC_B", "PAM.TBL_B") in lineage_pairs


class TestPamParserConsistency:
    """T13: 重复解析结果一致性。"""

    def test_repeated_parse_produces_same_table_count(self, tmp_path: Path):
        """多次解析同一目录，表数量应一致。"""
        ddl_dir = tmp_path / "ddl"
        ddl_dir.mkdir()
        for i in range(8):
            (ddl_dir / f"consistency_tbl_{i}.sql").write_text(
                _create_pam_ddl_sql(f"consistency_tbl_{i}", [("ID", "number(22)")]),
                encoding="utf-8",
            )

        parser = PamParser(default_schema="pam")
        counts: list[int] = []
        for _ in range(3):
            output = parser.parse_directory(tmp_path)
            counts.append(len(output.tables))

        assert counts == [8, 8, 8]

    def test_nonexistent_directory_returns_error(self, tmp_path: Path):
        """不存在的目录应返回错误。"""
        parser = PamParser(default_schema="pam")
        output = parser.parse_directory(tmp_path / "nonexistent")

        assert len(output.errors) == 1
        assert len(output.tables) == 0

    def test_file_path_not_directory_returns_error(self, tmp_path: Path):
        """文件路径（非目录）应返回错误。"""
        file_path = tmp_path / "not_a_dir.sql"
        file_path.write_text("create table x(id number)", encoding="utf-8")

        parser = PamParser(default_schema="pam")
        output = parser.parse_directory(file_path)

        assert len(output.errors) == 1
        assert len(output.tables) == 0
