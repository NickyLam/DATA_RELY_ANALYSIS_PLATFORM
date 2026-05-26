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

from app.dependencies import LineageServiceDep, ParserServiceDep
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
    lineage_service: LineageServiceDep,
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
    "/tables/{table}/fields",
    summary="获取表字段名列表",
    description="根据表名获取字段名列表，兼容旧版 api_server 端点",
)
def get_table_fields(
    table: str,
    parser_service: ParserServiceDep,
) -> dict:
    """获取指定表的字段名列表。

    查找策略（与旧版 api_server.py 一致）：
    1. 精确匹配 .tab 表（table_name 或 full_name）
    2. 从字段映射中查找过程表（短名或全名）
    3. 模糊匹配过程表
    """
    data = parser_service.get_current_data()
    if not data:
        raise HTTPException(status_code=404, detail="无可用数据")

    norm_name = table.strip().upper()

    # 1. 精确匹配 .tab 表
    for t in data.get("tables", []):
        tbl_name = (t.get("table_name") or "").upper()
        full_name = (t.get("full_name") or "").upper()
        if tbl_name == norm_name or full_name == norm_name:
            columns = t.get("columns", [])
            field_names = [c.get("name", "") for c in columns if c.get("name")]
            return {"success": True, "data": field_names}

    # 2. 从字段映射中查找过程表（按 target_table 聚合字段名）
    field_mappings = data.get("field_mappings", [])
    proc_fields: dict[str, set[str]] = {}
    for fm in field_mappings:
        tgt_table = (fm.get("target_table") or "").upper()
        tgt_col = fm.get("target_column", "")
        if tgt_table and tgt_col:
            proc_fields.setdefault(tgt_table, set()).add(tgt_col)

    for proc_tbl, fields in proc_fields.items():
        short = proc_tbl.split(".")[-1] if "." in proc_tbl else proc_tbl
        if short == norm_name or proc_tbl == norm_name:
            return {"success": True, "data": sorted(fields)}

    # 3. 模糊匹配过程表
    for proc_tbl, fields in proc_fields.items():
        if norm_name in proc_tbl or proc_tbl.endswith(norm_name):
            return {"success": True, "data": sorted(fields)}

    raise HTTPException(status_code=404, detail=f"未找到表: {table}")


@router.get(
    "/tables/{table}",
    response_model=SingleTableInfoResponse,
    summary="获取表详细信息",
    description="根据表名获取表的详细结构信息",
)
def get_table_info(
    table: str,
    parser_service: ParserServiceDep,
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
    lineage_service: LineageServiceDep,
) -> SystemStatsResponse:
    stats = lineage_service.get_system_stats()

    return SystemStatsResponse(data=SystemStatsData(**stats))


@router.post(
    "/cache/rebuild",
    summary="重建缓存索引",
    description="强制清空并重建内存索引和图预处理数据",
)
def rebuild_cache(
    lineage_service: LineageServiceDep,
) -> dict:
    lineage_service.rebuild_indexes()

    return {
        "success": True,
        "message": "索引重建完成",
    }


@router.get(
    "/lineage/edge-caliber",
    summary="懒加载单条边的口径详情",
    description=(
        "用于前端在血缘图上点击某条边时按需拉取该边的 transform_logic / where / join 等口径信息。"
        "复用 UnifiedTracer 的 O(1) 索引查找，未命中时返回 data=None。"
    ),
)
def get_edge_caliber(
    src: Annotated[str, Query(min_length=1, description="源表（可带或不带 schema）")],
    src_col: Annotated[str, Query(min_length=1, description="源字段")],
    tgt: Annotated[str, Query(min_length=1, description="目标表")],
    tgt_col: Annotated[str, Query(min_length=1, description="目标字段")],
    lineage_service: LineageServiceDep,
    proc: Annotated[str, Query(description="可选：限定过程名以精确匹配")] = "",
) -> dict:
    info = lineage_service.get_edge_caliber(src, src_col, tgt, tgt_col, proc or "")
    return {
        "success": True,
        "data": info,
    }


@router.get(
    "/lineage/node-detail",
    summary="懒加载单个节点详情",
    description=(
        "用于前端在血缘图上点击节点时按需拉取该表的字段列表、上下游表、关联过程，"
        "避免在 trace 阶段一次性塞入大量字段信息。"
    ),
)
def get_node_detail(
    table: Annotated[str, Query(min_length=1, description="表名（可带或不带 schema）")],
    lineage_service: LineageServiceDep,
) -> dict:
    detail = lineage_service.get_node_detail(table)
    if detail is None:
        raise HTTPException(status_code=404, detail=f"未找到节点: {table}")
    return {
        "success": True,
        "data": detail,
    }


@router.get(
    "/lineage/node-caliber",
    summary="节点指标口径概览卡（节点浮窗用）",
    description=(
        "返回单个字段的口径概览：指标名、技术口径摘要、统计、质量标记、"
        "完整加工规格。P5 迁移：原 /api/caliber/card-summary 后续将下线。"
    ),
)
def get_node_caliber(
    table: Annotated[str, Query(min_length=1, description="表名")],
    field: Annotated[str, Query(min_length=1, description="字段名")],
    lineage_service: LineageServiceDep,
    direction: Annotated[str, Query(description="upstream/downstream/both")] = "upstream",
    depth: Annotated[int, Query(ge=1, le=20)] = 10,
    data_source: Annotated[str, Query(description="可选数据源筛选")] = "",
) -> dict:
    return lineage_service.build_summary_card(
        table=table,
        field=field,
        direction=direction,
        depth=depth,
        data_source=data_source or None,
    )
