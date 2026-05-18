"""
指标血缘查询服务
封装指标血缘追溯逻辑，支持与字段血缘交叉查询
"""

from __future__ import annotations

import logging
from pathlib import Path
from typing import Any, Optional

from core.indicator_config_parser import IndicatorConfigParser
from core.indicator_graph_builder import IndicatorGraphBuilder
from core.indicator_models import IndicatorConfigResult
from app.utils.cache_manager import CacheManager

logger = logging.getLogger(__name__)


class IndicatorService:
    """指标血缘查询服务"""

    def __init__(
        self,
        indicator_data_path: str,
        cache_manager: CacheManager,
        lineage_service: Optional[Any] = None,
    ) -> None:
        self.data_path = Path(indicator_data_path)
        self.cache = cache_manager
        self._lineage_service = lineage_service
        self._config_result: Optional[IndicatorConfigResult] = None
        self._graph_builder: Optional[IndicatorGraphBuilder] = None
        self._load_and_build()

    def _load_and_build(self) -> None:
        if not self.data_path.exists():
            logger.warning("指标数据目录不存在: %s", self.data_path)
            return

        parser = IndicatorConfigParser(self.data_path)
        self._config_result = parser.parse_all()
        self._graph_builder = IndicatorGraphBuilder(self._config_result)
        self._graph_builder.build_full_graph()
        logger.info(
            "指标血缘服务初始化完成: %d 基础指标, %d 总账指标",
            self._config_result.base_calc_count,
            self._config_result.gl_calc_count,
        )

    def trace_indicator(
        self,
        index_no: str,
        measure: str = "",
        direction: str = "upstream",
        depth: int = 10,
    ) -> dict[str, Any]:
        if not self._graph_builder:
            return {
                "target_index_no": index_no,
                "target_measure": measure,
                "graph": {"nodes": [], "edges": [], "stats": {}},
                "chains": [],
                "query_time_ms": 0.0,
            }

        result = self._graph_builder.trace_indicator(
            index_no=index_no,
            measure=measure,
            direction=direction,
            max_depth=depth,
        )
        return self._serialize_result(result)

    def get_indicator_detail(self, index_no: str) -> dict[str, Any]:
        if not self._graph_builder:
            return {}
        return self._graph_builder.get_indicator_detail(index_no)

    def search_indicators(self, keyword: str, limit: int = 50) -> list[dict[str, Any]]:
        if not self._graph_builder:
            return []
        return self._graph_builder.search_indicators(keyword, limit)

    def get_pipeline_steps(self, index_no: str, measure: str = "") -> list[dict[str, Any]]:
        if not self._graph_builder:
            return []
        return self._graph_builder.get_pipeline_steps(index_no, measure)

    def get_stats(self) -> dict[str, Any]:
        if not self._graph_builder:
            return {}
        return self._graph_builder.get_stats()

    def bridge_to_field_lineage(self, table_name: str) -> dict[str, Any]:
        if not self._lineage_service:
            return {"success": False, "message": "字段血缘服务未初始化", "data": {}}

        try:
            lineage_result = self._lineage_service.query_lineage(
                table=table_name,
                depth=5,
                mode="upstream",
            )
            return {
                "success": True,
                "message": "查询成功",
                "data": lineage_result,
            }
        except Exception as e:
            logger.error("桥接字段血缘失败: %s", e)
            return {"success": False, "message": str(e), "data": {}}

    def get_indicator_source_tables(self, index_no: str) -> list[str]:
        if not self._graph_builder:
            return []
        detail = self._graph_builder.get_indicator_detail(index_no)
        tables: list[str] = []
        for m in detail.get("measures", []):
            src = m.get("src_table", "")
            if src:
                for t in src.split(","):
                    t = t.strip().upper()
                    if t and t not in tables:
                        tables.append(t)
        return tables

    def _serialize_result(self, result) -> dict[str, Any]:
        return {
            "target_index_no": result.target_index_no,
            "target_measure": result.target_measure,
            "measure_label": result.measure_label,
            "chain_count": result.chain_count,
            "max_depth": result.max_depth,
            "query_time_ms": result.query_time_ms,
            "graph": self._serialize_graph(result.graph),
            "chains": [self._serialize_chain(c) for c in result.chains],
        }

    def _serialize_graph(self, graph) -> dict[str, Any]:
        nodes = [
            {
                "id": n.node_id,
                "type": n.node_type,
                "label": n.display_label,
                "index_no": n.index_no,
                "index_measure": n.index_measure,
                "index_type": n.index_type,
                "algo_type": n.algo_type,
                "layer": n.layer,
                "brch_type": n.brch_type,
                "detail": n.detail,
            }
            for n in graph.nodes
        ]
        edges = [
            {
                "id": e.edge_id,
                "source": e.source_id,
                "target": e.target_id,
                "type": e.edge_type,
                "procedure": e.procedure,
                "transform_logic": e.transform_logic,
                "algo_type": e.algo_type,
                "condition_sql": e.condition_sql,
                "measure_sql": e.measure_sql,
            }
            for e in graph.edges
        ]
        return {
            "nodes": nodes,
            "edges": edges,
            "stats": graph.stats,
            "node_count": graph.node_count,
            "edge_count": graph.edge_count,
        }

    def _serialize_chain(self, chain) -> dict[str, Any]:
        return {
            "target_index_no": chain.target_index_no,
            "target_measure": chain.target_measure,
            "depth": chain.depth,
            "step_count": chain.step_count,
            "procedures_involved": chain.procedures_involved,
            "tables_involved": chain.tables_involved,
            "has_gl_step": chain.has_gl_step,
            "steps": [
                {
                    "step_num": s.step_num,
                    "index_no": s.index_no,
                    "index_measure": s.index_measure,
                    "measure_label": s.measure_label,
                    "index_type": s.index_type,
                    "index_type_label": s.index_type_label,
                    "algo_type": s.algo_type,
                    "algo_label": s.algo_label,
                    "procedure": s.procedure,
                    "source_tables": s.source_tables,
                    "target_table": s.target_table,
                    "transform_logic": s.transform_logic,
                    "condition_sql": s.condition_sql,
                    "measure_sql": s.measure_sql,
                    "brch_type": s.brch_type,
                    "gl_subj_no": s.gl_subj_no,
                    "gl_amt_val": s.gl_amt_val,
                    "gl_sign_no": s.gl_sign_no,
                    "is_gl_step": s.is_gl_step,
                }
                for s in chain.steps
            ],
        }