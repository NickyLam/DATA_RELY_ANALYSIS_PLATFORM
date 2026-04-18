# 阶段 1：平台底座建设 - 详细执行计划

## 📋 阶段概述

**阶段名称**：平台底座建设  
**阶段编号**：Phase 1  
**里程碑**：M1  
**时间周期**：第 1-2 月  
**总工时**：5 人周  
**状态**：🟡 规划中

---

## 🎯 阶段目标

完成数据血缘分析平台的基础设施建设，包括：
1. DataHub 元数据平台部署与定制
2. Neo4j 图数据库部署与模型设计
3. 前后端项目骨架搭建
4. Docker Compose 容器编排配置

---

## 📦 任务包分解

### WBS-1.1: DataHub 部署与定制开发（2 人周）

#### 任务目标
部署 DataHub 0.13+ 并进行定制开发，为 Oracle 19c 血缘采集做准备。

#### 详细任务列表

**Task 1.1.1: DataHub 环境准备（0.5 人周）**
- [ ] 安装 Docker 24+ 和 Docker Compose 2.20+
- [ ] 准备 DataHub 官方 Docker Compose 配置文件
- [ ] 配置 PostgreSQL 15+ 作为 DataHub 后端存储
- [ ] 配置 DataHub GMS (Generalized Metadata Service)
- [ ] 配置 DataHub Frontend (React 应用)
- [ ] 验证 DataHub 基础服务启动

**Task 1.1.2: DataHub 自定义血缘实体模型（0.5 人周）**
- [ ] 设计 Oracle 19c 数据源实体模型
- [ ] 设计表级血缘关系模型
- [ ] 设计字段级血缘关系模型
- [ ] 设计作业依赖关系模型
- [ ] 在 DataHub 中注册自定义实体类型
- [ ] 配置 DataHub GraphQL API 扩展

**Task 1.1.3: DataHub Neo4j 集成（0.5 人周）**
- [ ] 配置 DataHub 与 Neo4j 的连接
- [ ] 启用 DataHub 的图查询功能
- [ ] 测试 DataHub 血缘图查询 API
- [ ] 验证血缘关系在 Neo4j 中的存储

**Task 1.1.4: DataHub API 测试与文档（0.5 人周）**
- [ ] 测试 DataHub REST API
- [ ] 测试 DataHub GraphQL API
- [ ] 编写 DataHub API 使用文档
- [ ] 编写 DataHub 配置说明文档

#### 交付物
- DataHub 运行实例（Docker Compose 配置）
- 自定义血缘实体模型定义文件
- DataHub API 使用文档
- DataHub 配置说明文档

#### 验收标准
- ✅ DataHub GMS 服务正常运行（http://localhost:8080）
- ✅ DataHub Frontend 正常访问（http://localhost:9002）
- ✅ PostgreSQL 后端存储正常连接
- ✅ 自定义血缘实体模型已注册
- ✅ Neo4j 图查询功能已启用
- ✅ API 测试通过率 100%

---

### WBS-1.2: Neo4j 图数据库部署（1 人周）

#### 任务目标
部署 Neo4j 5.x LTS 并设计血缘图谱模型，为血缘查询提供图数据库支持。

#### 详细任务列表

**Task 1.2.1: Neo4j 环境部署（0.3 人周）**
- [ ] 使用 Docker 部署 Neo4j 5.x LTS
- [ ] 配置 Neo4j 数据目录和日志目录
- [ ] 配置 Neo4j 认证和访问控制
- [ ] 启用 Neo4j Browser（Web 界面）
- [ ] 验证 Neo4j 服务启动

**Task 1.2.2: 血缘图谱模型设计（0.4 人周）**
- [ ] 设计节点模型：
  - DataSource（数据源）
  - Database（数据库）
  - Schema（模式）
  - Table（表）
  - Field（字段）
  - Job（作业）
  - SQLStatement（SQL 语句）
  - BatchRun（批次运行）
- [ ] 设计关系模型：
  - CONTAINS（包含关系）
  - LINEAGE_TO（血缘关系）
  - DEPENDS_ON（依赖关系）
  - READS（读取关系）
  - WRITES（写入关系）
  - TRANSFORMS（转换关系）
- [ ] 设计节点属性：
  - 基础属性（名称、类型、创建时间等）
  - 来源属性（解析方法、可信度等）
  - 业务属性（监管标识、业务术语等）
- [ ] 设计关系属性：
  - 转换类型、表达式、血缘层级等

**Task 1.2.3: Neo4j 索引和约束配置（0.2 人周）**
- [ ] 创建节点唯一性约束
- [ ] 创建节点属性索引
- [ ] 创建关系属性索引
- [ ] 性能测试与优化

**Task 1.2.4: Neo4j 查询测试（0.1 人周）**
- [ ] 测试节点创建和查询
- [ ] 测试关系创建和查询
- [ ] 测试血缘路径查询
- [ ] 测试最短路径算法
- [ ] 编写 Neo4j 查询示例文档

#### 交付物
- Neo4j 运行实例（Docker 配置）
- 血缘图谱模型设计文档
- Neo4j 索引和约束配置脚本
- Neo4j 查询示例文档

#### 验收标准
- ✅ Neo4j Browser 正常访问（http://localhost:7474）
- ✅ Neo4j 数据库正常连接（bolt://localhost:7687）
- ✅ 血缘图谱模型已创建
- ✅ 索引和约束已配置
- ✅ 血缘路径查询测试通过
- ✅ 最短路径算法测试通过

---

### WBS-1.3: 基础框架搭建（2 人周）

#### 任务目标
搭建前后端项目骨架，配置 Docker Compose 容器编排和 CI/CD 流水线。

#### 详细任务列表

**Task 1.3.1: 后端项目初始化（0.5 人周）**
- [ ] 创建 Python 3.11+ 项目结构
- [ ] 配置 FastAPI 0.100+ 框架
- [ ] 配置 SQLAlchemy 2.0+ ORM
- [ ] 配置 Pydantic 数据验证
- [ ] 配置项目依赖管理（requirements.txt / pyproject.toml）
- [ ] 配置代码质量工具：
  - Black（代码格式化）
  - mypy（类型检查）
  - pytest（单元测试）
  - ruff（代码检查）
- [ ] 创建基础 API 路由结构
- [ ] 创建配置管理模块

**Task 1.3.2: 前端项目初始化（0.5 人周）**
- [ ] 创建 React 18+ 项目结构（使用 Vite）
- [ ] 配置 TypeScript 5.0+ 严格模式
- [ ] 配置 Ant Design 5+ UI 组件库
- [ ] 配置项目依赖管理（package.json）
- [ ] 配置代码质量工具：
  - ESLint（代码检查）
  - Prettier（代码格式化）
  - Vitest（单元测试）
- [ ] 创建基础页面结构：
  - 资产搜索页
  - 完整血缘页
  - 字段最小链路页
  - 问题排查页
- [ ] 创建路由配置
- [ ] 创建状态管理配置（Zustand）

**Task 1.3.3: Docker Compose 容器编排（0.5 人周）**
- [ ] 创建 Docker Compose 配置文件
- [ ] 配置服务编排：
  - DataHub GMS
  - DataHub Frontend
  - PostgreSQL
  - Neo4j
  - Backend API
  - Frontend App
  - Redis（可选）
- [ ] 配置服务依赖关系
- [ ] 配置服务网络
- [ ] 配置服务卷挂载
- [ ] 配置环境变量管理
- [ ] 编写 Docker Compose 使用文档

**Task 1.3.4: CI/CD 流水线配置（0.3 人周）**
- [ ] 配置 Git 分支模型（Git Flow）
- [ ] 配置 GitHub Actions / GitLab CI
- [ ] 配置代码检查流水线
- [ ] 配置单元测试流水线
- [ ] 配置构建流水线
- [ ] 配置部署流水线
- [ ] 编写 CI/CD 使用文档

**Task 1.3.5: 项目文档编写（0.2 人周）**
- [ ] 编写项目 README.md
- [ ] 编写开发指南文档
- [ ] 编写部署指南文档
- [ ] 编写 API 文档（OpenAPI/Swagger）
- [ ] 编写架构设计文档

#### 交付物
- 后端项目骨架（backend/）
- 前端项目骨架（frontend/）
- Docker Compose 配置文件（docker-compose.yml）
- CI/CD 流水线配置文件
- 项目文档（README.md、开发指南、部署指南）
- API 文档（OpenAPI/Swagger）

#### 验收标准
- ✅ 后端项目可启动（http://localhost:8000）
- ✅ 前端项目可启动（http://localhost:5173）
- ✅ Docker Compose 可一键启动所有服务
- ✅ CI/CD 流水线正常运行
- ✅ 代码检查通过（Black、mypy、ESLint）
- ✅ 单元测试通过
- ✅ API 文档可访问（http://localhost:8000/docs）

---

## 🗓️ 时间计划

| 任务包 | 开始时间 | 结束时间 | 工时 | 状态 |
|-------|---------|---------|------|------|
| WBS-1.1 | 第 1 周开始 | 第 2 周结束 | 2 人周 | 🟡 待开始 |
| WBS-1.2 | 第 2 周开始 | 第 2 周结束 | 1 人周 | 🟡 待开始 |
| WBS-1.3 | 第 3 周开始 | 第 4 周结束 | 2 人周 | 🟡 待开始 |

**关键路径**：WBS-1.1 → WBS-1.2 → WBS-1.3

---

## 📊 资源需求

### 人力资源
- **后端工程师**：1-2 人（全职）
- **前端工程师**：1 人（全职）
- **架构师**：1 人（兼职，指导设计）
- **DBA**：1 人（兼职，指导数据库配置）

### 环境资源
- **开发环境**：本地 Docker Compose
- **服务器资源**：
  - CPU：4 核+
  - 内存：16 GB+
  - 存储：100 GB+

---

## ⚠️ 风险与缓解措施

| 风险 | 影响 | 概率 | 缓解措施 |
|------|------|------|---------|
| DataHub 与 Neo4j 集成兼容性问题 | 高 | 中 | 使用官方推荐版本，提前进行集成测试 |
| Docker Compose 服务启动失败 | 中 | 低 | 编写详细的启动文档，提供故障排查指南 |
| 前后端技术栈版本冲突 | 低 | 低 | 使用 LTS 版本，提前验证依赖兼容性 |
| CI/CD 流水线配置复杂 | 中 | 中 | 使用成熟的 CI/CD 模板，逐步完善 |

---

## 🎯 验收清单

### 功能验收
- [ ] DataHub GMS 服务正常运行
- [ ] DataHub Frontend 正常访问
- [ ] Neo4j Browser 正常访问
- [ ] PostgreSQL 数据库正常连接
- [ ] 后端 API 服务正常启动
- [ ] 前端应用正常启动
- [ ] Docker Compose 一键启动所有服务

### 技术验收
- [ ] DataHub 自定义血缘实体模型已注册
- [ ] Neo4j 血缘图谱模型已创建
- [ ] Neo4j 索引和约束已配置
- [ ] 后端代码检查通过（Black、mypy）
- [ ] 前端代码检查通过（ESLint、Prettier）
- [ ] 单元测试通过率 ≥ 80%

### 文档验收
- [ ] DataHub API 使用文档完成
- [ ] Neo4j 查询示例文档完成
- [ ] 项目 README.md 完成
- [ ] 开发指南文档完成
- [ ] 部署指南文档完成
- [ ] API 文档（OpenAPI/Swagger）完成

---

## 📝 执行日志

### 执行记录模板
```
日期：YYYY-MM-DD
任务：Task X.X.X
执行人：XXX
状态：进行中/已完成/阻塞
备注：...
```

---

## 🔄 下一步行动

阶段 1 完成后，进入阶段 2（采集适配器开发）：
- WBS-2.1: Oracle 19c 采集适配器增强
- WBS-2.2: SQL 解析引擎集成
- WBS-2.3: 运行时血缘采集

---

**创建日期**：2026-04-18  
**最后更新**：2026-04-18  
**状态**：🟡 规划中，待执行