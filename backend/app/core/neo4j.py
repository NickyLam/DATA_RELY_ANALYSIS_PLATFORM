"""
Neo4j 图数据库连接
"""
from neo4j import AsyncGraphDatabase

from app.core.config import settings


async def init_neo4j() -> None:
    """
    初始化 Neo4j 连接
    """
    driver = AsyncGraphDatabase.driver(
        settings.NEO4J_URI,
        auth=(settings.NEO4J_USER, settings.NEO4J_PASSWORD),
    )
    
    # 验证连接
    await driver.verify_connectivity()
    
    # 存储到应用状态
    # 注意：这里需要在 main.py 中设置 app.state.neo4j_driver = driver


async def get_neo4j_session():
    """
    获取 Neo4j 会话（依赖注入）
    """
    from app.main import app
    
    driver = app.state.neo4j_driver
    async with driver.session() as session:
        try:
            yield session
        finally:
            await session.close()