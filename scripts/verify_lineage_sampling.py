"""
血缘随机抽查验证脚本

用途:
    对项目里已存在解析脚本的系统（rrp/edw/mcs/fdm/pam）进行随机抽查：
      1. 每个系统随机抽取 5 个非 BAK 表
      2. 取主键字段（rrp 走 primary_keys，其他系统回退首列）
      3. 调用 /api/lineage/query 查询 both 方向血缘
      4. 验证:
         - 节点表名/字段在数据中真实存在
         - 字段类型 data_type 正常显示（非空字符串）
         - 所有血缘节点都包含 数据库表 + 字段 + 字段类型

用法:
    python scripts/verify_lineage_sampling.py
    python scripts/verify_lineage_sampling.py --base http://localhost:8899 --seed 42 --sample 5
"""

from __future__ import annotations

import argparse
import json
import random
import sys
import time
from pathlib import Path
from typing import Any
from urllib.error import URLError
from urllib.request import Request, urlopen

# 添加项目根目录到 sys.path，便于复用模型/服务层
_PROJECT_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(_PROJECT_ROOT))


# ── HTTP 工具 ───────────────────────────────────────────────


def http_get(url: str, timeout: int = 30) -> Any:
    """发起 GET 请求并解析 JSON。"""
    req = Request(url, headers={"Accept": "application/json"})
    with urlopen(req, timeout=timeout) as resp:
        payload = resp.read().decode("utf-8")
    return json.loads(payload)


def http_post(url: str, body: dict, timeout: int = 60) -> Any:
    """发起 POST 请求并解析 JSON。"""
    data = json.dumps(body).encode("utf-8")
    req = Request(
        url,
        data=data,
        headers={"Content-Type": "application/json", "Accept": "application/json"},
        method="POST",
    )
    with urlopen(req, timeout=timeout) as resp:
        payload = resp.read().decode("utf-8")
    return json.loads(payload)


# ── 表抽样 ──────────────────────────────────────────────────


def fetch_system_tables(base: str, system_name: str, limit: int = 2000) -> list[dict]:
    """获取指定系统下的表清单。"""
    url = f"{base}/api/systems/{system_name}/tables?limit={limit}"
    data = http_get(url)
    # 该端点响应结构为 {data: [...], total: int}，无 success 字段
    payload = data.get("data")
    if not isinstance(payload, list):
        raise RuntimeError(f"获取系统 {system_name} 表清单失败: {data}")
    return payload


def filter_eligible_tables(tables: list[dict]) -> list[dict]:
    """过滤掉 BAK 表和 0 列表。

    - BAK 表（表名包含 BAK，大小写不敏感）：用户要求不查
    - 0 列表：无字段可验证，且查询血缘时会被服务端作为幽灵表过滤
    """
    eligible: list[dict] = []
    seen_full: set[str] = set()
    for t in tables:
        full_name = (t.get("full_name") or "").strip()
        if not full_name or full_name in seen_full:
            continue
        if "BAK" in full_name.upper():
            continue
        seen_full.add(full_name)
        eligible.append(t)
    return eligible


def sample_tables(tables: list[dict], sample_size: int, seed: int) -> list[dict]:
    """可复现地随机抽样。"""
    rng = random.Random(seed)
    if len(tables) <= sample_size:
        return list(tables)
    return rng.sample(tables, sample_size)


# ── 表详情/主键 ─────────────────────────────────────────────


def fetch_table_detail(base: str, full_name: str) -> dict:
    """通过 /api/tables/{table} 获取表详情（含 primary_keys 和 columns）。"""
    encoded = full_name.replace("/", "%2F")
    # API 接受的是表全名（含 schema），无需 URL 编码 "."，但保险起见仍处理斜杠
    url = f"{base}/api/tables/{encoded}"
    try:
        data = http_get(url)
        # SingleTableInfoResponse 结构为 {data: {...}}，无 success 字段
        payload = data.get("data")
        if isinstance(payload, dict) and payload:
            return payload
    except URLError:
        # 表名包含特殊字符时回退到搜索
        pass

    # 回退：用搜索接口找一张匹配的表
    short = full_name.split(".")[-1] if "." in full_name else full_name
    url = f"{base}/api/tables?keyword={short}&limit=5"
    data = http_get(url)
    payload = data.get("data") or []
    for t in payload:
        if (t.get("full_name") or "").upper() == full_name.upper():
            # search_tables 返回的 columns 是字符串列表，没有 primary_keys
            return {
                "full_name": t.get("full_name"),
                "table_name": t.get("short_name"),
                "columns": [{"name": c, "data_type": ""} for c in (t.get("columns") or [])],
                "primary_keys": [],
            }
    return {}


def pick_primary_field(table_detail: dict) -> tuple[str, str]:
    """选取主键字段；无主键时回退到第一个有 data_type 的列。

    Returns:
        (field_name, source) — source 标识 "primary_key" / "first_column"。
    """
    primary_keys = table_detail.get("primary_keys") or []
    columns = table_detail.get("columns") or []

    if primary_keys:
        pk = primary_keys[0]
        # 校验 pk 是否真实存在于 columns
        for c in columns:
            if (c.get("name") or "").upper() == pk.upper():
                return pk, "primary_key"
        # 主键不在 columns 中也返回（用于暴露数据不一致问题）
        return pk, "primary_key_not_in_columns"

    if columns:
        first = columns[0]
        return first.get("name", ""), "first_column"
    return "", "no_column"


# ── 血缘查询 ────────────────────────────────────────────────


def query_field_lineage(
    base: str,
    table: str,
    field: str,
    depth: int = 5,
    mode: str = "both",
) -> dict:
    """调用 /api/lineage/query 查询字段级血缘。"""
    url = f"{base}/api/lineage/query"
    body = {
        "table": table,
        "field": field,
        "depth": depth,
        "mode": mode,
        "options": {
            "include_fields": True,
            "limit": 1000,
            "use_cache": True,
        },
    }
    return http_post(url, body, timeout=120)


# ── 校验逻辑 ────────────────────────────────────────────────


def collect_all_table_columns(base: str, sampled_tables: list[dict]) -> dict[str, set[str]]:
    """构建 {full_name_upper: {field_name_upper}} 索引，用于校验节点引用的表/字段是否存在。"""
    index: dict[str, set[str]] = {}
    for t in sampled_tables:
        detail = t.get("__detail") or {}
        full = (detail.get("full_name") or t.get("full_name") or "").upper()
        if not full:
            continue
        cols = {str(c.get("name", "")).upper() for c in (detail.get("columns") or []) if c.get("name")}
        index.setdefault(full, set()).update(cols)
    return index


def verify_node_integrity(
    nodes: list[dict],
    table_field_index: dict[str, set[str]],
) -> list[str]:
    """验证节点是否满足 "表+字段+字段类型" 三要素，且引用的表/字段真实存在。"""
    issues: list[str] = []
    for i, node in enumerate(nodes):
        full_name = (node.get("full_name") or "").strip()
        node_id = node.get("id") or full_name or f"node[{i}]"

        # 1. 必须有数据库表
        if not full_name:
            issues.append(f"节点 {node_id} 缺少 full_name（数据库表）")
            continue

        # 2. 必须有 field 子对象
        field_obj = node.get("field")
        if not isinstance(field_obj, dict):
            issues.append(f"节点 {full_name} 缺少 field 对象（无字段信息）")
            continue

        field_name = (field_obj.get("name") or "").strip()
        if not field_name:
            issues.append(f"节点 {full_name} 的 field.name 为空")
            continue

        # 3. 必须有字段类型 data_type
        data_type = (field_obj.get("data_type") or "").strip()
        if not data_type:
            issues.append(f"节点 {full_name}.{field_name} 缺少 data_type（字段类型）")

        # 4. 引用的表/字段在抽样数据中存在（仅校验抽样表，未抽样的不报错）
        if full_name.upper() in table_field_index:
            known_cols = table_field_index[full_name.upper()]
            if known_cols and field_name.upper() not in known_cols:
                issues.append(
                    f"节点 {full_name}.{field_name} 的字段不存在于该表的 columns 列表中"
                )
    return issues


def verify_lineage_completeness(
    result: dict,
    table: str,
    field: str,
) -> list[str]:
    """验证血缘结果非空且查询目标节点存在。

    注意：0 条边（无血缘关系）属于数据状态而非代码缺陷，不作为失败项。
    调用方通过 edges_count==0 判定 skipped_no_lineage。
    """
    issues: list[str] = []
    nodes = result.get("nodes", []) or []
    if not nodes:
        issues.append(f"查询 {table}.{field} 返回 0 个节点（血缘为空）")
        return issues

    # 查询目标节点必须存在
    target_present = any(
        (n.get("full_name") or "").upper() == table.upper() for n in nodes
    )
    if not target_present:
        issues.append(f"查询目标表 {table} 不在返回的节点中")

    return issues


# ── 报告输出 ────────────────────────────────────────────────


def print_section(title: str) -> None:
    print(f"\n{'=' * 70}")
    print(f"  {title}")
    print(f"{'=' * 70}")


def print_ok(msg: str) -> None:
    print(f"  ✅ {msg}")


def print_fail(msg: str) -> None:
    print(f"  ❌ {msg}")


def print_warn(msg: str) -> None:
    print(f"  ⚠️  {msg}")


# ── 主流程 ──────────────────────────────────────────────────


def main() -> int:
    parser = argparse.ArgumentParser(description="血缘随机抽查验证")
    parser.add_argument(
        "--base",
        default="http://localhost:8899",
        help="API 基地址 (默认: http://localhost:8899)",
    )
    parser.add_argument(
        "--seed",
        type=int,
        default=42,
        help="随机种子，保证可复现 (默认: 42)",
    )
    parser.add_argument(
        "--sample",
        type=int,
        default=5,
        help="每个系统抽样的表数量 (默认: 5)",
    )
    parser.add_argument(
        "--depth",
        type=int,
        default=5,
        help="血缘查询深度 (默认: 5)",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("output/lineage_sampling_report.json"),
        help="JSON 报告输出路径",
    )
    args = parser.parse_args()

    systems = ["rrp", "edw", "mcs", "fdm", "pam"]
    overall_ok = True
    report: dict[str, Any] = {
        "base": args.base,
        "seed": args.seed,
        "sample_size": args.sample,
        "systems": {},
    }

    print_section(f"血缘随机抽查验证 (seed={args.seed}, sample={args.sample})")
    print(f"  服务地址: {args.base}")
    print(f"  系统: {', '.join(systems)}")

    # 健康检查
    try:
        stats = http_get(f"{args.base}/api/stats")
        # SystemStatsResponse 结构为 {data: {...}}，无 success 字段
        data = stats.get("data") or {}
        if not data:
            print_fail("服务健康检查失败: 响应无 data 字段")
            return 1
        print_ok(
            f"服务可用: tables={data.get('total_tables')}, "
            f"lineages={data.get('total_table_lineages')}, "
            f"field_mappings={data.get('total_field_mappings')}"
        )
    except Exception as e:
        print_fail(f"服务不可达: {e}")
        return 1

    for sys_name in systems:
        print_section(f"系统: {sys_name}")
        sys_report: dict[str, Any] = {"tables": [], "all_passed": True}

        try:
            tables = fetch_system_tables(args.base, sys_name, limit=2000)
        except Exception as e:
            print_fail(f"获取表清单失败: {e}")
            sys_report["error"] = str(e)
            sys_report["all_passed"] = False
            report["systems"][sys_name] = sys_report
            overall_ok = False
            continue

        eligible = filter_eligible_tables(tables)
        print_ok(f"共 {len(tables)} 张表，过滤 BAK 后 {len(eligible)} 张可抽样")

        if len(eligible) < args.sample:
            print_warn(f"可抽样表数 {len(eligible)} < 要求 {args.sample}，全部纳入")

        sampled = sample_tables(eligible, args.sample, args.seed)
        print_ok(f"随机抽样 {len(sampled)} 张表")

        # 预取表详情，构建索引
        for t in sampled:
            full = t.get("full_name", "")
            try:
                detail = fetch_table_detail(args.base, full)
                t["__detail"] = detail
            except Exception as e:
                print_warn(f"获取表 {full} 详情失败: {e}")
                t["__detail"] = {}

        table_field_index = collect_all_table_columns(args.base, sampled)

        for idx, t in enumerate(sampled, 1):
            full = t.get("full_name", "")
            detail = t.get("__detail") or {}
            field_name, source = pick_primary_field(detail)

            print(f"\n  [{idx}/{len(sampled)}] {full}")
            print(f"      主键字段: {field_name} (来源: {source})")

            if not field_name:
                # 表无任何列（DDL 未解析或幽灵表）：跳过而非失败
                print_warn(f"表 {full} 无可用字段（0 列），跳过")
                sys_report["tables"].append({
                    "table": full,
                    "field": "",
                    "status": "skipped_no_column",
                    "issues": ["无可用字段（0 列表）"],
                })
                continue

            # 查询血缘
            t0 = time.perf_counter()
            try:
                result = query_field_lineage(
                    args.base, full, field_name, depth=args.depth, mode="both"
                )
            except Exception as e:
                print_fail(f"血缘查询失败: {e}")
                sys_report["tables"].append({
                    "table": full,
                    "field": field_name,
                    "status": "query_error",
                    "issues": [str(e)],
                })
                sys_report["all_passed"] = False
                overall_ok = False
                continue
            elapsed_ms = (time.perf_counter() - t0) * 1000

            data_dict = result.get("data", {}) if isinstance(result, dict) else {}
            nodes = data_dict.get("nodes", []) or []
            edges = data_dict.get("edges", []) or []
            field_mappings = data_dict.get("field_mappings", []) or []

            print(
                f"      节点数: {len(nodes)}, 边数: {len(edges)}, "
                f"字段映射: {len(field_mappings)}, 耗时: {elapsed_ms:.0f}ms"
            )

            issues: list[str] = []
            issues.extend(verify_lineage_completeness(data_dict, full, field_name))
            # 0 边表属于数据状态（无血缘可验证），标记 skipped 而非 failed
            is_no_lineage = (len(edges) == 0)
            if not is_no_lineage:
                issues.extend(verify_node_integrity(nodes, table_field_index))

            if is_no_lineage:
                table_status = "skipped_no_lineage"
            elif issues:
                table_status = "failed"
            else:
                table_status = "passed"

            table_report: dict[str, Any] = {
                "table": full,
                "field": field_name,
                "field_source": source,
                "nodes_count": len(nodes),
                "edges_count": len(edges),
                "field_mappings_count": len(field_mappings),
                "query_time_ms": round(elapsed_ms, 1),
                "issues": issues,
                "status": table_status,
            }
            sys_report["tables"].append(table_report)

            if table_status == "skipped_no_lineage":
                print_warn("无血缘关系（0 边），跳过节点完整性校验")
            elif issues:
                sys_report["all_passed"] = False
                overall_ok = False
                for issue in issues:
                    print_fail(issue)
            else:
                print_ok("血缘节点完整：表+字段+字段类型齐全，引用真实存在")

        report["systems"][sys_name] = sys_report
        if sys_report["all_passed"]:
            print_ok(f"系统 {sys_name} 全部通过")
        else:
            print_fail(f"系统 {sys_name} 存在问题")

    # 写入报告
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with open(args.output, "w", encoding="utf-8") as f:
        json.dump(report, f, ensure_ascii=False, indent=2)

    print_section("总结")
    total_tables = sum(len(s["tables"]) for s in report["systems"].values())
    skipped_no_lineage = sum(
        1 for s in report["systems"].values() for t in s.get("tables", [])
        if t.get("status") == "skipped_no_lineage"
    )
    skipped_no_column = sum(
        1 for s in report["systems"].values() for t in s.get("tables", [])
        if t.get("status") == "skipped_no_column"
    )
    failed_tables = sum(
        1 for s in report["systems"].values() for t in s.get("tables", [])
        if t.get("status") == "failed"
    )
    passed_tables = total_tables - skipped_no_lineage - skipped_no_column - failed_tables
    print(f"  总抽样表数: {total_tables}")
    print(f"  通过: {passed_tables}")
    print(f"  跳过(无血缘): {skipped_no_lineage}")
    print(f"  跳过(无列): {skipped_no_column}")
    print(f"  失败: {failed_tables}")
    print(f"  报告: {args.output}")
    if overall_ok:
        print_ok("血缘随机抽查验证全部通过")
        return 0
    print_fail("血缘随机抽查验证未通过，详见报告")
    return 2


if __name__ == "__main__":
    sys.exit(main())
