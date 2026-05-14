"""
血缘查询 API 接口
表搜索、血缘关系查询、系统统计

遵循 FastAPI 最佳实践:
  - 使用 Annotated 类型别名声明依赖
  - 同步服务调用使用 def（非 async def）
  - 声明返回类型
"""

from __future__ import annotations

import logging
from typing import Annotated

from fastapi import APIRouter, HTTPException, Query

from app.dependencies import CaliberServiceDep, LineageServiceDep, ParserServiceDep
from app.models import (
    LineageQueryOptions,
    LineageQueryRequest,
    LineageQueryResponse,
    LineageResultData,
    SingleTableInfoResponse,
    SystemStatsData,
    SystemStatsResponse,
    TableInfoResponse,
    TableListItem,
)

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api", tags=["血缘查询"])


@router.get(
    "/tables",
    response_model=TableInfoResponse,
    summary="搜索表列表",
    description="通过关键词搜索表名，支持模糊匹配和倒排索引加速",
)
def search_tables(
    keyword: Annotated[str, Query(min_length=1, description="搜索关键词")],
    limit: Annotated[int, Query(ge=1, le=500, description="返回数量限制")] = 50,
    lineage_service: LineageServiceDep = None,
) -> TableInfoResponse:
    if not keyword.strip():
        raise HTTPException(status_code=400, detail="请提供搜索关键词")

    results = lineage_service.search_tables(keyword, limit)

    table_list = [
        TableListItem(**item) for item in results
    ]

    return TableInfoResponse(data=table_list)


@router.get(
    "/procedures",
    summary="搜索存储过程",
    description="通过关键词搜索存储过程名称",
)
def search_procedures(
    keyword: Annotated[str, Query(min_length=1, description="搜索关键词")],
    limit: Annotated[int, Query(ge=1, le=500, description="返回数量限制")] = 50,
    lineage_service: LineageServiceDep = None,
) -> dict:
    if not keyword.strip():
        raise HTTPException(status_code=400, detail="请提供搜索关键词")

    results = lineage_service.search_procedures(keyword, limit)

    return {
        "success": True,
        "data": results,
    }


@router.post(
    "/lineage/query",
    response_model=LineageQueryResponse,
    summary="查询血缘关系",
    description="查询指定表/字段的上下游血缘关系，支持深度控制和缓存优化",
)
def query_lineage(
    request: LineageQueryRequest,
    lineage_service: LineageServiceDep = None,
) -> LineageQueryResponse:
    options = request.options or LineageQueryOptions()

    result = lineage_service.query_lineage(
        table=request.table,
        field=request.field,
        depth=request.depth,
        mode=request.mode.value,
        include_fields=options.include_fields,
        limit=options.limit,
        use_cache=options.use_cache,
    )

    return LineageQueryResponse(data=LineageResultData(**result))


@router.get(
    "/tables/{table}",
    response_model=SingleTableInfoResponse,
    summary="获取表详细信息",
    description="根据表名获取表的详细结构信息",
)
def get_table_info(
    table: str,
    parser_service: ParserServiceDep = None,
) -> SingleTableInfoResponse:
    data = parser_service.get_current_data()
    if not data:
        raise HTTPException(status_code=404, detail="无可用数据")

    for t in data.get("tables", []):
        if t.get("full_name", "").upper() == table.upper():
            return SingleTableInfoResponse(data=t)

    raise HTTPException(status_code=404, detail=f"表不存在: {table}")


@router.get(
    "/lineage/{table}/{field}",
    summary="快捷血缘查询(GET)",
    description="GET 方式快速查询字段级血缘",
)
def query_lineage_get(
    table: str,
    field: str,
    depth: Annotated[int, Query(ge=1, le=20)] = 3,
    lineage_service: LineageServiceDep = None,
) -> LineageQueryResponse:
    result = lineage_service.query_lineage(
        table=table,
        field=field,
        depth=depth,
        mode="both",
    )

    return LineageQueryResponse(data=LineageResultData(**result))


@router.get(
    "/stats",
    response_model=SystemStatsResponse,
    summary="系统统计信息",
    description="获取当前系统的数据统计和缓存状态",
)
def get_system_stats(
    lineage_service: LineageServiceDep = None,
) -> SystemStatsResponse:
    stats = lineage_service.get_system_stats()

    return SystemStatsResponse(data=SystemStatsData(**stats))


@router.post(
    "/cache/rebuild",
    summary="重建缓存索引",
    description="强制清空并重建内存索引和图预处理数据",
)
def rebuild_cache(
    lineage_service: LineageServiceDep = None,
    caliber_service: CaliberServiceDep = None,
) -> dict:
    lineage_service.rebuild_indexes()
    caliber_service.rebuild_indexes()

    return {
        "success": True,
        "message": "索引重建完成",
    }
