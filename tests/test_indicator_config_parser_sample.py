"""验证 indicator_config_parser.py 的解析逻辑是否正确。"""

from __future__ import annotations

import re
from pathlib import Path

import openpyxl
import pytest

from core.indicator_config_parser import IndicatorConfigParser, _BASE_CALC_COLUMNS, _GL_CALC_COLUMNS


# ── fixtures ──────────────────────────────────────────────
@pytest.fixture(scope="module")
def indicator_data_path(tmp_path_factory: pytest.TempPathFactory) -> Path:
    data_path = tmp_path_factory.mktemp("indicator_config")

    wb = openpyxl.Workbook()
    base_ws = wb.active
    base_ws.title = "基础指标算法表"
    base_ws.append(list(_BASE_CALC_COLUMNS))
    base_ws.append(
        [
            "FM010001",
            "客户余额",
            "基础",
            "1",
            "1",
            "FDL_IDX_INDEX_DATA",
            "FDL_SRC_BAL",
            "SUM(BAL)",
            "FM010002",
            "SELECT BAL FROM FDL_SRC_BAL",
            "2024-01-01",
            "2099-12-31",
            "tester",
            "Y",
        ]
    )
    base_ws.append(
        [
            "FM010002",
            "客户余额明细",
            "基础",
            "1",
            "2",
            "FDL_IDX_INDEX_DATA",
            "FDL_SRC_BAL_DTL",
            "SUM(BAL_DTL)",
            "",
            "SELECT BAL_DTL FROM FDL_SRC_BAL_DTL",
            "2024-01-01",
            "2099-12-31",
            "tester",
            "Y",
        ]
    )

    gl_ws = wb.create_sheet("总账指标算法表")
    gl_ws.append(list(_GL_CALC_COLUMNS))
    gl_ws.append(["GL010001", "总账", "总账余额", "+", "1001", "4", "BAL", "2024-01-01", "2099-12-31"])
    gl_ws.append(["GL010002", "总账", "总账负债", "-", "2001", "4", "BAL", "2024-01-01", "2099-12-31"])

    wb.save(data_path / "财务指标查询.xlsx")
    wb.close()

    (data_path / "PRO_F_INDEX_CALC_BASE.proc").write_text(
        """
CREATE OR REPLACE PROCEDURE PRO_F_INDEX_CALC_BASE AS
BEGIN
    INSERT INTO FDL_IDX_INDEX_DATA (INDEX_NO, AMT)
    SELECT B.INDEX_NO, S.BAL
      FROM FDL_IDX_PARA_BASE B
      JOIN FDL_SRC_BAL S ON B.INDEX_NO = S.INDEX_NO;
END;
""",
        encoding="utf-8",
    )

    return data_path


@pytest.fixture(scope="module")
def fdm_parser(indicator_data_path: Path) -> IndicatorConfigParser:
    """使用测试内生成的指标配置目录构造解析器。"""
    return IndicatorConfigParser(indicator_data_path)


@pytest.fixture(scope="module")
def proc_parser(indicator_data_path: Path) -> IndicatorConfigParser:
    """使用测试内生成的 proc 文件构造解析器。"""
    return IndicatorConfigParser(indicator_data_path)


@pytest.fixture(scope="module")
def base_calcs(fdm_parser: IndicatorConfigParser):
    return fdm_parser._parse_base_calc_excel()


@pytest.fixture(scope="module")
def gl_calcs(fdm_parser: IndicatorConfigParser):
    return fdm_parser._parse_gl_calc_excel()


@pytest.fixture(scope="module")
def relations(fdm_parser: IndicatorConfigParser, base_calcs):
    return fdm_parser._parse_relations_from_base(base_calcs)


@pytest.fixture(scope="module")
def procedures(proc_parser: IndicatorConfigParser):
    return proc_parser._parse_proc_files()


# ── 测试 a: 基础指标算法表 ────────────────────────────────
class TestBaseCalc:
    """解析基础指标算法表（_parse_base_calc_excel），抽样 5 条验证字段非空。"""

    def test_has_records(self, base_calcs):
        assert len(base_calcs) > 0, "基础指标算法表应至少有 1 条记录"

    def test_sample_fields_not_empty(self, base_calcs):
        sample = base_calcs[:5]
        assert len(sample) > 0, "抽样记录不足"
        for calc in sample:
            assert calc.index_no, f"index_no 不应为空, 实际: {calc.index_no!r}"
            assert calc.index_measure, f"index_measure 不应为空, 实际: {calc.index_measure!r}"
            assert calc.algo_type, f"algo_type 不应为空, 实际: {calc.algo_type!r}"


# ── 测试 b: 总账指标算法表 ────────────────────────────────
class TestGLCalc:
    """解析总账指标算法表（_parse_gl_calc_excel），抽样 5 条验证字段合理性。"""

    def test_has_records(self, gl_calcs):
        assert len(gl_calcs) > 0, "总账指标算法表应至少有 1 条记录"

    def test_sample_sign_no_valid(self, gl_calcs):
        sample = gl_calcs[:5]
        for calc in sample:
            assert calc.sign_no in (1, -1), (
                f"sign_no 只能是 1 或 -1, 实际: {calc.sign_no}"
            )

    def test_sample_index_no_format(self, gl_calcs):
        sample = gl_calcs[:5]
        pattern = re.compile(r"^[A-Za-z]+\d+$")
        for calc in sample:
            assert pattern.match(calc.index_no), (
                f"index_no 格式应为字母+数字, 实际: {calc.index_no!r}"
            )


# ── 测试 c: 依赖关系 ─────────────────────────────────────
class TestRelations:
    """解析依赖关系（_parse_relations_from_base），验证 depend_index_nos 中的编号在 base_calcs 中存在。"""

    def test_has_relations(self, relations):
        assert len(relations) > 0, "应至少有 1 组依赖关系"

    def test_depend_index_nos_exist_in_base(self, relations, base_calcs):
        all_index_nos = {c.index_no.upper() for c in base_calcs}
        missing_count = 0
        for rel in relations:
            for dep_no in rel.depend_index_nos:
                if dep_no.upper() not in all_index_nos:
                    missing_count += 1
        # 允许少量跨表依赖不在 base_calcs 中，但不应超过 50%
        total_deps = sum(len(r.depend_index_nos) for r in relations)
        if total_deps > 0:
            missing_ratio = missing_count / total_deps
            assert missing_ratio < 0.5, (
                f"依赖编号缺失率 {missing_ratio:.1%} 过高 "
                f"({missing_count}/{total_deps})"
            )


# ── 测试 d: 存储过程文件 ──────────────────────────────────
class TestProcFiles:
    """解析存储过程文件（_parse_proc_files），验证 proc_name / step_order / source_tables。"""

    def test_has_procedures(self, procedures):
        assert len(procedures) > 0, "应至少解析到 1 个存储过程"

    def test_proc_name_not_empty(self, procedures):
        for name, info in procedures.items():
            assert info.proc_name, f"proc_name 不应为空, key={name!r}"

    def test_step_order_positive(self, procedures):
        for name, info in procedures.items():
            assert info.step_order > 0, (
                f"step_order 应 > 0, 实际: {info.step_order}, proc={name!r}"
            )

    def test_source_tables_not_empty(self, procedures):
        for name, info in procedures.items():
            assert len(info.source_tables) > 0, (
                f"source_tables 不应为空, proc={name!r}"
            )


# ── 测试 e: Excel 列映射 ─────────────────────────────────
class TestColIndex:
    """验证 _build_col_index 列映射逻辑。"""

    def test_base_calc_columns_mapped(self):
        header = list(_BASE_CALC_COLUMNS)
        col_index = IndicatorConfigParser._build_col_index(header, _BASE_CALC_COLUMNS)
        for col_name in _BASE_CALC_COLUMNS:
            assert col_name in col_index, f"列 {col_name!r} 未映射"
            expected_idx = header.index(col_name)
            assert col_index[col_name] == expected_idx, (
                f"列 {col_name!r} 映射索引错误: 期望 {expected_idx}, 实际 {col_index[col_name]}"
            )

    def test_missing_columns_use_default(self):
        """当 header 缺少某些列时，应使用 expected_columns 中的默认索引。"""
        header = ["指标编号", "指标度量", "算法类型"]  # 只有 3 列
        col_index = IndicatorConfigParser._build_col_index(header, _BASE_CALC_COLUMNS)
        # 已存在的列应映射到正确位置
        assert col_index["指标编号"] == 0
        assert col_index["指标度量"] == 1
        assert col_index["算法类型"] == 2
        # 缺失的列应回退到 expected_columns 中的顺序索引
        assert col_index["序列"] == 4
        assert col_index["目标表名称"] == 5

    def test_extra_columns_ignored(self):
        """header 中有多余列时不应干扰映射。"""
        header = ["多余列", "指标编号", "指标度量", "另一个多余列", "算法类型"]
        col_index = IndicatorConfigParser._build_col_index(header, _BASE_CALC_COLUMNS)
        assert col_index["指标编号"] == 1
        assert col_index["指标度量"] == 2
        assert col_index["算法类型"] == 4

    def test_gl_calc_columns_mapped(self):
        header = list(_GL_CALC_COLUMNS)
        col_index = IndicatorConfigParser._build_col_index(header, _GL_CALC_COLUMNS)
        for col_name in _GL_CALC_COLUMNS:
            assert col_name in col_index, f"列 {col_name!r} 未映射"
