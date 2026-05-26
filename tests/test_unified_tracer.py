"""UnifiedTracer 烟雾测试

测试目标：
  1. trace() 在 lineage-only 模式（with_caliber=False）下返回正确的 nodes+edges
  2. trace(with_caliber=True) 时 caliber_steps 字典正确填充
  3. get_edge_caliber 单边 O(1) 查询命中
  4. get_node_detail 返回字段列表 + 上下游
  5. 没有 caliber_infos 时 trace 不崩溃
"""

from __future__ import annotations

import pytest

from core.models import (
    ColumnInfo,
    FieldMapping,
    ProcedureInfo,
    SourceLocation,
    TableInfo,
    TableLineage,
)
from core.unified_tracer import UnifiedTracer


@pytest.fixture
def sample_data():
    """
    构造一个最小血缘场景：
      RRP_ODS.SRC_TBL.SRC_COL → RRP_MDL.MID_TBL.MID_COL → RRP_EAST.TGT_TBL.TGT_COL
      由 P_DEMO 过程加工，TGT_COL = MID_COL（直传）
      MID_COL = NVL(SRC_COL, 0)（口径携带 transform_logic）
    """
    tables = {
        "RRP_ODS.SRC_TBL": TableInfo(
            schema="RRP_ODS", table_name="SRC_TBL", full_name="RRP_ODS.SRC_TBL",
            columns=[ColumnInfo(name="SRC_COL", data_type="VARCHAR2(10)", comment="源字段")],
        ),
        "SRC_TBL": TableInfo(
            schema="RRP_ODS", table_name="SRC_TBL", full_name="RRP_ODS.SRC_TBL",
            columns=[ColumnInfo(name="SRC_COL", data_type="VARCHAR2(10)", comment="源字段")],
        ),
        "RRP_MDL.MID_TBL": TableInfo(
            schema="RRP_MDL", table_name="MID_TBL", full_name="RRP_MDL.MID_TBL",
            columns=[ColumnInfo(name="MID_COL", data_type="VARCHAR2(10)")],
        ),
        "MID_TBL": TableInfo(
            schema="RRP_MDL", table_name="MID_TBL", full_name="RRP_MDL.MID_TBL",
            columns=[ColumnInfo(name="MID_COL", data_type="VARCHAR2(10)")],
        ),
        "RRP_EAST.TGT_TBL": TableInfo(
            schema="RRP_EAST", table_name="TGT_TBL", full_name="RRP_EAST.TGT_TBL",
            columns=[ColumnInfo(name="TGT_COL", data_type="VARCHAR2(10)")],
        ),
        "TGT_TBL": TableInfo(
            schema="RRP_EAST", table_name="TGT_TBL", full_name="RRP_EAST.TGT_TBL",
            columns=[ColumnInfo(name="TGT_COL", data_type="VARCHAR2(10)")],
        ),
    }

    proc = ProcedureInfo(
        schema="RRP_PROC",
        proc_name="P_DEMO",
        full_name="RRP_PROC.P_DEMO",
        source_tables=["RRP_ODS.SRC_TBL", "RRP_MDL.MID_TBL"],
        target_tables=["RRP_MDL.MID_TBL", "RRP_EAST.TGT_TBL"],
    )
    procedures = {"RRP_PROC.P_DEMO": proc}

    table_lineages = [
        TableLineage(
            source_table="RRP_ODS.SRC_TBL",
            target_table="RRP_MDL.MID_TBL",
            procedure="RRP_PROC.P_DEMO",
        ),
        TableLineage(
            source_table="RRP_MDL.MID_TBL",
            target_table="RRP_EAST.TGT_TBL",
            procedure="RRP_PROC.P_DEMO",
        ),
    ]

    field_mappings = [
        FieldMapping(
            source_table="RRP_ODS.SRC_TBL", source_column="SRC_COL",
            target_table="RRP_MDL.MID_TBL", target_column="MID_COL",
            transform_logic="NVL(SRC_COL, 0)",
            procedure="RRP_PROC.P_DEMO",
        ),
        FieldMapping(
            source_table="RRP_MDL.MID_TBL", source_column="MID_COL",
            target_table="RRP_EAST.TGT_TBL", target_column="TGT_COL",
            transform_logic="",
            procedure="RRP_PROC.P_DEMO",
        ),
    ]

    caliber_infos = [
        {
            "target_table": "RRP_MDL.MID_TBL",
            "target_column": "MID_COL",
            "source_table": "RRP_ODS.SRC_TBL",
            "source_column": "SRC_COL",
            "transform_logic": "NVL(SRC_COL, 0)",
            "procedure": "RRP_PROC.P_DEMO",
            "where_conditions": [
                {"raw_text": "STATUS = '1'", "condition_type": "EQUAL",
                 "tables_involved": ["SRC_TBL"], "fields_involved": ["STATUS"]}
            ],
            "join_conditions": [],
            "data_source": "oracle",
            "confidence": 1.0,
        },
        {
            "target_table": "RRP_EAST.TGT_TBL",
            "target_column": "TGT_COL",
            "source_table": "RRP_MDL.MID_TBL",
            "source_column": "MID_COL",
            "transform_logic": "",
            "procedure": "RRP_PROC.P_DEMO",
            "where_conditions": [],
            "join_conditions": [],
            "data_source": "oracle",
            "confidence": 1.0,
        },
    ]

    return {
        "tables": tables,
        "procedures": procedures,
        "table_lineages": table_lineages,
        "field_mappings": field_mappings,
        "caliber_infos": caliber_infos,
    }


def test_trace_upstream_lightweight(sample_data):
    tracer = UnifiedTracer(**sample_data)
    result = tracer.trace("RRP_EAST.TGT_TBL", "TGT_COL", depth=5, mode="upstream", with_caliber=False)

    node_keys = {n.id for n in result.nodes}
    assert "RRP_EAST.TGT_TBL.TGT_COL" in node_keys
    assert any("MID_COL" in nid for nid in node_keys)
    assert any("SRC_COL" in nid for nid in node_keys)

    assert len(result.edges) >= 2
    assert result.caliber_steps == {}
    assert result.query_time_ms >= 0


def test_trace_with_caliber_populates_steps(sample_data):
    tracer = UnifiedTracer(**sample_data)
    result = tracer.trace("RRP_EAST.TGT_TBL", "TGT_COL", depth=5, mode="upstream", with_caliber=True)

    assert len(result.caliber_steps) >= 1
    # 找到至少一条边对应 SRC_COL → MID_COL 这步的 caliber 详情
    found_nvl = False
    for step in result.caliber_steps.values():
        if step.get("transform_logic") == "NVL(SRC_COL, 0)":
            found_nvl = True
            break
    assert found_nvl, "应找到 NVL 口径详情"


def test_get_edge_caliber_direct(sample_data):
    tracer = UnifiedTracer(**sample_data)
    info = tracer.get_edge_caliber(
        "RRP_ODS.SRC_TBL", "SRC_COL",
        "RRP_MDL.MID_TBL", "MID_COL",
        procedure="RRP_PROC.P_DEMO",
    )
    assert info is not None
    assert info["transform_logic"] == "NVL(SRC_COL, 0)"
    assert len(info["where_conditions"]) == 1


def test_get_edge_caliber_short_table_match(sample_data):
    tracer = UnifiedTracer(**sample_data)
    info = tracer.get_edge_caliber(
        "SRC_TBL", "SRC_COL",
        "MID_TBL", "MID_COL",
    )
    assert info is not None
    assert info["target_column"] == "MID_COL"


def test_get_edge_caliber_miss(sample_data):
    tracer = UnifiedTracer(**sample_data)
    info = tracer.get_edge_caliber("NO_TBL", "NO_COL", "NA_TBL", "NA_COL")
    assert info is None


def test_get_node_detail(sample_data):
    tracer = UnifiedTracer(**sample_data)
    detail = tracer.get_node_detail("RRP_MDL.MID_TBL")
    assert detail["table"] == "RRP_MDL.MID_TBL"
    assert detail["short_name"] == "MID_TBL"
    assert any(f["name"] == "MID_COL" for f in detail["fields"])
    assert "RRP_PROC.P_DEMO" in detail["procedures"]


def test_trace_without_caliber_infos(sample_data):
    data = dict(sample_data)
    data["caliber_infos"] = []
    tracer = UnifiedTracer(**data)
    result = tracer.trace("RRP_EAST.TGT_TBL", "TGT_COL", depth=5, mode="upstream", with_caliber=True)
    # 即使请求 with_caliber，没有 caliber_infos 时也不应崩溃
    assert result.caliber_steps == {}
    assert len(result.edges) >= 2
    # get_edge_caliber 在没有 caliber 时返回 None
    assert tracer.get_edge_caliber("RRP_ODS.SRC_TBL", "SRC_COL", "RRP_MDL.MID_TBL", "MID_COL") is None


def test_trace_downstream(sample_data):
    tracer = UnifiedTracer(**sample_data)
    result = tracer.trace("RRP_ODS.SRC_TBL", "SRC_COL", depth=5, mode="downstream", with_caliber=False)
    assert any("TGT_COL" in n.id for n in result.nodes)


def test_trace_both_direction(sample_data):
    tracer = UnifiedTracer(**sample_data)
    result = tracer.trace("RRP_MDL.MID_TBL", "MID_COL", depth=5, mode="both", with_caliber=False)
    node_keys = {n.id for n in result.nodes}
    assert any("SRC_COL" in nid for nid in node_keys)
    assert any("TGT_COL" in nid for nid in node_keys)


def test_factory_creates_unified(sample_data):
    from app.services.tracer_factory import TracerFactory
    factory = TracerFactory()
    tracer = factory.create_unified_tracer(**sample_data)
    assert tracer is not None
    # 第二次调用返回缓存
    tracer2 = factory.create_unified_tracer(**sample_data)
    assert tracer is tracer2
    factory.invalidate()
    assert factory.unified_tracer is None
