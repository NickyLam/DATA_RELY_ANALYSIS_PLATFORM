"""
指标口径查询 API 路由
"""

from __future__ import annotations

import logging
from typing import Optional

from fastapi import APIRouter, Depends, Query

from app.models import (
    CaliberQueryMode,
    CaliberQueryRequest,
    CaliberQueryResponse,
    CaliberSearchRequest,
    CaliberSearchResponse,
)
from app.services.caliber_service import CaliberService
from app.dependencies import get_caliber_service

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/caliber", tags=["指标口径查询"])


@router.post("/query", summary="查询指标口径")
async def query_caliber(
    request: CaliberQueryRequest,
    service: CaliberService = Depends(get_caliber_service),
) -> dict:
    """根据表名+字段名查询指标口径，追溯数据的完整加工链路和筛选条件"""
    try:
        result = service.query_caliber(
            table=request.table,
            field=request.field,
            depth=request.depth,
            direction=request.direction.value,
            data_source=request.data_source,
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


@router.get("/summary/{table}/{field}", summary="获取口径摘要文本(Markdown)")
async def get_caliber_summary(
    table: str,
    field: str,
    depth: int = Query(default=10, ge=1, le=20),
    direction: CaliberQueryMode = Query(default=CaliberQueryMode.UPSTREAM),
    data_source: Optional[str] = Query(default=None),
    service: CaliberService = Depends(get_caliber_service),
) -> dict:
    """获取指标口径的可读 Markdown 摘要文本，适合复制到文档或报告"""
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


@router.get("/sources/{table}/{field}", summary="获取直接上游口径(一层)")
async def get_direct_sources(
    table: str,
    field: str,
    service: CaliberService = Depends(get_caliber_service),
) -> dict:
    """获取目标字段的直接上游来源（仅一层，不递归追溯）"""
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


@router.get("/targets/{table}/{field}", summary="获取直接下游去向(一层)")
async def get_direct_targets(
    table: str,
    field: str,
    service: CaliberService = Depends(get_caliber_service),
) -> dict:
    """获取源字段的直接下游目标（仅一层，不递归追溯）"""
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
async def search_caliber(
    keyword: str = Query(..., min_length=1, description="搜索关键词"),
    limit: int = Query(default=50, ge=1, le=500, description="返回数量限制"),
    data_source: Optional[str] = Query(default=None, description="数据源筛选"),
    service: CaliberService = Depends(get_caliber_service),
) -> dict:
    """按关键词搜索指标口径（支持表名、字段名模糊搜索）"""
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


@router.get("/datasources/list", summary="获取数据源列表")
async def get_datasources(
    service: CaliberService = Depends(get_caliber_service),
) -> dict:
    """获取系统支持的数据源列表"""
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


@router.get("/{table}/{field}", summary="快捷口径查询(GET)")
async def get_caliber(
    table: str,
    field: str,
    depth: int = Query(default=10, ge=1, le=20, description="追溯深度"),
    direction: CaliberQueryMode = Query(default=CaliberQueryMode.UPSTREAM, description="查询方向"),
    data_source: Optional[str] = Query(default=None, description="数据源筛选"),
    service: CaliberService = Depends(get_caliber_service),
) -> dict:
    """快捷 GET 方式查询指标口径"""
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
