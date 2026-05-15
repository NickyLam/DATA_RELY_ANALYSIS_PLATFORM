"""
FastAPI 依赖注入模块
管理缓存实例、服务实例等共享资源

遵循 FastAPI 最佳实践: 使用 Annotated 类型别名声明依赖
"""

from __future__ import annotations

from functools import lru_cache
from typing import Annotated

from fastapi import Depends

from app.config import config
from app.services.caliber_service import CaliberService
from app.services.indicator_service import IndicatorService
from app.services.lineage_service import LineageService
from app.services.parser_service import ParserService
from app.services.progress_service import ProgressService
from app.utils.cache_manager import CacheManager
from app.utils.path_utils import get_base_dir


@lru_cache
def get_cache_manager() -> CacheManager:
    return CacheManager(
        max_size=config.max_cache_size,
        ttl=config.cache_ttl_seconds,
    )


@lru_cache
def get_parser_service() -> ParserService:
    return ParserService(
        data_dir=str(config.data_path),
        schema_dirs=config.schema_dirs,
        output_dir=str(config.output_path),
    )


@lru_cache
def get_lineage_service() -> LineageService:
    parser = get_parser_service()
    cache = get_cache_manager()
    return LineageService(
        parser_service=parser,
        cache_manager=cache,
    )


@lru_cache
def get_caliber_service() -> CaliberService:
    parser = get_parser_service()
    cache = get_cache_manager()
    return CaliberService(
        parser_service=parser,
        cache_manager=cache,
    )


@lru_cache
def get_progress_service() -> ProgressService:
    return ProgressService(
        keepalive_sec=config.progress_keepalive_sec,
    )


@lru_cache
def get_indicator_service() -> IndicatorService:
    base_dir = get_base_dir()
    indicator_data_path = base_dir / "财务集市指标血缘分析" / "指标"
    cache = get_cache_manager()
    lineage = get_lineage_service()
    return IndicatorService(
        indicator_data_path=str(indicator_data_path),
        cache_manager=cache,
        lineage_service=lineage,
    )


CacheManagerDep = Annotated[CacheManager, Depends(get_cache_manager)]
ParserServiceDep = Annotated[ParserService, Depends(get_parser_service)]
LineageServiceDep = Annotated[LineageService, Depends(get_lineage_service)]
CaliberServiceDep = Annotated[CaliberService, Depends(get_caliber_service)]
ProgressServiceDep = Annotated[ProgressService, Depends(get_progress_service)]
IndicatorServiceDep = Annotated[IndicatorService, Depends(get_indicator_service)]
