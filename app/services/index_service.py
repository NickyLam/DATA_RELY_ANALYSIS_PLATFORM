"""
索引管理服务
封装索引构建、缓存刷新、数据变更响应等生命周期管理
"""

from __future__ import annotations

import logging
import threading

from app.services.event_bus import EventType, get_event_bus
from app.services.parser_service import ParserService
from app.services.table_lineage_tracer import TableLineageTracer
from app.utils.cache_manager import CacheManager

logger = logging.getLogger(__name__)


class IndexService:
    """索引与缓存生命周期管理（从 LineageService 拆分）"""

    def __init__(
        self,
        parser_service: ParserService,
        cache_manager: CacheManager,
        table_tracer: TableLineageTracer,
    ):
        self._parser = parser_service
        self._cache = cache_manager
        self._table_tracer = table_tracer

        self._transitive_cache: dict[tuple, set] = {}
        self._last_data_mtime: float = 0
        self._cache_lock = threading.Lock()

        # 字段映射索引缓存（避免每次查询时 O(N) 重建）
        self.field_target_map: dict[tuple, list[dict]] = {}
        self.field_source_map: dict[tuple, list[dict]] = {}
        self.table_to_upstream: dict[str, set[str]] = {}

        self._event_bus = get_event_bus()
        self._event_bus.subscribe(EventType.DATA_CHANGED, self._on_data_changed)
        self._event_bus.subscribe(EventType.CACHE_INVALIDATED, self._on_cache_invalidated)

        self.build_indexes()

    def build_indexes(self) -> None:
        """构建内存索引和图预处理数据"""
        data = self._parser.get_current_data()
        if not data:
            logger.warning("无可用数据，跳过索引构建")
            return

        tables = data.get("tables", [])
        procedures = data.get("procedures", [])

        self._cache.build_index(tables, procedures)
        self._table_tracer.build_graph(data.get("table_lineages", []))

        # 预构建字段映射索引
        field_mappings = data.get("field_mappings", [])
        self.field_target_map = {}
        self.field_source_map = {}
        self.table_to_upstream = {}
        for fm in field_mappings:
            tgt_key = (
                fm.get("target_table", "").upper(),
                fm.get("target_column", "").upper(),
            )
            src_key = (
                fm.get("source_table", "").upper(),
                fm.get("source_column", "").upper(),
            )
            self.field_target_map.setdefault(tgt_key, []).append(fm)
            self.field_source_map.setdefault(src_key, []).append(fm)

            src_tbl = fm.get("source_table", "").upper()
            tgt_tbl = fm.get("target_table", "").upper()
            if src_tbl and tgt_tbl:
                self.table_to_upstream.setdefault(tgt_tbl, set()).add(src_tbl)

        logger.info("血缘服务索引构建完成")

    def rebuild_indexes(self) -> None:
        """强制重建所有索引"""
        logger.info("开始重建索引...")
        self._cache.clear()
        self._table_tracer.adjacency_up.clear()
        self._table_tracer.adjacency_down.clear()
        self._transitive_cache.clear()
        self.build_indexes()
        self._update_data_mtime()
        logger.info("索引重建完成")

    def check_and_refresh_cache(self) -> None:
        """检查数据是否已更新，如果更新则自动清除缓存。"""
        current_mtime = self._get_data_mtime()
        if current_mtime is None:
            return

        if self._last_data_mtime == 0:
            self._last_data_mtime = current_mtime
            return

        if current_mtime > self._last_data_mtime:
            with self._cache_lock:
                logger.info(
                    "检测到数据已更新 (%.2f > %.2f)，自动清除缓存",
                    current_mtime,
                    self._last_data_mtime,
                )
                self._cache.clear()
                self._table_tracer.adjacency_up.clear()
                self._table_tracer.adjacency_down.clear()
                self._transitive_cache.clear()
                self.build_indexes()
                self._last_data_mtime = current_mtime

    def clear_transitive_cache(self) -> None:
        """清除传递性缓存"""
        self._transitive_cache.clear()

    @property
    def transitive_cache(self) -> dict[tuple, set]:
        return self._transitive_cache

    def _on_data_changed(self, **kwargs) -> None:
        self._parser.invalidate_tracer()
        self.build_indexes()
        self._transitive_cache.clear()

    def _on_cache_invalidated(self, **kwargs) -> None:
        self.build_indexes()
        self._transitive_cache.clear()
        self._cache.clear()

    def _get_data_mtime(self) -> float | None:
        """获取数据的最后更新时间戳。"""
        try:
            repo = self._parser.get_repository()
            metadata = repo.get_metadata()
            last_updated_str = metadata.get("last_updated", "")
            if last_updated_str:
                from datetime import datetime

                dt = datetime.strptime(str(last_updated_str), "%Y-%m-%d %H:%M:%S")
                return dt.timestamp()
        except Exception:
            pass

        cache_file = self._parser.output_dir / "lineage_data.json"
        if cache_file.exists():
            return cache_file.stat().st_mtime

        return None

    def _update_data_mtime(self) -> None:
        """更新数据的最后修改时间。"""
        current = self._get_data_mtime()
        if current is not None:
            self._last_data_mtime = current
