# 数据血缘分析系统 — 设计规格与差距分析

## 第一部分：当前架构评估

### 总体结构

系统采用 **双TAB架构**（解析层 + 展示层），技术栈如下：

- **后端**: FastAPI + Python 3.11+，从单一巨型 JSON 文件（`lineage_data.json`，2.5 GB）加载到内存
- **前端**: 原生 JavaScript + D3.js，静态文件服务
- **通信**: SSE 实时解析进度推送 + REST API 查询

### 核心模块

| 模块 | 作用 | 大小 |
|---|---|---|
| `core/procedure_parser.py` | 基于正则的存储过程解析（INSERT/MERGE/UPDATE） | 43 KB |
| `core/lineage_tracer.py` | BFS 字段级上下游追溯 | 48 KB |
| `core/caliber_tracer.py` | 带条件的口径追溯（每步携带 WHERE/JOIN/GROUP BY 条件） | 39 KB |
| `core/caliber_extractor.py` | SQL 条件提取（WHERE/JOIN/GROUP BY/HAVING 等） | 37 KB |
| `core/indicator_graph_builder.py` | 指标依赖图构建与 BFS 遍历 | 28 KB |
| `app/repository.py` | 数据访问层（JSON 加载 → 内存字典） | 8.5 KB |
| `app/services/lineage_service.py` | 查询编排与缓存 | 34 KB |

### 三种分析路径

1. **字段血缘** (`LineageTracer`): 通过 `FieldMapping` 记录进行 BFS 追溯，解析 `表 → 存储过程 → 来源字段` 链路。

2. **指标口径** (`CaliberTracer`): 相同的 BFS 结构，但每步携带 WHERE/JOIN/GROUP BY 等完整加工条件。

3. **指标血缘** (`IndicatorGraphBuilder`): 从 Excel 配置解析的指标间依赖图（基础指标、总账指标、衍生指标），支持多度量（余额/日均/发生额等）追溯。

---

## 第二部分：理想系统设计规格

### 1. 数据模型设计

#### 1.1 实体层（元数据）

```
表 (Table) {
    id: UUID
    schema: string                          -- 模式名
    table_name: string                      -- 表名
    full_name: string (schema.table_name, 唯一)  -- 全限定名
    layer: enum(ODS, DWD, DWS, ADS, EAST, CONFIG)  -- 数据分层
    is_temp: boolean                        -- 是否临时表
    columns: [Column]                       -- 字段列表
    source_file: string                     -- 来源文件路径
}

字段 (Column) {
    id: UUID
    table_id: FK → Table                    -- 所属表
    name: string                            -- 字段名
    data_type: string                       -- 数据类型
    nullable: boolean                       -- 是否可空
    comment: string                         -- 注释说明
}

存储过程 (Procedure) {
    id: UUID
    schema: string                          -- 模式名
    proc_name: string                       -- 过程名
    full_name: string (唯一)                -- 全限定名
    source_file: string                     -- 来源文件路径
    file_hash: string                       -- 文件哈希值（用于增量解析）
}
```

#### 1.2 关系层（血缘边）

```
字段映射 (FieldMapping) {
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

步骤条件 (StepCondition) {
    id: UUID
    field_mapping_id: FK → FieldMapping     -- 所属字段映射
    condition_type: enum(WHERE, JOIN, GROUP_BY, HAVING, ORDER_BY)  -- 条件类型
    raw_text: string                        -- 原始SQL文本
    tables_involved: [string]               -- 涉及的表
    fields_involved: [string]               -- 涉及的字段
}
```

#### 1.3 指标层

```
指标 (Indicator) {
    id: UUID
    index_no: string (唯一)                 -- 指标编号
    index_name: string                      -- 指标名称
    index_type: enum(基础, 衍生, 总账, 特殊, 绩效)  -- 指标类型
    classification: {大类, 一级, 二级, 三级}       -- 分类体系
    business_caliber: string                -- 业务口径
    technical_caliber: string               -- 技术口径
}

指标度量 (IndicatorMeasure) {
    id: UUID
    indicator_id: FK → Indicator            -- 所属指标
    measure_code: string (001-029)          -- 度量编码（期末余额/月日均/年日均等）
    algo_type: enum(通用算法, 总账算法, 年化, 临时转标准)  -- 算法类型
    source_table: string                    -- 源表
    measure_sql: string                     -- 度量SQL
    condition_sql: string                   -- 条件SQL
}

指标依赖 (IndicatorDependency) {
    id: UUID
    parent_indicator_id: FK → Indicator     -- 父指标
    child_indicator_id: FK → Indicator      -- 子指标
    dependency_type: enum(派生, 组合)       -- 依赖类型
}

总账映射 (GLMapping) {
    id: UUID
    indicator_id: FK → Indicator            -- 所属指标
    measure_code: string                    -- 度量编码
    subject_no: string                      -- 科目号
    sign_no: int                            -- 符号（借方/贷方）
    amt_val: string                         -- 金额字段（期末借方余额/借方发生额等）
    length_val: int                         -- 科目匹配长度
}
```

### 2. 图表示

#### 2.1 存储格式

理想系统使用 **原生图结构**，邻接表以持久化、可查询的格式存储：

- **正向邻接表**（用于下游查询）：`{源节点 → [(目标节点, 边元数据)]}`
- **反向邻接表**（用于上游查询）：`{目标节点 → [(源节点, 边元数据)]}`
- **节点类型**：`table_field`（表.字段）、`indicator`（指标编号.度量）、`procedure`（存储过程）
- **边类型**：`data_flow`（数据流）、`condition_binding`（条件绑定）、`indicator_dependency`（指标依赖）、`gl_mapping`（总账映射）、`procedure_step`（过程步骤）

#### 2.2 图数据库选型

对于拥有数百万字段级边的系统，理想架构采用：

- **主要方案**: 图数据库（Neo4j 或 PostgreSQL 上的 Apache AGE），用于复杂遍历查询
- **降级方案**: 关系型数据库中压缩的邻接表 + 递归 CTE，适用于简化部署

#### 2.3 遍历算法

| 查询类型 | 算法 | 优化策略 |
|---|---|---|
| 字段上游追溯 | BFS + 循环检测 | 访问集去重 + 最大深度截断 |
| 字段下游追溯 | 正向邻接 BFS | 同上 |
| 指标依赖解析 | DFS 拓扑排序 | 按指标缓存结果（Memoization） |
| 口径条件累积 | BFS + 逐边条件传递 | 链级条件去重 |
| 影响分析 | 双向 BFS | 收敛时提前终止 |

### 3. 性能优化策略

#### 3.1 增量解析

- **文件哈希注册表**: 跟踪每个 `.prc`/`.tab` 文件的 SHA-256 哈希值，仅重新解析变更文件。
- **过程级粒度**: 重新解析某个过程时，仅删除其对应的边并插入新边（当前系统已正确实现此逻辑）。

#### 3.2 查询时优化

- **预物化子图**: 对于频繁查询的表（EAST 报送表），启动时预计算并缓存其完整上游 DAG。
- **分层缓存**:
  - L1: 进程内 LRU 缓存（当前方案），用于最近查询
  - L2: 持久缓存（Redis/SQLite），重启不丢失
- **图分区**: 按数据分层（ODS→DWD→DWS→ADS→EAST）分割血缘图，支持分层约束遍历。

#### 3.3 启动优化

- **延迟加载**: 启动时不加载完整 2.5 GB JSON 到内存，使用内存映射文件或数据库。
- **后台图构建**: HTTP 服务开始接受请求后，异步构建索引。
- **压缩序列化**: 用 MessagePack 或 Parquet 替代 JSON 存储元数据（10-30 倍体积缩减）。

### 4. 存储效率机制

#### 4.1 规范化

- **字符串驻留**: 表名、字段名、过程名在边中重复出现数百万次，使用整数 ID + 查找字典替代字符串。
- **条件去重**: 同一 SQL 操作中的多个字段映射共享相同的 WHERE/JOIN 条件，条件只存一次，通过 ID 引用。
- **表达式模板**: 转换逻辑（如 `NVL(A, 0)`）可参数化并存储为模板。

#### 4.2 存储格式

- **列式存储**（用于批量分析）：Parquet 或 Arrow IPC 格式存储解析后的血缘数据
- **行式存储**（用于点查询）：SQLite 或 PostgreSQL 用于实时 API 服务
- **冷热数据分离**: 高频查询的血缘边驻留内存，历史解析结果存磁盘

---

## 第三部分：差距分析 — 当前 vs. 理想

### 关键差距

| # | 差距 | 当前状态 | 理想状态 | 影响 |
|---|---|---|---|---|
| 1 | **巨型 JSON 存储** | 单一 2.5 GB `lineage_data.json` 全量加载到内存 | 带索引的关系/图数据库 | 启动 10+ 秒，内存 ~5 GB，无法局部加载 |
| 2 | **无持久存储层** | 数据全在进程内存，重启=全量重解析或重新加载 | 数据库后端（最低 SQLite，理想 PostgreSQL） | 数据持久化、查询灵活性、并发访问 |
| 3 | **基于正则的 SQL 解析** | 手写正则匹配 INSERT/MERGE/UPDATE | 基于 AST 的 SQL 解析器（sqlglot 等） | 解析脆弱、遗漏复杂 CTE/递归查询/动态SQL、正则误判 |
| 4 | **无图数据库** | 每次启动重建内存邻接表 | 持久化图 + 预构建遍历索引 | 每次启动重算所有索引，遍历结果不持久 |
| 5 | **输出数据重复** | `caliber_infos` 重复了 `field_mappings` 中已有信息并附加条件 | 统一边模型 + 可选条件附件 | 2.5 GB JSON 存在大量冗余，同一边以轻微差异多次存储 |

### 重要差距

| # | 差距 | 当前状态 | 理想状态 | 影响 |
|---|---|---|---|---|
| 6 | **无文件级增量解析** | 重解析目录所有文件，解析后去重 | 文件哈希跟踪，仅重解析变更文件 | 未变更的过程被无意义重解析 |
| 7 | **扁平条件模型** | `SQLCondition` 为自由文本，表/字段引用松散 | 结构化条件 AST（带类型操作数的运算符树） | 无法编程组合或去重条件，仅用于展示 |
| 8 | **仅靠命名约定检测分层** | `layer_detector.py` 使用前缀模式匹配（`M_`, `B_`, `O_ICL_`） | 元数据驱动的分层分配 + 覆盖注册表 | 不符合命名规则的表名检测失效，用户不可配置 |
| 9 | **无版本化血缘** | 当前解析始终覆盖之前状态 | 时序血缘（每次解析一个版本，支持版本间差异） | 无法追踪血缘随时间的变化，无审计轨迹 |
| 10 | **单线程遍历** | BFS 在请求线程中顺序执行 | 并行 BFS + 工作窃取算法处理宽 DAG | 高扇出表（数百个源映射）时性能缓慢 |
| 11 | **无查询结果分页** | 有 `limit` 参数但遍历完整图后才截断 | 迭代加深 + 提前终止 | 用户只需前几层时仍计算深图，浪费算力 |
| 12 | **仅时间驱动缓存失效** | 基于 TTL 的 LRU 缓存 | 内容哈希失效（底层数据变更时立即失效） | 重解析后到 TTL 过期前返回过期结果 |

### 中等差距

| # | 差距 | 当前状态 | 理想状态 | 影响 |
|---|---|---|---|---|
| 13 | **指标-字段血缘桥接浅** | `bridge_to_field_lineage()` 以固定 depth=5 调用一次 | 指标追踪到底层表时自动深入字段级 | 总账指标到源表的端到端追溯不完整 |
| 14 | **无模式演进处理** | `SCHEMA_VERSION = 1`，迁移注册表为空 | 随模式演进定义迁移函数 | 数据格式变更时将中断 |
| 15 | **粗粒度线程安全** | `DataRepository` 对整个数据字典加 `threading.Lock()` | 读写锁（RWLock）或 COW 不可变快照 | 并发 API 请求时读取争用 |
| 16 | **无链路置信度聚合** | 每个 `FieldMapping` 有置信度但多跳链路不聚合 | 沿链路路径连乘置信度，呈现可靠性评分 | 用户无法评估深层血缘链的可信度 |
| 17 | **可视化耦合** | `output/` 下多个 HTML 文件直接嵌入数据（38 MB） | 可视化与数据分离，API 驱动渲染 | 文件体积不可控，无法交互式过滤 |

### 架构观察

1. **关注点分离设计合理**: `core/`（解析 + 追溯引擎）与 `app/`（HTTP API + 服务）的分离清晰恰当。

2. **BFS + 循环检测的实现正确**: `LineageTracer` 和 `CaliberTracer` 均正确实现了带访问集循环打破和可配置最大深度的 BFS。

3. **索引预计算思路正确**: `_build_index()` 模式（构建哈希映射实现 O(1) 查询）方向正确，但应持久化而非每次启动重建。

4. **多路径血缘支持**: 系统正确处理 UNION ALL 场景产生多条链路——这是一个非平凡且处理良好的需求。

5. **CaliberInfo 模型过度设计**: 包含 30+ 字段（累积条件、步骤隔离条件、CTE 定义、自定义函数等），`CaliberInfo` 数据类已变成一个将解析产物与展示关注混在一起的"万能袋"。

---

## 第四部分：关键设计建议总结

1. **用 SQLite（最低）或 PostgreSQL 替代 JSON 扁平文件**: 将 2.5 GB 数据规范化为带索引的关系表。仅这一项变更即可解决差距 #1、#2、#4、#5 和 #12。

2. **采用基于 AST 的 SQL 解析器**（如 `sqlglot`）：消除正则脆弱性，支持正确的表达式树分析，正确处理 CTE、窗口函数和复杂子查询。

3. **实现内容寻址缓存**: 对输入数据哈希来决定缓存有效性，而非依赖时间 TTL。

4. **统一边模型**: 使用单一的 `LineageEdge`（带可选条件附件）替代当前 `field_mappings` + `caliber_infos` + `table_lineages` 的三重存储。

5. **添加时序版本化**: 每次解析产生一个版本；查询可针对"当前"或"某一历史版本"，支持血缘差异对比和审计。
