"""
指标口径查询 API 路由

遵循 FastAPI 最佳实践:
  - 使用 Annotated 类型别名声明依赖
  - 使用 Annotated 声明 Path/Query 参数
  - 声明返回类型
  - 同步服务调用使用 def（非 async def）避免阻塞事件循环
"""

from __future__ import annotations

import logging
from typing import Annotated, Optional

from fastapi import APIRouter, Path, Query

from app.models import (
    CaliberQueryMode,
    CaliberQueryRequest,
    CaliberQueryResponse,
    CaliberResultData,
    CaliberSearchRequest,
    CaliberSearchResponse,
)
from app.dependencies import CaliberServiceDep

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/caliber", tags=["指标口径查询"])


@router.post("/query", summary="查询指标口径", response_model=CaliberQueryResponse)
def query_caliber(
    request: CaliberQueryRequest,
    service: CaliberServiceDep,
) -> CaliberQueryResponse:
    try:
        result = service.query_caliber(
            table=request.table,
            field=request.field,
            depth=request.depth,
            direction=request.direction.value,
            data_source=request.data_source,
        )
        return CaliberQueryResponse(
            success=True,
            message="查询成功",
            data=CaliberResultData(**result),
        )
    except Exception as e:
        logger.error("口径查询失败: %s", e, exc_info=True)
        return CaliberQueryResponse(
            success=False,
            message=f"查询失败: {str(e)}",
        )


@router.get("/summary", summary="获取口径摘要文本(Markdown)")
def get_caliber_summary(
    table: Annotated[str, Query(description="目标表名")],
    field: Annotated[str, Query(description="目标字段名")],
    depth: Annotated[int, Query(ge=1, le=20)] = 10,
    direction: CaliberQueryMode = CaliberQueryMode.UPSTREAM,
    data_source: Annotated[Optional[str], Query(description="数据源筛选")] = None,
    service: CaliberServiceDep = None,
) -> dict:
    try:
        text = service.query_caliber_summary(
            table=table,
            field=field,
            depth=depth,
            direction=direction.value,
            data_source=data_source,
        )
        return {
            "success": True,
            "message": "查询成功",
            "data": {"table": table, "field": field, "summary_text": text},
        }
    except Exception as e:
        logger.error("口径摘要生成失败: %s", e, exc_info=True)
        return {
            "success": False,
            "message": f"生成失败: {str(e)}",
            "data": "",
        }


@router.get("/sources", summary="获取直接上游口径(一层)")
def get_direct_sources(
    table: Annotated[str, Query(description="目标表名")],
    field: Annotated[str, Query(description="目标字段名")],
    service: CaliberServiceDep = None,
) -> dict:
    try:
        records = service.get_direct_sources(table=table, field=field)
        return {
            "success": True,
            "message": "查询成功",
            "data": records,
        }
    except Exception as e:
        logger.error("直接上游查询失败: %s", e, exc_info=True)
        return {
            "success": False,
            "message": f"查询失败: {str(e)}",
            "data": [],
        }


@router.get("/targets", summary="获取直接下游去向(一层)")
def get_direct_targets(
    table: Annotated[str, Query(description="源表名")],
    field: Annotated[str, Query(description="源字段名")],
    service: CaliberServiceDep = None,
) -> dict:
    try:
        records = service.get_direct_targets(table=table, field=field)
        return {
            "success": True,
            "message": "查询成功",
            "data": records,
        }
    except Exception as e:
        logger.error("直接下游查询失败: %s", e, exc_info=True)
        return {
            "success": False,
            "message": f"查询失败: {str(e)}",
            "data": [],
        }


@router.get("/search", summary="搜索指标口径")
def search_caliber(
    keyword: Annotated[str, Query(min_length=1, description="搜索关键词")],
    limit: Annotated[int, Query(ge=1, le=500, description="返回数量限制")] = 50,
    data_source: Annotated[Optional[str], Query(description="数据源筛选")] = None,
    service: CaliberServiceDep = None,
) -> dict:
    try:
        results = service.search_indicators(
            keyword=keyword,
            limit=limit,
            data_source=data_source,
        )
        return {
            "success": True,
            "message": "搜索成功",
            "data": results,
        }
    except Exception as e:
        logger.error("口径搜索失败: %s", e, exc_info=True)
        return {
            "success": False,
            "message": f"搜索失败: {str(e)}",
            "data": [],
        }


@router.get("/fields", summary="获取表中有口径数据的字段列表")
def get_caliber_fields(
    table: Annotated[str, Query(description="目标表名(支持 schema.table 格式)")],
    data_source: Annotated[Optional[str], Query(description="数据源筛选")] = None,
    service: CaliberServiceDep = None,
) -> dict:
    try:
        fields = service.get_fields_with_caliber(table=table, data_source=data_source)
        return {
            "success": True,
            "message": "查询成功",
            "data": {
                "table": table,
                "fields": fields,
                "total": len(fields),
            },
        }
    except Exception as e:
        logger.error("口径字段查询失败: %s", e, exc_info=True)
        return {
            "success": False,
            "message": f"查询失败: {str(e)}",
            "data": {"table": table, "fields": [], "total": 0},
        }


@router.get("/datasources/list", summary="获取数据源列表")
def get_datasources(
    service: CaliberServiceDep = None,
) -> dict:
    try:
        datasources = service.get_datasources()
        return {
            "success": True,
            "message": "查询成功",
            "data": datasources,
        }
    except Exception as e:
        logger.error("获取数据源列表失败: %s", e, exc_info=True)
        return {
            "success": False,
            "message": f"查询失败: {str(e)}",
            "data": [],
        }


@router.get("/trace", summary="快捷口径追溯(GET)")
def get_caliber(
    table: Annotated[str, Query(description="目标表名")],
    field: Annotated[str, Query(description="目标字段名")],
    depth: Annotated[int, Query(ge=1, le=20, description="追溯深度")] = 10,
    direction: CaliberQueryMode = CaliberQueryMode.UPSTREAM,
    data_source: Annotated[Optional[str], Query(description="数据源筛选")] = None,
    service: CaliberServiceDep = None,
) -> dict:
    try:
        result = service.query_caliber(
            table=table,
            field=field,
            depth=depth,
            direction=direction.value,
            data_source=data_source,
        )
        return {
            "success": True,
            "message": "查询成功",
            "data": result,
        }
    except Exception as e:
        logger.error("口径查询失败: %s", e, exc_info=True)
        return {
            "success": False,
            "message": f"查询失败: {str(e)}",
            "data": None,
        }
