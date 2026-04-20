"""
Oracle 19c JDBC 元数据采集器模块

提供 Oracle 数据库元数据采集功能，包括：
- JDBC 元数据采集（表、列、约束）
- Oracle 系统视图采集（依赖关系、视图、触发器）
- PL/SQL 源码采集（存储过程、函数、包）
- 运行时血缘采集（审计日志、V$SQL）
"""

from app.collectors.base_collector import (
    BaseCollector,
    CollectorConfig,
    CollectorResult,
    CollectorStatus,
    ColumnMetadata,
    ConstraintMetadata,
    DataSourceType,
    DependencyMetadata,
    PLSQLSourceMetadata,
    TableMetadata,
)
from app.collectors.jdbc_collector import JDBCCollector
from app.collectors.oracle_views_collector import OracleViewsCollector
from app.collectors.plsql_collector import PLSQLCollector
from app.collectors.audit_collector import AuditLogCollector
from app.collectors.vsql_collector import VSQLCollector

__all__ = [
    "BaseCollector",
    "CollectorConfig",
    "CollectorResult",
    "CollectorStatus",
    "ColumnMetadata",
    "ConstraintMetadata",
    "DataSourceType",
    "DependencyMetadata",
    "PLSQLSourceMetadata",
    "TableMetadata",
    "JDBCCollector",
    "OracleViewsCollector",
    "PLSQLCollector",
    "AuditLogCollector",
    "VSQLCollector",
]