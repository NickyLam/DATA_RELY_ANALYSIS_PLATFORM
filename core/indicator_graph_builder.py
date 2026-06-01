"""
指标血缘图构建器
从解析后的配置数据构建指标间依赖关系图，支持BFS上下游追溯和加工链路提取
"""

from __future__ import annotations

import logging
import time
from collections import deque

from core.indicator_models import (
    ALGO_TYPE_LABELS,
    MEASURE_LABELS,
    IndicatorCalcBase,
    IndicatorCalcGL,
    IndicatorChain,
    IndicatorChainStep,
    IndicatorConfigResult,
    IndicatorLineageEdge,
    IndicatorLineageGraph,
    IndicatorLineageNode,
    IndicatorLineageResult,
    IndicatorRel,
)
from core.indicator_sql_parser import IndicatorSQLParser

logger = logging.getLogger(__name__)

_AMT_VAL_LABELS: dict[str, str] = {
    "term_end_dr_bal": "期末借方余额",
    "term_end_report_dr_bal": "报表期末借方余额",
    "y_term_begi_dr_bal": "年初借方余额",
    "y_term_begi_report_dr_bal": "报表年初借方余额",
    "dr_amt": "借方发生额",
    "term_end_dr_m_avg_bal": "期末借方月日均余额",
    "term_end_dr_q_avg_bal": "期末借方季日均余额",
    "term_end_dr_y_avg_bal": "期末借方年日均余额",
    "dr_m_accum_amt": "借方月累计发生额",
    "dr_q_accum_amt": "借方季累计发生额",
    "dr_y_accum_amt": "借方年累计发生额",
    "report_dr_y_accum_amt": "报表借方年累计发生额",
    "report_dr_q_accum_amt": "报表借方季累计发生额",
    "q_term_begi_dr_bal": "季初借方余额",
    "q_term_begi_report_dr_bal": "报表季初借方余额",
    "dr_amt_accum": "借方发生额累计",
    "report_dr_amt_accum": "报表借方发生额累计",
}

_BRCH_TYPE_LABELS: dict[str, str] = {
    "1": "明细机构",
    "2": "一级分行",
    "3": "全行",
    "4": "虚拟机构",
}


class IndicatorGraphBuilder:
    """指标血缘图构建器"""

    def __init__(self, config_result: IndicatorConfigResult) -> None:
        self.config = config_result
        self._sql_parser = IndicatorSQLParser()
        self._nodes: dict[str, IndicatorLineageNode] = {}
        self._edges: list[IndicatorLineageEdge] = []
        self._adjacency: dict[str, list[str]] = {}
        self._reverse_adjacency: dict[str, list[str]] = {}
        self._base_calc_idx: dict[str, list[IndicatorCalcBase]] = {}
        self._gl_calc_idx: dict[str, list[IndicatorCalcGL]] = {}
        self._rel_idx: dict[str, IndicatorRel] = {}
        self._edge_by_id: dict[str, IndicatorLineageEdge] = {}
        self._edges_by_source: dict[str, list[IndicatorLineageEdge]] = {}
        self._edges_by_target: dict[str, list[IndicatorLineageEdge]] = {}
        self._built = False

    def build_full_graph(self) -> IndicatorLineageGraph:
        if self._built:
            return self._get_current_graph()

        self._build_indexes()
        self._build_gl_nodes()
        self._build_base_nodes()
        self._build_derive_edges()
        self._build_procedure_nodes()
        self._built = True

        graph = self._get_current_graph()
        logger.info(
            "指标血缘图构建完成: %d 节点, %d 边",
            graph.node_count,
            graph.edge_count,
        )
        return graph

    def trace_indicator(
        self,
        index_no: str,
        measure: str = "",
        direction: str = "upstream",
        max_depth: int = 10,
    ) -> IndicatorLineageResult:
        start_time = time.time()

        self.build_full_graph()

        start_node_id = self._find_start_node(index_no, measure)
        if not start_node_id:
            elapsed = (time.time() - start_time) * 1000
            return IndicatorLineageResult(
                target_index_no=index_no,
                target_measure=measure,
                query_time_ms=elapsed,
            )

        if direction in ("upstream", "both"):
            upstream_nodes, upstream_edges = self._bfs(
                start_node_id,
                reverse=True,
                max_depth=max_depth,
            )
        else:
            upstream_nodes, upstream_edges = set(), []

        if direction in ("downstream", "both"):
            downstream_nodes, downstream_edges = self._bfs(
                start_node_id,
                reverse=False,
                max_depth=max_depth,
            )
        else:
            downstream_nodes, downstream_edges = set(), []

        all_node_ids = upstream_nodes | downstream_nodes | {start_node_id}
        seen_edge_ids: set[str] = set()
        all_edges: list[IndicatorLineageEdge] = []
        for e in upstream_edges + downstream_edges:
            if e.edge_id not in seen_edge_ids:
                seen_edge_ids.add(e.edge_id)
                all_edges.append(e)

        sub_nodes = [self._nodes[nid] for nid in all_node_ids if nid in self._nodes]
        sub_graph = IndicatorLineageGraph(
            nodes=sub_nodes,
            edges=all_edges,
            stats=self._compute_stats(sub_nodes, all_edges),
        )

        chains = self._extract_chains(
            index_no,
            measure,
            start_node_id,
            direction,
            max_depth,
        )

        elapsed = (time.time() - start_time) * 1000
        return IndicatorLineageResult(
            target_index_no=index_no,
            target_measure=measure,
            graph=sub_graph,
            chains=chains,
            query_time_ms=elapsed,
        )

    def get_indicator_detail(self, index_no: str) -> dict:
        self.build_full_graph()

        base_calcs = self._base_calc_idx.get(index_no, [])
        gl_calcs = self._gl_calc_idx.get(index_no, [])
        rel = self._rel_idx.get(index_no)

        measures: list[dict] = []
        seen_measures: set[str] = set()
        for c in base_calcs:
            if c.index_measure not in seen_measures:
                seen_measures.add(c.index_measure)
                measures.append(
                    {
                        "code": c.index_measure,
                        "label": MEASURE_LABELS.get(c.index_measure, c.index_measure),
                        "algo_type": c.algo_type,
                        "algo_label": ALGO_TYPE_LABELS.get(c.algo_type, c.algo_type),
                        "src_table": c.src_table_name,
                        "has_sql": bool(c.sqlcc),
                    }
                )
        for c in gl_calcs:
            if c.index_measure not in seen_measures:
                seen_measures.add(c.index_measure)
                measures.append(
                    {
                        "code": c.index_measure,
                        "label": MEASURE_LABELS.get(c.index_measure, c.index_measure),
                        "algo_type": "2",
                        "algo_label": "总账取数",
                    }
                )

        gl_mappings: list[dict] = []
        for c in gl_calcs:
            gl_mappings.append(
                {
                    "subj_no": c.subj_no,
                    "length_val": c.length_val,
                    "sign_no": c.sign_no,
                    "sign_label": "借方" if c.sign_no == 1 else "贷方",
                    "amt_val": c.amt_val,
                    "amt_val_label": _AMT_VAL_LABELS.get(c.amt_val, c.amt_val),
                    "measure": c.index_measure,
                    "measure_label": MEASURE_LABELS.get(c.index_measure, c.index_measure),
                }
            )

        upstream: list[str] = []
        downstream: list[str] = []
        if rel:
            upstream = rel.depend_index_nos
        for other_rel in self.config.relations:
            if index_no in other_rel.depend_index_nos:
                if other_rel.index_no not in downstream:
                    downstream.append(other_rel.index_no)

        return {
            "index_no": index_no,
            "measures": measures,
            "gl_mappings": gl_mappings,
            "upstream_indices": upstream,
            "downstream_indices": downstream,
            "is_base": bool(base_calcs) and not rel,
            "is_derived": bool(rel),
            "is_gl": bool(gl_calcs),
        }

    def search_indicators(self, keyword: str, limit: int = 50) -> list[dict]:
        self.build_full_graph()
        keyword_upper = keyword.upper().strip()
        if not keyword_upper:
            return []

        results: list[dict] = []
        seen: set[str] = set()

        for index_no in self._base_calc_idx:
            if keyword_upper in index_no.upper() and index_no not in seen:
                seen.add(index_no)
                calcs = self._base_calc_idx[index_no]
                measures = sorted({c.index_measure for c in calcs})
                results.append(
                    {
                        "index_no": index_no,
                        "measures": measures,
                        "source_type": "base",
                        "is_derived": index_no in self._rel_idx,
                    }
                )

        for index_no in self._gl_calc_idx:
            if keyword_upper in index_no.upper() and index_no not in seen:
                seen.add(index_no)
                calcs = self._gl_calc_idx[index_no]
                measures = sorted({c.index_measure for c in calcs})
                results.append(
                    {
                        "index_no": index_no,
                        "measures": measures,
                        "source_type": "gl",
                        "is_derived": index_no in self._rel_idx,
                    }
                )

        for rel in self.config.relations:
            if keyword_upper in rel.index_no.upper() and rel.index_no not in seen:
                seen.add(rel.index_no)
                results.append(
                    {
                        "index_no": rel.index_no,
                        "measures": [],
                        "source_type": "derived",
                        "is_derived": True,
                    }
                )

        return results[:limit]

    def get_pipeline_steps(
        self,
        index_no: str,
        measure: str = "",
    ) -> list[dict]:
        self.build_full_graph()

        steps: list[dict] = []
        procedure_map = self.config.procedures

        for proc_name, proc_info in sorted(
            procedure_map.items(),
            key=lambda x: x[1].step_order,
        ):
            involved = False
            detail = ""

            if proc_name == "PRO_F_INDEX_CALC_GL":
                gl_calcs = self._gl_calc_idx.get(index_no, [])
                if gl_calcs:
                    involved = True
                    mappings = [
                        f"科目{c.subj_no}({'借' if c.sign_no == 1 else '贷'})×{c.amt_val}" for c in gl_calcs[:3]
                    ]
                    detail = f"{len(gl_calcs)}条科目映射: {', '.join(mappings)}"

            elif proc_name == "PRO_F_INDEX_CALC_BASE":
                base_calcs = self._base_calc_idx.get(index_no, [])
                relevant = [c for c in base_calcs if not measure or c.index_measure == measure]
                if relevant:
                    involved = True
                    detail = f"{len(relevant)}条基础算法配置, 源表: {relevant[0].src_table_name}"

            elif proc_name == "PRO_F_INDEX_CALC_BRCHSUM":
                if index_no in self._base_calc_idx or index_no in self._gl_calc_idx:
                    involved = True
                    base_calcs = self._base_calc_idx.get(index_no, [])
                    is_agg = any(c.index_flag and "A" in c.index_flag for c in base_calcs)
                    detail = "汇总型指标(直接迁入)" if is_agg else "SUM汇总: 明细→分行→全行"

            elif proc_name == "PRO_F_INDEX_CALC_DERIVE":
                rel = self._rel_idx.get(index_no)
                if rel:
                    involved = True
                    relevant = [
                        c for c in self._base_calc_idx.get(index_no, []) if not measure or c.index_measure == measure
                    ]
                    algo = relevant[0].algo_type if relevant else ""
                    algo_label = ALGO_TYPE_LABELS.get(algo, algo) if algo else "衍生计算"
                    detail = f"依赖: {', '.join(rel.depend_index_nos[:5])}, 算法: {algo_label}"

            steps.append(
                {
                    "step_order": proc_info.step_order,
                    "proc_name": proc_name,
                    "description": proc_info.description or f"STEP {proc_info.step_order}",
                    "involved": involved,
                    "detail": detail,
                    "target_table": proc_info.target_table,
                }
            )

        return steps

    def get_stats(self) -> dict:
        self.build_full_graph()
        graph = self._get_current_graph()

        indicator_count = sum(1 for n in self._nodes.values() if n.node_type in ("indicator", "measure"))
        table_count = sum(1 for n in self._nodes.values() if n.node_type == "table")
        subject_count = sum(1 for n in self._nodes.values() if n.node_type == "field")

        return {
            "total_nodes": graph.node_count,
            "total_edges": graph.edge_count,
            "indicator_nodes": indicator_count,
            "table_nodes": table_count,
            "subject_nodes": subject_count,
            "base_calc_count": self.config.base_calc_count,
            "gl_calc_count": self.config.gl_calc_count,
            "relation_count": self.config.relation_count,
            "unique_index_count": len(self._base_calc_idx) + len(self._gl_calc_idx),
            "procedure_count": self.config.procedure_count,
        }

    def _build_indexes(self) -> None:
        for c in self.config.base_calcs:
            self._base_calc_idx.setdefault(c.index_no, []).append(c)
        for c in self.config.gl_calcs:
            self._gl_calc_idx.setdefault(c.index_no, []).append(c)
        for r in self.config.relations:
            self._rel_idx[r.index_no] = r

    def _build_gl_nodes(self) -> None:
        gl_source = "FML_IDX_ADM_GL_INFO"

        for index_no, calcs in self._gl_calc_idx.items():
            indicator_node_id = f"IND_{index_no}"
            self._ensure_node(
                indicator_node_id,
                "indicator",
                index_no=index_no,
                label=index_no,
                layer="FDL_IDX",
            )

            for calc in calcs:
                measure_node_id = f"IND_{index_no}_{calc.index_measure}"
                measure_label = MEASURE_LABELS.get(
                    calc.index_measure,
                    calc.index_measure,
                )
                self._ensure_node(
                    measure_node_id,
                    "measure",
                    index_no=index_no,
                    index_measure=calc.index_measure,
                    label=f"{index_no}[{measure_label}]",
                    layer="FDL_IDX",
                    detail={
                        "sign_no": calc.sign_no,
                        "amt_val": calc.amt_val,
                        "amt_val_label": _AMT_VAL_LABELS.get(
                            calc.amt_val,
                            calc.amt_val,
                        ),
                    },
                )

                self._add_edge(
                    measure_node_id,
                    indicator_node_id,
                    edge_type="data_flow",
                    procedure="PRO_F_INDEX_CALC_GL",
                    transform_logic=f"sign({calc.sign_no}) × {calc.amt_val}",
                )

                subject_node_id = f"SUBJ_{calc.subj_no}_{calc.length_val}"
                self._ensure_node(
                    subject_node_id,
                    "field",
                    label=f"科目{calc.subj_no}({calc.length_val}位)",
                    layer="IML",
                    detail={
                        "subj_no": calc.subj_no,
                        "length_val": calc.length_val,
                    },
                )

                self._add_edge(
                    subject_node_id,
                    measure_node_id,
                    edge_type="gl_mapping",
                    procedure="PRO_F_INDEX_CALC_GL",
                    transform_logic=(
                        f"substr(subj_no,1,{calc.length_val})='{calc.subj_no}' → sign({calc.sign_no})×{calc.amt_val}"
                    ),
                    algo_type="2",
                )

        if self._gl_calc_idx:
            self._ensure_node(gl_source, "table", label=gl_source, layer="IML")
            seen_subjects: set[str] = set()
            for calcs in self._gl_calc_idx.values():
                for calc in calcs:
                    subject_node_id = f"SUBJ_{calc.subj_no}_{calc.length_val}"
                    if subject_node_id not in seen_subjects:
                        seen_subjects.add(subject_node_id)
                        self._add_edge(
                            gl_source,
                            subject_node_id,
                            edge_type="data_flow",
                            procedure="PRO_F_INDEX_CALC_GL",
                        )

    def _build_base_nodes(self) -> None:
        for index_no, calcs in self._base_calc_idx.items():
            indicator_node_id = f"IND_{index_no}"
            self._ensure_node(
                indicator_node_id,
                "indicator",
                index_no=index_no,
                label=index_no,
                layer="FDL_IDX",
            )

            for calc in calcs:
                measure_node_id = f"IND_{index_no}_{calc.index_measure}"
                measure_label = MEASURE_LABELS.get(
                    calc.index_measure,
                    calc.index_measure,
                )
                self._ensure_node(
                    measure_node_id,
                    "measure",
                    index_no=index_no,
                    index_measure=calc.index_measure,
                    index_type="1",
                    algo_type=calc.algo_type,
                    label=f"{index_no}[{measure_label}]",
                    layer="FDL_IDX",
                    detail={
                        "algo_type": calc.algo_type,
                        "algo_label": ALGO_TYPE_LABELS.get(
                            calc.algo_type,
                            calc.algo_type,
                        ),
                        "src_table": calc.src_table_name,
                        "index_flag": calc.index_flag,
                    },
                )

                self._add_edge(
                    measure_node_id,
                    indicator_node_id,
                    edge_type="data_flow",
                    procedure="PRO_F_INDEX_CALC_BASE",
                )

                if calc.src_table_name:
                    for src_table in calc.src_table_name.split(","):
                        src_table = src_table.strip().upper()
                        if not src_table:
                            continue
                        table_node_id = f"TBL_{src_table}"
                        self._ensure_node(
                            table_node_id,
                            "table",
                            label=src_table,
                            layer="IML",
                        )
                        self._add_edge(
                            table_node_id,
                            measure_node_id,
                            edge_type="data_flow",
                            procedure="PRO_F_INDEX_CALC_BASE",
                            algo_type=calc.algo_type,
                            transform_logic=calc.measure_sql or "",
                        )

    def _build_derive_edges(self) -> None:
        for rel in self.config.relations:
            target_indicator_id = f"IND_{rel.index_no}"

            target_calcs = self._base_calc_idx.get(rel.index_no, [])
            if target_calcs:
                self._ensure_node(
                    target_indicator_id,
                    "indicator",
                    index_no=rel.index_no,
                    label=rel.index_no,
                    layer="FDL_IDX",
                )

            for dep_no in rel.depend_index_nos:
                dep_indicator_id = f"IND_{dep_no}"
                self._ensure_node(
                    dep_indicator_id,
                    "indicator",
                    index_no=dep_no,
                    label=dep_no,
                    layer="FDL_IDX",
                )

                algo_type = ""
                condition_sql = ""
                measure_sql = ""
                for c in target_calcs:
                    if c.algo_type:
                        algo_type = c.algo_type
                        condition_sql = c.condition_sql
                        measure_sql = c.measure_sql
                        break

                self._add_edge(
                    dep_indicator_id,
                    target_indicator_id,
                    edge_type="calc_dependency",
                    procedure="PRO_F_INDEX_CALC_DERIVE",
                    algo_type=algo_type,
                    condition_sql=condition_sql,
                    measure_sql=measure_sql,
                    transform_logic=self._build_derive_logic(
                        algo_type,
                        condition_sql,
                        measure_sql,
                    ),
                )

    def _build_procedure_nodes(self) -> None:
        for proc_name, proc_info in self.config.procedures.items():
            proc_node_id = f"PROC_{proc_name}"
            self._ensure_node(
                proc_node_id,
                "procedure",
                label=proc_name,
                layer="PROC",
                detail={
                    "step_order": proc_info.step_order,
                    "config_table": proc_info.config_table,
                    "target_table": proc_info.target_table,
                },
            )

    def _build_derive_logic(
        self,
        algo_type: str,
        condition_sql: str,
        measure_sql: str,
    ) -> str:
        if algo_type == "1":
            return f"通用算法: {measure_sql or 'SUM聚合'}"
        if algo_type == "3":
            return "年化通用算法: (增量/日均基数)×(年天数/期间天数)"
        if algo_type == "2":
            return "自定义SQL算法"
        return "衍生计算"

    def _ensure_node(
        self,
        node_id: str,
        node_type: str,
        **kwargs: object,
    ) -> IndicatorLineageNode:
        if node_id not in self._nodes:
            node = IndicatorLineageNode(
                node_id=node_id,
                node_type=node_type,
                **kwargs,  # type: ignore[arg-type]
            )
            self._nodes[node_id] = node
        return self._nodes[node_id]

    def _add_edge(
        self,
        source_id: str,
        target_id: str,
        edge_type: str = "data_flow",
        **kwargs: object,
    ) -> None:
        edge_id = f"{source_id}->{target_id}"
        if edge_id in self._edge_by_id:
            return

        edge = IndicatorLineageEdge(
            edge_id=edge_id,
            source_id=source_id,
            target_id=target_id,
            edge_type=edge_type,  # type: ignore[arg-type]
            **kwargs,  # type: ignore[arg-type]
        )
        self._edges.append(edge)
        self._edge_by_id[edge_id] = edge
        self._edges_by_source.setdefault(source_id, []).append(edge)
        self._edges_by_target.setdefault(target_id, []).append(edge)

        self._adjacency.setdefault(source_id, []).append(target_id)
        self._reverse_adjacency.setdefault(target_id, []).append(source_id)

    def _find_start_node(self, index_no: str, measure: str = "") -> str | None:
        if measure:
            measure_node_id = f"IND_{index_no}_{measure}"
            if measure_node_id in self._nodes:
                return measure_node_id

        indicator_node_id = f"IND_{index_no}"
        if indicator_node_id in self._nodes:
            return indicator_node_id

        for nid in self._nodes:
            if index_no.upper() in nid.upper():
                return nid

        return None

    def _bfs(
        self,
        start_id: str,
        reverse: bool = False,
        max_depth: int = 10,
    ) -> tuple[set[str], list[IndicatorLineageEdge]]:
        visited: set[str] = set()
        reached_nodes: set[str] = set()
        reached_edges: list[IndicatorLineageEdge] = []

        adj = self._reverse_adjacency if reverse else self._adjacency
        edge_lookup = self._edges_by_target if reverse else self._edges_by_source
        queue: deque[tuple[str, int]] = deque([(start_id, 0)])
        visited.add(start_id)

        while queue:
            current_id, depth = queue.popleft()
            if depth >= max_depth:
                continue

            neighbors = adj.get(current_id, [])
            for neighbor_id in neighbors:
                if neighbor_id in visited:
                    continue
                visited.add(neighbor_id)
                reached_nodes.add(neighbor_id)

                if reverse:
                    for edge in edge_lookup.get(current_id, []):
                        if edge.source_id == neighbor_id:
                            reached_edges.append(edge)
                            break
                else:
                    for edge in edge_lookup.get(current_id, []):
                        if edge.target_id == neighbor_id:
                            reached_edges.append(edge)
                            break

                queue.append((neighbor_id, depth + 1))

        return reached_nodes, reached_edges

    def _extract_chains(
        self,
        index_no: str,
        measure: str,
        start_node_id: str,
        direction: str,
        max_depth: int,
    ) -> list[IndicatorChain]:
        if direction not in ("upstream", "both"):
            return []

        chains: list[IndicatorChain] = []
        paths = self._find_all_paths(
            start_node_id,
            reverse=True,
            max_depth=max_depth,
        )

        for path in paths[:20]:
            steps: list[IndicatorChainStep] = []
            for i, node_id in enumerate(path):
                node = self._nodes.get(node_id)
                if not node:
                    continue

                incoming_edges = self._edges_by_target.get(node_id, [])
                edge = incoming_edges[0] if incoming_edges else None

                step = IndicatorChainStep(
                    step_num=i + 1,
                    index_no=node.index_no or "",
                    index_measure=node.index_measure or "",
                    index_type=node.index_type or "",
                    algo_type=node.algo_type or (edge.algo_type if edge else ""),
                    procedure=edge.procedure if edge else "",
                    transform_logic=edge.transform_logic if edge else "",
                    condition_sql=edge.condition_sql if edge else "",
                    measure_sql=edge.measure_sql if edge else "",
                    gl_subj_no=node.detail.get("subj_no", "") if node.detail else "",
                    gl_amt_val=node.detail.get("amt_val", "") if node.detail else "",
                    gl_sign_no=int(node.detail.get("sign_no", 0)) if node.detail else 0,
                )
                if node.node_type == "table":
                    step.source_tables = [node.label]
                steps.append(step)

            if steps:
                chains.append(
                    IndicatorChain(
                        target_index_no=index_no,
                        target_measure=measure,
                        steps=steps,
                        depth=len(steps),
                    )
                )

        return chains

    def _find_all_paths(
        self,
        start_id: str,
        reverse: bool = False,
        max_depth: int = 10,
    ) -> list[list[str]]:
        paths: list[list[str]] = []
        adj = self._reverse_adjacency if reverse else self._adjacency

        def _dfs(current: str, path: list[str], depth: int) -> None:
            if depth > max_depth:
                return
            neighbors = adj.get(current, [])
            if not neighbors:
                paths.append(path[:])
                return
            for neighbor in neighbors:
                if neighbor in path:
                    continue
                path.append(neighbor)
                _dfs(neighbor, path, depth + 1)
                path.pop()

        _dfs(start_id, [start_id], 0)
        paths.sort(key=len, reverse=True)
        return paths

    def _get_current_graph(self) -> IndicatorLineageGraph:
        return IndicatorLineageGraph(
            nodes=list(self._nodes.values()),
            edges=list(self._edges),
            stats=self._compute_stats(
                list(self._nodes.values()),
                self._edges,
            ),
        )

    @staticmethod
    def _compute_stats(
        nodes: list[IndicatorLineageNode],
        edges: list[IndicatorLineageEdge],
    ) -> dict:
        node_type_counts: dict[str, int] = {}
        edge_type_counts: dict[str, int] = {}
        for n in nodes:
            node_type_counts[n.node_type] = node_type_counts.get(n.node_type, 0) + 1
        for e in edges:
            edge_type_counts[e.edge_type] = edge_type_counts.get(e.edge_type, 0) + 1
        return {
            "node_type_counts": node_type_counts,
            "edge_type_counts": edge_type_counts,
        }
