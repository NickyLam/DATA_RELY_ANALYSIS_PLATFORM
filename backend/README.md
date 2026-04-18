# 数据血缘分析平台 - 后端服务

## 技术栈

- **语言**: Python 3.11+
- **框架**: FastAPI 0.100+
- **ORM**: SQLAlchemy 2.0+
- **图数据库**: Neo4j 5.x
- **缓存**: Redis 7.0+
- **任务队列**: Celery 5.3+

## 项目结构

```
backend/
├── app/
│   ├── api/
│   │   └── v1/
│   │       ├── api.py              # API 路由汇总
│   │       └── endpoints/
│   │           ├── health.py       # 健康检查
│   │           ├── search.py       # 资产搜索
│   │           ├── data_sources.py # 数据源管理
│   │           └── lineage.py      # 血缘查询
│   ├── core/
│   │   ├── config.py               # 配置管理
│   │   ├── database.py             # PostgreSQL 连接
│   │   ├── neo4j.py                # Neo4j 连接
│   │   └── redis.py                # Redis 连接
│   ├── schemas/
│   │   ├── data_source.py          # 数据源模型
│   │   ├── table.py                # 表元数据模型
│   │   └── lineage.py              # 血缘关系模型
│   └── main.py                     # 应用入口
├── pyproject.toml                  # 项目配置
├── Dockerfile                      # Docker 配置
└── README.md                       # 本文件
```

## 快速开始

### 1. 安装依赖

```bash
pip install -e .
```

### 2. 配置环境变量

复制 `.env.example` 到 `.env` 并修改配置：

```bash
cp ../.env.example .env
```

### 3. 启动服务

```bash
uvicorn app.main:app --reload
```

### 4. 访问 API 文档

- Swagger UI: http://localhost:8000/api/v1/docs
- ReDoc: http://localhost:8000/api/v1/redoc

## API 端点

### 健康检查
- `GET /api/v1/health` - 健康检查

### 资产搜索
- `GET /api/v1/search/tables` - 搜索表
- `GET /api/v1/search/fields` - 搜索字段

### 数据源管理
- `GET /api/v1/data-sources` - 获取所有数据源
- `POST /api/v1/data-sources` - 创建数据源
- `GET /api/v1/data-sources/{id}` - 获取数据源详情
- `PUT /api/v1/data-sources/{id}` - 更新数据源
- `DELETE /api/v1/data-sources/{id}` - 删除数据源

### 血缘查询
- `GET /api/v1/lineage/table/{id}` - 获取表级完整血缘
- `GET /api/v1/lineage/field/{id}` - 获取字段级最小链路
- `GET /api/v1/lineage/impact/{id}` - 影响分析
- `GET /api/v1/lineage/job/{id}` - 获取作业血缘

## 开发指南

### 代码质量

```bash
# 格式化代码
black app/

# 类型检查
mypy app/

# 代码检查
ruff check app/
```

### 单元测试

```bash
pytest tests/
```

## Docker 部署

```bash
docker build -t lineage-backend .
docker run -p 8000:8000 lineage-backend
```

## 许可证

MIT