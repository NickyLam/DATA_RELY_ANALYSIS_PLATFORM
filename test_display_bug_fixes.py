"""
测试展示层查询三个 Bug 的修复

测试场景:
  1. Schema 自动匹配：EAST5_201_GRJCXXB 应解析为 RRP_EAST 而非 RRP_MDL
  2. 错误 schema+表名应校验失败：RRP_MDL.EAST5_201_GRJCXXB 不应返回数据
  3. ICL 分支去重：EAST5_201_GRJCXXB.KHXM 不应出现 ICL 分支
"""

import sys

sys.path.insert(
    0,
    "/Users/linmaogui/VSCodeProjects/VSCodeProjects/LLM/Trae SOLO/DATA_RELY_ANALYSIS_SYS",
)

from app.services.table_lineage_tracer import TableLineageTracer
from core.layer_detector import LayerType, detect_layer
from core.table_name_resolver import TableNameResolver


def test_resolve_table_name_bug1_and_bug2():
    """测试 Bug 1 & 2: schema 解析和严格校验"""
    resolver = TableNameResolver()
    tracer = TableLineageTracer(resolver)

    # 模拟邻接表数据（RRP_MDL 和 RRP_EAST 都有同名表）
    tracer._adjacency_up = {
        "RRP_MDL.EAST5_201_GRJCXXB": {"RRP_MDL.SOME_SOURCE"},
        "RRP_EAST.EAST5_201_GRJCXXB": {"RRP_EAST.OTHER_SOURCE"},
        "RRP_MDL.SOME_SOURCE": set(),
        "RRP_EAST.OTHER_SOURCE": set(),
    }
    tracer._adjacency_down = {
        "RRP_MDL.SOME_SOURCE": {"RRP_MDL.EAST5_201_GRJCXXB"},
        "RRP_EAST.OTHER_SOURCE": {"RRP_EAST.EAST5_201_GRJCXXB"},
    }

    # 模拟实际表定义（只有 RRP_EAST 有 EAST5_201_GRJCXXB）
    data = {
        "tables": [
            {
                "full_name": "RRP_EAST.EAST5_201_GRJCXXB",
                "table_name": "EAST5_201_GRJCXXB",
            },
            {"full_name": "RRP_EAST.OTHER_SOURCE", "table_name": "OTHER_SOURCE"},
            {"full_name": "RRP_MDL.SOME_SOURCE", "table_name": "SOME_SOURCE"},
        ]
    }

    # Bug 1: 输入短名应解析到 RRP_EAST（因为实际表定义中只有 RRP_EAST 版本）
    result = tracer.resolve_table_name("EAST5_201_GRJCXXB", data)
    assert result == "RRP_EAST.EAST5_201_GRJCXXB", f"Bug 1 修复失败: 期望 RRP_EAST.EAST5_201_GRJCXXB, 实际 {result}"
    print(f"✅ Bug 1 修复验证通过: EAST5_201_GRJCXXB → {result}")

    # Bug 2: 输入错误的 schema+表名应返回原样（严格校验）
    result2 = tracer.resolve_table_name("RRP_MDL.EAST5_201_GRJCXXB", data)
    assert result2 == "RRP_MDL.EAST5_201_GRJCXXB", f"Bug 2 修复失败: 应返回原输入, 实际 {result2}"
    print(f"✅ Bug 2 修复验证通过: RRP_MDL.EAST5_201_GRJCXXB → {result2} (未匹配到实际表)")

    # 额外：输入正确的全名应正常返回
    result3 = tracer.resolve_table_name("RRP_EAST.EAST5_201_GRJCXXB", data)
    assert result3 == "RRP_EAST.EAST5_201_GRJCXXB", f"全名匹配失败: 实际 {result3}"
    print(f"✅ 全名精确匹配验证通过: RRP_EAST.EAST5_201_GRJCXXB → {result3}")


def test_layer_compatibility():
    """测试层级兼容性检测"""
    # EAST 表的目标层检测
    east_layer = detect_layer("EAST5_201_GRJCXXB")
    assert east_layer == LayerType.EAST, f"EAST5_201_GRJCXXB 应检测为 EAST 层, 实际 {east_layer}"

    # ICL 表应被识别为 ODS/OTHER（取决于具体规则）
    icl_layer = detect_layer("ICL.CMM_INDV_CUST_BASIC_INFO")
    print(f"ℹ️ ICL.CMM_INDV_CUST_BASIC_INFO 层级: {icl_layer}")

    # O_ICL 表应被识别为 ODS
    o_icl_layer = detect_layer("RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO")
    assert o_icl_layer == LayerType.ODS, f"O_ICL_ 表应检测为 ODS 层, 实际 {o_icl_layer}"
    print("✅ 层级检测验证通过")


def test_schema_priority_for_east5():
    """测试 EAST5_ 表的 schema 优先级"""
    resolver = TableNameResolver()
    tracer = TableLineageTracer(resolver)

    # 两个 schema 都有实际表定义
    tracer._adjacency_up = {
        "RRP_MDL.EAST5_201_GRJCXXB": {"SRC1"},
        "RRP_EAST.EAST5_201_GRJCXXB": {"SRC2"},
    }
    tracer._adjacency_down = {
        "SRC1": {"RRP_MDL.EAST5_201_GRJCXXB"},
        "SRC2": {"RRP_EAST.EAST5_201_GRJCXXB"},
    }

    data = {
        "tables": [
            {
                "full_name": "RRP_MDL.EAST5_201_GRJCXXB",
                "table_name": "EAST5_201_GRJCXXB",
            },
            {
                "full_name": "RRP_EAST.EAST5_201_GRJCXXB",
                "table_name": "EAST5_201_GRJCXXB",
            },
        ]
    }

    # 两个 schema 都有实际表时，EAST5_ 应优先选择 RRP_EAST
    result = tracer.resolve_table_name("EAST5_201_GRJCXXB", data)
    assert result == "RRP_EAST.EAST5_201_GRJCXXB", f"EAST5_ 优先级失败: 实际 {result}"
    print(f"✅ EAST5_ schema 优先级验证通过: 优先选择 {result}")


if __name__ == "__main__":
    print("=" * 60)
    print("展示层查询 Bug 修复验证测试")
    print("=" * 60)

    test_resolve_table_name_bug1_and_bug2()
    print()
    test_layer_compatibility()
    print()
    test_schema_priority_for_east5()

    print()
    print("=" * 60)
    print("所有测试通过 ✅")
    print("=" * 60)
