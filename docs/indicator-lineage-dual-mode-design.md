# 财务集市指标血缘双模式展示设计方案

> 版本: v1.0 | 日期: 2026-05-19
> 模型: Claude (SOLO) | 上下文: 200K tokens

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

### 1.3 设计目标

1. **总账指标**：展示清晰的「科目→度量→指标」层级链路，突出科目映射规则
2. **基础指标**：展示完整的「源表→SQL→度量→指标」加工逻辑，支持穿透到字段血缘
3. **自动识别**：解析阶段对指标打标，前端根据类型自动切换展示模式
4. **平滑过渡**：同一指标可能同时有总账和基础配置（混合指标），需支持双模式共存

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

### 2.3 分类标签映射

```python
INDICATOR_CATEGORY_LABELS: dict[str, str] = {
    "gl": "总账指标",
    "base": "基础指标",
    "derived": "衍生指标",
    "hybrid": "混合指标",
}

INDICATOR_CATEGORY_COLORS: dict[str, dict] = {
    "gl":      {"bg": "#fef3c7", "border": "#d97706", "text": "#92400e"},
    "base":    {"bg": "#dbeafe", "border": "#2563eb", "text": "#1e40af"},
    "derived": {"bg": "#ede9fe", "border": "#7c3aed", "text": "#5b21b6"},
    "hybrid":  {"bg": "#fce7f3", "border": "#db2777", "text": "#9d174d"},
}
```

---

## 3. 数据模型变更

### 3.1 IndicatorLineageNode 新增字段

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
    # ===== 新增字段 =====
    indicator_category: Literal["gl", "base", "derived", "hybrid", ""] = ""
```

### 3.2 IndicatorLineageGraph 新增统计

```python
@dataclass
class IndicatorLineageGraph:
    nodes: list[IndicatorLineageNode] = field(default_factory=list)
    edges: list[IndicatorLineageEdge] = field(default_factory=list)
    stats: dict = field(default_factory=dict)

    @property
    def category_counts(self) -> dict[str, int]:
        counts: dict[str, int] = {}
        for n in self.nodes:
            if n.node_type == "indicator" and n.indicator_category:
                cat = n.indicator_category
                counts[cat] = counts.get(cat, 0) + 1
        return counts
```

### 3.3 IndicatorLineageResult 新增分类信息

```python
@dataclass
class IndicatorLineageResult:
    target_index_no: str = ""
    target_measure: str = ""
    graph: IndicatorLineageGraph = field(default_factory=IndicatorLineageGraph)
    chains: list[IndicatorChain] = field(default_factory=list)
    query_time_ms: float = 0.0
    # ===== 新增字段 =====
    indicator_category: str = ""
    category_label: str = ""
```

### 3.4 搜索结果增强

搜索 API 返回结果新增 `indicator_category` 字段：

```python
{
    "index_no": "I001234",
    "measures": ["001", "002"],
    "source_type": "gl",           # 保留兼容
    "indicator_category": "gl",    # 新增：标准分类
    "category_label": "总账指标",   # 新增：中文标签
    "is_derived": False,
}
```

---

## 4. 后端变更

### 4.1 IndicatorGraphBuilder 变更

#### 4.1.1 新增分类索引

```python
class IndicatorGraphBuilder:
    def __init__(self, config_result: IndicatorConfigResult) -> None:
        # ... 现有字段 ...
        self._category_idx: dict[str, str] = {}  # index_no -> category

    def _build_indexes(self) -> None:
        for c in self.config.base_calcs:
            self._base_calc_idx.setdefault(c.index_no, []).append(c)
        for c in self.config.gl_calcs:
            self._gl_calc_idx.setdefault(c.index_no, []).append(c)
        for r in self.config.relations:
            self._rel_idx[r.index_no] = r
        # 新增：构建分类索引
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

#### 4.1.2 节点构建时打标

`_build_gl_nodes` 和 `_build_base_nodes` 中创建 indicator 节点时，写入 `indicator_category`：

```python
def _build_gl_nodes(self) -> None:
    for index_no, calcs in self._gl_calc_idx.items():
        indicator_node_id = f"IND_{index_no}"
        category = self._category_idx.get(index_no, "gl")
        self._ensure_node(
            indicator_node_id, "indicator",
            index_no=index_no,
            label=index_no,
            layer="FDL_IDX",
            indicator_category=category,  # 新增
        )
        # ... 其余逻辑不变 ...
```

#### 4.1.3 trace_indicator 返回分类信息

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

#### 4.1.4 新增按分类过滤的追溯方法

```python
def trace_indicator_by_category(
    self,
    index_no: str,
    measure: str = "",
    direction: str = "upstream",
    max_depth: int = 10,
) -> dict[str, Any]:
    """按指标分类返回差异化血缘结果"""
    category = self._category_idx.get(index_no, "base")
    result = self.trace_indicator(index_no, measure, direction, max_depth)

    if category == "gl":
        return self._format_gl_lineage(result, index_no, measure)
    elif category == "base":
        return self._format_base_lineage(result, index_no, measure)
    elif category == "hybrid":
        return self._format_hybrid_lineage(result, index_no, measure)
    else:
        return self._format_derived_lineage(result, index_no, measure)
```

### 4.2 IndicatorService 变更

#### 4.2.1 序列化增强

```python
def _serialize_result(self, result) -> dict[str, Any]:
    return {
        "target_index_no": result.target_index_no,
        "target_measure": result.target_measure,
        "measure_label": result.measure_label,
        "indicator_category": result.indicator_category,      # 新增
        "category_label": result.category_label,              # 新增
        "chain_count": result.chain_count,
        "max_depth": result.max_depth,
        "query_time_ms": result.query_time_ms,
        "graph": self._serialize_graph(result.graph),
        "chains": [self._serialize_chain(c) for c in result.chains],
    }

def _serialize_graph(self, graph) -> dict[str, Any]:
    nodes = [
        {
            "id": n.node_id,
            "type": n.node_type,
            "label": n.display_label,
            "index_no": n.index_no,
            "index_measure": n.index_measure,
            "index_type": n.index_type,
            "algo_type": n.algo_type,
            "layer": n.layer,
            "brch_type": n.brch_type,
            "detail": n.detail,
            "indicator_category": n.indicator_category,  # 新增
        }
        for n in graph.nodes
    ]
    # ... 其余不变 ...
```

### 4.3 API 变更

#### 4.3.1 血缘查询 API 新增参数

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
    """
    view_mode 参数:
    - auto: 根据指标类型自动选择展示模式 (默认)
    - gl:   强制使用总账指标展示模式
    - base: 强制使用基础指标展示模式
    """
    # ...
```

#### 4.3.2 搜索 API 返回分类信息

搜索结果中每个 item 新增 `indicator_category` 和 `category_label` 字段（见 3.4 节）。

#### 4.3.3 新增分类统计 API

```python
@router.get("/category-stats", summary="获取指标分类统计")
def get_indicator_category_stats(
    service: IndicatorServiceDep,
) -> dict:
    stats = service.get_stats()
    return {
        "success": True,
        "data": {
            "category_counts": stats.get("category_counts", {}),
            "total_indicators": stats.get("unique_index_count", 0),
        },
    }
```

---

## 5. 总账指标展示模式 (GL Mode)

### 5.1 展示形态：层级树 + 科目映射卡片

总账指标的加工链路天然是线性的层级结构，采用**自底向上的层级树**展示：

```
┌─────────────────────────────────────────────────────────┐
│  总账指标血缘 · GL Mode                                  │
│                                                         │
│  ┌──────────┐                                           │
│  │ 指标节点  │  I001234                                  │
│  └────┬─────┘                                           │
│       │                                                 │
│  ┌────┴──────────────────────────┐                      │
│  │ 度量节点  001[期末借方余额]     │                      │
│  │           002[月日均]          │                      │
│  └────┬──────────────────────────┘                      │
│       │ gl_mapping                                      │
│  ┌────┴────────────────────────────────────────────┐    │
│  │ 科目映射卡片                                      │    │
│  │ ┌─────────────────────────────────────────────┐ │    │
│  │ │ 科目 2011(4位)  借方 × 期末借方余额          │ │    │
│  │ │ substr(subj_no,1,4)='2011' → sign(1)×bal   │ │    │
│  │ └─────────────────────────────────────────────┘ │    │
│  │ ┌─────────────────────────────────────────────┐ │    │
│  │ │ 科目 2012(4位)  贷方 × 借方发生额            │ │    │
│  │ │ substr(subj_no,1,4)='2012' → sign(-1)×amt  │ │    │
│  │ └─────────────────────────────────────────────┘ │    │
│  └─────────────────────────────────────────────────┘    │
│       │                                                 │
│  ┌────┴─────────────┐                                   │
│  │ FML_IDX_ADM_GL_INFO│  (总账科目表)                    │
│  └──────────────────┘                                   │
└─────────────────────────────────────────────────────────┘
```

### 5.2 前端渲染逻辑

```javascript
function renderGLLineage(graphData, detail) {
    const container = document.getElementById('indicatorGraphContainer');
    container.innerHTML = '';

    // 1. 构建层级数据
    const indicatorNode = graphData.nodes.find(n => n.type === 'indicator');
    const measureNodes = graphData.nodes.filter(n => n.type === 'measure');
    const subjectNodes = graphData.nodes.filter(n => n.type === 'field');
    const sourceTable = graphData.nodes.find(n => n.type === 'table');

    // 2. 渲染层级树 (自顶向下)
    const tree = buildGLTree(indicatorNode, measureNodes, subjectNodes, sourceTable, graphData.edges);
    renderTreeLayout(tree, container);

    // 3. 科目映射卡片
    if (detail.gl_mappings && detail.gl_mappings.length > 0) {
        renderGLMappingCards(detail.gl_mappings, container);
    }
}
```

### 5.3 层级树布局参数

| 层级 | 节点类型 | 形状 | 颜色 | 尺寸 |
|------|---------|------|------|------|
| L0 | 指标 (indicator) | 圆角矩形 | 蓝色 #3b82f6 | 160×48 |
| L1 | 度量 (measure) | 圆角矩形 | 紫色 #8b5cf6 | 200×40 |
| L2 | 科目 (field) | 菱形 | 琥珀色 #f59e0b | 180×36 |
| L3 | 科目表 (table) | 矩形 | 绿色 #10b981 | 220×40 |

层间距: 100px，节点间距: 20px，使用 D3 tree layout 而非 force layout。

### 5.4 科目映射卡片

每个科目映射渲染为独立卡片，展示：

```
┌──────────────────────────────────────────┐
│ 📋 科目 2011 (4位匹配)                    │
│                                          │
│ 匹配规则:  substr(subj_no,1,4)='2011'    │
│ 转换逻辑:  sign(1) × term_end_dr_bal     │
│ 方向:      借方                           │
│ 金额类型:  期末借方余额                    │
│ 关联度量:  001[原始统计值(期末余额)]        │
└──────────────────────────────────────────┘
```

### 5.5 交互行为

| 操作 | 行为 |
|------|------|
| 点击指标节点 | 展开所有度量，高亮链路 |
| 点击度量节点 | 展开该度量关联的科目映射 |
| 点击科目节点 | 弹出科目映射详情卡片 |
| 点击科目表节点 | 无穿透（总账科目表为叶子节点） |
| 悬停边 | 显示转换逻辑 tooltip |

---

## 6. 基础指标展示模式 (Base Mode)

### 6.1 展示形态：DAG + SQL 详情面板 + 穿透入口

基础指标的加工链路复杂，涉及多源表、SQL 表达式、衍生依赖，采用**DAG 图 + 侧边详情面板**展示：

```
┌───────────────────────────────────────────────────────────────────┐
│  基础指标血缘 · Base Mode                                         │
│                                                                   │
│  ┌─────────────────────────────────┐  ┌────────────────────────┐ │
│  │                                 │  │ SQL 详情面板            │ │
│  │    ┌─────┐                      │  │                        │ │
│  │    │源表1 │──┐                   │  │ 源表: B_LOAN_INFO      │ │
│  │    └─────┘  │                   │  │ 算法: 通用算法          │ │
│  │             ▼                   │  │                        │ │
│  │    ┌─────┐  ┌──────────┐       │  │ 度量SQL:               │ │
│  │    │源表2 │──│ 度量节点  │       │  │ SUM(loan_amt)          │ │
│  │    └─────┘  └────┬─────┘       │  │                        │ │
│  │                   │             │  │ 条件SQL:               │ │
│  │             ┌─────▼─────┐      │  │ WHERE status='01'      │ │
│  │             │ 指标节点   │      │  │ AND type='credit'      │ │ │
│  │             │ I005678   │      │  │                        │ │
│  │             └─────┬─────┘      │  │ 🔗 穿透到字段血缘 →    │ │
│  │                   │             │  └────────────────────────┘ │
│  │             ┌─────▼─────┐      │                             │
│  │             │ 衍生指标   │      │                             │
│  │             │ I009999   │      │                             │
│  │             └───────────┘      │                             │
│  └─────────────────────────────────┘                             │
└───────────────────────────────────────────────────────────────────┘
```

### 6.2 前端渲染逻辑

```javascript
function renderBaseLineage(graphData, detail) {
    const container = document.getElementById('indicatorGraphContainer');
    container.innerHTML = '';

    // 1. 使用 DAG 布局 (D3 dagre 或 sugiyama)
    const dagLayout = computeDAGLayout(graphData.nodes, graphData.edges);

    // 2. 渲染 DAG 图
    renderDAGGraph(dagLayout, container);

    // 3. 渲染侧边 SQL 详情面板
    renderSQLDetailPanel(detail, container);

    // 4. 为源表节点添加穿透入口
    addBridgeButtons(graphData.nodes, container);
}
```

### 6.3 DAG 布局参数

| 节点类型 | 形状 | 颜色 | 尺寸 | 特殊标记 |
|---------|------|------|------|---------|
| 指标 (indicator) | 圆角矩形 | 蓝色 #3b82f6 | 140×44 | 显示指标编号 |
| 度量 (measure) | 圆角矩形 | 紫色 #8b5cf6 | 180×36 | 显示度量标签+算法类型 |
| 源表 (table) | 矩形+穿透图标 | 绿色 #10b981 | 160×36 | 右上角显示 🔗 穿透按钮 |
| 衍生指标 | 圆角矩形+虚线边 | 粉色 #ec4899 | 140×44 | 显示依赖关系 |

边样式：
- `data_flow`: 实线，蓝色
- `calc_dependency`: 虚线，紫色，标注算法类型
- 边上 hover 显示 transform_logic tooltip

### 6.4 SQL 详情面板

侧边固定面板，展示当前选中度量/边的完整 SQL 信息：

```
┌────────────────────────────────┐
│ 📝 SQL 详情                     │
│                                │
│ 指标: I005678                  │
│ 度量: 001[原始统计值(期末余额)]  │
│ 算法: 通用算法                  │
│                                │
│ ── 度量SQL ──                  │
│ SUM(loan_amt)                  │
│                                │
│ ── 条件SQL ──                  │
│ WHERE status = '01'            │
│   AND loan_type = 'credit'     │
│                                │
│ ── 完整SQL模板 ──              │
│ INSERT INTO FDL_IDX_...        │
│ SELECT SUM(loan_amt)           │
│ FROM B_LOAN_INFO               │
│ WHERE status = '01'            │
│                                │
│ [🔗 穿透到字段血缘]             │
└────────────────────────────────┘
```

### 6.5 穿透到字段血缘

基础指标的核心交互——从指标血缘穿透到字段级血缘：

```javascript
async function bridgeToFieldLineageFromBase(tableName) {
    const cleanName = tableName.replace(/^TBL_/, '');

    // 1. 调用桥接 API
    const result = await fetch(
        `/api/indicator/bridge-lineage?table_name=${encodeURIComponent(cleanName)}`
    ).then(r => r.json());

    if (result.success) {
        // 2. 在当前面板内嵌展示字段血缘 (不跳转 Tab)
        renderEmbeddedFieldLineage(result.data);
    }
}
```

穿透后，在 DAG 图下方展开一个内嵌的字段血缘子图：

```
┌──────────────────────────────────────────────────┐
│  字段血缘 · B_LOAN_INFO (内嵌)                    │
│                                                  │
│  O_ICL_LOAN.LOAN_AMT ──→ B_LOAN_INFO.LOAN_AMT   │
│  O_ICL_LOAN.STATUS   ──→ B_LOAN_INFO.STATUS     │
│  O_ICL_LOAN.TYPE     ──→ B_LOAN_INFO.LOAN_TYPE  │
│                                                  │
│  [展开完整血缘 → 切换到展示层Tab]                   │
└──────────────────────────────────────────────────┘
```

### 6.6 交互行为

| 操作 | 行为 |
|------|------|
| 点击指标节点 | 高亮该指标的所有上下游链路 |
| 点击度量节点 | 侧边面板展示 SQL 详情 |
| 点击源表节点 | 弹出穿透按钮，点击后内嵌字段血缘 |
| 点击边 | 侧边面板展示该边的转换逻辑 |
| 点击衍生指标 | 跳转到该衍生指标的血缘图 |
| 悬停源表节点 | 显示源表层级和字段数 tooltip |

---

## 7. 混合指标展示模式 (Hybrid Mode)

### 7.1 展示形态：双 Tab 切换

混合指标同时存在总账和基础配置，提供 Tab 切换：

```
┌──────────────────────────────────────────────────┐
│  混合指标血缘 · I007777                            │
│                                                  │
│  [总账链路]  [基础链路]     ← Tab 切换             │
│  ─────────────────                               │
│                                                  │
│  (当前 Tab 对应的展示模式)                          │
│                                                  │
└──────────────────────────────────────────────────┘
```

### 7.2 切换逻辑

- 默认展示总账链路（因为总账链路更简洁，用户可快速理解）
- Tab 切换时，重新调用 `/api/indicator/lineage` 并指定 `view_mode`
- 两个 Tab 的渲染分别复用 GL Mode 和 Base Mode 的渲染函数

---

## 8. 衍生指标展示模式 (Derived Mode)

### 8.1 展示形态：依赖关系图

衍生指标的核心是指标间依赖，采用**依赖关系图**展示：

```
┌──────────────────────────────────────────┐
│  衍生指标血缘 · I009999                   │
│                                          │
│  ┌──────┐  calc_dependency  ┌──────┐    │
│  │I001  │ ─────────────────→│I009  │    │
│  └──────┘                   │999   │    │
│  ┌──────┐  calc_dependency  │      │    │
│  │I002  │ ─────────────────→│      │    │
│  └──────┘                   └──────┘    │
│  ┌──────┐  calc_dependency              │
│  │I003  │ ────────────────→             │
│  └──────┘                                │
│                                          │
│  算法: 自定义SQL算法                       │
│  依赖: I001, I002, I003                   │
└──────────────────────────────────────────┘
```

### 8.2 交互行为

- 点击上游指标节点：跳转到该指标的血缘图
- 点击边：展示衍生计算逻辑（measure_sql / condition_sql）
- 支持递归展开：点击上游指标后，可继续追溯其上游

---

## 9. 前端架构变更

### 9.1 模块结构

```
static/js/
├── indicator-tab.js              # 主入口 (改造)
├── indicator-gl-renderer.js      # 新增：总账指标渲染器
├── indicator-base-renderer.js    # 新增：基础指标渲染器
├── indicator-derived-renderer.js # 新增：衍生指标渲染器
└── indicator-common.js           # 新增：共享工具函数
```

### 9.2 indicator-tab.js 改造

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

        // 根据分类自动选择渲染器
        renderByCategory(category, lineage, detail);

    } catch (error) {
        showIndicatorMessage('加载指标详情失败: ' + error.message);
    } finally {
        showIndicatorLoading(false);
    }
};

function renderByCategory(category, lineageData, detail) {
    switch (category) {
        case "gl":
            renderGLLineage(lineageData, detail);
            break;
        case "base":
            renderBaseLineage(lineageData, detail);
            break;
        case "hybrid":
            renderHybridLineage(lineageData, detail);
            break;
        case "derived":
            renderDerivedLineage(lineageData, detail);
            break;
        default:
            renderBaseLineage(lineageData, detail);
    }
}
```

### 9.3 搜索结果增强

搜索结果列表中，每个指标项显示分类标签和颜色标识：

```javascript
function renderIndicatorSearchResults(results) {
    const container = document.getElementById('indicatorSearchResults');
    container.innerHTML = '';

    results.forEach(item => {
        const cat = item.indicator_category || item.source_type || 'base';
        const catLabel = item.category_label || (cat === 'gl' ? '总账' : '基础');
        const catColors = INDICATOR_CATEGORY_COLORS[cat] || INDICATOR_CATEGORY_COLORS.base;

        const div = document.createElement('div');
        div.className = 'indicator-result-item';
        div.innerHTML = `
            <div class="indicator-no">${item.index_no}</div>
            <div class="indicator-meta">
                <span class="indicator-category-tag"
                      style="background:${catColors.bg};color:${catColors.text};
                             border:1px solid ${catColors.border}">
                    ${catLabel}
                </span>
                ${item.is_derived ? '<span class="indicator-tag derived-tag">衍生</span>' : ''}
            </div>
        `;
        div.onclick = () => selectIndicator(item.index_no);
        container.appendChild(div);
    });
}
```

### 9.4 分类筛选器

在搜索栏旁增加分类筛选下拉框：

```html
<div class="indicator-filter-bar">
    <input type="text" id="indicatorSearchInput" placeholder="输入指标编号搜索...">
    <select id="indicatorCategoryFilter">
        <option value="all">全部类型</option>
        <option value="gl">总账指标</option>
        <option value="base">基础指标</option>
        <option value="derived">衍生指标</option>
        <option value="hybrid">混合指标</option>
    </select>
    <button onclick="searchIndicator()">搜索</button>
</div>
```

搜索时将筛选条件传入 API：

```javascript
window.searchIndicator = async function() {
    const keyword = document.getElementById('indicatorSearchInput').value.trim();
    const category = document.getElementById('indicatorCategoryFilter').value;
    if (!keyword) { showIndicatorMessage('请输入指标编号'); return; }

    showIndicatorLoading(true);
    try {
        let url = `${API_BASE}/search?keyword=${encodeURIComponent(keyword)}&limit=20`;
        if (category !== 'all') {
            url += `&category=${category}`;
        }
        const response = await fetch(url);
        const result = await response.json();
        // ...
    } catch (error) {
        showIndicatorMessage('搜索失败: ' + error.message);
    } finally {
        showIndicatorLoading(false);
    }
};
```

---

## 10. API 接口变更汇总

### 10.1 变更接口

| 接口 | 变更内容 |
|------|---------|
| `GET /api/indicator/search` | 新增 `category` 查询参数；返回结果新增 `indicator_category`、`category_label` 字段 |
| `GET /api/indicator/lineage` | 新增 `view_mode` 查询参数；返回结果新增 `indicator_category`、`category_label` 字段；graph.nodes 新增 `indicator_category` 字段 |
| `GET /api/indicator/detail` | 返回结果新增 `indicator_category`、`category_label` 字段 |

### 10.2 新增接口

| 接口 | 说明 |
|------|------|
| `GET /api/indicator/category-stats` | 返回各分类指标数量统计 |

### 10.3 接口详细定义

#### GET /api/indicator/search

```
Query Parameters:
  keyword:   string (required, min_length=1)  搜索关键词
  limit:     int    (optional, default=50)    返回数量限制
  category:  string (optional)                分类筛选: gl/base/derived/hybrid

Response:
{
    "success": true,
    "data": [
        {
            "index_no": "I001234",
            "measures": ["001", "002"],
            "source_type": "gl",
            "indicator_category": "gl",
            "category_label": "总账指标",
            "is_derived": false
        }
    ]
}
```

#### GET /api/indicator/lineage

```
Query Parameters:
  index_no:   string (required)   指标编号
  measure:    string (optional)   指标度量
  direction:  string (optional)   查询方向: upstream/downstream/both
  depth:      int    (optional)   追溯深度
  view_mode:  string (optional)   展示模式: auto/gl/base (default: auto)

Response:
{
    "success": true,
    "data": {
        "target_index_no": "I001234",
        "target_measure": "001",
        "indicator_category": "gl",
        "category_label": "总账指标",
        "graph": {
            "nodes": [
                {
                    "id": "IND_I001234",
                    "type": "indicator",
                    "indicator_category": "gl",
                    ...
                }
            ],
            "edges": [...]
        },
        "chains": [...]
    }
}
```

#### GET /api/indicator/category-stats

```
Response:
{
    "success": true,
    "data": {
        "category_counts": {
            "gl": 156,
            "base": 423,
            "derived": 89,
            "hybrid": 12
        },
        "total_indicators": 680
    }
}
```

---

## 11. 实施计划

### Phase 1: 后端分类打标 (优先级: 高)

1. `indicator_models.py` 新增 `indicator_category` 字段到 `IndicatorLineageNode` 和 `IndicatorLineageResult`
2. `indicator_graph_builder.py` 新增 `_build_category_index()` 方法，节点构建时打标
3. `indicator_service.py` 序列化方法增加 `indicator_category` 输出
4. `indicator.py` API 路由新增 `category` 筛选参数和 `view_mode` 参数
5. 新增 `/api/indicator/category-stats` 接口

### Phase 2: 总账指标展示模式 (优先级: 高)

1. 新建 `indicator-gl-renderer.js`，实现层级树布局渲染
2. 实现科目映射卡片组件
3. 改造 `indicator-tab.js`，根据 `indicator_category` 自动路由到 GL 渲染器
4. 搜索结果增加分类标签和颜色

### Phase 3: 基础指标展示模式 (优先级: 高)

1. 新建 `indicator-base-renderer.js`，实现 DAG 布局渲染
2. 实现 SQL 详情侧边面板
3. 实现源表穿透按钮和内嵌字段血缘子图
4. 实现衍生指标跳转

### Phase 4: 混合/衍生模式 + 筛选器 (优先级: 中)

1. 新建 `indicator-derived-renderer.js`，实现依赖关系图
2. 实现混合指标双 Tab 切换
3. 搜索栏增加分类筛选下拉框
4. 新建 `indicator-common.js`，抽取共享工具函数

### Phase 5: 测试与优化 (优先级: 中)

1. 单元测试：分类判定逻辑、API 参数校验
2. 集成测试：端到端血缘查询 + 分类展示
3. 性能优化：大量科目映射时的渲染性能（虚拟滚动）
4. 交互优化：动画过渡、加载状态

---

## 12. 风险与应对

| 风险 | 影响 | 应对措施 |
|------|------|---------|
| 混合指标的双配置导致展示歧义 | 用户不确定看到的是哪部分链路 | 明确 Tab 标签，默认展示总账链路 |
| 总账指标科目映射数量过多（>50条） | 层级树渲染卡顿 | 科目映射卡片分页/虚拟滚动，默认只展示前10条 |
| 基础指标 SQL 模板过长 | 侧边面板溢出 | SQL 代码折叠，点击展开完整内容 |
| D3 tree layout 与现有 force layout 切换闪烁 | 用户体验差 | 添加过渡动画，先淡出旧图再淡入新图 |
| 衍生指标递归追溯深度过大 | 图谱节点爆炸 | 限制追溯深度 max_depth=5，超深节点折叠 |

---

## 13. 兼容性说明

- 所有 API 变更**向后兼容**：新增字段不影响现有调用方
- `view_mode=auto` 为默认值，行为等价于当前逻辑 + 自动分类
- 搜索 API 的 `category` 参数为可选，不传时返回全部结果
- 前端渲染器通过 `indicator_category` 字段自动路由，无需前端硬编码指标类型
