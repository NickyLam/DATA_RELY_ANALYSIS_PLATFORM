"""
指标血缘查询 API 路由
"""

from __future__ import annotations

import logging
from typing import Annotated

from fastapi import APIRouter, Query

from app.dependencies import IndicatorServiceDep

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/indicator", tags=["指标血缘查询"])


@router.get("/search", summary="搜索指标")
def search_indicators(
    keyword: Annotated[str, Query(min_length=1, description="搜索关键词(指标编号)")],
    limit: Annotated[int, Query(ge=1, le=500, description="返回数量限制")] = 50,
    service: IndicatorServiceDep = None,
) -> dict:
    try:
        results = service.search_indicators(keyword=keyword, limit=limit)
        return {
            "success": True,
            "message": "搜索成功",
            "data": results,
        }
    except Exception as e:
        logger.error("指标搜索失败: %s", e, exc_info=True)
        return {
            "success": False,
            "message": f"搜索失败: {str(e)}",
            "data": [],
        }


@router.get("/detail", summary="获取指标详情")
def get_indicator_detail(
    index_no: Annotated[str, Query(min_length=1, description="指标编号")],
    service: IndicatorServiceDep = None,
) -> dict:
    try:
        detail = service.get_indicator_detail(index_no=index_no)
        if not detail:
            return {
                "success": False,
                "message": f"未找到指标: {index_no}",
                "data": {},
            }
        return {
            "success": True,
            "message": "查询成功",
            "data": detail,
        }
    except Exception as e:
        logger.error("指标详情查询失败: %s", e, exc_info=True)
        return {
            "success": False,
            "message": f"查询失败: {str(e)}",
            "data": {},
        }


@router.get("/lineage", summary="查询指标血缘图")
def get_indicator_lineage(
    index_no: Annotated[str, Query(min_length=1, description="指标编号")],
    measure: Annotated[str, Query(description="指标度量(可选)")] = "",
    direction: Annotated[str, Query(description="查询方向: upstream/downstream/both")] = "upstream",
    depth: Annotated[int, Query(ge=1, le=20, description="追溯深度")] = 10,
    service: IndicatorServiceDep = None,
) -> dict:
    try:
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
    except Exception as e:
        logger.error("指标血缘查询失败: %s", e, exc_info=True)
        return {
            "success": False,
            "message": f"查询失败: {str(e)}",
            "data": None,
        }


@router.get("/pipeline", summary="获取指标加工流水线")
def get_indicator_pipeline(
    index_no: Annotated[str, Query(min_length=1, description="指标编号")],
    measure: Annotated[str, Query(description="指标度量(可选)")] = "",
    service: IndicatorServiceDep = None,
) -> dict:
    try:
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
    except Exception as e:
        logger.error("指标流水线查询失败: %s", e, exc_info=True)
        return {
            "success": False,
            "message": f"查询失败: {str(e)}",
            "data": {"index_no": index_no, "steps": [], "total_steps": 0},
        }


@router.get("/stats", summary="获取指标体系统计信息")
def get_indicator_stats(
    service: IndicatorServiceDep,
) -> dict:
    try:
        stats = service.get_stats()
        return {
            "success": True,
            "message": "查询成功",
            "data": stats,
        }
    except Exception as e:
        logger.error("指标统计查询失败: %s", e, exc_info=True)
        return {
            "success": False,
            "message": f"查询失败: {str(e)}",
            "data": {},
        }


@router.get("/bridge-lineage", summary="桥接到字段血缘")
def bridge_to_field_lineage(
    table_name: Annotated[str, Query(min_length=1, description="表名")],
    service: IndicatorServiceDep = None,
) -> dict:
    try:
        result = service.bridge_to_field_lineage(table_name=table_name)
        return result
    except Exception as e:
        logger.error("桥接字段血缘失败: %s", e, exc_info=True)
        return {
            "success": False,
            "message": f"查询失败: {str(e)}",
            "data": {},
        }


@router.get("/source-tables", summary="获取指标源表列表")
def get_indicator_source_tables(
    index_no: Annotated[str, Query(min_length=1, description="指标编号")],
    service: IndicatorServiceDep = None,
) -> dict:
    try:
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
    except Exception as e:
        logger.error("获取指标源表失败: %s", e, exc_info=True)
        return {
            "success": False,
            "message": f"查询失败: {str(e)}",
            "data": {"index_no": index_no, "tables": [], "count": 0},
        }
