# 生产环境部署指南

## 部署概述

本文档描述数据血缘分析平台的生产环境部署流程和配置要求。

---

## 环境要求

### 硬件要求

| 服务 | CPU | 内存 | 存储 | 数量 |
|------|-----|------|------|------|
| 后端 API | 4 核 | 8 GB | 50 GB | 2 |
| 前端服务 | 2 核 | 4 GB | 20 GB | 1 |
| PostgreSQL | 4 核 | 16 GB | 200 GB SSD | 1 |
| Neo4j | 4 核 | 16 GB | 100 GB SSD | 1 |
| Redis | 2 核 | 8 GB | 20 GB | 1 |
| Elasticsearch | 4 核 | 8 GB | 100 GB SSD | 1 |

### 软件要求

| 软件 | 版本 | 说明 |
|------|------|------|
| Docker | 24.0+ | 容器运行环境 |
| Docker Compose | 2.20+ | 容器编排工具 |
| Python | 3.11+ | 后端运行环境 |
| Node.js | 18.x LTS | 前端构建环境 |

### 网络要求

| 端口 | 服务 | 说明 |
|------|------|------|
| 8000 | 后端 API | API 服务端口 |
| 5173 | 前端 | 前端服务端口 |
| 5432 | PostgreSQL | 数据库端口 |
| 7474 | Neo4j HTTP | Neo4j Web 端口 |
| 7687 | Neo4j Bolt | Neo4j 连接端口 |
| 6379 | Redis | 缓存服务端口 |
| 9200 | Elasticsearch | 搜索引擎端口 |

---

## 部署流程

### 1. 环境准备

```bash
# 1. 克隆项目代码
git clone <项目地址>
cd DATA_RELY_ANALYSIS_PLATFORM

# 2. 创建生产环境配置
cp .env.example .env.production

# 3. 编辑环境变量
vim .env.production
```

### 2. 配置环境变量

编辑 `.env.production` 文件：

```bash
# 数据库配置
DATABASE_URL=postgresql://datahub:<密码>@postgres:5432/datahub
POSTGRES_USER=datahub
POSTGRES_PASSWORD=<强密码>
POSTGRES_DB=datahub

# Neo4j 配置
NEO4J_URI=bolt://neo4j:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=<强密码>

# Redis 配置
REDIS_URL=redis://redis:6379

# Elasticsearch 配置
ELASTICSEARCH_HOST=elasticsearch:9200

# 安全配置
JWT_SECRET=<随机密钥>
API_KEY=<随机密钥>

# 日志配置
LOG_LEVEL=INFO
LOG_FILE=/var/log/lineage-platform/app.log
```

### 3. 构建服务镜像

```bash
# 构建后端镜像
cd backend
docker build -t lineage-backend:v1.0 .

# 构建前端镜像
cd frontend
docker build -t lineage-frontend:v1.0 .
```

### 4. 启动服务

```bash
# 使用 Docker Compose 启动
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# 检查服务状态
docker-compose ps
```

### 5. 健康检查

```bash
# 检查后端健康状态
curl http://localhost:8000/health

# 检查 Neo4j 连接
curl http://localhost:7474

# 检查 Redis 连接
redis-cli -h localhost ping
```

---

## 生产配置

### PostgreSQL 配置

创建 `docker/postgres-prod.conf`：

```ini
# 性能配置
max_connections = 200
shared_buffers = 4GB
work_mem = 64MB
maintenance_work_mem = 512MB

# 日志配置
logging_collector = on
log_directory = '/var/log/postgresql'
log_filename = 'postgresql-%Y-%m-%d.log'
log_min_duration_statement = 1000

# 安全配置
ssl = on
ssl_cert_file = '/etc/ssl/certs/server.crt'
ssl_key_file = '/etc/ssl/private/server.key'
```

### Neo4j 配置

创建 `docker/neo4j-prod.conf`：

```properties
# 内存配置
server.memory.pagecache.size=2G
server.memory.heap.initial_size=2G
server.memory.heap.max_size=4G

# 安全配置
dbms.security.auth_enabled=true
dbms.security.procedures.unrestricted=apoc.*

# 日志配置
dbms.logs.debug.enabled=false
dbms.logs.default_debug_level=INFO
```

### Redis 配置

创建 `docker/redis-prod.conf`：

```conf
# 内存配置
maxmemory 4gb
maxmemory-policy allkeys-lru

# 持久化配置
appendonly yes
appendfsync everysec

# 安全配置
requirepass <强密码>
```

---

## 监控配置

### Prometheus 配置

创建 `prometheus.yml`：

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'lineage-backend'
    static_configs:
      - targets: ['backend:8000']

  - job_name: 'neo4j'
    static_configs:
      - targets: ['neo4j:7474']

  - job_name: 'redis'
    static_configs:
      - targets: ['redis:6379']

  - job_name: 'postgres'
    static_configs:
      - targets: ['postgres:5432']
```

### Grafana Dashboard

导入以下 Dashboard：
- Node Exporter Dashboard
- PostgreSQL Dashboard
- Neo4j Dashboard
- Redis Dashboard

---

## 告警配置

### 告警规则

创建 `alert_rules.yml`：

```yaml
groups:
  - name: lineage-platform
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status="5xx"}[5m]) > 0.1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "高错误率告警"
          description: "API 错误率超过 10%"

      - alert: SlowResponse
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 3
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "响应时间告警"
          description: "P95 响应时间超过 3s"

      - alert: DatabaseDown
        expr: up{job="postgres"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "数据库宕机告警"
          description: "PostgreSQL 服务不可用"
```

---

## 安全配置

### SSL/TLS 配置

1. 获取 SSL 证书
2. 配置 Nginx 反向代理：

```nginx
server {
    listen 443 ssl;
    server_name lineage.example.com;

    ssl_certificate /etc/ssl/certs/server.crt;
    ssl_certificate_key /etc/ssl/private/server.key;

    location / {
        proxy_pass http://frontend:5173;
    }

    location /api/ {
        proxy_pass http://backend:8000;
    }
}
```

### 认证配置

启用 JWT 认证：

```bash
# 生成密钥
openssl rand -base64 32

# 配置环境变量
JWT_SECRET=<生成的密钥>
JWT_EXPIRATION=86400
```

---

## 备份配置

### 数据库备份

```bash
# PostgreSQL 备份脚本
#!/bin/bash
BACKUP_DIR=/backup/postgresql
DATE=$(date +%Y%m%d)

pg_dump -h localhost -U datahub datahub > $BACKUP_DIR/datahub_$DATE.sql

# 保留最近 30 天备份
find $BACKUP_DIR -name "*.sql" -mtime +30 -delete
```

### Neo4j 备份

```bash
# Neo4j 备份脚本
#!/bin/bash
BACKUP_DIR=/backup/neo4j
DATE=$(date +%Y%m%d)

neo4j-admin database dump datahub --to=$BACKUP_DIR/neo4j_$DATE.dump

# 保留最近 30 天备份
find $BACKUP_DIR -name "*.dump" -mtime +30 -delete
```

---

## 运维流程

### 服务启动

```bash
# 启动所有服务
docker-compose up -d

# 启动单个服务
docker-compose up -d backend
```

### 服务停止

```bash
# 停止所有服务
docker-compose down

# 停止单个服务
docker-compose stop backend
```

### 服务重启

```bash
# 重启所有服务
docker-compose restart

# 重启单个服务
docker-compose restart backend
```

### 日志查看

```bash
# 查看服务日志
docker-compose logs backend

# 实时日志
docker-compose logs -f backend
```

---

## 上线检查清单

### 部署前检查

- [ ] 环境变量配置完成
- [ ] 数据库连接配置正确
- [ ] SSL 证书部署完成
- [ ] 防火墙端口开放
- [ ] 监控告警配置完成
- [ ] 备份脚本配置完成

### 部署后检查

- [ ] 所有服务启动成功
- [ ] API 健康检查通过
- [ ] 前端页面可访问
- [ ] Neo4j 连接正常
- [ ] Redis 连接正常
- [ ] 监控数据正常上报

### 功能验证

- [ ] 用户登录功能正常
- [ ] 资产搜索功能正常
- [ ] 血缘查询功能正常
- [ ] 字段级血缘功能正常
- [ ] 问题排查功能正常

---

## 故障处理

### 服务无法启动

1. 检查日志：`docker-compose logs <服务名>`
2. 检查配置文件是否正确
3. 检查端口是否被占用
4. 检查磁盘空间是否充足

### 数据库连接失败

1. 检查数据库服务状态
2. 验证连接参数是否正确
3. 检查防火墙规则
4. 检查数据库日志

### 性能下降

1. 检查缓存命中率
2. 检查数据库慢查询
3. 检查系统资源使用率
4. 增加缓存预热

---

**文档版本**：v1.0
**更新日期**：2026-04-20
**编写人**：项目团队