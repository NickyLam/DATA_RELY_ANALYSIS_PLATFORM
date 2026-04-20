"""
Oracle 审计日志采集器
从 DBA_AUDIT_TRAIL 视图采集运行态血缘
"""
import asyncio
import logging
import re
from dataclasses import dataclass, field
from datetime import datetime, timedelta
from enum import Enum
from typing import Any, Dict, List, Optional

from pydantic import BaseModel, Field

logger = logging.getLogger(__name__)


class AuditAction(Enum):
    """审计操作类型"""
    SELECT = "SELECT"
    INSERT = "INSERT"
    UPDATE = "UPDATE"
    DELETE = "DELETE"
    MERGE = "MERGE"
    CREATE = "CREATE"
    ALTER = "ALTER"
    DROP = "DROP"
    TRUNCATE = "TRUNCATE"
    EXECUTE = "EXECUTE"
    UNKNOWN = "UNKNOWN"


class AuditLogEntry(BaseModel):
    """审计日志条目"""
    session_id: int = Field(..., description="会话ID")
    session_serial: int = Field(..., description="会话序列号")
    user_name: str = Field(..., description="用户名")
    os_user: Optional[str] = Field(None, description="操作系统用户")
    user_host: Optional[str] = Field(None, description="客户端主机")
    action: AuditAction = Field(..., description="操作类型")
    action_name: str = Field(..., description="操作名称")
    object_name: Optional[str] = Field(None, description="对象名称")
    object_schema: Optional[str] = Field(None, description="对象所属模式")
    object_type: Optional[str] = Field(None, description="对象类型")
    sql_text: Optional[str] = Field(None, description="SQL文本")
    sql_bind: Optional[str] = Field(None, description="绑定变量")
    timestamp: datetime = Field(..., description="时间戳")
    return_code: int = Field(0, description="返回码")
    comment_text: Optional[str] = Field(None, description="注释文本")
    extended_timestamp: Optional[datetime] = Field(None, description="扩展时间戳")


class ParsedLineage(BaseModel):
    """解析后的血缘信息"""
    source_tables: List[str] = Field(default_factory=list, description="源表列表")
    target_tables: List[str] = Field(default_factory=list, description="目标表列表")
    source_fields: List[str] = Field(default_factory=list, description="源字段列表")
    target_fields: List[str] = Field(default_factory=list, description="目标字段列表")
    operation_type: str = Field(..., description="操作类型")
    sql_text: str = Field(..., description="原始SQL")
    confidence: float = Field(0.5, description="解析置信度")


@dataclass
class CollectorConfig:
    """采集器配置"""
    batch_size: int = 1000
    query_timeout: int = 300
    max_retries: int = 3
    retry_delay: float = 1.0
    time_range_hours: int = 24
    exclude_users: List[str] = field(default_factory=lambda: ["SYS", "SYSTEM", "DBSNMP"])
    exclude_schemas: List[str] = field(default_factory=lambda: ["SYS", "SYSTEM", "SYSMAN"])
    include_actions: List[AuditAction] = field(
        default_factory=lambda: [
            AuditAction.SELECT,
            AuditAction.INSERT,
            AuditAction.UPDATE,
            AuditAction.DELETE,
            AuditAction.MERGE,
        ]
    )


class AuditLogCollector:
    """
    Oracle 审计日志采集器
    
    从 DBA_AUDIT_TRAIL 视图采集审计记录，
    解析 SQL 语句提取血缘关系
    """
    
    TABLE_PATTERN = re.compile(
        r'(?:FROM|JOIN|INTO|UPDATE|MERGE\s+INTO)\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)',
        re.IGNORECASE
    )
    
    COLUMN_PATTERN = re.compile(
        r'(?:SELECT|INSERT\s+INTO|UPDATE\s+\w+\s+SET)\s+([A-Za-z_][A-Za-z0-9_]*(?:\s*,\s*[A-Za-z_][A-Za-z0-9_]*)*)',
        re.IGNORECASE
    )
    
    def __init__(
        self,
        connection_pool: Any,
        config: Optional[CollectorConfig] = None,
    ):
        """
        初始化审计日志采集器
        
        Args:
            connection_pool: Oracle 数据库连接池
            config: 采集器配置
        """
        self.connection_pool = connection_pool
        self.config = config or CollectorConfig()
        self._is_running = False
        self._stop_event = asyncio.Event()
    
    async def connect(self) -> bool:
        """
        测试数据库连接
        
        Returns:
            bool: 连接是否成功
        """
        try:
            async with self.connection_pool.acquire() as conn:
                cursor = await conn.execute("SELECT 1 FROM DUAL")
                await cursor.fetchone()
                logger.info("Oracle 审计日志采集器连接成功")
                return True
        except Exception as e:
            logger.error(f"Oracle 连接失败: {e}")
            return False
    
    async def collect_audit_logs(
        self,
        start_time: Optional[datetime] = None,
        end_time: Optional[datetime] = None,
        user_filter: Optional[List[str]] = None,
        schema_filter: Optional[List[str]] = None,
    ) -> List[AuditLogEntry]:
        """
        采集审计日志
        
        Args:
            start_time: 开始时间
            end_time: 结束时间
            user_filter: 用户过滤列表
            schema_filter: 模式过滤列表
        
        Returns:
            List[AuditLogEntry]: 审计日志列表
        """
        if start_time is None:
            start_time = datetime.now() - timedelta(hours=self.config.time_range_hours)
        if end_time is None:
            end_time = datetime.now()
        
        exclude_users = user_filter or self.config.exclude_users
        exclude_schemas = schema_filter or self.config.exclude_schemas
        
        query = self._build_audit_query(exclude_users, exclude_schemas)
        params = {
            "start_time": start_time,
            "end_time": end_time,
        }
        
        entries: List[AuditLogEntry] = []
        
        try:
            async with self.connection_pool.acquire() as conn:
                cursor = await conn.execute(query, params)
                rows = await cursor.fetchall()
                
                for row in rows:
                    entry = self._parse_audit_row(row)
                    if entry is not None:
                        entries.append(entry)
                
                logger.info(f"采集到 {len(entries)} 条审计日志")
                
        except Exception as e:
            logger.error(f"采集审计日志失败: {e}")
            raise
        
        return entries
    
    def _build_audit_query(
        self,
        exclude_users: List[str],
        exclude_schemas: List[str],
    ) -> str:
        """
        构建审计日志查询 SQL
        
        Args:
            exclude_users: 排除的用户列表
            exclude_schemas: 排除的模式列表
        
        Returns:
            str: SQL 查询语句
        """
        user_placeholders = ", ".join([f":user_{i}" for i in range(len(exclude_users))])
        schema_placeholders = ", ".join([f":schema_{i}" for i in range(len(exclude_schemas))])
        
        return f"""
        SELECT 
            SESSIONID,
            SES$ACTIONS,
            USERHOST,
            USERNAME,
            OS_USERNAME,
            USERHOST,
            ACTION,
            ACTION_NAME,
            OBJ_NAME,
            OBJ_SCHEMA,
            OBJ_TYPE,
            SQL_TEXT,
            SQL_BIND,
            TIMESTAMP,
            RETURNCODE,
            COMMENT$TEXT,
            EXTENDED_TIMESTAMP
        FROM DBA_AUDIT_TRAIL
        WHERE TIMESTAMP >= :start_time
          AND TIMESTAMP <= :end_time
          AND USERNAME NOT IN ({user_placeholders})
          AND OBJ_SCHEMA NOT IN ({schema_placeholders})
          AND RETURNCODE = 0
        ORDER BY TIMESTAMP DESC
        """
    
    def _parse_audit_row(self, row: Any) -> Optional[AuditLogEntry]:
        """
        解析审计日志行
        
        Args:
            row: 数据库行
        
        Returns:
            Optional[AuditLogEntry]: 解析后的审计日志条目
        """
        try:
            action = self._map_action_name(row[6], row[7])
            
            return AuditLogEntry(
                session_id=row[0] or 0,
                session_serial=row[1] or 0,
                user_name=row[3] or "",
                os_user=row[4],
                user_host=row[2] or row[5],
                action=action,
                action_name=row[7] or "",
                object_name=row[8],
                object_schema=row[9],
                object_type=row[10],
                sql_text=row[11],
                sql_bind=row[12],
                timestamp=row[13] or datetime.now(),
                return_code=row[14] or 0,
                comment_text=row[15],
                extended_timestamp=row[16],
            )
        except Exception as e:
            logger.warning(f"解析审计日志行失败: {e}")
            return None
    
    def _map_action_name(self, action_code: int, action_name: str) -> AuditAction:
        """
        映射操作名称到枚举
        
        Args:
            action_code: 操作码
            action_name: 操作名称
        
        Returns:
            AuditAction: 操作枚举
        """
        action_map = {
            "SELECT": AuditAction.SELECT,
            "INSERT": AuditAction.INSERT,
            "UPDATE": AuditAction.UPDATE,
            "DELETE": AuditAction.DELETE,
            "MERGE": AuditAction.MERGE,
            "CREATE": AuditAction.CREATE,
            "ALTER": AuditAction.ALTER,
            "DROP": AuditAction.DROP,
            "TRUNCATE": AuditAction.TRUNCATE,
            "EXECUTE": AuditAction.EXECUTE,
        }
        
        upper_name = (action_name or "").upper()
        for key, value in action_map.items():
            if key in upper_name:
                return value
        
        return AuditAction.UNKNOWN
    
    async def parse_lineage_from_sql(
        self,
        sql_text: str,
        action: AuditAction,
    ) -> ParsedLineage:
        """
        从 SQL 文本解析血缘关系
        
        Args:
            sql_text: SQL 文本
            action: 操作类型
        
        Returns:
            ParsedLineage: 解析后的血缘信息
        """
        if not sql_text:
            return ParsedLineage(
                operation_type=action.value,
                sql_text="",
                confidence=0.0,
            )
        
        sql_upper = sql_text.upper()
        source_tables: List[str] = []
        target_tables: List[str] = []
        confidence = 0.5
        
        if action == AuditAction.SELECT:
            source_tables = self._extract_tables_from_select(sql_text)
            confidence = 0.7
            
        elif action == AuditAction.INSERT:
            target_tables = self._extract_target_table(sql_text, "INSERT")
            source_tables = self._extract_source_tables(sql_text)
            confidence = 0.85
            
        elif action == AuditAction.UPDATE:
            target_tables = self._extract_target_table(sql_text, "UPDATE")
            source_tables = self._extract_source_tables(sql_text)
            confidence = 0.8
            
        elif action == AuditAction.DELETE:
            target_tables = self._extract_target_table(sql_text, "DELETE")
            confidence = 0.75
            
        elif action == AuditAction.MERGE:
            target_tables = self._extract_target_table(sql_text, "MERGE")
            source_tables = self._extract_source_tables(sql_text)
            confidence = 0.9
        
        source_tables = list(dict.fromkeys(source_tables))
        target_tables = list(dict.fromkeys(target_tables))
        
        source_fields = self._extract_columns(sql_text, "source")
        target_fields = self._extract_columns(sql_text, "target")
        
        return ParsedLineage(
            source_tables=source_tables,
            target_tables=target_tables,
            source_fields=source_fields,
            target_fields=target_fields,
            operation_type=action.value,
            sql_text=sql_text,
            confidence=confidence,
        )
    
    def _extract_tables_from_select(self, sql_text: str) -> List[str]:
        """
        从 SELECT 语句提取表名
        
        Args:
            sql_text: SQL 文本
        
        Returns:
            List[str]: 表名列表
        """
        tables: List[str] = []
        
        from_match = re.search(r'\bFROM\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)', sql_text, re.IGNORECASE)
        if from_match:
            tables.append(from_match.group(1))
        
        join_matches = re.findall(r'\bJOIN\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)', sql_text, re.IGNORECASE)
        tables.extend(join_matches)
        
        return tables
    
    def _extract_target_table(self, sql_text: str, operation: str) -> List[str]:
        """
        提取目标表名
        
        Args:
            sql_text: SQL 文本
            operation: 操作类型
        
        Returns:
            List[str]: 目标表名列表
        """
        tables: List[str] = []
        
        if operation == "INSERT":
            match = re.search(r'\bINSERT\s+INTO\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)', sql_text, re.IGNORECASE)
            if match:
                tables.append(match.group(1))
                
        elif operation == "UPDATE":
            match = re.search(r'\bUPDATE\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)', sql_text, re.IGNORECASE)
            if match:
                tables.append(match.group(1))
                
        elif operation == "DELETE":
            match = re.search(r'\bDELETE\s+FROM\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)', sql_text, re.IGNORECASE)
            if match:
                tables.append(match.group(1))
                
        elif operation == "MERGE":
            match = re.search(r'\bMERGE\s+INTO\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)', sql_text, re.IGNORECASE)
            if match:
                tables.append(match.group(1))
        
        return tables
    
    def _extract_source_tables(self, sql_text: str) -> List[str]:
        """
        提取源表名
        
        Args:
            sql_text: SQL 文本
        
        Returns:
            List[str]: 源表名列表
        """
        tables: List[str] = []
        
        from_matches = re.findall(r'\bFROM\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)', sql_text, re.IGNORECASE)
        tables.extend(from_matches)
        
        join_matches = re.findall(r'\bJOIN\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)', sql_text, re.IGNORECASE)
        tables.extend(join_matches)
        
        using_matches = re.findall(r'\bUSING\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)', sql_text, re.IGNORECASE)
        tables.extend(using_matches)
        
        return tables
    
    def _extract_columns(self, sql_text: str, column_type: str) -> List[str]:
        """
        提取列名
        
        Args:
            sql_text: SQL 文本
            column_type: 列类型 (source/target)
        
        Returns:
            List[str]: 列名列表
        """
        columns: List[str] = []
        
        if column_type == "source":
            select_match = re.search(r'\bSELECT\s+(.+?)\s+FROM', sql_text, re.IGNORECASE | re.DOTALL)
            if select_match:
                col_text = select_match.group(1)
                if "*" not in col_text:
                    col_names = re.findall(r'\b([A-Za-z_][A-Za-z0-9_]*)\b', col_text)
                    columns.extend([c for c in col_names if c.upper() not in ("SELECT", "FROM", "WHERE", "AND", "OR", "AS")])
        
        elif column_type == "target":
            insert_match = re.search(r'\bINSERT\s+INTO\s+[A-Za-z_][A-Za-z0-9_.]*\s*\(([^)]+)\)', sql_text, re.IGNORECASE)
            if insert_match:
                col_text = insert_match.group(1)
                col_names = re.findall(r'\b([A-Za-z_][A-Za-z0-9_]*)\b', col_text)
                columns.extend(col_names)
            
            update_match = re.search(r'\bSET\s+(.+?)\s+WHERE', sql_text, re.IGNORECASE | re.DOTALL)
            if update_match:
                col_text = update_match.group(1)
                col_names = re.findall(r'\b([A-Za-z_][A-Za-z0-9_]*)\s*=', col_text)
                columns.extend(col_names)
        
        return list(dict.fromkeys(columns))
    
    async def collect_and_parse(
        self,
        start_time: Optional[datetime] = None,
        end_time: Optional[datetime] = None,
    ) -> List[ParsedLineage]:
        """
        采集并解析审计日志
        
        Args:
            start_time: 开始时间
            end_time: 结束时间
        
        Returns:
            List[ParsedLineage]: 解析后的血缘列表
        """
        entries = await self.collect_audit_logs(start_time, end_time)
        
        lineages: List[ParsedLineage] = []
        
        for entry in entries:
            if entry.sql_text:
                lineage = await self.parse_lineage_from_sql(
                    entry.sql_text,
                    entry.action,
                )
                lineages.append(lineage)
        
        logger.info(f"解析出 {len(lineages)} 条血缘关系")
        return lineages
    
    async def start_continuous_collection(
        self,
        interval_seconds: int = 60,
        callback: Optional[Any] = None,
    ) -> None:
        """
        启动持续采集
        
        Args:
            interval_seconds: 采集间隔（秒）
            callback: 回调函数
        """
        self._is_running = True
        self._stop_event.clear()
        
        logger.info(f"启动审计日志持续采集，间隔 {interval_seconds} 秒")
        
        last_collection_time = datetime.now()
        
        while self._is_running and not self._stop_event.is_set():
            try:
                current_time = datetime.now()
                
                lineages = await self.collect_and_parse(
                    start_time=last_collection_time,
                    end_time=current_time,
                )
                
                if callback and lineages:
                    await callback(lineages)
                
                last_collection_time = current_time
                
                await asyncio.sleep(interval_seconds)
                
            except Exception as e:
                logger.error(f"持续采集出错: {e}")
                await asyncio.sleep(self.config.retry_delay)
    
    def stop_continuous_collection(self) -> None:
        """停止持续采集"""
        self._is_running = False
        self._stop_event.set()
        logger.info("停止审计日志持续采集")
    
    async def get_audit_statistics(
        self,
        start_time: Optional[datetime] = None,
        end_time: Optional[datetime] = None,
    ) -> Dict[str, Any]:
        """
        获取审计统计信息
        
        Args:
            start_time: 开始时间
            end_time: 结束时间
        
        Returns:
            Dict[str, Any]: 统计信息
        """
        if start_time is None:
            start_time = datetime.now() - timedelta(hours=self.config.time_range_hours)
        if end_time is None:
            end_time = datetime.now()
        
        query = """
        SELECT 
            ACTION_NAME,
            COUNT(*) as COUNT,
            USERNAME
        FROM DBA_AUDIT_TRAIL
        WHERE TIMESTAMP >= :start_time
          AND TIMESTAMP <= :end_time
          AND RETURNCODE = 0
        GROUP BY ACTION_NAME, USERNAME
        ORDER BY COUNT DESC
        """
        
        stats: Dict[str, Any] = {
            "total_count": 0,
            "by_action": {},
            "by_user": {},
            "time_range": {
                "start": start_time.isoformat(),
                "end": end_time.isoformat(),
            },
        }
        
        try:
            async with self.connection_pool.acquire() as conn:
                cursor = await conn.execute(query, {"start_time": start_time, "end_time": end_time})
                rows = await cursor.fetchall()
                
                for row in rows:
                    action_name = row[0] or "UNKNOWN"
                    count = row[1] or 0
                    username = row[2] or "UNKNOWN"
                    
                    stats["total_count"] += count
                    
                    if action_name not in stats["by_action"]:
                        stats["by_action"][action_name] = 0
                    stats["by_action"][action_name] += count
                    
                    if username not in stats["by_user"]:
                        stats["by_user"][username] = 0
                    stats["by_user"][username] += count
                    
        except Exception as e:
            logger.error(f"获取审计统计失败: {e}")
        
        return stats