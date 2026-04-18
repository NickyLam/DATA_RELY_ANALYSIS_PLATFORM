"""
应用配置
使用 Pydantic Settings 管理环境变量
"""
from typing import List

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """
    应用配置类
    """
    
    # 项目基础配置
    PROJECT_NAME: str = "数据血缘分析平台"
    VERSION: str = "1.0.0"
    DESCRIPTION: str = "异构数据库血缘分析平台后端服务"
    API_V1_STR: str = "/api/v1"
    
    # 安全配置
    SECRET_KEY: str = "your-secret-key-change-in-production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    # CORS 配置
    ALLOWED_ORIGINS: List[str] = ["http://localhost:5173", "http://localhost:3000"]
    
    # PostgreSQL 配置
    POSTGRES_USER: str = "datahub"
    POSTGRES_PASSWORD: str = "datahub123"
    POSTGRES_HOST: str = "localhost"
    POSTGRES_PORT: int = 5432
    POSTGRES_DB: str = "datahub"
    
    @property
    def DATABASE_URL(self) -> str:
        """
        PostgreSQL 连接字符串
        """
        return f"postgresql://{self.POSTGRES_USER}:{self.POSTGRES_PASSWORD}@{self.POSTGRES_HOST}:{self.POSTGRES_PORT}/{self.POSTGRES_DB}"
    
    # Neo4j 配置
    NEO4J_USER: str = "neo4j"
    NEO4J_PASSWORD: str = "neo4j123"
    NEO4J_HOST: str = "localhost"
    NEO4J_HTTP_PORT: int = 7474
    NEO4J_BOLT_PORT: int = 7687
    
    @property
    def NEO4J_URI(self) -> str:
        """
        Neo4j 连接字符串
        """
        return f"bolt://{self.NEO4J_HOST}:{self.NEO4J_BOLT_PORT}"
    
    # Redis 配置
    REDIS_HOST: str = "localhost"
    REDIS_PORT: int = 6379
    
    @property
    def REDIS_URL(self) -> str:
        """
        Redis 连接字符串
        """
        return f"redis://{self.REDIS_HOST}:{self.REDIS_PORT}"
    
    # DataHub 配置
    DATAHUB_GMS_HOST: str = "localhost"
    DATAHUB_GMS_PORT: int = 8080
    
    @property
    def DATAHUB_GMS_URL(self) -> str:
        """
        DataHub GMS URL
        """
        return f"http://{self.DATAHUB_GMS_HOST}:{self.DATAHUB_GMS_PORT}"
    
    # Elasticsearch 配置
    ELASTICSEARCH_HOST: str = "localhost"
    ELASTICSEARCH_PORT: int = 9200
    
    @property
    def ELASTICSEARCH_URL(self) -> str:
        """
        Elasticsearch URL
        """
        return f"http://{self.ELASTICSEARCH_HOST}:{self.ELASTICSEARCH_PORT}"
    
    # Kafka 配置
    KAFKA_BOOTSTRAP_SERVER: str = "localhost:9092"
    
    # Celery 配置
    CELERY_BROKER_URL: str = "redis://localhost:6379/0"
    CELERY_RESULT_BACKEND: str = "redis://localhost:6379/0"
    
    # 日志配置
    LOG_LEVEL: str = "INFO"
    
    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()