"""
API 路由模块初始化
"""

from app.api.lineage import router as lineage_router
from app.api.parse import router as parse_router
from app.api.system import router as system_router

__all__ = ["parse_router", "lineage_router", "system_router"]
