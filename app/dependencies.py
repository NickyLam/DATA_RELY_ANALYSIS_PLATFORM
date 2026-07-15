"""
FastAPI 依赖注入模块
管理缓存实例、服务实例等共享资源

遵循 FastAPI 最佳实践: 使用 Annotated 类型别名声明依赖
"""

from __future__ import annotations

import os
from functools import lru_cache
from typing import Annotated

from fastapi import Depends, HTTPException, Security
from fastapi.security import APIKeyHeader

from app.config import config
from app.services.index_service import IndexService
from app.services.indicator_service import IndicatorService
from app.services.lineage_service import LineageService
from app.services.parser_service import ParserService
from app.services.progress_service import ProgressService
from app.services.table_query_service import TableQueryService
from app.utils.cache_manager import CacheManager
from core.layer_detector import LayerDetector


@lru_cache
def get_layer_detector() -> LayerDetector:
    return LayerDetector.from_manifests(config.source_data_path)


@lru_cache
def get_cache_manager() -> CacheManager:
    return CacheManager(
        max_size=config.max_cache_size,
        ttl=config.cache_ttl_seconds,
    )


@lru_cache
def get_parser_service() -> ParserService:
    try:
        return ParserService(
            data_dir=str(config.data_path),
            schema_dirs=config.schema_dirs,
            output_dir=str(config.output_path),
        )
    except Exception:
        get_parser_service.cache_clear()
        raise


@lru_cache
def get_index_service() -> IndexService:
    try:
        return IndexService(
            parser_service=get_parser_service(),
            auto_start=False,
        )
    except Exception:
        get_index_service.cache_clear()
        raise


@lru_cache
def get_lineage_service() -> LineageService:
    try:
        parser = get_parser_service()
        cache = get_cache_manager()
        return LineageService(
            parser_service=parser,
            cache_manager=cache,
            index_service=get_index_service(),
        )
    except Exception:
        get_lineage_service.cache_clear()
        raise


@lru_cache
def get_progress_service() -> ProgressService:
    return ProgressService(
        keepalive_sec=config.progress_keepalive_sec,
    )


@lru_cache
def get_table_query_service() -> TableQueryService:
    parser = get_parser_service()
    cache = get_cache_manager()
    return TableQueryService(
        parser_service=parser,
        cache_manager=cache,
        index_service=get_index_service(),
    )


@lru_cache
def get_indicator_service() -> IndicatorService:
    fdm_config = next(
        (c for c in config.datasource_configs if c.name == "fdm"),
        None,
    )
    if fdm_config and fdm_config.enabled:
        indicator_data_path = fdm_config.data_dir
    else:
        indicator_data_path = str(config.base_dir / config.indicator_fallback_path)

    cache = get_cache_manager()
    lineage = get_lineage_service()
    try:
        return IndicatorService(
            indicator_data_path=indicator_data_path,
            cache_manager=cache,
            lineage_service=lineage,
        )
    except Exception:
        get_indicator_service.cache_clear()
        raise


CacheManagerDep = Annotated[CacheManager, Depends(get_cache_manager)]
ParserServiceDep = Annotated[ParserService, Depends(get_parser_service)]
IndexServiceDep = Annotated[IndexService, Depends(get_index_service)]
LineageServiceDep = Annotated[LineageService, Depends(get_lineage_service)]
ProgressServiceDep = Annotated[ProgressService, Depends(get_progress_service)]
IndicatorServiceDep = Annotated[IndicatorService, Depends(get_indicator_service)]
LayerDetectorDep = Annotated[LayerDetector, Depends(get_layer_detector)]
TableQueryServiceDep = Annotated[TableQueryService, Depends(get_table_query_service)]

_api_key_header = APIKeyHeader(name="X-Admin-Key", auto_error=False)


async def admin_required(api_key: str = Security(_api_key_header)) -> None:
    admin_key = os.getenv("ADMIN_API_KEY")
    if not admin_key:
        raise HTTPException(
            status_code=403,
            detail="Admin API key not configured. Set ADMIN_API_KEY environment variable to enable admin endpoints.",
        )
    if api_key != admin_key:
        raise HTTPException(status_code=403, detail="Invalid admin API key")
