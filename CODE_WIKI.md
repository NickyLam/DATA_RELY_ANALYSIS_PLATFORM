# 数据血缘分析系统 - Code Wiki

> **版本**: v3.0  
> **生成日期**: 2026-05-19  
> **技术栈**: Python 3.12+ / FastAPI / SQLGlot / D3.js / SQLite  

---

## 目录

- [1. 项目概述](#1-项目概述)
- [2. 系统架构](#2-系统架构)
- [3. 目录结构](#3-目录结构)
- [4. 核心模块详解](#4-核心模块详解)
- [5. 数据模型](#5-数据模型)
- [6. API 接口](#6-api-接口)
- [7. 前端架构](#7-前端架构)
- [8. 依赖关系](#8-依赖关系)
- [9. 项目运行](#9-项目运行)
- [10. 测试](#10-测试)
- [11. 关键算法](#11-关键算法)
- [12. 扩展指南](#12-扩展指南)

---

## 1. 项目概述

### 1.1 项目定位

数据血缘分析系统是一个面向金融/银行领域的数据治理工具，用于解析 Oracle 数据库的表结构定义文件（`.tab`）和存储过程文件（`.prc`），自动构建字段级的数据血缘关系图谱，并支持指标口径的递归追溯。

### 1.2 核心能力

| 能力 | 说明 |
|------|------|
| **SQL 解析** | 解析 Oracle PL/SQL 存储过程，提取 INSERT/UPDATE/DELETE/MERGE 语句中的表级血缘和字段级映射 |
| **血缘追溯** | 基于 BFS 算法实现字段级的上游追溯和下游去向分析 |
| **口径追溯** | 在血缘基础上携带完整的 WHERE/JOIN/GROUP BY 条件，逐层累积加工口径 |
| **指标管理** | 支持基于 Excel 配置的指标解析和指标依赖图构建 |
| **可视化展示** | D3.js 渲染有向无环图（DAG），支持缩放、拖拽、节点高亮 |

### 1.3 数据规模

- 表数量：~3,041 张
- 存储过程：~1,754 个
- 冷启动时间：6-8 分钟（全量解析）

---

## 2. 系统架构

### 2.1 分层架构

```
┌─────────────────────────────────────────────────────────────┐
│                        展示层 (Frontend)                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────┐ │
│  │ 解析层Tab │  │ 展示层Tab │  │指标口径Tab│  │ 指标血缘Tab  │ │
│  └──────────┘  └──────────┘  └──────────┘  └──────────────┘ │
├─────────────────────────────────────────────────────────────┤
│                        API 网关层                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────┐ │
│  │ /api/parse│ │/api/tables││/api/lineage││/api/caliber   │ │
│  └──────────┘  └──────────┘  └──────────┘  └──────────────┘ │
├─────────────────────────────────────────────────────────────┤
│                        服务层 (Services)                      │
│  ┌───────────────┐  ┌───────────────┐  ┌──────────────────┐ │
│  │ ParserService │  │LineageService │  │ CaliberService   │ │
│  └───────────────┘  └───────────────┘  └──────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│                        核心引擎层 (Core)                      │
│  ┌────────────┐ ┌────────────┐ ┌───────────┐ ┌────────────┐ │
│  │TableParser │ │Procedure   │ │Lineage    │ │Caliber     │ │
│  │            │ │Parser      │ │Tracer     │ │Tracer      │ │
│  └────────────┘ └────────────┘ └───────────┘ └────────────┘ │
│  ┌────────────┐ ┌────────────┐ ┌───────────┐ ┌────────────┐ │
│  │Caliber     │ │Layer       │ │TableName  │ │SQLBoundary │ │
│  │Extractor   │ │Detector    │ │Resolver   │ │Detector    │ │
│  └────────────┘ └────────────┘ └───────────┘ └────────────┘ │
├─────────────────────────────────────────────────────────────┤
│                        存储层 (Repository)                    │
│  ┌──────────────────────────────────────────────────────────┐│
│  │  SQLite (tables, procedures, table_lineages,             ││
│  │  field_mappings, caliber_infos, indicators)              ││
│  └──────────────────────────────────────────────────────────┘│
├─────────────────────────────────────────────────────────────┤
│                        数据源层                               │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────────────┐ │
│  │ .tab 文件     │  │ .prc 文件     │  │ 指标配置 Excel     │ │
│  └──────────────┘  └──────────────┘  └────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 数据流

```
.tab/.prc 文件
      │
      ▼
┌─────────────┐     ┌──────────────┐
│ TableParser │     │ProcedureParser│
└──────┬──────┘     └──────┬───────┘
       │                   │
       ▼                   ▼
┌─────────────────────────────────┐
│        Repository (SQLite)       │
└──────────────┬──────────────────┘
               │
       ┌───────┼───────┐
       ▼       ▼       ▼
┌─────────┐┌────────┐┌──────────┐
│Lineage  ││Caliber ││Indicator │
│Tracer   ││Tracer  ││Graph     │
└────┬────┘└───┬────┘└────┬─────┘
     │         │          │
     ▼         ▼          ▼
┌─────────────────────────────────┐
│         FastAPI Routes          │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│      D3.js Frontend UI          │
└─────────────────────────────────┘
```

---

## 3. 目录结构

```
DATA_RELY_ANALYSIS_SYS/
├── app/                          # FastAPI 应用层
│   ├── main.py                   # 应用入口，生命周期管理
│   ├── config.py                 # 配置管理（Settings）
│   ├── repository.py             # SQLite 数据访问层
│   ├── dependencies.py           # FastAPI 依赖注入
│   ├── services/                 # 业务服务层
│   │   ├── parser_service.py     # 文件解析服务
│   │   ├── lineage_service.py    # 血缘追溯服务
│   │   └── caliber_service.py    # 口径追溯服务
│   └── api/                      # API 路由层
│       ├── parse.py              # 解析相关接口
│       ├── lineage.py            # 血缘查询接口
│       ├── caliber.py            # 口径查询接口
│       └── tables.py             # 表查询接口
│
├── core/                         # 核心引擎层
│   ├── models.py                 # 数据模型定义（Pydantic + dataclass）
│   ├── base_sql_parser.py        # SQL 解析基类
│   ├── table_parser.py           # .tab 文件解析器
│   ├── procedure_parser.py       # .prc 存储过程解析器
│   ├── field_cleaner.py          # 字段名清洗器
│   ├── table_name_resolver.py    # 表名解析器
│   ├── lineage_tracer.py         # 血缘追溯引擎（BFS）
│   ├── caliber_tracer.py         # 口径追溯引擎（BFS + 条件累积）
│   ├── caliber_extractor.py      # SQL 口径条件提取器
│   ├── layer_detector.py         # 数据层级检测器
│   ├── sql_boundary_detector.py  # SQL 边界检测器
│   ├── indicator_models.py       # 指标数据模型
│   ├── indicator_config_parser.py# 指标配置解析器
│   ├── indicator_sql_parser.py   # 指标 SQL 解析器
│   ├── indicator_graph_builder.py# 指标依赖图构建器
│   └── data_validator.py         # 数据校验器
│
├── static/                       # 前端静态资源
│   ├── index.html                # 主页面
│   ├── css/
│   │   └── style.css             # 全局样式
│   └── js/
│       ├── app.js                # 应用主逻辑
│       ├── parse-tab.js          # 解析层 Tab
│       ├── search-panel.js       # 搜索面板
│       ├── lineage-graph.js      # 血缘图谱渲染
│       ├── detail-panel.js       # 详情面板
│       ├── caliber-tab.js        # 指标口径 Tab
│       └── indicator-tab.js      # 指标血缘 Tab
│
├── tests/                        # 测试目录
│   ├── test_lineage_tracer.py    # 血缘追溯测试
│   ├── test_caliber_tracer.py    # 口径追溯测试
│   ├── test_layer_detector.py    # 层级检测测试
│   ├── test_table_name_resolver.py
│   ├── test_sql_boundary_detector.py
│   ├── test_field_cleaner.py
│   ├── test_table_parser.py
│   ├── test_procedure_parser.py
│   ├── test_caliber_extractor.py
│   ├── test_indicator_config_parser.py
│   ├── test_indicator_sql_parser.py
│   ├── test_indicator_graph_builder.py
│   ├── test_data_validator.py
│   └── conftest.py               # pytest 配置
│
├── data/                         # 数据目录
│   ├── input/                    # 输入文件（.tab, .prc）
│   └── output/                   # 输出文件
│
├── docs/                         # 文档目录
│   ├── DESIGN_SPEC_ZH.md         # 设计规范
│   ├── API.md                    # API 文档
│   └── ...
│
├── requirements.txt              # Python 依赖
├── pyproject.toml                # 项目配置
├── Dockerfile                    # Docker 构建文件
├── docker-compose.yml            # Docker Compose 配置
└── README.md                     # 项目说明
```

---

## 4. 核心模块详解

### 4.1 解析层

#### 4.1.1 TableParser (`core/table_parser.py`)

**职责**: 解析 `.tab` 文件，提取表结构信息。

**输入格式**: 制表符分隔的文本文件，包含表名、字段名、字段类型、注释等。

**输出**: `TableInfo` 对象列表。

**关键方法**:
- `parse_file(filepath) -> list[TableInfo]`: 解析单个 `.tab` 文件
- `parse_directory(dir_path) -> list[TableInfo]`: 批量解析目录

#### 4.1.2 ProcedureParser (`core/procedure_parser.py`)

**职责**: 解析 Oracle PL/SQL 存储过程文件（`.prc`），提取 SQL 语句、表级血缘、字段级映射。

**继承关系**: 继承自 `BaseSQLParser`。

**关键方法**:
- `parse_file(filepath) -> ProcedureInfo`: 解析单个 `.prc` 文件
- `_extract_sql_statements(content) -> list[str]`: 提取 SQL 语句块
- `_parse_insert(stmt) -> tuple[str, list[FieldMapping]]`: 解析 INSERT 语句
- `_parse_update(stmt) -> tuple[str, list[FieldMapping]]`: 解析 UPDATE 语句
- `_parse_merge(stmt) -> tuple[str, list[FieldMapping]]`: 解析 MERGE 语句
- `_parse_delete(stmt) -> tuple[str, list[FieldMapping]]`: 解析 DELETE 语句

**解析策略**:
1. 使用 `sqlglot` 进行 AST 解析
2. 提取源表（FROM/JOIN）和目标表（INTO/UPDATE/MERGE INTO）
3. 提取字段映射关系（SELECT 列 → INSERT 列）
4. 提取 WHERE/JOIN 条件（用于口径追溯）

#### 4.1.3 CaliberExtractor (`core/caliber_extractor.py`)

**职责**: 从 SQL 语句中提取完整的加工口径条件。

**提取内容**:
- WHERE 条件
- JOIN 条件
- GROUP BY 子句
- HAVING 子句
- CTE（公共表表达式）
- 窗口函数
- 子查询
- 自定义函数调用

**关键方法**:
- `extract_from_sql(sql) -> list[CaliberInfo]`: 从 SQL 提取口径信息
- `from_dict(d) -> CaliberInfo`: 从字典构建口径对象

#### 4.1.4 FieldCleaner (`core/field_cleaner.py`)

**职责**: 规范化字段名，处理别名和大小写。

**关键方法**:
- `clean_field_name(name) -> str`: 清洗字段名

#### 4.1.5 TableNameResolver (`core/table_name_resolver.py`)

**职责**: 解析表名，处理 schema 前缀和别名。

**关键方法**:
- `resolve_table_name(name) -> str`: 解析完整表名
- `bare_table(name) -> str`: 获取不带 schema 的表名

#### 4.1.6 LayerDetector (`core/layer_detector.py`)

**职责**: 根据表名判断数据所属层级。

**层级定义**:

| 层级 | 标识 | 说明 |
|------|------|------|
| ODS | `ods` | 操作数据存储（源头层） |
| DIIS | `diis` | 数据集成层 |
| BASE | `base` | 基础数据层 |
| MDL | `mdl` | 模型数据层 |
| APP | `app` | 应用数据层 |
| EAST | `east` | 监管报送层 |
| CONFIG | `config` | 配置表 |
| OTHER | `other` | 其他 |

**关键方法**:
- `detect_layer(table_name) -> LayerType`: 检测表所属层级

#### 4.1.7 SQLBoundaryDetector (`core/sql_boundary_detector.py`)

**职责**: 检测存储过程内 DML 语句的边界，用于拆分复合 SQL 块。

### 4.2 追溯引擎层

#### 4.2.1 LineageTracer (`core/lineage_tracer.py`)

**职责**: 基于 BFS 算法实现字段级血缘追溯。

**核心算法**:
1. 从目标字段出发，构建 BFS 队列
2. 逐层查找上游来源（多策略回退）
3. 检测循环依赖，避免无限递归
4. 层级兼容性过滤（如 EAST 不直接追溯到 ODS）
5. 路径重建，生成 `FieldLineageChain`

**追溯策略优先级**:
1. caliber_infos 精确匹配
2. field_mappings 精确匹配
3. field_mappings schema 变体匹配
4. procedure 内 field_mappings 回退
5. table_lineages 表级回退

**关键方法**:
- `trace_lineage(table, field, direction, max_depth) -> LineageResult`: 追溯血缘
- `trace_upstream(table, field, max_depth) -> list[FieldLineageChain]`: 上游追溯
- `trace_downstream(table, field, max_depth) -> list[FieldLineageChain]`: 下游追溯
- `to_graph_result() -> GraphResult`: 转换为图谱数据

**层级兼容性规则**:
- EAST 表不应直接追溯到 ODS/DIIS 层
- ICL schema 的表作为 EAST 来源通常不正确
- OTHER 层中 bare_table 以 ICL_ 开头的表，作为 EAST 来源也不正确

#### 4.2.2 CaliberTracer (`core/caliber_tracer.py`)

**职责**: 在血缘基础上携带完整的加工条件，逐层累积口径。

**与 LineageTracer 的区别**:
- `LineageTracer` 返回 `FieldLineageChain`（节点+边，关注数据流向）
- `CaliberTracer` 返回 `CaliberChain`（每步含完整条件，关注加工口径）

**核心算法**:
1. BFS 逐层向上追溯
2. 每层携带 WHERE/JOIN/GROUP BY 条件
3. 条件逐层累积（`accumulated_where` / `accumulated_join`）
4. 支持跨存储过程的口径链路拼接
5. 支持多链路（UNION ALL 等合并场景）

**关键方法**:
- `trace_caliber(table, field, direction, max_depth) -> CaliberResult`: 追溯口径
- `generate_summary_text(result) -> str`: 生成可读的口径摘要

### 4.3 服务层

#### 4.3.1 ParserService (`app/services/parser_service.py`)

**职责**: 协调文件解析流程，管理解析任务状态。

**关键方法**:
- `parse_files(files, mode) -> ParseResult`: 解析上传的文件
- `parse_directory(dir_path, mode) -> ParseResult`: 解析目录
- `get_task_status(task_id) -> TaskStatus`: 获取任务状态

#### 4.3.2 LineageService (`app/services/lineage_service.py`)

**职责**: 提供血缘查询的业务逻辑封装。

**关键方法**:
- `query_lineage(table, field, direction, max_depth) -> LineageResult`: 查询血缘
- `get_table_info(table) -> TableInfo`: 获取表信息
- `get_field_list(table) -> list[str]`: 获取字段列表

#### 4.3.3 CaliberService (`app/services/caliber_service.py`)

**职责**: 提供口径查询的业务逻辑封装。

**关键方法**:
- `query_caliber(table, field, direction, max_depth, data_source) -> CaliberResult`: 查询口径
- `generate_summary(result) -> str`: 生成口径摘要

### 4.4 数据访问层

#### 4.4.1 Repository (`app/repository.py`)

**职责**: SQLite 数据访问封装，提供 CRUD 操作。

**数据表**:
- `tables`: 表结构信息
- `procedures`: 存储过程信息
- `table_lineages`: 表级血缘关系
- `field_mappings`: 字段级映射关系
- `caliber_infos`: 口径信息
- `indicators`: 指标配置

**关键方法**:
- `init_db()`: 初始化数据库
- `bulk_insert_tables(tables)`: 批量插入表
- `bulk_insert_procedures(procedures)`: 批量插入过程
- `bulk_insert_lineages(lineages)`: 批量插入血缘
- `bulk_insert_field_mappings(mappings)`: 批量插入字段映射
- `bulk_insert_caliber_infos(infos)`: 批量插入口径信息
- `get_all_tables() -> list[TableInfo]`: 获取所有表
- `get_table_by_name(name) -> Optional[TableInfo]`: 按名查询表
- `get_procedures() -> list[ProcedureInfo]`: 获取所有过程
- `get_field_mappings() -> list[FieldMapping]`: 获取所有字段映射
- `get_caliber_infos() -> list[dict]`: 获取所有口径信息

### 4.5 指标模块

#### 4.5.1 IndicatorConfigParser (`core/indicator_config_parser.py`)

**职责**: 解析 Excel 格式的指标配置文件。

#### 4.5.2 IndicatorSQLParser (`core/indicator_sql_parser.py`)

**职责**: 解析指标相关的 SQL 表达式。

#### 4.5.3 IndicatorGraphBuilder (`core/indicator_graph_builder.py`)

**职责**: 构建指标依赖关系图。

---

## 5. 数据模型

### 5.1 核心模型 (`core/models.py`)

#### 5.1.1 TableInfo

```python
@dataclass
class TableInfo:
    table_name: str              # 表名（含 schema）
    columns: list[ColumnInfo]    # 字段列表
    comment: str = ""            # 表注释
    data_source: str = "oracle"  # 数据源
```

#### 5.1.2 ColumnInfo

```python
@dataclass
class ColumnInfo:
    column_name: str             # 字段名
    data_type: str = ""          # 数据类型
    comment: str = ""            # 字段注释
    is_primary_key: bool = False # 是否主键
```

#### 5.1.3 ProcedureInfo

```python
@dataclass
class ProcedureInfo:
    full_name: str                           # 过程全名
    source_tables: set[str]                  # 源表集合
    target_tables: set[str]                  # 目标表集合
    sql_statements: list[str]                # SQL 语句列表
    table_lineages: list[TableLineage]       # 表级血缘
    field_mappings: list[FieldMapping]       # 字段映射
    caliber_infos: list[CaliberInfo]         # 口径信息
```

#### 5.1.4 TableLineage

```python
@dataclass
class TableLineage:
    source_table: str            # 源表
    target_table: str            # 目标表
    procedure: str = ""          # 所属过程
    confidence: float = 1.0      # 置信度
```

#### 5.1.5 FieldMapping

```python
@dataclass
class FieldMapping:
    source_table: str            # 源表
    source_column: str           # 源字段
    target_table: str            # 目标表
    target_column: str           # 目标字段
    transform_logic: str = ""    # 转换逻辑
    procedure: str = ""          # 所属过程
    confidence: float = 1.0      # 置信度
```

#### 5.1.6 CaliberInfo

```python
@dataclass
class CaliberInfo:
    source_table: str                    # 源表
    source_column: str                   # 源字段
    target_table: str                    # 目标表
    target_column: str                   # 目标字段
    transform_logic: str = ""            # 转换逻辑
    where_conditions: list[SQLCondition] # WHERE 条件
    join_conditions: list[SQLCondition]  # JOIN 条件
    group_by_clause: str = ""            # GROUP BY
    having_clause: str = ""              # HAVING
    procedure: str = ""                  # 所属过程
    step_num: int = 0                    # 步骤序号
    step_desc: str = ""                  # 步骤说明
    data_source: str = "oracle"          # 数据源
    raw_sql_fragment: str = ""           # 原始 SQL 片段
    confidence: float = 1.0              # 置信度
    source_table_layer: str = ""         # 源表层级
    target_table_layer: str = ""         # 目标表层级
    accumulated_where: list[SQLCondition]# 累积 WHERE
    accumulated_join: list[SQLCondition] # 累积 JOIN
```

#### 5.1.7 SQLCondition

```python
@dataclass
class SQLCondition:
    raw_text: str                # 原始条件文本
    condition_type: str = ""     # 条件类型 (where/join/having)
    tables_involved: list[str]   # 涉及的表
```

### 5.2 追溯结果模型

#### 5.2.1 LineageResult

```python
@dataclass
class LineageResult:
    target_table: str                    # 目标表
    target_field: str                    # 目标字段
    chains: list[FieldLineageChain]      # 血缘链路
    total_nodes: int                     # 总节点数
    total_edges: int                     # 总边数
    query_time_ms: float                 # 查询耗时
```

#### 5.2.2 FieldLineageChain

```python
@dataclass
class FieldLineageChain:
    source_table: str                    # 源表
    source_column: str                   # 源字段
    target_table: str                    # 目标表
    target_column: str                   # 目标字段
    depth: int                           # 深度
    procedure: str                       # 所属过程
    transform_logic: str                 # 转换逻辑
    confidence: float                    # 置信度
```

#### 5.2.3 CaliberResult

```python
@dataclass
class CaliberResult:
    target_table: str                    # 目标表
    target_column: str                   # 目标字段
    chains: list[CaliberChain]           # 口径链路
    total_steps: int                     # 总步骤数
    total_conditions: int                # 总条件数
    query_time_ms: float                 # 查询耗时
```

#### 5.2.4 CaliberChain

```python
@dataclass
class CaliberChain:
    target_table: str                    # 目标表
    target_column: str                   # 目标字段
    steps: list[CaliberInfo]             # 口径步骤
    depth: int                           # 深度
```

### 5.3 图谱模型

#### 5.3.1 GraphResult

```python
@dataclass
class GraphResult:
    nodes: list[GraphNode]               # 节点列表
    edges: list[GraphEdge]               # 边列表
```

#### 5.3.2 GraphNode

```python
@dataclass
class GraphNode:
    id: str                              # 节点 ID
    label: str                           # 显示标签
    table_name: str                      # 表名
    field_name: str                      # 字段名
    layer: str                           # 层级
    is_target: bool = False              # 是否目标节点
```

#### 5.3.3 GraphEdge

```python
@dataclass
class GraphEdge:
    source: str                          # 源节点 ID
    target: str                          # 目标节点 ID
    label: str = ""                      # 边标签
    procedure: str = ""                  # 所属过程
    confidence: float = 1.0              # 置信度
```

---

## 6. API 接口

### 6.1 解析接口

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/api/parse/upload` | 上传文件解析 |
| POST | `/api/parse/directory` | 解析目录 |
| GET | `/api/parse/status/{task_id}` | 获取任务状态 |

### 6.2 表查询接口

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/tables` | 获取所有表列表 |
| GET | `/api/tables/{table_name}` | 获取表详情 |
| GET | `/api/tables/{table_name}/fields` | 获取表字段列表 |
| GET | `/api/tables/search?q=xxx` | 搜索表 |

### 6.3 血缘查询接口

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/lineage/field` | 查询字段血缘 |
| GET | `/api/lineage/table` | 查询表级血缘 |
| GET | `/api/lineage/graph` | 获取图谱数据 |

**查询参数**:
- `table`: 表名（必填）
- `field`: 字段名（必填）
- `direction`: 追溯方向（`upstream`/`downstream`/`both`，默认 `upstream`）
- `max_depth`: 最大深度（默认 10）

### 6.4 口径查询接口

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/caliber/trace` | 追溯指标口径 |
| GET | `/api/caliber/summary` | 获取口径摘要 |

**查询参数**:
- `table`: 表名（必填）
- `field`: 字段名（必填）
- `direction`: 追溯方向（`upstream`/`downstream`/`both`）
- `max_depth`: 最大深度
- `data_source`: 数据源筛选（`oracle`/`tdh`/`gbase`）

---

## 7. 前端架构

### 7.1 页面结构

前端采用单页面应用（SPA）架构，基于原生 JavaScript + D3.js 实现，包含四个主要 Tab：

| Tab | 文件 | 功能 |
|-----|------|------|
| 解析层 | `parse-tab.js` | 文件上传、解析进度、结果展示 |
| 展示层 | `search-panel.js` + `lineage-graph.js` + `detail-panel.js` | 血缘搜索、图谱渲染、详情展示 |
| 指标口径 | `caliber-tab.js` | 口径搜索、Pipeline 可视化 |
| 指标血缘 | `indicator-tab.js` | 指标搜索、依赖图展示 |

### 7.2 核心模块

#### 7.2.1 app.js

**职责**: 应用初始化、Tab 切换、全局状态管理。

**关键函数**:
- `switchTab(tabName)`: 切换 Tab
- `showSystemStats()`: 显示系统统计

#### 7.2.2 search-panel.js

**职责**: 表名/字段名搜索、级联选择。

**关键函数**:
- `onTableInput()`: 表名输入处理
- `onFieldInput()`: 字段名输入处理
- `setMode(mode)`: 设置查询方向
- `executeFieldQuery()`: 执行血缘查询

#### 7.2.3 lineage-graph.js

**职责**: D3.js 图谱渲染、交互。

**关键函数**:
- `renderGraph(graphData)`: 渲染图谱
- `highlightNode(nodeId)`: 高亮节点
- `resetView()`: 重置视图
- `zoomBy(factor)`: 缩放
- `fitView()`: 适应视图

#### 7.2.4 detail-panel.js

**职责**: 查询详情展示。

**关键函数**:
- `showDetail(data)`: 显示详情
- `closeDetail()`: 关闭详情

#### 7.2.5 caliber-tab.js

**职责**: 口径搜索、Pipeline 可视化、详情抽屉。

**关键函数**:
- `executeCaliberQuery()`: 执行口径查询
- `renderPipeline(chains)`: 渲染 Pipeline
- `showStepDetail(step)`: 显示步骤详情
- `closeCaliberDrawer()`: 关闭抽屉

#### 7.2.6 parse-tab.js

**职责**: 文件上传、解析控制、进度展示。

**关键函数**:
- `handleFileSelect(event)`: 文件选择
- `handleDragOver(event)`: 拖拽处理
- `startParsing()`: 开始解析
- `triggerFullParse()`: 全量解析

### 7.3 样式规范

**CSS 变量**:
```css
:root {
    --primary-color: #3b82f6;
    --success-color: #10b981;
    --warning-color: #f59e0b;
    --error-color: #ef4444;
    --bg-color: #0f172a;
    --surface-color: #1e293b;
    --text-color: #e2e8f0;
    --text-muted: #94a3b8;
    --border-color: #334155;
}
```

**层级颜色**:
| 层级 | 颜色 |
|------|------|
| ODS | `#10b981` (绿色) |
| DIIS | `#06b6d4` (青色) |
| BASE | `#3b82f6` (蓝色) |
| MDL | `#8b5cf6` (紫色) |
| APP | `#f59e0b` (橙色) |
| EAST | `#ef4444` (红色) |

---

## 8. 依赖关系

### 8.1 Python 依赖

| 包名 | 版本 | 用途 |
|------|------|------|
| `fastapi` | >=0.115.0 | Web 框架 |
| `uvicorn` | >=0.30.0 | ASGI 服务器 |
| `sqlglot` | >=26.0.0 | SQL 解析引擎 |
| `pydantic` | >=2.0.0 | 数据验证 |
| `pydantic-settings` | >=2.0.0 | 配置管理 |
| `aiosqlite` | >=0.20.0 | 异步 SQLite |
| `python-multipart` | >=0.0.9 | 文件上传 |
| `openpyxl` | >=3.1.0 | Excel 解析 |
| `pytest` | >=8.0.0 | 测试框架 |
| `pytest-asyncio` | >=0.24.0 | 异步测试 |
| `httpx` | >=0.27.0 | HTTP 客户端（测试） |

### 8.2 前端依赖

| 库 | 版本 | 用途 |
|----|------|------|
| `D3.js` | v7 | SVG 图谱渲染 |

### 8.3 模块依赖图

```
app/main.py
├── app/config.py
├── app/repository.py
├── app/dependencies.py
├── app/services/
│   ├── parser_service.py
│   │   ├── core/table_parser.py
│   │   └── core/procedure_parser.py
│   │       ├── core/base_sql_parser.py
│   │       ├── core/field_cleaner.py
│   │       ├── core/table_name_resolver.py
│   │       ├── core/caliber_extractor.py
│   │       └── core/sql_boundary_detector.py
│   ├── lineage_service.py
│   │   └── core/lineage_tracer.py
│   │       ├── core/layer_detector.py
│   │       ├── core/table_name_resolver.py
│   │       └── core/models.py
│   └── caliber_service.py
│       └── core/caliber_tracer.py
│           ├── core/caliber_extractor.py
│           ├── core/layer_detector.py
│           ├── core/table_name_resolver.py
│           └── core/models.py
└── app/api/
    ├── parse.py
    ├── lineage.py
    ├── caliber.py
    └── tables.py
```

---

## 9. 项目运行

### 9.1 环境要求

- Python 3.12+
- pip 或 uv（推荐）

### 9.2 安装依赖

```bash
# 使用 pip
pip install -r requirements.txt

# 或使用 uv（推荐）
uv sync
```

### 9.3 启动服务

```bash
# 开发模式（自动重载）
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# 生产模式
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4
```

### 9.4 访问服务

- 前端页面: `http://localhost:8000`
- API 文档: `http://localhost:8000/docs`
- ReDoc 文档: `http://localhost:8000/redoc`

### 9.5 Docker 部署

```bash
# 构建镜像
docker build -t data-lineage-system .

# 运行容器
docker run -p 8000:8000 -v ./data:/app/data data-lineage-system

# 或使用 Docker Compose
docker-compose up -d
```

### 9.6 配置项

通过环境变量或 `.env` 文件配置：

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| `DATA_DIR` | `./data` | 数据目录 |
| `INPUT_DIR` | `./data/input` | 输入文件目录 |
| `DB_PATH` | `./data/lineage.db` | SQLite 数据库路径 |
| `HOST` | `0.0.0.0` | 服务地址 |
| `PORT` | `8000` | 服务端口 |
| `MAX_DEPTH` | `10` | 默认追溯深度 |
| `WORKERS` | `1` | 工作进程数 |

---

## 10. 测试

### 10.1 运行测试

```bash
# 运行所有测试
pytest

# 运行特定测试
pytest tests/test_lineage_tracer.py

# 带覆盖率报告
pytest --cov=core --cov=app --cov-report=html
```

### 10.2 测试覆盖模块

| 模块 | 测试文件 |
|------|----------|
| TableParser | `tests/test_table_parser.py` |
| ProcedureParser | `tests/test_procedure_parser.py` |
| LineageTracer | `tests/test_lineage_tracer.py` |
| CaliberTracer | `tests/test_caliber_tracer.py` |
| CaliberExtractor | `tests/test_caliber_extractor.py` |
| LayerDetector | `tests/test_layer_detector.py` |
| TableNameResolver | `tests/test_table_name_resolver.py` |
| SQLBoundaryDetector | `tests/test_sql_boundary_detector.py` |
| FieldCleaner | `tests/test_field_cleaner.py` |
| IndicatorConfigParser | `tests/test_indicator_config_parser.py` |
| IndicatorSQLParser | `tests/test_indicator_sql_parser.py` |
| IndicatorGraphBuilder | `tests/test_indicator_graph_builder.py` |
| DataValidator | `tests/test_data_validator.py` |

---

## 11. 关键算法

### 11.1 BFS 血缘追溯算法

```
输入: 目标表 T, 目标字段 F, 最大深度 D
输出: 血缘链路列表

1. 初始化:
   - visited = {(T, F)}
   - queue = [BFSNode(T, F, depth=0)]
   - bfs_tree = {(T, F): BFSNode(T, F, depth=0)}
   - leaf_paths = []

2. BFS 循环:
   while queue 非空:
     current = queue.popleft()
     
     # 终止条件检查
     if current.layer == ODS/CONFIG:
       leaf_paths.add(reconstruct_path(current))
       continue
     if current.depth >= D:
       leaf_paths.add(reconstruct_path(current))
       continue
     
     # 查找上游来源（多策略）
     sources = find_upstream_sources(current.table, current.field)
     
     if sources 为空:
       leaf_paths.add(reconstruct_path(current))
       continue
     
     # 层级兼容性过滤
     for src in sources:
       if is_layer_compatible(src.table, current.table):
         src_key = make_key(src.table, src.field)
         if src_key not in visited:
           visited.add(src_key)
           node = BFSNode(src.table, src.field, depth=current.depth+1)
           node.parent_key = make_key(current.table, current.field)
           bfs_tree[src_key] = node
           queue.append(node)

3. 路径转换:
   for path in leaf_paths:
     chain = path_to_chain(path)
     chains.add(chain)

4. 返回 chains
```

### 11.2 口径条件累积算法

```
输入: 口径链路 steps[]
输出: 每步携带累积条件

acc_where = []
acc_join = []

for step in steps:
  # 将当前步骤的条件加入累积
  acc_where.extend(step.where_conditions)
  acc_join.extend(step.join_conditions)
  
  # 去重
  acc_where = deduplicate(acc_where, by=raw_text)
  acc_join = deduplicate(acc_join, by=raw_text)
  
  # 注入到当前步骤
  step.accumulated_where = acc_where
  step.accumulated_join = acc_join
```

### 11.3 多策略回退查找

```
查找目标字段 (T, F) 的上游来源:

策略 1: caliber_infos 精确匹配
  - 在 _target_idx 中查找 (T, F)
  - 命中 → 返回

策略 2: caliber_infos schema 变体匹配
  - 尝试 RRP_MDL.T, RRP_EAST.T, T
  - 命中 → 返回

策略 3: field_mappings 精确匹配
  - 在 _fm_target_idx 中查找 T.F
  - 命中 → 转换为 CaliberSourceRecord 返回

策略 4: field_mappings schema 变体匹配
  - 同策略 2，尝试 schema 变体

策略 5: procedure field_mappings 回退
  - 查找以 T 为目标的 procedure
  - 遍历其 field_mappings

策略 6: table_lineages 表级回退
  - 查找以 T 为目标的 table_lineages
  - 降级到表级血缘，匹配同名字段
```

---

## 12. 扩展指南

### 12.1 添加新的 SQL 方言支持

1. 在 `core/base_sql_parser.py` 中扩展 `dialect` 参数
2. 在 `core/procedure_parser.py` 中添加方言特定的解析逻辑
3. 添加对应的测试用例

### 12.2 添加新的数据层级

1. 在 `core/layer_detector.py` 的 `LayerType` 枚举中添加新层级
2. 更新 `detect_layer()` 函数的匹配规则
3. 更新前端 CSS 中的层级颜色映射
4. 更新 `LineageTracer` 和 `CaliberTracer` 中的层级兼容性规则

### 12.3 添加新的追溯策略

1. 在 `LineageTracer._find_upstream_sources()` 或 `CaliberTracer._find_upstream_sources()` 中添加新策略
2. 确保新策略在回退链中的正确位置
3. 添加对应的索引构建逻辑（如需要）
4. 编写单元测试

### 12.4 添加新的 API 端点

1. 在 `app/api/` 下创建新的路由文件
2. 在 `app/main.py` 中注册路由
3. 使用 `get_lineage_service()` 等依赖注入获取服务
4. 遵循现有的响应格式和错误处理模式

### 12.5 添加新的前端 Tab

1. 在 `static/index.html` 中添加 Tab 按钮和内容区域
2. 创建新的 JS 文件（如 `new-tab.js`）
3. 在 `app.js` 中添加 Tab 切换逻辑
4. 在 HTML 中引入新的 JS 文件
5. 遵循现有的 CSS 样式规范
