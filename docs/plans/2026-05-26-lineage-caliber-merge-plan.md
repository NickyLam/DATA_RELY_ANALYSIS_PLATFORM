# Lineage + Caliber 模块合并方案

> 创建日期: 2026-05-26
> 状态: 待实施（P0 修复后启动 P1-P5）

---

## 一、背景

展示层（LineageService / LineageTracer）和指标口径（CaliberService / CaliberTracer）存在 70% 逻辑重复：
- BFS 追溯骨架几乎一样（base_tracer 已抽公共部分）
- 数据源是包含关系（caliber = lineage + where/join/group_by 等条件）
- 拓扑结构完全等价，区别只在边/节点上挂的元数据量

当前代价：
1. bug 修复要改两遍（字段血缘 dedup 只改了 lineage 一侧）
2. 数据一致性风险（lineage 4 节点 vs caliber 1 步）
3. 用户需切 tab 重新输入表/字段才能看口径
4. 缓存/索引不互通，重复占内存

---

## 二、总体思路："一张图，多视角"

```
┌─────────────────────────────────────────────────────────┐
│                  统一血缘查询页面                          │
│  ┌─────────────────────────┐  ┌──────────────────────┐  │
│  │                         │  │   节点详情面板         │  │
│  │     血缘图（共享）       │  │  ┌───────────────┐   │  │
│  │   nodes + edges         │  │  │ Tab1: 表/字段  │   │  │
│  │                         │  │  │ Tab2: 加工口径 │◄──┼──── 点节点 / 点边
│  │   点击节点 ────────────►│  │  │ Tab3: 步骤详情 │   │  │
│  │                         │  │  └───────────────┘   │  │
│  └─────────────────────────┘  └──────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

用户路径：输入表+字段 → 一次查询拿到完整血缘 → 图上点任一节点/边 → 右侧面板按需懒加载口径详情。

---

## 三、后端架构（三层重构）

### 3.1 统一 Tracer

```
core/unified_tracer.py
  class UnifiedTracer(BaseTracer):
      def trace(table, field, depth, mode, with_caliber=False)
          → returns UnifiedLineageResult
              .nodes: list[NodeInfo]
              .edges: list[EdgeInfo]      # 每条边可携带 caliber_step
              .caliber_steps: dict[(src, src_col, tgt, tgt_col, proc)] → CaliberInfo
```

- BFS 用 LineageTracer 的（更成熟，修了 4 个 bug）
- 口径详情通过 `caliber_steps` dict 关联到边
- `with_caliber=False` 只返回拓扑（首屏 < 100ms）
- `with_caliber=True` 或 lazy 拉取单边时附加 CaliberInfo

### 3.2 服务层精简

```
app/services/lineage_service.py
  class LineageService:
      query_lineage(table, field, depth, mode)              # 图查询
      get_edge_caliber(src, src_col, tgt, tgt_col, proc)   # 单边口径懒加载
      get_node_detail(table)                                # 节点详情懒加载
      build_pipeline_view(table, field)                     # 整链 Pipeline
      build_summary_card(table, field)                      # 概览卡
      export_caliber_doc(table, field, format)              # 文档导出
```

- 删除 caliber_service.py 的重复 BFS 入口
- 保留口径特有的"展示构建"方法，内部调用 `query_lineage(with_caliber=True)`

### 3.3 API 路由收敛

保留：
| 路由 | 说明 |
|---|---|
| `POST /api/lineage/query` | 图查询（默认轻量） |
| `GET /api/lineage/edge-caliber` | **新**：单边口径懒加载 |
| `GET /api/lineage/node-detail` | **新**：节点详情懒加载 |
| `GET /api/lineage/pipeline` | 整链 Pipeline（沿用 caliber/pipeline） |
| `GET /api/lineage/summary` | 概览卡（沿用 caliber/card-summary） |
| `POST /api/lineage/export` | 文档导出（沿用 caliber/export） |
| `GET /api/lineage/search-indicator` | 指标搜索（沿用 caliber/search） |

删除（兼容期保留 thin proxy + deprecation header）：
- `/api/caliber/query`, `/api/caliber/trace` → `query_lineage` 替代
- `/api/caliber/sources`, `/api/caliber/targets` → `query_lineage(depth=1)` 替代
- `/api/caliber/step-detail` → 图上点边触发 `edge-caliber`
- `/api/caliber/datasources` → 移到 `/api/system`

---

## 四、前端架构

### 4.1 页面合并

```
合并：display-tab + caliber-tab → lineage-tab

新组件：
  static/js/lineage-tab.js          # 主面板：搜索表+字段
  static/js/lineage-graph.js        # 复用现有图组件
  static/js/lineage-detail-panel.js # 右侧详情面板
```

### 4.2 详情面板 Tabs

| Tab | 触发 | 内容 |
|---|---|---|
| 节点信息 | 点节点 | 表名/comment/字段列表 |
| 加工口径 | 点边 | where/join/transform_logic |
| Pipeline | 整链路按钮 | caliber pipeline view |
| 概览卡 | 整链路按钮 | summary card |
| 导出 | 导出按钮 | markdown/html |

入口保留两种触发方式（向后兼容）：
- 表搜索 → 选字段 → 看血缘图
- 指标搜索 → 选指标 → 跳同一页面

---

## 五、数据流对比

**当前（两条独立链路）**：
```
Frontend → /api/lineage/query → LineageService → LineageTracer → field_mappings 索引
Frontend → /api/caliber/trace → CaliberService  → CaliberTracer → caliber_infos 索引
```

**合并后**：
```
Frontend → /api/lineage/query (with_caliber=false)
        → LineageService.query_lineage → UnifiedTracer.trace
        → 返回 nodes + edges（首屏 50-100ms）

用户点边 → /api/lineage/edge-caliber?src=...&tgt=...&proc=...
        → LineageService.get_edge_caliber → 查 caliber_infos 索引（O(1)）
        → 返回单条 CaliberInfo（按需懒加载）
```

---

## 六、渐进式实施路线

| 阶段 | 内容 | 风险 | 价值 |
|---|---|---|---|
| **P0 修复** | CaliberTracer source_location 嵌套读取 bug | 低 | 立刻可用 |
| **P1 后端统一索引** | UnifiedTracer 新建，CaliberTracer 委托，公开 with_caliber；不动 API | 中 | 一致性保证 |
| **P2 新增懒加载 API** | /api/lineage/edge-caliber + /api/lineage/node-detail | 低 | 前端可开始改造 |
| **P3 前端合并页面** | 新建 lineage-tab，caliber pipeline/summary/export 嵌进详情面板 | 中 | 用户体验打通 |
| **P4 旧 API 转 proxy** | /api/caliber/* 变 thin proxy + deprecation header | 低 | 兼容期 |
| **P5 删除旧代码** | 删除 caliber_service、caliber_tracer、caliber-tab.js | 低 | 减 ~2500 行 |

每阶段独立可发布，任何阶段停下不破坏现状。

---

## 七、保留的能力（必须）

- CaliberInfo 所有附加字段（where/join/group_by/CTE/custom_functions/SQL 片段）
- Pipeline 分支检测、layer_order 排序
- 文档导出（markdown/html）
- 指标搜索独立入口
- caliber 的 5 层 fallback 查找链路语义

---

## 八、风险点

1. **CaliberInfo 嵌套 source_location** — 必须先 P0 修掉
2. 前端图交互改动可能影响用户习惯 — P3 保留旧 tab 做 A/B
3. caliber fallback 链路逻辑迁移到 UnifiedTracer 时必须保留完整语义

---

## 九、代码量估算

| 项目 | 当前 | 合并后 | 净减 |
|---|---|---|---|
| core tracer | 2080 行 | ~1500 行 | -580 |
| service | 2200 行 | ~1400 行 | -800 |
| frontend | 3200 行 | ~2200 行 | -1000 |
| API routes | ~500 行 | ~250 行 | -250 |
| **合计** | **~8000** | **~5350** | **-2650** |
