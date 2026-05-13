"""
系统管理 API 接口
健康检查、版本信息等
"""

from __future__ import annotations

import logging
import time
from datetime import datetime

from fastapi import APIRouter

from app.config import config
from app.dependencies import get_lineage_service, get_progress_service

logger = logging.getLogger(__name__)

router = APIRouter(tags=["系统管理"])


_start_time = time.time()


@router.get(
    "/health",
    summary="健康检查",
    description="检查服务运行状态",
)
async def health_check():
    uptime = time.time() - _start_time

    data_loaded = False
    index_status = "not_built"
    table_count = 0
    proc_count = 0

    try:
        from app.dependencies import get_parser_service
        parser = get_parser_service()
        data = parser.get_current_data()
        if data:
            data_loaded = True
            metadata = data.get("metadata", {})
            table_count = metadata.get("total_tables", 0)
            proc_count = metadata.get("total_procedures", 0)

        try:
            lineage_svc = get_lineage_service()
            if lineage_svc._table_tracer.adjacency_up or lineage_svc._table_tracer.adjacency_down:
                index_status = "ready"
            else:
                index_status = "empty"
        except Exception:
            index_status = "error"
    except Exception:
        data_loaded = False

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
async def system_stats():
    from app.dependencies import get_parser_service

    data_loaded = False
    table_count = 0
    proc_count = 0
    lineage_count = 0

    try:
        parser = get_parser_service()
        data = parser.get_current_data()
        if data:
            data_loaded = True
            metadata = data.get("metadata", {})
            table_count = metadata.get("total_tables", 0)
            proc_count = metadata.get("total_procedures", 0)
            lineage_count = metadata.get("total_table_lineages", 0)
    except Exception:
        pass

    uptime = time.time() - _start_time

    return {
        "success": True,
        "data": {
            "loaded": data_loaded,
            "tables": table_count,
            "procedures": proc_count,
            "lineages": lineage_count,
            "uptime_seconds": round(uptime, 2),
        },
    }
