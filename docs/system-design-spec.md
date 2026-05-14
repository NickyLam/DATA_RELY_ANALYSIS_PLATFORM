# DATA_RELY_ANALYSIS_SYS 系统设计说明书

> 版本: v2.0 | 日期: 2026-05-14 | 状态: ✅已有 / 📋计划实施

---

## 目录

1. [系统概述](#1-系统概述)
2. [系统架构](#2-系统架构)
3. [数据模型层](#3-数据模型层)
4. [解析引擎层](#4-解析引擎层)
5. [血缘追踪层](#5-血缘追踪层)
6. [口径追溯层](#6-口径追溯层)
7. [API 服务层](#7-api-服务层)
8. [前端展示层](#8-前端展示层)
9. [层级检测体系](#9-层级检测体系)
10. [Schema 同义词映射体系](#10-schema-同义词映射体系)
11. [SQL 边界检测（计划）](#11-sql-边界检测计划)
12. [步骤级隔离条件提取（计划）](#12-步骤级隔离条件提取计划)
13. [CTE / 自定义函数 / 完整表达式解析（计划）](#13-cte--自定义函数--完整表达式解析计划)
14. [口径可视化增强（计划）](#14-口径可视化增强计划)
15. [部署与运维](#15-部署与运维)
16. [实施任务清单](#16-实施任务清单)
17. [模块依赖与解耦关系](#17-模块依赖与解耦关系)

---

## 1. 系统概述

### 1.1 项目定位

Oracle 数据库血缘分析系统，从 `.tab`（表结构定义）和 `.prc`（存储过程）文件中解析表级/字段级血缘关系，提供：

- **展示层**：D3.js 图谱可视化，支持上游/下游字段级血缘追溯
- **口径层**：指标口径追溯，提供全链路 WHERE/JOIN/GROUP BY 条件、口径规格描述
- **API 层**：HTTP REST API，供前端和外部系统调用

### 1.2 数据规模

| 指标 | 数量 |
|------|------|
| 表 (.tab) | 3,041 |
| 存储过程 (.prc) | 1,754 |
| 服务初始化时间 | 6-8 分钟 |

### 1.3 技术栈

| 层 | 技术 |
|----|------|
| 后端 | Python 3.9, 标准库 http.server |
| 前端 | 原生 JS + D3.js v7 + Element-UI |
| 数据源 | Oracle .tab/.prc 文件（RRP_ORACLE 目录） |
| 打包 | PyInstaller (build_exe.py) |

---

## 2. 系统架构

### 2.1 整体分层

```
┌─────────────────────────────────────────────────────────────┐
│                      前端展示层 (static/)                     │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌───────────────┐  │
│  │ 解析层Tab │ │ 展示层Tab │ │ 口径层Tab │ │ (计划)口径详情 │  │
│  │parse-tab │ │search+   │ │caliber-  │ │  增强Tab       │  │
│  │          │ │graph+    │ │tab.js    │ │               │  │
│  │          │ │detail    │ │          │ │               │  │
│  └──────────┘ └──────────┘ └──────────┘ └───────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                    API 服务层 (api_server.py)                 │
│  /api/lineage/query  /api/caliber/trace  /api/tables ...    │
├─────────────────────────────────────────────────────────────┤
│                    血缘追踪层 (core/)                         │
│  ┌───────────────┐  ┌───────────────┐  ┌────────────────┐  │
│  │ LineageTracer │  │ CaliberTracer │  │(计划)SQLBound-  │  │
│  │ (BFS上游/下游) │  │ (BFS口径链路) │  │  aryDetector   │  │
│  └───────┬───────┘  └───────┬───────┘  └────────────────┘  │
│          │                  │                                │
│  ┌───────┴──────────────────┴──────┐  ┌──────────────────┐  │
│  │       CaliberExtractor          │  │ LayerDetector    │  │
│  │  (WHERE/JOIN/元数据提取,无状态)  │  │ (层级检测)       │  │
│  └─────────────────────────────────┘  └──────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                    解析引擎层 (core/)                         │
│  ┌──────────────────┐  ┌──────────────────────────────┐    │
│  │ OracleTableParser│  │ EnhancedProcedureParser      │    │
│  │ (.tab 表结构解析) │  │ (.prc 存储过程解析)           │    │
│  │                  │  │  └─ SQLOperation (DML操作)    │    │
│  │                  │  │  └─ FieldCleaner (字段清洗)   │    │
│  │                  │  │  └─ TableNameResolver (表名)  │    │
│  └──────────────────┘  └──────────────────────────────┘    │
├─────────────────────────────────────────────────────────────┤
│                    数据模型层 (core/models.py)                │
│  TableInfo, ColumnInfo, FieldMapping, CaliberInfo, ...      │
├─────────────────────────────────────────────────────────────┤
│                    数据源 (RRP_ORACLE/)                       │
│  rrp_mdl/*.tab  rrp_mdl/*.prc  rrp_east/*.tab  ...         │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 双路径数据流

系统存在两条独立的数据路径，互不干扰：

| 路径 | 入口 | 转换器 | 输出格式 | 消费方 |
|------|------|--------|---------|--------|
| **展示层血缘** | `/api/lineage/query` | `_result_to_graph()` | `{nodes, edges, field_mappings}` | lineage-graph.js, detail-panel.js |
| **口径追溯** | `/api/caliber/trace` | `_chains_to_caliber_result()` | `CaliberResult` | caliber-tab.js |

> **铁律**: 对 `CaliberInfo` / `CaliberExtractor` / `SQLOperation` 的修改必须保留已有字段路径；新功能仅通过新增字段/方法实现。

---

## 3. 数据模型层

> 文件: `core/models.py`

### 3.1 已有数据模型

| 模型 | 用途 | 状态 |
|------|------|------|
| `ColumnInfo` | 字段定义 (name, data_type, nullable, comment) | ✅已有 |
| `TableInfo` | 表定义 (schema, table_name, columns, primary_keys, partitions) | ✅已有 |
| `FieldMapping` | 字段映射 (source→target, transform_logic, confidence) | ✅已有 |
| `TableLineage` | 表级血缘 (source→target, field_mappings) | ✅已有 |
| `ProcedureInfo` | 存储过程信息 (source/target_tables, field_mappings) | ✅已有 |
| `FieldLineageNode` | 血缘链路节点 (layer, table_name, field_name, procedure) | ✅已有 |
| `FieldLineageChain` | 血缘链路 (target→chain of nodes, depth) | ✅已有 |
| `FieldLineageResult` | 血缘查询结果 (chains, total_nodes, max_depth) | ✅已有 |
| `SQLCondition` | SQL 条件子句 (condition_type, raw_text, tables/fields_involved) | ✅已有 |
| `SelectColumnMapping` | SELECT 列映射 (source_expression, target_column, alias) | ✅已有 |
| `SubqueryInfo` | 子查询信息 (alias, raw_text, source_tables) | ✅已有 |
| `SQLOperationType` | SQL 操作类型常量 (INSERT_SELECT, MERGE, UPDATE...) | ✅已有 |
| `SetOperationType` | 集合运算类型常量 (UNION, UNION ALL, INTERSECT, MINUS) | ✅已有 |
| `CaliberInfo` | 指标口径信息 — 详见 §6.1 | ✅已有 |
| `CaliberChain` | 口径链路 (steps, depth, data_flow_layers) | ✅已有 |
| `CaliberResult` | 口径查询结果 (chains, total_steps, complete_caliber_spec) | ✅已有 |

### 3.2 CaliberInfo 已有字段详解

> 文件: `core/models.py` L174-306

| 字段 | 类型 | 说明 | 状态 |
|------|------|------|------|
| target_table | str | 目标表名 | ✅已有 |
| target_column | str | 目标字段名 | ✅已有 |
| source_table | str | 来源表名 | ✅已有 |
| source_column | str | 来源字段名 | ✅已有 |
| transform_logic | str | 转换逻辑 | ✅已有 |
| where_conditions | list[SQLCondition] | 当前步骤 WHERE 条件 | ✅已有 |
| join_conditions | list[SQLCondition] | 当前步骤 JOIN 条件 | ✅已有 |
| group_by_clause | str | GROUP BY 子句 | ✅已有 |
| having_clause | str | HAVING 子句 | ✅已有 |
| procedure | str | 所属存储过程 | ✅已有 |
| step_num | int | 步骤编号 | ✅已有 |
| step_desc | str | 步骤描述 | ✅已有 |
| data_source | str | 数据源标识 (默认 "oracle") | ✅已有 |
| raw_sql_fragment | str | 原始 SQL 片段 (截断2000字) | ✅已有 |
| confidence | float | 置信度 | ✅已有 |
| operation_type | str | SQL操作类型 | ✅已有 |
| select_columns | list[SelectColumnMapping] | SELECT列映射 | ✅已有 |
| distinct_flag | bool | 是否DISTINCT | ✅已有 |
| order_by_clause | str | ORDER BY子句 | ✅已有 |
| set_operation | str | 集合运算类型 | ✅已有 |
| subqueries | list[SubqueryInfo] | 子查询信息 | ✅已有 |
| source_table_layer | str | 来源表分层 | ✅已有 |
| target_table_layer | str | 目标表分层 | ✅已有 |
| window_functions | list[str] | 窗口函数表达式 | ✅已有 |
| sql_operation_sequence | int | SQL操作执行顺序 | ✅已有 |
| accumulated_where | list[SQLCondition] | 累积WHERE条件 | ✅已有 |
| accumulated_join | list[SQLCondition] | 累积JOIN条件 | ✅已有 |
| caliber_spec | str | 口径规格描述 | ✅已有 |

### 3.3 CaliberInfo 计划新增字段

| 字段 | 类型 | 默认值 | 说明 | 状态 |
|------|------|--------|------|------|
| file_path | str | "" | 来源.prc文件路径 | 📋计划 |
| start_line | int | 0 | SQL操作在文件中的起始行号 | 📋计划 |
| end_line | int | 0 | SQL操作在文件中的结束行号 | 📋计划 |
| step_isolated_where | list[SQLCondition] | [] | 步骤级隔离WHERE条件（非累积） | 📋计划 |
| step_isolated_join | list[SQLCondition] | [] | 步骤级隔离JOIN条件（非累积） | 📋计划 |
| cte_definitions | list[str] | [] | WITH子句CTE定义 | 📋计划 |
| custom_functions | list[str] | [] | 自定义函数调用列表 | 📋计划 |
| full_expression | str | "" | 完整字段表达式（含函数嵌套） | 📋计划 |
| is_custom_function_call | bool | False | 是否为自定义函数调用 | 📋计划 |

> **兼容性保障**: 新增字段全部带默认值，不影响已有 `CaliberInfo(...)` 构造调用。

### 3.4 SQLOperation 已有/计划字段

> 文件: `core/procedure_parser.py` L34-42

| 字段 | 类型 | 说明 | 状态 |
|------|------|------|------|
| op_type | str | 操作类型 (insert/merge/update) | ✅已有 |
| target_table | str | 目标表名 | ✅已有 |
| sql_block | str | SQL操作完整文本 | ✅已有 |
| step_num | int | 步骤编号 | ✅已有 |
| step_desc | str | 步骤描述 | ✅已有 |
| raw_text | str | 原始文本 | ✅已有 |
| start_line | int | 起始行号（默认0） | 📋计划 |
| end_line | int | 结束行号（默认0） | 📋计划 |
| file_path | str | 文件路径（默认""） | 📋计划 |

---

## 4. 解析引擎层

### 4.1 OracleTableParser ✅已有

> 文件: `core/table_parser.py`

| 能力 | 状态 |
|------|------|
| 解析 .tab 文件 CREATE TABLE 语句 | ✅已有 |
| 提取字段定义 (name, data_type, nullable) | ✅已有 |
| 提取主键、分区、表注释 | ✅已有 |
| 目录递归扫描 | ✅已有 |

### 4.2 EnhancedProcedureParser ✅已有

> 文件: `core/procedure_parser.py`

| 能力 | 状态 |
|------|------|
| 全局查找 INSERT/MERGE/UPDATE 操作 | ✅已有 |
| V_STEP 步骤上下文定位 | ✅已有 |
| INSERT 字段映射提取 (含 UNION ALL) | ✅已有 |
| MERGE INTO 两分支解析 | ✅已有 |
| UPDATE SET 字段映射提取 | ✅已有 |
| FROM 子句别名解析 | ✅已有 |
| TMP 临时表检测与内部依赖 | ✅已有 |
| 口径提取接口 (parse_prc_file_with_caliber) | ✅已有 |
| 表名规范化 (_normalize_table_name) | ✅已有 |

### 4.3 FieldCleaner ✅已有

> 文件: `core/field_cleaner.py`

| 能力 | 状态 |
|------|------|
| 目标字段列表清洗 (去注释/空白) | ✅已有 |
| SELECT 字段解析 (含别名) | ✅已有 |
| UPDATE SET 对解析 | ✅已有 |
| 字段名清洗 (去函数包裹/注释) | ✅已有 |
| 源字段推断 (resolve_source_from_expr) | ✅已有 |

### 4.4 TableNameResolver ✅已有

> 文件: `core/table_name_resolver.py`

| 能力 | 状态 |
|------|------|
| 表名同义词解析 (O_ICL_* / ICL.*) | ✅已有 |
| 表名模糊匹配 | ✅已有 |

### 4.5 DataValidator ✅已有

> 文件: `core/data_validator.py`

| 能力 | 状态 |
|------|------|
| 数据校验工具 | ✅已有 |

### 4.6 BaseSQLParser ✅已有

> 文件: `core/base_sql_parser.py`

| 能力 | 状态 |
|------|------|
| SQL 解析基类 | ✅已有 |

---

## 5. 血缘追踪层

### 5.1 LineageTracer ✅已有

> 文件: `core/lineage_tracer.py`

| 能力 | 状态 |
|------|------|
| BFS 上游追溯 (trace_field) | ✅已有 |
| BFS 下游追溯 (trace_field_downstream) | ✅已有 |
| 5 个预建索引 (table_lineage/field_mapping/source_field/proc_target/table_proc) | ✅已有 |
| TMP 表桥接查找 (_try_tmp_bridge) | ✅已有 |
| Schema 变体模糊匹配 (_fuzzy_match_table_key) | ✅已有 |
| 表间推断 (_infer_source_table_from_lineage) | ✅已有 |
| 循环依赖检测 (含裸表名 key) | ✅已有 |
| 图结果转换 (to_graph_result) | ✅已有 |
| `_bare_table()` 同义词映射（与 api_server._bare 保持一致） | ✅已有 |

> **不在修改范围**: `FieldLineageResult` / `FieldLineageChain` / `FieldLineageNode` 数据类不受新计划影响。

---

## 6. 口径追溯层

### 6.1 CaliberExtractor ✅已有

> 文件: `core/caliber_extractor.py`

| 能力 | 状态 |
|------|------|
| WHERE 条件提取 (_extract_where) | ✅已有 |
| JOIN 条件提取 (_extract_joins) | ✅已有 |
| GROUP BY / HAVING 提取 | ✅已有 |
| 操作类型检测 (_detect_operation_type) | ✅已有 |
| DISTINCT 检测 | ✅已有 |
| ORDER BY 提取 | ✅已有 |
| 集合运算检测 (UNION/UNION ALL/INTERSECT/MINUS) | ✅已有 |
| SELECT 列映射提取 | ✅已有 |
| 窗口函数提取 | ✅已有 |
| 子查询提取 | ✅已有 |
| build_caliber_info / build_caliber_infos | ✅已有 |
| to_dict / from_dict 序列化 | ✅已有 |

**当前 WHERE 提取模式**: **累积模式** — 对完整 `sql_block` 整体提取，结果为该 SQL 块内所有 WHERE 的合集。

### 6.2 CaliberTracer ✅已有

> 文件: `core/caliber_tracer.py`

| 能力 | 状态 |
|------|------|
| BFS 口径链路追溯 | ✅已有 |
| 每步携带完整 WHERE/JOIN/GROUP BY 条件 | ✅已有 |
| 跨存储过程口径链路拼接 | ✅已有 |
| 口径摘要生成 (可读文本 + 结构化数据) | ✅已有 |
| TableNameResolver 集成 | ✅已有 |

### 6.3 口径提取当前问题

| 问题 | 根因 | 计划方案 |
|------|------|---------|
| WHERE 条件为累积模式，无法区分哪步引入哪条条件 | `_extract_where()` 对完整 sql_block 提取 | 新增 `SQLBoundaryDetector` 做步骤级隔离 |
| 缺少行号定位 | `SQLOperation` 无 start_line/end_line | 扩展 SQLOperation + 解析器增加行号记录 |
| CTE (WITH 子句) 未提取 | 正则未覆盖 | 新增 CTE 提取逻辑 |
| 自定义函数调用未识别 | 正则未覆盖 | 新增自定义函数检测 |
| 字段完整表达式丢失 | FieldMapping.transform_logic 截断 | 新增 full_expression 字段 |

---

## 7. API 服务层

### 7.1 已有 API 端点

> 文件: `api_server.py`

| 端点 | 方法 | 用途 | 状态 |
|------|------|------|------|
| `/health` | GET | 健康检查 (status, uptime, total_tables) | ✅已有 |
| `/api/tables` | GET | 表列表搜索 (?keyword=xxx) | ✅已有 |
| `/api/tables/{name}/fields` | GET | 某表字段列表 | ✅已有 |
| `/api/lineage/query` | POST | 字段血缘查询 (展示层格式) | ✅已有 |
| `/api/lineage/{table}/{field}` | GET | 血缘查询快捷方式 | ✅已有 |
| `/api/caliber/fields` | GET | 某表有口径数据的字段列表 | ✅已有 |
| `/api/caliber/trace` | GET | 口径追溯查询 (CaliberResult格式) | ✅已有 |
| `/api/stats` | GET | 系统统计信息 | ✅已有 |
| `/` | GET | 前端首页 | ✅已有 |
| `/static/*` | GET | 静态文件服务 | ✅已有 |

### 7.2 关键转换函数

| 函数 | 用途 | 状态 |
|------|------|------|
| `_result_to_graph()` | FieldLineageResult → {nodes, edges, field_mappings} | ✅已有 |
| `_chains_to_caliber_result()` | FieldLineageChain[] → CaliberResult | ✅已有 |
| `_serialize_caliber_info()` | CaliberInfo → dict | ✅已有 |
| `_serialize_caliber_result()` | CaliberResult → dict | ✅已有 |
| `_find_field_mapping()` | 查找血缘映射 (精确+模糊) | ✅已有 |
| `_extract_sql_block_for_mapping()` | 从 .prc 提取 SQL 操作块 | ✅已有 |

### 7.3 计划新增端点

| 端点 | 方法 | 用途 | 状态 |
|------|------|------|------|
| `/api/caliber/trace/detail` | GET | 增强口径追溯（含行号/隔离条件/CTE/函数） | 📋计划 |
| `/api/caliber/sql-detail` | GET | 单步SQL详细解析（步骤级隔离条件+边界信息） | 📋计划 |

> **兼容性**: 已有端点不做修改，新端点为纯增量添加。

---

## 8. 前端展示层

### 8.1 已有前端模块

| 文件 | 用途 | 状态 |
|------|------|------|
| `static/index.html` | 入口页面，三Tab布局（解析/展示/口径） | ✅已有 |
| `static/js/app.js` | 全局状态管理、Tab切换、工具函数 | ✅已有 |
| `static/js/parse-tab.js` | 解析层Tab（文件上传/进度/SSE） | ✅已有 |
| `static/js/search-panel.js` | 展示层搜索面板（表名搜索、字段选择） | ✅已有 |
| `static/js/lineage-graph.js` | D3.js 图谱渲染（BFS布局、节点/边绘制） | ✅已有 |
| `static/js/detail-panel.js` | 展示层详情面板（字段映射列表） | ✅已有 |
| `static/js/caliber-tab.js` | 口径层Tab（搜索、结果展示、链路可视化） | ✅已有 |
| `static/js/display-tab.js` | ❌已拆分，不再被 index.html 引入 | 废弃 |

### 8.2 计划前端增强

| 模块 | 用途 | 状态 |
|------|------|------|
| 口径详情增强 | 行号跳转、隔离条件高亮、CTE折叠、函数调用标注 | 📋计划 |

> **影响范围**: 展示层 (lineage-graph.js, detail-panel.js) 零影响。

---

## 9. 层级检测体系

### 9.1 LayerDetector ✅已有

> 文件: `core/layer_detector.py`

| 层级 | 前缀模式 | 颜色 | 排序 |
|------|---------|------|------|
| ODS 源系统层 | O_ICL_*, O_IML_*, O_IOL_*, O_FDW_*, O_RDW_* | #4ade80 | 0 |
| DIIS 明细层 | ADD_*, *DIIS* | #38bdf8 | 1 |
| BASE 基础层 | B_* | #818cf8 | 2 |
| MDL 模型层 | M_* | #c084fc | 3 |
| APP 应用汇总层 | A_*, S_* | #fb923c | 4 |
| EAST 报送层 | *EAST* | #f87171 | 5 |
| CONFIG 配置表 | ETL_*, CONFIG*, CODE*, TMP*, SQ_* | #6b7280 | 6 |

**支持 schema.table 全限定名检测**，短名提取后匹配，避免 RRP_EAST schema 误判。

---

## 10. Schema 同义词映射体系

### 10.1 `_bare()` 映射规则 ✅已有

> 需保持一致的位置: `api_server.py` L464-491 和 `core/lineage_tracer.py` L584-595, L698-722

| 原始表名 | `_bare()` 结果 | 说明 |
|---------|----------------|------|
| `RRP_MDL.O_ICL_CMM_XXX` | `ICL_CMM_XXX` | 去掉 O_ 前缀 |
| `ICL.V_CMM_XXX` | `ICL_CMM_XXX` | 去掉 V_ 视图前缀，加 ICL_ |
| `ICL.CMM_XXX` | `ICL_CMM_XXX` | 加 ICL_ 前缀 |

三个变体映射到同一个逻辑名，实现同义去重。

### 10.2 去重机制 ✅已有

| 场景 | 机制 |
|------|------|
| 节点去重 | `node_map` 按 `_bare()` key 合并 |
| 边去重 | `edge_keys` 按 `src_bare|tgt_bare` 去重 |
| 映射去重 | `fm_dedup_keys` 按 `(src_bare|tgt_bare.target_field)` 三元组去重 |
| 自环边过滤 | `src_bare == tgt_bare AND src_table != tgt_table` 时跳过（保留同表内字段转换边） |

---

## 11. SQL 边界检测（计划）

### 11.1 设计目标

在存储过程中精确定位每条 DML 操作的行号范围，为步骤级隔离条件提取提供边界信息。

### 11.2 SQLBoundaryDetector 📋计划

| 能力 | 说明 |
|------|------|
| 精确行号定位 | 识别 INSERT/MERGE/UPDATE 在文件中的 start_line / end_line |
| CTE 边界识别 | 识别 WITH ... AS (...) 子句的范围 |
| 嵌套语句处理 | 处理 BEGIN...END 嵌套内的 DML 定位 |

### 11.3 与已有模块的关系

```
SQLBoundaryDetector (新模块，独立)
    ↓ 输出: {start_line, end_line, file_path}
SQLOperation (扩展字段，向后兼容)
    ↓ 消费
CaliberExtractor (新增方法，不修改已有方法)
    ↓ 输出: step_isolated_where / step_isolated_join
CaliberInfo (新增字段，带默认值)
```

---

## 12. 步骤级隔离条件提取（计划）

### 12.1 当前问题

`CaliberExtractor._extract_where()` 对完整 `sql_block` 做累积提取，无法区分：
- 哪个 WHERE 条件是当前步骤引入的
- 哪个是从前序步骤继承的

### 12.2 双路径策略 📋计划

| 路径 | 方法 | 输出字段 | 状态 |
|------|------|---------|------|
| 旧路径（保留） | `_extract_where()` → `accumulated_where` | `accumulated_where` / `accumulated_join` | ✅已有 |
| 新路径（新增） | `SQLBoundaryDetector` + `_extract_step_isolated_where()` | `step_isolated_where` / `step_isolated_join` | 📋计划 |

> **解耦原则**: 新路径为独立模块，不修改旧路径的任何代码。

### 12.3 优先级逻辑

`CaliberInfo.generate_caliber_spec()` 中的 WHERE 优先级将扩展为：

```
step_isolated_where → accumulated_where → where_conditions
```

---

## 13. CTE / 自定义函数 / 完整表达式解析（计划）

### 13.1 CTE (WITH 子句) 提取 📋计划

| 能力 | 说明 |
|------|------|
| WITH ... AS (...) 识别 | 提取 CTE 名称和定义体 |
| CTE 引用追踪 | 识别主查询中对 CTE 的引用 |
| 输出 | `CaliberInfo.cte_definitions: list[str]` |

### 13.2 自定义函数检测 📋计划

| 能力 | 说明 |
|------|------|
| 函数调用模式识别 | 检测 `PKG_FUNC(...)` / `FN_XXX(...)` 等 Oracle 自定义函数 |
| 标记 | `CaliberInfo.is_custom_function_call: bool` |
| 列表 | `CaliberInfo.custom_functions: list[str]` |

### 13.3 完整字段表达式 📋计划

| 能力 | 说明 |
|------|------|
| 保留 SELECT 中字段的完整表达式 | 不截断，包含函数嵌套、CASE WHEN 等 |
| 输出 | `CaliberInfo.full_expression: str` |

---

## 14. 口径可视化增强（计划）

### 14.1 行号跳转 📋计划

在口径详情中显示 `file_path:start_line-end_line`，点击可跳转到源文件对应行。

### 14.2 隔离条件高亮 📋计划

步骤级隔离条件以不同样式高亮，与累积条件区分。

### 14.3 CTE 折叠展示 📋计划

WITH 子句默认折叠，点击展开。

### 14.4 自定义函数标注 📋计划

函数调用以特殊样式标注，点击可查看函数定义。

---

## 15. 部署与运维

### 15.1 启动方式 ✅已有

```bash
# 开发模式
python api_server.py --port 8899 --dir RRP_ORACLE

# 打包模式
python build_exe.py  # → dist/ 目录
```

### 15.2 配置 ✅已有

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| --port | 8899 | HTTP 监听端口 |
| --dir | RRP_ORACLE | .prc/.tab 文件根目录 |

### 15.3 健康检查 ✅已有

```bash
curl http://localhost:8899/health
# → {"success": true, "data": {"status": "ok", "uptime_seconds": 123, "total_tables": 3041, "total_procedures": 1754}}
```

---

## 16. 实施任务清单

### 16.1 任务分组与优先级

按解耦原则，任务分为 **4 个独立批次**，每批次内部无跨批依赖，可独立开发/测试/上线。

---

#### 批次 A: 行号定位基础（低风险，纯增量）

| # | 任务 | 涉及文件 | 风险 | 依赖 |
|---|------|---------|------|------|
| A1 | `SQLOperation` 新增 `start_line`, `end_line`, `file_path` 字段（带默认值） | `core/procedure_parser.py` | 低 | 无 |
| A2 | `_extract_all_sql_operations()` 中计算行号并填充 `start_line/end_line` | `core/procedure_parser.py` | 低 | A1 |
| A3 | `parse_prc_file()` 传递 `file_path` 到 SQLOperation | `core/procedure_parser.py` | 低 | A1 |
| A4 | `CaliberInfo` 新增 `file_path`, `start_line`, `end_line` 字段（带默认值） | `core/models.py` | 低 | 无 |
| A5 | `CaliberExtractor.build_caliber_info()` 填充行号/文件路径 | `core/caliber_extractor.py` | 低 | A1,A4 |
| A6 | `CaliberExtractor.to_dict()` / `from_dict()` 序列化新字段 | `core/caliber_extractor.py` | 低 | A4 |
| A7 | `api_server._serialize_caliber_info()` 序列化新字段 | `api_server.py` | 低 | A4 |

---

#### 批次 B: SQL 边界检测 + 步骤级隔离条件（中风险，新模块）

| # | 任务 | 涉及文件 | 风险 | 依赖 |
|---|------|---------|------|------|
| B1 | 新建 `core/sql_boundary_detector.py` 模块 | 新文件 | 低 | 无 |
| B2 | 实现 `SQLBoundaryDetector` 类：行号精确计算、CTE边界识别 | `core/sql_boundary_detector.py` | 中 | B1 |
| B3 | `CaliberInfo` 新增 `step_isolated_where`, `step_isolated_join` 字段 | `core/models.py` | 低 | 无 |
| B4 | `CaliberExtractor` 新增 `_extract_step_isolated_where()` / `_extract_step_isolated_join()` 方法 | `core/caliber_extractor.py` | 中 | B2,B3 |
| B5 | `build_caliber_info()` 调用新方法填充隔离条件 | `core/caliber_extractor.py` | 中 | B4 |
| B6 | `generate_caliber_spec()` 优先级逻辑扩展: `step_isolated_where → accumulated_where → where_conditions` | `core/models.py` | 中 | B3 |
| B7 | `to_dict()` / `from_dict()` 序列化新字段 | `core/caliber_extractor.py` | 低 | B3 |
| B8 | 单元测试: SQLBoundaryDetector | `tests/` | 低 | B2 |

---

#### 批次 C: CTE / 自定义函数 / 完整表达式（低风险，纯新增）

| # | 任务 | 涉及文件 | 风险 | 依赖 |
|---|------|---------|------|------|
| C1 | `CaliberInfo` 新增 `cte_definitions`, `custom_functions`, `full_expression`, `is_custom_function_call` 字段 | `core/models.py` | 低 | 无 |
| C2 | `CaliberExtractor` 新增 `_extract_cte_definitions()` 方法 | `core/caliber_extractor.py` | 低 | C1 |
| C3 | `CaliberExtractor` 新增 `_extract_custom_functions()` 方法 | `core/caliber_extractor.py` | 低 | C1 |
| C4 | `CaliberExtractor` 新增 `_extract_full_expression()` 方法 | `core/caliber_extractor.py` | 低 | C1 |
| C5 | `build_caliber_info()` 调用新方法填充新字段 | `core/caliber_extractor.py` | 低 | C2,C3,C4 |
| C6 | `to_dict()` / `from_dict()` 序列化新字段 | `core/caliber_extractor.py` | 低 | C1 |
| C7 | `generate_caliber_spec()` 扩展: CTE/函数/表达式渲染 | `core/models.py` | 低 | C1 |
| C8 | 单元测试: CTE/函数/表达式提取 | `tests/` | 低 | C2,C3,C4 |

---

#### 批次 D: API + 前端增强（低风险，纯增量）

| # | 任务 | 涉及文件 | 风险 | 依赖 |
|---|------|---------|------|------|
| D1 | 新增 `/api/caliber/trace/detail` 端点 | `api_server.py` | 低 | A,B,C |
| D2 | 新增 `/api/caliber/sql-detail` 端点 | `api_server.py` | 低 | A,B |
| D3 | `api_server._serialize_caliber_info()` 补充所有新字段 | `api_server.py` | 低 | A4,B3,C1 |
| D4 | 口径Tab前端增强: 行号跳转 | `static/js/caliber-tab.js` | 低 | A,D1 |
| D5 | 口径Tab前端增强: 隔离条件高亮 | `static/js/caliber-tab.js` | 低 | B,D1 |
| D6 | 口径Tab前端增强: CTE折叠展示 | `static/js/caliber-tab.js` | 低 | C,D1 |
| D7 | 口径Tab前端增强: 自定义函数标注 | `static/js/caliber-tab.js` | 低 | C,D1 |
| D8 | 口径Tab前端增强: 完整表达式展示 | `static/js/caliber-tab.js` | 低 | C,D1 |

---

## 17. 模块依赖与解耦关系

### 17.1 模块依赖图

```
                    ┌─────────────────┐
                    │   models.py     │ ← 数据模型核心，被所有模块依赖
                    └────────┬────────┘
                             │
          ┌──────────────────┼───────────────────┐
          │                  │                   │
  ┌───────┴───────┐  ┌──────┴──────┐  ┌────────┴────────┐
  │layer_detector │  │ caliber_    │  │  caliber_       │
  │  .py          │  │ extractor   │  │  tracer.py      │
  └───────┬───────┘  └──────┬──────┘  └────────┬────────┘
          │                 │                   │
          │          ┌──────┴──────┐            │
          │          │ (计划) sql_  │            │
          │          │ boundary_   │            │
          │          │ detector.py │            │
          │          └─────────────┘            │
          │                                     │
  ┌───────┴───────────────┐        ┌───────────┴───────┐
  │ procedure_parser.py   │        │  lineage_tracer.py │
  │ (SQLOperation,        │        │  (LineageTracer)   │
  │  EnhancedProcParser)  │        └───────────────────┘
  └───────┬───────────────┘
          │
  ┌───────┴───────────┐
  │  table_parser.py   │
  │  field_cleaner.py  │
  │  table_name_       │
  │  resolver.py       │
  └───────────────────┘
```

### 17.2 解耦设计原则

| 原则 | 说明 |
|------|------|
| **数据模型向后兼容** | 新增字段带默认值，不破坏已有构造调用 |
| **旧路径保留** | `_extract_where()` / `accumulated_where` 不修改，新路径为独立方法 |
| **新模块独立** | `SQLBoundaryDetector` 为独立文件，不侵入已有模块 |
| **API 纯增量** | 已有端点不修改，新端点为独立路由 |
| **展示层零影响** | `lineage-graph.js` / `detail-panel.js` 不受任何新计划影响 |
| **序列化扩展** | `to_dict()` / `from_dict()` / `_serialize_caliber_info()` 仅新增字段映射 |

### 17.3 风险矩阵

| 修改区域 | 风险等级 | 缓解措施 |
|---------|---------|---------|
| `models.py` 新增字段 | 🟡 中（已缓解） | dataclass 默认值，不破坏已有构造 |
| `caliber_extractor.py` 新增方法 | 🟡 中（已缓解） | 新方法独立，不修改已有方法签名 |
| `procedure_parser.py` 新增字段 | 🟢 低 | SQLOperation 新字段带默认值 |
| `api_server.py` 新增端点 | 🟢 低 | 纯增量，不修改已有路由 |
| `caliber-tab.js` 增强功能 | 🟢 低 | 纯新增 UI 元素 |
| `lineage-graph.js` | ⚪ 零 | 不在修改范围 |
| `detail-panel.js` | ⚪ 零 | 不在修改范围 |

---

> **文档维护**: 本文档随系统迭代更新。每次实施完成一个批次后，将对应 📋计划 标记改为 ✅已有，并更新相关章节。
