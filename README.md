# 数据血缘分析系统 (Data Lineage Analysis System)

> 项目版本: v2.2.0
> 最后更新: 2026-05-22

## 项目简介

数据血缘分析系统，用于解析 Oracle/数仓 SQL 脚本，构建字段级血缘图谱，提供口径追溯与可视化能力。

### 核心能力

- **SQL 脚本解析**: 支持 Oracle DDL/DML/存储过程、数仓各层脚本自动解析
- **字段级血缘追溯**: 基于 BFS 算法构建表级/字段级血缘关系图，支持上下游追溯
- **数仓分层支持**: 完整支持 EDW 数仓分层架构 (SRC → MSL → ITL → IOL → ICL → IML → IDL → IEL → DQC)，每层独立层级标识
- **分区交换表识别**: 自动识别 `_ex` 交换中间表，正确映射为正式表名，避免 Type5 ICL 共性加工模式血缘丢失
- **口径追溯**: 自动提取字段加工口径，支持口径文档导出 (Excel)
- **指标血缘分析**: 针对指标表的专项血缘构建与可视化
- **可视化展示**: 基于 D3.js 的前端血缘图谱可视化，支持层级着色、节点拖拽、路径高亮

### 技术栈

| 层级 | 技术 |
|------|------|
| 后端框架 | FastAPI + Python 3.11+ |
| 数据模型 | Pydantic v2 + dataclass |
| SQL 解析 | sqlglot |
| 前端可视化 | D3.js v7 + 原生 JS |
| 缓存 | 内存 TTL/LRU 缓存 + pickle/json 双写持久化 |

## 快速开始

### 环境要求

- Python 3.11+
- pip / uv

### 安装与启动

```bash
# 1. 安装依赖
pip install -r requirements.txt

# 2. 启动服务
python run_app.py
```

服务默认运行在 `http://localhost:8899`，API 文档可通过 `http://localhost:8899/docs` 访问。

前端页面：`http://localhost:8899/static/index.html`

### 数据准备

将 SQL 脚本文件放置到 `SOURCE_DATA/` 目录下（该目录不参与版本控制），系统按以下结构组织：

```
SOURCE_DATA/
├── EDW/              # 数仓脚本
│   ├── ddl/          # 建表脚本
│   └── dml/          # 数据跑批脚本 (含 Type5 ICL 共性加工模式)
├── BRT/              # 报表脚本
├── CCR/              # 其他业务脚本
└── manifest.yml      # 各数据源配置（可选）
```

## 项目结构

```
DATA_RELY_ANALYSIS_SYS/
├── app/                          # 应用层 (FastAPI)
│   ├── api/                      # API 路由 (lineage, caliber, indicator, parse, system)
│   ├── services/                 # 业务服务 (parser, lineage, caliber, indicator, progress)
│   ├── models/                   # Pydantic 请求/响应模型
│   ├── utils/                    # 工具类 (cache_manager, path_utils, file_handler, event_bus)
│   ├── config.py                 # 配置管理
│   ├── dependencies.py           # 依赖注入
│   └── repository.py             # 数据仓库层
├── core/                         # 核心引擎层
│   ├── models.py                 # 核心数据模型 (dataclass)
│   ├── layer_detector.py         # 数据分层检测（支持 17 种层级类型）
│   ├── base_tracer.py            # 血缘追溯基类（层级兼容性判断）
│   ├── lineage_tracer.py         # 字段级 BFS 血缘追溯引擎
│   ├── caliber_tracer.py         # 口径 BFS 追溯引擎
│   ├── caliber_extractor.py      # 口径信息提取器
│   ├── caliber_exporter.py       # 口径文档导出器
│   ├── table_parser.py           # Oracle 表结构解析器
│   ├── procedure_parser.py       # 存储过程解析器
│   ├── parser_protocol.py        # 解析器协议 (Protocol)
│   ├── parser_registry.py        # 解析器注册表
│   ├── table_name_resolver.py    # 表名归一化/解析
│   ├── field_cleaner.py          # 字段名清洗
│   ├── adapters/                 # 解析器适配器 (Oracle tab/prc/warehouse/indicator)
│   └── warehouse/                # 数仓脚本解析器
│       ├── dml_parser.py         # DML 解析（支持 _ex 交换表映射）
│       ├── ddl_parser.py         # DDL 解析
│       ├── temp_table_filter.py  # 临时表/交换表过滤器
│       ├── schema_resolver.py    # Schema 变量替换 (${xxx_schema})
│       └── warehouse_parser.py   # 数仓统一入口
├── static/                       # 前端静态文件
│   ├── js/
│   │   └── layer-config.js      # 层级配置（17 种层级颜色/标签/顺序）
│   └── css/
│       ├── style.css            # 主样式（含 CSS 变量）
│       └── style.css            # 静态页面样式
├── tests/                        # 测试用例
├── output/                       # 缓存输出目录
│   ├── lineage_data.pkl          # Pickle 序列化缓存
│   └── lineage_data.json         # JSON 格式缓存
├── SOURCE_DATA/                  # 真实数据目录 (.gitignore 忽略，仅保留空目录+manifest.yml)
├── requirements.txt
└── run_app.py                     # 启动入口
```

## 架构设计

### 三层架构

```
app/api/ ──→ app/services/ ──→ core/
  路由层        编排层          纯算法引擎
```

- **路由层 (app/api/)**: 参数校验、响应封装，不含业务逻辑
- **编排层 (app/services/)**: 服务编排、缓存管理、事件总线、横切关注点
- **引擎层 (core/)**: 纯算法实现，不依赖 FastAPI，可独立测试

### 数仓分层架构

系统完整支持企业级数仓分层，每种 schema 映射到独立的层级类型：

```
SRC (原始数据层)     ← 外部源系统数据接入
  ↓
MSL (源系统层)       ← 源系统数据标准化
  ↓
ITL (接口层)         ← 接口数据暂存
  ↓
IOL (操作层)         ← 操作型数据加工
  ↓
ICL (共性加工层)     ← 公共维度/指标加工 ★ Type5 CTAS+INSERT+EXCHANGE 模式
  ↓
IML (模型层)         ← 主题模型/宽表构建
  ↓
IDL (接口层)         ← 下游接口输出
  ↓
IEL (外部层)         ← 外部机构报送
  ↓
DQC (数据质量层)     ← 数据质量检查
```

**Type5 ICL 共性加工模式**是系统的核心支持场景：

```
1. CTAS CREATE TABLE tmp_01 AS SELECT ... FROM ${iml_schema}.xxx ...
2. INSERT INTO ${icl_schema}.target_table_ex SELECT FROM tmp_01 ... LEFT JOIN ${iol_schema}.yyy ...
3. ALTER TABLE ${icl_schema}.target_table EXCHANGE PARTITION p_${date} WITH TABLE ${icl_schema}.target_table_ex
```

系统通过以下机制确保此类脚本的血缘不丢失：
- [`temp_table_filter.py`](core/warehouse/temp_table_filter.py): 区分 `_ex` 交换表和真正的临时表
- [`dml_parser.py`](core/warehouse/dml_parser.py): 将 `INSERT INTO xxx_ex` 目标映射为正式表名

### 层级检测机制

[`layer_detector.py`](core/layer_detector.py) 支持 **17 种层级类型**，优先级从高到低：

1. **规则匹配** (`LayerRule`): 表名正则匹配（如 `^EAST` → east, `^B_` → base）
2. **Schema 匹配** (`SchemaRule`): 按 schema 名精确映射（如 `ICL` → icl, `IML` → iml）
3. **短名匹配** (`BareNameRule`): 无 schema 时按短名模式匹配
4. **兜底**: 返回 `other`

可通过各数据源的 `manifest.yml` 自定义层级规则。

### 解析器扩展机制

通过 `Protocol` + `Registry` 实现开闭原则：

1. 实现 `ParserProtocol` 接口
2. 调用 `register()` 注册解析器
3. 系统根据文件扩展名和数据源配置自动路由到对应解析器

### 血缘追溯引擎

基于 BFS (广度优先搜索) 算法：

- 预构建多层字典索引，将 O(N) 查询降为 O(1)
- 循环依赖检测与环路防护
- 层级兼容性过滤（EAST 层不可直接跳过数仓中间层）
- TMP 临时表桥接策略
- 同表字段变换折叠
- 交换表 (_ex) 自动映射为正式表名

## 主要 API

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 文件解析 | POST | `/api/parse/upload` | 上传 SQL 文件并解析 |
| 目录解析 | POST | `/api/parse/directory` | 解析指定目录下所有 SQL 文件 |
| 血缘查询 | POST | `/api/lineage/query` | 查询字段级血缘关系（支持 upstream/downstream/both） |
| 快捷血缘查询 | GET | `/api/lineage/{table}/{field}` | GET 方式快速查询字段级血缘 |
| 口径查询 | POST | `/api/caliber/query` | 查询字段加工口径 |
| 口径导出 | POST | `/api/caliber/export` | 导出口径文档 (Excel) |
| 指标血缘 | POST | `/api/indicator/build` | 构建指标血缘图 |
| 表搜索 | GET | `/api/tables?keyword=xxx` | 搜索表名（倒排索引加速） |
| 过程搜索 | GET | `/api/procedures?keyword=xxx` | 搜索存储过程名称 |
| 系统统计 | GET | `/api/stats` | 获取系统统计信息（表数/血缘数/缓存状态） |
| 缓存重建 | POST | `/api/cache/rebuild` | 强制清空并重建内存索引 |
| 层级配置 | GET | `/api/system/layers` | 获取当前系统的层级颜色/标签/顺序配置 |

详细 API 文档请参考启动后的 Swagger UI (`/docs`)。

## 近期修复记录

### v2.2.0 (2026-05-22)

#### 🔧 Bug 修复

**ICL 层血缘丢失问题（核心修复）**

- **根因**: Type5 ICL 共性加工模式中，`INSERT INTO xxx_ex` 的目标表被 `TempTableFilter` 当作临时表过滤；同时 `EXCHANGE PARTITION WITH xxx_ex` 的源表也被过滤
- **修复**:
  - [`temp_table_filter.py`](core/warehouse/temp_table_filter.py): 新增 `is_exchange_table()` / `resolve_exchange_table()` 方法，区分 `_ex` 交换表和 TMP 临时表
  - [`dml_parser.py`](core/warehouse/dml_parser.py): INSERT 和 EXCHANGE 语句中的 `_ex` 表自动映射为正式表名
  - [`lineage_tracer.py`](core/lineage_tracer.py): 修复 `to_graph_result()` 中 upstream 模式边方向反转 Bug

**验证结果**: `ICL.CMM_INDV_CUST_BASIC_INFO.CUST_ID` 查询从 **1 节点 / 0 边 / 4 映射** 提升至 **83 节点 / 82 边 / 790 映射**，正确显示 IML/IOL/MSL 等上游来源

#### ✨ 新功能

**数仓独立层级体系**

- [`layer_detector.py`](core/layer_detector.py): `LayerType` 枚举从 7 种扩展至 **17 种**，新增 SRC/MSL/ITL/IOL/ICL/IML/IDL/IEL/DQC 独立层级
- [`base_tracer.py`](core/base_tracer.py): 层级兼容性规则增强，EAST 层不可直接从数仓中间层跳过
- 前端 [`layer-config.js`](static/js/layer-config.js) + CSS: 同步更新所有新层级的颜色/标签/样式

**层级映射对照表**

| Schema | 层级 | 标签 | 颜色 |
|--------|------|------|------|
| SRC | src | 原始数据层 | `#34d399` |
| MSL | msl | 源系统层 | `#2dd4bf` |
| ITL | itl | 接口层 | `#22d3ee` |
| IOL | iol | 操作层 | `#38bdf8` |
| ICL | icl | 共性加工层 | `#818cf8` |
| IML | iml | 模型层 | `#a78bfa` |
| IDL | idl | 接口层 | `#c084fc` |
| IEL | iel | 外部层 | `#e879f9` |
| DQC | dqc | 数据质量层 | `#f472b6` |
| RRP_MDL | base | 基础层 | `#818cf8` |
| RRP_EAST | east | EAST 报送层 | `#f87171` |

## 安全说明

- `SOURCE_DATA/` 目录包含真实业务数据，已在 `.gitignore` 中配置，**不会上传至代码仓库**
- `.gitignore` 规则保留空目录结构（`.gitkeep`）和 `manifest.yml` 配置文件
- 系统无外部数据库依赖，所有数据存储在内存/本地缓存中
- 敏感数据请妥善保管，勿将真实数据提交至公共仓库

## 测试

```bash
# 运行全部测试
python -m pytest tests/

# 运行指定测试
python -m pytest tests/test_lineage.py -v

# 单元验证 DML 解析（示例）
python3.11 -c "
from core.warehouse.dml_parser import DMLParser
parser = DMLParser()
result = parser.parse_file('SOURCE_DATA/EDW/dml/icl_cmm_indv_cust_basic_info.sql')
print(f'表级血缘: {len(result.table_lineages)}, 字段映射: {len(result.field_mappings)}')
"
```

## 相关文档

- [架构设计评估报告](ARCHITECTURE_REVIEW.md)
- [详细架构解决方案](ARCHITECTURE_DETAILED_SOLUTIONS.md)
- [代码 Wiki](CODE_WIKI.md)

## 许可证

本项目采用 [MIT 许可证](LICENSE)。
