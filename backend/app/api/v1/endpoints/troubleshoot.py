"""
问题排查 API
"""
from typing import List

from fastapi import APIRouter, Depends, Query

from app.schemas.troubleshoot import (
    QuickSearchRequest,
    QuickSearchResponse,
    QuickSearchResult,
    TroubleshootQueryRequest,
    TroubleshootResult,
)
from app.services.troubleshoot_service import TroubleshootService

router = APIRouter()


def get_troubleshoot_service() -> TroubleshootService:
    """
    获取问题排查服务（依赖注入）
    """
    return TroubleshootService()


@router.post("/quick-search", response_model=QuickSearchResponse)
async def quick_search(
    request: QuickSearchRequest,
    service: TroubleshootService = Depends(get_troubleshoot_service),
):
    """
    快速搜索表或字段
    """
    results = await service.quick_search(
        keyword=request.keyword,
        search_type=request.search_type,
        limit=request.limit,
    )
    
    return QuickSearchResponse(
        results=results,
        total_count=len(results),
    )


@router.get("/search", response_model=QuickSearchResponse)
async def search_objects(
    keyword: str = Query(..., description="搜索关键词"),
    search_type: str = Query("all", description="搜索类型：all, table, field"),
    limit: int = Query(10, ge=1, le=50, description="返回数量限制"),
    service: TroubleshootService = Depends(get_troubleshoot_service),
):
    """
    搜索表或字段
    """
    results = await service.quick_search(
        keyword=keyword,
        search_type=search_type,
        limit=limit,
    )
    
    return QuickSearchResponse(
        results=results,
        total_count=len(results),
    )


@router.post("/analyze", response_model=TroubleshootResult)
async def analyze_object(
    request: TroubleshootQueryRequest,
    service: TroubleshootService = Depends(get_troubleshoot_service),
):
    """
    分析对象问题
    """
    result = await service.troubleshoot(
        object_name=request.object_name,
        object_type=request.object_type,
        include_runtime=request.include_runtime,
        include_changes=request.include_changes,
        days_limit=request.days_limit,
    )
    
    return result


@router.get("/analyze/{object_name}", response_model=TroubleshootResult)
async def analyze_object_by_name(
    object_name: str,
    object_type: str = Query("table", description="对象类型：table 或 field"),
    include_runtime: bool = Query(True, description="是否包含运行态数据"),
    include_changes: bool = Query(True, description="是否包含变更历史"),
    days_limit: int = Query(7, ge=1, le=30, description="查询天数限制"),
    service: TroubleshootService = Depends(get_troubleshoot_service),
):
    """
    根据名称分析对象问题
    """
    result = await service.troubleshoot(
        object_name=object_name,
        object_type=object_type,
        include_runtime=include_runtime,
        include_changes=include_changes,
        days_limit=days_limit,
    )
    
    return result


@router.get("/statistics")
async def get_statistics(
    service: TroubleshootService = Depends(get_troubleshoot_service),
):
    """
    获取统计摘要
    """
    return await service.get_statistics_summary()