# 数据血缘分析系统 (Data Lineage Analysis System)

> 项目版本: v2.1.0
> 最后更新: 2026-05-21

## 项目简介

数据血缘分析系统，用于解析 Oracle/数仓 SQL 脚本，构建字段级血缘图谱，提供口径追溯与可视化能力。

### 核心能力

- **SQL 脚本解析**: 支持 Oracle DDL/DML/存储过程、数仓各层 (EDW IOL/IDL/IML/ICL/IEL) 脚本自动解析
- **字段级血缘追溯**: 基于 BFS 算法构建表级/字段级血缘关系图，支持上下游追溯
- **口径追溯**: 自动提取字段加工口径，支持口径文档导出 (Excel)
- **指标血缘分析**: 针对指标表的专项血缘构建与可视化
- **可视化展示**: 基于 D3.js 的前端血缘图谱可视化

### 技术栈

| 层级 | 技术 |
|------|------|
| 后端框架 | FastAPI + Python 3.11+ |
| 数据模型 | Pydantic v2 + dataclass |
| SQL 解析 | sqlglot |
| 前端可视化 | D3.js v7 + 原生 JS |
| 缓存 | 内存 TTL/LRU 缓存 + pickle 序列化 |

## 快速开始

### 环境要求

- Python 3.11+
- pip / uv

### 安装与启动

```bash
# 1. 安装依赖
pip install -r requirements.txt

# 2. 启动服务
python main.py
```

服务默认运行在 `http://localhost:8000`，API 文档可通过 `http://localhost:8000/docs` 访问。

### 数据准备

将 SQL 脚本文件放置到 `SOURCE_DATA/` 目录下（该目录不参与版本控制），系统按以下结构组织：

```
SOURCE_DATA/
├── EDW/              # 数仓脚本
│   ├── ddl/          # 建表脚本 (IOL/IDL/IML/ICL 分层)
│   └── dml/          # 数据跑批脚本
├── BRT/              # 报表脚本
└── CCR/              # 其他业务脚本
```

## 项目结构

```
DATA_RELY_ANALYSIS_SYS/
├── app/                          # 应用层 (FastAPI)
│   ├── api/                      # API 路由 (lineage, caliber, indicator, parse, system)
│   ├── services/                 # 业务服务 (parser, lineage, caliber, indicator, progress)
│   ├── models/                   # Pydantic 请求/响应模型
│   ├── utils/                    # 工具类 (cache_manager, path_utils, file_handler)
│   ├── config.py                 # 配置管理
│   ├── dependencies.py           # 依赖注入
│   └── repository.py             # 数据仓库层
├── core/                         # 核心引擎层
│   ├── models.py                 # 核心数据模型 (dataclass)
│   ├── indicator_models.py       # 指标血缘数据模型
│   ├── lineage_tracer.py         # 字段级 BFS 血缘追溯引擎
│   ├── caliber_tracer.py         # 口径 BFS 追溯引擎
│   ├── caliber_extractor.py      # 口径信息提取器
│   ├── caliber_exporter.py       # 口径文档导出器
│   ├── indicator_graph_builder.py # 指标血缘图构建器
│   ├── indicator_sql_parser.py   # 指标 SQL 解析器
│   ├── table_parser.py           # Oracle 表结构解析器
│   ├── procedure_parser.py       # 存储过程解析器
│   ├── parser_protocol.py        # 解析器协议 (Protocol)
│   ├── parser_registry.py        # 解析器注册表
│   ├── layer_detector.py         # 数据分层检测
│   ├── table_name_resolver.py    # 表名归一化/解析
│   ├── field_cleaner.py          # 字段名清洗
│   ├── data_validator.py         # 数据校验
│   ├── sql_boundary_detector.py  # SQL 边界检测
│   ├── adapters/                 # 解析器适配器 (Oracle tab/prc)
│   └── warehouse/                # 数仓脚本解析器 (DDL/DML/CTL)
├── static/                       # 前端静态文件 (D3.js + 原生 JS)
├── tests/                        # 测试用例
├── deprecated/                   # 已废弃代码
├── AI指标血缘分析_数仓&管架/      # 示例数据文件 (SQL 脚本)
├── SOURCE_DATA/                  # 真实数据目录 (已忽略，不上传)
├── requirements.txt
└── main.py
```

## 架构设计

### 三层架构

```
app/api/ ──→ app/services/ ──→ core/
  路由层        编排层          纯算法引擎
```

- **路由层 (app/api/)**: 参数校验、响应封装，不含业务逻辑
- **编排层 (app/services/)**: 服务编排、缓存管理、横切关注点
- **引擎层 (core/)**: 纯算法实现，不依赖 FastAPI，可独立测试

### 解析器扩展机制

通过 `Protocol` + `Registry` 实现开闭原则：

1. 实现 `ParserProtocol` 接口
2. 调用 `register()` 注册解析器
3. 系统根据文件扩展名自动路由到对应解析器

### 血缘追溯引擎

基于 BFS (广度优先搜索) 算法：

- 预构建多层字典索引，将 O(N) 查询降为 O(1)
- 循环依赖检测与环路防护
- 层级兼容性过滤
- TMP 临时表桥接策略
- 同表字段变换折叠

## 主要 API

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 文件解析 | POST | `/api/parse/upload` | 上传 SQL 文件并解析 |
| 文件解析 | POST | `/api/parse/directory` | 解析指定目录下所有 SQL 文件 |
| 血缘查询 | POST | `/api/lineage/query` | 查询字段级血缘关系 |
| 口径查询 | POST | `/api/caliber/query` | 查询字段加工口径 |
| 口径导出 | POST | `/api/caliber/export` | 导出口径文档 (Excel) |
| 指标血缘 | POST | `/api/indicator/build` | 构建指标血缘图 |
| 表列表 | GET | `/api/parse/tables` | 获取已解析的表列表 |
| 搜索表 | GET | `/api/parse/tables/search` | 搜索表名/字段名 |

详细 API 文档请参考启动后的 Swagger UI (`/docs`)。

## 安全说明

- `SOURCE_DATA/` 目录包含真实业务数据，已在 `.gitignore` 中配置，**不会上传至代码仓库**
- 系统无外部数据库依赖，所有数据存储在内存/本地缓存中
- 敏感数据请妥善保管，勿将真实数据提交至公共仓库

## 测试

```bash
# 运行全部测试
python -m pytest tests/

# 运行指定测试
python -m pytest tests/test_lineage.py -v
```

## 相关文档

- [架构设计评估报告](ARCHITECTURE_REVIEW.md)
- [详细架构解决方案](ARCHITECTURE_DETAILED_SOLUTIONS.md)
- [代码 Wiki](CODE_WIKI.md)

## 许可证

本项目采用 [MIT 许可证](LICENSE)。
