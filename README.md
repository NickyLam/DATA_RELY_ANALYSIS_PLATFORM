# 数据血缘分析平台

## 项目简介

数据血缘分析平台是一个面向 Oracle 19c、TDH、OceanBase、GBase、崖山等异构数据库的统一血缘分析系统，重点解决"结果表完整加工血缘可查"和"字段最小血缘链路可追"的核心问题。

## 系统架构

```
┌─────────────────────────────────────────┐
│           展示层 (Presentation)          │
│  资产搜索 | 完整血缘 | 最小链路 | 影响分析  │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│            服务层 (Service)              │
│  元数据服务 | 血缘查询 | 最小链路 | 审核  │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│            存储层 (Storage)              │
│   PostgreSQL (元数据) + Neo4j (图谱)    │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│            建模层 (Modeling)             │
│   表模型 | 字段模型 | 作业模型 | 血缘边   │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│            解析层 (Parsing)              │
│  SQL 方言识别 | AST 解析 | 血缘提取       │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│            采集层 (Collection)           │
│  JDBC 采集 | SQL 采集 | 运行时采集 | 人工  │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│           数据源层 (Data Sources)        │
│ Oracle 19c → TDH → OceanBase → GBase → 崖山│
└─────────────────────────────────────────┘
```

## 技术栈

### 后端
- Python 3.11+
- FastAPI 0.100+
- SQLAlchemy 2.0+
- Neo4j 5.x
- Redis 7.0+

### 前端
- React 18+
- TypeScript 5.0+
- Vite 5.0+
- Ant Design 5+

### 数据层
- PostgreSQL 15+
- Neo4j 5.x
- Redis 7.0+
- Elasticsearch 8.x (可选)

### 开源组件
- DataHub 0.13+
- JSqlParser 4.x (Oracle 19c)

## 项目结构

```
DATA_RELY_ANALYSIS_PLATFORM/
├── .planning/                    # 项目规划目录
│   ├── PROJECT.md               # 项目上下文
│   ├── ROADMAP.md               # 路线图
│   ├── STATE.md                 # 状态跟踪
│   ├── config.json              # 配置
│   └── phases/phase-1/          # 阶段 1 规划
│       ├── CONTEXT.md           # 阶段上下文
│       └── PLAN.md              # 详细执行计划
├── backend/                      # 后端项目
│   ├── app/
│   │   ├── api/v1/              # API 路由
│   │   ├── core/                # 核心模块
│   │   ├── schemas/             # Pydantic 模型
│   │   └── main.py              # 应用入口
│   ├── pyproject.toml           # 项目配置
│   ├── Dockerfile               # Docker 配置
│   └── README.md                # 后端文档
├── frontend/                     # 前端项目
│   ├── src/
│   │   ├── components/          # 组件
│   │   ├── pages/               # 页面
│   │   ├── App.tsx              # 应用入口
│   │   └── main.tsx             # React 入口
│   ├── package.json             # 项目配置
│   ├── Dockerfile               # Docker 配置
│   └── README.md                # 前端文档
├── docker/                       # Docker 配置
│   ├── init-postgres.sql        # PostgreSQL 初始化
│   └── neo4j-init/              # Neo4j 初始化
├── docker-compose.yml            # Docker Compose 配置
├── .env.example                  # 环境变量模板
└── README.md                     # 本文件
```

## 快速开始

### 1. 克隆项目

```bash
git clone <repository-url>
cd DATA_RELY_ANALYSIS_PLATFORM
```

### 2. 配置环境变量

```bash
cp .env.example .env
# 编辑 .env 文件，修改配置
```

### 3. 启动所有服务

```bash
docker-compose up -d
```

### 4. 访问应用

- 前端应用: http://localhost:5173
- 后端 API: http://localhost:8000
- API 文档: http://localhost:8000/api/v1/docs
- DataHub: http://localhost:9002
- Neo4j Browser: http://localhost:7474

## 数据库接入优先级

1. **一期**: Oracle 19c
2. **二期**: TDH
3. **三期**: OceanBase → GBase → 崖山数据库

## 实施计划

### 阶段 1: 平台底座建设（第 1-2 月）
- DataHub 部署与定制开发
- Neo4j 图数据库部署
- 基础框架搭建

### 阶段 2: 采集适配器开发（第 2-4 月）
- Oracle 19c 采集适配器增强
- SQL 解析引擎集成
- 运行时血缘采集

### 阶段 3: 核心功能开发（第 3-5 月）
- 资产搜索模块
- 表级血缘查询模块
- 字段级最小链路模块
- 问题排查页

### 阶段 4: 试点与优化（第 5-6 月）
- 监管报送系统试点接入
- 性能优化
- 用户培训与上线

## 验收标准

### 性能指标
- 简单搜索（精确表名）：P95 ≤1 秒
- 表级完整血缘（≤5 层）：P95 ≤3 秒
- 字段级最小链路：P95 ≤5 秒
- 支持并发用户数：≥200 人

### 解析准确率
- L1 简单场景：≥98%
- L2 中等场景：≥90%
- L3 复杂场景：≥80%
- L4 极复杂场景：≥70%

## 许可证

MIT

## 联系方式

- 项目团队: Data Lineage Team
- 邮箱: team@example.com