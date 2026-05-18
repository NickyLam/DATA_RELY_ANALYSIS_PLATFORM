# 数据血缘分析平台 — 理想系统设计规范

> **文档类型**：设计规范（架构评估与差距分析报告）
> **日期**：2026-05-18
> **范围**：系统架构评估、理想设计、差距分析

---

## 1. 当前架构评估

### 1.1 系统概述

当前系统是一个基于 Python 的数据血缘分析平台，通过解析 Oracle 存储过程（`.prc`）和表定义文件（`.tab`）构建字段级数据血缘关系，通过 HTTP API 提供血缘数据查询，前端使用 D3.js 渲染有向图。

**关键数据规模**：3,041 张表，1,754 个存储过程，冷启动约需 6-8 分钟。

### 1.2 当前组件清单

| 层级 | 组件 | 文件 | 职责 |
|------|------|------|------|
| 解析层 | 表结构解析器 | `core/table_parser.py` | `.tab` 文件 → `TableInfo` |
| 解析层 | 存储过程解析器 | `core/procedure_parser.py` | `.prc` 文件 → `ProcedureInfo`、`FieldMapping`、`TableLineage` |
| 解析层 | 字段清洗器 | `core/field_cleaner.py` | 列名规范化、别名解析 |
| 解析层 | 表名解析器 | `core/table_name_resolver.py` | Schema 限定表名解析 |
| 解析层 | 指标配置解析器 | `core/indicator_config_parser.py` | 基于 Excel 的指标配置解析 |
| 解析层 | 指标 SQL 解析器 | `core/indicator_sql_parser.py` | 指标 SQL 表达式解析 |
| 核心层 | 血缘追溯引擎 | `core/lineage_tracer.py` | BFS 上游/下游字段追溯 |
| 核心层 | 口径提取器 | `core/caliber_extractor.py` | WHERE/JOIN/CTE 条件提取 |
| 核心层 | 口径追溯引擎 | `core/caliber_tracer.py` | 带条件累积的 BFS（独立实现） |
| 核心层 | 指标图构建器 | `core/indicator_graph_builder.py` | 指标依赖关系图构建 |
| 核心层 | 层级检测器 | `core/layer_detector.py` | 表到层级的分类（ODS/DIIS/BASE/MDL/APP/EAST） |
| 核心层 | SQL 边界检测器 | `core/sql_boundary_detector.py` | 存储过程内 DML 边界检测 |
| 核心层 | 数据校验器 | `core/data_validator.py` | 数据质量校验 |
| API层 | HTTP 服务 | `api_server.py` | REST API + 静态文件服务 |
| 前端 | 展示层 Tab | `static/js/display-tab.js` | D3.js 图谱渲染 |
| 前端 | 口径 Tab | `static/js/caliber-tab.js` | Pipeline 可视化 v3.0 |
| 模型层 | 数据模型 | `core/models.py` | 所有共享数据类 |
| 模型层 | 指标模型 | `core/indicator_models.py` | 指标专用数据类 |

### 1.3 当前架构优势

1. **多策略字段解析**：BFS 追溯引擎采用 5 级回退策略（索引查找 → 模糊匹配 → Schema 变体合并 → TMP 桥接 → 过程扫描），有效处理 Oracle Schema 变体复杂性（O_ICL_*/ICL.*/ICL.V_*）。
2. **丰富的口径提取**：`CaliberExtractor` 提取 WHERE、JOIN、GROUP BY、HAVING、CTE、自定义函数、窗口函数、子查询、步骤隔离条件。
3. **双向追溯**：同时支持上游和下游 BFS 追溯。
4. **指标感知**：独立的指标模型（`IndicatorCalcBase`、`IndicatorCalcGL`）和图构建器，用于指标类字段血缘。
5. **口径链去重**：公共前缀检测实现口径链语义去重。

### 1.4 当前架构不足

1. **无持久化存储**：所有数据存于内存，每次重启需 6-8 分钟冷启动。
2. **单体耦合**：`api_server.py` 包含 1,289 行代码，混合路由、业务逻辑、序列化、图转换、口径链构建。
3. **逻辑重复**：`_bare_table()` 在 `api_server.py` 和 `lineage_tracer.py` 中各实现一份；图转换逻辑（`_result_to_graph`）与 `LineageTracer.to_graph_result()` 重复。
4. **无明细/指标字段区分**：系统对所有字段统一使用 BFS 追溯，未区分基础指标、总账指标和明细字段的不同追溯策略。
5. **线性扫描回退**：索引未命中时模糊匹配遍历所有 key（O(N)），当前规模可接受但不可扩展。
6. **单进程服务**：`http.server.HTTPServer` 单线程阻塞，无并发支持。
7. **无增量更新**：新增或修改单个 `.prc` 需要全量重新初始化。

---

## 2. 理想系统设计规范

### 2.1 架构总览

```
┌─────────────────────────────────────────────────────────────────┐
│                          展示层                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────────────┐ │
│  │  关系图视图   │  │  管线视图     │  │  指标拓扑视图         │ │
│  │ (D3.js/SVG)  │  │ (Pipeline)   │  │  (D3.js/SVG)          │ │
│  └──────────────┘  └──────────────┘  └───────────────────────┘ │
├─────────────────────────────────────────────────────────────────┤
│                         API 网关层                               │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────────┐  │
│  │ 表查询API │ │血缘查询  │ │口径查询  │ │指标查询API       │  │
│  │          │ │API       │ │API       │ │                  │  │
│  └──────────┘ └──────────┘ └──────────┘ └──────────────────┘  │
├─────────────────────────────────────────────────────────────────┤
│                        服务层                                    │
│  ┌───────────────┐  ┌───────────────┐  ┌──────────────────┐   │
│  │ 明细字段追溯  │  │ 基础指标追溯  │  │ 总账指标追溯     │   │
│  │ 服务          │  │ 服务          │  │ 服务             │   │
│  │ (完整BFS)     │  │ (BFS+条件)    │  │ (指标图遍历)     │   │
│  └───────────────┘  └───────────────┘  └──────────────────┘   │
│  ┌───────────────┐  ┌───────────────┐                          │
│  │ 图转换服务    │  │ 口径构建服务  │                          │
│  └───────────────┘  └───────────────┘                          │
├─────────────────────────────────────────────────────────────────┤
│                       追溯引擎层                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐ │
│  │ Schema感知   │  │ 条件累积    │  │ 多策略解析          │ │
│  │ BFS引擎      │  │ BFS引擎      │  │ 引擎                │ │
│  └──────────────┘  └──────────────┘  └──────────────────────┘ │
├─────────────────────────────────────────────────────────────────┤
│                        存储层                                    │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │
│  │ 图数据库 │  │ 关系存储 │  │ 搜索索引 │  │ 缓存层       │  │
│  │(Neo4j/   │  │ (SQLite) │  │(Whoosh/  │  │(Redis/       │  │
│  │ NetworkX)│  │          │  │ SQLite FTS)│  │ 内存)        │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────────┘  │
├─────────────────────────────────────────────────────────────────┤
│                        解析层                                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐ │
│  │ 表结构解析器 │  │ 存储过程    │  │ 指标配置解析器       │ │
│  │              │  │ 解析器      │  │                      │ │
│  └──────────────┘  └──────────────┘  └──────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 数据模型设计

#### 2.2.1 核心实体

```yaml
Table（表）:
  主键: bare_table_name                    # 归一化逻辑标识符
  属性:
    - full_names: list[string]              # 所有 schema 限定的别名
    - schema: string
    - layer: LayerType                      # ODS/DIIS/BASE/MDL/APP/EAST/CONFIG/OTHER
    - comment: string
    - is_temp: boolean
    - column_count: integer
  关系:
    - has_columns → Column (1:N)
    - processed_by → Procedure (M:N)
    - upstream_of → Table (M:N, 经由 TableLineage)
    - downstream_of → Table (M:N, 经由 TableLineage)

Column（字段）:
  主键: (bare_table_name, column_name)
  属性:
    - data_type: string
    - nullable: boolean
    - comment: string
    - is_primary_key: boolean
    - field_category: enum                  # DETAILED | BASIC_INDICATOR | GL_INDICATOR
  关系:
    - belongs_to → Table (N:1)
    - source_of → FieldMapping (1:N)
    - target_of → FieldMapping (1:N)

FieldMapping（字段映射）:
  主键: (source_bare_table, source_column, target_bare_table, target_column, procedure)
  属性:
    - transform_logic: string
    - confidence: float
    - operation_type: SQLOperationType
  关系:
    - source → Column (N:1)
    - target → Column (N:1)
    - produced_by → Procedure (N:1)
    - has_caliber → CaliberInfo (1:1)

Procedure（存储过程）:
  主键: full_name
  属性:
    - schema: string
    - description: string
    - file_path: string
  关系:
    - reads_from → Table (M:N, source_tables)
    - writes_to → Table (M:N, target_tables)
    - uses_temp → Table (M:N, temp_tables)
    - contains → SQLOperation (1:N)

SQLOperation（SQL操作）:
  主键: (procedure, step_num)
  属性:
    - op_type: INSERT | MERGE | UPDATE
    - target_table: string
    - sql_block: string
    - start_line: integer
    - end_line: integer

CaliberInfo（口径信息）:
  主键: (field_mapping_id)
  属性:
    - where_conditions: list[SQLCondition]
    - join_conditions: list[SQLCondition]
    - group_by_clause: string
    - having_clause: string
    - step_isolated_where: list[SQLCondition]
    - step_isolated_join: list[SQLCondition]
    - cte_definitions: list[string]
    - custom_functions: list[string]
    - full_expression: string
    - operation_type: string
    - select_columns: list[SelectColumnMapping]
    - distinct_flag: boolean
    - set_operation: string
    - window_functions: list[string]

TableLineage（表级血缘）:
  主键: (source_bare_table, target_bare_table, procedure)
  属性:
    - procedure: string
  关系:
    - source → Table (N:1)
    - target → Table (N:1)
    - produced_by → Procedure (N:1)

IndicatorDef（指标定义）:
  主键: index_no
  属性:
    - index_name: string
    - index_bclass: string                 # "1"=基础, "2"=衍生, "3"=特殊, "6"=绩效
    - stat_period: string
  关系:
    - has_measures → IndicatorMeasureDef (1:N)
    - depends_on → IndicatorDef (M:N, 经由 IndicatorRel)
    - computed_by_base → IndicatorCalcBase (1:N)
    - computed_by_gl → IndicatorCalcGL (1:N)
```

#### 2.2.2 Schema 归一化（规范标识）

所有表引用**必须**归一化为**规范裸名**，使用唯一的权威函数。规范形式消除 Schema 变体：

| 原始形式 | 规范形式 | 规则 |
|---|---|---|
| `RRP_MDL.O_ICL_CMM_XXX` | `ICL_CMM_XXX` | 去掉 O_ICL_* 的 O_ 前缀 |
| `ICL.V_CMM_XXX` | `ICL_CMM_XXX` | 去掉 V_ 前缀，加 ICL_ 前缀 |
| `ICL.CMM_XXX` | `ICL_CMM_XXX` | 加 ICL_ 前缀 |
| `RRP_EAST.EAST5_KHXXB` | `EAST5_KHXXB` | 去掉 Schema 前缀 |

**不变量**：此函数只有**一个**实现，所有层共享。禁止重复实现。

#### 2.2.3 字段分类体系

字段必须分为三类，以实现差异化追溯：

```yaml
DETAILED（明细字段）:
  描述: "非指标数据字段，需完整追溯上游来源直到源头"
  追溯策略: "完整 BFS，穿越表/字段关系直到源端"
  展示要求: "完整链路，每跳显示转换逻辑"

BASIC_INDICATOR（基础指标）:
  描述: "基于原始数据按特定算法计算的基础指标"
  追溯策略: "带条件累积的 BFS，每层展示该层的 JOIN/WHERE 条件"
  展示要求: "逐层隔离条件（step-isolated）、累积条件、转换逻辑"

GL_INDICATOR（总账指标）:
  描述: "通过指标依赖图追溯到总账科目账户的指标"
  追溯策略: "指标图遍历 → 总账科目解析（subj_no + sign_no + amt_val）"
  展示要求: "指标到指标链路、终端总账科目详情"
```

### 2.3 图表示与遍历算法

#### 2.3.1 图模型

系统使用**多层有向图**，包含两个不同的图结构：

**图A：字段级血缘图**（用于明细和基础指标字段）
- **节点**：`(bare_table_name, column_name)` 元组
- **边**：`FieldMapping` 记录，附带 procedure/transform 元数据
- **边属性**：`transform_logic`、`confidence`、`operation_type`、`procedure`
- **方向**：源字段 → 目标字段（数据流方向）

**图B：指标依赖图**（用于总账指标字段）
- **节点**：`(index_no, index_measure)` 元组，加上终端总账科目节点
- **边**：`IndicatorRel` 依赖 + `IndicatorCalcGL` 总账映射
- **边属性**：`algo_type`、`condition_sql`、`measure_sql`、`gl_subj_no`、`gl_sign_no`
- **边类型**：`data_flow`、`calc_dependency`、`procedure_step`、`gl_mapping`

#### 2.3.2 遍历算法

**算法1：Schema 感知 BFS（明细字段）**
```
输入: (target_table, target_field, max_depth, direction)
输出: list[FieldLineageChain]

1. 将输入归一化为规范裸名
2. 初始化 BFS 队列，根节点入队
3. 对每个出队节点 (current_table, current_field):
   a. 使用规范索引 (O(1)) 查找 target = (current_table, current_field) 的 FieldMapping
   b. 对每个找到的 FieldMapping:
      i.   将 source 归一化为规范形式
      ii.  检查 visited 集合（同时检查完整 key 和裸名 key）
      iii. 若未访问:
           - 创建 BFS 树节点，记录父链接
           - 加入 visited 集合
           - 入队
4. 从 BFS 树构建链路（叶子→根路径）
5. 按深度排序（最长优先）
```

**算法2：条件累积 BFS（基础指标）**
```
输入: (target_table, target_field, max_depth)
输出: CaliberChain，含逐层条件

1. 与算法1相同的 BFS 结构
2. 额外的逐层处理:
   a. 提取当前映射 procedure 的 SQL 块
   b. 从 SQL 块解析 WHERE/JOIN/CTE 条件
   c. 计算步骤隔离条件（当前 - 已累积）
   d. 为下游步骤累积条件
3. 构建 CaliberChain，步骤按源→目标排序
4. 每个 CaliberInfo 包含:
   - step_isolated_where/join（本步骤独有条件）
   - accumulated conditions（截至本步骤的所有条件）
```

**算法3：指标图遍历（总账指标）**
```
输入: (index_no, index_measure)
输出: IndicatorChain，含总账终端节点

1. 在 IndicatorRel 图中查找指标
2. BFS 遍历指标依赖边:
   a. 对每个依赖:
      - 若 algo_type == "2"（总账）: 解析到总账科目
        (subj_no, sign_no, amt_val)
      - 若 algo_type != "2": 沿依赖链继续
3. 终端节点为总账科目，包含:
   - 科目编号 (subj_no)
   - 方向符号 (sign_no: 借方/贷方)
   - 金额字段 (amt_val)
4. 构建 IndicatorChain，包含:
   - 指标到指标边 (calc_dependency)
   - 指标到总账科目边 (gl_mapping)
```

#### 2.3.3 环路检测

三个算法均必须使用**规范裸名**实现环路检测：

- 维护 `visited: set[str]`，key 为 `bare_table_name.field_name`
- 入队前同时检查完整 key 和裸名 key
- 防止 Schema 变体自引用导致的无限循环（如 `ICL.V_CMM_XXX ↔ RRP_MDL.O_ICL_CMM_XXX`）

### 2.4 存储设计

#### 2.4.1 持久化图存储

血缘图必须持久化，避免 6-8 分钟冷启动：

**方案A：SQLite + 邻接表**（推荐，适合当前规模）
```sql
-- 表
CREATE TABLE tables (
    bare_name TEXT PRIMARY KEY,
    full_names TEXT,        -- schema 限定名的 JSON 数组
    schema_name TEXT,
    layer TEXT,
    comment TEXT,
    is_temp BOOLEAN,
    column_count INTEGER
);

CREATE TABLE columns (
    bare_table TEXT,
    column_name TEXT,
    data_type TEXT,
    nullable BOOLEAN,
    comment TEXT,
    field_category TEXT,    -- DETAILED | BASIC_INDICATOR | GL_INDICATOR
    PRIMARY KEY (bare_table, column_name),
    FOREIGN KEY (bare_table) REFERENCES tables(bare_name)
);

-- 字段映射
CREATE TABLE field_mappings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_bare_table TEXT,
    source_column TEXT,
    target_bare_table TEXT,
    target_column TEXT,
    transform_logic TEXT,
    procedure_name TEXT,
    confidence REAL,
    operation_type TEXT,
    UNIQUE(source_bare_table, source_column, target_bare_table, target_column, procedure_name)
);

-- O(1) 查询索引
CREATE INDEX idx_fm_target ON field_mappings(target_bare_table, target_column);
CREATE INDEX idx_fm_source ON field_mappings(source_bare_table, source_column);
CREATE INDEX idx_fm_procedure ON field_mappings(procedure_name);

-- 表级血缘
CREATE TABLE table_lineages (
    source_bare_table TEXT,
    target_bare_table TEXT,
    procedure_name TEXT,
    PRIMARY KEY (source_bare_table, target_bare_table, procedure_name)
);

-- 口径信息
CREATE TABLE caliber_info (
    field_mapping_id INTEGER PRIMARY KEY,
    where_conditions TEXT,      -- JSON
    join_conditions TEXT,       -- JSON
    group_by_clause TEXT,
    step_isolated_where TEXT,   -- JSON
    step_isolated_join TEXT,    -- JSON
    cte_definitions TEXT,       -- JSON
    full_expression TEXT,
    FOREIGN KEY (field_mapping_id) REFERENCES field_mappings(id)
);

-- 指标定义
CREATE TABLE indicators (
    index_no TEXT PRIMARY KEY,
    index_name TEXT,
    index_bclass TEXT,
    stat_period TEXT
);

-- 指标关系（依赖图）
CREATE TABLE indicator_relations (
    index_no TEXT,
    depend_index_no TEXT,
    PRIMARY KEY (index_no, depend_index_no)
);

-- 全文搜索
CREATE VIRTUAL TABLE tables_fts USING fts5(bare_name, full_names, comment);
```

**方案B：Neo4j**（未来扩展）
- 节点：Table、Column、Procedure、Indicator、GLAccount
- 关系：READS_FROM、WRITES_TO、MAPS_TO、DEPENDS_ON、GL_MAPS
- 遍历：Cypher 查询实现 BFS 路径

#### 2.4.2 缓存层

```yaml
查询缓存:
  范围: "单次查询结果（graph_data, caliber_result）"
  TTL: 300s (5分钟)
  失效策略: "源文件变更检测时失效"
  存储: "内存 LRU，最大 1000 条"

索引缓存:
  范围: "预构建的 BFS 索引（field_mapping_idx, proc_target_idx 等）"
  TTL: "直到源变更"
  存储: "内存映射 SQLite 或 pickle"

搜索缓存:
  范围: "按关键字的表搜索结果"
  TTL: 60s
  存储: "内存 Map + 防抖"
```

#### 2.4.3 冗余消除

当前系统存在显著冗余，必须消除：

| 当前冗余 | 理想方案 |
|---|---|
| `FieldMapping` 对象在 `ProcedureInfo.field_mappings` 和 `LineageTracer.field_mappings` 中重复 | 唯一数据源在 `field_mappings` 表，过程通过外键引用 |
| `TableLineage` 对象内嵌完整 `FieldMapping` 列表 | `TableLineage` 引用 `FieldMapping` ID |
| `_bare_table()` 逻辑在 2 个文件中重复 | 单一模块（`core/canonical.py`）统一导入 |
| `api_server.py` 中的 `_result_to_graph()` 与 `LineageTracer.to_graph_result()` 重复 | 统一 `GraphTransformService` |
| `CaliberInfo` 每次查询时从 SQL 重新提取 | 解析时预计算，存入 `caliber_info` 表 |
| `CaliberTracer` 重复 `LineageTracer` 的 BFS 逻辑 | 共享 BFS 引擎 + 可插拔策略 |

### 2.5 性能优化策略

#### 2.5.1 初始化优化

| 策略 | 当前 | 目标 |
|---|---|---|
| 全量重解析启动 | 6-8 分钟 | < 10秒（从 SQLite 加载） |
| 增量更新 | 不支持 | < 30秒/变更文件 |
| 并行解析 | 顺序执行 | 多线程（4-8 工作线程） |

**增量更新设计**：
```
1. 计算每个源文件的哈希值（内容 MD5）
2. 在 source_files 表中存储哈希
3. 启动时比较当前哈希与存储哈希
4. 仅重新解析变更文件
5. 增量重建受影响的索引
```

#### 2.5.2 查询时优化

| 策略 | 当前 | 目标 |
|---|---|---|
| 字段映射查找 | O(1) 索引 + O(N) 模糊回退 | 始终 O(1)（规范索引） |
| 图序列化 | 每次查询完整重序列化 | 缓存序列化结果 |
| 口径提取 | 每次查询重新读取 .prc 文件 | 解析时预计算 |
| BFS visited 检查 | 字符串集合 | 整数集合（节点 ID） |
| 链路去重 | O(N²) 两两比较 | O(N log N) 排序前缀检查 |

**规范索引设计**：
```
所有查找使用 bare_table_name 作为主键。
Schema 变体映射到相同的规范 key。
查询时不需要模糊匹配。
模糊匹配是解析时关注点，不是查询时关注点。
```

#### 2.5.3 并发模型

```
当前: 单线程 http.server.HTTPServer
理想: ASGI 服务器 (uvicorn + FastAPI/Starlette)
      - API 处理器异步 I/O
      - CPU 密集型 BFS 查询使用线程池
      - 批量操作使用进程池
```

### 2.6 可视化设计

#### 2.6.1 三种可视化模式

**模式1：关系图视图（明细字段）**
- 有向图，节点=表，边=字段映射
- 节点按层级着色（ODS/DIIS/BASE/MDL/APP/EAST）
- 垂直布局：源（上）→ 目标（下）
- 悬停显示边详情：transform_logic、procedure 名
- 当前已通过 D3.js 力导向布局实现

**模式2：管线视图（基础指标）**
- 水平管线，含步骤卡片
- 每张卡片显示：源→目标、JOIN 条件、WHERE 条件
- 累积条件汇总条
- 点击展开步骤详情抽屉
- 当前已实现为 Pipeline v3.0

**模式3：指标拓扑视图（总账指标）**
- 含指标节点和总账科目终端节点的图
- 不同边样式区分 calc_dependency 和 gl_mapping
- 可按 index_bclass 折叠指标集群
- 总账终端节点显示：subj_no、sign、amt_val
- **当前系统尚未实现**

---

## 3. 差距分析：当前 vs 理想

### 3.1 关键差距

| # | 差距 | 当前状态 | 理想状态 | 影响 |
|---|------|---------|---------|------|
| G1 | **无持久化存储** | 所有数据存于内存；6-8分钟冷启动 | SQLite 支持；<10秒启动 | 运维 |
| G2 | **无字段分类区分** | 所有字段统一 BFS 追溯 | 三种追溯策略按字段类型区分 | 功能 |
| G3 | **口径信息未预计算** | 每次查询重新读取 SQL；每步 .prc 文件 I/O | 解析时预计算，存入数据库 | 性能 |
| G4 | **`_bare_table()` 重复实现** | `api_server.py` + `lineage_tracer.py` 各一份 | 单一规范模块 | 可维护性 |
| G5 | **单体 API 服务器** | 1,289行 `api_server.py` 混合所有关注点 | 分层架构 + 服务分离 | 可维护性 |
| G6 | **无指标拓扑可视化** | 总账指标追溯已实现但无可视化 | 三模式可视化系统 | 用户体验 |

### 3.2 重要差距

| # | 差距 | 当前状态 | 理想状态 | 影响 |
|---|------|---------|---------|------|
| G7 | **单线程 HTTP 服务器** | `http.server.HTTPServer`（阻塞） | ASGI + 异步处理器 | 性能 |
| G8 | **查询时模糊匹配** | 索引未命中时 O(N) 扫描 | 规范索引消除查询时模糊匹配 | 性能 |
| G9 | **无增量更新** | 任意变更需全量重解析 | 基于文件哈希的增量更新 | 运维 |
| G10 | **重复 BFS 引擎** | `LineageTracer` + `CaliberTracer` 逻辑相似 | 共享 BFS 核心 + 可插拔策略 | 可维护性 |
| G11 | **无字段分类元数据** | 字段无分类标签 | `field_category: DETAILED/BASIC_INDICATOR/GL_INDICATOR` | 功能 |
| G12 | **图转换逻辑在 API 层** | `_result_to_graph()` 在 `api_server.py` 中 | 专用 `GraphTransformService` | 关注点分离 |
| G13 | **链路去重为 O(N²)** | 两两签名比较 | 排序前缀检查 O(N log N) | 大规模性能 |

### 3.3 次要差距

| # | 差距 | 当前状态 | 理想状态 | 影响 |
|---|------|---------|---------|------|
| G14 | **无查询结果缓存** | 每次查询重新计算 | LRU 缓存 + TTL | 性能 |
| G15 | **层级检测仅基于规则** | 硬编码命名约定 | 可配置规则 + 学习模式 | 扩展性 |
| G16 | **无 API 版本管理** | 单一未版本化 API | 版本化端点（`/api/v1/`） | API 稳定性 |
| G17 | **无健康监控** | 基础 `/health` 端点 | 指标、性能分析、慢查询日志 | 运维 |
| G18 | **硬编码 Schema 变体规则** | `O_ICL_*`/`ICL.V_*` 规则写在代码中 | 可配置同义词映射表 | 扩展性 |
| G19 | **无访问控制** | 开放 API | 基于角色的查询访问 | 安全 |

### 3.4 差距到目标映射

| 目标 | 直接影响的差距 |
|---|---|
| **明细字段分析**（追溯到源端） | G2、G11（无字段区分）、G8（模糊匹配延迟） |
| **基础指标分析**（逐层 JOIN/WHERE） | G2、G3（口径未预计算）、G10（重复 BFS） |
| **总账指标分析**（追溯到总账科目） | G2、G6（无总账拓扑可视化）、G11 |
| **可视化** | G6（无指标拓扑视图）、G12（图转换在 API 层） |
| **性能** | G1（冷启动）、G3（重新读文件）、G7（单线程）、G8（模糊匹配）、G14（无缓存） |
| **非冗余存储** | G4（重复 bare_table）、G5（单体）、G9（无增量）、G10（重复 BFS） |

---

## 4. 理想数据流

### 4.1 解析时数据流

```
.prc/.tab 文件
       │
       ▼
  ┌─────────────┐     ┌──────────────────┐
  │ 表结构解析器 │     │ 存储过程解析器     │
  └──────┬──────┘     └────────┬─────────┘
         │                     │
         ▼                     ▼
  ┌─────────────┐     ┌──────────────────┐
  │ 规范归一化器 │     │ 字段映射提取器     │
  └──────┬──────┘     └────────┬─────────┘
         │                     │
         ▼                     ▼
  ┌─────────────────────────────────────┐
  │           字段分类器                  │
  │  (将每个字段标记为 DETAILED /         │
  │   BASIC_INDICATOR / GL_INDICATOR)    │
  └────────────────┬────────────────────┘
                   │
         ┌─────────┼──────────┐
         ▼         ▼          ▼
  ┌──────────┐ ┌──────────┐ ┌──────────────┐
  │ 口径     │ │指标图    │ │ Schema       │
  │ 预计算   │ │构建器    │ │ 同义词表     │
  └────┬─────┘ └────┬─────┘ └──────┬───────┘
       │            │              │
       ▼            ▼              ▼
  ┌──────────────────────────────────────┐
  │         持久化存储 (SQLite)            │
  └──────────────────────────────────────┘
```

### 4.2 查询时数据流

```
客户端请求 (table, field)
       │
       ▼
  ┌────────────────┐
  │ 字段分类解析器  │
  │                 │──→ DETAILED? ──→ BFS 引擎（算法1）
  │                 │──→ BASIC_INDICATOR? ──→ 条件BFS（算法2）
  │                 │──→ GL_INDICATOR? ──→ 指标图遍历（算法3）
  └────────────────┘
       │
       ▼
  ┌────────────────┐
  │ 图转换服务      │
  └────────────────┘
       │
       ▼
  ┌────────────────┐
  │ 可视化路由器    │──→ 关系图 / 管线视图 / 指标拓扑
  └────────────────┘
```

---

## 5. 按代码库文件的差距清单

| 文件 | 识别的问题 |
|---|---|
| `api_server.py` | 单体文件（1,289行）；包含图转换（`_result_to_graph`）、口径链构建（`_chains_to_caliber_result`）、重复的 `_bare_table()`、内联文件 I/O 提取 SQL 块、无缓存、无异步 |
| `core/lineage_tracer.py` | 重复的 `_bare_table()`；O(N) 模糊匹配回退；`to_graph_result()` 与 `api_server._result_to_graph()` 重复；索引 key 使用原始名称而非裸名（非规范索引） |
| `core/caliber_tracer.py` | 重复 `LineageTracer` 的 BFS 逻辑；条件累积功能可用但与主追溯引擎隔离 |
| `core/procedure_parser.py` | 解析逻辑扎实；但 `field_mappings` 以列表形式存储在 `ProcedureInfo` 上（无数据库规范化）；TMP 桥接逻辑在追溯器中而非解析时 |
| `core/caliber_extractor.py` | 条件提取功能良好；但在查询时调用而非解析时 |
| `core/models.py` | `FieldMapping` 无 `field_category`；`CaliberInfo` 字段过多（应规范化）；`TableLineage` 内嵌完整 `FieldMapping` 列表 |
| `core/indicator_graph_builder.py` | 功能可用但与主 API 断开；无可视化端点 |
| `core/layer_detector.py` | 硬编码规则；不可配置 |
| `core/sql_boundary_detector.py` | DML 边界检测良好但仅在查询时使用，未在解析时使用 |
| `core/table_parser.py` | 简单实用；无问题 |
| `static/js/display-tab.js` | D3.js 图谱可用但边上无字段级详情 |
| `static/js/caliber-tab.js` | Pipeline v3.0 可用；步骤详情抽屉功能正常 |
