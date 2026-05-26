"""字段血缘映射去重测试。

回归测试：修复"4节点 / 6详情"重复 bug。

根因：LineageTracer.to_graph_result() 产出 full name（如 RRP_MDL.X），
而 data["field_mappings"] 中的原始映射可能是短名（X），原 dedup key 直接
用 source_table/target_table 字符串比较，导致同一逻辑映射被当成两条。
"""

from app.services.lineage_service import LineageService


def test_dedup_full_name_vs_short_name():
    """full name 和 short name 形式的同一映射应被去重为 1 条。"""
    mappings = [
        {
            "source_table": "RRP_MDL.TABLE_X",
            "source_column": "KHXM",
            "target_table": "RRP_EAST.EAST5_201_GRJCXXB",
            "target_column": "KHXM",
            "procedure": "PROC_A",
        },
        {
            "source_table": "TABLE_X",
            "source_column": "KHXM",
            "target_table": "EAST5_201_GRJCXXB",
            "target_column": "KHXM",
            "procedure": "PROC_A",
        },
    ]
    result = LineageService._deduplicate_field_mappings(mappings)
    assert len(result) == 1, f"应去重为 1 条，实际 {len(result)} 条: {result}"


def test_dedup_keeps_first_occurrence():
    """重复项应保留首次出现的记录。"""
    mappings = [
        {
            "source_table": "RRP_MDL.TABLE_X",
            "source_column": "KHXM",
            "target_table": "RRP_EAST.EAST5_201_GRJCXXB",
            "target_column": "KHXM",
            "procedure": "PROC_A",
            "marker": "first",
        },
        {
            "source_table": "TABLE_X",
            "source_column": "KHXM",
            "target_table": "EAST5_201_GRJCXXB",
            "target_column": "KHXM",
            "procedure": "PROC_A",
            "marker": "second",
        },
    ]
    result = LineageService._deduplicate_field_mappings(mappings)
    assert len(result) == 1
    assert result[0]["marker"] == "first"


def test_dedup_distinguishes_different_procedures():
    """同源同字段但不同 procedure 应保留为不同记录。"""
    mappings = [
        {
            "source_table": "TABLE_X",
            "source_column": "KHXM",
            "target_table": "EAST5_201_GRJCXXB",
            "target_column": "KHXM",
            "procedure": "PROC_A",
        },
        {
            "source_table": "TABLE_X",
            "source_column": "KHXM",
            "target_table": "EAST5_201_GRJCXXB",
            "target_column": "KHXM",
            "procedure": "PROC_B",
        },
    ]
    result = LineageService._deduplicate_field_mappings(mappings)
    assert len(result) == 2


def test_dedup_distinguishes_different_columns():
    """同表但不同字段应保留为不同记录。"""
    mappings = [
        {
            "source_table": "TABLE_X",
            "source_column": "KHXM",
            "target_table": "EAST5_201_GRJCXXB",
            "target_column": "KHXM",
            "procedure": "PROC_A",
        },
        {
            "source_table": "TABLE_X",
            "source_column": "ZJHM",
            "target_table": "EAST5_201_GRJCXXB",
            "target_column": "ZJHM",
            "procedure": "PROC_A",
        },
    ]
    result = LineageService._deduplicate_field_mappings(mappings)
    assert len(result) == 2


def test_dedup_case_insensitive():
    """大小写不同的同一映射应被去重。"""
    mappings = [
        {
            "source_table": "RRP_MDL.table_x",
            "source_column": "khxm",
            "target_table": "RRP_EAST.east5_201_grjcxxb",
            "target_column": "khxm",
            "procedure": "proc_a",
        },
        {
            "source_table": "RRP_MDL.TABLE_X",
            "source_column": "KHXM",
            "target_table": "RRP_EAST.EAST5_201_GRJCXXB",
            "target_column": "KHXM",
            "procedure": "PROC_A",
        },
    ]
    result = LineageService._deduplicate_field_mappings(mappings)
    assert len(result) == 1


def test_dedup_key_helper_consistent():
    """_field_mapping_dedup_key 对 full name 和 short name 应产出相同 key。"""
    full = {
        "source_table": "RRP_MDL.TABLE_X",
        "source_column": "KHXM",
        "target_table": "RRP_EAST.EAST5_201_GRJCXXB",
        "target_column": "KHXM",
        "procedure": "PROC_A",
    }
    short = {
        "source_table": "TABLE_X",
        "source_column": "KHXM",
        "target_table": "EAST5_201_GRJCXXB",
        "target_column": "KHXM",
        "procedure": "PROC_A",
    }
    assert LineageService._field_mapping_dedup_key(full) == \
           LineageService._field_mapping_dedup_key(short)


# --- _filter_field_mappings tests ---


def test_filter_both_ends_in_nodes():
    """源和目标都在节点中的映射应被保留。"""
    nodes = {"RRP_MDL.TABLE_X", "RRP_EAST.EAST5_201_GRJCXXB"}
    mappings = [
        {
            "source_table": "RRP_MDL.TABLE_X",
            "source_column": "KHXM",
            "target_table": "RRP_EAST.EAST5_201_GRJCXXB",
            "target_column": "KHXM",
            "procedure": "PROC_A",
        },
    ]
    result = LineageService._filter_field_mappings(mappings, nodes, target_field="KHXM")
    assert len(result) == 1


def test_filter_excludes_one_end_outside_nodes():
    """只有一端在节点中的映射应被排除（泄漏修复回归）。"""
    nodes = {"RRP_EAST.M_CUST_IND_INFO_EAST", "RRP_EAST.EAST5_201_GRJCXXB"}
    mappings = [
        # 源和目标都在节点中 -> 保留
        {
            "source_table": "RRP_EAST.M_CUST_IND_INFO_EAST",
            "source_column": "CUST_NM_DESEN",
            "target_table": "RRP_EAST.EAST5_201_GRJCXXB",
            "target_column": "KHXM",
            "procedure": "PROC_A",
        },
        # 目标不在节点中 -> 排除
        {
            "source_table": "RRP_EAST.M_CUST_IND_INFO_EAST",
            "source_column": "CUST_NM_DESEN",
            "target_table": "RRP_EAST.EAST5_202_GRKHGXB",
            "target_column": "KHXM",
            "procedure": "PROC_B",
        },
    ]
    result = LineageService._filter_field_mappings(mappings, nodes, target_field="KHXM")
    assert len(result) == 1
    assert result[0]["target_table"] == "RRP_EAST.EAST5_201_GRJCXXB"


def test_filter_matches_short_name_in_nodes():
    """data 中的短名应能匹配节点集合中的全名。"""
    nodes = {"RRP_MDL.TABLE_X", "RRP_EAST.EAST5_201_GRJCXXB"}
    mappings = [
        {
            "source_table": "TABLE_X",
            "source_column": "KHXM",
            "target_table": "EAST5_201_GRJCXXB",
            "target_column": "KHXM",
            "procedure": "PROC_A",
        },
    ]
    result = LineageService._filter_field_mappings(mappings, nodes, target_field="KHXM")
    assert len(result) == 1


def test_filter_no_field_returns_all_in_node_mappings():
    """不指定字段时，只要源和目标都在节点中就保留。"""
    nodes = {"RRP_MDL.TABLE_X", "RRP_EAST.EAST5_201_GRJCXXB"}
    mappings = [
        {
            "source_table": "RRP_MDL.TABLE_X",
            "source_column": "KHXM",
            "target_table": "RRP_EAST.EAST5_201_GRJCXXB",
            "target_column": "KHXM",
            "procedure": "PROC_A",
        },
        {
            "source_table": "RRP_MDL.TABLE_X",
            "source_column": "ZJHM",
            "target_table": "RRP_EAST.EAST5_201_GRJCXXB",
            "target_column": "ZJHM",
            "procedure": "PROC_A",
        },
    ]
    result = LineageService._filter_field_mappings(mappings, nodes)
    assert len(result) == 2
