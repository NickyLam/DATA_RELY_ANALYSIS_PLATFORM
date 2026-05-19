# 财务集市指标血缘双模式展示设计方案

> 版本: v2.0 | 日期: 2026-05-19
> 模型: Claude (SOLO) | 上下文: 200K tokens
> v2.0 变更: 对齐展示层视觉风格与交互模式，统一布局结构

---

## 1. 背景与问题

### 1.1 现状

当前指标血缘 Tab 对所有指标采用统一的 D3 力导向图渲染，不区分指标类型。用户搜索指标后，无论总账指标还是基础指标，均以相同的节点-边图谱展示。

### 1.2 问题

| 维度 | 总账指标 | 基础指标 |
|------|---------|---------|
| 数据来源 | 总账科目表 (FML_IDX_ADM_GL_INFO) | 业务源表 (多表、SQL 模板) |
| 加工链路 | 科目→度量→指标，线性清晰 | 源表→SQL→度量→指标→衍生，复杂分支 |
| 映射方式 | 科目号+符号+金额值，规则明确 | measure_sql + condition_sql，逻辑多样 |
| 穿透需求 | 穿透到科目即可，链路终止 | 需穿透到字段级血缘，链路延续 |
| 展示效果 | 统一力导向图下，科目节点与表节点混杂，层级感弱 | SQL 细节被压缩，穿透入口不明显 |

**核心矛盾**：两种指标的加工语义和用户关注点截然不同，统一展示导致「总账看不清层级、基础看不清逻辑」。

### 1.3 与展示层的风格差距

当前指标血缘 Tab 与展示层 Tab 存在显著风格差异：

| 维度 | 展示层 (display-tab) | 指标血缘层 (indicator-tab) |
|------|---------------------|--------------------------|
| 页面布局 | 顶部查询栏 + 左侧详情面板 + 右侧图谱区 | 左侧搜索面板 + 右侧图谱区 |
| 图谱布局 | BFS 深度分层垂直布局 + 左侧层级标签 | D3 力导向图 (force simulation) |
| 节点样式 | 240×72 圆角矩形，三行信息 (Schema+表名+字段) | 20px 圆形，仅显示截断编号 |
| 连线样式 | 贝塞尔曲线 + 箭头 marker | 直线 |
| 详情交互 | 右侧 infoPanel 浮窗 | 右侧 detailPanel 浮窗 |
| 缩放控制 | 底部缩放按钮组 | 无 |
| 图例 | 底部图例 | 无 |

### 1.4 设计目标

1. **风格统一**：指标血缘 Tab 的布局、节点样式、连线、交互与展示层保持一致
2. **总账指标**：展示清晰的「科目→度量→指标」层级链路，突出科目映射规则
3. **基础指标**：展示完整的「源表→SQL→度量→指标」加工逻辑，支持穿透到字段血缘
4. **自动识别**：解析阶段对指标打标，前端根据类型自动切换展示模式
5. **平滑过渡**：同一指标可能同时有总账和基础配置（混合指标），需支持双模式共存

---

## 2. 指标类型分类体系

### 2.1 分类定义

```
指标类型 (indicator_category)
├── gl          总账指标：数据来源于总账科目表，通过科目号+符号+金额值映射
├── base        基础指标：数据来源于业务源表，通过 SQL 模板计算
├── derived     衍生指标：依赖其他指标计算得出
└── hybrid      混合指标：同时存在总账和基础配置
```

### 2.2 分类判定规则

解析阶段按以下优先级判定每个指标的 `indicator_category`：

```python
def classify_indicator(
    index_no: str,
    base_calcs: list[IndicatorCalcBase],
    gl_calcs: list[IndicatorCalcGL],
    relations: list[IndicatorRel],
) -> str:
    has_base = bool(base_calcs)
    has_gl = bool(gl_calcs)
    is_derived = any(r.index_no == index_no for r in relations)

    if has_base and has_gl:
        return "hybrid"
    if has_gl:
        return "gl"
    if is_derived and not has_base:
        return "derived"
    return "base"
```

### 2.3 分类标签与颜色映射

颜色体系与展示层 `LAYER_CONFIG` / `getDepthLayerConfig` 保持一致的设计语言：

```python
INDICATOR_CATEGORY_LABELS: dict[str, str] = {
    "gl": "总账指标",
    "base": "基础指标",
    "derived": "衍生指标",
    "hybrid": "混合指标",
}

INDICATOR_CATEGORY_COLORS: dict[str, dict] = {
    "gl":      {"bg": "#fef3c7", "border": "#d97706", "text": "#92400e",
                "color": "#f59e0b"},   # 对齐展示层第1层来源色
    "base":    {"bg": "#dbeafe", "border": "#2563eb", "text": "#1e40af",
                "color": "#3b82f6"},   # 对齐展示层第2层来源色
    "derived": {"bg": "#ede9fe", "border": "#7c3aed", "text": "#5b21b6",
                "color": "#8b5cf6"},   # 对齐展示层第3层来源色
    "hybrid":  {"bg": "#fce7f3", "border": "#db2777", "text": "#9d174d",
                "color": "#ec4899"},
}
```

---

## 3. 页面布局重构：对齐展示层

### 3.1 布局结构变更

**当前指标血缘 Tab 布局**（左右分栏）：
```
┌──────────────┬──────────────────────────────┐
│ 搜索面板      │                              │
│ (320px)      │     力导向图 (SVG)            │
│              │                              │
│ 流水线       │                              │
└──────────────┴──────────────────────────────┘
```

**目标布局**（对齐展示层：顶部查询栏 + 左侧详情 + 右侧图谱）：
```
┌──────────────────────────────────────────────┐
│  顶部查询栏 (指标编号 + 分类筛选 + 查询按钮)   │
├────────────┬─────────────────────────────────┤
│            │                                 │
│  详情面板   │     垂直分层图谱 (SVG)           │
│  (320px)   │     + 左侧层级标签               │
│            │     + 底部图例/缩放控制           │
│            │                                 │
├────────────┤                                 │
│  流水线     │                                 │
│  (折叠式)   │                                 │
└────────────┴─────────────────────────────────┘
```

### 3.2 HTML 结构变更

指标血缘 Tab 的 HTML 改为与展示层相同的 `display-layout` 结构：

```html
<section id="indicator-tab" class="tab-content">
    <div class="display-layout">
        <!-- 顶部：搜索与控制栏 -->
        <header class="query-header">
            <div class="query-inputs-row">
                <div class="input-group">
                    <label class="input-label">📈 指标编号</label>
                    <input type="text" id="indicatorSearchInput"
                           placeholder="如 FM0100011" autocomplete="off">
                    <div id="indicatorSearchResults"
                         class="search-results-dropdown" style="display:none;"></div>
                </div>
                <div class="input-group" style="min-width:140px;">
                    <label class="input-label">🏷️ 类型</label>
                    <select id="indicatorCategoryFilter"
                            style="width:100%;height:40px;padding:8px 12px;
                                   border:2px solid #e2e8f0;border-radius:6px;font-size:13px;">
                        <option value="all">全部类型</option>
                        <option value="gl">总账指标</option>
                        <option value="base">基础指标</option>
                        <option value="derived">衍生指标</option>
                        <option value="hybrid">混合指标</option>
                    </select>
                </div>
                <div class="input-group btn-group">
                    <label class="input-label">&nbsp;</label>
                    <button class="btn btn-primary query-btn"
                            onclick="searchIndicator()">🔍 查询血缘</button>
                </div>
            </div>
            <p style="margin-top:8px;color:#94a3b8;font-size:11px;text-align:center;">
                💡 输入指标编号查看血缘关系，系统自动识别指标类型并切换展示模式
            </p>
        </header>

        <!-- 下方：详情 + 图谱 -->
        <main class="content-area">
            <!-- 左侧：详情面板 -->
            <aside id="indicatorDetailPanel" class="detail-panel-sidebar" style="display:none;">
                <h3>📊 指标详情</h3>
                <div id="indicatorDetailContent" class="detail-content"></div>
                <!-- 加工流水线（折叠式） -->
                <div class="pipeline-section">
                    <h3 style="cursor:pointer;" onclick="togglePipeline()">⚙️ 加工流水线 ▾</h3>
                    <div id="indicatorPipeline" class="pipeline-container"
                         style="display:none;"></div>
                </div>
            </aside>

            <!-- 右侧：图谱区 -->
            <div class="graph-area">
                <svg id="indicatorSvg" class="graph-canvas"></svg>
                <div id="indicatorEmptyHint" class="empty-hint">
                    <div class="empty-icon">📈</div>
                    <p>输入指标编号查看血缘关系</p>
                </div>
                <div id="indicatorLoading" class="loading-indicator" style="display:none;">
                    <div class="spinner"></div>
                    <p>正在查询指标血缘...</p>
                </div>
                <div id="indicatorLegend" class="legend" style="display:none;"></div>
                <div id="indicatorZoomControls" class="zoom-controls" style="display:none;">
                    <button onclick="indicatorResetView()">重置</button>
                    <button onclick="indicatorZoomBy(1.4)">放大</button>
                    <button onclick="indicatorZoomBy(0.7)">缩小</button>
                    <button onclick="indicatorFitView()">适应</button>
                </div>
                <div id="indicatorInfoPanel" class="info-panel" style="display:none;">
                    <button class="close-btn" onclick="closeIndicatorInfoPanel()">×</button>
                    <h3 id="indicatorPanelTitle"></h3>
                    <div id="indicatorPanelContent"></div>
                </div>
            </div>
        </main>
    </div>
</section>
```

### 3.3 关键对齐点

| 对齐项 | 展示层实现 | 指标血缘层对齐方案 |
|-------|-----------|-----------------|
| 页面布局 | `display-layout` (flex column) | 复用 `display-layout` CSS 类 |
| 查询栏 | `query-header` + `query-inputs-row` | 复用相同 CSS 类 |
| 详情面板 | `detail-panel-sidebar` (320px) | 复用相同 CSS 类 |
| 图谱区 | `graph-area` + `graph-canvas` | 复用相同 CSS 类 |
| 空状态 | `empty-hint` | 复用相同 CSS 类 |
| 加载状态 | `loading-indicator` + `spinner` | 复用相同 CSS 类 |
| 图例 | `legend` | 复用相同 CSS 类 |
| 缩放控制 | `zoom-controls` | 复用相同 CSS 类 |
| 信息浮窗 | `info-panel` | 复用相同 CSS 类 |
| 节点样式 | 240×72 圆角矩形 + 三行信息 | 采用相同尺寸和信息密度 |
| 连线样式 | 贝塞尔曲线 + 箭头 marker | 复用相同 SVG marker 定义 |
| 层级标签 | 左侧彩色背景条 + 层级名称 | 复用相同渲染逻辑 |

---

## 4. 数据模型变更

### 4.1 IndicatorLineageNode 新增字段

```python
@dataclass
class IndicatorLineageNode:
    node_id: str = ""
    node_type: Literal["indicator", "measure", "table", "field", "procedure"] = "indicator"
    index_no: str = ""
    index_measure: str = ""
    index_type: str = ""
    algo_type: str = ""
    label: str = ""
    layer: str = ""
    brch_type: str = ""
    detail: dict = field(default_factory=dict)
    indicator_category: Literal["gl", "base", "derived", "hybrid", ""] = ""
```

### 4.2 IndicatorLineageResult 新增分类信息

```python
@dataclass
class IndicatorLineageResult:
    target_index_no: str = ""
    target_measure: str = ""
    graph: IndicatorLineageGraph = field(default_factory=IndicatorLineageGraph)
    chains: list[IndicatorChain] = field(default_factory=list)
    query_time_ms: float = 0.0
    indicator_category: str = ""
    category_label: str = ""
```

### 4.3 搜索结果增强

搜索 API 返回结果新增 `indicator_category` 和 `category_label` 字段。

---

## 5. 后端变更

### 5.1 IndicatorGraphBuilder 变更

#### 5.1.1 新增分类索引

```python
class IndicatorGraphBuilder:
    def __init__(self, config_result: IndicatorConfigResult) -> None:
        # ... 现有字段 ...
        self._category_idx: dict[str, str] = {}

    def _build_indexes(self) -> None:
        for c in self.config.base_calcs:
            self._base_calc_idx.setdefault(c.index_no, []).append(c)
        for c in self.config.gl_calcs:
            self._gl_calc_idx.setdefault(c.index_no, []).append(c)
        for r in self.config.relations:
            self._rel_idx[r.index_no] = r
        self._build_category_index()

    def _build_category_index(self) -> None:
        all_index_nos = set(self._base_calc_idx) | set(self._gl_calc_idx)
        for rel in self.config.relations:
            all_index_nos.add(rel.index_no)
            all_index_nos.update(rel.depend_index_nos)

        for index_no in all_index_nos:
            has_base = index_no in self._base_calc_idx
            has_gl = index_no in self._gl_calc_idx
            is_derived = index_no in self._rel_idx

            if has_base and has_gl:
                self._category_idx[index_no] = "hybrid"
            elif has_gl:
                self._category_idx[index_no] = "gl"
            elif is_derived and not has_base:
                self._category_idx[index_no] = "derived"
            else:
                self._category_idx[index_no] = "base"
```

#### 5.1.2 节点构建时打标

`_build_gl_nodes` 和 `_build_base_nodes` 中创建 indicator 节点时，写入 `indicator_category`。

#### 5.1.3 trace_indicator 返回分类信息

```python
def trace_indicator(self, index_no, measure="", direction="upstream", max_depth=10):
    # ... 现有逻辑 ...
    category = self._category_idx.get(index_no, "base")
    return IndicatorLineageResult(
        target_index_no=index_no,
        target_measure=measure,
        graph=sub_graph,
        chains=chains,
        query_time_ms=elapsed,
        indicator_category=category,
        category_label=INDICATOR_CATEGORY_LABELS.get(category, category),
    )
```

### 5.2 IndicatorService 变更

序列化方法增加 `indicator_category` 和 `category_label` 输出（同 v1.0 方案）。

### 5.3 API 变更

#### 5.3.1 血缘查询 API 新增参数

```python
@router.get("/lineage", summary="查询指标血缘图")
def get_indicator_lineage(
    index_no: Annotated[str, Query(min_length=1, description="指标编号")],
    measure: Annotated[str, Query(description="指标度量(可选)")] = "",
    direction: Annotated[str, Query(description="查询方向")] = "upstream",
    depth: Annotated[int, Query(ge=1, le=20, description="追溯深度")] = 10,
    view_mode: Annotated[str, Query(description="展示模式: auto/gl/base")] = "auto",
    service: IndicatorServiceDep = None,
) -> dict:
    ...
```

#### 5.3.2 搜索 API 新增分类筛选

```python
@router.get("/search", summary="搜索指标")
def search_indicators(
    keyword: Annotated[str, Query(min_length=1, description="搜索关键词")],
    limit: Annotated[int, Query(ge=1, le=500, description="返回数量限制")] = 50,
    category: Annotated[str, Query(description="分类筛选: gl/base/derived/hybrid")] = "",
    service: IndicatorServiceDep = None,
) -> dict:
    ...
```

#### 5.3.3 新增分类统计 API

```python
@router.get("/category-stats", summary="获取指标分类统计")
def get_indicator_category_stats(service: IndicatorServiceDep) -> dict:
    ...
```

---

## 6. 总账指标展示模式 (GL Mode)

### 6.1 展示形态：垂直分层布局（对齐展示层）

总账指标采用与展示层完全一致的**垂直分层布局**，基于 BFS 深度分层：

```
┌─────────────────────────────────────────────────────────────────┐
│  顶部查询栏: [指标编号 FM0100011] [类型: 总账] [查询血缘]         │
├──────────┬──────────────────────────────────────────────────────┤
│          │  ┌─────┐                                            │
│  指标详情 │  │ 目标 │  FM0100011                                │
│  ──────  │  └──┬──┘                                            │
│  类型:总账 │     │                                              │
│  度量:    │  ┌──┴──────────────────┐                           │
│  001期末余额│  │ 第1层  001[期末借方余额]  │                    │
│  002月日均 │  │       002[月日均]      │                        │
│          │  └──┬──────────────────┘                            │
│  科目映射: │     │ gl_mapping                                    │
│  2011借方 │  ┌──┴──────────────────────────────────────────┐  │
│  ×期末余额 │  │ 第2层  科目2011(4位) 借方×期末余额           │  │
│          │  │       科目2012(4位) 贷方×发生额             │  │
│  ──────  │  └──┬──────────────────────────────────────────┘  │
│  流水线   │     │                                              │
│  STEP1 ✓ │  ┌──┴──────────────────────┐                      │
│  STEP2 - │  │ 第3层  FML_IDX_ADM_GL_INFO │                    │
│  STEP3 ✓ │  └─────────────────────────┘                      │
│  STEP4 - │                                                      │
└──────────┴──────────────────────────────────────────────────────┘
```

### 6.2 节点样式（对齐展示层 240×72 圆角矩形）

所有节点统一使用展示层的圆角矩形样式，三行信息布局：

| 层级 | 节点类型 | 第1行 | 第2行 | 第3行 | 颜色方案 |
|------|---------|------|------|------|---------|
| L0 (目标) | 指标 | [FDL_IDX] | FM0100011 | 度量: 001 | 红色填充 #ef4444 (对齐展示层目标表) |
| L1 | 度量 | [FDL_IDX] | 001[期末借方余额] | 总账取数 | 橙色边框 #f59e0b (对齐展示层第1层) |
| L2 | 科目 | [IML] | 科目2011(4位) | 借方×期末余额 | 蓝色边框 #3b82f6 (对齐展示层第2层) |
| L3 | 科目表 | [IML] | FML_IDX_ADM_GL_INFO | | 绿色边框 #10b981 (对齐展示层第4层) |

### 6.3 左侧层级标签

复用展示层的左侧层级标签渲染逻辑：

```javascript
const GL_DEPTH_CONFIG = [
    { color: '#ef4444', border: '#dc2626', bg: '#fef2f2', label: '目标' },
    { color: '#f59e0b', border: '#d97706', bg: '#fffbeb', label: '度量' },
    { color: '#3b82f6', border: '#2563eb', bg: '#eff6ff', label: '科目' },
    { color: '#10b981', border: '#059669', bg: '#ecfdf5', label: '来源' },
];
```

### 6.4 连线样式

复用展示层的贝塞尔曲线 + 箭头 marker：

```javascript
// 与展示层完全一致的连线渲染
const midY = (y1 + y2) / 2;
const path = `M${x1},${y1} C${x1},${midY} ${x2},${midY} ${x2},${y2}`;

g.append('path')
    .attr('d', path)
    .attr('class', 'link-line')
    .attr('fill', 'none')
    .attr('stroke', isQueryNode ? '#6366f1' : '#94a3b8')
    .attr('stroke-width', isQueryNode ? 2 : 1.2)
    .attr('opacity', isQueryNode ? 0.85 : 0.65)
    .attr('marker-end', isQueryNode ? 'url(#arrow-query)' : 'url(#arrow)');
```

### 6.5 科目映射详情

科目映射信息在左侧详情面板中展示（而非独立卡片），与展示层的字段映射列表风格一致：

```html
<h4 style="color:#f59e0b;margin:16px 0 8px;font-size:13px;">
    📋 科目映射 (3 条)
</h4>
<div style="max-height:280px;overflow-y:auto;background:#fafafa;
            border-radius:8px;padding:10px;border:1px solid #e2e8f0;">
    <div style="padding:7px 10px;margin-bottom:4px;background:white;
                border-radius:5px;font-size:11px;border-left:3px solid #f59e0b;">
        <span style="color:#92400e;font-weight:500;">科目2011(4位)</span>
        <span style="color:#94a3b8;margin:0 6px;">→</span>
        <span style="color:#dc2626;font-weight:500;">借方 × 期末借方余额</span>
    </div>
    ...
</div>
```

### 6.6 交互行为

| 操作 | 行为 | 对齐展示层 |
|------|------|-----------|
| 点击指标节点 | 弹出 infoPanel 浮窗，展示指标详情 | ✅ 与展示层 showInfoPanel 一致 |
| 点击度量节点 | 弹出 infoPanel，展示度量配置和科目映射 | ✅ |
| 点击科目节点 | 弹出 infoPanel，展示匹配规则和转换逻辑 | ✅ |
| 点击科目表节点 | 弹出 infoPanel，展示表信息 | ✅ |
| 悬停节点 | 节点透明度变化 | ✅ 与展示层一致 |
| 缩放/平移 | D3 zoom 控制 | ✅ 复用展示层缩放逻辑 |

---

## 7. 基础指标展示模式 (Base Mode)

### 7.1 展示形态：垂直分层布局（对齐展示层）

基础指标同样采用垂直分层布局，但层级语义不同：

```
┌─────────────────────────────────────────────────────────────────┐
│  顶部查询栏: [指标编号 FM005678] [类型: 基础] [查询血缘]         │
├──────────┬──────────────────────────────────────────────────────┤
│          │  ┌─────┐                                            │
│  指标详情 │  │ 目标 │  FM005678                                │
│  ──────  │  └──┬──┘                                            │
│  类型:基础 │     │                                              │
│  度量:    │  ┌──┴──────────────────┐                           │
│  001期末余额│  │ 第1层  001[期末借方余额]  │ 通用算法            │
│          │  └──┬──────────────────┘                            │
│  SQL详情: │     │ data_flow                                     │
│  度量SQL: │  ┌──┴──────────────────────────────────────────┐  │
│  SUM(...) │  │ 第2层  B_LOAN_INFO        🔗穿透             │  │
│          │  │       B_DEPOSIT_INFO     🔗穿透             │  │
│  条件SQL: │  └─────────────────────────────────────────────┘  │
│  WHERE... │                                                      │
│          │                                                      │
│  ──────  │                                                      │
│  流水线   │                                                      │
│  STEP1 - │                                                      │
│  STEP2 ✓ │                                                      │
│  STEP3 ✓ │                                                      │
│  STEP4 - │                                                      │
└──────────┴──────────────────────────────────────────────────────┘
```

### 7.2 节点样式（对齐展示层）

| 层级 | 节点类型 | 第1行 | 第2行 | 第3行 | 颜色方案 |
|------|---------|------|------|------|---------|
| L0 (目标) | 指标 | [FDL_IDX] | FM005678 | 度量: 001 | 红色填充 #ef4444 |
| L1 | 度量 | [FDL_IDX] | 001[期末借方余额] | 通用算法 | 橙色边框 #f59e0b |
| L2 | 源表 | [IML] | B_LOAN_INFO | 🔗 穿透 | 蓝色边框 #3b82f6 |
| L2 | 衍生指标 | [FDL_IDX] | FM009999 | 依赖: FM001,FM002 | 紫色边框 #8b5cf6 |

### 7.3 源表穿透入口

源表节点第3行显示「🔗 穿透」标记，点击后：

1. 弹出 infoPanel 浮窗，展示源表基本信息
2. 浮窗底部提供「🔗 穿透到字段血缘」按钮
3. 点击穿透按钮后，调用 `/api/indicator/bridge-lineage` 获取字段血缘
4. 在 infoPanel 内嵌展示字段血缘映射列表（与展示层 detailPanel 中的字段映射列表风格一致）
5. 提供「展开完整血缘 → 切换到展示层」链接

### 7.4 SQL 详情展示

SQL 信息在左侧详情面板中展示，采用与展示层字段映射列表相同的风格：

```html
<h4 style="color:#6366f1;margin:16px 0 8px;font-size:13px;">
    📝 SQL 详情
</h4>
<div style="padding:10px;background:#fafafa;border-radius:8px;
            border:1px solid #e2e8f0;font-size:12px;">
    <div style="margin-bottom:8px;">
        <span style="color:#64748b;font-weight:600;">度量SQL</span><br>
        <code style="font-family:monospace;color:#1e293b;">SUM(loan_amt)</code>
    </div>
    <div style="margin-bottom:8px;">
        <span style="color:#64748b;font-weight:600;">条件SQL</span><br>
        <code style="font-family:monospace;color:#1e293b;">WHERE status='01'</code>
    </div>
    <div>
        <span style="color:#64748b;font-weight:600;">完整SQL</span><br>
        <pre style="background:#1e293b;color:#e2e8f0;padding:8px;
                    border-radius:4px;font-size:11px;overflow-x:auto;
                    white-space:pre-wrap;">INSERT INTO FDL_IDX_...
SELECT SUM(loan_amt)
FROM B_LOAN_INFO
WHERE status='01'</pre>
    </div>
</div>
```

### 7.5 交互行为

| 操作 | 行为 | 对齐展示层 |
|------|------|-----------|
| 点击指标节点 | 弹出 infoPanel，展示指标详情 | ✅ |
| 点击度量节点 | 弹出 infoPanel，展示 SQL 详情 | ✅ |
| 点击源表节点 | 弹出 infoPanel，含穿透按钮 | ✅ |
| 点击穿透按钮 | infoPanel 内嵌字段血缘 | ✅ |
| 点击衍生指标 | 跳转到该指标的血缘查询 | ✅ |
| 悬停边 | 显示 transform_logic tooltip | ✅ |

---

## 8. 混合指标展示模式 (Hybrid Mode)

### 8.1 展示形态

混合指标在顶部查询栏下方增加 Tab 切换条：

```
┌─────────────────────────────────────────────────────────────────┐
│  顶部查询栏: [指标编号 FM007777] [类型: 混合] [查询血缘]         │
│  [总账链路]  [基础链路]     ← Tab 切换条                        │
├──────────┬──────────────────────────────────────────────────────┤
│          │                                                      │
│  (当前 Tab 对应的展示模式)                                        │
│          │                                                      │
└──────────┴──────────────────────────────────────────────────────┘
```

### 8.2 切换逻辑

- 默认展示总账链路
- Tab 切换时，重新调用 `/api/indicator/lineage` 并指定 `view_mode`
- 两个 Tab 的渲染分别复用 GL Mode 和 Base Mode 的渲染函数

---

## 9. 衍生指标展示模式 (Derived Mode)

### 9.1 展示形态：垂直分层布局

衍生指标同样使用垂直分层布局，目标指标在 L0，上游依赖指标在 L1：

```
┌─────────────────────────────────────────────────────────────────┐
│  顶部查询栏: [指标编号 FM009999] [类型: 衍生] [查询血缘]         │
├──────────┬──────────────────────────────────────────────────────┤
│          │  ┌─────┐                                            │
│  指标详情 │  │ 目标 │  FM009999                                │
│  ──────  │  └──┬──┘                                            │
│  类型:衍生 │     │ calc_dependency                              │
│  算法:自定义│  ┌──┴──────────────────────────────────────────┐  │
│          │  │ 第1层  FM001  FM002  FM003                     │  │
│  依赖:    │  │       基础   基础   总账                       │  │
│  FM001    │  └──────────────────────────────────────────────┘  │
│  FM002    │                                                      │
│  FM003    │                                                      │
└──────────┴──────────────────────────────────────────────────────┘
```

### 9.2 交互行为

- 点击上游指标节点：弹出 infoPanel，提供「查看该指标血缘」按钮
- 点击边：弹出 infoPanel，展示衍生计算逻辑

---

## 10. 前端架构变更

### 10.1 模块结构

```
static/js/
├── indicator-tab.js              # 主入口 (改造)
├── indicator-gl-renderer.js      # 新增：总账指标渲染器
├── indicator-base-renderer.js    # 新增：基础指标渲染器
├── indicator-derived-renderer.js # 新增：衍生指标渲染器
└── indicator-common.js           # 新增：共享工具函数 (BFS深度计算、节点绘制、连线绘制)
```

### 10.2 indicator-common.js 共享逻辑

从展示层 `lineage-graph.js` 中抽取可复用的渲染逻辑：

```javascript
const IndicatorCommon = {
    NODE_W: 240,
    NODE_H: 72,
    LAYER_GAP: 80,
    NODE_GAP_X: 30,
    LEFT_MARGIN: 96,

    DEPTH_CONFIGS: [
        { color: '#ef4444', border: '#dc2626', bg: '#fef2f2', label: '目标' },
        { color: '#f59e0b', border: '#d97706', bg: '#fffbeb', label: '第1层' },
        { color: '#3b82f6', border: '#2563eb', bg: '#eff6ff', label: '第2层' },
        { color: '#8b5cf6', border: '#7c3aed', bg: '#f5f3ff', label: '第3层' },
        { color: '#10b981', border: '#059669', bg: '#ecfdf5', label: '第4层' },
        { color: '#6b7280', border: '#4b5563', bg: '#f9fafb', label: '更深层' },
    ],

    calculateNodeDepths(nodes, edges, targetId) { ... },
    renderLayerLabels(g, layers, layerBounds) { ... },
    renderEdges(g, edges, positions, currentQuery) { ... },
    renderNode(g, node, pos, isQueryTarget, config) { ... },
    fitView(svg, g, container) { ... },
};
```

### 10.3 indicator-tab.js 改造

```javascript
window.selectIndicator = async function(indexNo) {
    currentIndicator = indexNo;
    showIndicatorLoading(true);

    try {
        const [detailRes, lineageRes] = await Promise.all([
            fetch(`${API_BASE}/detail?index_no=${indexNo}`).then(r => r.json()),
            fetch(`${API_BASE}/lineage?index_no=${indexNo}&direction=upstream&depth=5`).then(r => r.json()),
        ]);

        const detail = detailRes.success ? detailRes.data : {};
        const lineage = lineageRes.success ? lineageRes.data : null;
        const category = lineage?.indicator_category || detail.indicator_category || "base";

        renderByCategory(category, lineage, detail);

    } catch (error) {
        showIndicatorMessage('加载指标详情失败: ' + error.message);
    } finally {
        showIndicatorLoading(false);
    }
};

function renderByCategory(category, lineageData, detail) {
    switch (category) {
        case "gl":      renderGLLineage(lineageData, detail); break;
        case "base":    renderBaseLineage(lineageData, detail); break;
        case "hybrid":  renderHybridLineage(lineageData, detail); break;
        case "derived": renderDerivedLineage(lineageData, detail); break;
        default:        renderBaseLineage(lineageData, detail);
    }
}
```

### 10.4 搜索结果增强

搜索结果列表中，每个指标项显示分类标签和颜色标识，使用与展示层搜索结果相同的下拉列表样式：

```javascript
function renderIndicatorSearchResults(results) {
    const container = document.getElementById('indicatorSearchResults');
    container.innerHTML = '';

    results.forEach(item => {
        const cat = item.indicator_category || item.source_type || 'base';
        const catLabel = item.category_label || (cat === 'gl' ? '总账' : '基础');
        const catColors = INDICATOR_CATEGORY_COLORS[cat] || INDICATOR_CATEGORY_COLORS.base;

        const div = document.createElement('div');
        div.className = 'search-result-item';
        div.innerHTML = `
            <div class="result-name">
                <span style="color:${catColors.text};font-weight:600;">${item.index_no}</span>
            </div>
            <div class="result-type">
                <span style="background:${catColors.bg};color:${catColors.text};
                             border:1px solid ${catColors.border};
                             padding:1px 6px;border-radius:3px;font-size:10px;font-weight:600;">
                    ${catLabel}
                </span>
                · 度量 ${item.measures.length} 个
                ${item.is_derived ? ' · 衍生' : ''}
            </div>
        `;
        div.onclick = () => {
            document.getElementById('indicatorSearchInput').value = item.index_no;
            document.getElementById('indicatorSearchResults').style.display = 'none';
            selectIndicator(item.index_no);
        };
        container.appendChild(div);
    });
}
```

---

## 11. API 接口变更汇总

### 11.1 变更接口

| 接口 | 变更内容 |
|------|---------|
| `GET /api/indicator/search` | 新增 `category` 查询参数；返回结果新增 `indicator_category`、`category_label` 字段 |
| `GET /api/indicator/lineage` | 新增 `view_mode` 查询参数；返回结果新增 `indicator_category`、`category_label` 字段；graph.nodes 新增 `indicator_category` 字段 |
| `GET /api/indicator/detail` | 返回结果新增 `indicator_category`、`category_label` 字段 |

### 11.2 新增接口

| 接口 | 说明 |
|------|------|
| `GET /api/indicator/category-stats` | 返回各分类指标数量统计 |

---

## 12. 实施计划

### Phase 1: 后端分类打标 (优先级: 高)

1. `indicator_models.py` 新增 `indicator_category` 字段
2. `indicator_graph_builder.py` 新增 `_build_category_index()` 方法
3. `indicator_service.py` 序列化方法增加分类字段输出
4. `indicator.py` API 路由新增 `category` 和 `view_mode` 参数
5. 新增 `/api/indicator/category-stats` 接口

### Phase 2: 页面布局重构 (优先级: 高)

1. 修改 `index.html` 指标血缘 Tab 的 HTML 结构，对齐展示层布局
2. 删除旧的 `.indicator-layout` / `.indicator-left-panel` / `.indicator-right-panel` CSS
3. 复用展示层的 `.display-layout` / `.query-header` / `.content-area` / `.graph-area` CSS
4. 新增指标血缘特有的 CSS（分类标签色、穿透按钮样式等）

### Phase 3: 共享渲染逻辑抽取 (优先级: 高)

1. 新建 `indicator-common.js`，从展示层抽取 BFS 深度计算、节点绘制、连线绘制、层级标签绘制
2. 初始化指标血缘 SVG 画布（复用展示层的 marker 定义、zoom 配置）

### Phase 4: 总账指标展示模式 (优先级: 高)

1. 新建 `indicator-gl-renderer.js`，基于 `indicator-common.js` 实现垂直分层布局
2. 实现科目映射详情（在左侧详情面板中展示）
3. 改造 `indicator-tab.js`，根据 `indicator_category` 自动路由到 GL 渲染器

### Phase 5: 基础指标展示模式 (优先级: 高)

1. 新建 `indicator-base-renderer.js`，基于 `indicator-common.js` 实现垂直分层布局
2. 实现 SQL 详情展示（在左侧详情面板中展示）
3. 实现源表穿透按钮和 infoPanel 内嵌字段血缘
4. 实现衍生指标跳转

### Phase 6: 混合/衍生模式 + 筛选器 (优先级: 中)

1. 新建 `indicator-derived-renderer.js`
2. 实现混合指标 Tab 切换
3. 搜索栏增加分类筛选下拉框

### Phase 7: 测试与优化 (优先级: 中)

1. 单元测试：分类判定逻辑、API 参数校验
2. 集成测试：端到端血缘查询 + 分类展示
3. 性能优化：大量科目映射时的渲染性能
4. 交互优化：动画过渡、加载状态

---

## 13. 风险与应对

| 风险 | 影响 | 应对措施 |
|------|------|---------|
| 布局重构影响现有功能 | 指标血缘 Tab 现有功能暂时不可用 | 分阶段实施，Phase 2 完成后立即进入 Phase 3/4 |
| 共享逻辑抽取可能引入回归 | 展示层渲染受影响 | `indicator-common.js` 仅复制不修改展示层代码，两套独立维护 |
| 总账指标科目映射数量过多（>50条） | 垂直布局节点过多 | 同层节点水平排列（复用展示层的 nodesPerRow 换行逻辑） |
| 基础指标 SQL 模板过长 | 详情面板溢出 | SQL 代码折叠，点击展开 |
| 衍生指标递归追溯深度过大 | 图谱节点爆炸 | 限制追溯深度 max_depth=5 |

---

## 14. 兼容性说明

- 所有 API 变更**向后兼容**：新增字段不影响现有调用方
- `view_mode=auto` 为默认值，行为等价于当前逻辑 + 自动分类
- 搜索 API 的 `category` 参数为可选，不传时返回全部结果
- 前端渲染器通过 `indicator_category` 字段自动路由，无需前端硬编码指标类型
- 展示层代码**不做任何修改**，`indicator-common.js` 是独立复制+适配

---

## 15. v2.0 与 v1.0 方案差异总结

| 变更项 | v1.0 方案 | v2.0 方案 | 变更原因 |
|-------|----------|----------|---------|
| 页面布局 | 左右分栏 (搜索+图谱) | 顶部查询栏+左侧详情+右侧图谱 | 对齐展示层布局 |
| 图谱布局 | GL用tree layout, Base用DAG/dagre | 统一使用BFS深度分层垂直布局 | 对齐展示层渲染风格 |
| 节点样式 | GL用圆/菱形, Base用圆角矩形 | 统一240×72圆角矩形三行信息 | 对齐展示层节点样式 |
| 连线样式 | GL用直线, Base用实线/虚线 | 统一贝塞尔曲线+箭头marker | 对齐展示层连线风格 |
| 科目映射 | 独立卡片组件 | 左侧详情面板内展示 | 对齐展示层详情面板风格 |
| SQL详情 | 侧边固定面板 | 左侧详情面板内展示 | 对齐展示层详情面板风格 |
| 穿透交互 | 内嵌子图 | infoPanel内嵌字段映射列表 | 对齐展示层infoPanel交互 |
| 层级标签 | 无 | 左侧彩色背景条+层级名称 | 对齐展示层层级标签 |
| 缩放控制 | 无 | 底部缩放按钮组 | 对齐展示层缩放控制 |
| 图例 | 无 | 底部图例 | 对齐展示层图例 |
| CSS复用 | 独立CSS | 复用展示层CSS类 | 减少样式差异 |
| JS模块 | 4个独立渲染器 | 4个渲染器+1个共享common | 抽取展示层可复用逻辑 |
