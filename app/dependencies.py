"""
FastAPI 依赖注入模块
管理数据库连接、缓存实例、服务实例等共享资源
"""

from __future__ import annotations

from functools import lru_cache
from typing import AsyncGenerator

from fastapi import Depends

from app.config import config
from app.services.caliber_service import CaliberService
from app.services.lineage_service import LineageService
from app.services.parser_service import ParserService
from app.services.progress_service import ProgressService
from app.utils.cache_manager import CacheManager


@lru_cache
def get_cache_manager() -> CacheManager:
    """获取缓存管理器单例"""
    return CacheManager(
        max_size=config.max_cache_size,
        ttl=config.cache_ttl_seconds,
    )


@lru_cache
def get_parser_service() -> ParserService:
    """获取解析服务单例"""
    return ParserService(
        data_dir=str(config.data_path),
        schema_dirs=config.schema_dirs,
        output_dir=str(config.output_path),
    )


@lru_cache
def get_lineage_service() -> LineageService:
    """获取血缘服务单例"""
    parser = get_parser_service()
    cache = get_cache_manager()
    return LineageService(
        parser_service=parser,
        cache_manager=cache,
    )


@lru_cache
def get_caliber_service() -> CaliberService:
    """获取口径查询服务单例"""
    parser = get_parser_service()
    cache = get_cache_manager()
    return CaliberService(
        parser_service=parser,
        cache_manager=cache,
    )


@lru_cache
def get_progress_service() -> ProgressService:
    """获取进度服务单例"""
    return ProgressService(
        keepalive_sec=config.progress_keepalive_sec,
    )
