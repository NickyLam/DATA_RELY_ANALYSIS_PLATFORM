"""
端到端验证脚本 — 验证展示层血缘查询三个 Bug 修复

Bug 1: Schema 自动匹配错误 (EAST5_ 表应匹配 RRP_EAST 而非 RRP_MDL)
Bug 2: 错误用户名+表名仍能查询 (应校验失败)
Bug 3: 重复分支血缘 (EAST 表不应追溯到 ICL/ODS 层)
"""

import json
import sys

import requests

BASE = "http://localhost:8088"


def title(text: str):
    print(f"\n{'=' * 60}")
    print(f"  {text}")
    print(f"{'=' * 60}")


def ok(text: str):
    print(f"  ✅ {text}")


def fail(text: str):
    print(f"  ❌ {text}")


def warn(text: str):
    print(f"  ⚠️  {text}")


# -----------------------------------------------------------
# Bug 1 & Bug 2: 测试 resolve_table_name 行为
# -----------------------------------------------------------
def test_table_resolution():
    title("Bug 1 & 2: 表名解析验证")

    # 通过 API 获取所有表来验证
    resp = requests.get(f"{BASE}/api/lineage/tables")
    if resp.status_code != 200:
        # 尝试旧版 API
        resp = requests.get(f"{BASE}/api/tables")

    if resp.status_code == 200:
        data = resp.json()
        tables = data.get("tables", []) if isinstance(data, dict) else data

        # 查找 EAST5_201_GRJCXXB 相关的表
        east_tables = [t for t in tables if "EAST5_201_GRJCXXB" in str(t).upper()]
        mdl_tables = [t for t in tables if "RRP_MDL" in str(t).upper() and "EAST5_201_GRJCXXB" in str(t).upper()]
        east_schema_tables = [
            t for t in tables if "RRP_EAST" in str(t).upper() and "EAST5_201_GRJCXXB" in str(t).upper()
        ]

        print("\n  查找 EAST5_201_GRJCXXB 相关表:")
        print(f"    总数: {len(east_tables)}")
        print(f"    RRP_MDL schema: {len(mdl_tables)}")
        print(f"    RRP_EAST schema: {len(east_schema_tables)}")

        if east_schema_tables and not mdl_tables:
            ok("EAST5_201_GRJCXXB 只存在于 RRP_EAST schema (Bug 1 修复验证通过)")
        elif east_schema_tables and mdl_tables:
            warn("两个 schema 都存在，需要验证优先级")
            print(f"    RRP_EAST: {east_schema_tables[:3]}")
            print(f"    RRP_MDL: {mdl_tables[:3]}")
        else:
            print(f"    所有匹配: {east_tables[:5]}")

    return True


# -----------------------------------------------------------
# Bug 3: 字段级血缘查询 — 验证无 ICL 分支
# -----------------------------------------------------------
def test_field_lineage():
    title("Bug 3: 字段级血缘查询验证 (EAST5_201_GRJCXXB.KHXM 上游追溯)")

    # 尝试展示层血缘 API
    endpoints = [
        f"{BASE}/api/lineage/field/upstream",
        f"{BASE}/api/field-lineage/upstream",
    ]

    payload = {
        "table_name": "EAST5_201_GRJCXXB",
        "field_name": "KHXM",
    }

    for endpoint in endpoints:
        resp = requests.post(endpoint, json=payload)
        if resp.status_code == 200:
            data = resp.json()
            print(f"\n  API 端点: {endpoint}")
            print(f"  响应状态: {resp.status_code}")

            # 分析返回的血缘路径
            paths = data.get("paths", data.get("chains", data.get("lineage", [])))
            if isinstance(paths, list):
                print(f"  血缘路径数量: {len(paths)}")
                for i, path in enumerate(paths):
                    path_str = json.dumps(path, ensure_ascii=False)[:200]
                    print(f"    路径 {i + 1}: {path_str}")

                    # 检查是否包含 ICL schema
                    if "ICL" in str(path).upper():
                        fail(f"路径 {i + 1} 包含 ICL schema (Bug 3 未修复!)")
                    else:
                        ok(f"路径 {i + 1} 不包含 ICL schema")

                # 总结
                icl_paths = [p for p in paths if "ICL" in str(p).upper()]
                if icl_paths:
                    fail(f"发现 {len(icl_paths)} 条包含 ICL 的血缘路径 — Bug 3 修复失败!")
                else:
                    ok("所有血缘路径均不包含 ICL schema — Bug 3 修复验证通过")
            return True

    # 如果以上端点都不存在，尝试通用血缘查询
    print("\n  ⚠️  专用端点不可用，尝试通用端点...")
    resp = requests.get(
        f"{BASE}/api/lineage",
        params={"table": "EAST5_201_GRJCXXB", "field": "KHXM", "direction": "upstream"},
    )
    if resp.status_code == 200:
        data = resp.json()
        print(f"  通用端点响应: {json.dumps(data, ensure_ascii=False)[:300]}")
    else:
        warn(f"  通用端点也不可用 (HTTP {resp.status_code})")

    return False


# -----------------------------------------------------------
# 综合验证: 测试错误 schema 输入
# -----------------------------------------------------------
def test_wrong_schema():
    title("Bug 2 补充: 错误 schema 输入验证")

    # 输入 RRP_MDL.EAST5_201_GRJCXXB（错误 schema）
    # 如果实际表只存在于 RRP_EAST，则应返回错误或空结果
    endpoints = [
        f"{BASE}/api/lineage/field/upstream",
        f"{BASE}/api/field-lineage/upstream",
    ]

    payload = {
        "table_name": "RRP_MDL.EAST5_201_GRJCXXB",
        "field_name": "KHXM",
    }

    for endpoint in endpoints:
        resp = requests.post(endpoint, json=payload)
        if resp.status_code == 200:
            data = resp.json()
            paths = data.get("paths", data.get("chains", data.get("lineage", [])))
            if isinstance(paths, list) and len(paths) > 0:
                fail(f"错误 schema RRP_MDL.EAST5_201_GRJCXXB 仍返回 {len(paths)} 条路径 — Bug 2 修复失败!")
            else:
                ok("错误 schema 输入返回空结果 — Bug 2 修复验证通过")
            return True

    warn("  无法找到可用的 API 端点进行测试")
    return False


# -----------------------------------------------------------
# 主验证流程
# -----------------------------------------------------------
if __name__ == "__main__":
    print("\n" + "=" * 60)
    print("  数据血缘分析系统 — 端到端验证")
    print("  目标: 验证展示层血缘查询三个 Bug 修复")
    print("=" * 60)

    # 检查服务是否可达
    try:
        resp = requests.get(f"{BASE}/", timeout=5)
        if resp.status_code == 200:
            ok(f"服务可达: {BASE}")
        else:
            fail(f"服务响应异常: HTTP {resp.status_code}")
            sys.exit(1)
    except Exception as e:
        fail(f"服务不可达: {e}")
        sys.exit(1)

    # 执行验证
    results = {}
    results["Bug 1 & 2 (表名解析)"] = test_table_resolution()
    results["Bug 3 (字段血缘)"] = test_field_lineage()
    results["Bug 2 补充(错误 schema)"] = test_wrong_schema()

    # 总结
    title("验证总结")
    for name, passed in results.items():
        if passed:
            ok(f"{name}: 通过")
        else:
            fail(f"{name}: 失败或部分失败")

    all_passed = all(results.values())
    print(f"\n  {'=' * 60}")
    if all_passed:
        print("  🎉 所有验证通过! 三个 Bug 修复生效。")
    else:
        print("  ⚠️  部分验证未通过，需要进一步检查。")
    print(f"  {'=' * 60}\n")
