"""T15: 固定 IndicatorAdapter 字段映射当前行为。

背景：
  IndicatorCalcBase 数据模型没有 field_mappings 属性，
  indicator_adapter.py:109 使用 getattr(base_calc, "field_mappings", []) 永远返回 []，
  因此笛卡尔积字段映射代码（lines 110-128）是死代码，从未执行。

本测试套件固定当前行为，并用 mock 验证"假设 mappings 非空时"的笛卡尔积语义，
防止未来误改。若后续要启用字段级血缘，需先解决 SQL 别名解析问题（见 T15 调研报告）。
"""

from __future__ import annotations

from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch

from core.adapters.indicator_adapter import IndicatorAdapter
from core.indicator_models import IndicatorCalcBase, IndicatorConfigResult


def _make_result(base_calcs: list[IndicatorCalcBase]) -> IndicatorConfigResult:
    """构造一个只含 base_calcs 的 IndicatorConfigResult。"""
    return IndicatorConfigResult(base_calcs=base_calcs)


def _make_adapter_and_parse(
    base_calcs: list[IndicatorCalcBase], tmp_path: Path
):
    """用 mock IndicatorConfigParser 驱动 IndicatorAdapter.parse_directory。

    返回 ParseOutput，避免依赖真实 Excel 文件。
    """
    result = _make_result(base_calcs)

    with patch(
        "core.indicator_config_parser.IndicatorConfigParser"
    ) as mock_parser_cls:
        mock_parser_cls.return_value.parse_all.return_value = result
        adapter = IndicatorAdapter()
        output = adapter.parse_directory(tmp_path)

    return output


class TestIndicatorAdapterFieldMappings:
    """T15: IndicatorAdapter 字段映射行为固定。"""

    def test_field_mappings_empty_when_base_calc_has_no_mappings(
        self, tmp_path: Path
    ):
        """IndicatorCalcBase 无 field_mappings 属性 → output.field_mappings 必须为空。

        这是当前死代码行为的固定测试。若未来有人给 IndicatorCalcBase 增加了
        field_mappings 属性并填充数据，此测试会失败，提醒开发者重新评估
        笛卡尔积语义（见 test_cartesian_product_semantics_when_mappings_present）。
        """
        base_calc = IndicatorCalcBase(
            trg_table_name="FDL.TGT_TABLE",
            src_table_name="FDL.SRC_TABLE_A,FDL.SRC_TABLE_B",
        )

        output = _make_adapter_and_parse([base_calc], tmp_path)

        assert output.field_mappings == [], (
            "IndicatorCalcBase 无 field_mappings 属性时，output.field_mappings 必须为空。"
            "若此测试失败，说明有人给 IndicatorCalcBase 增加了 field_mappings 并填充了数据，"
            "需重新评估 indicator_adapter.py 的笛卡尔积语义。"
        )

    def test_cartesian_product_semantics_when_mappings_present(
        self, tmp_path: Path
    ):
        """当 base_calc.field_mappings 非空时，会产生 N(mapping) × M(source_tables) 笛卡尔积。

        此测试用 mock 显式记录当前笛卡尔积语义。每个 mapping 会被复制到每一个源表，
        即使该 mapping 的 source_column 实际只来自某一个源表。

        文档化：此行为待 T15 后续决策。若要改为"关联实际源表"，
        需先在 IndicatorSQLParser 中实现 SQL 别名解析（alias → table）。
        """
        base_calc = IndicatorCalcBase(
            trg_table_name="FDL.TGT_TABLE",
            src_table_name="FDL.SRC_TABLE_A,FDL.SRC_TABLE_B",
        )
        # 动态挂载 field_mappings 属性（模拟未来可能的数据形态）
        # 使用 SimpleNamespace 模拟 mapping 对象，因为 indicator_adapter.py
        # 用 getattr(mapping, "source_column", "") 等方式访问
        base_calc.field_mappings = [
            SimpleNamespace(
                source_column="COL_A",
                target_column="TGT_COL_A",
                expression="S.COL_A",
            ),
            SimpleNamespace(
                source_column="COL_B",
                target_column="TGT_COL_B",
                expression="NVL(S.COL_B, 0)",
            ),
        ]

        output = _make_adapter_and_parse([base_calc], tmp_path)

        # 2 mappings × 2 source_tables = 4 field_mappings（笛卡尔积）
        assert len(output.field_mappings) == 4, (
            "笛卡尔积语义：每个 mapping 复制到每个 source_table。"
            "2 mappings × 2 source_tables 应产生 4 条 field_mappings。"
        )

        # 验证每条 mapping 的 source_table 来自两个源表之一
        source_tables_in_mappings = {fm["source_table"] for fm in output.field_mappings}
        assert source_tables_in_mappings == {"FDL.SRC_TABLE_A", "FDL.SRC_TABLE_B"}

        # 验证 mapping 内容正确（COL_A 和 COL_B 都被复制到两个源表）
        target_cols_per_source = {}
        for fm in output.field_mappings:
            key = fm["source_table"]
            target_cols_per_source.setdefault(key, set()).add(fm["target_column"])

        assert target_cols_per_source == {
            "FDL.SRC_TABLE_A": {"TGT_COL_A", "TGT_COL_B"},
            "FDL.SRC_TABLE_B": {"TGT_COL_A", "TGT_COL_B"},
        }

        # 验证 transform_logic 正确传递
        for fm in output.field_mappings:
            if fm["target_column"] == "TGT_COL_A":
                assert fm["transform_logic"] == "S.COL_A"
            elif fm["target_column"] == "TGT_COL_B":
                assert fm["transform_logic"] == "NVL(S.COL_B, 0)"

    def test_table_lineages_not_affected_by_field_mappings(
        self, tmp_path: Path
    ):
        """表级血缘不受 field_mappings 是否存在的影响。

        无论 base_calc.field_mappings 是否为空，table_lineages 都应正常生成
        src_table → trg_table 的血缘关系。
        """
        base_calc = IndicatorCalcBase(
            trg_table_name="FDL.TGT_TABLE",
            src_table_name="FDL.SRC_TABLE_A,FDL.SRC_TABLE_B",
        )

        output = _make_adapter_and_parse([base_calc], tmp_path)

        # 表级血缘应该有 2 条（SRC_A → TGT, SRC_B → TGT）
        lineage_pairs = {
            (tl["source_table"], tl["target_table"])
            for tl in output.table_lineages
        }
        assert ("FDL.SRC_TABLE_A", "FDL.TGT_TABLE") in lineage_pairs
        assert ("FDL.SRC_TABLE_B", "FDL.TGT_TABLE") in lineage_pairs

        # field_mappings 应为空（因为 IndicatorCalcBase 无此属性）
        assert output.field_mappings == []
