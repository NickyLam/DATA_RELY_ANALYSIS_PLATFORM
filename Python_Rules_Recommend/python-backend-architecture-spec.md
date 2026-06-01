# Python 后端开发架构规范

> 版本：1.0 | 更新日期：2026-05-28

---

## 目录

- [1. 总体原则](#1-总体原则)
- [2. 项目结构规范](#2-项目结构规范)
- [3. 分层架构设计](#3-分层架构设计)
- [4. 接口设计规范](#4-接口设计规范)
- [5. 模块设计规范](#5-模块设计规范)
- [6. 函数设计规范](#6-函数设计规范)
- [7. 变量定义规范](#7-变量定义规范)
- [8. 异常处理规范](#8-异常处理规范)
- [9. 日志规范](#9-日志规范)
- [10. 数据库与 ORM 规范](#10-数据库与-orm-规范)
- [11. 配置管理规范](#11-配置管理规范)
- [12. 安全规范](#12-安全规范)
- [13. 测试规范](#13-测试规范)
- [14. 性能与并发规范](#14-性能与并发规范)
- [15. 代码审查清单](#15-代码审查清单)

---

## 1. 总体原则

### 1.1 核心理念

| 原则 | 说明 |
|------|------|
| **SOLID** | 单一职责、开闭原则、里氏替换、接口隔离、依赖反转 |
| **DRY** | Don't Repeat Yourself，避免重复代码 |
| **KISS** | Keep It Simple, Stupid，优先选择简单方案 |
| **YAGNI** | You Aren't Gonna Need It，不提前实现不需要的功能 |
| **显式优于隐式** | 代码意图必须清晰可读，避免"魔法"行为 |

### 1.2 Python 风格基准

- 严格遵循 [PEP 8](https://peps.python.org/pep-0008/) 编码风格
- 使用 Python 3.10+ 特性（类型别名、match-case、管道联合类型等）
- 强制启用 `mypy --strict` 类型检查
- 强制使用 `ruff` 进行代码格式化和 lint

---

## 2. 项目结构规范

### 2.1 推荐目录结构

```
project-root/
├── pyproject.toml              # 项目元数据与依赖管理
├── README.md
├── .env.example                # 环境变量模板
├── .gitignore
├── Dockerfile
├── docker-compose.yml
├── alembic/                    # 数据库迁移
│   ├── alembic.ini
│   └── versions/
├── tests/                      # 测试目录（镜像 src 结构）
│   ├── conftest.py
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── scripts/                    # 运维/部署脚本
├── docs/                       # 项目文档
└── src/                        # 源码根目录
    └── app/
        ├── __init__.py
        ├── main.py             # 应用入口（FastAPI/Flask 实例）
        ├── core/               # 核心配置与基础设施
        │   ├── __init__.py
        │   ├── config.py       # 配置加载
        │   ├── security.py     # 认证/授权
        │   ├── exceptions.py   # 全局异常定义
        │   ├── middleware.py    # 中间件
        │   └── deps.py         # 依赖注入
        ├── api/                # 接口层（路由）
        │   ├── __init__.py
        │   ├── v1/
        │   │   ├── __init__.py
        │   │   ├── router.py   # v1 路由聚合
        │   │   ├── endpoints/
        │   │   │   ├── users.py
        │   │   │   └── orders.py
        │   │   └── schemas/    # 请求/响应模型
        │   │       ├── user_schema.py
        │   │       └── order_schema.py
        │   └── v2/             # 版本化接口
        ├── services/           # 业务逻辑层
        │   ├── __init__.py
        │   ├── user_service.py
        │   └── order_service.py
        ├── repositories/       # 数据访问层
        │   ├── __init__.py
        │   ├── base.py         # 通用 Repository
        │   ├── user_repo.py
        │   └── order_repo.py
        ├── models/             # ORM 模型
        │   ├── __init__.py
        │   ├── base.py         # 声明性基类
        │   ├── user.py
        │   └── order.py
        ├── schemas/            # 共享 Pydantic 模型
        │   ├── __init__.py
        │   └── common.py
        └── utils/              # 工具函数
            ├── __init__.py
            ├── datetime.py
            └── crypto.py
```

### 2.2 结构原则

| 规则 | 说明 |
|------|------|
| `src` 布局 | 源码放在 `src/` 下，避免隐式导入问题 |
| 测试镜像 | `tests/` 目录结构镜像 `src/` 结构 |
| 按领域分模块 | 以业务领域（user/order）而非技术层划分文件 |
| 接口版本化 | `api/v1/`、`api/v2/` 隔离不同版本 |
| 单文件单类 | 一个文件只定义一个主要模型/服务/仓储类 |

---

## 3. 分层架构设计

### 3.1 四层架构

```
┌─────────────────────────────────────────┐
│              API 层 (Router)             │  ← 请求校验、响应序列化
├─────────────────────────────────────────┤
│            Service 层 (业务逻辑)          │  ← 核心业务编排、事务控制
├─────────────────────────────────────────┤
│          Repository 层 (数据访问)         │  ← 数据库 CRUD、查询封装
├─────────────────────────────────────────┤
│            Model 层 (数据模型)            │  ← ORM 映射、领域实体
└─────────────────────────────────────────┘
```

### 3.2 各层职责与约束

#### API 层

```python
from fastapi import APIRouter, Depends
from app.api.v1.schemas.user_schema import UserCreateRequest, UserResponse
from app.services.user_service import UserService
from app.core.deps import get_user_service

router = APIRouter(prefix="/users", tags=["users"])

@router.post("/", response_model=UserResponse, status_code=201)
async def create_user(
    request: UserCreateRequest,
    service: UserService = Depends(get_user_service),
) -> UserResponse:
    return await service.create_user(request)
```

**约束：**
- ✅ 仅做参数校验（`@validator` / Pydantic）、调用 Service、返回响应
- ✅ 使用 Pydantic Schema 做请求/响应模型，不直接暴露 ORM Model
- ❌ 禁止在 API 层编写业务逻辑
- ❌ 禁止在 API 层直接操作数据库

#### Service 层

```python
from typing import Optional
from app.repositories.user_repo import UserRepository
from app.api.v1.schemas.user_schema import UserCreateRequest, UserResponse
from app.core.exceptions import BusinessError, ErrorCode

class UserService:
    def __init__(self, user_repo: UserRepository) -> None:
        self._user_repo = user_repo

    async def create_user(self, request: UserCreateRequest) -> UserResponse:
        existing = await self._user_repo.get_by_email(request.email)
        if existing is not None:
            raise BusinessError(ErrorCode.USER_ALREADY_EXISTS)
        user = await self._user_repo.create(request)
        return UserResponse.model_validate(user)
```

**约束：**
- ✅ 核心业务逻辑的唯一归属层
- ✅ 控制事务边界（`@Transactional` 或手动 `session.commit()`）
- ✅ 调用一个或多个 Repository 完成业务编排
- ✅ 返回 Pydantic Schema 或基础类型，不返回 ORM Model
- ❌ 禁止直接依赖 HTTP 请求对象（`Request`/`Response`）

#### Repository 层

```python
from typing import Optional, Sequence
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.models.user import User
from app.api.v1.schemas.user_schema import UserCreateRequest

class UserRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_by_id(self, user_id: int) -> Optional[User]:
        stmt = select(User).where(User.id == user_id)
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def get_by_email(self, email: str) -> Optional[User]:
        stmt = select(User).where(User.email == email)
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def create(self, request: UserCreateRequest) -> User:
        user = User(**request.model_dump())
        self._session.add(user)
        await self._session.flush()
        return user

    async def list_users(
        self, offset: int = 0, limit: int = 20
    ) -> Sequence[User]:
        stmt = select(User).offset(offset).limit(limit)
        result = await self._session.execute(stmt)
        return result.scalars().all()
```

**约束：**
- ✅ 只做数据存取，不包含业务判断
- ✅ 使用参数化查询，禁止字符串拼接 SQL
- ✅ 返回 ORM Model 或基础类型
- ❌ 禁止包含业务逻辑

#### Model 层

```python
from datetime import datetime
from sqlalchemy import String, DateTime, Boolean
from sqlalchemy.orm import Mapped, mapped_column
from app.models.base import Base

class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    email: Mapped[str] = mapped_column(String(255), unique=True, nullable=False)
    nickname: Mapped[str] = mapped_column(String(100), nullable=False)
    hashed_password: Mapped[str] = mapped_column(String(255), nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=datetime.now, nullable=False
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=datetime.now, onupdate=datetime.now, nullable=False
    )
```

**约束：**
- ✅ 只定义字段映射与表级约束
- ✅ 可包含简单的属性计算（`@property`）
- ❌ 禁止包含业务方法或调用 Service/Repository

### 3.3 依赖注入

使用 FastAPI 的 `Depends` 实现依赖注入，避免硬编码依赖：

```python
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.deps import get_db_session
from app.repositories.user_repo import UserRepository
from app.services.user_service import UserService

async def get_user_service(
    session: AsyncSession = Depends(get_db_session),
) -> UserService:
    user_repo = UserRepository(session)
    return UserService(user_repo)
```

---

## 4. 接口设计规范

### 4.1 RESTful 设计原则

| 规则 | 示例 |
|------|------|
| 资源名用复数名词 | `/users`、`/orders` |
| 使用 HTTP 方法表达操作 | `GET` 查询、`POST` 创建、`PUT` 全量更新、`PATCH` 部分更新、`DELETE` 删除 |
| 嵌套资源最多两层 | `/users/{id}/orders` |
| URL 使用 kebab-case | `/user-profiles` |
| 查询参数使用 snake_case | `?page_size=10&sort_by=created_at` |
| 版本化放在 URL 前缀 | `/api/v1/users` |

### 4.2 统一响应格式

```python
from pydantic import BaseModel
from typing import Generic, TypeVar, Optional

T = TypeVar("T")

class ApiResponse(BaseModel, Generic[T]):
    code: int = 0
    message: str = "success"
    data: Optional[T] = None

class PagedData(BaseModel, Generic[T]):
    items: list[T]
    total: int
    page: int
    page_size: int

class PagedResponse(ApiResponse[PagedData[T]], Generic[T]):
    pass
```

**成功响应示例：**

```json
{
    "code": 0,
    "message": "success",
    "data": {
        "id": 1,
        "email": "user@example.com",
        "nickname": "Alice"
    }
}
```

**分页响应示例：**

```json
{
    "code": 0,
    "message": "success",
    "data": {
        "items": [...],
        "total": 100,
        "page": 1,
        "page_size": 20
    }
}
```

**错误响应示例：**

```json
{
    "code": 40001,
    "message": "用户已存在",
    "data": null
}
```

### 4.3 HTTP 状态码使用

| 状态码 | 场景 |
|--------|------|
| `200 OK` | 查询/更新成功 |
| `201 Created` | 资源创建成功 |
| `204 No Content` | 删除成功（无响应体） |
| `400 Bad Request` | 请求参数校验失败 |
| `401 Unauthorized` | 未认证 |
| `403 Forbidden` | 无权限 |
| `404 Not Found` | 资源不存在 |
| `409 Conflict` | 资源冲突（如唯一约束） |
| `422 Unprocessable Entity` | 业务校验失败 |
| `429 Too Many Requests` | 限流 |
| `500 Internal Server Error` | 服务端异常 |

### 4.4 请求校验

使用 Pydantic V2 进行严格校验：

```python
from pydantic import BaseModel, EmailStr, Field, field_validator
from typing import Optional

class UserCreateRequest(BaseModel):
    email: EmailStr
    nickname: str = Field(min_length=2, max_length=50, examples=["Alice"])
    password: str = Field(min_length=8, max_length=128)

    @field_validator("password")
    @classmethod
    def validate_password_strength(cls, v: str) -> str:
        if not any(c.isupper() for c in v):
            raise ValueError("密码必须包含至少一个大写字母")
        if not any(c.isdigit() for c in v):
            raise ValueError("密码必须包含至少一个数字")
        return v

class UserUpdateRequest(BaseModel):
    nickname: Optional[str] = Field(default=None, min_length=2, max_length=50)
```

### 4.5 接口文档

- 使用 FastAPI 自动生成的 OpenAPI 文档
- 每个 endpoint 必须填写 `summary`、`description`、`response_model`
- Schema 字段必须提供 `description` 和 `examples`

```python
@router.get(
    "/{user_id}",
    response_model=ApiResponse[UserResponse],
    summary="获取用户详情",
    description="根据用户ID获取用户的详细信息",
    responses={404: {"description": "用户不存在"}},
)
async def get_user(
    user_id: int = Path(..., description="用户ID", gt=0),
    service: UserService = Depends(get_user_service),
) -> ApiResponse[UserResponse]:
    data = await service.get_user(user_id)
    return ApiResponse(data=data)
```

---

## 5. 模块设计规范

### 5.1 模块划分原则

| 原则 | 说明 |
|------|------|
| 高内聚低耦合 | 模块内部功能紧密相关，模块之间依赖最小 |
| 单一职责 | 每个模块只负责一个业务领域 |
| 显式导入 | 禁止 `from module import *` |
| 循环依赖零容忍 | 模块间不允许循环导入，如有则提取公共模块 |

### 5.2 `__init__.py` 规范

- `__init__.py` 仅用于导出公共 API，不包含逻辑代码
- 使用 `__all__` 显式声明导出列表

```python
# app/services/__init__.py
from app.services.user_service import UserService
from app.services.order_service import OrderService

__all__ = ["UserService", "OrderService"]
```

### 5.3 模块间依赖方向

```
api → services → repositories → models
  ↓       ↓          ↓
schemas  schemas    models
  ↓
 core (config, exceptions, security)
```

- 依赖只能从上层指向下层，禁止反向依赖
- `core` 模块不依赖任何业务模块
- `schemas` 可被 `api` 和 `services` 共同引用

### 5.4 公共模块提取

当两个以上模块需要同一功能时，提取到 `utils/` 或 `core/`：

```
utils/
├── datetime.py     # 日期时间工具
├── crypto.py       # 加解密工具
├── string.py       # 字符串处理
└── pagination.py   # 分页工具
```

---

## 6. 函数设计规范

### 6.1 基本原则

| 规则 | 说明 |
|------|------|
| 单一职责 | 一个函数只做一件事 |
| 短小精悍 | 函数体不超过 50 行，超过则拆分 |
| 参数不超过 5 个 | 超过则使用 Pydantic Model 或 `dataclass` 封装 |
| 纯函数优先 | 相同输入始终产生相同输出，无副作用 |
| 显式返回 | 必须声明返回类型，不依赖隐式 `None` |

### 6.2 函数签名规范

```python
from typing import Optional

# ✅ 正确：类型注解完整，参数有默认值放后面
async def query_users(
    page: int = 1,
    page_size: int = 20,
    keyword: Optional[str] = None,
) -> list[User]:
    ...

# ❌ 错误：缺少返回类型
async def query_users(page, page_size, keyword=None):
    ...
```

### 6.3 函数命名规范

| 类型 | 风格 | 示例 |
|------|------|------|
| 普通函数 | snake_case | `get_user_by_id` |
| 私有函数 | _前缀 | `_hash_password` |
| 异步函数 | snake_case + async | `async def fetch_user` |
| 布尔返回函数 | is/has/can/should 前缀 | `is_active`、`has_permission` |
| 工厂函数 | create_ 前缀 | `create_user_service` |

### 6.4 类型注解要求

```python
from typing import Optional

# ✅ 完整类型注解
def find_user(email: str) -> Optional[User]:
    ...

# ✅ 使用 Python 3.10+ 联合类型
def find_user(email: str) -> User | None:
    ...

# ✅ 使用 collections.abc 替代 typing
from collections.abc import Sequence

def list_users() -> Sequence[User]:
    ...

# ❌ 禁止使用 Any
def process(data: Any) -> Any:  # 禁止
    ...

# ✅ 使用 unknown + 类型收窄
def process(data: unknown) -> str:
    if isinstance(data, dict):
        return str(data.get("key", ""))
    raise TypeError(f"Expected dict, got {type(data)}")
```

### 6.5 装饰器使用

```python
from functools import wraps
from time import perf_counter
from app.core.logging import get_logger

logger = get_logger(__name__)

def measure_time(func):
    @wraps(func)
    async def wrapper(*args, **kwargs):
        start = perf_counter()
        try:
            return await func(*args, **kwargs)
        finally:
            elapsed = perf_counter() - start
            logger.info("%s executed in %.3fs", func.__qualname__, elapsed)
    return wrapper
```

---

## 7. 变量定义规范

### 7.1 命名规范

| 类型 | 风格 | 示例 |
|------|------|------|
| 模块级变量 | snake_case | `default_page_size = 20` |
| 常量 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT = 3` |
| 类属性 | snake_case | `self.user_name` |
| 私有属性 | _前缀 | `self._internal_cache` |
| 布尔变量 | is/has/can/should 前缀 | `is_active`、`has_permission` |
| 类型变量 | PascalCase + T 前缀 | `TModel = TypeVar("TModel")` |
| Pydantic Schema | PascalCase + 后缀 | `UserCreateRequest`、`UserResponse` |

### 7.2 常量定义

```python
# ✅ 模块级常量，使用 UPPER_SNAKE_CASE
MAX_RETRY_COUNT = 3
DEFAULT_PAGE_SIZE = 20
CACHE_TTL_SECONDS = 300

# ✅ 使用 Enum 管理相关常量
from enum import Enum

class UserStatus(str, Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"
    BANNED = "banned"
```

### 7.3 变量初始化

```python
# ✅ 使用 immutable 优先
total_count: int = 0
user_list: list[User] = []

# ✅ 延迟初始化使用 Optional
cached_config: Optional[dict[str, str]] = None

# ✅ 类属性提供类型注解和默认值
class UserService:
    _instance: Optional["UserService"] = None
    default_role: str = "member"
```

### 7.4 禁止事项

```python
# ❌ 禁止使用单字母变量（循环计数器 i/j/k 除外）
x = get_data()

# ❌ 禁止使用内置名覆盖
list = [1, 2, 3]     # 覆盖内置 list
id = 123             # 覆盖内置 id
type = "admin"       # 覆盖内置 type

# ❌ 禁止魔法数字
if status == 3:      # 3 代表什么？
    ...

# ✅ 使用命名常量
BANNED_STATUS = 3
if status == BANNED_STATUS:
    ...
```

---

## 8. 异常处理规范

### 8.1 异常体系设计

```python
from enum import Enum

class ErrorCode(Enum):
    # 通用错误 10xxx
    UNKNOWN_ERROR = (10000, "未知错误")
    PARAM_ERROR = (10001, "参数错误")
    UNAUTHORIZED = (10002, "未认证")
    FORBIDDEN = (10003, "无权限")

    # 用户模块 20xxx
    USER_NOT_FOUND = (20001, "用户不存在")
    USER_ALREADY_EXISTS = (20002, "用户已存在")
    USER_PASSWORD_ERROR = (20003, "密码错误")

    # 订单模块 30xxx
    ORDER_NOT_FOUND = (30001, "订单不存在")
    ORDER_STATUS_ERROR = (30002, "订单状态异常")

    def __init__(self, code: int, message: str) -> None:
        self.code = code
        self.message = message


class BusinessError(Exception):
    def __init__(self, error_code: ErrorCode, detail: str = "") -> None:
        self.error_code = error_code
        self.detail = detail or error_code.message
        super().__init__(self.detail)


class NotFoundError(BusinessError):
    pass


class ConflictError(BusinessError):
    pass
```

### 8.2 全局异常处理

```python
from fastapi import Request
from fastapi.responses import JSONResponse
from fastapi.exception_handlers import http_exception_handler
from app.core.exceptions import BusinessError

async def business_error_handler(
    request: Request, exc: BusinessError
) -> JSONResponse:
    status_map = {
        "NotFoundError": 404,
        "ConflictError": 409,
    }
    status = status_map.get(type(exc).__name__, 422)
    return JSONResponse(
        status_code=status,
        content={
            "code": exc.error_code.code,
            "message": exc.detail,
            "data": None,
        },
    )
```

### 8.3 异常处理原则

```python
# ✅ 谁捕获谁记录，不吞异常
try:
    result = await risky_operation()
except ValueError as e:
    logger.error("Failed to process data: %s", data_id, exc_info=e)
    raise BusinessError(ErrorCode.PARAM_ERROR) from e

# ✅ 使用 from 保留异常链
except DatabaseError as e:
    raise BusinessError(ErrorCode.UNKNOWN_ERROR) from e

# ❌ 禁止空 except
try:
    ...
except Exception:
    pass  # 绝对禁止

# ❌ 禁止捕获过于宽泛的异常
except Exception:  # 应该捕获具体异常
    ...

# ✅ 使用 try/finally 管理资源
async with session.begin():
    await session.execute(stmt)
```

---

## 9. 日志规范

### 9.1 日志配置

```python
import logging
import sys
from logging.config import dictConfig

LOGGING_CONFIG = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "json": {
            "class": "pythonjsonlogger.jsonlogger.JsonFormatter",
            "format": "%(asctime)s %(levelname)s %(name)s %(message)s",
        },
    },
    "handlers": {
        "stdout": {
            "class": "logging.StreamHandler",
            "stream": sys.stdout,
            "formatter": "json",
        },
    },
    "root": {
        "level": "INFO",
        "handlers": ["stdout"],
    },
}

dictConfig(LOGGING_CONFIG)
```

### 9.2 日志使用规范

```python
import logging

logger = logging.getLogger(__name__)

# ✅ 使用 % 格式化（惰性求值，性能更好）
logger.info("User %s logged in from %s", user_id, ip_address)
logger.error("Failed to create order for user %s", user_id, exc_info=e)

# ❌ 禁止使用 f-string（急切求值，影响性能）
logger.info(f"User {user_id} logged in")  # 禁止

# ❌ 禁止在日志中输出敏感信息
logger.info("User password: %s", password)  # 绝对禁止
logger.info("User token: %s", token)        # 绝对禁止
```

### 9.3 日志级别使用

| 级别 | 场景 |
|------|------|
| `DEBUG` | 开发调试信息，生产环境关闭 |
| `INFO` | 关键业务流程节点（用户登录、订单创建等） |
| `WARNING` | 可恢复的异常情况（重试成功、降级处理） |
| `ERROR` | 需要关注的错误（外部服务调用失败、数据不一致） |
| `CRITICAL` | 系统级故障（数据库不可用、磁盘满） |

---

## 10. 数据库与 ORM 规范

### 10.1 ORM 使用规范

```python
# ✅ 使用 2.0 风格的 SQLAlchemy 查询
from sqlalchemy import select

stmt = select(User).where(User.email == email)
result = await session.execute(stmt)
user = result.scalar_one_or_none()

# ❌ 禁止使用 1.x 遗留查询
session.query(User).filter_by(email=email).first()  # 禁止

# ✅ 使用 AsyncSession
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession

engine = create_async_engine(DATABASE_URL, echo=False)
async_session = async_sessionmaker(engine, class_=AsyncSession)
```

### 10.2 数据库迁移

- 使用 Alembic 管理数据库迁移
- 每次模型变更必须生成迁移脚本
- 迁移脚本必须经过 Code Review
- 禁止手动修改数据库结构

```bash
# 生成迁移脚本
alembic revision --autogenerate -m "add_user_phone_column"

# 执行迁移
alembic upgrade head

# 回滚
alembic downgrade -1
```

### 10.3 查询性能

```python
# ✅ 使用 eager loading 避免 N+1
from sqlalchemy.orm import selectinload

stmt = select(Order).options(selectinload(Order.items))

# ✅ 分页查询
stmt = select(User).offset(offset).limit(limit)

# ✅ 只查询需要的列
stmt = select(User.id, User.email).where(User.is_active.is_(True))

# ❌ 禁止无限制查询
stmt = select(User)  # 没有 limit，可能返回海量数据
```

---

## 11. 配置管理规范

### 11.1 配置分层

```
环境变量 (.env) → 默认值 (config.py) → 运行时覆盖
```

优先级从高到低：环境变量 > `.env` 文件 > 代码默认值

### 11.2 配置模型

```python
from pydantic_settings import BaseSettings
from pydantic import Field

class AppConfig(BaseSettings):
    app_name: str = "my-service"
    debug: bool = False
    database_url: str = Field(..., description="数据库连接字符串")
    redis_url: str = Field(default="redis://localhost:6379/0")
    jwt_secret: str = Field(..., description="JWT 签名密钥")
    jwt_expire_minutes: int = Field(default=60, gt=0)

    model_config = {
        "env_file": ".env",
        "env_file_encoding": "utf-8",
        "case_sensitive": False,
    }

settings = AppConfig()
```

### 11.3 敏感信息管理

- 密钥、密码等敏感配置必须通过环境变量注入
- `.env` 文件必须加入 `.gitignore`
- 提供 `.env.example` 作为模板，不含真实值
- 禁止在代码中硬编码任何密钥

---

## 12. 安全规范

### 12.1 认证与授权

```python
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import jwt, JWTError

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")

async def get_current_user(
    token: str = Depends(oauth2_scheme),
) -> User:
    try:
        payload = jwt.decode(
            token, settings.jwt_secret, algorithms=["HS256"]
        )
        user_id: int | None = payload.get("sub")
        if user_id is None:
            raise HTTPException(status_code=401)
    except JWTError:
        raise HTTPException(status_code=401)
    user = await user_repo.get_by_id(user_id)
    if user is None:
        raise HTTPException(status_code=401)
    return user
```

### 12.2 输入安全

| 规则 | 说明 |
|------|------|
| 参数化查询 | 禁止字符串拼接 SQL |
| 输入校验 | 所有外部输入必须通过 Pydantic 校验 |
| 输出编码 | 防止 XSS，JSON 响应自动转义 |
| 文件上传 | 校验文件类型、大小，使用随机文件名 |
| 限流 | 使用 `slowapi` 等中间件限制请求频率 |

### 12.3 密码安全

```python
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(plain: str) -> str:
    return pwd_context.hash(plain)

def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)
```

---

## 13. 测试规范

### 13.1 测试分层

| 层级 | 占比 | 说明 |
|------|------|------|
| 单元测试 | 70% | 测试 Service/Repository/Utils 逻辑 |
| 集成测试 | 20% | 测试 API 端到端流程（含数据库） |
| E2E 测试 | 10% | 测试关键业务场景 |

### 13.2 测试命名

```python
# 格式：test_{方法名}_{场景}_{预期结果}
def test_create_user_when_email_exists_raises_conflict():
    ...

def test_get_user_when_not_found_returns_none():
    ...
```

### 13.3 测试结构（AAA 模式）

```python
import pytest
from app.services.user_service import UserService
from app.core.exceptions import BusinessError, ErrorCode

@pytest.mark.asyncio
async def test_create_user_when_email_exists_raises_conflict(
    user_service: UserService, user_repo: UserRepository
):
    # Arrange
    request = UserCreateRequest(email="test@example.com", nickname="Alice", password="Pass1234")
    await user_service.create_user(request)

    # Act & Assert
    with pytest.raises(BusinessError) as exc_info:
        await user_service.create_user(request)
    assert exc_info.value.error_code == ErrorCode.USER_ALREADY_EXISTS
```

### 13.4 Fixture 设计

```python
import pytest
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker

@pytest.fixture
async def db_session() -> AsyncGenerator[AsyncSession, None]:
    engine = create_async_engine("sqlite+aiosqlite:///:memory:")
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    session_factory = async_sessionmaker(engine, class_=AsyncSession)
    async with session_factory() as session:
        yield session
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
    await engine.dispose()
```

### 13.5 覆盖率要求

- 行覆盖率 ≥ 80%
- 核心业务逻辑覆盖率 ≥ 90%
- 使用 `pytest-cov` 生成报告：

```bash
pytest --cov=src/app --cov-report=html --cov-fail-under=80
```

---

## 14. 性能与并发规范

### 14.1 异步编程

```python
# ✅ 使用 async/await
async def fetch_user_and_orders(user_id: int) -> dict:
    user_task = user_repo.get_by_id(user_id)
    orders_task = order_repo.list_by_user_id(user_id)
    user, orders = await asyncio.gather(user_task, orders_task)
    return {"user": user, "orders": orders}

# ❌ 禁止在异步上下文中使用同步阻塞调用
import requests  # 禁止在 async 函数中使用
result = requests.get(url)  # 会阻塞事件循环

# ✅ 使用 httpx 替代
import httpx
async with httpx.AsyncClient() as client:
    result = await client.get(url)
```

### 14.2 缓存策略

```python
from functools import lru_cache

# ✅ 纯函数结果缓存
@lru_cache(maxsize=256)
def get_region_name(region_code: str) -> str:
    ...

# ✅ Redis 缓存（异步）
async def get_user_with_cache(user_id: int) -> User:
    cache_key = f"user:{user_id}"
    cached = await redis.get(cache_key)
    if cached is not None:
        return UserResponse.model_validate_json(cached)
    user = await user_repo.get_by_id(user_id)
    if user is not None:
        await redis.setex(cache_key, CACHE_TTL_SECONDS, UserResponse.model_validate(user).model_dump_json())
    return user
```

### 14.3 连接池管理

```python
from sqlalchemy.ext.asyncio import create_async_engine

engine = create_async_engine(
    DATABASE_URL,
    pool_size=10,
    max_overflow=20,
    pool_timeout=30,
    pool_recycle=3600,
    echo=False,
)
```

---

## 15. 代码审查清单

### 15.1 提交前自查

- [ ] 所有函数都有完整的类型注解
- [ ] `mypy --strict` 通过，无错误
- [ ] `ruff check` 和 `ruff format` 通过
- [ ] 所有测试通过，覆盖率达标
- [ ] 无硬编码密钥或敏感信息
- [ ] 无 `Any` 类型使用
- [ ] 无循环导入
- [ ] 异常处理完整，无空 `except`
- [ ] 日志不包含敏感信息
- [ ] 新增接口有 OpenAPI 文档

### 15.2 Code Review 关注点

| 维度 | 检查项 |
|------|--------|
| **正确性** | 逻辑是否正确？边界条件是否处理？ |
| **安全性** | 是否有注入风险？权限校验是否完整？ |
| **性能** | 是否有 N+1 查询？是否有不必要的全表扫描？ |
| **可维护性** | 命名是否清晰？函数是否过长？职责是否单一？ |
| **异常处理** | 异常是否被正确捕获和传播？是否有资源泄漏？ |
| **测试** | 是否有对应测试？测试是否覆盖关键路径？ |

### 15.3 工具链配置

```toml
# pyproject.toml

[tool.ruff]
target-version = "py310"
line-length = 120

[tool.ruff.lint]
select = ["E", "F", "W", "I", "N", "UP", "B", "A", "SIM", "TCH"]

[tool.mypy]
strict = true
python_version = "3.10"
warn_return_any = true
disallow_untyped_defs = true

[tool.pytest.ini_options]
asyncio_mode = "auto"
testpaths = ["tests"]
```

---

## 附录：推荐技术栈

| 类别 | 推荐方案 |
|------|----------|
| Web 框架 | FastAPI |
| ORM | SQLAlchemy 2.0 (Async) |
| 数据校验 | Pydantic V2 |
| 数据库迁移 | Alembic |
| 任务队列 | Celery + Redis |
| 缓存 | Redis |
| HTTP 客户端 | httpx |
| 测试 | pytest + pytest-asyncio + httpx |
| 代码质量 | ruff + mypy --strict |
| 日志 | structlog / python-json-logger |
| 配置 | pydantic-settings |
| 容器化 | Docker + docker-compose |
| CI/CD | GitHub Actions / GitLab CI |
