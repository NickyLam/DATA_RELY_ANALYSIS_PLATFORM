"""
SQL 解析器抽象基类
定义多数据源解析的统一接口，Oracle / TDH / GBase 解析器均继承此类。
"""

from __future__ import annotations

from abc import ABC, abstractmethod
from typing import Optional

from core.models import CaliberInfo, ProcedureInfo, TableInfo


class BaseSQLParser(ABC):
    """SQL 解析器抽象基类"""

    @abstractmethod
    def parse_ddl(self, content: str, file_path: str = "") -> Optional[TableInfo]:
        """解析 DDL 语句（CREATE TABLE），返回表结构信息"""
        ...

    @abstractmethod
    def parse_dml(self, content: str, file_path: str = "") -> Optional[ProcedureInfo]:
        """解析 DML 语句（存储过程/SQL脚本），返回过程信息"""
        ...

    @abstractmethod
    def extract_caliber(self, content: str, proc_info: ProcedureInfo) -> list[CaliberInfo]:
        """从 DML 中提取指标口径信息（WHERE/JOIN/GROUP BY 条件）"""
        ...

    @abstractmethod
    def supported_extensions(self) -> list[str]:
        """该解析器支持的文件扩展名"""
        ...

    @abstractmethod
    def data_source_name(self) -> str:
        """数据源标识（oracle/tdh/gbase）"""
        ...
