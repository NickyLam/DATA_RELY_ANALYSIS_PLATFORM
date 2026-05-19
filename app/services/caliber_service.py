"""
指标口径查询服务
封装口径追溯逻辑，支持按表名+字段名查询指标口径链路
"""

from __future__ import annotations

import dataclasses
import logging
import re
import time
from typing import Any, Optional

from core.caliber_extractor import CaliberExtractor
from core.caliber_tracer import CaliberTracer
from core.models import (
    CaliberChain,
    CaliberInfo,
    CaliberResult,
    CaliberSummaryCard,
    CustomFunctionDetail,
    CTEDetail,
    FieldMapping,
    LAYER_ORDER,
    PipelineBranch,
    PipelineEdge,
    PipelineNode,
    PipelineView,
    ProcedureInfo,
    StepDetail,
    TableInfo,
    TableLineage,
    TargetFieldExpression,
)
from core.table_name_resolver import TableNameResolver
from app.services.parser_service import ParserService
from app.utils.cache_manager import CacheManager

logger = logging.getLogger(__name__)


class CaliberService:
    """指标口径查询服务

    使用 CaliberTracer 进行多层 BFS 追溯，
    同时保留轻量级索引用于快速搜索和单步查询。
    """

    def __init__(
        self,
        parser_service: ParserService,
        cache_manager: CacheManager,
    ):
        self.parser = parser_service
        self.cache = cache_manager
        self._resolver = TableNameResolver()

        self._target_caliber_idx: dict[tuple[str, str], list[dict]] = {}
        self._source_caliber_idx: dict[tuple[str, str], list[dict]] = {}
        self._tracer: Optional[CaliberTracer] = None

        self._build_indexes()
        self._build_tracer()

    def _build_indexes(self) -> None:
        """构建轻量级索引（用于快速搜索和单步查询）。"""
        data = self.parser.get_current_data()
        if not data:
            return

        caliber_infos = data.get("caliber_infos", [])
        if not caliber_infos:
            return

        self._target_caliber_idx.clear()
        self._source_caliber_idx.clear()

        for ci in caliber_infos:
            target_table = ci.get("target_table", "").upper()
            target_column = ci.get("target_column", "").upper()
            source_table = ci.get("source_table", "").upper()
            source_column = ci.get("source_column", "").upper()

            target_key = self._make_key(target_table, target_column)
            source_key = self._make_key(source_table, source_column)

            self._target_caliber_idx.setdefault(target_key, []).append(ci)
            self._source_caliber_idx.setdefault(source_key, []).append(ci)

        logger.info(
            "口径索引构建完成: %d 条口径信息, %d 个目标索引, %d 个来源索引",
            len(caliber_infos),
            len(self._target_caliber_idx),
            len(self._source_caliber_idx),
        )

    def _build_tracer(self) -> None:
        """构建 CaliberTracer 实例（用于多层追溯）。"""
        data = self.parser.get_current_data()
        if not data:
            return

        tables_raw = data.get("tables", [])
        procedures_raw = data.get("procedures", [])
        table_lineages_raw = data.get("table_lineages", [])
        field_mappings_raw = data.get("field_mappings", [])
        caliber_infos_raw = data.get("caliber_infos", [])

        tables: dict[str, TableInfo] = {}
        for t in tables_raw:
            try:
                ti = TableInfo(
                    schema=t.get("schema", ""),
                    table_name=t.get("table_name", ""),
                    full_name=t.get("full_name", t.get("table_name", "")),
                )
                tables[ti.full_name.upper()] = ti
                tables[ti.table_name.upper()] = ti
            except Exception:
                continue

        procedures: dict[str, ProcedureInfo] = {}
        for p in procedures_raw:
            proc_info = ProcedureInfo(
                full_name=p.get("full_name", ""),
                schema=p.get("schema", ""),
                proc_name=p.get("proc_name", ""),
                description=p.get("description", ""),
                source_tables=p.get("source_tables", []),
                target_tables=p.get("target_tables", []),
            )
            procedures[proc_info.full_name] = proc_info

        table_lineages: list[TableLineage] = []
        for tl in table_lineages_raw:
            table_lineages.append(TableLineage(
                source_table=tl.get("source_table", ""),
                target_table=tl.get("target_table", ""),
                procedure=tl.get("procedure", ""),
            ))

        field_mappings: list[FieldMapping] = []
        for fm in field_mappings_raw:
            field_mappings.append(FieldMapping(
                source_table=fm.get("source_table", ""),
                source_column=fm.get("source_column", ""),
                target_table=fm.get("target_table", ""),
                target_column=fm.get("target_column", ""),
                transform_logic=fm.get("transform_logic", ""),
                procedure=fm.get("procedure", ""),
                confidence=fm.get("confidence", 1.0),
            ))

        self._tracer = CaliberTracer(
            tables=tables,
            procedures=procedures,
            table_lineages=table_lineages,
            field_mappings=field_mappings,
            caliber_infos=caliber_infos_raw,
        )
        logger.info("CaliberTracer 构建完成")

    def rebuild_indexes(self) -> None:
        """重建所有索引和 Tracer（数据更新后调用）。"""
        self._build_indexes()
        self._build_tracer()

    @staticmethod
    def _make_key(table: str, column: str) -> tuple[str, str]:
        short_table = table.split(".")[-1] if "." in table else table
        return (short_table.upper(), column.upper())

    # ===================================================================
    # 核心查询 API（使用 CaliberTracer）
    # ===================================================================

    def query_caliber(
        self,
        table: str,
        field: str,
        depth: int = 10,
        direction: str = "upstream",
        data_source: Optional[str] = None,
    ) -> dict[str, Any]:
        """查询指标口径（使用 CaliberTracer 多层追溯引擎）。

        Args:
            table: 目标表名
            field: 目标字段名
            depth: 追溯深度
            direction: 追溯方向 (upstream/downstream/both)
            data_source: 数据源筛选
        """
        if not self._tracer:
            return {
                "success": False,
                "message": "数据尚未加载，请先执行解析操作",
                "data": None,
            }

        result = self._tracer.trace_caliber(
            target_table=table,
            target_field=field,
            direction=direction,
            max_depth=depth,
            data_source=data_source,
        )

        return self._result_to_dict(result)

    def query_caliber_summary(self, table: str, field: str, **kwargs) -> str:
        """查询指标口径并返回可读的 Markdown 摘要文本。"""
        if not self._tracer:
            return "# 错误：数据尚未加载"

        result = self._tracer.trace_caliber(
            target_table=table,
            target_field=field,
            direction=kwargs.get("direction", "upstream"),
            max_depth=kwargs.get("depth", 10),
            data_source=kwargs.get("data_source"),
        )
        return self._tracer.generate_summary_text(result)

    def get_direct_sources(self, table: str, field: str) -> list[dict]:
        """获取目标字段的直接上游口径记录（一层，不递归）。"""
        if not self._tracer:
            return []

        records = self._tracer.get_direct_sources(table, field)
        return [self._record_to_dict(r) for r in records]

    def get_direct_targets(self, table: str, field: str) -> list[dict]:
        """获取源字段的直接下游口径记录（一层，不递归）。"""
        if not self._tracer:
            return []

        records = self._tracer.get_direct_targets(table, field)
        return [self._record_to_dict(r) for r in records]

    # ===================================================================
    # 快速搜索（使用轻量级索引）
    # ===================================================================

    def search_indicators(
        self,
        keyword: str,
        limit: int = 50,
        data_source: Optional[str] = None,
    ) -> list[dict]:
        """搜索指标口径（按关键词）—— 使用轻量级索引，响应 <10ms。"""
        data = self.parser.get_current_data()
        if not data:
            return []

        caliber_infos = data.get("caliber_infos", [])
        keyword_upper = keyword.upper()

        seen: set[tuple[str, str]] = set()
        results: list[dict] = []

        for ci in caliber_infos:
            if data_source and ci.get("data_source", "") != data_source:
                continue

            target_table = ci.get("target_table", "").upper()
            target_column = ci.get("target_column", "").upper()
            source_table = ci.get("source_table", "").upper()
            source_column = ci.get("source_column", "").upper()

            short_target = target_table.split(".")[-1] if "." in target_table else target_table
            short_source = source_table.split(".")[-1] if "." in source_table else source_table

            hit = (
                keyword_upper in short_target
                or keyword_upper in target_column
                or keyword_upper in short_source
                or keyword_upper in source_column
            )
            if not hit:
                continue

            target_key = (short_target, target_column)
            if target_key in seen:
                continue
            seen.add(target_key)

            results.append({
                "table": ci.get("target_table", ""),
                "field": ci.get("target_column", ""),
                "short_table": short_target,
                "data_source": ci.get("data_source", "oracle"),
                "transform_logic": ci.get("transform_logic", ""),
                "procedure": ci.get("procedure", ""),
                "has_conditions": bool(ci.get("where_conditions") or ci.get("join_conditions")),
            })

            if len(results) >= limit:
                break

        return results

    def get_fields_with_caliber(
        self,
        table: str,
        data_source: Optional[str] = None,
    ) -> list[dict]:
        """获取指定表中有口径数据的字段列表（含上下游数量统计）。

        用于前端"选中表 → 关联展示口径字段"场景，避免用户选到一个
        无口径数据的字段后查询结果为空。

        Args:
            table: 表名（支持短名和带 schema 的全名）
            data_source: 数据源筛选

        Returns:
            字段列表，每个元素含:
              - field: 字段名
              - upstream_count: 作为目标字段的口径记录数（上游来源数）
              - downstream_count: 作为源字段的口径记录数（下游去向数）
        """
        short_table = table.upper().split(".")[-1] if "." in table else table.upper()
        full_table = table.upper()

        # 收集该表在 _target_caliber_idx 中的所有字段（该字段作为目标被追溯）
        target_fields: dict[str, int] = {}
        source_fields: dict[str, int] = {}

        for ci in self._target_caliber_idx:
            ci_table, ci_col = ci  # (short_table, column)
            if ci_table != short_table:
                continue
            records = self._target_caliber_idx[ci]
            if data_source:
                records = [r for r in records if r.get("data_source", "") == data_source]
            if records:
                target_fields[ci_col] = len(records)

        for ci in self._source_caliber_idx:
            ci_table, ci_col = ci
            if ci_table != short_table:
                continue
            records = self._source_caliber_idx[ci]
            if data_source:
                records = [r for r in records if r.get("data_source", "") == data_source]
            if records:
                source_fields[ci_col] = len(records)

        # 合并：有上游或有下游记录的字段都算
        all_fields: set[str] = set(target_fields.keys()) | set(source_fields.keys())
        results: list[dict] = []
        for field_name in sorted(all_fields):
            results.append({
                "field": field_name,
                "upstream_count": target_fields.get(field_name, 0),
                "downstream_count": source_fields.get(field_name, 0),
            })

        return results

    def get_datasources(self) -> list[dict]:
        """获取可用的数据源列表。"""
        from app.config import config

        return [
            {
                "name": ds.name,
                "display_name": ds.display_name,
                "file_extensions": ds.file_extensions,
            }
            for ds in config.datasource_configs
        ]

    # ===================================================================
    # 序列化工具方法
    # ===================================================================

    @staticmethod
    def _result_to_dict(result: CaliberResult) -> dict[str, Any]:
        """将 CaliberResult 转换为 API 响应字典（含增强字段）。"""
        chains_data = []
        for chain in result.chains:
            steps_data = []
            for step in chain.steps:
                steps_data.append({
                    "target_table": step.target_table,
                    "target_column": step.target_column,
                    "source_table": step.source_table,
                    "source_column": step.source_column,
                    "transform_logic": step.transform_logic,
                    "where_conditions": [
                        {
                            "condition_type": c.condition_type,
                            "raw_text": c.raw_text,
                            "tables_involved": c.tables_involved,
                            "fields_involved": c.fields_involved,
                        }
                        for c in step.where_conditions
                    ],
                    "join_conditions": [
                        {
                            "condition_type": c.condition_type,
                            "raw_text": c.raw_text,
                            "tables_involved": c.tables_involved,
                            "fields_involved": c.fields_involved,
                        }
                        for c in step.join_conditions
                    ],
                    "group_by_clause": step.group_by_clause,
                    "having_clause": step.having_clause,
                    "procedure": step.procedure,
                    "step_num": step.step_num,
                    "step_desc": step.step_desc,
                    "data_source": step.data_source,
                    "raw_sql_fragment": step.raw_sql_fragment,
                    "confidence": step.confidence,
                    "operation_type": step.operation_type,
                    "select_columns": [
                        {
                            "source_expression": sc.source_expression,
                            "target_column": sc.target_column,
                            "alias": sc.alias,
                        }
                        for sc in step.select_columns
                    ],
                    "distinct_flag": step.distinct_flag,
                    "order_by_clause": step.order_by_clause,
                    "set_operation": step.set_operation,
                    "subqueries": [
                        {
                            "alias": sq.alias,
                            "raw_text": sq.raw_text,
                            "source_tables": sq.source_tables,
                        }
                        for sq in step.subqueries
                    ],
                    "source_table_layer": step.source_table_layer,
                    "target_table_layer": step.target_table_layer,
                    "window_functions": step.window_functions,
                    "sql_operation_sequence": step.sql_operation_sequence,
                    "accumulated_where": [
                        {
                            "condition_type": c.condition_type,
                            "raw_text": c.raw_text,
                            "tables_involved": c.tables_involved,
                            "fields_involved": c.fields_involved,
                        }
                        for c in step.accumulated_where
                    ],
                    "accumulated_join": [
                        {
                            "condition_type": c.condition_type,
                            "raw_text": c.raw_text,
                            "tables_involved": c.tables_involved,
                            "fields_involved": c.fields_involved,
                        }
                        for c in step.accumulated_join
                    ],
                    "caliber_spec": step.generate_caliber_spec(),
                })

            chains_data.append({
                "target_table": chain.target_table,
                "target_column": chain.target_column,
                "steps": steps_data,
                "depth": chain.depth,
                "summary": chain.summary,
                "data_flow_layers": chain.data_flow_layers,
                "procedures_involved": chain.procedures_involved,
                "tables_involved": chain.tables_involved,
                "total_conditions": chain.total_conditions,
                "complete_caliber_spec": chain.complete_caliber_spec,
                "accumulated_conditions_text": chain.accumulated_conditions_text,
            })

        return {
            "target_table": result.target_table,
            "target_column": result.target_column,
            "chains": chains_data,
            "total_steps": result.total_steps,
            "total_conditions": result.total_conditions,
            "query_time_ms": result.query_time_ms,
            "data_flow_layers_summary": result.data_flow_layers_summary,
            "complete_caliber_spec": result.complete_caliber_spec,
        }

    @staticmethod
    def _record_to_dict(record) -> dict:
        """将内部记录对象转换为字典。"""
        return {
            "source_table": record.source_table,
            "source_column": record.source_column,
            "target_table": record.target_table,
            "target_column": record.target_column,
            "transform_logic": record.transform_logic,
            "where_conditions": record.where_conditions,
            "join_conditions": record.join_conditions,
            "group_by_clause": record.group_by_clause,
            "having_clause": record.having_clause,
            "procedure": record.procedure,
            "step_num": record.step_num,
            "step_desc": record.step_desc,
            "data_source": record.data_source,
            "raw_sql_fragment": record.raw_sql_fragment,
            "confidence": record.confidence,
        }

    # ===================================================================
    # Pipeline View 构建
    # ===================================================================

    def build_pipeline_view(self, table: str, field: str, **kwargs) -> dict:
        """构建 Pipeline 视图数据。

        从口径查询结果中提取节点、边和分支信息，
        生成前端 Pipeline 可视化所需的完整数据结构。
        """
        result = self.query_caliber(table, field, **kwargs)

        chains = result.get("chains", [])
        if not chains:
            return {"success": False, "message": "未找到该字段的口径数据"}

        # 构建节点和边
        nodes_dict = self._build_pipeline_nodes(chains)
        edges = self._build_pipeline_edges(chains, nodes_dict)

        # 标记 is_source / is_target
        target_node_ids: set[str] = set()
        source_node_ids: set[str] = set()
        for edge in edges:
            source_node_ids.add(edge["source"])
            target_node_ids.add(edge["target"])

        for node_id, node in nodes_dict.items():
            node["is_source"] = node_id not in target_node_ids
            node["is_target"] = node_id not in source_node_ids

        # 检测同表内转换
        for node_id, node in nodes_dict.items():
            incoming_from_same = any(
                e["source"] == node_id and e["target"] == node_id
                for e in edges
            )
            if incoming_from_same:
                node["is_internal_transform"] = True
                node["transform_note"] = "同表内字段转换"

        # 检测分支
        branches = self._detect_branches(edges)

        # 确定 layer_order（按 LAYER_ORDER 常量中出现的顺序排列实际出现的层）
        seen_layers: list[str] = []
        for node in nodes_dict.values():
            layer = node.get("layer", "")
            if layer and layer not in seen_layers:
                seen_layers.append(layer)
        layer_order = [l for l in LAYER_ORDER if l in seen_layers]
        # 追加不在 LAYER_ORDER 中的层
        for l in seen_layers:
            if l not in layer_order:
                layer_order.append(l)

        view = PipelineView(
            target_table=table,
            target_field=field,
            nodes=[PipelineNode(**n) for n in nodes_dict.values()],
            edges=[PipelineEdge(**e) for e in edges],
            branches=[PipelineBranch(**b) for b in branches],
            layer_order=layer_order,
        )

        return {"success": True, "data": dataclasses.asdict(view)}

    @staticmethod
    def _make_pipeline_node_id(table: str, field_name: str) -> str:
        """生成 Pipeline 节点 ID: SHORT_TABLE.FIELD (均大写)。"""
        short = table.split(".")[-1].upper()
        return f"{short}.{field_name.upper()}"

    def _build_pipeline_nodes(self, chains: list[dict]) -> dict[str, dict]:
        """从 chains 中构建所有唯一节点。

        Returns:
            dict[node_id, PipelineNode_dict] — 相同 node_id 去重合并
        """
        nodes: dict[str, dict] = {}
        has_incoming: set[str] = set()

        for chain in chains:
            for step in chain.get("steps", []):
                src_table = step.get("source_table", "")
                src_col = step.get("source_column", "")
                tgt_table = step.get("target_table", "")
                tgt_col = step.get("target_column", "")
                src_layer = step.get("source_table_layer", "")
                tgt_layer = step.get("target_table_layer", "")

                # 源节点
                if src_table and src_col:
                    src_id = self._make_pipeline_node_id(src_table, src_col)
                    if src_id not in nodes:
                        short = src_table.split(".")[-1].upper()
                        layer_label = self._get_layer_label(src_layer)
                        nodes[src_id] = {
                            "id": src_id,
                            "layer": src_layer,
                            "layer_label": layer_label,
                            "label": short,
                            "field": src_col.upper(),
                            "is_source": True,
                            "is_target": False,
                            "is_internal_transform": False,
                            "transform_note": "",
                        }

                # 目标节点
                if tgt_table and tgt_col:
                    tgt_id = self._make_pipeline_node_id(tgt_table, tgt_col)
                    has_incoming.add(tgt_id)
                    if tgt_id not in nodes:
                        short = tgt_table.split(".")[-1].upper()
                        layer_label = self._get_layer_label(tgt_layer)
                        nodes[tgt_id] = {
                            "id": tgt_id,
                            "layer": tgt_layer,
                            "layer_label": layer_label,
                            "label": short,
                            "field": tgt_col.upper(),
                            "is_source": False,
                            "is_target": False,
                            "is_internal_transform": False,
                            "transform_note": "",
                        }

        # 更新 is_source 标记：没有入边的节点为源头
        for node_id in nodes:
            if node_id not in has_incoming:
                nodes[node_id]["is_source"] = True

        return nodes

    def _build_pipeline_edges(self, chains: list[dict], nodes: dict) -> list[dict]:
        """从 chains 中构建所有边。"""
        edges: list[dict] = []
        edge_counter = 0

        for chain in chains:
            for step in chain.get("steps", []):
                src_table = step.get("source_table", "")
                src_col = step.get("source_column", "")
                tgt_table = step.get("target_table", "")
                tgt_col = step.get("target_column", "")

                if not (src_table and src_col and tgt_table and tgt_col):
                    continue

                src_id = self._make_pipeline_node_id(src_table, src_col)
                tgt_id = self._make_pipeline_node_id(tgt_table, tgt_col)

                expression = step.get("full_expression", "") or step.get("transform_logic", "")
                has_detail = bool(
                    step.get("where_conditions")
                    or step.get("join_conditions")
                    or step.get("full_expression")
                )

                edge_counter += 1
                edges.append({
                    "id": f"step_{edge_counter}",
                    "source": src_id,
                    "target": tgt_id,
                    "source_field": src_col.upper(),
                    "target_field": tgt_col.upper(),
                    "expression": expression,
                    "procedure": step.get("procedure", ""),
                    "step_num": step.get("step_num", 0),
                    "operation_type": step.get("operation_type", ""),
                    "has_detail": has_detail,
                    "file_path": step.get("file_path", ""),
                    "start_line": step.get("start_line", 0),
                })

                # 同表内转换标记
                src_short = src_table.split(".")[-1].upper()
                tgt_short = tgt_table.split(".")[-1].upper()
                if src_short == tgt_short and src_col.upper() != tgt_col.upper():
                    if tgt_id in nodes:
                        nodes[tgt_id]["is_internal_transform"] = True
                        nodes[tgt_id]["transform_note"] = f"同表内: {src_col} → {tgt_col}"

        return edges

    @staticmethod
    def _detect_branches(edges: list[dict]) -> list[dict]:
        """检测分支（汇聚点）：某节点有 >= 2 个不同来源的入边时产生分支。"""
        incoming: dict[str, list[str]] = {}
        for edge in edges:
            tgt = edge["target"]
            src = edge["source"]
            incoming.setdefault(tgt, [])
            if src not in incoming[tgt]:
                incoming[tgt].append(src)

        branches: list[dict] = []
        for tgt_node, sources in incoming.items():
            if len(sources) >= 2:
                main_source = sources[0]
                for alt_source in sources[1:]:
                    branches.append({
                        "merge_point": tgt_node,
                        "source_node": alt_source,
                        "label": f"分支: {alt_source} → {tgt_node}",
                    })

        return branches

    @staticmethod
    def _get_layer_label(layer: str) -> str:
        """获取层级显示标签。"""
        from core.models import LAYER_CONFIG
        config = LAYER_CONFIG.get(layer, {})
        return config.get("label", layer.upper() if layer else "")

    # ===================================================================
    # Summary Card 构建方法
    # ===================================================================

    def build_summary_card(self, table: str, field: str, **kwargs) -> dict:
        """构建指标概览卡数据。

        Args:
            table: 目标表名
            field: 目标字段名
            **kwargs: 传递给 query_caliber 的额外参数 (depth, direction, data_source)

        Returns:
            dict: {"success": True/False, "data": CaliberSummaryCard.asdict() or None}
        """
        start = time.time()

        result = self.query_caliber(table, field, **kwargs)

        chains = result.get("chains", [])
        if not chains:
            return {"success": False, "message": "未找到该字段的口径数据", "data": None}

        target_table = result["target_table"]
        short_table = target_table.split(".")[-1]

        indicator = f"{target_table}.{result['target_column']}"
        indicator_short = f"{short_table}.{result['target_column']}"
        technical_caliber_summary = self._build_technical_summary(chains)
        data_quality_flags = self._detect_quality_flags(result)
        stats = self._build_summary_stats(result)
        caliber_chain_text = [
            step.get("caliber_spec", "")
            for step in chains[0]["steps"]
        ] if chains else []
        query_time_ms = (time.time() - start) * 1000

        card = CaliberSummaryCard(
            indicator=indicator,
            indicator_short=indicator_short,
            technical_caliber_summary=technical_caliber_summary,
            caliber_chain_text=caliber_chain_text,
            stats=stats,
            data_quality_flags=data_quality_flags,
            query_time_ms=query_time_ms,
        )

        return {"success": True, "data": dataclasses.asdict(card)}

    @staticmethod
    def _build_technical_summary(chains: list[dict]) -> str:
        """从链路数据构建技术口径摘要（一行文字链路）。

        Args:
            chains: query_caliber 返回的 chains 列表

        Returns:
            str: 用 " → " 连接的技术口径摘要
        """
        if not chains:
            return ""

        steps = chains[0].get("steps", [])
        if not steps:
            return ""

        parts: list[str] = []
        for i, step in enumerate(steps):
            full_expr = step.get("full_expression", "") or step.get("transform_logic", "")
            src_col = step.get("source_column", "")
            tgt_col = step.get("target_column", "")
            layer = step.get("target_table_layer", "")

            is_first = (i == 0)
            is_last = (i == len(steps) - 1)

            if is_first:
                if full_expr and full_expr != src_col:
                    parts.append(full_expr)
                else:
                    parts.append(src_col)
            elif is_last:
                parts.append(tgt_col)
            else:
                if full_expr and full_expr != src_col:
                    parts.append(f"[{layer} {full_expr}]" if layer else f"[{full_expr}]")
                else:
                    parts.append(src_col)

        return " → ".join(parts)

    @staticmethod
    def _detect_quality_flags(result: dict) -> dict:
        """检测数据质量标记。

        Args:
            result: query_caliber 返回的结果字典

        Returns:
            dict: 质量标记
        """
        flags = {
            "has_hardcoded_values": False,
            "has_cross_schema_join": False,
            "has_null_branch": False,
            "has_custom_function": False,
        }

        hardcoded_pattern = re.compile(r"=\s*['\"]?[01]['\"]?|=\s*\d+")
        null_pattern = re.compile(r"(NVL|COALESCE|IS\s+NULL)", re.IGNORECASE)

        for chain in result.get("chains", []):
            for step in chain.get("steps", []):
                # has_hardcoded_values: 检查 where_conditions 的 raw_text
                for wc in step.get("where_conditions", []):
                    raw_text = wc.get("raw_text", "")
                    if raw_text and hardcoded_pattern.search(raw_text):
                        flags["has_hardcoded_values"] = True

                # has_cross_schema_join: 检查 join_conditions 的 tables_involved
                for jc in step.get("join_conditions", []):
                    tables_involved = jc.get("tables_involved", [])
                    schemas = set()
                    for t in tables_involved:
                        parts = t.split(".")
                        if len(parts) > 1:
                            schemas.add(parts[0])
                    if len(schemas) > 1:
                        flags["has_cross_schema_join"] = True

                # has_null_branch: 检查 full_expression 或 transform_logic
                full_expr = step.get("full_expression", "") or ""
                transform_logic = step.get("transform_logic", "") or ""
                if null_pattern.search(full_expr) or null_pattern.search(transform_logic):
                    flags["has_null_branch"] = True

                # has_custom_function: 检查 custom_functions 列表
                custom_funcs = step.get("custom_functions", [])
                if custom_funcs:
                    flags["has_custom_function"] = True

        return flags

    @staticmethod
    def _build_summary_stats(result: dict) -> dict:
        """构建统计信息。

        Args:
            result: query_caliber 返回的结果字典

        Returns:
            dict: 统计信息
        """
        chains = result.get("chains", [])
        parallel_paths = len(chains)
        total_steps = sum(c.get("depth", 0) for c in chains)

        procedures: set[str] = set()
        tables: set[str] = set()
        custom_functions: set[str] = set()

        for chain in chains:
            for step in chain.get("steps", []):
                proc = step.get("procedure", "")
                if proc:
                    procedures.add(proc)

                for tbl_key in ("target_table", "source_table"):
                    tbl = step.get(tbl_key, "")
                    if tbl:
                        short = tbl.split(".")[-1]
                        tables.add(short)

                for cf in step.get("custom_functions", []):
                    custom_functions.add(cf)

        return {
            "parallel_paths": parallel_paths,
            "total_steps": total_steps,
            "procedures": sorted(procedures),
            "tables": sorted(tables),
            "custom_functions": sorted(custom_functions),
        }

    # ===================================================================
    # Step Detail 构建
    # ===================================================================

    def build_step_detail(
        self, table: str, field: str, step_num: int, procedure: str = "", **kwargs
    ) -> dict:
        """构建单步详情面板数据。

        Args:
            table: 目标表名
            field: 目标字段名
            step_num: 步骤编号
            procedure: 存储过程名 (可选，用于精确定位)
            **kwargs: 传递给 query_caliber 的额外参数
        """
        result = self.query_caliber(table, field, **kwargs)
        chains = result.get("chains", [])
        if not chains:
            return {"success": False, "message": f"未找到步骤 {step_num} 的详情", "data": None}

        # 在 chains 中查找 step_num 匹配的步骤
        # 策略1: 精确匹配 step_num + procedure
        matched_step = None
        for chain in chains:
            for step in chain.get("steps", []):
                if step.get("step_num") == step_num:
                    if procedure and step.get("procedure", "") != procedure:
                        continue
                    matched_step = step
                    break
            if matched_step:
                break

        # 策略2: 如果 step_num 均为 0 (BFS 追溯未赋序号)，按步骤索引定位
        if not matched_step and step_num > 0:
            all_steps = []
            for chain in chains:
                for step in chain.get("steps", []):
                    if procedure and step.get("procedure", "") != procedure:
                        continue
                    all_steps.append(step)
            idx = step_num - 1  # 1-based to 0-based
            if 0 <= idx < len(all_steps):
                matched_step = all_steps[idx]

        # 策略3: 按 procedure 匹配（忽略 step_num）
        if not matched_step and procedure:
            for chain in chains:
                for step in chain.get("steps", []):
                    if step.get("procedure", "") == procedure:
                        matched_step = step
                        break
                if matched_step:
                    break

        if not matched_step:
            return {"success": False, "message": f"未找到步骤 {step_num} 的详情", "data": None}

        detail = StepDetail(
            step_num=matched_step.get("step_num", 0),
            step_desc=matched_step.get("step_desc", ""),
            procedure=matched_step.get("procedure", ""),
            source_table=matched_step.get("source_table", ""),
            target_table=matched_step.get("target_table", ""),
            operation_type=matched_step.get("operation_type", ""),
            source_code_location={
                "file_path": matched_step.get("file_path", ""),
                "start_line": matched_step.get("start_line", 0),
                "end_line": matched_step.get("end_line", 0),
            },
            target_field_expressions=self._build_target_expressions(matched_step),
            step_isolated_where=[
                {
                    "condition_type": c.get("condition_type", ""),
                    "raw_text": c.get("raw_text", ""),
                    "tables_involved": c.get("tables_involved", []),
                }
                for c in (matched_step.get("step_isolated_where") or matched_step.get("where_conditions", []))
            ],
            step_isolated_join=[
                {
                    "condition_type": c.get("condition_type", ""),
                    "raw_text": c.get("raw_text", ""),
                    "tables_involved": c.get("tables_involved", []),
                }
                for c in (matched_step.get("step_isolated_join") or matched_step.get("join_conditions", []))
            ],
            window_functions=matched_step.get("window_functions", []),
            group_by_clause=matched_step.get("group_by_clause", ""),
            having_clause=matched_step.get("having_clause", ""),
            distinct_flag=matched_step.get("distinct_flag", False),
            set_operation=matched_step.get("set_operation", ""),
            order_by_clause=matched_step.get("order_by_clause", ""),
            cte_definitions=self._build_cte_details(matched_step),
            custom_functions=self._build_custom_function_details(matched_step),
            raw_sql=self._read_raw_sql(matched_step),
            confidence=matched_step.get("confidence", 1.0),
        )

        return {"success": True, "data": dataclasses.asdict(detail)}

    @staticmethod
    def _build_target_expressions(step: dict) -> list[dict]:
        """从步骤数据中提取目标字段表达式列表。"""
        expressions: list[dict] = []
        tgt_col = step.get("target_column", "")
        full_expr = step.get("full_expression", "")
        transform_logic = step.get("transform_logic", "")
        src_col = step.get("source_column", "")
        src_table = step.get("source_table", "")

        # 自定义函数检测
        custom_func_pattern = re.compile(r"(PKG_\w+\.\w+|FN_\w+)")
        is_custom = False
        func_name = ""
        if full_expr:
            m = custom_func_pattern.search(full_expr)
            if m:
                is_custom = True
                func_name = m.group(1)

        # 确定表达式优先级: full_expression > select_columns > transform_logic
        expr = ""
        if full_expr and full_expr.upper() != src_col.upper():
            expr = full_expr
        else:
            select_cols = step.get("select_columns", [])
            for sc in select_cols:
                sc_expr = sc.get("source_expression", "")
                sc_tgt = sc.get("target_column", "")
                if sc_tgt.upper() == tgt_col.upper() and sc_expr.upper() != tgt_col.upper():
                    expr = sc_expr
                    break
            if not expr and transform_logic and transform_logic.upper() not in ("DIRECT", src_col.upper()):
                expr = transform_logic

        expressions.append(dataclasses.asdict(TargetFieldExpression(
            target_column=tgt_col,
            expression=expr,
            source_columns=[src_col] if src_col else [],
            source_tables=[src_table] if src_table else [],
            is_custom_function=is_custom,
            custom_function_name=func_name,
        )))

        return expressions

    @staticmethod
    def _build_cte_details(step: dict) -> list[dict]:
        """从步骤数据中构建 CTE 详情列表。"""
        cte_defs = step.get("cte_definitions", [])
        if not cte_defs:
            return []

        details: list[dict] = []
        for cte_text in cte_defs:
            # 尝试提取 CTE 名称 (WITH name AS ...)
            name = ""
            m = re.match(r"(?:WITH\s+)(\w+)", cte_text, re.IGNORECASE)
            if m:
                name = m.group(1)

            details.append(dataclasses.asdict(CTEDetail(
                name=name,
                definition=cte_text,
                source_tables=[],
                consumed_in_step=step.get("step_num", 0),
            )))

        return details

    @staticmethod
    def _build_custom_function_details(step: dict) -> list[dict]:
        """从步骤数据中构建自定义函数详情列表。"""
        custom_funcs = step.get("custom_functions", [])
        if not custom_funcs:
            return []

        details: list[dict] = []
        for func_name in custom_funcs:
            risk = "LOW"
            note = ""
            if re.match(r"PKG_\w+\.", func_name):
                risk = "HIGH"
                note = "自定义包函数，新环境需确认或重写"
            elif re.match(r"(FN_|FUNC_)", func_name):
                risk = "MEDIUM"
                note = "独立自定义函数，可能需迁移"

            details.append(dataclasses.asdict(CustomFunctionDetail(
                name=func_name,
                is_custom=True,
                migration_risk=risk,
                risk_note=note,
            )))

        return details

    @staticmethod
    def _read_raw_sql(step: dict) -> str:
        """从源文件读取指定行号范围的 SQL 文本。"""
        file_path = step.get("file_path", "")
        start_line = step.get("start_line", 0)
        end_line = step.get("end_line", 0)

        if not file_path or start_line <= 0 or end_line <= 0:
            return step.get("raw_sql_fragment", "")

        # 安全检查: 防目录遍历
        if ".." in file_path:
            return "(路径无效)"

        # 限制行号范围
        if end_line - start_line > 500:
            end_line = start_line + 499

        try:
            from pathlib import Path
            p = Path(file_path)
            if not p.exists():
                return "(源文件不可用)"

            lines = p.read_text(encoding="utf-8", errors="ignore").splitlines()
            # 转为 0-based 索引
            selected = lines[max(0, start_line - 1):end_line]
            return "\n".join(line.rstrip() for line in selected)
        except Exception:
            return "(源文件读取失败)"
