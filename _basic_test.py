#!/usr/bin/env python3
"""基础功能测试脚本"""

import json
import sys
import urllib.error
import urllib.request

BASE = "http://localhost:8004"


def req(method, path, data=None):
    url = f"{BASE}{path}"
    body = json.dumps(data).encode("utf-8") if data else None
    r = urllib.request.Request(url, data=body, method=method)
    if body:
        r.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(r, timeout=15) as resp:
            return resp.status, json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        return e.code, json.loads(e.read().decode("utf-8"))
    except Exception as e:
        return -1, {"error": str(e)}


results = {"pass": 0, "fail": 0}


def test(name, status, data, check_fn, msg):
    try:
        if status == 200 and check_fn(data):
            print(f"  ✅ {msg}")
            results["pass"] += 1
            return True
    except Exception:
        pass
    print(f"  ❌ {name}: status={status}, data={data}")
    results["fail"] += 1
    return False


print("=" * 60)
print("基础功能测试")
print("=" * 60)

# 1. 系统管理
print("\n[系统管理]")
s, d = req("GET", "/health")
test(
    "health",
    s,
    d,
    lambda x: x.get("status") in ("healthy", "degraded"),
    f"健康检查: status={d.get('status')}, data_loaded={d.get('data', {}).get('loaded')}",
)

s, d = req("GET", "/")
test(
    "sys_root",
    s,
    d,
    lambda x: "service" in x,
    f"系统根路径: service={d.get('service')}, version={d.get('version')}",
)

# 2. 表搜索
print("\n[表搜索]")
s, d = req("GET", "/api/tables?keyword=KHXXB&limit=5")
test(
    "search",
    s,
    d,
    lambda x: len(x.get("data", [])) > 0,
    f"表搜索: 结果数={len(d.get('data', []))}",
)

# 3. 表信息
print("\n[表信息]")
s, d = req("GET", "/api/tables/RRP_EAST.EAST5_KHXXB")
test(
    "table_info",
    s,
    d,
    lambda x: x.get("data", {}).get("full_name") is not None,
    f"表信息: {d.get('data', {}).get('full_name')}",
)

# 4. 统计
print("\n[统计]")
s, d = req("GET", "/api/stats")
test(
    "stats",
    s,
    d,
    lambda x: x.get("data", {}).get("total_tables", 0) > 0,
    f"统计: tables={d.get('data', {}).get('total_tables')}, procs={d.get('data', {}).get('total_procedures')}",
)

# 5. 系统信息
print("\n[系统信息]")
s, d = req("GET", "/api/system/info")
test(
    "sys_info",
    s,
    d,
    lambda x: x.get("data", {}).get("version") is not None,
    f"系统信息: version={d.get('data', {}).get('version')}",
)

s, d = req("GET", "/api/system/stats")
test(
    "sys_stats",
    s,
    d,
    lambda x: x.get("data", {}).get("tables", 0) > 0,
    f"系统统计: tables={d.get('data', {}).get('tables')}, procs={d.get('data', {}).get('procedures')}",
)

# 6. 解析管理
print("\n[解析管理]")
s, d = req("GET", "/api/parse/tasks")
test(
    "parse_tasks",
    s,
    d,
    lambda x: "data" in x,
    f"任务列表: total={d.get('data', {}).get('total')}",
)

# 汇总
print("\n" + "=" * 60)
print(f"测试结果: 通过 {results['pass']} / 失败 {results['fail']} / 总计 {results['pass'] + results['fail']}")
print("=" * 60)

sys.exit(0 if results["fail"] == 0 else 1)
