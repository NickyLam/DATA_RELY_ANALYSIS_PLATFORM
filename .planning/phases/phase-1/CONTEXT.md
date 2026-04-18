# 阶段 1: 平台底座建设 - 上下文

## 阶段概述

**阶段名称**：平台底座建设  
**阶段编号**：Phase 1  
**里程碑**：M1  
**时间范围**：第 1-2 月  
**状态**：🔴 未开始 → 🟡 规划中

## 阶段目标

完成数据血缘分析平台的基础设施建设，包括：
1. DataHub 元数据平台部署与定制
2. Neo4j 图数据库部署与血缘模型设计
3. 前后端项目骨架搭建
4. Docker Compose 容器编排配置

## 任务包清单

### WBS-1.1: DataHub 部署与定制开发（2 人周）
- 部署 DataHub 0.13+
- 配置 MySQL/PostgreSQL 后端存储
- 自定义血缘实体模型
- 集成 Neo4j 图查询能力

### WBS-1.2: Neo4j 图数据库部署（1 人周）
- 部署 Neo4j 5.x LTS
- 设计血缘图谱模型（节点、边、属性）
- 配置索引和约束
- 性能调优

### WBS-1.3: 基础框架搭建（2 人周）
- 后端：FastAPI 项目结构
- 前端：React + TypeScript + Vite
- Docker Compose 编排配置
- CI/CD 流水线配置

## 技术栈

### 后端
- **语言**：Python 3.11+ (LTS)
- **框架**：FastAPI 0.100+
- **ORM**：SQLAlchemy 2.0+
- **任务队列**：Celery 5.3+
- **缓存**：Redis 7.0+

### 前端
- **框架**：React 18+ (LTS)
- **语言**：TypeScript 5.0+
- **构建工具**：Vite 4+
- **UI 组件库**：Ant Design 5+
- **可视化**：D3.js 7+ / React Flow

### 数据层
- **元数据存储**：PostgreSQL 15+
- **图数据库**：Neo4j 5.x LTS
- **搜索引擎**：Elasticsearch 8.x (可选)

### 开源组件
- **元数据平台**：DataHub 0.13+
- **SQL 解析引擎**：JSqlParser 4.x (Oracle 19c)

### 部署
- **容器化**：Docker 24+、Docker Compose 2.20+
- **应用服务器**：Gunicorn + Uvicorn
- **Web 服务器**：Nginx

## 交付物

1. **DataHub 运行实例**
   - DataHub GMS (Generalized Metadata Service)
   - DataHub Frontend
   - DataHub Actions (可选)

2. **Neo4j 运行实例**
   - Neo4j Database
   - Neo4j Browser
   - 血缘图谱模型

3. **前后端项目骨架**
   - backend/ 目录结构
   - frontend/ 目录结构
   - 基础配置文件

4. **Docker Compose 配置文件**
   - docker-compose.yml
   - 环境变量配置
   - 网络配置

## 验收标准

### 功能验收
- ✅ DataHub API 可正常访问（http://localhost:8080）
- ✅ DataHub Frontend 可正常访问（http://localhost:9002）
- ✅ Neo4j Browser 可连接（http://localhost:7474）
- ✅ Neo4j 数据库可执行 Cypher 查询
- ✅ 后端项目可启动（http://localhost:8000/docs）
- ✅ 前端项目可启动（http://localhost:5173）

### 技术验收
- ✅ Docker Compose 可一键启动所有服务
- ✅ 所有服务健康检查通过
- ✅ 服务间网络通信正常
- ✅ 数据持久化配置正确

### 文档验收
- ✅ 部署文档完整
- ✅ 配置说明清晰
- ✅ API 文档可访问（Swagger UI）

## 依赖关系

### 前置依赖
- Docker 24+ 已安装
- Docker Compose 2.20+ 已安装
- Python 3.11+ 已安装
- Node.js 18+ 已安装

### 后续依赖
- 阶段 2（采集适配器开发）依赖阶段 1 的平台底座
- DataHub 和 Neo4j 必须正常运行才能进行血缘采集

## 风险与缓解

### 技术风险
- **风险**：DataHub 与 Neo4j 集成可能遇到兼容性问题
- **缓解**：使用 DataHub 官方推荐的 Neo4j 版本，提前进行集成测试

### 性能风险
- **风险**：多个服务同时运行可能导致资源不足
- **缓解**：配置合理的资源限制，使用 Docker Compose 资源管理

### 配置风险
- **风险**：环境变量配置复杂，容易出错
- **缓解**：使用 .env 文件统一管理，提供配置模板

## 关键决策

### 决策 1：DataHub 后端存储选择
- **选项**：MySQL vs PostgreSQL
- **推荐**：PostgreSQL 15+
- **理由**：
  - PostgreSQL 更适合复杂查询和 JSON 数据类型
  - 与 Neo4j 的数据模型更一致
  - 开源且社区活跃

### 决策 2：Neo4j 部署模式
- **选项**：单节点 vs 集群
- **推荐**：单节点（一期）
- **理由**：
  - 一期数据量较小（≤50,000 张表）
  - 降低部署复杂度
  - 二期可扩展为集群

### 册策 3：前端 UI 组件库
- **选项**：Ant Design vs Material UI
- **推荐**：Ant Design 5+
- **理由**：
  - 中文文档完善
  - 企业级组件丰富
  - 适合数据密集型应用

## 参考资源

### DataHub 官方文档
- [DataHub Deployment](https://datahubproject.io/docs/deploy/)
- [DataHub Architecture](https://datahubproject.io/docs/architecture/)
- [DataHub Custom Metadata](https://datahubproject.io/docs/metadata-model/)

### Neo4j 官方文档
- [Neo4j Docker Deployment](https://neo4j.com/docs/operations-manual/current/docker/)
- [Neo4j Data Modeling](https://neo4j.com/docs/data-modeling/)
- [Neo4j Performance Tuning](https://neo4j.com/docs/operations-manual/current/performance/)

### FastAPI 官方文档
- [FastAPI Project Structure](https://fastapi.tiangolo.com/tutorial/project-structure/)
- [FastAPI Docker Deployment](https://fastapi.tiangolo.com/deployment/docker/)

### React 官方文档
- [React + TypeScript](https://react.dev/learn/typescript)
- [Vite Configuration](https://vitejs.dev/config/)

## 下一步

完成 CONTEXT.md 后，下一步是创建 PLAN.md 详细计划文件。