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

router = APIRouter(
    prefix="/api/caliber",
    tags=["指标口径查询 (Deprecated)"],
    deprecated=True,
)


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
    service: CaliberServiceDep,
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


@router.get("/pipeline", summary="获取加工链路Pipeline视图数据")
def get_caliber_pipeline(
    table: Annotated[str, Query(description="目标表名")],
    field: Annotated[str, Query(description="目标字段名")],
    depth: Annotated[int, Query(ge=1, le=20)] = 10,
    direction: CaliberQueryMode = CaliberQueryMode.UPSTREAM,
    data_source: Annotated[Optional[str], Query(description="数据源筛选")] = None,
    service: CaliberServiceDep = None,
) -> dict:
    try:
        result = service.build_pipeline_view(
            table=table, field=field,
            depth=depth, direction=direction.value,
            data_source=data_source,
        )
        return result
    except Exception as e:
        logger.error("Pipeline查询失败: %s", e, exc_info=True)
        return {"success": False, "message": f"查询失败: {str(e)}", "data": None}


@router.get("/card-summary", summary="获取指标概览卡数据")
def get_caliber_card_summary(
    table: Annotated[str, Query(description="目标表名")],
    field: Annotated[str, Query(description="目标字段名")],
    depth: Annotated[int, Query(ge=1, le=20)] = 10,
    direction: CaliberQueryMode = CaliberQueryMode.UPSTREAM,
    data_source: Annotated[Optional[str], Query(description="数据源筛选")] = None,
    service: CaliberServiceDep = None,
) -> dict:
    try:
        result = service.build_summary_card(
            table=table, field=field,
            depth=depth, direction=direction.value,
            data_source=data_source,
        )
        return result
    except Exception as e:
        logger.error("概览卡查询失败: %s", e, exc_info=True)
        return {"success": False, "message": f"查询失败: {str(e)}", "data": None}


@router.get("/step-detail", summary="获取单步详情面板数据")
def get_caliber_step_detail(
    table: Annotated[str, Query(description="目标表名")],
    field: Annotated[str, Query(description="目标字段名")],
    step_num: Annotated[int, Query(ge=1, description="步骤编号")],
    procedure: Annotated[Optional[str], Query(description="存储过程名(可选)")] = None,
    depth: Annotated[int, Query(ge=1, le=20)] = 10,
    direction: CaliberQueryMode = CaliberQueryMode.UPSTREAM,
    data_source: Annotated[Optional[str], Query(description="数据源筛选")] = None,
    service: CaliberServiceDep = None,
) -> dict:
    try:
        result = service.build_step_detail(
            table=table, field=field, step_num=step_num,
            procedure=procedure or "",
            depth=depth, direction=direction.value,
            data_source=data_source,
        )
        return result
    except Exception as e:
        logger.error("步骤详情查询失败: %s", e, exc_info=True)
        return {"success": False, "message": f"查询失败: {str(e)}", "data": None}


@router.post("/export", summary="导出口径文档")
def export_caliber_document(
    request: dict,
    service: CaliberServiceDep,
) -> dict:
    """导出口径文档 (Markdown 或 HTML 格式)。

    Request body:
    {
        "table": "表名",
        "field": "字段名",
        "format": "markdown" | "html",
        "include_sql": true,
        "include_source_location": true
    }
    """
    try:
        from core.caliber_exporter import CaliberExporter

        table = request.get("table", "")
        field = request.get("field", "")
        fmt = request.get("format", "markdown")
        include_sql = request.get("include_sql", True)
        include_source_location = request.get("include_source_location", True)

        if not table or not field:
            return {"success": False, "message": "缺少 table 或 field 参数"}

        summary_result = service.build_summary_card(table=table, field=field)
        if not summary_result.get("success"):
            return {"success": False, "message": summary_result.get("message", "口径数据查询失败")}
        summary_data = summary_result["data"]

        pipeline_result = service.build_pipeline_view(table=table, field=field)
        pipeline_data = pipeline_result.get("data") if pipeline_result.get("success") else None

        step_details = []
        chains = service.query_caliber(table=table, field=field).get("chains", [])
        for chain in chains:
            for step in chain.get("steps", []):
                sn = step.get("step_num", 0)
                if sn > 0:
                    sd_result = service.build_step_detail(
                        table=table, field=field, step_num=sn,
                        procedure=step.get("procedure", ""),
                    )
                    if sd_result.get("success"):
                        step_details.append(sd_result["data"])

        exporter = CaliberExporter()
        if fmt == "html":
            content = exporter.export_html(
                summary_card=summary_data,
                pipeline_view=pipeline_data,
                step_details=step_details,
                include_sql=include_sql,
                include_source_location=include_source_location,
            )
            content_type = "text/html"
        else:
            content = exporter.export_markdown(
                summary_card=summary_data,
                pipeline_view=pipeline_data,
                step_details=step_details,
                include_sql=include_sql,
                include_source_location=include_source_location,
            )
            content_type = "text/markdown"

        return {
            "success": True,
            "content_type": content_type,
            "content": content,
            "filename": f"caliber_{table.split('.')[-1]}_{field}.{'html' if fmt == 'html' else 'md'}",
        }
    except Exception as e:
        logger.error("口径文档导出失败: %s", e, exc_info=True)
        return {"success": False, "message": f"导出失败: {str(e)}"}
