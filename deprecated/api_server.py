"""
数据血缘查询 HTTP API 服务（纯 Python 标准库实现）

提供以下接口：
  GET  /api/tables?keyword=xxx          → 表列表搜索
  GET  /api/tables/{table_name}/fields → 某表字段列表
  POST /api/lineage/query              → 字段血缘查询（主体接口）
  GET  /api/lineage/{table}/{field}    → 血缘查询 GET 快捷方式
  GET  /api/stats                      → 系统统计信息
  GET  /                              → 前端首页（index.html）
  GET  /static/*                      → 静态文件服务

启动方式：
  python api_server.py --port 8080 --dir RRP_ORACLE
"""

from __future__ import annotations

import argparse
import json
import logging
import mimetypes
import os
import re
import sys
import time
import urllib.parse
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path
from typing import Any, Optional

from core.caliber_extractor import CaliberExtractor
from core.lineage_tracer import LineageTracer
from core.models import (
    CaliberChain,
    CaliberInfo,
    CaliberResult,
    FieldLineageNode,
    TableInfo,
    detect_layer,
)
from core.procedure_parser import EnhancedProcedureParser
from core.table_name_resolver import TableNameResolver
from core.table_parser import OracleTableParser


def is_frozen() -> bool:
    """检测是否在 PyInstaller 打包模式下运行"""
    return getattr(sys, "frozen", False) and hasattr(sys, "_MEIPASS")


def get_base_dir() -> Path:
    """获取应用基础目录"""
    if is_frozen():
        return Path(sys._MEIPASS)
    return Path(__file__).parent


def get_static_dir() -> Path:
    """获取静态文件目录"""
    return get_base_dir() / "static"


def get_data_dir() -> Path:
    """获取数据目录 (RRP_ORACLE)"""
    return get_base_dir() / "RRP_ORACLE"


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
logger = logging.getLogger(__name__)


# ===========================================================================
# 全局状态：启动时初始化，Handler 通过类属性访问
# ===========================================================================
_tracer: Optional[LineageTracer] = None
_tables: dict[str, TableInfo] = {}
_procedures: dict[str, Any] = {}
_proc_table_names: dict[str, set] = {}  # {upper_name: set of fields}
_procedures_count: int = 0
_table_lineages_count: int = 0
_field_mappings_count: int = 0
_static_dir: str = "static"
_start_time: float = 0.0  # 服务启动时间（Unix 时间戳）
_indicator_graph_builder: Optional[Any] = None  # 指标图构建器
_indicator_config_result: Optional[Any] = None   # 指标配置结果


def _init_engine(prc_dir: str) -> None:
    global _tracer, _tables, _procedures, _proc_table_names
    global _procedures_count, _table_lineages_count, _field_mappings_count

    logger.info("正在扫描目录: %s", prc_dir)

    table_parser = OracleTableParser()
    logger.info("步骤 1/3: 解析表结构...")
    for subdir in ["rrp_mdl", "rrp_east"]:
        full_dir = os.path.join(prc_dir, subdir)
        if os.path.isdir(full_dir):
            logger.info("  正在解析: %s", subdir)
            table_parser.parse_directory(full_dir)
            logger.info("  目录扫描完成: %s", full_dir)
    _tables = table_parser.tables
    logger.info("表结构解析完成: %d 张表", len(_tables))

    logger.info("步骤 2/3: 解析存储过程...")
    parser = EnhancedProcedureParser(tables=_tables)
    procedures: dict = {}
    for subdir in ["rrp_mdl", "rrp_east"]:
        full_dir = os.path.join(prc_dir, subdir)
        if os.path.isdir(full_dir):
            logger.info("  正在解析: %s", subdir)
            procedures.update(parser.parse_directory(full_dir))
            logger.info("  目录扫描完成: %s, 共解析 %d 个存储过程", full_dir, len(procedures))
    _procedures = {k: v.__dict__ for k, v in procedures.items()}
    _procedures_count = len(procedures)
    logger.info("存储过程解析完成: %d 个过程", _procedures_count)

    logger.info("步骤 3/3: 构建血缘索引...")

    all_table_lineages: list = []
    all_field_mappings: list = []
    for proc in procedures.values():
        if proc.table_lineages:
            all_table_lineages.extend(proc.table_lineages)
        if proc.field_mappings:
            all_field_mappings.extend(proc.field_mappings)

    _table_lineages_count = len(all_table_lineages)
    _field_mappings_count = len(all_field_mappings)

    for proc in procedures.values():
        for tbl in proc.source_tables:
            key = tbl.upper()
            if key not in _proc_table_names:
                _proc_table_names[key] = set()
        for tbl in proc.target_tables:
            key = tbl.upper()
            if key not in _proc_table_names:
                _proc_table_names[key] = set()
        for fm in proc.field_mappings:
            tgt_key = fm.target_table.upper()
            if tgt_key not in _proc_table_names:
                _proc_table_names[tgt_key] = set()
            if fm.target_column:
                _proc_table_names[tgt_key].add(fm.target_column.upper())
            src_key = fm.source_table.upper()
            if src_key and src_key not in _proc_table_names:
                _proc_table_names[src_key] = set()
            if src_key and fm.source_column:
                _proc_table_names[src_key].add(fm.source_column.upper())

    _tracer = LineageTracer(
        tables=_tables,
        procedures=procedures,
        table_lineages=all_table_lineages,
        field_mappings=all_field_mappings,
    )

    logger.info(
        "引擎初始化完成: %d 个过程, %d 条表级血缘, %d 条字段映射, %d 张表",
        _procedures_count,
        _table_lineages_count,
        _field_mappings_count,
        len(_tables),
    )

    # 步骤 4: 初始化指标血缘服务
    _init_indicator_service()


def _init_indicator_service() -> None:
    """初始化指标血缘服务（从财务集市指标血缘分析/指标目录加载配置）"""
    global _indicator_graph_builder, _indicator_config_result

    base_dir = get_base_dir()
    indicator_data_path = base_dir / "财务集市指标血缘分析" / "指标"

    if not indicator_data_path.exists():
        logger.warning("指标数据目录不存在: %s，跳过指标服务初始化", indicator_data_path)
        return

    try:
        from core.indicator_config_parser import IndicatorConfigParser
        from core.indicator_graph_builder import IndicatorGraphBuilder

        logger.info("步骤 4: 初始化指标血缘服务...")
        parser = IndicatorConfigParser(indicator_data_path)  # Path 对象
        _indicator_config_result = parser.parse_all()
        _indicator_graph_builder = IndicatorGraphBuilder(_indicator_config_result)
        _indicator_graph_builder.build_full_graph()
        logger.info(
            "指标血缘服务初始化完成: %d 基础指标, %d 总账指标",
            _indicator_config_result.base_calc_count,
            _indicator_config_result.gl_calc_count,
        )
    except Exception as exc:
        logger.error("指标血缘服务初始化失败: %s", exc, exc_info=True)


# ===========================================================================
# 序列化辅助：将 dataclass 对象转为可 JSON 序列化的 dict
# ===========================================================================


def _serialize_node(node: FieldLineageNode) -> dict[str, Any]:
    """将 FieldLineageNode 转为字典。"""
    return {
        "layer": node.layer,
        "table_name": node.table_name,
        "field_name": node.field_name,
        "procedure": node.procedure,
        "is_temp": node.is_temp,
        "transform_logic": node.transform_logic,
        "source_fields": node.source_fields,
        "layer_type": node.layer_type,
    }


def _serialize_chain(chain: Any) -> dict[str, Any]:
    """将 FieldLineageChain 转为字典。"""
    return {
        "depth": chain.depth,
        "chain": [_serialize_node(n) for n in chain.chain],
    }


def _serialize_result(result: Any) -> dict[str, Any]:
    """将 FieldLineageResult 转为完整响应数据（旧格式，保留兼容）。"""
    return {
        "target_table": result.target_table,
        "target_field": result.target_field,
        "chains": [_serialize_chain(c) for c in result.chains],
        "total_nodes": result.total_nodes,
        "total_tables": result.total_tables,
        "total_procedures": result.total_procedures,
        "max_depth": result.max_depth,
        "query_time_ms": result.query_time_ms,
    }


# ===========================================================================
# 口径查询辅助函数
# ===========================================================================

def _find_field_mapping(
    src_node: FieldLineageNode,
    tgt_node: FieldLineageNode,
) -> Any:
    """在 tracer 的 field_mappings 中查找匹配的血缘映射。"""
    if _tracer is None:
        return None

    src_table = src_node.table_name.upper()
    src_field = src_node.field_name.upper()
    tgt_table = tgt_node.table_name.upper()
    tgt_field = tgt_node.field_name.upper()

    for fm in _tracer.field_mappings:
        if (
            fm.source_table.upper() == src_table
            and fm.source_column.upper() == src_field
            and fm.target_table.upper() == tgt_table
            and fm.target_column.upper() == tgt_field
        ):
            return fm

    # 模糊匹配：允许 schema 前缀差异
    for fm in _tracer.field_mappings:
        fm_src_tbl = fm.source_table.upper().split(".")[-1] if "." in fm.source_table else fm.source_table.upper()
        fm_tgt_tbl = fm.target_table.upper().split(".")[-1] if "." in fm.target_table else fm.target_table.upper()
        src_tbl_short = src_table.split(".")[-1] if "." in src_table else src_table
        tgt_tbl_short = tgt_table.split(".")[-1] if "." in tgt_table else tgt_table
        if (
            fm_src_tbl == src_tbl_short
            and fm.source_column.upper() == src_field
            and fm_tgt_tbl == tgt_tbl_short
            and fm.target_column.upper() == tgt_field
        ):
            return fm

    return None


def _bare_table(table_name: str) -> str:
    """获取裸表名并处理 O_ICL_*/ICL.*/ICL.V_* 同义词映射。

    委托给 TableNameResolver.bare_table() 的统一实现，保留此函数名以兼容已有调用。
    """
    return TableNameResolver.bare_table(table_name)


def _extract_sql_block_for_mapping(proc: Any, target_table: str) -> str:
    """从 .prc 文件中提取对应目标表的 SQL 操作块。

    匹配策略：
      1. 精确短名匹配（target_table 的短名 == operation 的短名）
      2. 裸表名归一化匹配（_bare_table 归一化后比较，处理 schema 变体）
      3. 首个 INSERT/merge 操作兜底（当目标表不在操作列表中时）
    """
    if not proc or not proc.file_path:
        return ""

    try:
        with open(proc.file_path, "r", encoding="utf-8", errors="ignore") as fh:
            content = fh.read()
    except OSError:
        return ""

    parser = EnhancedProcedureParser(tables=_tracer.tables if _tracer else {})
    try:
        operations = parser._extract_all_sql_operations(content, proc)
    except Exception:
        return ""

    if not operations:
        return ""

    target_short = target_table.split(".")[-1].upper() if "." in target_table else target_table.upper()
    target_bare = _bare_table(target_table)

    # 策略1: 精确短名匹配
    for op in operations:
        op_target_short = (
            op.target_table.split(".")[-1].upper()
            if "." in op.target_table
            else op.target_table.upper()
        )
        if op_target_short == target_short:
            return op.sql_block

    # 策略2: 裸表名归一化匹配（处理 O_ICL_*/ICL.*/ICL.V_* 等变体）
    for op in operations:
        op_bare = _bare_table(op.target_table)
        if op_bare == target_bare and op_bare != op.target_table.split(".")[-1].upper():
            # 只在归一化后才匹配的情况使用（即原始短名不匹配但归一化后匹配）
            return op.sql_block

    # 策略3: 首个 INSERT/MERGE 操作兜底（当目标表不在操作列表中时，
    # 可能是因为 .prc 解析时 target_table 记录为不同 schema 变体）
    if target_bare:
        for op in operations:
            op_upper = (op.sql_block or "").strip().upper()
            if op_upper.startswith("INSERT") or op_upper.startswith("MERGE"):
                return op.sql_block

    return ""


def _chains_to_caliber_result(
    chains: list[Any],
    table: str,
    field: str,
    direction: str = "upstream",
) -> CaliberResult:
    """将 FieldLineageChain 列表转换为 CaliberResult。"""
    caliber_chains: list[CaliberChain] = []

    for chain in chains:
        steps: list[CaliberInfo] = []
        nodes = chain.chain

        # 上游追溯：nodes[0]=源头, nodes[-1]=目标
        # 从目标倒序遍历到源头，构建每步的 CaliberInfo
        for i in range(len(nodes) - 1, 0, -1):
            tgt_node = nodes[i]
            src_node = nodes[i - 1]

            fm = _find_field_mapping(src_node, tgt_node)

            sql_block = ""
            proc = None
            procedure_name = tgt_node.procedure or ""

            # 策略1: 从 tgt_node.procedure 直接获取过程
            if procedure_name and _tracer and _tracer.procedures:
                proc = _tracer.procedures.get(procedure_name)

            # 策略1b: 当 tgt_node.procedure 为空时，回退使用 src_node.procedure
            # BFS 中目标节点（追溯起点）的 procedure 为空，但其上游节点记录了加工过程
            if proc is None and not procedure_name and src_node.procedure and _tracer and _tracer.procedures:
                proc = _tracer.procedures.get(src_node.procedure)
                if proc:
                    procedure_name = src_node.procedure

            # 策略2: 当 procedure 为空或未找到时，通过 tracer 索引查找加工该表的过程
            if proc is None and _tracer:
                tgt_bare = _bare_table(tgt_node.table_name)
                # 从 _proc_target_idx 查找加工了该表的过程
                norm_tgt = _tracer._normalize_table_name(tgt_node.table_name)
                procs_for_table = _tracer._proc_target_idx.get(norm_tgt, [])
                if not procs_for_table:
                    # 尝试裸表名查找
                    procs_for_table = _tracer._proc_target_idx.get(tgt_bare, [])
                # 还尝试 schema.裸名 组合
                if not procs_for_table:
                    for key in _tracer._proc_target_idx:
                        key_bare = _bare_table(key)
                        if key_bare == tgt_bare:
                            procs_for_table = _tracer._proc_target_idx[key]
                            break
                if procs_for_table:
                    # 取第一个有 file_path 的过程
                    for p in procs_for_table:
                        if p.file_path:
                            proc = p
                            procedure_name = procedure_name or p.full_name
                            break

            # 提取 sql_block
            if proc:
                sql_block = _extract_sql_block_for_mapping(proc, tgt_node.table_name)

            if fm:
                caliber_info = CaliberExtractor.build_caliber_info(
                    field_mapping=fm,
                    sql_block=sql_block,
                    procedure=procedure_name,
                    data_source="oracle",
                )
            else:
                # 即使没有精确匹配的 FieldMapping，仍然尝试用 sql_block 提取口径信息
                from core.layer_detector import detect_layer as _detect_layer
                from core.models import FieldMapping as _FM

                # 构造一个最小化的 FieldMapping 传给 build_caliber_info
                # 这样 build_caliber_info 仍能从 sql_block 中提取 WHERE/JOIN/CTE 等
                fallback_fm = _FM(
                    source_table=src_node.table_name,
                    source_column=src_node.field_name,
                    target_table=tgt_node.table_name,
                    target_column=tgt_node.field_name,
                    transform_logic=tgt_node.transform_logic or "",
                    procedure=procedure_name or "",
                    confidence=0.4,
                )
                caliber_info = CaliberExtractor.build_caliber_info(
                    field_mapping=fallback_fm,
                    sql_block=sql_block,
                    procedure=procedure_name,
                    data_source="oracle",
                )

            steps.append(caliber_info)

        # 反转步骤顺序：从源头到目标
        steps = steps[::-1]
        for idx, step in enumerate(steps, 1):
            step.step_num = idx

        caliber_chain = CaliberChain(
            target_table=table,
            target_column=field,
            steps=steps,
            depth=len(steps),
        )
        caliber_chain.compute_metadata()
        caliber_chains.append(caliber_chain)

    # 口径链语义去重：基于公共前缀检测
    # 策略1：如果两条链完全相同签名，保留一条
    # 策略2：如果一条链是另一条链的"前缀子链"（深度更小且前n步完全相同），丢弃子链
    if len(caliber_chains) > 1:
        # 计算每条链的完整签名
        chain_sigs: list[tuple[int, str, CaliberChain]] = []
        for cc in caliber_chains:
            sig_parts = []
            for step in cc.steps:
                tgt_bare = _bare_table(step.target_table)
                sig_parts.append(f"{tgt_bare}.{step.target_column}")
            sig = "→".join(sig_parts)
            chain_sigs.append((cc.depth, sig, cc))

        # 按深度降序排序（优先保留最长链）
        chain_sigs.sort(key=lambda x: x[0], reverse=True)

        kept_sigs: set[str] = set()
        deduped_chains: list[CaliberChain] = []

        for depth, sig, cc in chain_sigs:
            # 检查是否已被保留的链包含（公共前缀检测）
            is_prefix_of_existing = False
            for kept_sig in kept_sigs:
                # 如果当前签是已保留签名的前缀（即前n步相同但深度更小），则丢弃
                if kept_sig.startswith(sig) and kept_sig != sig:
                    is_prefix_of_existing = True
                    logger.debug(
                        "丢弃冗余子链（前缀重复）: depth=%d, sig=%s",
                        depth,
                        sig,
                    )
                    break

            if not is_prefix_of_existing and sig not in kept_sigs:
                kept_sigs.add(sig)
                deduped_chains.append(cc)

        if len(deduped_chains) < len(caliber_chains):
            logger.info(
                "口径链公共前缀去重: %d → %d (按深度优先保留最长链)",
                len(caliber_chains),
                len(deduped_chains),
            )
        caliber_chains = deduped_chains

    total_steps = sum(c.depth for c in caliber_chains)
    total_conditions = sum(c.total_conditions for c in caliber_chains)

    result = CaliberResult(
        target_table=table,
        target_column=field,
        chains=caliber_chains,
        total_steps=total_steps,
        total_conditions=total_conditions,
    )
    result.build_complete_spec()
    return result


def _serialize_caliber_info(ci: CaliberInfo) -> dict[str, Any]:
    return {
        "target_table": ci.target_table,
        "target_column": ci.target_column,
        "source_table": ci.source_table,
        "source_column": ci.source_column,
        "transform_logic": ci.transform_logic,
        "where_conditions": [
            {
                "condition_type": c.condition_type,
                "raw_text": c.raw_text,
                "tables_involved": c.tables_involved,
                "fields_involved": c.fields_involved,
            }
            for c in ci.where_conditions
        ],
        "join_conditions": [
            {
                "condition_type": c.condition_type,
                "raw_text": c.raw_text,
                "tables_involved": c.tables_involved,
                "fields_involved": c.fields_involved,
            }
            for c in ci.join_conditions
        ],
        "group_by_clause": ci.group_by_clause,
        "having_clause": ci.having_clause,
        "procedure": ci.procedure,
        "step_num": ci.step_num,
        "step_desc": ci.step_desc,
        "data_source": ci.data_source,
        "raw_sql_fragment": ci.raw_sql_fragment,
        "confidence": ci.confidence,
        "operation_type": ci.operation_type,
        "select_columns": [
            {
                "source_expression": sc.source_expression,
                "target_column": sc.target_column,
                "alias": sc.alias,
            }
            for sc in ci.select_columns
        ],
        "distinct_flag": ci.distinct_flag,
        "order_by_clause": ci.order_by_clause,
        "set_operation": ci.set_operation,
        "subqueries": [
            {
                "alias": sq.alias,
                "raw_text": sq.raw_text,
                "source_tables": sq.source_tables,
                "where_conditions": [
                    {"condition_type": wc.condition_type, "raw_text": wc.raw_text}
                    for wc in sq.where_conditions
                ],
            }
            for sq in ci.subqueries
        ],
        "source_table_layer": ci.source_table_layer,
        "target_table_layer": ci.target_table_layer,
        "window_functions": ci.window_functions,
        "sql_operation_sequence": ci.sql_operation_sequence,
        "file_path": ci.file_path,
        "start_line": ci.start_line,
        "end_line": ci.end_line,
        "step_isolated_where": [
            {
                "condition_type": c.condition_type,
                "raw_text": c.raw_text,
                "tables_involved": c.tables_involved,
                "fields_involved": c.fields_involved,
            }
            for c in ci.step_isolated_where
        ],
        "step_isolated_join": [
            {
                "condition_type": c.condition_type,
                "raw_text": c.raw_text,
                "tables_involved": c.tables_involved,
                "fields_involved": c.fields_involved,
            }
            for c in ci.step_isolated_join
        ],
        "cte_definitions": ci.cte_definitions,
        "custom_functions": ci.custom_functions,
        "full_expression": ci.full_expression,
        "is_custom_function_call": ci.is_custom_function_call,
    }


def _serialize_caliber_chain(cc: CaliberChain) -> dict[str, Any]:
    return {
        "target_table": cc.target_table,
        "target_column": cc.target_column,
        "steps": [_serialize_caliber_info(s) for s in cc.steps],
        "depth": cc.depth,
        "data_flow_layers": cc.data_flow_layers,
        "procedures_involved": cc.procedures_involved,
        "tables_involved": cc.tables_involved,
        "total_conditions": cc.total_conditions,
        "complete_caliber_spec": cc.complete_caliber_spec,
        "accumulated_conditions_text": cc.accumulated_conditions_text,
    }


def _serialize_caliber_result(cr: CaliberResult) -> dict[str, Any]:
    return {
        "target_table": cr.target_table,
        "target_column": cr.target_column,
        "chains": [_serialize_caliber_chain(c) for c in cr.chains],
        "total_steps": cr.total_steps,
        "total_conditions": cr.total_conditions,
        "query_time_ms": cr.query_time_ms,
        "data_flow_layers_summary": cr.data_flow_layers_summary,
        "complete_caliber_spec": cr.complete_caliber_spec,
    }


def _result_to_graph(result: Any) -> dict[str, Any]:
    """将 FieldLineageResult 转换为前端展示层期望的 nodes/edges/field_mappings 格式。

    前端 display-tab.js 期望:
      nodes: [{ id(完整表名), layer(LayerType字符串), comment, columns }]
      edges: [{ source_table, target_table, source_field, target_field }]
      field_mappings: [{ source_table, source_column, target_table, target_column, transform_logic, procedure }]
      query_target: { table, field }
      query_time_ms, nodes_count, edges_count, field_mapping_count
    """

    def _bare(table_name: str) -> str:
        """获取裸表名（去掉 schema 前缀），用于去重。

        委托给 TableNameResolver.bare_table() 的统一实现。
        """
        return TableNameResolver.bare_table(table_name)

    # 1. 收集去重节点（按裸表名去重，避免 schema 前缀差异导致重复节点）
    node_map: dict[str, dict[str, Any]] = {}  # bare_name -> node dict

    def _ensure_node(table_name: str, layer_type: str) -> dict[str, Any]:
        key = _bare(table_name)
        if key not in node_map:
            comment = ""
            columns: list[str] = []
            tbl_info = _tables.get(table_name.upper())
            if tbl_info is None:
                # 尝试短名匹配
                for t in _tables.values():
                    short = t.table_name.upper()
                    if short == key or (t.full_name and t.full_name.upper() == table_name.upper()):
                        tbl_info = t
                        break
            if tbl_info is not None:
                comment = tbl_info.comment or ""
                columns = tbl_info.column_names or []

            node_map[key] = {
                "id": table_name,
                "layer": layer_type or "other",
                "comment": comment,
                "columns": columns,
            }
        else:
            # 优先使用非 other 的 layer_type
            if layer_type and layer_type != "other" and node_map[key]["layer"] == "other":
                node_map[key]["layer"] = layer_type
            # 优先保留带 schema 前缀的完整表名作为显示 id
            if "." in table_name and "." not in node_map[key]["id"]:
                node_map[key]["id"] = table_name
            # Bug C fix: 优先保留非ICL变体（如 RRP_MDL.O_ICL_*）替代纯 ICL.* 节点
            existing_id = node_map[key]["id"]
            if existing_id.upper().startswith("ICL.") and not table_name.upper().startswith("ICL."):
                node_map[key]["id"] = table_name
        return node_map[key]

    # 2. 构建 edges 和 field_mappings
    edges: list[dict[str, str]] = []
    field_mappings: list[dict[str, str]] = []
    edge_keys: set[str] = set()
    fm_keys: set[str] = set()
    fm_dedup_keys: set[str] = set()  # (逻辑源表|逻辑目标表.目标字段) 三元组去重

    for chain in result.chains:
        chain_nodes = chain.chain if hasattr(chain, "chain") else []
        for i in range(len(chain_nodes) - 1):
            src_node = chain_nodes[i]
            tgt_node = chain_nodes[i + 1]

            src_table = src_node.table_name if hasattr(src_node, "table_name") else str(src_node)
            tgt_table = tgt_node.table_name if hasattr(tgt_node, "table_name") else str(tgt_node)
            src_field = src_node.field_name if hasattr(src_node, "field_name") else ""
            tgt_field = tgt_node.field_name if hasattr(tgt_node, "field_name") else ""
            src_layer = src_node.layer_type if hasattr(src_node, "layer_type") else ""
            tgt_layer = tgt_node.layer_type if hasattr(tgt_node, "layer_type") else ""
            procedure = tgt_node.procedure if hasattr(tgt_node, "procedure") else ""
            transform = tgt_node.transform_logic if hasattr(tgt_node, "transform_logic") else ""

            # 确保两个节点都在 map 中
            _ensure_node(src_table, src_layer)
            _ensure_node(tgt_table, tgt_layer)

            # 跳过 schema 变体自环边：源和目标映射到同一个逻辑节点，且原始表名不同
            # 例如 ICL.V_CMM_XXX → RRP_MDL.O_ICL_CMM_XXX（_bare 相同，但原始表名不同，是搬运不是转换）
            # 但同表内不同字段的映射（如 CUST_NM → CUST_NM_DESEN）应保留
            src_bare = _bare(src_table)
            tgt_bare = _bare(tgt_table)
            if src_bare == tgt_bare and src_table != tgt_table:
                continue

            # 使用合并后的逻辑表名作为 edge 和 field_mapping 的显示名
            # 优先使用 node_map 中已合并的 id（如 RRP_MDL.O_ICL_* 而非 ICL.V_*）
            display_src = node_map[src_bare]["id"] if src_bare in node_map else src_table
            display_tgt = node_map[tgt_bare]["id"] if tgt_bare in node_map else tgt_table

            # 去重 edge（按逻辑裸表名，避免 schema 前缀差异导致重复边）
            edge_key = f"{src_bare}|{tgt_bare}"
            if edge_key not in edge_keys:
                edge_keys.add(edge_key)
                edges.append({
                    "source_table": display_src,
                    "target_table": display_tgt,
                    "source_field": src_field,
                    "target_field": tgt_field,
                })

            # 去重 field_mapping（按逻辑裸表名+字段名，避免 schema 前缀差异导致重复映射）
            # 同时对同一 (逻辑源表, 逻辑目标表, 目标字段) 三元组去重，
            # 避免同一目标字段出现多个语义等价的源字段（如 CUST_NAME vs CUST_NM）
            fm_key = f"{src_bare}.{src_field.upper()}|{tgt_bare}.{tgt_field.upper()}"
            fm_dedup_key = f"{src_bare}|{tgt_bare}.{tgt_field.upper()}"
            if fm_key not in fm_keys and src_field and tgt_field and fm_dedup_key not in fm_dedup_keys:
                fm_keys.add(fm_key)
                fm_dedup_keys.add(fm_dedup_key)
                fm_entry: dict[str, str] = {
                    "source_table": display_src,
                    "source_column": src_field,
                    "target_table": display_tgt,
                    "target_column": tgt_field,
                }
                if transform:
                    fm_entry["transform_logic"] = transform
                if procedure:
                    fm_entry["procedure"] = procedure
                field_mappings.append(fm_entry)

    nodes = list(node_map.values())

    return {
        "nodes": nodes,
        "edges": edges,
        "nodes_count": len(nodes),
        "edges_count": len(edges),
        "field_mappings": field_mappings,
        "field_mapping_count": len(field_mappings),
        "query_target": {
            "table": result.target_table,
            "field": result.target_field,
        },
        "query_time_ms": result.query_time_ms,
    }


# ===========================================================================
# HTTP 请求处理器
# ===========================================================================
class LineageAPIHandler(BaseHTTPRequestHandler):
    """HTTP 请求处理器，路由分发 + JSON 响应。"""

    # 抑制默认的 log_message 输出到 stderr，改用自定义日志
    def log_message(self, format_str: str, *args: Any) -> None:
        logger.info("%s %s", args[0] if args else "", self.path)

    # ------------------------------------------------------------------
    # 路由匹配表：(方法+路径模式, 处理器方法名, 是否含路径参数)
    # ------------------------------------------------------------------
    ROUTES: list[tuple[str, str, bool]] = [
        ("GET", r"^/health$", False),
        ("GET", r"^/api/tables$", False),
        ("GET", r"^/api/tables/(.+)/fields$", True),
        ("POST", r"^/api/lineage/query$", False),
        ("GET", r"^/api/lineage/(.+)/(.+)$", True),
        ("GET", r"^/api/caliber/fields$", False),
        ("GET", r"^/api/caliber/trace$", False),
        ("GET", r"^/api/indicator/search$", False),
        ("GET", r"^/api/indicator/detail$", False),
        ("GET", r"^/api/indicator/lineage$", False),
        ("GET", r"^/api/indicator/pipeline$", False),
        ("GET", r"^/api/indicator/stats$", False),
        ("GET", r"^/api/indicator/source-tables$", False),
        ("GET", r"^/api/stats$", False),
        ("GET", r"^/$", False),
        ("GET", r"^/static/(.+)$", True),
    ]

    def do_GET(self) -> None:
        self._dispatch("GET")

    def do_POST(self) -> None:
        self._dispatch("POST")

    def do_OPTIONS(self) -> None:
        self._set_cors_headers()
        self.send_response(204)
        self.end_headers()

    # ==================================================================
    # 路由分发核心
    # ==================================================================

    def _dispatch(self, method: str) -> None:
        t0 = time.perf_counter()

        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path.rstrip("/") or "/"

        try:
            handler_found = False
            for route_method, pattern_str, has_params in self.ROUTES:
                if method != route_method:
                    continue
                match = re.match(pattern_str, path)
                if not match:
                    continue

                handler_found = True
                groups = match.groups() if has_params else ()
                self._call_handler(method, path, groups)
                break

            if not handler_found:
                self._send_error(f"未找到路由: {method} {path}", status=404)

        except Exception as exc:
            logger.error("处理请求异常: %s %s — %s", method, path, exc, exc_info=True)
            self._send_error(f"服务器内部错误: {str(exc)}", status=500)

        finally:
            elapsed_ms = (time.perf_counter() - t0) * 1000
            logger.info("%s %s → %.1fms", method, path, elapsed_ms)

    def _call_handler(self, method: str, path: str, groups: tuple) -> None:
        """根据路由匹配结果调用对应处理器。"""
        if path == "/":
            self._handle_index()
        elif path == "/health":
            self._handle_health()
        elif path == "/api/stats":
            self._handle_stats()
        elif re.match(r"^/api/tables$", path):
            query = urllib.parse.parse_qs(urllib.parse.urlparse(self.path).query)
            keyword = query.get("keyword", [""])[0]
            self._handle_list_tables(keyword)
        elif re.match(r"^/api/tables/(.+)/fields$", path):
            self._handle_table_fields(groups[0])
        elif path == "/api/lineage/query" and method == "POST":
            self._handle_lineage_query()
        elif re.match(r"^/api/lineage/(.+)/(.+)$", path):
            self._handle_lineage_get(groups[0], groups[1])
        elif re.match(r"^/api/caliber/fields$", path):
            query = urllib.parse.parse_qs(urllib.parse.urlparse(self.path).query)
            table = query.get("table", [""])[0]
            self._handle_caliber_fields(table)
        elif re.match(r"^/api/caliber/trace$", path):
            query = urllib.parse.parse_qs(urllib.parse.urlparse(self.path).query)
            table = query.get("table", [""])[0]
            field = query.get("field", [""])[0]
            direction = query.get("direction", ["upstream"])[0]
            depth_str = query.get("depth", ["10"])[0]
            try:
                depth = int(depth_str)
            except ValueError:
                depth = 10
            self._handle_caliber_trace(table, field, direction, depth)
        elif re.match(r"^/api/indicator/search$", path):
            query = urllib.parse.parse_qs(urllib.parse.urlparse(self.path).query)
            keyword = query.get("keyword", [""])[0]
            limit_str = query.get("limit", ["50"])[0]
            try:
                limit = int(limit_str)
            except ValueError:
                limit = 50
            self._handle_indicator_search(keyword, limit)
        elif re.match(r"^/api/indicator/detail$", path):
            query = urllib.parse.parse_qs(urllib.parse.urlparse(self.path).query)
            index_no = query.get("index_no", [""])[0]
            self._handle_indicator_detail(index_no)
        elif re.match(r"^/api/indicator/lineage$", path):
            query = urllib.parse.parse_qs(urllib.parse.urlparse(self.path).query)
            index_no = query.get("index_no", [""])[0]
            measure = query.get("measure", [""])[0]
            direction = query.get("direction", ["upstream"])[0]
            depth_str = query.get("depth", ["10"])[0]
            try:
                depth = int(depth_str)
            except ValueError:
                depth = 10
            self._handle_indicator_lineage(index_no, measure, direction, depth)
        elif re.match(r"^/api/indicator/pipeline$", path):
            query = urllib.parse.parse_qs(urllib.parse.urlparse(self.path).query)
            index_no = query.get("index_no", [""])[0]
            measure = query.get("measure", [""])[0]
            self._handle_indicator_pipeline(index_no, measure)
        elif re.match(r"^/api/indicator/stats$", path):
            self._handle_indicator_stats()
        elif re.match(r"^/api/indicator/source-tables$", path):
            query = urllib.parse.parse_qs(urllib.parse.urlparse(self.path).query)
            index_no = query.get("index_no", [""])[0]
            self._handle_indicator_source_tables(index_no)
        elif re.match(r"^/static/(.+)$", path):
            self._serve_static_file(groups[0])

    # ==================================================================
    # 各路由处理器
    # ==================================================================

    def _handle_health(self) -> None:
        uptime = time.time() - _start_time if _start_time > 0 else 0
        self._send_json({
            "success": True,
            "data": {
                "status": "ok",
                "uptime_seconds": round(uptime),
                "total_tables": len(_tables),
                "total_procedures": _procedures_count,
            },
        })

    def _handle_index(self) -> None:
        index_path = os.path.join(_static_dir, "index.html")
        if os.path.isfile(index_path):
            self._serve_static_file("index.html")
        else:
            body = json.dumps(
                {
                    "success": True,
                    "data": {
                        "service": "Data Lineage Analysis API",
                        "version": "1.0.0",
                        "endpoints": [
                            "GET  /api/tables?keyword=xxx",
                            "GET  /api/tables/{table_name}/fields",
                            "POST /api/lineage/query",
                            "GET  /api/lineage/{table}/{field}",
                            "GET  /api/stats",
                        ],
                    },
                },
                ensure_ascii=False,
            )
            self._send_raw(body, content_type="application/json; charset=utf-8")

    def _handle_stats(self) -> None:
        data: dict[str, Any] = {
            "total_tables": len(_tables),
            "total_procedures": _procedures_count,
            "total_table_lineages": _table_lineages_count,
            "total_field_mappings": _field_mappings_count,
        }
        if _tracer is not None:
            data["tracer_tables"] = len(_tracer.tables)
            data["tracer_procedures"] = len(_tracer.procedures)
        self._send_json({"success": True, "data": data})

    def _handle_list_tables(self, keyword: str) -> None:
        keyword_upper = keyword.strip().upper()
        results: list[dict[str, Any]] = []
        seen_full: set = set()  # 用 full_name 去重，允许不同 schema 同名表共存

        # 1. 从 .tab 解析的表（如果有）
        for tbl_info in _tables.values():
            name = tbl_info.table_name or ""
            full_name = tbl_info.full_name or name
            if keyword_upper and keyword_upper not in full_name.upper():
                continue
            if full_name.upper() in seen_full:
                continue
            schema_name = tbl_info.schema or (full_name.split(".")[0] if "." in full_name else "")
            layer_val = detect_layer(tbl_info.full_name).value if tbl_info.full_name else "other"
            results.append({
                "full_name": full_name,
                "short_name": name,
                "schema": schema_name,
                "field_count": len(tbl_info.columns),
                "layer": layer_val,
            })
            seen_full.add(full_name.upper())

        # 2. 从存储过程提取的表（补充 .tab 未覆盖的）
        for proc_tbl_upper in _proc_table_names:
            if proc_tbl_upper in seen_full:
                continue
            short_name = proc_tbl_upper.split(".")[-1] if "." in proc_tbl_upper else proc_tbl_upper
            if keyword_upper and keyword_upper not in proc_tbl_upper:
                continue
            schema_name = proc_tbl_upper.split(".")[0] if "." in proc_tbl_upper else ""
            fields = _proc_table_names.get(proc_tbl_upper, set())
            layer_val = detect_layer(proc_tbl_upper).value
            results.append({
                "full_name": proc_tbl_upper,
                "short_name": short_name,
                "schema": schema_name,
                "field_count": len(fields),
                "layer": layer_val,
            })
            seen_full.add(proc_tbl_upper)

        # 排序：优先匹配 schema/短名前缀，再按 short_name 排序
        # 例：搜 EAST5_201 → RRP_EAST.EAST5_201_GRJCXXB 排在 RRP_MDL.EAST5_201_GRJCXXB 前面
        def _sort_key(item: dict) -> tuple:
            sn = item["short_name"].upper()
            fn = item["full_name"].upper()
            schema = (item.get("schema") or "").upper()
            # 精确匹配 short_name 的排在最前
            exact_short = 0 if sn == keyword_upper else 1
            # schema 前缀与 keyword 有重叠的优先（如 RRP_EAST 匹配 EAST5_）
            schema_match = 0 if keyword_upper in schema else 1
            # short_name 开头匹配的优先
            prefix_match = 0 if sn.startswith(keyword_upper) else 1
            return (exact_short, schema_match, prefix_match, sn, fn)

        results.sort(key=_sort_key)
        self._send_json({"success": True, "data": results})

    def _handle_table_fields(self, table_name: str) -> None:
        norm_name = table_name.strip().upper()

        # 1. 先从 .tab 表中找
        matched_tbl: Optional[TableInfo] = None
        for tbl_info in _tables.values():
            if tbl_info.table_name.upper() == norm_name or (
                tbl_info.full_name and tbl_info.full_name.upper() == norm_name
            ):
                matched_tbl = tbl_info
                break

        if matched_tbl is not None:
            field_names = matched_tbl.column_names
            self._send_json({"success": True, "data": field_names})
            return

        # 2. 从过程表的字段映射中找
        for proc_tbl_upper, fields in _proc_table_names.items():
            short = proc_tbl_upper.split(".")[-1] if "." in proc_tbl_upper else proc_tbl_upper
            if short == norm_name or proc_tbl_upper == norm_name:
                self._send_json({"success": True, "data": sorted(fields)})
                return

        # 3. 模糊匹配
        for proc_tbl_upper, fields in _proc_table_names.items():
            if norm_name in proc_tbl_upper or proc_tbl_upper.endswith(norm_name):
                self._send_json({"success": True, "data": sorted(fields)})
                return

        self._send_error(f"未找到表: {table_name}", status=404)

    def _handle_lineage_query(self) -> None:
        if _tracer is None:
            self._send_error("引擎尚未初始化", status=503)
            return

        try:
            body = self._read_body()
        except (json.JSONDecodeError, ValueError) as exc:
            self._send_error(f"请求体 JSON 解析失败: {exc}", status=400)
            return

        table = (body.get("table") or "").strip()
        field = (body.get("field") or "").strip()
        # 兼容前端发送的 depth 和 max_depth
        max_depth = body.get("max_depth") or body.get("depth", 10)
        mode = (body.get("mode") or "upstream").strip().lower()

        if not table:
            self._send_error("缺少必要参数: table", status=400)
            return
        if not field:
            self._send_error("缺少必要参数: field", status=400)
            return
        if not isinstance(max_depth, int) or max_depth < 1 or max_depth > 20:
            max_depth = 10

        if mode == "downstream":
            import time as _time
            from types import SimpleNamespace as _SN
            t0 = _time.perf_counter()
            chains = _tracer.trace_field_downstream(table, field, max_depth=max_depth)
            elapsed = round((_time.perf_counter() - t0) * 1000, 2)
            result = _SN(
                target_table=table.upper(),
                target_field=field.upper(),
                chains=chains,
                total_nodes=sum(c.node_count for c in chains),
                total_tables=len({n.table_name for c in chains for n in c.chain}),
                total_procedures=len({n.procedure for c in chains for n in c.chain if n.procedure}),
                max_depth=max((c.depth for c in chains), default=0),
                query_time_ms=elapsed,
            )
            graph_data = _result_to_graph(result)
            self._send_json({"success": True, "data": graph_data})
            return

        try:
            result = _tracer.trace_field(table, field)
            graph_data = _result_to_graph(result)
            self._send_json({"success": True, "data": graph_data})
        except Exception as exc:
            logger.error("血缘查询异常: %s.%s — %s", table, field, exc, exc_info=True)
            self._send_error(f"血缘查询失败: {exc}", status=500)

    def _handle_lineage_get(self, table: str, field: str) -> None:
        if _tracer is None:
            self._send_error("引擎尚未初始化", status=503)
            return

        table_clean = urllib.parse.unquote(table).strip()
        field_clean = urllib.parse.unquote(field).strip()

        if not table_clean or not field_clean:
            self._send_error("参数不完整: 需要提供 table 和 field", status=400)
            return

        try:
            result = _tracer.trace_field(table_clean, field_clean)
            graph_data = _result_to_graph(result)
            self._send_json({"success": True, "data": graph_data})
        except Exception as exc:
            logger.error("血缘查询异常(GET): %s.%s — %s", table_clean, field_clean, exc, exc_info=True)
            self._send_error(f"血缘查询失败: {exc}", status=500)

    def _handle_caliber_fields(self, table: str) -> None:
        """返回某表中所有有口径数据的字段列表。"""
        if not table:
            self._send_error("缺少必要参数: table", status=400)
            return

        norm_table = table.strip().upper()
        short_name = norm_table.split(".")[-1] if "." in norm_table else norm_table

        field_set: set[str] = set()
        caliber_fields: list[dict[str, str]] = []

        # 从 tracer 的 field_mappings 中收集涉及该表的字段
        if _tracer is not None:
            for fm in _tracer.field_mappings:
                fm_tgt_tbl = fm.target_table.upper()
                fm_tgt_short = fm_tgt_tbl.split(".")[-1] if "." in fm_tgt_tbl else fm_tgt_tbl
                fm_src_tbl = fm.source_table.upper()
                fm_src_short = fm_src_tbl.split(".")[-1] if "." in fm_src_tbl else fm_src_tbl

                if fm_tgt_short == short_name or fm_tgt_tbl == norm_table:
                    field_set.add(fm.target_column.upper())
                if fm_src_short == short_name or fm_src_tbl == norm_table:
                    field_set.add(fm.source_column.upper())

        for f in sorted(field_set):
            caliber_fields.append({"field": f, "has_caliber": True})

        self._send_json({"success": True, "data": {"fields": caliber_fields}})

    def _handle_caliber_trace(
        self, table: str, field: str, direction: str, depth: int
    ) -> None:
        """执行口径追溯查询，返回 CaliberResult。"""
        if _tracer is None:
            self._send_error("引擎尚未初始化", status=503)
            return

        if not table or not field:
            self._send_error("缺少必要参数: table 和 field", status=400)
            return

        import time as _time

        t0 = _time.perf_counter()

        try:
            if direction == "downstream":
                chains = _tracer.trace_field_downstream(table, field, max_depth=depth)
            else:
                chains = _tracer.trace_field(table, field).chains

            caliber_result = _chains_to_caliber_result(
                chains, table, field, direction=direction
            )
            caliber_result.query_time_ms = round((_time.perf_counter() - t0) * 1000, 2)

            data = _serialize_caliber_result(caliber_result)
            self._send_json({"success": True, "data": data})
        except Exception as exc:
            logger.error("口径查询异常: %s.%s — %s", table, field, exc, exc_info=True)
            self._send_error(f"口径查询失败: {exc}", status=500)

    # ==================================================================
    # 指标血缘路由处理器
    # ==================================================================

    def _handle_indicator_search(self, keyword: str, limit: int) -> None:
        """搜索指标"""
        if not _indicator_graph_builder:
            self._send_json({"success": False, "message": "指标服务未初始化", "data": []})
            return
        if not keyword:
            self._send_error("缺少必要参数: keyword", status=400)
            return
        try:
            results = _indicator_graph_builder.search_indicators(keyword, limit)
            self._send_json({"success": True, "message": "搜索成功", "data": results})
        except Exception as exc:
            logger.error("指标搜索异常: %s", exc, exc_info=True)
            self._send_error(f"指标搜索失败: {exc}", status=500)

    def _handle_indicator_detail(self, index_no: str) -> None:
        """获取指标详情"""
        if not _indicator_graph_builder:
            self._send_json({"success": False, "message": "指标服务未初始化", "data": {}})
            return
        if not index_no:
            self._send_error("缺少必要参数: index_no", status=400)
            return
        try:
            detail = _indicator_graph_builder.get_indicator_detail(index_no)
            if not detail:
                self._send_json({"success": False, "message": f"未找到指标: {index_no}", "data": {}})
                return
            self._send_json({"success": True, "message": "查询成功", "data": detail})
        except Exception as exc:
            logger.error("指标详情查询异常: %s", exc, exc_info=True)
            self._send_error(f"指标详情查询失败: {exc}", status=500)

    def _handle_indicator_lineage(
        self, index_no: str, measure: str, direction: str, depth: int
    ) -> None:
        """查询指标血缘图"""
        if not _indicator_graph_builder:
            self._send_json({
                "success": False, "message": "指标服务未初始化",
                "data": {"target_index_no": index_no, "graph": {"nodes": [], "edges": []}, "chains": []},
            })
            return
        if not index_no:
            self._send_error("缺少必要参数: index_no", status=400)
            return
        try:
            result = _indicator_graph_builder.trace_indicator(
                index_no=index_no, measure=measure, direction=direction, max_depth=depth,
            )
            # 序列化图
            graph_data = {
                "nodes": [
                    {"id": n.node_id, "type": n.node_type, "label": n.display_label,
                     "index_no": n.index_no, "index_measure": n.index_measure,
                     "index_type": n.index_type, "algo_type": n.algo_type,
                     "layer": n.layer, "brch_type": n.brch_type, "detail": n.detail}
                    for n in result.graph.nodes
                ],
                "edges": [
                    {"id": e.edge_id, "source": e.source_id, "target": e.target_id,
                     "type": e.edge_type, "procedure": e.procedure,
                     "transform_logic": e.transform_logic, "algo_type": e.algo_type,
                     "condition_sql": e.condition_sql, "measure_sql": e.measure_sql}
                    for e in result.graph.edges
                ],
                "stats": result.graph.stats,
                "node_count": result.graph.node_count,
                "edge_count": result.graph.edge_count,
            }
            # 序列化链路
            chains_data = [
                {"target_index_no": c.target_index_no, "target_measure": c.target_measure,
                 "depth": c.depth, "step_count": c.step_count,
                 "procedures_involved": c.procedures_involved,
                 "tables_involved": c.tables_involved, "has_gl_step": c.has_gl_step,
                 "steps": [
                     {"step_num": s.step_num, "index_no": s.index_no,
                      "index_measure": s.index_measure, "measure_label": s.measure_label,
                      "index_type": s.index_type, "algo_type": s.algo_type,
                      "algo_label": s.algo_label, "procedure": s.procedure,
                      "source_tables": s.source_tables, "target_table": s.target_table,
                      "transform_logic": s.transform_logic, "condition_sql": s.condition_sql,
                      "measure_sql": s.measure_sql, "brch_type": s.brch_type,
                      "gl_subj_no": s.gl_subj_no, "gl_amt_val": s.gl_amt_val,
                      "gl_sign_no": s.gl_sign_no, "is_gl_step": s.is_gl_step}
                     for s in c.steps
                 ]}
                for c in result.chains
            ]
            self._send_json({
                "success": True, "message": "查询成功",
                "data": {
                    "target_index_no": result.target_index_no,
                    "target_measure": result.target_measure,
                    "measure_label": result.measure_label,
                    "chain_count": result.chain_count,
                    "max_depth": result.max_depth,
                    "query_time_ms": result.query_time_ms,
                    "graph": graph_data,
                    "chains": chains_data,
                },
            })
        except Exception as exc:
            logger.error("指标血缘查询异常: %s — %s", index_no, exc, exc_info=True)
            self._send_error(f"指标血缘查询失败: {exc}", status=500)

    def _handle_indicator_pipeline(self, index_no: str, measure: str) -> None:
        """获取指标加工流水线"""
        if not _indicator_graph_builder:
            self._send_json({"success": False, "message": "指标服务未初始化",
                            "data": {"index_no": index_no, "steps": [], "total_steps": 0}})
            return
        if not index_no:
            self._send_error("缺少必要参数: index_no", status=400)
            return
        try:
            steps = _indicator_graph_builder.get_pipeline_steps(index_no, measure)
            self._send_json({
                "success": True, "message": "查询成功",
                "data": {"index_no": index_no, "measure": measure,
                         "steps": steps, "total_steps": len(steps)},
            })
        except Exception as exc:
            logger.error("指标流水线查询异常: %s", exc, exc_info=True)
            self._send_error(f"指标流水线查询失败: {exc}", status=500)

    def _handle_indicator_stats(self) -> None:
        """获取指标体系统计"""
        if not _indicator_graph_builder:
            self._send_json({"success": False, "message": "指标服务未初始化", "data": {}})
            return
        try:
            stats = _indicator_graph_builder.get_stats()
            self._send_json({"success": True, "message": "查询成功", "data": stats})
        except Exception as exc:
            logger.error("指标统计查询异常: %s", exc, exc_info=True)
            self._send_error(f"指标统计查询失败: {exc}", status=500)

    def _handle_indicator_source_tables(self, index_no: str) -> None:
        """获取指标源表列表"""
        if not _indicator_graph_builder:
            self._send_json({"success": False, "message": "指标服务未初始化",
                            "data": {"index_no": index_no, "tables": [], "count": 0}})
            return
        if not index_no:
            self._send_error("缺少必要参数: index_no", status=400)
            return
        try:
            detail = _indicator_graph_builder.get_indicator_detail(index_no)
            tables: list[str] = []
            for m in detail.get("measures", []):
                src = m.get("src_table", "")
                if src:
                    for t in src.split(","):
                        t = t.strip().upper()
                        if t and t not in tables:
                            tables.append(t)
            self._send_json({
                "success": True, "message": "查询成功",
                "data": {"index_no": index_no, "tables": tables, "count": len(tables)},
            })
        except Exception as exc:
            logger.error("获取指标源表异常: %s", exc, exc_info=True)
            self._send_error(f"获取指标源表失败: {exc}", status=500)

    # ==================================================================
    # 工具方法
    # ==================================================================

    def _set_cors_headers(self) -> None:
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header(
            "Access-Control-Allow-Headers",
            "Content-Type, Authorization, X-Requested-With",
        )

    def _send_json(self, data: Any, status: int = 200) -> None:
        body = json.dumps(data, ensure_ascii=False)
        self._send_raw(body, status=status, content_type="application/json; charset=utf-8")

    def _send_raw(
        self,
        body: str,
        status: int = 200,
        content_type: str = "application/json; charset=utf-8",
    ) -> None:
        encoded = body.encode("utf-8")
        self.send_response(status)
        self._set_cors_headers()
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(encoded)))
        self.end_headers()
        self.wfile.write(encoded)

    def _send_error(self, message: str, status: int = 400) -> None:
        self._send_json({"success": False, "error": message}, status=status)

    def _read_body(self) -> dict:
        content_length = int(self.headers.get("Content-Length", 0))
        if content_length <= 0:
            return {}
        raw = self.rfile.read(content_length)
        text = raw.decode("utf-8", errors="replace")
        return json.loads(text)

    def _serve_static_file(self, relative_path: str) -> None:
        safe_path = relative_path.lstrip("/")
        safe_path = safe_path.replace("..", "").replace("//", "/")
        file_path = os.path.normpath(os.path.join(_static_dir, safe_path))

        if not file_path.startswith(os.path.abspath(_static_dir)):
            self._send_error("非法路径访问", status=403)
            return

        if not os.path.isfile(file_path):
            self._send_error(f"文件不存在: {relative_path}", status=404)
            return

        mime_type, _ = mimetypes.guess_type(file_path)
        if mime_type is None:
            mime_type = "application/octet-stream"

        try:
            with open(file_path, "rb") as fh:
                content = fh.read()
            self.send_response(200)
            self._set_cors_headers()
            self.send_header("Content-Type", f"{mime_type}; charset=utf-8")
            self.send_header("Content-Length", str(len(content)))
            self.end_headers()
            self.wfile.write(content)
        except OSError as exc:
            logger.error("读取静态文件失败: %s — %s", file_path, exc)
            self._send_error(f"读取文件失败: {exc}", status=500)


# ===========================================================================
# 入口
# ===========================================================================
def main() -> None:
    global _static_dir, _start_time

    _start_time = time.time()

    parser = argparse.ArgumentParser(description="数据血缘分析 HTTP API 服务")
    parser.add_argument("--port", type=int, default=8899, help="监听端口 (默认: 8899)")
    parser.add_argument("--dir", default=None, help=".prc 文件根目录 (默认: RRP_ORACLE)")
    args = parser.parse_args()

    _static_dir = str(get_static_dir())

    if args.dir:
        prc_dir = args.dir
    else:
        prc_dir = str(get_data_dir())

    if not os.path.isdir(prc_dir):
        logger.error(".prc 目录不存在: %s", prc_dir)
        return

    print(f"\n正在解析存储过程目录: {prc_dir}")
    _init_engine(prc_dir)

    server = HTTPServer(("0.0.0.0", args.port), LineageAPIHandler)
    url = f"http://localhost:{args.port}"
    print(f"\n{'='*50}")
    print(f"  数据血缘分析 API 服务已启动")
    print(f"  地址: {url}")
    print(f"  接口:")
    print(f"    GET  {url}/api/tables?keyword=KHXXB")
    print(f"    POST {url}/api/lineage/query")
    print(f"    GET  {url}/api/stats")
    print(f"{'='*50}\n")

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n服务已停止")
        server.server_close()


if __name__ == "__main__":
    main()
