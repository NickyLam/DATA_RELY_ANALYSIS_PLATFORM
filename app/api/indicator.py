"""
指标血缘查询 API 路由
"""

from __future__ import annotations

import logging
from typing import Annotated

from fastapi import APIRouter, HTTPException, Query

from app.dependencies import IndicatorServiceDep
from app.models import (
    IndicatorDetailResponse,
    IndicatorLineageResponse,
    IndicatorPipelineResponse,
    IndicatorSearchResponse,
    IndicatorStatsResponse,
)

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/indicator", tags=["指标血缘查询"])


@router.get("/search", response_model=IndicatorSearchResponse, summary="搜索指标")
def search_indicators(
    keyword: Annotated[str, Query(min_length=1, description="搜索关键词(指标编号)")],
    limit: Annotated[int, Query(ge=1, le=500, description="返回数量限制")] = 50,
    service: IndicatorServiceDep = None,
) -> dict:
    results = service.search_indicators(keyword=keyword, limit=limit)
    return {
        "success": True,
        "message": "搜索成功",
        "data": results,
    }


@router.get("/detail", response_model=IndicatorDetailResponse, summary="获取指标详情")
def get_indicator_detail(
    index_no: Annotated[str, Query(min_length=1, description="指标编号")],
    service: IndicatorServiceDep = None,
) -> dict:
    detail = service.get_indicator_detail(index_no=index_no)
    if not detail:
        raise HTTPException(status_code=404, detail="指定的指标不存在")
    return {
        "success": True,
        "message": "查询成功",
        "data": detail,
    }


@router.get("/lineage", response_model=IndicatorLineageResponse, summary="查询指标血缘图")
def get_indicator_lineage(
    index_no: Annotated[str, Query(min_length=1, description="指标编号")],
    measure: Annotated[str, Query(description="指标度量(可选)")] = "",
    direction: Annotated[str, Query(description="查询方向: upstream/downstream/both")] = "upstream",
    depth: Annotated[int, Query(ge=1, le=20, description="追溯深度")] = 10,
    service: IndicatorServiceDep = None,
) -> dict:
    result = service.trace_indicator(
        index_no=index_no,
        measure=measure,
        direction=direction,
        depth=depth,
    )
    return {
        "success": True,
        "message": "查询成功",
        "data": result,
    }


@router.get("/pipeline", response_model=IndicatorPipelineResponse, summary="获取指标加工流水线")
def get_indicator_pipeline(
    index_no: Annotated[str, Query(min_length=1, description="指标编号")],
    measure: Annotated[str, Query(description="指标度量(可选)")] = "",
    service: IndicatorServiceDep = None,
) -> dict:
    steps = service.get_pipeline_steps(index_no=index_no, measure=measure)
    return {
        "success": True,
        "message": "查询成功",
        "data": {
            "index_no": index_no,
            "measure": measure,
            "steps": steps,
            "total_steps": len(steps),
        },
    }


@router.get("/stats", response_model=IndicatorStatsResponse, summary="获取指标体系统计信息")
def get_indicator_stats(
    service: IndicatorServiceDep,
) -> dict:
    stats = service.get_stats()
    return {
        "success": True,
        "message": "查询成功",
        "data": stats,
    }


@router.get("/bridge-lineage", summary="桥接到字段血缘")
def bridge_to_field_lineage(
    table_name: Annotated[str, Query(min_length=1, description="表名")],
    service: IndicatorServiceDep = None,
) -> dict:
    result = service.bridge_to_field_lineage(table_name=table_name)
    return result


@router.get("/source-tables", summary="获取指标源表列表")
def get_indicator_source_tables(
    index_no: Annotated[str, Query(min_length=1, description="指标编号")],
    service: IndicatorServiceDep = None,
) -> dict:
    tables = service.get_indicator_source_tables(index_no=index_no)
    return {
        "success": True,
        "message": "查询成功",
        "data": {
            "index_no": index_no,
            "tables": tables,
            "count": len(tables),
        },
    }
