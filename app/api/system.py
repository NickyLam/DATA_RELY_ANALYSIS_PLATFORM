"""
系统管理 API 接口
健康检查、版本信息等
"""

from __future__ import annotations

import logging
import time
from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException

from app.config import config
from app.dependencies import (
    IndexServiceDep,
    ParserServiceDep,
    TableQueryServiceDep,
    admin_required,
    get_layer_detector,
)
from app.services.index_service import RefreshOutcome

logger = logging.getLogger(__name__)

router = APIRouter(tags=["系统管理"])


_start_time = time.time()


@router.get(
    "/health",
    summary="健康检查",
    description="检查服务运行状态",
)
async def health_check(table_query_service: TableQueryServiceDep):
    uptime = time.time() - _start_time

    data_loaded = False
    index_status = "empty"
    table_count = 0
    proc_count = 0

    try:
        stats = table_query_service.get_runtime_stats()
        data_loaded = stats["loaded"]
        table_count = stats["tables"]
        proc_count = stats["procedures"]
        index_status = stats["index_status"]
    except Exception:
        data_loaded = False
        index_status = "error"

    status = "healthy" if data_loaded else "degraded"

    return {
        "status": status,
        "timestamp": datetime.now().isoformat(),
        "uptime_seconds": round(uptime, 2),
        "version": config.app_version,
        "data": {
            "loaded": data_loaded,
            "tables": table_count,
            "procedures": proc_count,
            "index_status": index_status,
        },
    }


@router.get(
    "/api/system",
    summary="首页重定向",
    description="返回 API 服务信息和可用端点列表",
)
async def root():
    return {
        "service": config.app_title,
        "version": config.app_version,
        "description": "数据血缘分析系统 v2.0 - 双TAB架构",
        "endpoints": {
            "解析管理": [
                "POST /api/parse/upload - 上传文件并解析",
                "GET /api/parse/progress/{task_id} - SSE 进度推送",
                "GET /api/parse/tasks/{task_id} - 查询任务状态",
                "POST /api/parse/parse-existing - 触发全量解析",
            ],
            "血缘查询": [
                "GET /api/tables?keyword=xxx - 搜索表",
                "POST /api/lineage/query - 血缘查询",
                "GET /api/stats - 系统统计",
            ],
            "系统": [
                "GET /health - 健康检查",
                "GET /static/index.html - 前端页面",
            ],
        },
        "docs": "/docs",
        "redoc": "/redoc",
    }


@router.get(
    "/api/system/info",
    summary="系统信息",
    description="获取系统版本和配置信息",
)
async def system_info():
    return {
        "success": True,
        "data": {
            "name": config.app_title,
            "version": config.app_version,
            "debug": config.debug,
            "host": config.host,
            "port": config.port,
        },
    }


@router.get(
    "/api/system/stats",
    summary="系统运行统计",
    description="获取系统运行时的数据统计信息",
)
async def system_stats(table_query_service: TableQueryServiceDep):
    try:
        stats = table_query_service.get_runtime_stats()
    except Exception:
        stats = {"loaded": False, "tables": 0, "procedures": 0, "lineages": 0}

    uptime = time.time() - _start_time

    return {
        "success": True,
        "data": {
            "loaded": stats["loaded"],
            "tables": stats["tables"],
            "procedures": stats["procedures"],
            "lineages": stats["lineages"],
            "uptime_seconds": round(uptime, 2),
        },
    }


@router.get(
    "/api/system/layers",
    summary="层级配置",
    description="获取所有系统的层级检测规则和配色配置，供前端动态渲染",
)
async def get_layer_configs():
    from core.layer_detector import LAYER_CONFIG, LAYER_ORDER

    detector = get_layer_detector()
    all_configs = detector.get_all_configs()

    result = {}
    for system, layer_config in all_configs.items():
        result[system] = {
            "layer_order": layer_config.layer_order,
            "layer_colors": layer_config.layer_colors,
            "default_schema": layer_config.default_schema,
            "known_schemas": layer_config.known_schemas,
            "rules": [{"pattern": r.pattern, "layer": r.layer, "label": r.label} for r in layer_config.rules],
        }

    result["_default"] = {
        "layer_order": LAYER_ORDER,
        "layer_colors": {k: v["color"] for k, v in LAYER_CONFIG.items()},
        "layer_labels": {k: v["label"] for k, v in LAYER_CONFIG.items()},
    }

    return {
        "success": True,
        "data": result,
    }


@router.post(
    "/api/system/reparse",
    summary="强制重新解析",
    description="清除缓存并重新全量解析所有数据文件（耗时约6-10分钟）",
)
def force_reparse(
    parser: ParserServiceDep,
    index_service: IndexServiceDep,
    _: None = Depends(admin_required),
):
    """强制重新全量解析，覆盖缓存"""
    try:
        # 清除旧的 LineageTracer 缓存
        parser.reset_tracer()

        # 强制全量解析
        result = parser.parse_existing_data(force=True)

        # DATA_CHANGED 通常已同步发布新 generation；此兼容检查必须保持非强制并去重。
        generation = parser.data_generation
        refresh = index_service.refresh(
            requested_generation=generation,
            force=False,
            trigger="post-reparse",
        )
        if (
            refresh.outcome not in {RefreshOutcome.PUBLISHED, RefreshOutcome.DUPLICATE}
            or index_service.state.committed_generation != generation
        ):
            raise RuntimeError("projection_not_published")

        return {
            "success": True,
            "data": {
                "tables": len(result.tables),
                "procedures": len(result.procedures),
                "table_lineages": len(result.table_lineages),
                "field_mappings": len(result.field_mappings),
                "parse_time_sec": round(result.parse_time_sec, 2),
            },
        }
    except Exception as e:
        logger.error("Force reparse failed: %s", e)
        raise HTTPException(status_code=500, detail="重新解析失败") from e
