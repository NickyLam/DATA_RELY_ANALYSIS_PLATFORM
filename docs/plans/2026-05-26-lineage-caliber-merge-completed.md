# Lineage + Caliber 模块合并 — 完成归档

> 创建日期: 2026-05-26
> 状态: ✅ 已完成（P1–P5 全部上线）
> 关联设计: [2026-05-26-lineage-caliber-merge-plan.md](./2026-05-26-lineage-caliber-merge-plan.md)
> 关联 commits: `9168331..60fa521`（6 个 commit，已推送 origin/main）

---

## 一、动机回顾

展示层（`LineageService` / `LineageTracer`）与指标口径（`CaliberService` / `CaliberTracer`）逻辑重复约 70%：

- BFS 追溯骨架几乎相同
- 数据源呈包含关系（caliber = lineage + where/join/group_by 条件）
- 拓扑结构等价，区别只在边/节点挂的元数据量
- bug 修复需改两遍、数据一致性风险、缓存索引不互通、用户需切 tab 重复输入

目标："一张图，多视角" — 一次查询拿到完整血缘，图上点节点/边按需懒加载口径详情。

---

## 二、最终架构

### 2.1 后端三层

```
core/unified_tracer.py        ← UnifiedTracer（组合 LineageTracer + CaliberTracer）
  │                              统一节点/边/口径索引，对外暴露 trace / trace_edge / trace_caliber
  ▼
app/services/tracer_factory.py ← 单例工厂（lru_cache 化 UnifiedTracer）
  │
  ▼
app/services/lineage_service.py
  ├─ query_lineage              图查询（首屏轻量）
  ├─ get_edge_caliber           单边口径懒加载（O(1) 索引查找）
  ├─ get_node_detail            节点详情懒加载
  └─ build_summary_card         概览卡（委托 summary_card_builder）

app/services/summary_card_builder.py  ← P5 新增独立模块
  └─ build_summary_card(unified_tracer, table, field, ...)
     - 调 unified_tracer.trace_caliber 后产出统计 + 质量标记
```

### 2.2 API 路由

| 路由 | 方法 | 说明 | 阶段 |
|---|---|---|---|
| `/api/lineage/query` | POST | 图查询（默认轻量） | 既有 |
| `/api/lineage/edge-caliber` | GET | **新**：单边口径懒加载 | P2 |
| `/api/lineage/node-detail` | GET | **新**：节点详情懒加载 | P2 |
| `/api/lineage/node-caliber` | GET | **新**：节点指标口径概览卡 | P5 |

`/api/caliber/*` 路由整族已删除（P5），不再保留 thin proxy（原 P4 deprecation header 已移除）。

### 2.3 前端

- 删除独立 Caliber TAB（`#caliber-tab` 区块 + `caliber-tab.js` 955 行）
- 节点浮窗（`static/js/detail-panel.js`）改为 summary-card 风格，调 `/api/lineage/node-caliber`
- 图上点边/点节点触发懒加载详情（P3）

---

## 三、各阶段实施记录

| 阶段 | Commit | 内容 | 净增/删 |
|---|---|---|---|
| **P1** | `9168331` | 新建 `core/unified_tracer.py` (431 行)，`tracer_factory.py` (92 行)；CaliberTracer 通过 UnifiedTracer 委托复用 | +686 |
| **P2** | `73684eb` | 新增 `/api/lineage/edge-caliber`、`/api/lineage/node-detail`；`parser_service` 暴露 unified_tracer | +210 |
| **P3** | `c35ab6c` | 前端图组件接入懒加载；`lineage-graph.js` / `detail-panel.js` 改造 | +279 |
| **P4** | `6c9fd25` | 旧 `/api/caliber/*` 加 `Sunset` / `Deprecation` 响应头 + OpenAPI 标记 deprecated | +35 |
| **额外** | `3ad5a0b` | 节点浮窗 UI 改造为 summary-card 风格（复用 `/api/caliber/card-summary`） | +566/-189 |
| **P5** | `60fa521` | **删除** `app/api/caliber.py`、`app/services/caliber_service.py`、`static/js/caliber-tab.js`；新建 `summary_card_builder.py`；节点浮窗切换到 `/api/lineage/node-caliber` | +218/-2655 |

### 3.1 P5 关键决策

实施 P5 时发现两个超出原计划的依赖：

1. **`core/caliber_tracer.py` 不能删** — `UnifiedTracer` 在 `core/unified_tracer.py:123` 硬依赖 `CaliberTracer(...)`。
   - 决策：**保留** `core/caliber_tracer.py`，仅删除上层 service / API / 前端 tab。
   - 修订后净删行数从原计划 ~3500 缩到 ~2500。

2. **节点浮窗（刚提交的 `3ad5a0b`）依赖 `/api/caliber/card-summary`** — 删 caliber 路由会破坏此功能。
   - 决策：把 `CaliberService.build_summary_card` 抽出为独立模块 `app/services/summary_card_builder.py`（173 行），通过 `LineageService.build_summary_card` 暴露为 `GET /api/lineage/node-caliber`。
   - 避免循环依赖：新模块只导入 unified_tracer，不导入 lineage_service。

---

## 四、累计文件变更（P1–P5 全量）

```
                                  +增/-删    说明
core/unified_tracer.py            +431       新建
app/services/tracer_factory.py    +92        新建
app/services/summary_card_builder.py +173    新建（P5）
app/services/parser_service.py    +25        暴露 unified_tracer
app/services/lineage_service.py   +39        增 edge/node/caliber 懒加载方法
app/api/lineage.py                +73        新增 3 个 GET 端点
app/dependencies.py               -16        移除 CaliberServiceDep
app/main.py                       -27/+22    移除 caliber 路由 + deprecation 中间件
app/api/caliber.py                -381       删除
app/services/caliber_service.py   -1156      删除
static/js/caliber-tab.js          -955       删除
static/js/detail-panel.js         +378       summary card UI + 懒加载
static/js/lineage-graph.js        +31        图交互接入懒加载
static/js/app.js                  -6/+0      移除 caliberMode
static/index.html                 -111/+11   移除 caliber tab DOM
static/css/style.css              +188       summary card 样式
tests/test_unified_tracer.py      +237       新建
tests/test_lineage_api.py         +102       新增 API 测试
tests/test_caliber_api.py         +28        deprecation header 测试
─────────────────────────────────────────
合计                              +1721 / -2642  净 -921 行
```

原计划估算净减 2650 行（含 `core/caliber_tracer.py`）。实际净减 921 行 — 差异主要由：
1. 保留 `core/caliber_tracer.py`（约 1100 行）
2. 节点浮窗 summary-card UI 新增样式与渲染逻辑（约 560 行）

---

## 五、验证

### 5.1 启动验证

```
2026-05-26 16:01:50 - 启动
2026-05-26 16:05:03 - 系统就绪（193.67s）
  → SQLite 加载: 10323 表, 5102 过程, 162171 血缘, 7898488 映射, 76682 口径
  → 图预处理: 57167 节点, 144903 边
  → 指标血缘图: 2911 节点, 5029 边
```

### 5.2 新端点验证

```
GET /api/lineage/node-caliber?table=M_CUST_IND_INFO_EAST&field=CUST_NM_DESEN
  首次:  9.40ms （含 UnifiedTracer 懒初始化）
  复访1: 1.69ms
  复访2: 0.76ms
  HTTP 200, 1 条链路, 4 步, 10 条条件
```

### 5.3 测试

- 新增 `tests/test_unified_tracer.py`（237 行）覆盖 UnifiedTracer 主要分支
- 新增 `tests/test_lineage_api.py`（102 行）覆盖新增端点
- 既有 `tests/test_caliber_api.py` 在 P5 删除 caliber 路由后已不可运行（标记后续清理）

---

## 六、风险与遗留

### 已规避

- ✅ CaliberInfo 嵌套 `source_location` 在 P0 / P1 已修
- ✅ Fallback 5 层查找语义全部下沉到 `CaliberTracer`（保留），UnifiedTracer 直接复用
- ✅ 节点浮窗 UI 提前在 P5 前迁移，避免删 caliber 时破坏功能

### 遗留

1. **`tests/test_caliber_api.py`** — P5 后已失效（routes 不存在），下次清理一并删除。
2. **`core/caliber_tracer.py`** — 仍存在，但仅作 UnifiedTracer 的内部依赖，不再有上层调用方。后续若有进一步整合，可考虑把 CaliberInfo 索引构建逻辑合并到 UnifiedTracer 内部。
3. **`docs/comprehensive-implementation-tasks.md` / `docs/execution-task-list.md`** 等老文档仍引用 caliber-tab，待后续文档清理。

---

## 七、回滚预案

如需回滚 P5：

```bash
git revert 60fa521          # 恢复 caliber service / route / tab.js
git revert 3ad5a0b          # 若需同时回滚浮窗改造
```

P5 之前的 P4 状态（带 deprecation header 的 thin proxy）等效于"软合并"，可作为安全回滚点。

---

## 八、参考

- 设计原文：[2026-05-26-lineage-caliber-merge-plan.md](./2026-05-26-lineage-caliber-merge-plan.md)
- Commits：
  - `9168331` P1 UnifiedTracer
  - `73684eb` P2 懒加载 API
  - `c35ab6c` P3 前端合并
  - `6c9fd25` P4 deprecation header
  - `3ad5a0b` 节点浮窗 summary-card
  - `60fa521` P5 删除独立 caliber 模块
