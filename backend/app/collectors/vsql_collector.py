"""
Oracle V$SQL 视图采集器
从 V$SQL 视图采集执行语句和执行计划
"""
import asyncio
import logging
import re
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from typing import Any, Dict, List, Optional

from pydantic import BaseModel, Field

logger = logging.getLogger(__name__)


class ExecutionStatus(Enum):
    """执行状态"""
    SUCCESS = "SUCCESS"
    FAILED = "FAILED"
    RUNNING = "RUNNING"
    UNKNOWN = "UNKNOWN"


class SQLStatement(BaseModel):
    """SQL 语句模型"""
    sql_id: str = Field(..., description="SQL ID")
    sql_text: str = Field(..., description="SQL 文本")
    plan_hash_value: int = Field(0, description="执行计划哈希值")
    executions: int = Field(0, description="执行次数")
    elapsed_time: float = Field(0.0, description="总耗时（微秒）")
    cpu_time: float = Field(0.0, description="CPU 时间（微秒）")
    buffer_gets: int = Field(0, description="缓冲区获取次数")
    disk_reads: int = Field(0, description="磁盘读取次数")
    rows_processed: int = Field(0, description="处理行数")
    parsing_schema: str = Field("", description="解析模式")
    module: Optional[str] = Field(None, description="模块名")
    action: Optional[str] = Field(None, description="操作名")
    first_load_time: Optional[datetime] = Field(None, description="首次加载时间")
    last_load_time: Optional[datetime] = Field(None, description="最后加载时间")
    last_active_time: Optional[datetime] = Field(None, description="最后活跃时间")
    status: ExecutionStatus = Field(ExecutionStatus.UNKNOWN, description="执行状态")


class ExecutionPlan(BaseModel):
    """执行计划模型"""
    sql_id: str = Field(..., description="SQL ID")
    plan_hash_value: int = Field(0, description="计划哈希值")
    operation: str = Field(..., description="操作类型")
    options: Optional[str] = Field(None, description="操作选项")
    object_name: Optional[str] = Field(None, description="对象名")
    object_owner: Optional[str] = Field(None, description="对象所有者")
    object_type: Optional[str] = Field(None, description="对象类型")
    id: int = Field(0, description="计划 ID")
    parent_id: Optional[int] = Field(None, description="父 ID")
    depth: int = Field(0, description="深度")
    position: int = Field(0, description="位置")
    cardinality: Optional[int] = Field(None, description="基数")
    bytes: Optional[int] = Field(None, description="字节数")
    cost: Optional[float] = Field(None, description="成本")
    cpu_cost: Optional[float] = Field(None, description="CPU 成本")
    io_cost: Optional[float] = Field(None, description="IO 成本")
    time: Optional[int] = Field(None, description="预估时间")
    predicates: Optional[str] = Field(None, description="谓词")
    access_predicates: Optional[str] = Field(None, description="访问谓词")
    filter_predicates: Optional[str] = Field(None, description="过滤谓词")


class BindVariable(BaseModel):
    """绑定变量模型"""
    sql_id: str = Field(..., description="SQL ID")
    child_number: int = Field(0, description="子游标号")
    name: str = Field(..., description="变量名")
    position: int = Field(0, description="位置")
    datatype: str = Field("", description="数据类型")
    value_string: Optional[str] = Field(None, description="字符串值")
    value_anydata: Optional[Any] = Field(None, description="任意数据值")
    max_length: int = Field(0, description="最大长度")
    precision: Optional[int] = Field(None, description="精度")
    scale: Optional[int] = Field(None, description="小数位")


class VSQLLineage(BaseModel):
    """V$SQL 血缘模型"""
    sql_id: str = Field(..., description="SQL ID")
    sql_text: str = Field(..., description="SQL 文本")
    source_tables: List[str] = Field(default_factory=list, description="源表列表")
    target_tables: List[str] = Field(default_factory=list, description="目标表列表")
    source_fields: List[str] = Field(default_factory=list, description="源字段列表")
    target_fields: List[str] = Field(default_factory=list, description="目标字段列表")
    operation_type: str = Field(..., description="操作类型")
    execution_count: int = Field(0, description="执行次数")
    avg_elapsed_time: float = Field(0.0, description="平均耗时")
    confidence: float = Field(0.5, description="置信度")
    parsing_schema: str = Field("", description="解析模式")
    last_active_time: Optional[datetime] = Field(None, description="最后活跃时间")


@dataclass
class VSQLCollectorConfig:
    """V$SQL 采集器配置"""
    batch_size: int = 500
    query_timeout: int = 300
    max_retries: int = 3
    retry_delay: float = 1.0
    min_executions: int = 1
    exclude_schemas: List[str] = field(default_factory=lambda: ["SYS", "SYSTEM", "SYSMAN", "DBSNMP"])
    include_operations: List[str] = field(
        default_factory=lambda: ["SELECT", "INSERT", "UPDATE", "DELETE", "MERGE"]
    )
    max_sql_length: int = 4000
    collect_bind_variables: bool = True
    collect_execution_plans: bool = True


class VSQLCollector:
    """
    Oracle V$SQL 视图采集器
    
    从 V$SQL 视图采集执行语句，
    解析执行计划和绑定变量
    """
    
    TABLE_PATTERN = re.compile(
        r'(?:FROM|JOIN|INTO|UPDATE|MERGE\s+INTO)\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)',
        re.IGNORECASE
    )
    
    def __init__(
        self,
        connection_pool: Any,
        config: Optional[VSQLCollectorConfig] = None,
    ):
        """
        初始化 V$SQL 采集器
        
        Args:
            connection_pool: Oracle 数据库连接池
            config: 采集器配置
        """
        self.connection_pool = connection_pool
        self.config = config or VSQLCollectorConfig()
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
                logger.info("Oracle V$SQL 采集器连接成功")
                return True
        except Exception as e:
            logger.error(f"Oracle 连接失败: {e}")
            return False
    
    async def collect_sql_statements(
        self,
        schema_filter: Optional[List[str]] = None,
        min_executions: Optional[int] = None,
        limit: Optional[int] = None,
    ) -> List[SQLStatement]:
        """
        采集 SQL 语句
        
        Args:
            schema_filter: 模式过滤列表
            min_executions: 最小执行次数
            limit: 返回数量限制
        
        Returns:
            List[SQLStatement]: SQL 语句列表
        """
        exclude_schemas = schema_filter or self.config.exclude_schemas
        min_exec = min_executions or self.config.min_executions
        limit_count = limit or self.config.batch_size
        
        exclude_placeholders = ", ".join([f":schema_{i}" for i in range(len(exclude_schemas))])
        
        query = f"""
        SELECT 
            SQL_ID,
            SQL_TEXT,
            PLAN_HASH_VALUE,
            EXECUTIONS,
            ELAPSED_TIME,
            CPU_TIME,
            BUFFER_GETS,
            DISK_READS,
            ROWS_PROCESSED,
            PARSING_SCHEMA_NAME,
            MODULE,
            ACTION,
            FIRST_LOAD_TIME,
            LAST_LOAD_TIME,
            LAST_ACTIVE_TIME
        FROM V$SQL
        WHERE EXECUTIONS >= :min_executions
          AND PARSING_SCHEMA_NAME NOT IN ({exclude_placeholders})
          AND SQL_TEXT NOT LIKE '%V$%'
          AND SQL_TEXT NOT LIKE '%DBA_%'
        ORDER BY ELAPSED_TIME DESC
        FETCH FIRST :limit ROWS ONLY
        """
        
        params = {
            "min_executions": min_exec,
            "limit": limit_count,
        }
        for i, schema in enumerate(exclude_schemas):
            params[f"schema_{i}"] = schema
        
        statements: List[SQLStatement] = []
        
        try:
            async with self.connection_pool.acquire() as conn:
                cursor = await conn.execute(query, params)
                rows = await cursor.fetchall()
                
                for row in rows:
                    stmt = self._parse_sql_row(row)
                    if stmt is not None:
                        statements.append(stmt)
                
                logger.info(f"采集到 {len(statements)} 条 SQL 语句")
                
        except Exception as e:
            logger.error(f"采集 SQL 语句失败: {e}")
            raise
        
        return statements
    
    def _parse_sql_row(self, row: Any) -> Optional[SQLStatement]:
        """
        解析 SQL 语句行
        
        Args:
            row: 数据库行
        
        Returns:
            Optional[SQLStatement]: 解析后的 SQL 语句
        """
        try:
            return SQLStatement(
                sql_id=row[0] or "",
                sql_text=row[1] or "",
                plan_hash_value=row[2] or 0,
                executions=row[3] or 0,
                elapsed_time=float(row[4] or 0),
                cpu_time=float(row[5] or 0),
                buffer_gets=row[6] or 0,
                disk_reads=row[7] or 0,
                rows_processed=row[8] or 0,
                parsing_schema=row[9] or "",
                module=row[10],
                action=row[11],
                first_load_time=row[12],
                last_load_time=row[13],
                last_active_time=row[14],
                status=ExecutionStatus.SUCCESS,
            )
        except Exception as e:
            logger.warning(f"解析 SQL 语句行失败: {e}")
            return None
    
    async def collect_execution_plan(
        self,
        sql_id: str,
        plan_hash_value: Optional[int] = None,
    ) -> List[ExecutionPlan]:
        """
        采集执行计划
        
        Args:
            sql_id: SQL ID
            plan_hash_value: 计划哈希值（可选）
        
        Returns:
            List[ExecutionPlan]: 执行计划列表
        """
        if not self.config.collect_execution_plans:
            return []
        
        base_query = """
        SELECT 
            SQL_ID,
            PLAN_HASH_VALUE,
            OPERATION,
            OPTIONS,
            OBJECT_NAME,
            OBJECT_OWNER,
            OBJECT_TYPE,
            ID,
            PARENT_ID,
            DEPTH,
            POSITION,
            CARDINALITY,
            BYTES,
            COST,
            CPU_COST,
            IO_COST,
            TIME,
            PREDICATES,
            ACCESS_PREDICATES,
            FILTER_PREDICATES
        FROM V$SQL_PLAN
        WHERE SQL_ID = :sql_id
        """
        
        if plan_hash_value:
            base_query += " AND PLAN_HASH_VALUE = :plan_hash_value"
        
        base_query += " ORDER BY ID"
        
        params: Dict[str, Any] = {"sql_id": sql_id}
        if plan_hash_value:
            params["plan_hash_value"] = plan_hash_value
        
        plans: List[ExecutionPlan] = []
        
        try:
            async with self.connection_pool.acquire() as conn:
                cursor = await conn.execute(base_query, params)
                rows = await cursor.fetchall()
                
                for row in rows:
                    plan = self._parse_plan_row(row)
                    if plan is not None:
                        plans.append(plan)
                
                logger.debug(f"采集到 {len(plans)} 条执行计划记录")
                
        except Exception as e:
            logger.error(f"采集执行计划失败: {e}")
        
        return plans
    
    def _parse_plan_row(self, row: Any) -> Optional[ExecutionPlan]:
        """
        解析执行计划行
        
        Args:
            row: 数据库行
        
        Returns:
            Optional[ExecutionPlan]: 解析后的执行计划
        """
        try:
            return ExecutionPlan(
                sql_id=row[0] or "",
                plan_hash_value=row[1] or 0,
                operation=row[2] or "",
                options=row[3],
                object_name=row[4],
                object_owner=row[5],
                object_type=row[6],
                id=row[7] or 0,
                parent_id=row[8],
                depth=row[9] or 0,
                position=row[10] or 0,
                cardinality=row[11],
                bytes=row[12],
                cost=row[13],
                cpu_cost=row[14],
                io_cost=row[15],
                time=row[16],
                predicates=row[17],
                access_predicates=row[18],
                filter_predicates=row[19],
            )
        except Exception as e:
            logger.warning(f"解析执行计划行失败: {e}")
            return None
    
    async def collect_bind_variables(
        self,
        sql_id: str,
    ) -> List[BindVariable]:
        """
        采集绑定变量
        
        Args:
            sql_id: SQL ID
        
        Returns:
            List[BindVariable]: 绑定变量列表
        """
        if not self.config.collect_bind_variables:
            return []
        
        query = """
        SELECT 
            SQL_ID,
            CHILD_NUMBER,
            NAME,
            POSITION,
            DATATYPE,
            VALUE_STRING,
            VALUE_ANYDATA,
            MAX_LENGTH,
            PRECISION,
            SCALE
        FROM V$SQL_BIND_CAPTURE
        WHERE SQL_ID = :sql_id
        ORDER BY POSITION
        """
        
        binds: List[BindVariable] = []
        
        try:
            async with self.connection_pool.acquire() as conn:
                cursor = await conn.execute(query, {"sql_id": sql_id})
                rows = await cursor.fetchall()
                
                for row in rows:
                    bind = self._parse_bind_row(row)
                    if bind is not None:
                        binds.append(bind)
                
                logger.debug(f"采集到 {len(binds)} 个绑定变量")
                
        except Exception as e:
            logger.error(f"采集绑定变量失败: {e}")
        
        return binds
    
    def _parse_bind_row(self, row: Any) -> Optional[BindVariable]:
        """
        解析绑定变量行
        
        Args:
            row: 数据库行
        
        Returns:
            Optional[BindVariable]: 解析后的绑定变量
        """
        try:
            return BindVariable(
                sql_id=row[0] or "",
                child_number=row[1] or 0,
                name=row[2] or "",
                position=row[3] or 0,
                datatype=row[4] or "",
                value_string=row[5],
                value_anydata=row[6],
                max_length=row[7] or 0,
                precision=row[8],
                scale=row[9],
            )
        except Exception as e:
            logger.warning(f"解析绑定变量行失败: {e}")
            return None
    
    async def parse_lineage_from_sql(
        self,
        sql_text: str,
        sql_id: str,
        executions: int = 1,
        elapsed_time: float = 0.0,
        parsing_schema: str = "",
        last_active_time: Optional[datetime] = None,
    ) -> VSQLLineage:
        """
        从 SQL 文本解析血缘关系
        
        Args:
            sql_text: SQL 文本
            sql_id: SQL ID
            executions: 执行次数
            elapsed_time: 耗时
            parsing_schema: 解析模式
            last_active_time: 最后活跃时间
        
        Returns:
            VSQLLineage: 解析后的血缘信息
        """
        sql_upper = sql_text.upper().strip()
        
        operation_type = self._detect_operation_type(sql_upper)
        
        source_tables: List[str] = []
        target_tables: List[str] = []
        confidence = 0.5
        
        if operation_type == "SELECT":
            source_tables = self._extract_source_tables(sql_text)
            confidence = 0.7
            
        elif operation_type == "INSERT":
            target_tables = self._extract_target_table(sql_text, "INSERT")
            source_tables = self._extract_source_tables(sql_text)
            confidence = 0.85
            
        elif operation_type == "UPDATE":
            target_tables = self._extract_target_table(sql_text, "UPDATE")
            source_tables = self._extract_source_tables(sql_text)
            confidence = 0.8
            
        elif operation_type == "DELETE":
            target_tables = self._extract_target_table(sql_text, "DELETE")
            confidence = 0.75
            
        elif operation_type == "MERGE":
            target_tables = self._extract_target_table(sql_text, "MERGE")
            source_tables = self._extract_source_tables(sql_text)
            confidence = 0.9
        
        source_tables = list(dict.fromkeys(source_tables))
        target_tables = list(dict.fromkeys(target_tables))
        
        source_fields = self._extract_source_columns(sql_text, operation_type)
        target_fields = self._extract_target_columns(sql_text, operation_type)
        
        avg_elapsed = elapsed_time / executions if executions > 0 else 0.0
        
        return VSQLLineage(
            sql_id=sql_id,
            sql_text=sql_text,
            source_tables=source_tables,
            target_tables=target_tables,
            source_fields=source_fields,
            target_fields=target_fields,
            operation_type=operation_type,
            execution_count=executions,
            avg_elapsed_time=avg_elapsed,
            confidence=confidence,
            parsing_schema=parsing_schema,
            last_active_time=last_active_time,
        )
    
    def _detect_operation_type(self, sql_upper: str) -> str:
        """
        检测操作类型
        
        Args:
            sql_upper: 大写 SQL 文本
        
        Returns:
            str: 操作类型
        """
        if sql_upper.startswith("SELECT"):
            return "SELECT"
        elif sql_upper.startswith("INSERT"):
            return "INSERT"
        elif sql_upper.startswith("UPDATE"):
            return "UPDATE"
        elif sql_upper.startswith("DELETE"):
            return "DELETE"
        elif sql_upper.startswith("MERGE"):
            return "MERGE"
        elif sql_upper.startswith("CREATE"):
            return "CREATE"
        elif sql_upper.startswith("ALTER"):
            return "ALTER"
        elif sql_upper.startswith("DROP"):
            return "DROP"
        else:
            return "UNKNOWN"
    
    def _extract_source_tables(self, sql_text: str) -> List[str]:
        """
        提取源表名
        
        Args:
            sql_text: SQL 文本
        
        Returns:
            List[str]: 源表名列表
        """
        tables: List[str] = []
        
        from_matches = re.findall(
            r'\bFROM\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)',
            sql_text,
            re.IGNORECASE
        )
        tables.extend(from_matches)
        
        join_matches = re.findall(
            r'\bJOIN\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)',
            sql_text,
            re.IGNORECASE
        )
        tables.extend(join_matches)
        
        using_matches = re.findall(
            r'\bUSING\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)',
            sql_text,
            re.IGNORECASE
        )
        tables.extend(using_matches)
        
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
        
        patterns = {
            "INSERT": r'\bINSERT\s+INTO\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)',
            "UPDATE": r'\bUPDATE\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)',
            "DELETE": r'\bDELETE\s+FROM\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)',
            "MERGE": r'\bMERGE\s+INTO\s+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?)',
        }
        
        if operation in patterns:
            match = re.search(patterns[operation], sql_text, re.IGNORECASE)
            if match:
                tables.append(match.group(1))
        
        return tables
    
    def _extract_source_columns(self, sql_text: str, operation_type: str) -> List[str]:
        """
        提取源列名
        
        Args:
            sql_text: SQL 文本
            operation_type: 操作类型
        
        Returns:
            List[str]: 源列名列表
        """
        columns: List[str] = []
        
        select_match = re.search(
            r'\bSELECT\s+(.+?)\s+FROM',
            sql_text,
            re.IGNORECASE | re.DOTALL
        )
        if select_match:
            col_text = select_match.group(1)
            if "*" not in col_text:
                col_names = re.findall(r'\b([A-Za-z_][A-Za-z0-9_]*)\b', col_text)
                exclude_keywords = {
                    "SELECT", "FROM", "WHERE", "AND", "OR", "AS", "DISTINCT",
                    "ALL", "UNIQUE", "UNION", "INTERSECT", "MINUS", "EXCEPT",
                    "ORDER", "BY", "GROUP", "HAVING", "LIMIT", "OFFSET",
                    "JOIN", "INNER", "LEFT", "RIGHT", "OUTER", "FULL", "CROSS",
                    "ON", "IN", "NOT", "IS", "NULL", "LIKE", "BETWEEN", "EXISTS",
                    "CASE", "WHEN", "THEN", "ELSE", "END", "CAST", "CONVERT",
                    "COALESCE", "NULLIF", "NVL", "DECODE", "SUM", "COUNT", "AVG",
                    "MIN", "MAX", "ROUND", "TRUNC", "SUBSTR", "LENGTH", "UPPER",
                    "LOWER", "TRIM", "LPAD", "RPAD", "TO_CHAR", "TO_DATE", "TO_NUMBER",
                }
                columns.extend([c for c in col_names if c.upper() not in exclude_keywords])
        
        return list(dict.fromkeys(columns))
    
    def _extract_target_columns(self, sql_text: str, operation_type: str) -> List[str]:
        """
        提取目标列名
        
        Args:
            sql_text: SQL 文本
            operation_type: 操作类型
        
        Returns:
            List[str]: 目标列名列表
        """
        columns: List[str] = []
        
        if operation_type == "INSERT":
            insert_match = re.search(
                r'\bINSERT\s+INTO\s+[A-Za-z_][A-Za-z0-9_.]*\s*\(([^)]+)\)',
                sql_text,
                re.IGNORECASE
            )
            if insert_match:
                col_text = insert_match.group(1)
                col_names = re.findall(r'\b([A-Za-z_][A-Za-z0-9_]*)\b', col_text)
                columns.extend(col_names)
        
        elif operation_type == "UPDATE":
            set_match = re.search(
                r'\bSET\s+(.+?)\s+WHERE',
                sql_text,
                re.IGNORECASE | re.DOTALL
            )
            if set_match:
                col_text = set_match.group(1)
                col_names = re.findall(r'\b([A-Za-z_][A-Za-z0-9_]*)\s*=', col_text)
                columns.extend(col_names)
        
        return list(dict.fromkeys(columns))
    
    async def collect_and_parse(
        self,
        schema_filter: Optional[List[str]] = None,
        min_executions: Optional[int] = None,
        limit: Optional[int] = None,
    ) -> List[VSQLLineage]:
        """
        采集并解析 SQL 语句
        
        Args:
            schema_filter: 模式过滤列表
            min_executions: 最小执行次数
            limit: 返回数量限制
        
        Returns:
            List[VSQLLineage]: 解析后的血缘列表
        """
        statements = await self.collect_sql_statements(
            schema_filter=schema_filter,
            min_executions=min_executions,
            limit=limit,
        )
        
        lineages: List[VSQLLineage] = []
        
        for stmt in statements:
            lineage = await self.parse_lineage_from_sql(
                sql_text=stmt.sql_text,
                sql_id=stmt.sql_id,
                executions=stmt.executions,
                elapsed_time=stmt.elapsed_time,
                parsing_schema=stmt.parsing_schema,
                last_active_time=stmt.last_active_time,
            )
            lineages.append(lineage)
        
        logger.info(f"解析出 {len(lineages)} 条血缘关系")
        return lineages
    
    async def collect_full_lineage(
        self,
        sql_id: str,
    ) -> Dict[str, Any]:
        """
        采集完整血缘信息（包含执行计划和绑定变量）
        
        Args:
            sql_id: SQL ID
        
        Returns:
            Dict[str, Any]: 完整血缘信息
        """
        result: Dict[str, Any] = {
            "sql_id": sql_id,
            "statement": None,
            "execution_plan": [],
            "bind_variables": [],
            "lineage": None,
        }
        
        query = """
        SELECT 
            SQL_ID,
            SQL_TEXT,
            PLAN_HASH_VALUE,
            EXECUTIONS,
            ELAPSED_TIME,
            CPU_TIME,
            BUFFER_GETS,
            DISK_READS,
            ROWS_PROCESSED,
            PARSING_SCHEMA_NAME,
            MODULE,
            ACTION,
            FIRST_LOAD_TIME,
            LAST_LOAD_TIME,
            LAST_ACTIVE_TIME
        FROM V$SQL
        WHERE SQL_ID = :sql_id
        """
        
        try:
            async with self.connection_pool.acquire() as conn:
                cursor = await conn.execute(query, {"sql_id": sql_id})
                row = await cursor.fetchone()
                
                if row:
                    stmt = self._parse_sql_row(row)
                    result["statement"] = stmt
                    
                    if stmt:
                        execution_plans = await self.collect_execution_plan(
                            sql_id,
                            stmt.plan_hash_value,
                        )
                        result["execution_plan"] = execution_plans
                        
                        bind_variables = await self.collect_bind_variables(sql_id)
                        result["bind_variables"] = bind_variables
                        
                        lineage = await self.parse_lineage_from_sql(
                            sql_text=stmt.sql_text,
                            sql_id=stmt.sql_id,
                            executions=stmt.executions,
                            elapsed_time=stmt.elapsed_time,
                            parsing_schema=stmt.parsing_schema,
                            last_active_time=stmt.last_active_time,
                        )
                        result["lineage"] = lineage
                        
        except Exception as e:
            logger.error(f"采集完整血缘信息失败: {e}")
        
        return result
    
    async def get_sql_statistics(
        self,
        schema_filter: Optional[List[str]] = None,
    ) -> Dict[str, Any]:
        """
        获取 SQL 统计信息
        
        Args:
            schema_filter: 模式过滤列表
        
        Returns:
            Dict[str, Any]: 统计信息
        """
        exclude_schemas = schema_filter or self.config.exclude_schemas
        exclude_placeholders = ", ".join([f":schema_{i}" for i in range(len(exclude_schemas))])
        
        query = f"""
        SELECT 
            PARSING_SCHEMA_NAME,
            COUNT(*) as SQL_COUNT,
            SUM(EXECUTIONS) as TOTAL_EXECUTIONS,
            SUM(ELAPSED_TIME) as TOTAL_ELAPSED_TIME,
            SUM(CPU_TIME) as TOTAL_CPU_TIME,
            SUM(BUFFER_GETS) as TOTAL_BUFFER_GETS,
            SUM(DISK_READS) as TOTAL_DISK_READS
        FROM V$SQL
        WHERE PARSING_SCHEMA_NAME NOT IN ({exclude_placeholders})
        GROUP BY PARSING_SCHEMA_NAME
        ORDER BY TOTAL_ELAPSED_TIME DESC
        """
        
        params = {f"schema_{i}": schema for i, schema in enumerate(exclude_schemas)}
        
        stats: Dict[str, Any] = {
            "total_sql_count": 0,
            "total_executions": 0,
            "total_elapsed_time": 0.0,
            "by_schema": {},
        }
        
        try:
            async with self.connection_pool.acquire() as conn:
                cursor = await conn.execute(query, params)
                rows = await cursor.fetchall()
                
                for row in rows:
                    schema = row[0] or "UNKNOWN"
                    sql_count = row[1] or 0
                    total_executions = row[2] or 0
                    total_elapsed_time = float(row[3] or 0)
                    total_cpu_time = float(row[4] or 0)
                    total_buffer_gets = row[5] or 0
                    total_disk_reads = row[6] or 0
                    
                    stats["total_sql_count"] += sql_count
                    stats["total_executions"] += total_executions
                    stats["total_elapsed_time"] += total_elapsed_time
                    
                    stats["by_schema"][schema] = {
                        "sql_count": sql_count,
                        "total_executions": total_executions,
                        "total_elapsed_time": total_elapsed_time,
                        "total_cpu_time": total_cpu_time,
                        "total_buffer_gets": total_buffer_gets,
                        "total_disk_reads": total_disk_reads,
                    }
                    
        except Exception as e:
            logger.error(f"获取 SQL 统计失败: {e}")
        
        return stats
    
    async def start_continuous_collection(
        self,
        interval_seconds: int = 300,
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
        
        logger.info(f"启动 V$SQL 持续采集，间隔 {interval_seconds} 秒")
        
        collected_sql_ids: set = set()
        
        while self._is_running and not self._stop_event.is_set():
            try:
                statements = await self.collect_sql_statements(limit=self.config.batch_size)
                
                new_lineages: List[VSQLLineage] = []
                
                for stmt in statements:
                    if stmt.sql_id not in collected_sql_ids:
                        lineage = await self.parse_lineage_from_sql(
                            sql_text=stmt.sql_text,
                            sql_id=stmt.sql_id,
                            executions=stmt.executions,
                            elapsed_time=stmt.elapsed_time,
                            parsing_schema=stmt.parsing_schema,
                            last_active_time=stmt.last_active_time,
                        )
                        new_lineages.append(lineage)
                        collected_sql_ids.add(stmt.sql_id)
                
                if callback and new_lineages:
                    await callback(new_lineages)
                
                await asyncio.sleep(interval_seconds)
                
            except Exception as e:
                logger.error(f"持续采集出错: {e}")
                await asyncio.sleep(self.config.retry_delay)
    
    def stop_continuous_collection(self) -> None:
        """停止持续采集"""
        self._is_running = False
        self._stop_event.set()
        logger.info("停止 V$SQL 持续采集")