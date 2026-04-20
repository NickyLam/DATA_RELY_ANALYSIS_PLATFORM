"""
API 路由汇总
"""
from fastapi import APIRouter

from app.api.v1.endpoints import data_sources, lineage, search, health, collect, parse, field_lineage, troubleshoot, validation

api_router = APIRouter()

api_router.include_router(health.router, prefix="/health", tags=["健康检查"])
api_router.include_router(search.router, prefix="/search", tags=["资产搜索"])
api_router.include_router(data_sources.router, prefix="/data-sources", tags=["数据源管理"])
api_router.include_router(lineage.router, prefix="/lineage", tags=["血缘查询"])
api_router.include_router(field_lineage.router, prefix="/field-lineage", tags=["字段血缘"])
api_router.include_router(collect.router, prefix="/collect", tags=["采集任务管理"])
api_router.include_router(parse.router, prefix="/parse", tags=["SQL解析"])
api_router.include_router(troubleshoot.router, prefix="/troubleshoot", tags=["问题排查"])
api_router.include_router(validation.router, prefix="/validation", tags=["血缘验证"])