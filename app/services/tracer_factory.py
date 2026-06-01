from __future__ import annotations

import logging
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from core.caliber_tracer import CaliberTracer
    from core.lineage_tracer import LineageTracer
    from core.unified_tracer import UnifiedTracer

logger = logging.getLogger(__name__)


class TracerFactory:
    def __init__(self):
        self._lineage_tracer: LineageTracer | None = None
        self._caliber_tracer: CaliberTracer | None = None
        self._unified_tracer: UnifiedTracer | None = None

    def create_lineage_tracer(
        self, tables, procedures, table_lineages, field_mappings, max_depth: int = 10
    ) -> LineageTracer:
        if self._lineage_tracer is not None:
            return self._lineage_tracer
        try:
            from core.lineage_tracer import LineageTracer

            self._lineage_tracer = LineageTracer(
                tables=tables,
                procedures=procedures,
                table_lineages=table_lineages,
                field_mappings=field_mappings,
                max_depth=max_depth,
            )
            return self._lineage_tracer
        except Exception as e:
            logger.error("构建 LineageTracer 失败: %s", e, exc_info=True)
            raise

    def create_caliber_tracer(
        self,
        tables,
        procedures,
        table_lineages,
        field_mappings,
        caliber_infos,
        max_depth: int = 10,
    ) -> CaliberTracer:
        if self._caliber_tracer is not None:
            return self._caliber_tracer
        try:
            from core.caliber_tracer import CaliberTracer

            self._caliber_tracer = CaliberTracer(
                tables=tables,
                procedures=procedures,
                table_lineages=table_lineages,
                field_mappings=field_mappings,
                caliber_infos=caliber_infos,
                max_depth=max_depth,
            )
            return self._caliber_tracer
        except Exception as e:
            logger.error("构建 CaliberTracer 失败: %s", e, exc_info=True)
            raise

    def create_unified_tracer(
        self,
        tables,
        procedures,
        table_lineages,
        field_mappings,
        caliber_infos=None,
        max_depth: int = 10,
    ) -> UnifiedTracer:
        if self._unified_tracer is not None:
            return self._unified_tracer
        try:
            from core.unified_tracer import UnifiedTracer

            self._unified_tracer = UnifiedTracer(
                tables=tables,
                procedures=procedures,
                table_lineages=table_lineages,
                field_mappings=field_mappings,
                caliber_infos=caliber_infos,
                max_depth=max_depth,
            )
            return self._unified_tracer
        except Exception as e:
            logger.error("构建 UnifiedTracer 失败: %s", e, exc_info=True)
            raise

    def invalidate(self) -> None:
        self._lineage_tracer = None
        self._caliber_tracer = None
        self._unified_tracer = None

    @property
    def lineage_tracer(self):
        return self._lineage_tracer

    @property
    def caliber_tracer(self):
        return self._caliber_tracer

    @property
    def unified_tracer(self):
        return self._unified_tracer
