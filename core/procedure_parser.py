"""
存储过程增强型解析器
从 .prc 文件中提取字段级数据血缘关系，支持多步 INSERT / MERGE / UPDATE 检测、
TMP 表链路追踪、UNION ALL、步骤级追踪与置信度评分。
"""

from __future__ import annotations

import logging
import re
from dataclasses import dataclass
from pathlib import Path

from core.caliber_extractor import CaliberExtractor
from core.field_cleaner import FieldCleaner
from core.models import (
    CaliberInfo,
    FieldMapping,
    ProcedureInfo,
    TableInfo,
    TableLineage,
)

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# 内部数据结构：单条 SQL 操作的解析结果
# ---------------------------------------------------------------------------
@dataclass
class SQLOperation:
    """存储过程中的一条 DML 操作（INSERT / MERGE / UPDATE）"""

    op_type: str  # 'insert' | 'merge' | 'update'
    target_table: str
    sql_block: str
    step_num: int = 0
    step_desc: str = ""
    raw_text: str = ""
    # 批次A新增：行号定位字段（向后兼容，带默认值）
    start_line: int = 0  # SQL操作在文件中的起始行号（1-based）
    end_line: int = 0  # SQL操作在文件中的结束行号（1-based）
    file_path: str = ""  # 来源.prc文件路径


# ---------------------------------------------------------------------------
# 常量：无效表名前缀（用于过滤误匹配）
# ---------------------------------------------------------------------------
_INVALID_TABLE_PREFIXES: tuple[str, ...] = (
    "DUAL",
    "ETL_",
    "FUN_",
    "SQL",
    "ALTER",
    "EXECUTE",
    "COMMIT",
    "ROLLBACK",
)

# 常量：临时表识别模式后缀
_TEMP_TABLE_SUFFIXES: tuple[str, ...] = ("TMP", "_TMP", "TEMP", "_TEMP")

# 正则：INSERT INTO ... (cols) SELECT ... FROM / UNION / ;
# 分组说明：
#   group(1) → 目标表名（可能含 schema）
#   group(2) → 目标字段列表（括号内逗号分隔）
#   group(3) → SELECT 子句内容（到 FROM / UNION / ; 为止）
#   group(4) → FROM 子句及后续内容（用于别名解析）
# 支持 Oracle hint 格式: INSERT /*+hint*/ INTO ...
# 支持 NOLOGGING 关键字: INSERT INTO table NOLOGGING (cols) SELECT ...
_INSERT_INTO_PATTERN = re.compile(
    r"INSERT\s+(?:/\*.*?\*/\s*)?INTO\s+([\w.]+)(?:\s+NOLOGGING)?\s*\((.*?)\)\s*SELECT\s*(.*?)(?:\bFROM\b)(.*?)(?:\bUNION\b|;|$)",
    re.IGNORECASE | re.DOTALL,
)

# 正则：MERGE INTO t USING s ON (...) WHEN MATCHED THEN ... WHEN NOT MATCHED THEN ...
_MERGE_INTO_PATTERN = re.compile(
    r"MERGE\s+INTO\s+([\w.]+)\s+USING\s+([\w.]+(?:\s+\w+)?)\s+ON\s*\(.*?\)"
    r"\s*WHEN\s+MATCHED\s+THEN\s+UPDATE\s+SET\s*(.*?)"
    r"\s*WHEN\s+NOT\s+MATCHED\s+THEN\s+INSERT\s*\((.*?)\)\s*VALUES\s*\((.*?)\)",
    re.IGNORECASE | re.DOTALL,
)

# 正则：UPDATE t SET col1=expr1, col2=expr2 [FROM src]
_UPDATE_SET_PATTERN = re.compile(
    r"UPDATE\s+([\w.]+)\s+SET\s*(.*?)(?:\s*FROM\s+[\w.]+|\s*WHERE\s|;|$)",
    re.IGNORECASE | re.DOTALL,
)

# 正则：V_STEP 赋值语句，用于步骤级追踪
_STEP_ASSIGN_PATTERN = re.compile(r"V_STEP\s*[:=]\s*(\d+)", re.IGNORECASE)

# 正则：V_STEP_DESC 赋值语句
_STEP_DESC_PATTERN = re.compile(r"V_STEP_DESC\s*[:=]\s*'([^']*)'", re.IGNORECASE)


class EnhancedProcedureParser:
    """存储过程增强型解析器。

    相比原版 ProcedureParser 的关键增强点：
      - 全局查找所有 INSERT / MERGE / UPDATE 操作（支持 20+ 条 INSERT）
      - TMP/_TEMP 后缀临时表自动识别与内部依赖检测
      - MERGE INTO 完整语法解析（MATCHED/NOT MATCHED 两分支）
      - UPDATE SET 字段映射提取
      - 字段名清洗：去注释、去函数包裹、处理 CASE WHEN / DECODE / 子查询
      - UNION ALL 多来源合并场景
      - 按 V_STEP 分组记录每步操作及描述
      - 每条 FieldMapping 附带 confidence 置信度评分 (0.0~1.0)
    """

    def __init__(self, tables: dict[str, TableInfo]) -> None:
        self.tables: dict[str, TableInfo] = tables
        # ★ 优化：缓存最近解析的 operations + content，避免 extract_caliber_from_proc 重复读取
        self._last_parse_cache: dict[str, tuple[str, list[SQLOperation]]] = {}

    # ===================================================================
    # 公开接口
    # ===================================================================

    def parse_prc_file(self, file_path: str) -> ProcedureInfo | None:
        """解析单个 .prc 文件，返回 ProcedureInfo 或 None。"""
        try:
            with open(file_path, encoding="utf-8", errors="ignore") as fh:
                content = fh.read()
        except OSError as e:
            logger.error("读取文件失败: %s, 错误: %s", file_path, e)
            return None

        proc_info = self._parse_header(content, file_path)
        if proc_info is None:
            logger.warning("文件头部解析失败，跳过: %s", file_path)
            return None

        proc_info.file_path = file_path

        # 提取所有 SQL 操作（核心增强点：全局查找而非仅第一个）
        operations = self._extract_all_sql_operations(content, proc_info)

        # A3：将文件路径传递到每个 SQLOperation
        for op in operations:
            op.file_path = file_path
        logger.info(
            "[%s] 共检测到 %d 条 SQL 操作 (insert/merge/update)",
            proc_info.full_name,
            len(operations),
        )

        # 从操作列表中逐条提取字段映射
        all_mappings: list[FieldMapping] = []
        for op in operations:
            if op.op_type == "insert":
                all_mappings.extend(self._extract_insert_mappings(op, proc_info))
            elif op.op_type == "merge":
                all_mappings.extend(self._extract_merge_mappings(op, proc_info))
            elif op.op_type == "update":
                all_mappings.extend(self._extract_update_mappings(op, proc_info))

        proc_info.field_mappings = all_mappings

        # 表级信息
        proc_info.source_tables = self._extract_source_tables(content)
        proc_info.target_tables = self._extract_target_tables(content)
        proc_info.temp_tables = self._detect_temp_tables(content, proc_info)

        # TMP 表内部依赖（先 INSERT 到 TMP，后续 FROM TMP SELECT）
        internal_deps = self._detect_internal_dependencies(operations, proc_info)

        # 构建表级血缘（含外部 + 内部依赖）
        proc_info.table_lineages = self._build_table_lineages(proc_info, internal_deps)

        # ★ 优化：缓存 operations 和 content，避免 extract_caliber_from_proc 重复读取和解析
        self._last_parse_cache[proc_info.full_name] = (content, operations)

        logger.info(
            "[%s] 解析完成: %d 条字段映射, %d 个源表, %d 个目标表, %d 个临时表",
            proc_info.full_name,
            len(all_mappings),
            len(proc_info.source_tables),
            len(proc_info.target_tables),
            len(proc_info.temp_tables),
        )
        return proc_info

    def parse_directory(self, directory: str) -> dict[str, ProcedureInfo]:
        """递归解析目录下所有 .prc 文件，返回 {full_name: ProcedureInfo}。"""
        results: dict[str, ProcedureInfo] = {}
        prc_dir = Path(directory)
        if not prc_dir.is_dir():
            logger.error("目录不存在或不是目录: %s", directory)
            return results

        # ★ 优化：收集所有文件后并行解析
        prc_files = sorted(prc_dir.rglob("*.prc"))
        if not prc_files:
            return results

        import threading
        from concurrent.futures import ThreadPoolExecutor

        results_lock = threading.Lock()

        def _parse_and_collect(fp: Path):
            proc_info = self.parse_prc_file(str(fp))
            if proc_info is not None:
                with results_lock:
                    results[proc_info.full_name] = proc_info

        with ThreadPoolExecutor(max_workers=4) as executor:
            executor.map(_parse_and_collect, prc_files)

        logger.info("目录扫描完成: %s, 共解析 %d 个存储过程", directory, len(results))
        return results

    # ===================================================================
    # 口径提取接口（新增，不影响现有方法）
    # ===================================================================

    def parse_prc_file_with_caliber(
        self, file_path: str, data_source: str = "oracle"
    ) -> tuple[ProcedureInfo | None, list[CaliberInfo]]:
        """解析单个 .prc 文件，同时返回 ProcedureInfo 和口径信息列表。

        与 parse_prc_file 不同的地方：
          - 返回值从单个 ProcedureInfo 变为 (ProcedureInfo, list[CaliberInfo])
          - 口径信息在字段映射提取的同时产出，不重复扫描文件
        """
        proc_info = self.parse_prc_file(file_path)
        if proc_info is None:
            return None, []

        caliber_infos = self.extract_caliber_from_proc(proc_info, data_source)
        return proc_info, caliber_infos

    def extract_caliber_from_proc(self, proc_info: ProcedureInfo, data_source: str = "oracle") -> list[CaliberInfo]:
        """从已解析的 ProcedureInfo 中提取口径信息。

        基于 proc_info.field_mappings 和原始文件内容中的 SQL 操作块，
        利用 CaliberExtractor 提取 WHERE/JOIN/GROUP BY 条件。

        ★ 优化：优先使用缓存中的 content/operations，避免重复读取文件和重新解析。
        """
        if not proc_info.field_mappings or not proc_info.file_path:
            return []

        # ★ 优先使用缓存
        cached = self._last_parse_cache.get(proc_info.full_name)
        if cached is not None:
            content, operations = cached
        else:
            # 回退：缓存未命中时重新读取
            try:
                with open(proc_info.file_path, encoding="utf-8", errors="ignore") as fh:
                    content = fh.read()
            except OSError:
                logger.warning("无法重新读取文件以提取口径: %s", proc_info.file_path)
                return []

            operations = self._extract_all_sql_operations(content, proc_info)

        op_by_target: dict[str, list[SQLOperation]] = {}
        op_by_step: dict[int, SQLOperation] = {}
        for op in operations:
            if op.step_num > 0:
                op_by_step[op.step_num] = op
            op_target = op.target_table.upper().split(".")[-1] if op.target_table else ""
            if op_target:
                op_by_target.setdefault(op_target, []).append(op)

        step_to_mappings: dict[int, list[FieldMapping]] = {}
        target_to_mappings: dict[str, list[FieldMapping]] = {}
        unmapped: list[FieldMapping] = []

        for fm in proc_info.field_mappings:
            step_num = self._find_mapping_step(fm, operations)
            fm_target = fm.target_table.upper().split(".")[-1] if fm.target_table else ""

            if step_num > 0:
                step_to_mappings.setdefault(step_num, []).append(fm)
            elif fm_target:
                target_to_mappings.setdefault(fm_target, []).append(fm)
            else:
                unmapped.append(fm)

        caliber_infos: list[CaliberInfo] = []

        for step_num, mappings in step_to_mappings.items():
            op = op_by_step.get(step_num)
            sql_block = op.sql_block if op else ""
            step_desc = op.step_desc if op else ""
            fp = op.file_path if op else ""
            sl = op.start_line if op else 0
            el = op.end_line if op else 0

            batch = CaliberExtractor.build_caliber_infos(
                mappings=mappings,
                sql_block=sql_block,
                procedure=proc_info.full_name,
                step_num=step_num,
                step_desc=step_desc,
                data_source=data_source,
                file_path=fp,
                start_line=sl,
                end_line=el,
            )
            caliber_infos.extend(batch)

        for fm_target, mappings in target_to_mappings.items():
            ops = op_by_target.get(fm_target, [])
            for op in ops:
                batch = CaliberExtractor.build_caliber_infos(
                    mappings=mappings,
                    sql_block=op.sql_block,
                    procedure=proc_info.full_name,
                    step_num=op.step_num if op.step_num > 0 else 0,
                    step_desc=op.step_desc if op.step_desc else "",
                    data_source=data_source,
                    file_path=op.file_path,
                    start_line=op.start_line,
                    end_line=op.end_line,
                )
                caliber_infos.extend(batch)
            if not ops:
                for fm in mappings:
                    caliber_infos.append(
                        CaliberExtractor.build_caliber_info(
                            field_mapping=fm,
                            sql_block="",
                            procedure=proc_info.full_name,
                            data_source=data_source,
                        )
                    )

        for fm in unmapped:
            caliber_infos.append(
                CaliberExtractor.build_caliber_info(
                    field_mapping=fm,
                    sql_block=content if len(operations) <= 1 else "",
                    procedure=proc_info.full_name,
                    data_source=data_source,
                )
            )

        logger.info(
            "[%s] 口径提取完成: %d 条口径信息",
            proc_info.full_name,
            len(caliber_infos),
        )
        return caliber_infos

    def _find_mapping_step(self, fm: FieldMapping, operations: list[SQLOperation]) -> int:
        """根据 FieldMapping 的目标表匹配其所属步骤编号。"""
        fm_target = fm.target_table.upper().split(".")[-1] if fm.target_table else ""
        for op in operations:
            if op.step_num > 0:
                op_target = op.target_table.upper().split(".")[-1] if op.target_table else ""
                if fm_target and op_target and fm_target == op_target:
                    return op.step_num
        for op in operations:
            if op.step_num > 0:
                return op.step_num
        return 0

    # ===================================================================
    # 头部解析
    # ===================================================================

    def _parse_header(self, content: str, file_path: str) -> ProcedureInfo | None:
        """从 CREATE OR REPLACE PROCEDURE 语句中提取 schema / name / description。"""
        header_match = re.search(
            r"CREATE\s+(?:OR\s+REPLACE\s+)?PROCEDURE\s+([\w.]+)",
            content,
            re.IGNORECASE,
        )
        if not header_match:
            return None

        full_name = header_match.group(1).strip().upper()
        parts = full_name.split(".")
        schema: str = parts[0] if len(parts) == 2 else "UNKNOWN"
        proc_name: str = parts[-1]

        description = ""
        desc_match = re.search(r"功能描述[::\s]*[：:]\s*([^\n*]+)", content)
        if desc_match:
            description = desc_match.group(1).strip()

        return ProcedureInfo(
            schema=schema,
            proc_name=proc_name,
            full_name=full_name,
            description=description,
        )

    # ===================================================================
    # SQL 操作提取（核心：全局查找所有 INSERT / MERGE / UPDATE）
    # ===================================================================

    def _extract_all_sql_operations(self, content: str, proc_info: ProcedureInfo) -> list[SQLOperation]:
        """从存储过程正文中提取所有 DML 操作，并关联 V_STEP 信息。

        Returns:
            按 V_STEP 排序的操作列表，每个元素包含 op_type / target_table /
            sql_block / step_num / step_desc。

        增强点：sql_block 会自动向前扩展包含 WITH/CTE 子句（如果存在），
        使得 CaliberExtractor 能够提取 CTE 定义信息。
        """
        operations: list[SQLOperation] = []

        # ---- INSERT INTO ----
        for match in _INSERT_INTO_PATTERN.finditer(content):
            target_table = match.group(1).strip().upper()
            if not self._is_valid_table(target_table):
                continue

            raw_block = match.group(0)
            # 尝试向前扩展 WITH/CTE 子句
            extended_block, ext_start = self._extend_with_cte(content, match.start(), raw_block)
            step_num, step_desc = self._find_step_context(match.start(), content)
            start_line = content[:ext_start].count("\n") + 1
            end_line = content[: match.end()].count("\n") + 1

            operations.append(
                SQLOperation(
                    op_type="insert",
                    target_table=target_table,
                    sql_block=extended_block,
                    step_num=step_num,
                    step_desc=step_desc,
                    raw_text=extended_block,
                    start_line=start_line,
                    end_line=end_line,
                )
            )

        # ---- MERGE INTO ----
        for match in _MERGE_INTO_PATTERN.finditer(content):
            target_table = match.group(1).strip().upper()
            if not self._is_valid_table(target_table):
                continue

            raw_block = match.group(0)
            extended_block, ext_start = self._extend_with_cte(content, match.start(), raw_block)
            step_num, step_desc = self._find_step_context(match.start(), content)
            start_line = content[:ext_start].count("\n") + 1
            end_line = content[: match.end()].count("\n") + 1

            operations.append(
                SQLOperation(
                    op_type="merge",
                    target_table=target_table,
                    sql_block=extended_block,
                    step_num=step_num,
                    step_desc=step_desc,
                    raw_text=extended_block,
                    start_line=start_line,
                    end_line=end_line,
                )
            )

        # ---- UPDATE SET ----
        for match in _UPDATE_SET_PATTERN.finditer(content):
            target_table = match.group(1).strip().upper()
            if not self._is_valid_table(target_table):
                continue

            raw_block = match.group(0)
            extended_block, ext_start = self._extend_with_cte(content, match.start(), raw_block)
            step_num, step_desc = self._find_step_context(match.start(), content)
            start_line = content[:ext_start].count("\n") + 1
            end_line = content[: match.end()].count("\n") + 1

            operations.append(
                SQLOperation(
                    op_type="update",
                    target_table=target_table,
                    sql_block=extended_block,
                    step_num=step_num,
                    step_desc=step_desc,
                    raw_text=extended_block,
                    start_line=start_line,
                    end_line=end_line,
                )
            )

        # 按 step_num 排序（未识别到 step 的排最后）
        operations.sort(key=lambda op: op.step_num if op.step_num > 0 else 9999)
        return operations

    def _extend_with_cte(self, content: str, dml_start: int, raw_block: str) -> tuple[str, int]:
        """向前扩展 sql_block 以包含 WITH/CTE 子句。

        Oracle CTE 语法：WITH alias AS (subquery) [, alias2 AS (subquery2)] INSERT INTO ...

        策略：
          1. 在 DML 关键字之前查找独立的 WITH 关键字
          2. 从 WITH 开始截取到 DML 关键字之前，拼接到 raw_block 前面
          3. 处理嵌套括号以确保 CTE 完整

        Args:
            content: 存储过程完整文本
            dml_start: DML 语句（INSERT/MERGE/UPDATE）在 content 中的起始位置
            raw_block: 原始匹配的 SQL 块

        Returns:
            (extended_sql_block, extended_start_position)
        """
        # 在 DML 关键字前的文本中查找 WITH
        prefix_region = content[:dml_start]

        # 找到最后一个独立的 WITH 关键字（不是子查询内部的 WITH）
        # 使用反向搜索策略：从 dml_start 位置向前查找
        with_match = None
        for m in re.finditer(r"\bWITH\b", prefix_region, re.IGNORECASE):
            # 检查这个 WITH 是否独立（前面不是字母/数字/下划线/点号）
            pos = m.start()
            if pos > 0 and content[pos - 1].isalnum():
                continue
            with_match = m

        if with_match is None:
            return raw_block, dml_start

        # 从 WITH 到 DML 起始位置之间的文本
        cte_prefix = content[with_match.start() : dml_start]

        # 验证：这段文本和 DML 语句之间不应有其他完整的 SQL 语句
        # （如另一个 INSERT/UPDATE/DELETE/MERGE/COMMIT/ROLLBACK）
        intervening_dml = re.search(
            r"\b(?:INSERT\s|UPDATE\s|DELETE\s|MERGE\s|COMMIT|ROLLBACK)",
            cte_prefix,
            re.IGNORECASE,
        )
        if intervening_dml:
            # WITH 属于更前面的语句，不属于当前 DML
            return raw_block, dml_start

        # 拼接完整的 sql_block
        extended_block = cte_prefix + raw_block
        return extended_block, with_match.start()

    # ===================================================================
    # 步骤上下文定位
    # ===================================================================

    def _find_step_context(self, position: int, content: str) -> tuple[int, str]:
        """根据 SQL 语句在正文中的位置，向前搜索最近的 V_STEP / V_STEP_DESC 赋值。

        Args:
            position: 当前 SQL 语句起始字符偏移
            content:  存储过程完整文本

        Returns:
            (step_num, step_desc)
        """
        search_region = content[:position]
        step_matches = list(_STEP_ASSIGN_PATTERN.finditer(search_region))
        desc_matches = list(_STEP_DESC_PATTERN.finditer(search_region))

        step_num: int = 0
        step_desc: str = ""

        if step_matches:
            try:
                step_num = int(step_matches[-1].group(1))
            except ValueError:
                step_num = 0

        if desc_matches:
            step_desc = desc_matches[-1].group(1).strip()

        return step_num, step_desc

    # ===================================================================
    # INSERT 字段映射提取
    # ===================================================================

    def _parse_from_aliases(self, sql_block: str) -> dict[str, str]:
        """解析 FROM 子句中的表别名映射。

        返回 {alias: real_table} 字典，例如 {'A': 'RRP_EAST.M_CUST_IND_INFO_EAST'}
        """
        aliases: dict[str, str] = {}

        # 匹配 FROM table_name alias 或 FROM table_name AS alias
        # 支持 schema.table 格式
        patterns = [
            r"\bFROM\s+([\w.]+)\s+AS\s+(\w+)\b",
            r"\bFROM\s+([\w.]+)\s+(\w+)\b",
            r"\bJOIN\s+([\w.]+)\s+AS\s+(\w+)\b",
            r"\bJOIN\s+([\w.]+)\s+(\w+)\b",
            r"\bLEFT\s+JOIN\s+([\w.]+)\s+AS\s+(\w+)\b",
            r"\bLEFT\s+JOIN\s+([\w.]+)\s+(\w+)\b",
            r"\bRIGHT\s+JOIN\s+([\w.]+)\s+AS\s+(\w+)\b",
            r"\bRIGHT\s+JOIN\s+([\w.]+)\s+(\w+)\b",
            r"\bINNER\s+JOIN\s+([\w.]+)\s+AS\s+(\w+)\b",
            r"\bINNER\s+JOIN\s+([\w.]+)\s+(\w+)\b",
        ]

        for pattern in patterns:
            for match in re.finditer(pattern, sql_block, re.IGNORECASE):
                table_name = match.group(1).upper()
                alias_name = match.group(2).upper()
                # 排除关键字（如 ON, AND, WHERE, SET 等）
                if alias_name not in (
                    "ON",
                    "AND",
                    "WHERE",
                    "SET",
                    "SELECT",
                    "INSERT",
                    "UPDATE",
                    "DELETE",
                    "FROM",
                    "JOIN",
                    "LEFT",
                    "RIGHT",
                    "INNER",
                    "OUTER",
                    "FULL",
                    "CROSS",
                    "USING",
                    "GROUP",
                    "ORDER",
                    "HAVING",
                    "LIMIT",
                    "OFFSET",
                    "UNION",
                    "EXCEPT",
                    "INTERSECT",
                    "CASE",
                    "WHEN",
                    "THEN",
                    "ELSE",
                    "END",
                    "AS",
                    "IS",
                    "NOT",
                    "NULL",
                    "TRUE",
                    "FALSE",
                    "LIKE",
                    "IN",
                    "EXISTS",
                    "BETWEEN",
                    "OR",
                    "XOR",
                ):
                    aliases[alias_name] = table_name

        return aliases

    def _extract_insert_mappings(self, operation: SQLOperation, proc_info: ProcedureInfo) -> list[FieldMapping]:
        """从一条 INSERT INTO ... SELECT 语句中提取字段级映射。

        支持以下场景：
          - 标准 INSERT INTO t(a,b) SELECT x,y FROM s
          - 含 UNION ALL 的多来源合并
          - 目标字段列表带行内注释 -- xxx
          - 表别名映射：SELECT A.col FROM table A
        """
        mappings: list[FieldMapping] = []

        match = _INSERT_INTO_PATTERN.search(operation.sql_block)
        if not match:
            return mappings

        target_table = match.group(1).strip().upper()
        target_cols_raw = match.group(2)
        select_part = match.group(3)
        from_part = match.group(4) if len(match.groups()) >= 4 else ""

        # 解析 FROM 子句中的别名映射（需要包含 FROM 关键字）
        full_from_clause = "FROM " + from_part if from_part else ""
        alias_map = self._parse_from_aliases(full_from_clause)

        # 从 FROM 子句中提取第一个裸表名（无别名时作为 source_table 的兜底）
        from_default_table = ""
        if from_part:
            from_table_match = re.match(r"\s*([\w]+(?:\.[\w]+)+)\b", from_part.strip())
            if from_table_match:
                from_default_table = from_table_match.group(1).upper()

        # 清洗目标字段列表（去除行内注释和空白）
        target_columns = FieldCleaner.split_target_columns(target_cols_raw)
        if not target_columns:
            return mappings

        # 解析 SELECT 字段列表（考虑 UNION ALL 场景）
        select_column_infos = FieldCleaner.parse_select_columns(select_part)

        # 逐对构建映射
        for i, target_col in enumerate(target_columns):
            target_col_clean = FieldCleaner.clean_column_name(target_col)
            if not target_col_clean:
                continue

            if i < len(select_column_infos):
                src_info = select_column_infos[i]
                source_table = src_info.get("table", "")
                source_column = src_info.get("column", "")
                transform = src_info.get("transform", "")
                confidence = src_info.get("confidence", 0.5)

                # 将别名替换为真实表名
                if source_table and source_table in alias_map:
                    source_table = alias_map[source_table]

                # 兜底：SELECT 列无表前缀（如 CUST_NAME）且 FROM 只有一张表时，
                # 自动补全 source_table（解决外部视图/单表直传场景）
                if not source_table and source_column and from_default_table:
                    source_table = from_default_table
                    confidence = 0.8
            else:
                source_table = ""
                source_column = ""
                transform = select_part.strip()[:200]
                confidence = 0.3

            mappings.append(
                FieldMapping(
                    source_schema="",
                    source_table=source_table.upper(),
                    source_column=source_column.upper(),
                    target_schema=proc_info.schema,
                    target_table=self._normalize_table_name(target_table),
                    target_column=target_col_clean.upper(),
                    transform_logic=transform,
                    procedure=proc_info.full_name,
                    confidence=confidence,
                )
            )

        logger.debug(
            "  [INSERT→%s] step=%d 提取 %d 条字段映射, desc=%s",
            target_table,
            operation.step_num,
            len(mappings),
            operation.step_desc or "(无)",
        )
        return mappings

    # ===================================================================
    # MERGE 字段映射提取
    # ===================================================================

    def _extract_merge_mappings(self, operation: SQLOperation, proc_info: ProcedureInfo) -> list[FieldMapping]:
        """从 MERGE INTO ... USING ... ON ... WHEN MATCHED ... WHEN NOT MATCHED 中提取映射。

        返回两条分支的字段映射：
          - MATCHED 分支：UPDATE SET col = expr
          - NOT MATCHED 分支：INSERT (cols) VALUES (vals)
        """
        mappings: list[FieldMapping] = []

        match = _MERGE_INTO_PATTERN.search(operation.sql_block)
        if not match:
            return mappings

        target_table = match.group(1).strip().upper()
        source_table_raw = match.group(2).strip().upper()
        update_set_str = match.group(3)
        insert_cols_str = match.group(4)
        insert_vals_str = match.group(5)

        # USING 后面可能带别名，如 "RRP_EAST.SRC S"
        source_table = source_table_raw.split()[0] if source_table_raw else ""

        # --- WHEN NOT MATCHED: INSERT (cols) VALUES (vals) ---
        insert_cols = FieldCleaner.split_target_columns(insert_cols_str)
        insert_vals = FieldCleaner.split_target_columns(insert_vals_str)
        for i, tgt_col in enumerate(insert_cols):
            tgt_clean = FieldCleaner.clean_column_name(tgt_col)
            if not tgt_clean:
                continue
            val_expr = insert_vals[i] if i < len(insert_vals) else ""
            val_clean = FieldCleaner.clean_column_name(val_expr)
            src_tbl, src_col = FieldCleaner.resolve_source_from_expr(val_clean, source_table)

            mappings.append(
                FieldMapping(
                    source_schema="",
                    source_table=src_tbl,
                    source_column=src_col,
                    target_schema=proc_info.schema,
                    target_table=self._normalize_table_name(target_table),
                    target_column=tgt_clean.upper(),
                    transform_logic=val_expr,
                    procedure=proc_info.full_name,
                    confidence=0.85 if src_col else 0.6,
                )
            )

        # --- WHEN MATCHED: UPDATE SET col1=expr1, col2=expr2 ---
        update_pairs = FieldCleaner.parse_update_set_pairs(update_set_str)
        for tgt_col, expr in update_pairs:
            tgt_clean = FieldCleaner.clean_column_name(tgt_col)
            if not tgt_clean:
                continue
            expr_clean = FieldCleaner.clean_column_name(expr)
            src_tbl, src_col = FieldCleaner.resolve_source_from_expr(expr_clean, source_table)

            mappings.append(
                FieldMapping(
                    source_schema="",
                    source_table=src_tbl,
                    source_column=src_col,
                    target_schema=proc_info.schema,
                    target_table=self._normalize_table_name(target_table),
                    target_column=tgt_clean.upper(),
                    transform_logic=expr,
                    procedure=proc_info.full_name,
                    confidence=0.8 if src_col else 0.5,
                )
            )

        logger.debug(
            "  [MERGE→%s] step=%d 提取 %d 条字段映射, desc=%s",
            target_table,
            operation.step_num,
            len(mappings),
            operation.step_desc or "(无)",
        )
        return mappings

    # ===================================================================
    # UPDATE 字段映射提取
    # ===================================================================

    def _extract_update_mappings(self, operation: SQLOperation, proc_info: ProcedureInfo) -> list[FieldMapping]:
        """从 UPDATE t SET col1=expr1, col2=expr2 中提取字段映射。"""
        mappings: list[FieldMapping] = []

        match = _UPDATE_SET_PATTERN.search(operation.sql_block)
        if not match:
            return mappings

        target_table = match.group(1).strip().upper()
        set_clause = match.group(2)

        update_pairs = FieldCleaner.parse_update_set_pairs(set_clause)
        for tgt_col, expr in update_pairs:
            tgt_clean = FieldCleaner.clean_column_name(tgt_col)
            if not tgt_clean:
                continue
            expr_clean = FieldCleaner.clean_column_name(expr)
            src_tbl, src_col = FieldCleaner.resolve_source_from_expr(expr_clean, "")

            mappings.append(
                FieldMapping(
                    source_schema="",
                    source_table=src_tbl,
                    source_column=src_col,
                    target_schema=proc_info.schema,
                    target_table=self._normalize_table_name(target_table),
                    target_column=tgt_clean.upper(),
                    transform_logic=expr,
                    procedure=proc_info.full_name,
                    confidence=0.8 if src_col else 0.5,
                )
            )

        logger.debug(
            "  [UPDATE→%s] step=%d 提取 %d 条字段映射, desc=%s",
            target_table,
            operation.step_num,
            len(mappings),
            operation.step_desc or "(无)",
        )
        return mappings

    # ===================================================================
    # 临时表检测
    # ===================================================================

    def _detect_temp_tables(self, content: str, proc_info: ProcedureInfo) -> list[str]:
        """识别存储过程中的临时表（名称以 TMP / _TMP / TEMP / _TEMP 结尾）。

        同时检查 TRUNCATE TABLE 和 INSERT INTO 中出现的表名。
        """
        temp_set: set[str] = set()

        # 方式一：从 INSERT/MERGE/TRUNCATE 的目标表中筛选
        all_table_patterns = [
            r"INSERT\s+INTO\s+([\w.]+)",
            r"TRUNCATE\s+TABLE\s+([\w.]+)",
            r"MERGE\s+INTO\s+([\w.]+)",
        ]
        for pattern_str in all_table_patterns:
            for m in re.finditer(pattern_str, content, re.IGNORECASE):
                tbl = m.group(1).strip().upper()
                if self._is_temp_table(tbl):
                    temp_set.add(tbl)

        # 方式二：从 FROM 子句中也筛一遍（有些地方直接 FROM TMP 表查询）
        for m in re.finditer(r"\bFROM\s+([\w.]+)", content, re.IGNORECASE):
            tbl = m.group(1).strip().upper()
            if self._is_temp_table(tbl):
                temp_set.add(tbl)

        result = sorted(temp_set)
        if result:
            logger.info("[%s] 检测到临时表: %s", proc_info.full_name, ", ".join(result))
        return result

    def _is_temp_table(self, table_name: str) -> bool:
        """判断表名是否为临时表（基于命名约定）。"""
        name_upper = table_name.upper()
        return any(name_upper.endswith(suffix) for suffix in _TEMP_TABLE_SUFFIXES)

    # ===================================================================
    # TMP 表内部依赖检测
    # ===================================================================

    def _detect_internal_dependencies(
        self, operations: list[SQLOperation], proc_info: ProcedureInfo
    ) -> list[TableLineage]:
        """在同一存储过程中检测 TMP 表的内部数据流向。

        规则：如果第 N 步 INSERT 到 TMP 表，第 M 步（M > N）FROM 该 TMP 表 SELECT，
        则建立一条 TableLineage 表示内部依赖。
        """
        internal_lineages: list[TableLineage] = []

        # 记录每个 TMP 表被写入的位置（最早写入步骤）
        tmp_write_steps: dict[str, int] = {}
        for op in operations:
            if self._is_temp_table(op.target_table):
                prev_step = tmp_write_steps.get(op.target_table, 9999)
                if op.step_num > 0 and op.step_num < prev_step:
                    tmp_write_steps[op.target_table] = op.step_num

        # 检查后续操作是否从这些 TMP 表读取
        for op in operations:
            for tmp_table, write_step in tmp_write_steps.items():
                if op.step_num <= write_step:
                    continue
                if tmp_table.lower() in op.sql_block.lower():
                    from_pattern = rf"\bFROM\s+{re.escape(tmp_table)}\b"
                    if re.search(from_pattern, op.sql_block, re.IGNORECASE):
                        lineage = TableLineage(
                            source_schema=proc_info.schema,
                            source_table=tmp_table,
                            target_schema=proc_info.schema,
                            target_table=op.target_table,
                            procedure=proc_info.full_name,
                        )
                        internal_lineages.append(lineage)
                        logger.debug(
                            "  [内部依赖] %s → %s (写于step%d, 读于step%d)",
                            tmp_table,
                            op.target_table,
                            write_step,
                            op.step_num,
                        )

        return internal_lineages

    # ===================================================================
    # 源表 / 目标表提取
    # ===================================================================

    def _extract_source_tables(self, content: str) -> list[str]:
        source_tables: list[str] = []

        section_match = re.search(
            r"来源表[::\s]*[：:]?\s*(.*?)(?=\*目标表|\*配置表|\*修改|\*/)",
            content,
            re.IGNORECASE | re.DOTALL,
        )
        if section_match:
            section = section_match.group(1)
            for tm in re.finditer(r"([\w.]+)\s+(?:--|/\*)\s*[^\n*]+", section):
                tbl = tm.group(1).strip().upper()
                if tbl and not tbl.startswith("ETL_"):
                    source_tables.append(self._normalize_table_name(tbl))

        if not source_tables:
            from_tables: set[str] = set()
            for fm in re.finditer(r"\bFROM\s+([\w.]+(?:_EAST)?)", content, re.IGNORECASE):
                tbl = fm.group(1).strip().upper()
                if self._is_valid_table(tbl):
                    from_tables.add(self._normalize_table_name(tbl))
            for jm in re.finditer(r"\bJOIN\s+([\w.]+)", content, re.IGNORECASE):
                tbl = jm.group(1).strip().upper()
                if self._is_valid_table(tbl):
                    from_tables.add(self._normalize_table_name(tbl))
            source_tables = list(from_tables)

        return source_tables

    def _extract_target_tables(self, content: str) -> list[str]:
        target_tables: list[str] = []

        section_match = re.search(
            r"目标表[::\s]*[：:]?\s*(.*?)(?=\*配置表|\*修改|\*/)",
            content,
            re.IGNORECASE | re.DOTALL,
        )
        if section_match:
            section = section_match.group(1)
            for tm in re.finditer(r"([\w.]+)\s+(?:--|/\*)\s*[^\n*]+", section):
                tbl = tm.group(1).strip().upper()
                if tbl and not tbl.startswith("ETL_"):
                    target_tables.append(self._normalize_table_name(tbl))

        if not target_tables:
            tbl_set: set[str] = set()
            for im in re.finditer(r"\bINSERT\s+(?:/\*.*?\*/\s*)?INTO\s+([\w.]+)", content, re.IGNORECASE):
                tbl = im.group(1).strip().upper()
                if self._is_valid_table(tbl):
                    tbl_set.add(self._normalize_table_name(tbl))
            for mm in re.finditer(r"\bMERGE\s+.*?\bINTO\s+([\w.]+)", content, re.IGNORECASE | re.DOTALL):
                tbl = mm.group(1).strip().upper()
                if self._is_valid_table(tbl):
                    tbl_set.add(self._normalize_table_name(tbl))
            for um in re.finditer(r"\bUPDATE\s+([\w.]+)\s", content, re.IGNORECASE):
                tbl = um.group(1).strip().upper()
                if self._is_valid_table(tbl):
                    tbl_set.add(self._normalize_table_name(tbl))
            target_tables = list(tbl_set)

        return target_tables

    # ===================================================================
    # 表级血缘构建
    # ===================================================================

    def _build_table_lineages(
        self,
        proc_info: ProcedureInfo,
        internal_deps: list[TableLineage] | None = None,
    ) -> list[TableLineage]:
        """构建表级血缘关系（外部源表→目标表 + 内部 TMP 依赖）。"""
        lineages: list[TableLineage] = []

        for source in proc_info.source_tables:
            for target in proc_info.target_tables:
                if source == target:
                    continue
                related_mappings = [fm for fm in proc_info.field_mappings if fm.target_table == target]
                lineages.append(
                    TableLineage(
                        source_schema=proc_info.schema,
                        source_table=source,
                        target_schema=proc_info.schema,
                        target_table=target,
                        procedure=proc_info.full_name,
                        field_mappings=related_mappings,
                    )
                )

        # 合并内部依赖
        if internal_deps:
            lineages.extend(internal_deps)

        return lineages

    # ===================================================================
    # 工具方法
    # ===================================================================

    @staticmethod
    def _is_valid_table(table_name: str) -> bool:
        if not table_name:
            return False
        if table_name.startswith(_INVALID_TABLE_PREFIXES):
            return False
        if len(table_name) < 2:
            return False
        return True

    def _normalize_table_name(self, raw_name: str, default_schema: str = "RRP_MDL") -> str:
        raw = raw_name.strip().upper()
        if not raw:
            return raw

        if "." in raw:
            parts = raw.split(".", 1)
            schema_part, tbl_part = parts[0], parts[1]
            known_schemas = {"ICL", "IML", "IOL", "RRP_EAST", "RRP_MDL"}
            if schema_part in known_schemas:
                best_match = self._find_best_table_match(tbl_part, preferred_schema=schema_part)
                if best_match:
                    return best_match
                return f"{schema_part}.{tbl_part}"
            return raw

        best_match = self._find_best_table_match(raw)
        if best_match:
            return best_match
        return f"{default_schema}.{raw}"

    def _find_best_table_match(self, tbl_part: str, preferred_schema: str = "") -> str:
        _rrp_prefixes = ("O_ICL_", "O_IML_", "O_IOL_", "O_RDW_")

        exact_candidates = []
        prefix_candidates = []
        for full_key in self.tables:
            upper_key = full_key.upper()
            if upper_key == f"RRP_MDL.{tbl_part}" or upper_key.endswith(f".{tbl_part}"):
                exact_candidates.append(full_key)
                continue
            for pfx in _rrp_prefixes:
                if upper_key.endswith(f"{pfx}{tbl_part}") or upper_key == f"RRP_MDL.{pfx}{tbl_part}":
                    prefix_candidates.append(full_key)
                    break

        if exact_candidates:
            if preferred_schema:
                schema_matches = [c for c in exact_candidates if c.upper().startswith(f"{preferred_schema}.")]
                if schema_matches:
                    return min(schema_matches, key=len)
            return min(exact_candidates, key=len)
        if prefix_candidates:
            if preferred_schema:
                schema_matches = [c for c in prefix_candidates if c.upper().startswith(f"{preferred_schema}.")]
                if schema_matches:
                    return min(schema_matches, key=len)
            return min(prefix_candidates, key=len)
        return ""
