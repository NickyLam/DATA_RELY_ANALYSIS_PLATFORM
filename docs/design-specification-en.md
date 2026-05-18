# Data Lineage Analysis System — Design Specification & Gap Analysis

# 数据血缘分析系统 — 设计规格与差距分析

---

## Part I: Current Architecture Assessment
## 第一部分：当前架构评估

### Overall Structure
### 总体结构

The system follows a **dual-TAB architecture** (parsing layer + presentation layer) built on:
系统采用 **双TAB架构**（解析层 + 展示层），技术栈如下：

- **Backend**: FastAPI + Python 3.11+, in-memory data store loaded from a single monolithic JSON file (`lineage_data.json` — 2.5 GB)
- **后端**: FastAPI + Python 3.11+，从单一巨型 JSON 文件（`lineage_data.json`，2.5 GB）加载到内存
- **Frontend**: Vanilla JavaScript + D3.js, served as static files
- **前端**: 原生 JavaScript + D3.js，静态文件服务
- **Communication**: SSE for real-time parse progress, REST APIs for queries
- **通信**: SSE 实时解析进度推送 + REST API 查询

### Core Modules
### 核心模块

| Module / 模块 | Role / 作用 | Size / 大小 |
|---|---|---|
| `core/procedure_parser.py` | Regex-based stored procedure parsing (INSERT/MERGE/UPDATE) / 基于正则的存储过程解析 | 43 KB |
| `core/lineage_tracer.py` | BFS field-level upstream/downstream tracing / BFS 字段级上下游追溯 | 48 KB |
| `core/caliber_tracer.py` | BFS caliber (indicator specification) tracing with conditions / 带条件的口径追溯 | 39 KB |
| `core/caliber_extractor.py` | SQL condition extraction (WHERE/JOIN/GROUP BY) / SQL 条件提取 | 37 KB |
| `core/indicator_graph_builder.py` | Indicator dependency graph construction + BFS traversal / 指标依赖图构建与遍历 | 28 KB |
| `app/repository.py` | Data access layer (JSON load → in-memory dict) / 数据访问层 | 8.5 KB |
| `app/services/lineage_service.py` | Query orchestration with caching / 查询编排与缓存 | 34 KB |

### Three Analysis Paths
### 三种分析路径

1. **Field Lineage** (`LineageTracer`): BFS tracing through `FieldMapping` records, resolving `table → procedure → source field` chains.

   **字段血缘** (`LineageTracer`): 通过 `FieldMapping` 记录进行 BFS 追溯，解析 `表 → 存储过程 → 来源字段` 链路。

2. **Caliber (Indicator Spec)** (`CaliberTracer`): Same BFS structure but carrying WHERE/JOIN/GROUP BY conditions per step.

   **指标口径** (`CaliberTracer`): 相同的 BFS 结构，但每步携带 WHERE/JOIN/GROUP BY 条件。

3. **Indicator Lineage** (`IndicatorGraphBuilder`): Graph of indicator-to-indicator dependencies (base indicators, GL indicators, derived indicators) parsed from Excel configuration.

   **指标血缘** (`IndicatorGraphBuilder`): 从 Excel 配置解析的指标间依赖图（基础指标、总账指标、衍生指标）。

---

## Part II: Ideal System Design Specification
## 第二部分：理想系统设计规格

### 1. Data Model Design
### 1. 数据模型设计

#### 1.1 Entity Layer (Metadata) / 实体层（元数据）

```
Table / 表 {
    id: UUID
    schema: string                          -- 模式名
    table_name: string                      -- 表名
    full_name: string (schema.table_name, unique)  -- 全限定名，唯一
    layer: enum(ODS, DWD, DWS, ADS, EAST, CONFIG)  -- 数据分层
    is_temp: boolean                        -- 是否临时表
    columns: [Column]                       -- 字段列表
    source_file: string                     -- 来源文件路径
}

Column / 字段 {
    id: UUID
    table_id: FK → Table                    -- 所属表
    name: string                            -- 字段名
    data_type: string                       -- 数据类型
    nullable: boolean                       -- 是否可空
    comment: string                         -- 注释说明
}

Procedure / 存储过程 {
    id: UUID
    schema: string                          -- 模式名
    proc_name: string                       -- 过程名
    full_name: string (unique)              -- 全限定名，唯一
    source_file: string                     -- 来源文件路径
    file_hash: string                       -- 文件哈希值（用于增量解析）
}
```

#### 1.2 Relationship Layer (Lineage Edges) / 关系层（血缘边）

```
FieldMapping / 字段映射 {
    id: UUID
    source_table_id: FK → Table             -- 源表
    source_column_id: FK → Column           -- 源字段
    target_table_id: FK → Table             -- 目标表
    target_column_id: FK → Column           -- 目标字段
    procedure_id: FK → Procedure            -- 加工过程
    transform_logic: string                 -- 转换逻辑
    confidence: float                       -- 置信度
    operation_type: enum(INSERT_SELECT, MERGE, UPDATE, CTAS)  -- 操作类型
    step_sequence: int                      -- 在过程中的执行序号
}

StepCondition / 步骤条件 {
    id: UUID
    field_mapping_id: FK → FieldMapping     -- 所属字段映射
    condition_type: enum(WHERE, JOIN, GROUP_BY, HAVING, ORDER_BY)  -- 条件类型
    raw_text: string                        -- 原始SQL文本
    tables_involved: [string]               -- 涉及的表
    fields_involved: [string]               -- 涉及的字段
}
```

#### 1.3 Indicator Layer / 指标层

```
Indicator / 指标 {
    id: UUID
    index_no: string (unique)               -- 指标编号，唯一
    index_name: string                      -- 指标名称
    index_type: enum(base, derived, gl, special, performance)  -- 指标类型
    classification: {bclass, level1, level2, level3}  -- 分类体系
    business_caliber: string                -- 业务口径
    technical_caliber: string               -- 技术口径
}

IndicatorMeasure / 指标度量 {
    id: UUID
    indicator_id: FK → Indicator            -- 所属指标
    measure_code: string (001-029)          -- 度量编码
    algo_type: enum(standard, gl, annualized, convert)  -- 算法类型
    source_table: string                    -- 源表
    measure_sql: string                     -- 度量SQL
    condition_sql: string                   -- 条件SQL
}

IndicatorDependency / 指标依赖 {
    id: UUID
    parent_indicator_id: FK → Indicator     -- 父指标
    child_indicator_id: FK → Indicator      -- 子指标
    dependency_type: enum(derivation, composition)  -- 依赖类型
}

GLMapping / 总账映射 {
    id: UUID
    indicator_id: FK → Indicator            -- 所属指标
    measure_code: string                    -- 度量编码
    subject_no: string                      -- 科目号
    sign_no: int                            -- 符号（借方/贷方）
    amt_val: string                         -- 金额字段
    length_val: int                         -- 科目匹配长度
}
```

### 2. Graph Representation
### 2. 图表示

#### 2.1 Storage Format / 存储格式

The ideal system uses a **native graph structure** with adjacency lists stored in a persistent, queryable format:

理想系统使用 **原生图结构**，邻接表以持久化、可查询的格式存储：

- **Forward Adjacency** (for downstream queries): `{source_node → [(target_node, edge_metadata)]}`
- **正向邻接表**（用于下游查询）：`{源节点 → [(目标节点, 边元数据)]}`
- **Reverse Adjacency** (for upstream queries): `{target_node → [(source_node, edge_metadata)]}`
- **反向邻接表**（用于上游查询）：`{目标节点 → [(源节点, 边元数据)]}`
- **Node types**: `table_field` (table.column), `indicator` (index_no.measure)
- **节点类型**：`table_field`（表.字段）、`indicator`（指标编号.度量）
- **Edge types**: `data_flow`, `condition_binding`, `indicator_dependency`, `gl_mapping`
- **边类型**：`data_flow`（数据流）、`condition_binding`（条件绑定）、`indicator_dependency`（指标依赖）、`gl_mapping`（总账映射）

#### 2.2 Graph Database Choice / 图数据库选型

For a system with millions of field-level edges, the ideal architecture uses:

对于拥有数百万字段级边的系统，理想架构采用：

- **Primary**: A graph database (Neo4j or Apache AGE on PostgreSQL) for complex traversal queries
- **主要方案**: 图数据库（Neo4j 或 PostgreSQL 上的 Apache AGE），用于复杂遍历查询
- **Fallback**: Compressed adjacency lists in a relational DB with recursive CTEs for simpler deployments
- **降级方案**: 关系型数据库中压缩的邻接表 + 递归 CTE，适用于简化部署

#### 2.3 Traversal Algorithms / 遍历算法

| Query Type / 查询类型 | Algorithm / 算法 | Optimization / 优化 |
|---|---|---|
| Field upstream tracing / 字段上游追溯 | BFS with cycle detection / BFS + 循环检测 | Visited-set deduplication, max-depth cutoff / 访问集去重 + 最大深度截断 |
| Field downstream tracing / 字段下游追溯 | BFS on forward adjacency / 正向邻接 BFS | Same / 同上 |
| Indicator dependency resolution / 指标依赖解析 | DFS topological sort / DFS 拓扑排序 | Memoized results per indicator / 按指标缓存结果 |
| Caliber condition accumulation / 口径条件累积 | BFS with per-edge condition propagation / BFS + 逐边条件传递 | Condition deduplication per chain / 链级条件去重 |
| Impact analysis / 影响分析 | Bidirectional BFS / 双向 BFS | Early termination on convergence / 收敛时提前终止 |

### 3. Performance Optimization Strategies
### 3. 性能优化策略

#### 3.1 Incremental Parsing / 增量解析

- **File hash registry**: Track SHA-256 of each `.prc`/`.tab` file. Only re-parse files whose hash changed.
- **文件哈希注册表**: 跟踪每个 `.prc`/`.tab` 文件的 SHA-256 哈希值，仅重新解析变更文件。
- **Procedure-level granularity**: When a procedure is re-parsed, delete only its edges from the graph, then insert new ones (current system does this correctly).
- **过程级粒度**: 重新解析某个过程时，仅删除其对应的边并插入新边（当前系统已正确实现此逻辑）。

#### 3.2 Query-Time Optimization / 查询时优化

- **Pre-materialized subgraphs**: For frequently-queried tables (EAST reporting tables), pre-compute and cache their full upstream DAG at startup.
- **预物化子图**: 对于频繁查询的表（EAST 报送表），启动时预计算并缓存其完整上游 DAG。
- **Tiered caching**:
- **分层缓存**:
  - L1: In-process LRU cache (current approach) for recent queries
  - L1: 进程内 LRU 缓存（当前方案），用于最近查询
  - L2: Persistent cache (Redis/SQLite) surviving restarts
  - L2: 持久缓存（Redis/SQLite），重启不丢失
- **Graph partitioning**: Partition the lineage graph by data layer (ODS→DWD→DWS→ADS→EAST), allowing layer-constrained traversal.
- **图分区**: 按数据分层（ODS→DWD→DWS→ADS→EAST）分割血缘图，支持分层约束遍历。

#### 3.3 Startup Optimization / 启动优化

- **Lazy loading**: Don't load full 2.5 GB JSON into memory at startup. Use memory-mapped file or a database.
- **延迟加载**: 启动时不加载完整 2.5 GB JSON 到内存，使用内存映射文件或数据库。
- **Background graph construction**: Build indexes asynchronously after HTTP server starts accepting requests.
- **后台图构建**: HTTP 服务开始接受请求后，异步构建索引。
- **Compressed serialization**: Replace JSON with MessagePack or Parquet for metadata storage (10-30x size reduction).
- **压缩序列化**: 用 MessagePack 或 Parquet 替代 JSON 存储元数据（10-30 倍体积缩减）。

### 4. Storage Efficiency Mechanisms
### 4. 存储效率机制

#### 4.1 Normalization / 规范化

- **String interning**: Table names, field names, procedure names appear millions of times across edges. Use integer IDs with a lookup dictionary.
- **字符串驻留**: 表名、字段名、过程名在边中重复出现数百万次，使用整数 ID + 查找字典替代字符串。
- **Condition deduplication**: Many WHERE/JOIN conditions are identical across multiple field mappings within the same SQL operation. Store conditions once, reference by ID.
- **条件去重**: 同一 SQL 操作中的多个字段映射共享相同的 WHERE/JOIN 条件，条件只存一次，通过 ID 引用。
- **Expression templates**: Transform logic strings (e.g., `NVL(A, 0)`) can be parameterized and stored as templates.
- **表达式模板**: 转换逻辑（如 `NVL(A, 0)`）可参数化并存储为模板。

#### 4.2 Storage Format / 存储格式

- **Columnar storage** for bulk analytics: Parquet or Arrow IPC format for the parsed lineage data
- **列式存储**（用于批量分析）：Parquet 或 Arrow IPC 格式存储解析后的血缘数据
- **Row storage** for point queries: SQLite or PostgreSQL for real-time API serving
- **行式存储**（用于点查询）：SQLite 或 PostgreSQL 用于实时 API 服务
- **Separation of hot/cold data**: Frequently-queried lineage edges in memory; historical parse results on disk
- **冷热数据分离**: 高频查询的血缘边驻留内存，历史解析结果存磁盘

---

## Part III: Gap Analysis — Current vs. Ideal
## 第三部分：差距分析 — 当前 vs. 理想

### Critical Gaps / 关键差距

| # | Gap / 差距 | Current State / 当前状态 | Ideal State / 理想状态 | Impact / 影响 |
|---|---|---|---|---|
| 1 | **Monolithic JSON storage** / 巨型 JSON 存储 | Single 2.5 GB `lineage_data.json` loaded entirely into memory / 单一 2.5 GB JSON 全量加载到内存 | Normalized relational/graph DB with indexed access / 带索引的关系/图数据库 | Startup takes 10+ seconds; memory usage ~5 GB; no partial loading possible / 启动 10+ 秒，内存 ~5 GB，无法局部加载 |
| 2 | **No persistent storage layer** / 无持久存储层 | All data lives in process memory; restart = full re-parse or re-load from JSON / 数据全在进程内存，重启=全量重解析或重新加载 | Database backend (SQLite minimum, PostgreSQL ideal) / 数据库后端（最低 SQLite，理想 PostgreSQL） | Data durability; query flexibility; concurrent access / 数据持久化、查询灵活性、并发访问 |
| 3 | **Regex-based SQL parsing** / 基于正则的 SQL 解析 | Hand-written regex patterns in `procedure_parser.py` for INSERT/MERGE/UPDATE / 手写正则匹配 INSERT/MERGE/UPDATE | AST-based SQL parser (sqlglot, sqlparse with semantic analysis) / 基于 AST 的 SQL 解析器（sqlglot 等） | Fragile parsing; misses complex CTEs, recursive queries, dynamic SQL; false positives on regex boundaries / 解析脆弱、遗漏复杂 CTE/递归查询/动态SQL、正则误判 |
| 4 | **No graph database** / 无图数据库 | In-memory adjacency lists rebuilt on every startup / 每次启动重建内存邻接表 | Persistent graph with pre-built traversal indexes / 持久化图 + 预构建遍历索引 | Every startup re-computes all indexes; no persistence of traversal results / 每次启动重算所有索引，遍历结果不持久 |
| 5 | **Duplicate data in output** / 输出数据重复 | `caliber_infos` duplicates information already in `field_mappings` with added conditions / `caliber_infos` 重复了 `field_mappings` 中已有信息并附加条件 | Unified edge model with optional condition attachments / 统一边模型 + 可选条件附件 | 2.5 GB JSON contains massive redundancy; same edges stored multiple times with slight variations / 2.5 GB JSON 存在大量冗余，同一边以轻微差异多次存储 |

### Significant Gaps / 重要差距

| # | Gap / 差距 | Current State / 当前状态 | Ideal State / 理想状态 | Impact / 影响 |
|---|---|---|---|---|
| 6 | **No incremental parse at file level** / 无文件级增量解析 | Re-parses all files in directory; deduplication done post-parse / 重解析目录所有文件，解析后去重 | File hash tracking; only re-parse changed files / 文件哈希跟踪，仅重解析变更文件 | Unnecessary re-work on unchanged procedures / 未变更的过程被无意义重解析 |
| 7 | **Flat condition model** / 扁平条件模型 | `SQLCondition` is a free-text string with loose table/field references / `SQLCondition` 为自由文本，表/字段引用松散 | Structured condition AST (operator tree with typed operands) / 结构化条件 AST（带类型操作数的运算符树） | Cannot programmatically compose or deduplicate conditions; display-only / 无法编程组合或去重条件，仅用于展示 |
| 8 | **Layer detection by naming convention only** / 仅靠命名约定检测分层 | `layer_detector.py` uses prefix pattern matching (`M_`, `B_`, `O_ICL_`) / `layer_detector.py` 使用前缀模式匹配 | Metadata-driven layer assignment with override registry / 元数据驱动的分层分配 + 覆盖注册表 | Breaks for non-conforming table names; no user configurability / 不符合命名规则的表名检测失效，用户不可配置 |
| 9 | **No versioned lineage** / 无版本化血缘 | Current parse always overwrites previous state / 当前解析始终覆盖之前状态 | Temporal lineage (version per parse run, diff between versions) / 时序血缘（每次解析一个版本，支持版本间差异） | Cannot track how lineage changes over time; no audit trail / 无法追踪血缘随时间的变化，无审计轨迹 |
| 10 | **Single-threaded traversal** / 单线程遍历 | BFS runs sequentially in the request thread / BFS 在请求线程中顺序执行 | Parallel BFS with work-stealing for wide DAGs / 并行 BFS + 工作窃取算法处理宽 DAG | Slow for high-fanout tables with hundreds of source mappings / 高扇出表（数百个源映射）时性能缓慢 |
| 11 | **No query result pagination** / 无查询结果分页 | `limit` parameter exists but entire graph is traversed before truncation / 有 `limit` 参数但遍历完整图后才截断 | Iterative deepening with early termination / 迭代加深 + 提前终止 | Wastes computation on deep graphs when user only needs first few layers / 用户只需前几层时仍计算深图，浪费算力 |
| 12 | **Cache invalidation is time-based only** / 仅时间驱动缓存失效 | TTL-based LRU cache (`cache_ttl_seconds=3600`) / 基于 TTL 的 LRU 缓存 | Content-hash-based invalidation (invalidate when underlying data changes) / 内容哈希失效（底层数据变更时立即失效） | Stale results after re-parse until TTL expires / 重解析后到 TTL 过期前返回过期结果 |

### Moderate Gaps / 中等差距

| # | Gap / 差距 | Current State / 当前状态 | Ideal State / 理想状态 | Impact / 影响 |
|---|---|---|---|---|
| 13 | **Indicator ↔ Field lineage bridge is shallow** / 指标-字段血缘桥接浅 | `bridge_to_field_lineage()` calls `query_lineage()` once with fixed depth=5 / `bridge_to_field_lineage()` 以固定 depth=5 调用一次 | Deep integration where indicator tracing automatically continues into field-level when reaching base tables / 指标追踪到底层表时自动深入字段级 | Incomplete end-to-end tracing for GL indicators down to source tables / 总账指标到源表的端到端追溯不完整 |
| 14 | **No schema evolution handling** / 无模式演进处理 | `SCHEMA_VERSION = 1` with empty migration registry / `SCHEMA_VERSION = 1`，迁移注册表为空 | Defined migration functions as schema evolves / 随模式演进定义迁移函数 | Will break when data format changes / 数据格式变更时将中断 |
| 15 | **Thread safety via coarse locking** / 粗粒度线程安全 | `threading.Lock()` on entire data dict in `DataRepository` / `DataRepository` 对整个数据字典加 `threading.Lock()` | Read-write lock (RWLock) or immutable snapshots with copy-on-write / 读写锁（RWLock）或 COW 不可变快照 | Read contention under concurrent API requests / 并发 API 请求时读取争用 |
| 16 | **No confidence aggregation across chains** / 无链路置信度聚合 | Each `FieldMapping` has `confidence` but multi-hop chains don't aggregate / 每个 `FieldMapping` 有置信度但多跳链路不聚合 | Multiply confidence along chain paths; present reliability score / 沿链路路径连乘置信度，呈现可靠性评分 | Users cannot assess trustworthiness of deep lineage chains / 用户无法评估深层血缘链的可信度 |
| 17 | **Visualization coupling** / 可视化耦合 | Several HTML files in `output/` embed data directly (38 MB HTML files) / `output/` 下多个 HTML 文件直接嵌入数据（38 MB） | Separate visualization from data; API-driven rendering / 可视化与数据分离，API 驱动渲染 | Unmanageable file sizes; no interactive filtering / 文件体积不可控，无法交互式过滤 |

### Architectural Observations / 架构观察

1. **Well-designed separation of concerns**: The `core/` (parsing + tracing engine) vs `app/` (HTTP API + services) split is clean and appropriate.

   **关注点分离设计合理**: `core/`（解析 + 追溯引擎）与 `app/`（HTTP API + 服务）的分离清晰恰当。

2. **Good use of BFS with cycle detection**: Both `LineageTracer` and `CaliberTracer` correctly implement BFS with visited-set cycle breaking and configurable max-depth.

   **BFS + 循环检测的实现正确**: `LineageTracer` 和 `CaliberTracer` 均正确实现了带访问集循环打破和可配置最大深度的 BFS。

3. **Index pre-computation is correct in principle**: The `_build_index()` pattern (building hash maps for O(1) lookup) is the right approach but should be persistent rather than computed at startup.

   **索引预计算思路正确**: `_build_index()` 模式（构建哈希映射实现 O(1) 查询）方向正确，但应持久化而非每次启动重建。

4. **Multi-path lineage support**: The system correctly handles UNION ALL scenarios producing multiple chains — this is a non-trivial requirement handled well.

   **多路径血缘支持**: 系统正确处理 UNION ALL 场景产生多条链路——这是一个非平凡且处理良好的需求。

5. **The CaliberInfo model is over-engineered**: With 30+ fields including accumulated conditions, step-isolated conditions, CTE definitions, and custom functions, the `CaliberInfo` dataclass has become a catch-all that mixes parsing artifacts with display concerns.

   **CaliberInfo 模型过度设计**: 包含 30+ 字段（累积条件、步骤隔离条件、CTE 定义、自定义函数等），`CaliberInfo` 数据类已变成一个将解析产物与展示关注混在一起的"万能袋"。

---

## Part IV: Key Design Recommendations Summary
## 第四部分：关键设计建议总结

1. **Replace JSON flat-file with SQLite** (minimum) or PostgreSQL: Normalize the 2.5 GB blob into proper tables with indexes. This single change addresses gaps #1, #2, #4, #5, and #12.

   **用 SQLite（最低）或 PostgreSQL 替代 JSON 扁平文件**: 将 2.5 GB 数据规范化为带索引的关系表。仅这一项变更即可解决差距 #1、#2、#4、#5 和 #12。

2. **Adopt an AST-based SQL parser** (e.g., `sqlglot`): Eliminates regex fragility, enables proper expression tree analysis, and correctly handles CTEs, window functions, and complex subqueries.

   **采用基于 AST 的 SQL 解析器**（如 `sqlglot`）：消除正则脆弱性，支持正确的表达式树分析，正确处理 CTE、窗口函数和复杂子查询。

3. **Implement content-addressed caching**: Hash the input data to determine cache validity rather than relying on time-based TTL.

   **实现内容寻址缓存**: 对输入数据哈希来决定缓存有效性，而非依赖时间 TTL。

4. **Unify the edge model**: A single `LineageEdge` with optional condition attachments replaces the current triple storage of `field_mappings` + `caliber_infos` + `table_lineages`.

   **统一边模型**: 使用单一的 `LineageEdge`（带可选条件附件）替代当前 `field_mappings` + `caliber_infos` + `table_lineages` 的三重存储。

5. **Add temporal versioning**: Each parse run produces a version; queries can target "current" or "as-of" a specific version. Enables lineage diff and audit.

   **添加时序版本化**: 每次解析产生一个版本；查询可针对"当前"或"某一历史版本"，支持血缘差异对比和审计。
