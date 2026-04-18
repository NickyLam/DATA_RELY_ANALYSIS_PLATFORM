# 阶段 1：平台底座建设 - 详细计划

## 📋 阶段概览

**阶段编号**：Phase 1  
**阶段名称**：平台底座建设  
**时间周期**：第 1-2 月（8 周）  
**状态**：🔴 未开始  
**优先级**：P0 - 最高优先级

---

## 🎯 阶段目标

完成数据血缘分析平台的基础底座建设，包括：
1. DataHub 元数据平台部署与定制
2. Neo4j 图数据库部署与血缘模型设计
3. 前后端项目骨架搭建
4. Docker Compose 一键部署配置

**验收标准**：
- ✅ DataHub API 可正常访问（http://localhost:8080）
- ✅ Neo4j Browser 可连接（bolt://localhost:7687）
- ✅ 前后端项目可启动
- ✅ Docker Compose 可一键启动所有服务

---

## 📦 任务包分解

### WBS-1.1: DataHub 部署与定制开发（2 人周）

**负责人**：后端工程师 A  
**优先级**：P0  
**依赖**：无  
**预计工时**：2 人周（80 小时）

#### 任务详情

**1.1.1 DataHub 环境调研（4 小时）**
- 阅读 DataHub 官方文档（0.13+ 版本）
- 对比 Docker Compose vs Kubernetes 部署方案
- 评估 MySQL vs PostgreSQL 后端存储
- 输出：《DataHub 部署方案选型报告》

**1.1.2 Docker Compose 配置（8 小时）**
- 编写 datahub-compose.yml
- 配置服务：
  - datahub-gms（元数据服务）
  - datahub-frontend（前端 UI）
  - datahub-mae-consumer（元数据事件消费者）
  - datahub-mce-consumer（元数据变更事件消费者）
- 配置网络、卷、环境变量

**1.1.3 数据库初始化（4 小时）**
- 部署 MySQL 8.0（DataHub 推荐）
- 执行 DataHub 数据库初始化脚本
- 验证数据库连接

**1.1.4 DataHub 启动与验证（4 小时）**
- 启动 DataHub 服务
- 验证 API 端点（http://localhost:8080）
- 验证 UI 界面（http://localhost:9002）
- 执行健康检查

**1.1.5 自定义血缘实体模型（16 小时）**
- 分析 Oracle 19c 血缘需求
- 设计自定义 Dataset 实体（扩展 DataHub 模型）
- 添加 Oracle 特有属性：
  - 表空间（TABLESPACE_NAME）
  - 分区信息（PARTITIONED）
  - 存储过程类型（PROCEDURE_TYPE）
- 编写 PDL（Pegasus Data Language）定义

**1.1.6 DataHub  ingestion 配置（8 小时）**
- 配置 RDBMS ingestion 源
- 编写 Oracle 19c ingestion 配置文件
- 测试 ingestion 流程

**1.1.7 文档编写（4 小时）**
- 编写 DataHub 部署手册
- 编写 ingestion 配置指南
- 编写故障排查手册

**交付物**：
- [ ] datahub-compose.yml
- [ ] DataHub 运行实例
- [ ] 《DataHub 部署方案选型报告》
- [ ] Oracle 自定义实体模型
- [ ] Oracle ingestion 配置文件
- [ ] DataHub 部署手册

**验收标准**：
- ✅ DataHub API 响应时间 < 500ms
- ✅ UI 页面加载时间