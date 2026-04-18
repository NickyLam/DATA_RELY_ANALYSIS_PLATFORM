"""
PostgreSQL 数据库连接
使用 SQLAlchemy ORM
"""
from sqlalchemy import create_engine
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import declarative_base, sessionmaker

from app.core.config import settings

# 同步引擎（用于初始化）
engine = create_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,
    echo=False,
)

# 异步引擎（用于应用）
async_engine = create_async_engine(
    settings.DATABASE_URL.replace("postgresql://", "postgresql+asyncpg://"),
    echo=False,
)

# 会话工厂
AsyncSessionLocal = sessionmaker(
    async_engine,
    class_=AsyncSession,
    expire_on_commit=False,
)

# 基础模型
Base = declarative_base()


async def init_db() -> None:
    """
    初始化数据库连接
    """
    # 创建所有表（如果不存在）
    # 注意：生产环境应该使用迁移工具（如 Alembic）
    # Base.metadata.create_all(bind=engine)
    pass


async def get_db() -> AsyncSession:
    """
    获取数据库会话（依赖注入）
    """
    async with AsyncSessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()