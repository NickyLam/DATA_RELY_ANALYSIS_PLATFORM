"""
Redis 缓存连接
"""
import redis.asyncio as redis

from app.core.config import settings


async def init_redis() -> None:
    """
    初始化 Redis 连接
    """
    client = redis.from_url(
        settings.REDIS_URL,
        encoding="utf-8",
        decode_responses=True,
    )
    
    # 验证连接
    await client.ping()
    
    # 存储到应用状态
    # 注意：这里需要在 main.py 中设置 app.state.redis_client = client


async def get_redis() -> redis.Redis:
    """
    获取 Redis 客户端（依赖注入）
    """
    from app.main import app
    
    return app.state.redis_client