"""LineageTracer.to_graph_result procedure 归属修复测试。

回归：upstream 模式下，边 src → tgt 的 procedure 应取自 src 节点
（prev_node），而非目标节点（node）。目标节点（尤其是 root）的
procedure 为空，导致最终一段映射缺少 procedure 信息。
"""

from core.lineage_tracer import FieldLineageChain, FieldLineageNode, LineageTracer


def _make_node(table, field, procedure="", transform_logic=""):
    return FieldLineageNode(
        layer=0,
        table_name=table,
        field_name=field,
        procedure=procedure,
        transform_logic=transform_logic,
        source_fields=[],
        is_temp=False,
        layer_type="base",
    )


def test_upstream_procedure_from_source_node():
    """upstream 模式下，边的 procedure 应取自源节点（prev_node）。"""
    # chain: O_ICL_CMM.CUST_NAME → M_CUST_IND.CUST_NM → EAST.KHXM
    # 模拟 upstream BFS 的 chain 顺序：source → target
    chain = FieldLineageChain(
        target_table="RRP_EAST.EAST5_201_GRJCXXB",
        target_field="KHXM",
        chain=[
            _make_node("RRP_MDL.O_ICL_CMM", "CUST_NAME", "ETL_PROC_A", "logic_a"),
            _make_node("RRP_MDL.M_CUST_IND", "CUST_NM", "ETL_PROC_B", "logic_b"),
            _make_node("RRP_EAST.EAST5_201_GRJCXXB", "KHXM", "", "(目标字段)"),
        ],
        depth=2,
    )

    _, _, mappings = LineageTracer.to_graph_result([chain], direction="upstream")

    assert len(mappings) == 2

    # Edge 1: O_ICL_CMM.CUST_NAME → M_CUST_IND.CUST_NM
    assert mappings[0]["procedure"] == "ETL_PROC_A", (
        f"Edge 1 procedure 应来自 prev_node (源端), got '{mappings[0]['procedure']}'"
    )
    assert mappings[0]["transform_logic"] == "logic_a"

    # Edge 2: M_CUST_IND.CUST_NM → EAST5_201_GRJCXXB.KHXM
    assert mappings[1]["procedure"] == "ETL_PROC_B", (
        f"Edge 2 procedure 应来自 prev_node (源端), got '{mappings[1]['procedure']}'"
    )
    assert mappings[1]["transform_logic"] == "logic_b"


def test_downstream_procedure_from_target_node():
    """downstream 模式下，边的 procedure 应取自目标节点（node）。"""
    # downstream chain: source → target, tgt.procedure 描述流入它的过程
    chain = FieldLineageChain(
        target_table="RRP_MDL.O_ICL_CMM",
        target_field="CUST_NAME",
        chain=[
            _make_node("RRP_EAST.EAST5_201_GRJCXXB", "KHXM", "", "(源字段)"),
            _make_node("RRP_MDL.M_CUST_IND", "CUST_NM", "ETL_PROC_B", "logic_b"),
            _make_node("RRP_MDL.O_ICL_CMM", "CUST_NAME", "ETL_PROC_A", "logic_a"),
        ],
        depth=2,
    )

    _, _, mappings = LineageTracer.to_graph_result([chain], direction="downstream")

    assert len(mappings) == 2

    # Edge 1: KHXM → CUST_NM — procedure from tgt node (CUST_NM)
    assert mappings[0]["procedure"] == "ETL_PROC_B"
    assert mappings[0]["transform_logic"] == "logic_b"

    # Edge 2: CUST_NM → CUST_NAME — procedure from tgt node (CUST_NAME)
    assert mappings[1]["procedure"] == "ETL_PROC_A"
    assert mappings[1]["transform_logic"] == "logic_a"


def test_upstream_root_no_empty_procedure():
    """upstream 最后一跳不应产出空 procedure（回归原 bug）。"""
    chain = FieldLineageChain(
        target_table="RRP_EAST.EAST5_201_GRJCXXB",
        target_field="KHXM",
        chain=[
            _make_node("RRP_MDL.M_CUST_IND", "CUST_NM", "ETL_EAST5_201", "INSERT INTO"),
            _make_node("RRP_EAST.EAST5_201_GRJCXXB", "KHXM", "", "(目标字段)"),
        ],
        depth=1,
    )

    _, _, mappings = LineageTracer.to_graph_result([chain], direction="upstream")

    assert len(mappings) == 1
    assert mappings[0]["procedure"] == "ETL_EAST5_201", f"最后一跳 procedure 不应为空, got '{mappings[0]['procedure']}'"
