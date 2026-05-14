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

from core.lineage_tracer import LineageTracer
from core.models import (
    FieldLineageNode,
    TableInfo,
    detect_layer,
)
from core.procedure_parser import EnhancedProcedureParser
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

        特殊处理：
        - RRP_MDL.O_ICL_* → 去掉 O_ 前缀（O_ICL_CMM_XXX → ICL_CMM_XXX）
        - ICL.V_* → 去掉 V_ 视图前缀后加 ICL_ 前缀（ICL.V_CMM_XXX → ICL_CMM_XXX）
        - ICL.<table> → 加 ICL_ 前缀（ICL.CMM_XXX → ICL_CMM_XXX）
        这样 O_ICL_CMM_XXX / ICL.V_CMM_XXX / ICL.CMM_XXX 都映射到 ICL_CMM_XXX，实现同义去重。
        """
        parts = table_name.split(".")
        schema = parts[0].upper() if len(parts) > 1 else ""
        bare = parts[-1].upper()

        # RRP_MDL.O_ICL_* -> ICL_*
        if bare.startswith("O_ICL_"):
            bare = bare[2:]  # O_ICL_ -> ICL_
            return bare

        # ICL.V_* -> ICL_* (视图前缀去掉 V_)
        if schema == "ICL" and bare.startswith("V_"):
            bare = bare[2:]  # V_CMM_XXX -> CMM_XXX
            return f"ICL_{bare}"

        # ICL.XXX -> ICL_XXX（与 O_ICL_* 统一前缀）
        if schema == "ICL" and not bare.startswith("ICL_"):
            bare = f"ICL_{bare}"

        return bare

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
        seen: set = set()

        # 1. 从 .tab 解析的表（如果有）
        for tbl_info in _tables.values():
            name = tbl_info.table_name or ""
            full_name = tbl_info.full_name or name
            if keyword_upper and keyword_upper not in name.upper():
                continue
            layer_val = detect_layer(tbl_info.full_name).value if tbl_info.full_name else "other"
            results.append({
                "full_name": full_name,
                "short_name": name,
                "field_count": len(tbl_info.columns),
                "layer": layer_val,
            })
            seen.add(name.upper())

        # 2. 从存储过程提取的表（补充 .tab 未覆盖的）
        for proc_tbl_upper in _proc_table_names:
            short_name = proc_tbl_upper.split(".")[-1] if "." in proc_tbl_upper else proc_tbl_upper
            if short_name in seen:
                continue
            if keyword_upper and keyword_upper not in proc_tbl_upper:
                continue
            fields = _proc_table_names.get(proc_tbl_upper, set())
            layer_val = detect_layer(proc_tbl_upper).value
            results.append({
                "full_name": proc_tbl_upper,
                "short_name": short_name,
                "field_count": len(fields),
                "layer": layer_val,
            })
            seen.add(short_name)

        results.sort(key=lambda x: x["short_name"])
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
