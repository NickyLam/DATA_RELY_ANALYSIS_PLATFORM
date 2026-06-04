"""
统一血缘 + 口径追溯引擎（P1 合并方案）

设计目标：
  1. 一次 trace 调用，按需返回拓扑（轻量）或拓扑+口径（含详情）
  2. 共享 BaseTracer 公共索引，避免双份内存占用
  3. BFS 复用 LineageTracer（更成熟，修了 4 个 bug）
  4. 口径详情复用 CaliberTracer 的 5 层 fallback 查找
  5. 提供 O(1) 单边/单节点懒加载 API（供 P2 新增 API 使用）

调用方式：
    tracer = UnifiedTracer(tables, procedures, table_lineages, field_mappings, caliber_infos)
    result = tracer.trace(table, field, depth=10, mode="upstream", with_caliber=False)
    # 单边口径懒加载
    info = tracer.get_edge_caliber(src_table, src_col, tgt_table, tgt_col, procedure="")
    # 单节点详情懒加载
    node = tracer.get_node_detail(table)

向后兼容：
  - LineageTracer / CaliberTracer 保留，UnifiedTracer 通过组合复用其能力
  - P5 阶段再视情况把两者的实现下沉到本文件
"""

from __future__ import annotations

import logging
import time
from dataclasses import dataclass, field
from typing import Any

from core.caliber_tracer import CaliberTracer
from core.lineage_tracer import LineageTracer
from core.models import (
    CaliberResult,
    FieldLineageResult,
    FieldMapping,
    ProcedureInfo,
    TableInfo,
    TableLineage,
)

logger = logging.getLogger(__name__)


@dataclass
class UnifiedNode:
    """图节点（用于前端渲染，比 FieldLineageNode 更精简）"""

    id: str
    table: str
    field: str
    layer: int
    layer_type: str = ""
    is_temp: bool = False
    procedure: str = ""


@dataclass
class UnifiedEdge:
    """图边（携带可选的 caliber_step 引用键）"""

    source_table: str
    source_field: str
    target_table: str
    target_field: str
    procedure: str = ""
    transform_logic: str = ""
    caliber_key: tuple[str, str, str, str, str] | None = None


@dataclass
class UnifiedLineageResult:
    """统一血缘结果。轻量模式下 caliber_steps 为空。"""

    target_table: str
    target_field: str
    mode: str
    nodes: list[UnifiedNode] = field(default_factory=list)
    edges: list[UnifiedEdge] = field(default_factory=list)
    caliber_steps: dict[tuple[str, str, str, str, str], dict] = field(default_factory=dict)
    query_time_ms: float = 0.0
    total_nodes: int = 0
    total_edges: int = 0
    total_chains: int = 0
    max_depth: int = 0


class UnifiedTracer:
    """统一血缘 + 口径追溯引擎。

    内部通过组合复用两个现有 Tracer，
    对外暴露统一的 trace / get_edge_caliber / get_node_detail 接口。
    """

    def __init__(
        self,
        tables: dict[str, TableInfo],
        procedures: dict[str, ProcedureInfo],
        table_lineages: list[TableLineage],
        field_mappings: list[FieldMapping],
        caliber_infos: list[dict] | None = None,
        max_depth: int = 10,
    ) -> None:
        self.tables = tables
        self.procedures = procedures
        self.table_lineages = table_lineages
        self.field_mappings = field_mappings
        self.caliber_infos = caliber_infos or []
        self.max_depth = max_depth

        self._lineage = LineageTracer(
            tables=tables,
            procedures=procedures,
            table_lineages=table_lineages,
            field_mappings=field_mappings,
            max_depth=max_depth,
        )

        self._caliber: CaliberTracer | None = None
        if self.caliber_infos:
            try:
                self._caliber = CaliberTracer(
                    tables=tables,
                    procedures=procedures,
                    table_lineages=table_lineages,
                    field_mappings=field_mappings,
                    caliber_infos=self.caliber_infos,
                    max_depth=max_depth,
                )
            except Exception as e:
                logger.warning("CaliberTracer 初始化失败，口径详情功能将不可用: %s", e)

        logger.info(
            "UnifiedTracer 初始化完成: %d 张表, %d 过程, %d 表级血缘, %d 字段映射, %d 口径",
            len(tables),
            len(procedures),
            len(table_lineages),
            len(field_mappings),
            len(self.caliber_infos),
        )

    # -------------------------------------------------------------------
    # 核心 trace API
    # -------------------------------------------------------------------

    def trace(
        self,
        table: str,
        field: str,
        depth: int | None = None,
        mode: str = "upstream",
        with_caliber: bool = False,
    ) -> UnifiedLineageResult:
        """统一血缘查询。

        Args:
            table: 起始表（任意大小写、可带或不带 schema）
            field: 起始字段
            depth: 最大追溯深度
            mode: "upstream" | "downstream" | "both"
            with_caliber: True 时附加 caliber_steps 详情
        """
        t0 = time.perf_counter()
        depth = depth or self.max_depth

        chains_up = []
        chains_down = []

        if mode in ("upstream", "both"):
            chains_up = self._lineage.trace_field_upstream(table, field, depth)
        if mode in ("downstream", "both"):
            chains_down = self._lineage.trace_field_downstream(table, field, depth)

        nodes, edges, max_layer = self._chains_to_graph(
            chains_up,
            chains_down,
        )

        caliber_steps: dict[tuple[str, str, str, str, str], dict] = {}
        if with_caliber and self._caliber:
            for edge in edges:
                key = (
                    self._short_table(edge.source_table),
                    edge.source_field.upper(),
                    self._short_table(edge.target_table),
                    edge.target_field.upper(),
                    edge.procedure or "",
                )
                edge.caliber_key = key
                ci = self._lookup_caliber_step(
                    edge.source_table,
                    edge.source_field,
                    edge.target_table,
                    edge.target_field,
                    edge.procedure,
                )
                if ci:
                    caliber_steps[key] = ci

        elapsed = (time.perf_counter() - t0) * 1000

        return UnifiedLineageResult(
            target_table=self._lineage.normalize_name(table),
            target_field=field.upper().strip(),
            mode=mode,
            nodes=nodes,
            edges=edges,
            caliber_steps=caliber_steps,
            query_time_ms=round(elapsed, 2),
            total_nodes=len(nodes),
            total_edges=len(edges),
            total_chains=len(chains_up) + len(chains_down),
            max_depth=max_layer,
        )

    # -------------------------------------------------------------------
    # 懒加载 API（供 /api/lineage/edge-caliber 和 node-detail 使用）
    # -------------------------------------------------------------------

    def get_edge_caliber(
        self,
        src_table: str,
        src_column: str,
        tgt_table: str,
        tgt_column: str,
        procedure: str = "",
    ) -> dict | None:
        """O(1) 查询单条边的口径详情。

        命中策略与 CaliberTracer._paths_to_chains 中的匹配逻辑保持一致：
          1. 用 (target_table_short, target_column) 索引取候选
          2. 在候选中按 source_table_short + source_column 精确匹配
          3. 找不到时按 schema variants 重试
          4. 提供 procedure 时进一步过滤
        """
        if not self._caliber:
            return None
        return self._lookup_caliber_step(src_table, src_column, tgt_table, tgt_column, procedure)

    def get_node_detail(self, table: str) -> dict[str, Any]:
        """节点详情：表的字段列表 + 上下游表 + 关联的过程。"""
        norm = self._lineage.normalize_name(table)
        short = self._short_table(norm)

        tbl_info = self.tables.get(norm) or self.tables.get(short)

        fields: list[dict] = []
        if tbl_info and getattr(tbl_info, "columns", None):
            for c in tbl_info.columns:
                fields.append(
                    {
                        "name": getattr(c, "name", "") or getattr(c, "column_name", ""),
                        "type": getattr(c, "data_type", ""),
                        "comment": getattr(c, "comment", ""),
                        "nullable": getattr(c, "nullable", True),
                    }
                )

        upstream = self._lineage.get_upstream_tables(norm)
        downstream = self._lineage.get_downstream_tables(norm)

        proc_idx = getattr(self._lineage, "_table_proc_idx", {})
        procs = proc_idx.get(norm, []) or proc_idx.get(short, [])
        procedures = sorted({p.full_name for p in procs if getattr(p, "full_name", "")})

        return {
            "table": norm,
            "short_name": short,
            "schema": getattr(tbl_info, "schema", "") if tbl_info else "",
            "comment": getattr(tbl_info, "comment", "") if tbl_info else "",
            "fields": fields,
            "upstream_tables": upstream,
            "downstream_tables": downstream,
            "procedures": procedures,
        }

    # -------------------------------------------------------------------
    # 内部工具
    # -------------------------------------------------------------------

    def _chains_to_graph(
        self,
        chains_up: list,
        chains_down: list,
    ) -> tuple[list[UnifiedNode], list[UnifiedEdge], int]:
        nodes_by_id: dict[str, UnifiedNode] = {}
        edges_by_key: dict[tuple, UnifiedEdge] = {}
        max_layer = 0

        def _add_node(
            table: str,
            field: str,
            layer: int,
            layer_type: str,
            is_temp: bool,
            procedure: str,
        ) -> None:
            nid = f"{table}.{field}"
            existing = nodes_by_id.get(nid)
            if existing is None:
                nodes_by_id[nid] = UnifiedNode(
                    id=nid,
                    table=table,
                    field=field,
                    layer=layer,
                    layer_type=layer_type,
                    is_temp=is_temp,
                    procedure=procedure,
                )
            else:
                if layer > existing.layer:
                    existing.layer = layer

        for chain in chains_up:
            for i, node in enumerate(chain.chain):
                _add_node(
                    node.table_name,
                    node.field_name,
                    i,
                    node.layer_type,
                    node.is_temp,
                    node.procedure,
                )
                if i > 0:
                    prev = chain.chain[i - 1]
                    key = (
                        prev.table_name,
                        prev.field_name,
                        node.table_name,
                        node.field_name,
                    )
                    if key not in edges_by_key:
                        edges_by_key[key] = UnifiedEdge(
                            source_table=prev.table_name,
                            source_field=prev.field_name,
                            target_table=node.table_name,
                            target_field=node.field_name,
                            procedure=prev.procedure,
                            transform_logic=prev.transform_logic,
                        )
                if i > max_layer:
                    max_layer = i

        for chain in chains_down:
            for i, node in enumerate(chain.chain):
                _add_node(
                    node.table_name,
                    node.field_name,
                    i,
                    node.layer_type,
                    node.is_temp,
                    node.procedure,
                )
                if i > 0:
                    prev = chain.chain[i - 1]
                    key = (
                        prev.table_name,
                        prev.field_name,
                        node.table_name,
                        node.field_name,
                    )
                    if key not in edges_by_key:
                        edges_by_key[key] = UnifiedEdge(
                            source_table=prev.table_name,
                            source_field=prev.field_name,
                            target_table=node.table_name,
                            target_field=node.field_name,
                            procedure=node.procedure,
                            transform_logic=node.transform_logic,
                        )
                if i > max_layer:
                    max_layer = i

        return list(nodes_by_id.values()), list(edges_by_key.values()), max_layer

    def _lookup_caliber_step(
        self,
        src_table: str,
        src_column: str,
        tgt_table: str,
        tgt_column: str,
        procedure: str = "",
    ) -> dict | None:
        if not self._caliber:
            return None

        norm_src = self._lineage.normalize_name(src_table)
        norm_tgt = self._lineage.normalize_name(tgt_table)
        src_short = self._short_table(norm_src)
        tgt_short = self._short_table(norm_tgt)
        src_col = src_column.upper().strip()
        tgt_col = tgt_column.upper().strip()

        target_idx = getattr(self._caliber, "_target_idx", {})
        candidates = target_idx.get((tgt_short, tgt_col), []) or target_idx.get((norm_tgt, tgt_col), [])
        if not candidates:
            return None

        matched: list[dict] = []
        for r in candidates:
            r_src = r.get("source_table", "").upper()
            r_src_short = r_src.split(".")[-1] if "." in r_src else r_src
            r_src_col = r.get("source_column", "").upper()

            if r_src_short == src_short and r_src_col == src_col:
                matched.append(r)

        if not matched and src_short:
            for r in candidates:
                r_src_col = r.get("source_column", "").upper()
                if r_src_col == src_col:
                    matched.append(r)

        if not matched:
            return None

        if procedure:
            proc_filtered = [r for r in matched if r.get("procedure", "") == procedure]
            if proc_filtered:
                matched = proc_filtered

        return matched[0]

    @staticmethod
    def _short_table(table: str) -> str:
        if not table:
            return ""
        return table.split(".")[-1].upper() if "." in table else table.upper()

    # -------------------------------------------------------------------
    # 委托给底层 Tracer 的便捷方法
    # -------------------------------------------------------------------

    def trace_field(self, table: str, field: str) -> FieldLineageResult:
        return self._lineage.trace_field(table, field)

    def trace_caliber(
        self,
        table: str,
        field: str,
        direction: str = "upstream",
        max_depth: int | None = None,
        data_source: str | None = None,
    ) -> CaliberResult | None:
        if not self._caliber:
            return None
        return self._caliber.trace_caliber(
            target_table=table,
            target_field=field,
            direction=direction,
            max_depth=max_depth,
            data_source=data_source,
        )

    @property
    def lineage_tracer(self) -> LineageTracer:
        return self._lineage

    @property
    def caliber_tracer(self) -> CaliberTracer | None:
        return self._caliber
