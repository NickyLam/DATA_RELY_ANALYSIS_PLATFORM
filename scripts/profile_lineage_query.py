"""
查询性能诊断脚本

用于测量 /api/lineage/query 端点的响应时间，区分首次查询和缓存命中查询。
支持两种模式：
  - 服务层直接调用（默认）
  - HTTP 调用本地服务（--http 模式）

用法：
  python scripts/profile_lineage_query.py --table RRP_MDL.EAST5_201_GRJCXXB --field KHXM --repeat 3
  python scripts/profile_lineage_query.py --table RRP_MDL.EAST5_201_GRJCXXB --mode upstream --repeat 5
  python scripts/profile_lineage_query.py --table RRP_MDL.EAST5_201_GRJCXXB --field KHXM --http --port 8899
"""

from __future__ import annotations

import argparse
import json
import sys
import time
from pathlib import Path

# 添加项目根目录到 path
_project_root = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(_project_root))


def profile_via_service(table: str, field: str | None, depth: int, mode: str, repeat: int) -> None:
    """通过服务层直接调用测量性能。"""
    from app.config import config
    from app.services.index_service import IndexService
    from app.services.lineage_service import LineageService
    from app.services.parser_service import ParserService
    from app.utils.cache_manager import CacheManager

    print("[INFO] 初始化服务...")
    parser_service = ParserService(
        data_dir=str(config.data_path),
        schema_dirs=config.schema_dirs,
        output_dir=str(config.output_path),
    )
    cache_manager = CacheManager(
        max_size=config.max_cache_size,
        ttl=config.cache_ttl_seconds,
    )
    index_service = IndexService(parser_service=parser_service)
    lineage_service = LineageService(
        parser_service=parser_service,
        cache_manager=cache_manager,
        index_service=index_service,
    )

    # 预热：加载缓存数据
    print("[INFO] 加载数据...")
    data = parser_service.get_current_data()
    if not data:
        print("[ERROR] 无可用数据，请先运行解析")
        index_service.close()
        parser_service.shutdown()
        return

    metadata = data.get("metadata", {})
    print(f"[INFO] 数据加载完成: {metadata.get('total_tables', 0)} 表, "
          f"{metadata.get('total_field_mappings', 0)} 映射")

    print(f"\n{'=' * 70}")
    print(f"查询参数: table={table}, field={field}, depth={depth}, mode={mode}")
    print(f"重复次数: {repeat}")
    print(f"{'=' * 70}\n")

    results = []
    for i in range(repeat):
        t0 = time.perf_counter()
        result = lineage_service.query_lineage(
            table=table,
            field=field,
            depth=depth,
            mode=mode,
            include_fields=True,
            use_cache=True,
        )
        elapsed_ms = (time.perf_counter() - t0) * 1000

        cache_hit = result.get("cache_hit", False)
        nodes_count = result.get("nodes_count", 0)
        edges_count = result.get("edges_count", 0)
        field_mapping_count = result.get("field_mapping_count", 0)
        reported_ms = result.get("query_time_ms", 0)

        results.append({
            "run": i + 1,
            "elapsed_ms": round(elapsed_ms, 2),
            "reported_ms": round(reported_ms, 2),
            "cache_hit": cache_hit,
            "nodes_count": nodes_count,
            "edges_count": edges_count,
            "field_mapping_count": field_mapping_count,
        })

        status = "CACHE_HIT" if cache_hit else "COLD"
        print(f"  #{i + 1:2d}  {status:10s}  wall={elapsed_ms:8.1f}ms  "
              f"reported={reported_ms:8.1f}ms  "
              f"nodes={nodes_count:4d}  edges={edges_count:4d}  "
              f"mappings={field_mapping_count:4d}")

    # 统计
    print(f"\n{'=' * 70}")
    cold_runs = [r for r in results if not r["cache_hit"]]
    warm_runs = [r for r in results if r["cache_hit"]]

    if cold_runs:
        cold_times = [r["elapsed_ms"] for r in cold_runs]
        print(f"冷查询 ({len(cold_runs)} 次): "
              f"min={min(cold_times):.1f}ms  "
              f"max={max(cold_times):.1f}ms  "
              f"avg={sum(cold_times) / len(cold_times):.1f}ms")

    if warm_runs:
        warm_times = [r["elapsed_ms"] for r in warm_runs]
        print(f"缓存命中 ({len(warm_runs)} 次): "
              f"min={min(warm_times):.1f}ms  "
              f"max={max(warm_times):.1f}ms  "
              f"avg={sum(warm_times) / len(warm_times):.1f}ms")

    # 保存详细结果
    output_path = _project_root / "output" / "profile_results.json"
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump({
            "params": {
                "table": table,
                "field": field,
                "depth": depth,
                "mode": mode,
                "repeat": repeat,
            },
            "results": results,
        }, f, ensure_ascii=False, indent=2)
    print(f"\n详细结果已保存到: {output_path}")

    index_service.close()
    parser_service.shutdown()


def profile_via_http(table: str, field: str | None, depth: int, mode: str,
                     repeat: int, port: int) -> None:
    """通过 HTTP 调用本地服务测量性能。"""
    try:
        import httpx
    except ImportError:
        print("[ERROR] httpx 未安装，请使用 pip install httpx 或服务层模式")
        return

    base_url = f"http://127.0.0.1:{port}"
    print(f"[INFO] HTTP 模式: {base_url}")
    print(f"查询参数: table={table}, field={field}, depth={depth}, mode={mode}")
    print(f"重复次数: {repeat}\n")

    results = []
    with httpx.Client(timeout=120) as client:
        for i in range(repeat):
            payload = {
                "table": table,
                "field": field or "",
                "depth": depth,
                "mode": mode,
                "options": {
                    "include_fields": True,
                    "use_cache": True,
                },
            }
            t0 = time.perf_counter()
            resp = client.post(f"{base_url}/api/lineage/query", json=payload)
            elapsed_ms = (time.perf_counter() - t0) * 1000

            if resp.status_code != 200:
                print(f"  #{i + 1:2d}  ERROR  status={resp.status_code}  {resp.text[:200]}")
                continue

            body = resp.json()
            data = body.get("data", body)
            cache_hit = data.get("cache_hit", False)
            nodes_count = data.get("nodes_count", 0)
            edges_count = data.get("edges_count", 0)

            results.append({
                "run": i + 1,
                "elapsed_ms": round(elapsed_ms, 2),
                "cache_hit": cache_hit,
                "nodes_count": nodes_count,
                "edges_count": edges_count,
            })

            status = "CACHE_HIT" if cache_hit else "COLD"
            print(f"  #{i + 1:2d}  {status:10s}  wall={elapsed_ms:8.1f}ms  "
                  f"nodes={nodes_count:4d}  edges={edges_count:4d}")


def main():
    parser = argparse.ArgumentParser(description="血缘查询性能诊断")
    parser.add_argument("--table", required=True, help="查询表名")
    parser.add_argument("--field", default=None, help="查询字段名（可选）")
    parser.add_argument("--depth", type=int, default=3, help="追溯深度（默认 3）")
    parser.add_argument("--mode", default="both", choices=["upstream", "downstream", "both"],
                        help="追溯方向（默认 both）")
    parser.add_argument("--repeat", type=int, default=3, help="重复次数（默认 3）")
    parser.add_argument("--http", action="store_true", help="使用 HTTP 模式调用本地服务")
    parser.add_argument("--port", type=int, default=8899, help="HTTP 模式端口（默认 8899）")

    args = parser.parse_args()

    if args.http:
        profile_via_http(args.table, args.field, args.depth, args.mode, args.repeat, args.port)
    else:
        profile_via_service(args.table, args.field, args.depth, args.mode, args.repeat)


if __name__ == "__main__":
    main()
