"""
数据源 Pydantic 模型
"""
from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


class DataSourceBase(BaseModel):
    """
    数据源基础模型
    """
    name: str = Field(..., description="数据源名称")
    type: str = Field(..., description="数据源类型：oracle, tdh, oceanbase, gbase, yashan")
    host: str = Field(..., description="主机地址")
    port: int = Field(..., description="端口")
    database_name: Optional[str] = Field(None, description="数据库名称")
    username: Optional[str] = Field(None, description="用户名")
    description: Optional[str] = Field(None, description="描述")


class DataSourceCreate(DataSourceBase):
    """
    创建数据源请求模型
    """
    password: Optional[str] = Field(None, description="密码")
    connection_params: Optional[dict] = Field(None, description="连接参数")


class DataSourceUpdate(BaseModel):
    """
    更新数据源请求模型
    """
    name: Optional[str] = None
    host: Optional[str] = None
    port: Optional[int] = None
    database_name: Optional[str] = None
    username: Optional[str] = None
    password: Optional[str] = None
    description: Optional[str] = None
    status: Optional[str] = None


class DataSourceResponse(DataSourceBase):
    """
    数据源响应模型
    """
    id: str
    status: str = Field(..., description="状态：active, inactive, error")
    created_at: datetime
    updated_at: datetime
    last_collected_at: Optional[datetime] = None
    created_by: Optional[str] = None
    updated_by: Optional[str] = None
    
    class Config:
        from_attributes = True