"""
API 路由汇总
"""
from fastapi import APIRouter

from app.api.v1.endpoints import data_sources, lineage, search, health

api_router = APIRouter()

# 注册各个模块的路由
api_router.include_router(health.router, prefix="/health", tags=["健康检查"])
api_router.include_router(search.router, prefix="/search", tags=["资产搜索"])
api_router.include_router(data_sources.router, prefix="/data-sources", tags=["数据源管理"])
api_router.include_router(lineage.router, prefix="/lineage", tags=["血缘查询"])