# 数据血缘分析平台 - 部署指南

## 环境要求

### 系统要求
- 操作系统：Linux / macOS / Windows
- CPU：4 核+
- 内存：16 GB+
- 存储：100 GB+

### 软件要求
- Docker 24+
- Docker Compose 2.20+
- Python 3.11+（可选，用于本地开发）
- Node.js 18+（可选，用于本地开发）

---

## 快速部署

### 1. 克隆项目

```bash
git clone <repository-url>
cd DATA_RELY_ANALYSIS_PLATFORM
```

### 2. 配置环境变量

```bash
cp .env.example .env
```

编辑 `.env` 文件，修改以下关键配置：

```bash
# PostgreSQL 配置
POSTGRES_USER=datahub
POSTGRES_PASSWORD=datahub123  # 生产环境请修改密码
POSTGRES_HOST=localhost
POSTGRES_PORT=5432

# Neo4j 配置
NEO4J_USER=neo4j
NEO4J_PASSWORD=neo4j123  # 生产环境请修改密码
NEO4J_HOST=localhost
NEO4J_HTTP_PORT=7474
NEO4J_BOLT_PORT=7687

# Redis 配置
REDIS_HOST=localhost
REDIS_PORT=6379

# DataHub 配置
DATAHUB_GMS_HOST=localhost
DATAHUB_GMS_PORT=8080
DATAHUB_FRONTEND_HOST=localhost
DATAHUB_FRONTEND_PORT=9002

# Backend API 配置
BACKEND_HOST=localhost
BACKEND_PORT=8000

# Frontend 配置
FRONTEND_HOST=localhost
FRONTEND_PORT=5173
```

### 3. 启动所有服务

```bash
docker-compose up -d
```

### 4. 查看服务状态

```bash
docker-compose ps
```

### 5. 查看服务日志

```bash
docker-compose logs -f
```

---

## 服务访问地址

| 服务 | 地址 | 说明 |
|------|------|------|
| PostgreSQL | localhost:5432 | 数据库连接 |
| Neo4j Browser | http://localhost:7474 | 图数据库 Web 界面 |
| Neo4j Bolt | bolt://localhost:7687 | 图数据库连接 |
| Redis | localhost:6379 | 缓存服务 |
| DataHub GMS | http://localhost:8080 | DataHub API |
| DataHub Frontend | http://localhost:9002 | DataHub Web 界面 |
| Backend API | http://localhost:8000 | 血缘分析平台 API |
| API 文档 | http://localhost:8000/api/v1/docs | Swagger UI |
| Frontend App | http://localhost:5173 | 血缘分析平台前端 |

---

## 服务健康检查

### PostgreSQL

```bash
docker exec -it lineage-postgres psql -U datahub -d datahub -c "SELECT 1;"
```

### Neo4j

```bash
curl http://localhost:7474
```

### Redis

```bash
docker exec -it lineage-redis redis-cli ping
```

### Backend API

```bash
curl http://localhost:8000/health
```

---

## 数据初始化

### PostgreSQL 初始化

PostgreSQL 初始化脚本会在首次启动时自动执行：

- 创建数据库表结构
- 创建索引和约束
- 创建触发器
- 插入默认数据源和采集任务

### Neo4j 初始化

Neo4j 初始化脚本需要手动执行：

```bash
# 连接到 Neo4j Browser (http://localhost:7474)
# 执行 docker/neo4j-init/init.cypher 中的脚本
```

或者使用 Cypher Shell：

```bash
docker exec -it lineage-neo4j cypher-shell -u neo4j -p neo4j123
# 然后粘贴 init.cypher 中的脚本
```

---

## 常见问题排查

### 1. 服务启动失败

**检查日志**：
```bash
docker-compose logs <service-name>
```

**常见原因**：
- 端口冲突：检查端口是否被占用
- 内存不足：检查 Docker 内存限制
- 网络问题：检查 Docker 网络配置

### 2. PostgreSQL 连接失败

**检查服务状态**：
```bash
docker-compose ps postgres
```

**检查日志**：
```bash
docker-compose logs postgres
```

**解决方案**：
- 确保 PostgreSQL 服务已启动
- 检查用户名、密码、数据库名称是否正确
- 检查端口是否正确

### 3. Neo4j 连接失败

**检查服务状态**：
```bash
docker-compose ps neo4j
```

**检查日志**：
```bash
docker-compose logs neo4j
```

**解决方案**：
- 确保 Neo4j 服务已启动
- 检查用户名、密码是否正确
- 检查端口是否正确

### 4. Backend API 无法访问

**检查服务状态**：
```bash
docker-compose ps backend
```

**检查日志**：
```bash
docker-compose logs backend
```

**解决方案**：
- 确保 Backend 服务已启动
- 检查依赖服务（PostgreSQL、Neo4j、Redis）是否正常
- 检查环境变量配置是否正确

---

## 生产环境部署建议

### 1. 安全配置

- 修改所有默认密码
- 使用 SSL/TLS 加密通信
- 配置防火墙规则
- 启用访问控制

### 2. 性能优化

- 增加内存和 CPU 资源
- 配置数据库连接池
- 启用 Redis 缓存
- 配置 Elasticsearch 索引优化

### 3. 高可用配置

- 使用 Kubernetes 部署
- 配置数据库主从复制
- 配置 Neo4j 集群
- 配置负载均衡

### 4. 监控配置

- 配置 Prometheus 监控
- 配置 Grafana 可视化
- 配置日志收集（ELK Stack）
- 配置告警规则

---

## 停止和清理

### 停止所有服务

```bash
docker-compose stop
```

### 停止并删除所有服务

```bash
docker-compose down
```

### 删除所有数据（谨慎操作）

```bash
docker-compose down -v
```

---

## 更新和升级

### 更新代码

```bash
git pull
```

### 重新构建镜像

```bash
docker-compose build
```

### 重启服务

```bash
docker-compose up -d
```

---

## 备份和恢复

### PostgreSQL 备份

```bash
docker exec lineage-postgres pg_dump -U datahub datahub > backup.sql
```

### PostgreSQL 恢复

```bash
docker exec -i lineage-postgres psql -U datahub datahub < backup.sql
```

### Neo4j 备份

```bash
docker exec lineage-neo4j neo4j-admin dump --database=neo4j --to=/backup/neo4j.dump
```

### Neo4j 恢复

```bash
docker exec lineage-neo4j neo4j-admin load --database=neo4j --from=/backup/neo4j.dump
```

---

## 许可证

MIT