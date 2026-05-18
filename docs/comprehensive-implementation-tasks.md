# 指标口径功能增强 — 综合实施任务清单与详细设计

> 版本: v1.0  
> 日期: 2026-05-18  
> 来源: docs/indicator-spec-design.md + docs/execution-task-list.md  
> 设计原则: 分层聚焦、单步自治、表达式优先、源码锚定、可导出文档

---

## 一、实施现状评估

基于代码库审查，各批次当前实施状态如下：

| 批次 | 状态 | 说明 |
|------|------|------|
| **批次A** (行号定位) | ✅ 已完成 | `SQLOperation` 已有 `start_line/end_line/file_path`；`CaliberInfo` 已有对应字段；`api_server.py` 已序列化 |
| **批次B** (SQL边界检测) | ✅ 已完成 | `core/sql_boundary_detector.py` 已实现；`step_isolated_where/join` 已在 models 和 API 中存在 |
| **批次C** (CTE/函数/表达式) | ✅ 已完成 | `_extract_cte_definitions/_extract_custom_functions/_extract_full_expression` 已在 `caliber_extractor.py` 中实现 |
| **批次D** (API/前端增强) | ⚠️ 部分完成 | API 序列化已有新字段输出，但缺少 Summary Card、Pipeline View、Step Detail Panel 三层视图 |

### 剩余工作总结

**解析层（已完成）** → **服务层（需增强）** → **API层（需新增端点）** → **前端展示层（需全新实现）** → **导出层（需新增）**

---

## 二、任务总览

分为 **5 个阶段**，共 **28 项任务**：

| 阶段 | 任务数 | 优先级 | 核心目标 |
|------|--------|--------|---------|
| **Phase 1** | 5 | P0 (最高) | Summary Card 服务 + API |
| **Phase 2** | 6 | P0 (最高) | Pipeline View 服务 + API |
| **Phase 3** | 6 | P0 (最高) | Step Detail Panel 服务 + API |
| **Phase 4** | 7 | P1 (高) | 前端三层视图实现 |
| **Phase 5** | 4 | P2 (中) | 导出功能 + 集成测试 |

---

## Phase 1: Summary Card 服务层 + API

### 目标

实现指标概览卡数据服务，提供"技术口径摘要"、"链路统计"、"数据质量标记"等概览信息。

### 设计原则映射

- **分层聚焦**: Summary Card 是最顶层入口，提供宏观视图
- **表达式优先**: 技术口径摘要展示从源到目标的完整表达式链路

---

#### 任务 1.1: 新增 CaliberSummaryCard 数据模型

**优先级**: P0  
**涉及文件**: `core/models.py`  
**依赖**: 无  
**风险**: 🟢 低 — 纯新增数据类，不影响已有代码

**详细设计**:

```python
@dataclass
class CaliberSummaryCard:
    """指标概览卡数据模型"""
    indicator: str = ""                    # 完整标识 (SCHEMA.TABLE.FIELD)
    indicator_short: str = ""              # 短标识 (TABLE.FIELD)
    business_caliber: str = ""             # 业务口径描述
    technical_caliber_summary: str = ""    # 技术口径摘要 (一行文字链路)
    caliber_chain_text: list[str] = field(default_factory=list)  # 每步转换描述
    stats: dict = field(default_factory=dict)  # 统计信息
    data_quality_flags: dict = field(default_factory=dict)  # 数据质量标记
    query_time_ms: float = 0.0
```

**Stats 字段结构**:
```python
stats = {
    "parallel_paths": int,       # 并行路径数
    "total_steps": int,          # 总步骤数
    "procedures_count": int,     # 涉及存储过程数
    "procedures": list[str],     # 存储过程名列表
    "tables_count": int,         # 涉及表数
    "tables": list[str],         # 表名列表
    "custom_functions": list[str],  # 自定义函数列表
}
```

**Data Quality Flags 字段结构**:
```python
data_quality_flags = {
    "has_hardcoded_values": bool,   # 是否有硬编码值
    "has_cross_schema_join": bool,  # 是否有跨 Schema 关联
    "has_null_branch": bool,        # 是否有 NULL 分支
    "has_custom_function": bool,    # 是否使用自定义函数
}
```

**验收标准**:
1. `CaliberSummaryCard` 可正常实例化
2. 不影响现有 `CaliberResult` / `CaliberChain` / `CaliberInfo` 的使用
3. 支持 `dataclasses.asdict()` 序列化

---

#### 任务 1.2: 实现 Summary Card 构建逻辑

**优先级**: P0  
**涉及文件**: `app/services/caliber_service.py`  
**依赖**: 任务 1.1  
**风险**: 🟡 中 — 需从 CaliberResult 中提取和聚合信息

**详细设计**:

新增方法 `build_summary_card(table: str, field: str) -> CaliberSummaryCard`:

```python
def build_summary_card(self, table: str, field: str) -> dict:
    """构建指标概览卡数据。
    
    算法:
      1. 调用 trace_caliber() 获取完整 CaliberResult
      2. 提取技术口径摘要: 遍历首选链路的每个 step，
         拼接 "source_expression → [layer 转换] → target" 文本
      3. 聚合统计: 路径数、步骤数、涉及表/过程
      4. 检测数据质量标记: 扫描所有 step 的条件和表达式
      5. 构造 CaliberSummaryCard 返回
    """
```

**技术口径摘要生成算法**:
```python
def _build_technical_summary(self, chain: CaliberChain) -> str:
    """从链路步骤生成技术口径摘要文本。
    
    示例输出:
      "TRIM(UPPER(CUST_NAME)) → [MDL 脱敏] → [EAST 映射] → KHXM"
    
    逻辑:
      1. 取首步的 full_expression 作为起始表达式
      2. 中间步骤: 如果 full_expression 不同于 source_column，
         显示 "[{layer} {transform_note}]"
      3. 末步: 显示目标字段名
    """
```

**数据质量标记检测**:
```python
def _detect_quality_flags(self, result: CaliberResult) -> dict:
    """扫描链路检测数据质量问题。
    
    检测规则:
      - has_hardcoded_values: WHERE 条件中包含字面量 ('1', '0', 数字)
      - has_cross_schema_join: JOIN 涉及不同 schema 的表
      - has_null_branch: 表达式中包含 NVL/COALESCE/IS NULL
      - has_custom_function: custom_functions 列表非空
    """
```

**验收标准**:
1. 查询已知表.字段返回完整 summary card
2. 技术口径摘要文本可读，正确反映转换链路
3. 统计数据准确（路径数与 chains 数一致）

---

#### 任务 1.3: 新增 `/api/caliber/summary` API 端点

**优先级**: P0  
**涉及文件**: `app/api/caliber.py`  
**依赖**: 任务 1.2  
**风险**: 🟢 低 — 纯新增端点

**API 规格**:

```
GET /api/caliber/summary?table={table}&field={field}

Parameters:
  table: string (required) - 目标表名，支持 SCHEMA.TABLE 或 TABLE 短名
  field: string (required) - 目标字段名

Response (200):
{
  "success": true,
  "data": {
    "indicator": "RRP_EAST.EAST5_201_GRJCXXB.KHXM",
    "indicator_short": "EAST5_201_GRJCXXB.KHXM",
    "business_caliber": "",
    "technical_caliber_summary": "TRIM(UPPER(CUST_NAME)) → [MDL 脱敏] → KHXM",
    "caliber_chain_text": [...],
    "stats": {...},
    "data_quality_flags": {...},
    "query_time_ms": 123.45
  }
}

Response (404):
{
  "success": false,
  "error": {"code": "NOT_FOUND", "message": "未找到该字段的口径数据"}
}
```

**实现位置**: `app/api/caliber.py` 新增路由

**验收标准**:
1. API 可正常访问，返回正确 JSON 结构
2. 查询不存在的字段返回 404
3. `query_time_ms` 有值且合理 (< 5000ms)

---

#### 任务 1.4: Summary Card 单元测试

**优先级**: P0  
**涉及文件**: `tests/test_summary_card.py` (新建)  
**依赖**: 任务 1.2  
**风险**: 🟢 低

**测试场景**:

| # | 场景 | 验证点 |
|---|------|--------|
| 1 | 正常查询已有口径的字段 | technical_caliber_summary 非空，stats 正确 |
| 2 | 查询无口径数据的字段 | 返回空 summary 或 404 |
| 3 | 多路径场景 | parallel_paths > 1 |
| 4 | 包含自定义函数 | has_custom_function = true，函数列表非空 |
| 5 | 技术口径摘要格式 | 包含 "→" 分隔符，首尾为字段名/表达式 |

---

#### 任务 1.5: Summary Card 集成验证

**优先级**: P0  
**涉及文件**: 无新文件，运行验证  
**依赖**: 任务 1.3, 1.4  
**风险**: 🟢 低

**验证方法**:
1. 启动服务 `uvicorn app.main:app --port 8899`
2. 请求 `GET /api/caliber/summary?table=EAST5_201_GRJCXXB&field=KHXM`（或实际存在的数据）
3. 验证响应包含所有必须字段
4. 验证 `technical_caliber_summary` 可读性

---

## Phase 2: Pipeline View 服务层 + API

### 目标

实现加工链路流水线视图数据服务，将线性链路转换为横向 DAG 结构（节点 + 边 + 分支），支持并行路径展示。

### 设计原则映射

- **分层聚焦**: Pipeline 是中间层，展示宏观数据流
- **单步自治**: 每条边是独立的加工步骤

---

#### 任务 2.1: 新增 Pipeline 数据模型

**优先级**: P0  
**涉及文件**: `core/models.py`  
**依赖**: 无  
**风险**: 🟢 低

**详细设计**:

```python
@dataclass
class PipelineNode:
    """Pipeline 视图节点"""
    id: str = ""                           # 唯一标识 (TABLE.FIELD 或 TABLE)
    layer: str = ""                        # 数据分层 (ODS/DWD/DWS/ADS/EAST)
    layer_label: str = ""                  # 分层显示标签
    label: str = ""                        # 显示标签 (短表名)
    field: str = ""                        # 关联字段名
    is_source: bool = False                # 是否为源头节点
    is_target: bool = False                # 是否为目标节点
    is_internal_transform: bool = False    # 是否为同表内字段转换
    transform_note: str = ""               # 转换说明 (如 "同表内脱敏处理")


@dataclass
class PipelineEdge:
    """Pipeline 视图边 (一个加工步骤)"""
    id: str = ""                           # 步骤 ID (如 "step_1")
    source: str = ""                       # 源节点 ID
    target: str = ""                       # 目标节点 ID
    source_field: str = ""                 # 源字段名
    target_field: str = ""                 # 目标字段名
    expression: str = ""                   # 完整加工表达式
    procedure: str = ""                    # 所属存储过程
    step_num: int = 0                      # 步骤编号
    operation_type: str = ""               # 操作类型 (INSERT_SELECT/MERGE/UPDATE)
    has_detail: bool = True                # 是否有详情可展开
    file_path: str = ""                    # 源文件路径
    start_line: int = 0                    # 起始行号


@dataclass
class PipelineBranch:
    """Pipeline 视图中的分支 (并行路径)"""
    merge_point: str = ""                  # 汇聚节点 ID
    source_node: str = ""                  # 分支来源节点 ID
    label: str = ""                        # 分支标签


@dataclass
class PipelineView:
    """Pipeline 完整视图"""
    target_table: str = ""
    target_field: str = ""
    nodes: list[PipelineNode] = field(default_factory=list)
    edges: list[PipelineEdge] = field(default_factory=list)
    branches: list[PipelineBranch] = field(default_factory=list)
    layer_order: list[str] = field(default_factory=list)  # 从左到右的分层顺序
```

**验收标准**:
1. 所有数据类可正常实例化和序列化
2. 不影响现有代码

---

#### 任务 2.2: 实现 Pipeline 构建引擎

**优先级**: P0  
**涉及文件**: `app/services/caliber_service.py`  
**依赖**: 任务 2.1  
**风险**: 🟡 中 — 需要将线性 chain 转换为图结构

**详细设计**:

新增方法 `build_pipeline_view(table: str, field: str) -> dict`:

```python
def build_pipeline_view(self, table: str, field: str) -> dict:
    """构建 Pipeline 流水线视图数据。
    
    算法:
      1. 调用 trace_caliber() 获取 CaliberResult (所有 chains)
      2. 遍历所有 chains，构建全局节点集和边集
      3. 同一 (table, field) 对映射为同一个 PipelineNode
      4. 检测同表内字段转换 (source_table == target_table 但 field 不同)
      5. 检测并行路径 (多个 chain 的某些边汇聚到同一节点)
      6. 按数据分层排列节点列顺序 (ODS → DWD → DWS → ADS → EAST)
      7. 标记 is_source (无入边) 和 is_target (无出边) 节点
    """
```

**并行路径检测算法**:
```python
def _detect_branches(self, nodes: dict, edges: list) -> list[PipelineBranch]:
    """检测并行分支路径。
    
    规则:
      - 如果某个节点有多个入边来自不同源节点，则为汇聚点
      - 主路径 (首选 chain 的路径) 为实线
      - 分支路径 (其他 chain 独有的边) 为虚线
    """
```

**同表内转换检测**:
```python
def _detect_internal_transforms(self, chain) -> list[tuple]:
    """检测同表内字段转换。
    
    规则:
      - 同一步骤中 source_table == target_table 但 source_column != target_column
      - 标记为 is_internal_transform = True
      - transform_note = "同表内字段转换：{描述}"
    """
```

**验收标准**:
1. 返回的 Pipeline 中节点唯一（无重复）
2. 边的 source/target 引用的节点 ID 存在于 nodes 中
3. 分支标记正确（多路径场景下 branches 非空）
4. 分层顺序正确 (ODS 在左，EAST 在右)

---

#### 任务 2.3: 新增 `/api/caliber/pipeline` API 端点

**优先级**: P0  
**涉及文件**: `app/api/caliber.py`  
**依赖**: 任务 2.2  
**风险**: 🟢 低

**API 规格**:

```
GET /api/caliber/pipeline?table={table}&field={field}

Parameters:
  table: string (required) - 目标表名
  field: string (required) - 目标字段名

Response (200):
{
  "success": true,
  "data": {
    "target": {"table": "...", "field": "..."},
    "pipeline": {
      "nodes": [...],
      "edges": [...],
      "branches": [...],
      "layer_order": ["ods", "base", "mdl", "app", "east"]
    },
    "query_time_ms": 150.3
  }
}
```

**验收标准**:
1. 响应 JSON 结构符合规格
2. nodes/edges 数组非空（对于有效查询）
3. 前端可直接基于此数据渲染 D3.js 图

---

#### 任务 2.4: Pipeline 节点去重与 ID 稳定化

**优先级**: P0  
**涉及文件**: `app/services/caliber_service.py`  
**依赖**: 任务 2.2  
**风险**: 🟡 中

**详细设计**:

节点 ID 生成策略:
```python
def _make_node_id(self, table: str, field: str) -> str:
    """生成稳定的节点 ID。
    
    规则:
      - 基本格式: "{SHORT_TABLE}.{FIELD}"
      - 同表内转换: "{SHORT_TABLE}.{FIELD}" (每个字段一个节点)
      - 去除 schema 前缀确保匹配 (RRP_EAST.T1 和 T1 映射为同节点)
    """
    short_table = table.split(".")[-1].upper() if "." in table else table.upper()
    return f"{short_table}.{field.upper()}"
```

**去重逻辑**:
```python
def _merge_nodes(self, chains: list) -> dict[str, PipelineNode]:
    """从多条 chain 中合并去重节点。
    
    合并规则:
      - 相同 node_id 的节点合并为一个
      - 属性合并: is_source = any(node.is_source for same_id)
      - layer 取首次出现的值
    """
```

**验收标准**:
1. 多条 chain 共享的节点在输出中仅出现一次
2. 相同表的不同 schema 变体映射为同一节点
3. 节点 ID 稳定（相同查询多次调用返回相同 ID）

---

#### 任务 2.5: Pipeline 单元测试

**优先级**: P0  
**涉及文件**: `tests/test_pipeline_view.py` (新建)  
**依赖**: 任务 2.2  
**风险**: 🟢 低

**测试场景**:

| # | 场景 | 验证点 |
|---|------|--------|
| 1 | 单链路 (无分支) | nodes 按分层排列，edges 串联 |
| 2 | 多链路并行 | branches 非空，汇聚点正确 |
| 3 | 同表内转换 | is_internal_transform = true 的节点存在 |
| 4 | 节点去重 | 多 chain 共享中间表时不重复 |
| 5 | 空结果 | 无口径数据时返回空 pipeline |

---

#### 任务 2.6: Pipeline 集成验证

**优先级**: P0  
**涉及文件**: 无新文件  
**依赖**: 任务 2.3  
**风险**: 🟢 低

**验证**: 启动服务后请求 `/api/caliber/pipeline`，确认响应可被 D3.js 消费。

---

## Phase 3: Step Detail Panel 服务层 + API

### 目标

实现单步详情数据服务，为前端 Step Detail Panel 提供：完整表达式、步骤级隔离条件、CTE 定义、自定义函数标记、源码定位。

### 设计原则映射

- **单步自治**: 只展示该步骤自身的 WHERE/JOIN，不累积
- **表达式优先**: 目标字段 = 完整计算表达式
- **源码锚定**: 精确到文件、行号、SQL 片段

---

#### 任务 3.1: 新增 StepDetail 数据模型

**优先级**: P0  
**涉及文件**: `core/models.py`  
**依赖**: 无  
**风险**: 🟢 低

**详细设计**:

```python
@dataclass
class TargetFieldExpression:
    """单个目标字段的完整表达式"""
    target_column: str = ""
    expression: str = ""                   # 完整表达式
    source_columns: list[str] = field(default_factory=list)
    source_tables: list[str] = field(default_factory=list)
    is_custom_function: bool = False
    custom_function_name: str = ""


@dataclass
class CTEDetail:
    """CTE 详情 (展示用)"""
    name: str = ""
    definition: str = ""                   # CTE 完整定义体
    source_tables: list[str] = field(default_factory=list)
    consumed_in_step: int = 0


@dataclass
class CustomFunctionDetail:
    """自定义函数详情"""
    name: str = ""                         # 函数全名 (如 PKG_DESEN.ENCRYPT_NAME)
    is_custom: bool = True
    migration_risk: str = "LOW"            # LOW / MEDIUM / HIGH
    risk_note: str = ""                    # 风险说明


@dataclass
class StepDetail:
    """单步详情面板完整数据"""
    step_num: int = 0
    step_desc: str = ""
    procedure: str = ""
    source_table: str = ""
    target_table: str = ""
    operation_type: str = ""               # INSERT_SELECT / MERGE / UPDATE
    
    # 源码锚定
    source_code_location: dict = field(default_factory=dict)  # {file_path, start_line, end_line}
    
    # 目标字段表达式 (核心)
    target_field_expressions: list[TargetFieldExpression] = field(default_factory=list)
    
    # 步骤级隔离条件 (非累积)
    step_isolated_where: list[dict] = field(default_factory=list)
    step_isolated_join: list[dict] = field(default_factory=list)
    
    # 聚合/窗口
    window_functions: list[str] = field(default_factory=list)
    group_by_clause: str = ""
    having_clause: str = ""
    distinct_flag: bool = False
    set_operation: str = ""
    order_by_clause: str = ""
    
    # CTE
    cte_definitions: list[CTEDetail] = field(default_factory=list)
    
    # 自定义函数
    custom_functions: list[CustomFunctionDetail] = field(default_factory=list)
    
    # 原始 SQL
    raw_sql: str = ""
    
    # 元数据
    confidence: float = 1.0
```

**验收标准**: 数据类可正常实例化和序列化

---

#### 任务 3.2: 实现 Step Detail 构建逻辑

**优先级**: P0  
**涉及文件**: `app/services/caliber_service.py`  
**依赖**: 任务 3.1  
**风险**: 🟡 中 — 需从 CaliberInfo 中组装 StepDetail

**详细设计**:

```python
def build_step_detail(
    self, table: str, field: str, step_num: int, procedure: str = ""
) -> dict:
    """构建单步详情面板数据。
    
    算法:
      1. 调用 trace_caliber() 获取 CaliberResult
      2. 在 chains 中定位指定 step_num (和 procedure) 的 CaliberInfo
      3. 从 CaliberInfo 提取:
         - source_code_location: file_path + start_line + end_line
         - step_isolated_where/join (优先) 或 where_conditions/join_conditions (降级)
         - full_expression → 构建 TargetFieldExpression
         - cte_definitions → 构建 CTEDetail 列表
         - custom_functions → 构建 CustomFunctionDetail 列表
      4. 从源文件读取 raw_sql (如果行号有效)
      5. 计算迁移风险评级
    """
```

**表达式构建逻辑**:
```python
def _build_target_expressions(self, caliber_info) -> list[dict]:
    """从 CaliberInfo 构建目标字段表达式列表。
    
    优先级:
      1. full_expression (如果非空且不等于 source_column)
      2. select_columns 中的 source_expression
      3. 降级为 transform_logic
    
    自定义函数标记:
      - 表达式中包含 PKG_.* 或 FN_.* 调用 → is_custom_function = true
    """
```

**迁移风险评估逻辑**:
```python
def _assess_migration_risk(self, func_name: str) -> tuple[str, str]:
    """评估自定义函数的迁移风险。
    
    规则:
      - PKG_*.FUNC() → HIGH ("自定义包函数，新环境需确认或重写")
      - FN_*() / FUNC_*() → MEDIUM ("独立自定义函数，可能需迁移")
      - 其他 → LOW
    """
```

**验收标准**:
1. 返回的 StepDetail 中 `target_field_expressions` 非空
2. `step_isolated_where` 只包含本步骤的条件（非累积）
3. `source_code_location.file_path` 非空且行号有效
4. 如有自定义函数，`custom_functions` 正确标记

---

#### 任务 3.3: 实现 raw_sql 读取逻辑

**优先级**: P0  
**涉及文件**: `app/services/caliber_service.py`  
**依赖**: 任务 3.2  
**风险**: 🟡 中 — 需要文件系统读取

**详细设计**:

```python
def _read_raw_sql(self, file_path: str, start_line: int, end_line: int) -> str:
    """从源文件读取指定行号范围的 SQL 文本。
    
    安全措施:
      - 文件路径必须在配置的数据目录内 (防目录遍历)
      - 行号范围不超过 500 行 (防大段读取)
      - 文件不存在时返回 "(源文件不可用)"
      - 编码为 UTF-8，errors='ignore'
    
    返回:
      原始 SQL 文本 (保留缩进和换行)
    """
```

**验收标准**:
1. 有效的 file_path + line range 返回对应 SQL
2. 无效路径/行号不抛异常，返回提示文本
3. 路径校验防止目录遍历攻击

---

#### 任务 3.4: 新增 `/api/caliber/step-detail` API 端点

**优先级**: P0  
**涉及文件**: `app/api/caliber.py`  
**依赖**: 任务 3.2, 3.3  
**风险**: 🟢 低

**API 规格**:

```
GET /api/caliber/step-detail?table={table}&field={field}&step_num={n}&procedure={proc}

Parameters:
  table: string (required) - 目标表名
  field: string (required) - 目标字段名
  step_num: int (required) - 步骤编号
  procedure: string (optional) - 存储过程名 (用于精确定位)

Response (200):
{
  "success": true,
  "data": {
    "step_num": 2,
    "step_desc": "...",
    "procedure": "P_M_CUST_IND_INFO_EAST",
    "source_table": "RRP_MDL.M_CUST_IND_INFO",
    "target_table": "RRP_EAST.M_CUST_IND_INFO_EAST",
    "operation_type": "INSERT_SELECT",
    "source_code_location": {
      "file_path": "RRP_ORACLE/rrp_east/P_M_CUST_IND_INFO_EAST.prc",
      "start_line": 142,
      "end_line": 189
    },
    "target_field_expressions": [...],
    "step_isolated_where": [...],
    "step_isolated_join": [...],
    "window_functions": [...],
    "cte_definitions": [...],
    "custom_functions": [...],
    "raw_sql": "INSERT INTO ...",
    "confidence": 0.95
  }
}
```

**验收标准**:
1. 正确定位到指定步骤
2. 所有字段按规格返回
3. raw_sql 来自源文件而非截断的 CaliberInfo.raw_sql_fragment

---

#### 任务 3.5: Step Detail 单元测试

**优先级**: P0  
**涉及文件**: `tests/test_step_detail.py` (新建)  
**依赖**: 任务 3.2  
**风险**: 🟢 低

**测试场景**:

| # | 场景 | 验证点 |
|---|------|--------|
| 1 | 正常步骤查询 | 所有字段非空/合理 |
| 2 | 包含自定义函数的步骤 | custom_functions 非空，migration_risk 正确 |
| 3 | 包含 CTE 的步骤 | cte_definitions 非空 |
| 4 | 步骤不存在 | 返回 404 或空结果 |
| 5 | 隔离条件 vs 累积条件 | step_isolated_where 条目数 <= where_conditions |

---

#### 任务 3.6: Step Detail 集成验证

**优先级**: P0  
**涉及文件**: 无  
**依赖**: 任务 3.4  
**风险**: 🟢 低

**验证**: 启动服务后请求 `/api/caliber/step-detail`，确认响应完整且 raw_sql 来自源文件。

---

## Phase 4: 前端三层视图实现

### 目标

实现前端三个组件：Summary Card、Pipeline View (D3.js 横向流水线)、Step Detail Panel (右侧滑出面板)。

### 设计原则映射

- **分层聚焦**: 三层视图逐级展开
- **可导出文档**: 为 Phase 5 导出功能提供 UI 入口

---

#### 任务 4.1: 前端目录结构搭建

**优先级**: P1  
**涉及文件**: `static/js/caliber/` (新建目录), `static/css/caliber.css` (新建)  
**依赖**: Phase 1-3 API 完成  
**风险**: 🟢 低

**文件结构**:
```
static/
├── js/
│   └── caliber/
│       ├── summary-card.js      # 层级1: 指标概览卡
│       ├── pipeline-view.js     # 层级2: 加工链路图
│       ├── step-detail.js       # 层级3: 单步详情面板
│       └── caliber-export.js    # 导出功能 (Phase 5)
└── css/
    └── caliber.css              # 口径功能专用样式
```

**验收标准**: 目录和空文件创建完成，可在 index.html 中引入

---

#### 任务 4.2: Summary Card 前端组件

**优先级**: P1  
**涉及文件**: `static/js/caliber/summary-card.js`, `static/css/caliber.css`  
**依赖**: 任务 1.3 (API), 任务 4.1  
**风险**: 🟢 低

**详细设计**:

组件职责:
1. 调用 `GET /api/caliber/summary` 获取数据
2. 渲染指标标识、技术口径摘要、链路统计、数据质量标记
3. 提供"查看加工链路"按钮触发 Pipeline View

**技术口径摘要渲染**:
```html
<div class="caliber-summary-chain">
  <span class="chain-step source">TRIM(UPPER(CUST_NAME))</span>
  <span class="chain-arrow">→</span>
  <span class="chain-step transform">[MDL 脱敏]</span>
  <span class="chain-arrow">→</span>
  <span class="chain-step target">KHXM</span>
</div>
```

**交互**: 
- 输入框接受 table + field
- 查询后渲染卡片
- 点击"查看加工链路"调用 Pipeline View

**验收标准**:
1. 概览卡在口径 Tab 顶部正确渲染
2. 技术口径摘要一行可见，表达式链路可读
3. 统计数字正确

---

#### 任务 4.3: Pipeline View 前端组件 (D3.js)

**优先级**: P1  
**涉及文件**: `static/js/caliber/pipeline-view.js`, `static/css/caliber.css`  
**依赖**: 任务 2.3 (API), 任务 4.1  
**风险**: 🟡 中 — D3.js 布局算法需调试

**详细设计**:

**布局算法**:
```javascript
class PipelineLayout {
    constructor(nodes, edges, branches) { ... }
    
    layout() {
        // 1. 按 layer 分列 (从左到右: ODS → DWD → DWS → ADS → EAST)
        // 2. 同列内按拓扑序排列
        // 3. 分支节点在汇聚点下方偏移
        // 4. 同表内转换节点紧贴父节点下方
    }
}
```

**节点渲染**:
- 普通节点: 圆角矩形，按分层着色 (使用 LAYER_CONFIG 定义的颜色)
- 源头节点: 绿色边框
- 目标节点: 蓝色边框
- 同表内转换: 虚线边框 + "内部转换"标签

**边渲染**:
- 主路径: 实线箭头 + 步骤编号标签
- 分支路径: 虚线箭头
- Hover: 显示 expression tooltip

**交互**:
- 点击节点: 高亮该节点的上下游路径
- 点击边: 触发 Step Detail Panel 滑出
- Hover 节点: 显示表名.字段名全名

**验收标准**:
1. 横向流水线正确渲染，节点按分层从左到右排列
2. 并行路径可视（多条路径交叉时不重叠）
3. 点击边触发详情面板
4. 20 个节点以内流畅渲染

---

#### 任务 4.4: Step Detail Panel 前端组件

**优先级**: P1  
**涉及文件**: `static/js/caliber/step-detail.js`, `static/css/caliber.css`  
**依赖**: 任务 3.4 (API), 任务 4.1  
**风险**: 🟢 低

**详细设计**:

**面板结构** (右侧滑出，固定宽度 480px):
```
┌─────────────────────────────────────┐
│ [×] 步骤 #2: M_CUST → M_CUST_EAST │  ← 标题 + 关闭按钮
├─────────────────────────────────────┤
│ 【所属脚本】                         │
│ P_M_CUST_IND_INFO_EAST.prc:142-189  │  ← 可点击跳转
│ 操作类型: INSERT_SELECT              │
├─────────────────────────────────────┤
│ 【目标字段表达式】                    │  ← 语法高亮
│ CUST_NM_DESEN =                      │
│   PKG_DESEN.ENCRYPT_NAME(A.CUST_NM)  │  ← 自定义函数高亮
├─────────────────────────────────────┤
│ 【本步筛选条件】                      │
│ WHERE A.ETL_DT <= TO_DATE(...)       │
│   AND A.IS_VALID = '1'               │
├─────────────────────────────────────┤
│ 【本步 JOIN 关系】                    │
│ LEFT JOIN TMP_ALB_TMP1 K             │
│   ON K.CUSTOMER_NO = A.CUST_ID       │
├─────────────────────────────────────┤
│ 【CTE / 临时表】  [▼ 折叠]           │
│ WITH TMP_ALB_TMP2 AS (...)           │
├─────────────────────────────────────┤
│ 【自定义函数】                        │
│ ⚠️ PKG_DESEN.ENCRYPT_NAME [HIGH]     │
│   风险: 自定义加密包，需确认或重写    │
├─────────────────────────────────────┤
│ 【原始 SQL】  [▼ 折叠]               │
│ INSERT INTO M_CUST_IND_INFO_EAST ... │
├─────────────────────────────────────┤
│ [复制 SQL] [导出此步骤]               │
└─────────────────────────────────────┘
```

**语法高亮** (简易实现):
```javascript
function highlightSQL(expr) {
    return expr
        .replace(/(PKG_\w+\.\w+)/g, '<span class="hl-custom-func">$1</span>')
        .replace(/\b(TRIM|UPPER|LOWER|NVL|SUBSTR|TO_DATE|TO_CHAR)\b/gi, '<span class="hl-builtin">$1</span>')
        .replace(/\b(SELECT|FROM|WHERE|AND|OR|JOIN|ON|INSERT|INTO|UPDATE|SET)\b/gi, '<span class="hl-keyword">$1</span>')
        .replace(/('[^']*')/g, '<span class="hl-string">$1</span>');
}
```

**验收标准**:
1. 点击 Pipeline 边后右侧面板正确滑出
2. 所有信息区域正确渲染
3. CTE 和原始 SQL 默认折叠，可展开
4. 自定义函数有风险标签 (颜色区分)
5. "复制 SQL" 按钮功能正常

---

#### 任务 4.5: 三层组件联动集成

**优先级**: P1  
**涉及文件**: `static/index.html`, `static/js/caliber/` 各组件  
**依赖**: 任务 4.2, 4.3, 4.4  
**风险**: 🟡 中 — 组件间通信和状态管理

**详细设计**:

组件通信流程:
```
用户输入 table + field
    ↓
summary-card.js: 调用 /api/caliber/summary → 渲染概览卡
    ↓ (用户点击 "查看加工链路")
pipeline-view.js: 调用 /api/caliber/pipeline → 渲染流水线图
    ↓ (用户点击某条边)
step-detail.js: 调用 /api/caliber/step-detail → 渲染详情面板
```

事件通信:
```javascript
// 使用 CustomEvent 进行组件间通信
document.dispatchEvent(new CustomEvent('caliber:show-pipeline', { detail: { table, field } }));
document.dispatchEvent(new CustomEvent('caliber:show-step', { detail: { table, field, step_num, procedure } }));
```

**验收标准**:
1. 完整交互流程无断点
2. 面板切换平滑（CSS transition）
3. 返回/关闭按钮正常工作

---

#### 任务 4.6: 前端样式设计

**优先级**: P1  
**涉及文件**: `static/css/caliber.css`  
**依赖**: 任务 4.2, 4.3, 4.4  
**风险**: 🟢 低

**CSS 变量** (与现有系统风格一致):
```css
:root {
    --caliber-bg: var(--bg-secondary, #f8fafc);
    --caliber-border: var(--border-color, #e2e8f0);
    --caliber-accent: var(--accent-color, #3b82f6);
    --caliber-warning: #f59e0b;
    --caliber-danger: #ef4444;
    --caliber-success: #10b981;
}
```

**验收标准**: 样式与系统现有风格统一，响应式适配

---

#### 任务 4.7: 前端 E2E 验证

**优先级**: P1  
**涉及文件**: 无  
**依赖**: 任务 4.5  
**风险**: 🟢 低

**验证场景**:
1. 查询一个已知有口径数据的 table.field
2. 概览卡正确显示
3. 点击"查看加工链路" → Pipeline 正确渲染
4. 点击某条边 → Step Detail 滑出并显示正确信息
5. 点击"复制 SQL" → 剪贴板中有 SQL
6. 关闭面板 → 界面恢复

---

## Phase 5: 导出功能 + 集成测试

### 目标

实现口径文档导出（Markdown / HTML），以及全链路集成测试。

### 设计原则映射

- **可导出为设计文档**: 一键生成 Markdown，直接贴进需求设计文档

---

#### 任务 5.1: 实现 Markdown 导出引擎

**优先级**: P2  
**涉及文件**: `core/caliber_exporter.py` (新建)  
**依赖**: Phase 1-3 完成  
**风险**: 🟢 低

**详细设计**:

```python
class CaliberExporter:
    """口径文档导出引擎"""
    
    def export_markdown(
        self, table: str, field: str, 
        include_sql: bool = True,
        include_source_location: bool = True,
    ) -> str:
        """导出为 Markdown 格式文档。
        
        模板:
          # 指标口径规格：{table}.{field}
          ## 技术口径摘要
          {technical_caliber_summary}
          ## 加工链路
          {caliber_chain_text (numbered list)}
          ## 逐步骤详情
          ### 步骤 1: {source} → {target}
          - **操作类型**: ...
          - **所属脚本**: ...
          - **目标字段表达式**: `{expression}`
          - **筛选条件**: ...
          - **自定义函数**: ...
          ```sql
          {raw_sql}  (if include_sql)
          ```
          ## 数据质量标记
          ...
        """
    
    def export_html(self, table: str, field: str, **kwargs) -> str:
        """导出为 HTML 格式 (Jinja2 模板)。"""
```

**验收标准**:
1. 导出的 Markdown 可在任意 Markdown 渲染器中正确显示
2. 包含完整链路信息（概览 + 每步详情）
3. SQL 代码块格式正确

---

#### 任务 5.2: 新增 `/api/caliber/export` API 端点

**优先级**: P2  
**涉及文件**: `app/api/caliber.py`  
**依赖**: 任务 5.1  
**风险**: 🟢 低

**API 规格**:

```
POST /api/caliber/export
Content-Type: application/json

{
  "table": "EAST5_201_GRJCXXB",
  "field": "KHXM",
  "format": "markdown",
  "include_sql": true,
  "include_source_location": true
}

Response: 
  Content-Type: text/markdown (或 text/html)
  Content-Disposition: attachment; filename="caliber_EAST5_201_GRJCXXB_KHXM.md"
  Body: 文档内容
```

**验收标准**: 下载的文件内容完整，格式正确

---

#### 任务 5.3: 前端导出按钮集成

**优先级**: P2  
**涉及文件**: `static/js/caliber/caliber-export.js`  
**依赖**: 任务 5.2, 任务 4.5  
**风险**: 🟢 低

**实现**:
- Summary Card 上添加"导出口径文档"按钮
- Step Detail Panel 上添加"导出此步骤"按钮
- 调用导出 API，触发浏览器下载

---

#### 任务 5.4: 全链路集成测试

**优先级**: P2  
**涉及文件**: `tests/test_caliber_integration.py` (新建)  
**依赖**: Phase 1-4 完成  
**风险**: 🟢 低

**测试场景**:

| # | 场景 | 验证点 |
|---|------|--------|
| 1 | 完整流程: summary → pipeline → step-detail | 三个 API 串联返回一致数据 |
| 2 | 导出 Markdown 内容正确性 | 导出内容包含所有步骤详情 |
| 3 | 大表查询性能 | 响应时间 < 5s (含复杂链路) |
| 4 | 边界情况: 无口径数据 | 优雅返回空/404 |
| 5 | 边界情况: 自引用循环 | 不死循环，返回有限结果 |

---

## 三、任务依赖关系总览

```
Phase 1 (Summary Card)          Phase 2 (Pipeline)           Phase 3 (Step Detail)
┌─────────────────┐            ┌─────────────────┐          ┌─────────────────┐
│ 1.1 数据模型     │            │ 2.1 数据模型     │          │ 3.1 数据模型     │
│       ↓         │            │       ↓         │          │       ↓         │
│ 1.2 构建逻辑     │            │ 2.2 构建引擎     │          │ 3.2 构建逻辑     │
│       ↓         │            │       ↓         │          │   ↓       ↓     │
│ 1.3 API 端点     │            │ 2.3 API 端点     │          │ 3.3 SQL读取 3.4 API│
│       ↓         │            │   ↓       ↓     │          │       ↓         │
│ 1.4 单元测试     │            │ 2.4 去重  2.5 测试│          │ 3.5 单元测试     │
│       ↓         │            │       ↓         │          │       ↓         │
│ 1.5 集成验证     │            │ 2.6 集成验证     │          │ 3.6 集成验证     │
└─────────────────┘            └─────────────────┘          └─────────────────┘
         ↘                              ↓                            ↙
          ────────────────────────────────────────────────────────────
                                        ↓
                            Phase 4 (前端三层视图)
                     ┌──────────────────────────────────┐
                     │ 4.1 目录搭建                      │
                     │   ↓         ↓          ↓        │
                     │ 4.2 Card  4.3 Pipeline  4.4 Panel│
                     │      ↘      ↓        ↙         │
                     │        4.5 联动集成               │
                     │          ↓        ↓              │
                     │      4.6 样式   4.7 E2E 验证     │
                     └──────────────────────────────────┘
                                        ↓
                            Phase 5 (导出 + 集成)
                     ┌──────────────────────────────────┐
                     │ 5.1 导出引擎  → 5.2 API → 5.3 UI│
                     │                      ↓           │
                     │               5.4 集成测试        │
                     └──────────────────────────────────┘
```

**关键路径**: Phase 1-3 可并行开发 → Phase 4 依赖 Phase 1-3 → Phase 5 依赖 Phase 4

---

## 四、风险评估与缓解

| # | 风险 | 概率 | 影响 | 缓解策略 |
|---|------|------|------|---------|
| 1 | Pipeline 构建在多路径场景下节点去重困难 | 中 | 视图数据不正确 | 统一使用 `SHORT_TABLE.FIELD` 作为 node_id；增加单元测试覆盖多路径场景 |
| 2 | raw_sql 读取可能因文件路径变动而失败 | 中 | Step Detail 无法显示原始 SQL | 降级策略: 使用 CaliberInfo.raw_sql_fragment (截断版)；前端显示"源文件不可用"提示 |
| 3 | D3.js Pipeline 在节点多(>20)时布局混乱 | 低 | 可视化不清晰 | 限制最大渲染节点数；超出时折叠中间层；提供缩放+拖拽 |
| 4 | 技术口径摘要在复杂链路下过长 | 中 | 概览卡溢出 | 摘要限制最多 3 个中间步骤；超出显示 "...({n} steps)..." |
| 5 | CaliberTracer 返回空链路(某些字段无解析数据) | 高 | 整个三层视图无法展示 | 在 Summary Card 级别显示"该字段暂无完整口径数据"提示；引导用户重新解析 |
| 6 | 前端组件加载顺序问题 | 低 | JS 报错 | 使用 ES6 Module 或确保 script 加载顺序；添加 DOMContentLoaded 检查 |
| 7 | 大量 WHERE/JOIN 条件在 Step Detail 中溢出 | 中 | 面板过长难以阅读 | 条件超过 10 条时默认折叠，显示"展开全部 ({n} 条)" |

---

## 五、文件修改清单

### 新建文件

| 文件 | Phase | 用途 |
|------|-------|------|
| `tests/test_summary_card.py` | 1 | Summary Card 单元测试 |
| `tests/test_pipeline_view.py` | 2 | Pipeline View 单元测试 |
| `tests/test_step_detail.py` | 3 | Step Detail 单元测试 |
| `static/js/caliber/summary-card.js` | 4 | Summary Card 前端组件 |
| `static/js/caliber/pipeline-view.js` | 4 | Pipeline View 前端组件 |
| `static/js/caliber/step-detail.js` | 4 | Step Detail Panel 前端组件 |
| `static/js/caliber/caliber-export.js` | 5 | 导出功能前端 |
| `static/css/caliber.css` | 4 | 口径功能样式 |
| `core/caliber_exporter.py` | 5 | 导出引擎 |
| `tests/test_caliber_integration.py` | 5 | 集成测试 |

### 修改文件

| 文件 | Phase | 修改内容 |
|------|-------|---------|
| `core/models.py` | 1, 2, 3 | 新增 CaliberSummaryCard, PipelineNode/Edge/Branch/View, StepDetail 等数据模型 |
| `app/services/caliber_service.py` | 1, 2, 3 | 新增 build_summary_card(), build_pipeline_view(), build_step_detail() 方法 |
| `app/api/caliber.py` | 1, 2, 3, 5 | 新增 /summary, /pipeline, /step-detail, /export 端点 |
| `static/index.html` | 4 | 引入新的 JS/CSS 文件，调整口径 Tab 布局 |

---

## 六、验收里程碑

| 里程碑 | 验收标准 | 可交付物 |
|--------|---------|---------|
| **M1: API 层完成** (Phase 1-3) | 三个新 API (`/summary`, `/pipeline`, `/step-detail`) 均可正常返回数据；单元测试通过 | API 文档 + 测试报告 |
| **M2: 前端完成** (Phase 4) | 完整交互流程: 输入查询 → 概览卡 → Pipeline 图 → 点击步骤 → 详情面板。全流程无断点 | 可演示的前端页面 |
| **M3: 导出完成** (Phase 5) | 点击"导出口径文档" → 下载 Markdown 文件，内容完整可读 | 导出文件样例 |
| **M4: 全量验收** | 查询一个实际业务字段 (如 EAST5_201 表的某字段)，三层视图 + 导出均正常工作 | 完整系统演示 |

---

## 七、执行建议

### 并行策略

- **Phase 1, 2, 3** 的数据模型 (任务 x.1) 可同时进行
- **Phase 1, 2, 3** 的服务层 (任务 x.2) 在各自数据模型完成后可并行
- **Phase 4** 必须等待 Phase 1-3 的 API 端点完成
- **Phase 5** 可与 Phase 4 后期并行（导出引擎不依赖前端）

### 渐进交付

1. 先完成 Phase 1 (Summary Card) 并上线 — 即时提供价值
2. 再完成 Phase 3 (Step Detail) — 解决"看不懂怎么算的"核心痛点
3. 最后完成 Phase 2 (Pipeline) — 提供宏观可视化
4. Phase 5 作为增值交付

### 向后兼容保证

- 所有新增 API 端点为独立路由，不修改现有 `/api/caliber/trace` 等接口
- 所有新增数据模型为独立 dataclass，不修改现有 `CaliberInfo` / `CaliberResult` 结构
- 前端新组件在独立目录，不修改现有 `lineage-graph.js` / `detail-panel.js`
- 口径 Tab 原有功能保持不变，新三层视图为增量新增

---

*文档版本: v1.0*  
*生成日期: 2026-05-18*  
*适用项目: 数据血缘分析系统 v2.1.0*
