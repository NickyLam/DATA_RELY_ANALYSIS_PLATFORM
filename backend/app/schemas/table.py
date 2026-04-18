"""
表元数据 Pydantic 模型
"""
from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


class TableBase(BaseModel):
    """
    表基础模型
    """
    name: str = Field(..., description="表名")
    type: str = Field("table", description="类型：table, view, materialized_view")
    description: Optional[str] = Field(None, description="描述")
    owner: Optional[str] = Field(None, description="所有者")


class TableResponse(TableBase):
    """
    表响应模型
    """
    id: str
    database_id: str
    row_count: Optional[int] = None
    column_count: Optional[int] = None
    created_at: datetime
    updated_at: datetime
    last_modified_at: Optional[datetime] = None
    is_active: bool = True
    
    class Config:
        from_attributes = True


class FieldBase(BaseModel):
    """
    字段基础模型
    """
    name: str = Field(..., description="字段名")
    data_type: Optional[str] = Field(None, description="数据类型")
    is_primary_key: bool = Field(False, description="是否主键")
    is_foreign_key: bool = Field(False, description="是否外键")
    is_nullable: bool = Field(True, description="是否可空")
    description: Optional[str] = Field(None, description="描述")


class FieldResponse(FieldBase):
    """
    字段响应模型
    """
    id: str
    table_id: str
    default_value: Optional[str] = None
    position: Optional[int] = None
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True