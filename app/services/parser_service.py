"""
解析服务
封装现有的表/存储过程解析逻辑，支持增量解析与异步任务管理
"""

from __future__ import annotations

import json
import logging
import os
import pickle
import threading
import time
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from typing import Any, Optional

from app.config import config
from app.repository import DataRepository, search_table_dicts

logger = logging.getLogger(__name__)

try:
    from core.table_parser import OracleTableParser
    from core.procedure_parser import EnhancedProcedureParser
    from core.caliber_extractor import CaliberExtractor
    from core.models import FieldMapping, TableLineage
except ImportError as e:
    logger.warning("无法导入核心解析模块: %s", e)
    OracleTableParser = None
    EnhancedProcedureParser = None
    CaliberExtractor = None


class ParseResult:
    """解析结果数据类"""

    def __init__(self):
        self.tables: list[dict] = []
        self.procedures: list[dict] = []
        self.table_lineages: list[dict] = []
        self.field_mappings: list[dict] = []
        self.caliber_infos: list[dict] = []
        self.errors: list[str] = []
        self.parse_time_sec: float = 0.0

    def to_dict(self) -> dict[str, Any]:
        return {
            "tables_parsed": len(self.tables),
            "procedures_parsed": len(self.procedures),
            "table_lineages": len(self.table_lineages),
            "field_mappings": len(self.field_mappings),
            "caliber_infos": len(self.caliber_infos),
            "errors": self.errors,
            "parse_time_sec": round(self.parse_time_sec, 2),
        }

    def merge(self, other: "ParseResult") -> None:
        """合并另一个解析结果（增量模式）- 支持存储过程去重更新"""
        existing_tables = {t["full_name"]: i for i, t in enumerate(self.tables)}
        for table in other.tables:
            if table["full_name"] not in existing_tables:
                self.tables.append(table)
            else:
                idx = existing_tables[table["full_name"]]
                self.tables[idx] = table

        existing_procs = {p["full_name"]: p for p in self.procedures}
        new_proc_names = {p["full_name"] for p in other.procedures}

        removed_procs = set(existing_procs.keys()) & new_proc_names
        if removed_procs:
            logger.info("检测到 %d 个重复存储过程，将清除旧血缘关系后重新添加", len(removed_procs))
            old_lineages_to_remove = set()
            old_mappings_to_remove = set()

            for proc_name in removed_procs:
                old_lineages_to_remove.update(
                    (tl["source_table"], tl["target_table"], tl.get("procedure", ""))
                    for tl in self.table_lineages
                    if tl.get("procedure", "") == proc_name
                )
                old_mappings_to_remove.update(
                    (fm["source_table"], fm["source_column"], fm["target_table"], fm["target_column"])
                    for fm in self.field_mappings
                    if fm.get("procedure", "") == proc_name
                )

            if old_lineages_to_remove:
                self.table_lineages = [
                    tl for tl in self.table_lineages
                    if (tl["source_table"], tl["target_table"], tl.get("procedure", "")) not in old_lineages_to_remove
                ]
                logger.info("已清除 %d 条旧血缘关系", len(old_lineages_to_remove))

            if old_mappings_to_remove:
                self.field_mappings = [
                    fm for fm in self.field_mappings
                    if (fm["source_table"], fm["source_column"], fm["target_table"], fm["target_column"]) not in old_mappings_to_remove
                ]
                logger.info("已清除 %d 条旧字段映射", len(old_mappings_to_remove))

        for proc in other.procedures:
            existing_procs[proc["full_name"]] = proc

        self.procedures = list(existing_procs.values())

        seen_lineages = set()
        unique_lineages = []
        for tl in other.table_lineages + self.table_lineages:
            key = (tl["source_table"], tl["target_table"], tl.get("procedure", ""))
            if key not in seen_lineages:
                seen_lineages.add(key)
                unique_lineages.append(tl)
        self.table_lineages = unique_lineages

        seen_mappings = set()
        unique_mappings = []
        for fm in other.field_mappings + self.field_mappings:
            key = (fm["source_table"], fm["source_column"], fm["target_table"], fm["target_column"])
            if key not in seen_mappings:
                seen_mappings.add(key)
                unique_mappings.append(fm)
        self.field_mappings = unique_mappings

        seen_calibers = set()
        unique_calibers = []
        for ci in other.caliber_infos + self.caliber_infos:
            key = (ci.get("target_table", ""), ci.get("target_column", ""),
                   ci.get("source_table", ""), ci.get("source_column", ""),
                   ci.get("procedure", ""), ci.get("step_num", 0))
            if key not in seen_calibers:
                seen_calibers.add(key)
                unique_calibers.append(ci)
        self.caliber_infos = unique_calibers

        self.errors.extend(other.errors)


class ParserService:
    """数据库对象解析服务"""

    def __init__(self, data_dir: str, schema_dirs: list[str], output_dir: str):
        self.data_dir = Path(data_dir)
        self.schema_dirs = schema_dirs
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)

        self._table_parser: Optional[OracleTableParser] = None
        self._proc_parser: Optional[EnhancedProcedureParser] = None
        self._current_result: Optional[ParseResult] = None
        self._lineage_tracer: Optional[Any] = None
        self._repository: Optional[DataRepository] = None
        self._result_lock = threading.Lock()
        self._cached_procedures: dict[str, Any] = {}

        self._executor = ThreadPoolExecutor(max_workers=2)

    def initialize_parsers(self) -> None:
        """初始化解析器实例"""
        if OracleTableParser is None:
            raise RuntimeError("核心解析模块未安装，请检查依赖")

        if self._table_parser is None:
            self._table_parser = OracleTableParser()
            logger.info("表结构解析器初始化完成")

        if self._proc_parser is None and EnhancedProcedureParser is not None:
            tables = self._table_parser.tables if self._table_parser else {}
            self._proc_parser = EnhancedProcedureParser(tables=tables)
            logger.info("存储过程解析器初始化完成 (Enhanced)")

    def load_from_cache(self) -> Optional[ParseResult]:
        """
        从缓存文件加载数据（优先 pickle，回退 JSON）

        pickle 缓存约 10 秒加载，JSON 约 2 分钟。
        pickle 不存在时自动回退到 JSON 并生成 pickle。

        Returns:
            ParseResult 如果缓存有效，否则返回 None
        """
        pkl_file = self.output_dir / "lineage_data.pkl"
        json_file = self.output_dir / "lineage_data.json"

        # 策略 1：优先加载 pickle（快速）
        if pkl_file.exists():
            try:
                start_time = time.time()
                logger.info("正在加载 pickle 缓存: %s (大小: %.1f MB)",
                            pkl_file, pkl_file.stat().st_size / 1024 / 1024)

                with open(pkl_file, "rb") as f:
                    data = pickle.load(f)

                metadata = data.get("metadata", {})
                if not metadata or not metadata.get("total_tables"):
                    logger.warning("pickle 缓存元数据无效，删除后重试")
                    pkl_file.unlink(missing_ok=True)
                else:
                    result = self._populate_result_from_data(data)
                    elapsed = time.time() - start_time
                    logger.info(
                        "✅ pickle 缓存加载完成: %d 张表, %d 个过程, %d 条血缘, 耗时 %.2fs",
                        len(result.tables),
                        len(result.procedures),
                        len(result.table_lineages),
                        elapsed,
                    )
                    return result

            except Exception as e:
                logger.warning("pickle 缓存加载失败: %s，尝试 JSON", e)
                pkl_file.unlink(missing_ok=True)

        # 策略 2：回退到 JSON（慢但可靠）
        if not json_file.exists():
            logger.info("缓存文件不存在 (pickle 和 JSON 均无)")
            return None

        try:
            start_time = time.time()
            logger.info("正在加载 JSON 缓存: %s (大小: %.1f MB)",
                        json_file, json_file.stat().st_size / 1024 / 1024)

            with open(json_file, "r", encoding="utf-8") as f:
                data = json.load(f)

            metadata = data.get("metadata", {})
            if not metadata or not metadata.get("total_tables"):
                logger.warning("JSON 缓存元数据无效，跳过缓存加载")
                return None

            result = self._populate_result_from_data(data)
            elapsed = time.time() - start_time
            logger.info(
                "✅ JSON 缓存加载完成: %d 张表, %d 个过程, %d 条血缘, 耗时 %.2fs",
                len(result.tables),
                len(result.procedures),
                len(result.table_lineages),
                elapsed,
            )

            # 自动生成 pickle 缓存以加速下次启动
            self._save_pickle_cache(data)

            return result

        except Exception as e:
            logger.error("JSON 缓存加载失败: %s", e, exc_info=True)
            return None

    def _populate_result_from_data(self, data: dict) -> ParseResult:
        """从字典数据填充 ParseResult 并初始化 Repository"""
        result = ParseResult()
        result.tables = data.get("tables", [])
        result.procedures = data.get("procedures", [])
        result.table_lineages = data.get("table_lineages", [])
        result.field_mappings = data.get("field_mappings", [])
        result.caliber_infos = data.get("caliber_infos", [])
        result.parse_time_sec = 0.0

        self._current_result = result

        # 初始化 Repository 并直接用内存数据填充（避免重复加载 JSON）
        json_file = self.output_dir / "lineage_data.json"
        self._repository = DataRepository(json_file)
        # 不调用 repository.load()（会重复读 JSON），直接 update 内存数据
        self._repository.update(data)

        return result

    def _save_pickle_cache(self, data: dict) -> None:
        """将数据保存为 pickle 格式以加速后续启动"""
        pkl_file = self.output_dir / "lineage_data.pkl"
        try:
            start_time = time.time()
            with open(pkl_file, "wb") as f:
                pickle.dump(data, f, protocol=pickle.HIGHEST_PROTOCOL)
            elapsed = time.time() - start_time
            logger.info("pickle 缓存已保存: %s (大小: %.1f MB, 耗时 %.2fs)",
                        pkl_file, pkl_file.stat().st_size / 1024 / 1024, elapsed)
        except Exception as e:
            logger.warning("pickle 缓存保存失败: %s", e)

    def parse_existing_data(self, force: bool = False) -> ParseResult:
        """
        解析已有的 RRP_ORACLE 目录下的所有文件
        
        Args:
            force: 是否强制全量解析（忽略缓存）
        
        Returns:
            ParseResult 包含完整的解析结果
        """
        # 缓存优先：非强制模式时先尝试加载缓存
        if not force:
            cached = self.load_from_cache()
            if cached is not None:
                return cached

        start_time = time.time()
        result = ParseResult()

        try:
            self.initialize_parsers()

            logger.info("开始扫描目录: %s", self.data_dir)

            # 解析 .tab 文件 (表结构)
            for schema_dir in self.schema_dirs:
                schema_path = self.data_dir / schema_dir
                if schema_path.exists():
                    self._parse_tab_directory(schema_path, result)

            # 解析 .prc 文件 (存储过程)
            if self._proc_parser:
                for schema_dir in self.schema_dirs:
                    schema_path = self.data_dir / schema_dir
                    if schema_path.exists():
                        self._parse_proc_directory(schema_path, result)

            result.parse_time_sec = time.time() - start_time
            self._current_result = result

            self._save_result_to_cache(result)
            logger.info(
                "解析完成: %d 张表, %d 个过程, %d 条血缘, 耗时 %.2fs",
                len(result.tables),
                len(result.procedures),
                len(result.table_lineages),
                result.parse_time_sec,
            )

        except Exception as e:
            logger.error("解析过程异常: %s", e, exc_info=True)
            result.errors.append(f"解析异常: {str(e)}")

        return result

    def parse_uploaded_files(
        self,
        file_paths: list[Path],
        mode: str = "incremental",
        progress_callback=None,
    ) -> ParseResult:
        """
        解析用户上传的文件列表（串行模式，支持进度回调）

        Args:
            file_paths: 上传文件的路径列表
            mode: 解析模式 (incremental | full)
            progress_callback: 进度回调函数 callback(percent, current_file, message, **stats)

        Returns:
            ParseResult 上传文件的解析结果
        """
        start_time = time.time()
        result = ParseResult()

        try:
            self.initialize_parsers()

            tab_files = [f for f in file_paths if f.suffix.lower() == ".tab"]
            prc_files = [f for f in file_paths if f.suffix.lower() == ".prc"]
            total_files = len(tab_files) + len(prc_files)

            logger.info("开始串行解析上传文件: %d 个 .tab 文件, %d 个 .prc 文件 (共 %d 个)",
                       len(tab_files), len(prc_files), total_files)

            if progress_callback:
                progress_callback(5, "", "初始化解析引擎...")

            all_files = [(f, "tab") for f in tab_files] + [(f, "prc") for f in prc_files]

            for idx, (file_path, file_type) in enumerate(all_files):
                percent = 5 + int((idx / max(total_files, 1)) * 85)
                current_file_name = file_path.name

                if progress_callback:
                    progress_callback(
                        percent,
                        current_file_name,
                        f"正在解析 ({idx + 1}/{total_files}): {current_file_name}",
                        tables_parsed=len(result.tables),
                        procedures_parsed=len(result.procedures),
                        lineages_found=len(result.table_lineages),
                    )

                try:
                    if file_type == "tab":
                        self._parse_single_tab(file_path, result)
                    elif file_type == "prc":
                        self._parse_single_prc(file_path, result)

                except Exception as e:
                    logger.error("文件解析异常: %s - %s", file_path, e)
                    result.errors.append(f"文件 {file_path.name}: {str(e)}")

                if progress_callback:
                    progress_callback(
                        min(percent + 2, 95),
                        current_file_name,
                        f"完成 ({idx + 1}/{total_files})",
                        tables_parsed=len(result.tables),
                        procedures_parsed=len(result.procedures),
                        lineages_found=len(result.table_lineages),
                    )

            result.parse_time_sec = time.time() - start_time

            if mode == "incremental" and self._current_result:
                if progress_callback:
                    progress_callback(96, "", "合并增量数据（去重更新中）...")
                self._current_result.merge(result)
                self._save_result_to_cache(self._current_result)
            else:
                self._current_result = result
                self._save_result_to_cache(result)

            if progress_callback:
                progress_callback(100, "", "✅ 解析完成！")

            logger.info(
                "文件解析完成: %d 张表, %d 个过程, 耗时 %.2fs",
                len(self._current_result.tables),
                len(self._current_result.procedures),
                result.parse_time_sec,
            )

        except Exception as e:
            logger.error("文件解析异常: %s", e, exc_info=True)
            result.errors.append(f"解析异常: {str(e)}")
            if progress_callback:
                progress_callback(-1, "", f"❌ 解析失败: {str(e)}")

        return result

    def _get_repository(self) -> DataRepository:
        """获取或创建 DataRepository 实例"""
        if self._repository is None:
            cache_file = self.output_dir / "lineage_data.json"
            self._repository = DataRepository(cache_file)
            self._repository.load()
        return self._repository

    def get_current_data(self) -> Optional[dict[str, Any]]:
        """获取当前缓存的完整数据（优先从内存缓存读取）"""
        repo = self._get_repository()
        cached = repo.get_raw_data()
        if cached:
            return cached

        cache_file = self.output_dir / "lineage_data.json"
        if cache_file.exists():
            try:
                with open(cache_file, "r", encoding="utf-8") as f:
                    data = json.load(f)
                repo.update(data)
                return data
            except Exception as e:
                logger.error("读取缓存数据失败: %s", e)
        return None

    def get_table_list(self) -> list[dict]:
        """获取当前所有表的列表"""
        data = self.get_current_data()
        if data:
            return data.get("tables", [])
        return []

    def search_tables(self, keyword: str, limit: int = 50) -> list[dict]:
        """通过统一数据仓库搜索表。"""
        if self._current_result is not None:
            return search_table_dicts(self._current_result.tables, keyword, limit)
        return self._get_repository().search_tables(keyword, limit)

    def get_procedure_list(self) -> list[dict]:
        """获取当前所有存储过程的列表"""
        data = self.get_current_data()
        if data:
            return data.get("procedures", [])
        return []

    def get_lineage_tracer(self) -> Optional[Any]:
        """获取或构建 LineageTracer 实例（支持从缓存重建 dataclass 对象）"""
        if self._lineage_tracer is not None:
            return self._lineage_tracer

        try:
            from core.lineage_tracer import LineageTracer
            from core.models import TableLineage, FieldMapping, TableInfo, ColumnInfo, ProcedureInfo

            # 策略 1：从已解析的 dataclass 对象构建（全量解析后）
            if self._table_parser and self._proc_parser and self._cached_procedures:
                tables = self._table_parser.tables
                procedures: dict = {}

                all_table_lineages: list[TableLineage] = []
                all_field_mappings: list[FieldMapping] = []

                for proc_info in self._cached_procedures.values():
                    procedures[proc_info.full_name] = proc_info
                    all_table_lineages.extend(proc_info.table_lineages)
                    all_field_mappings.extend(proc_info.field_mappings)

                self._lineage_tracer = LineageTracer(
                    tables=tables,
                    procedures=procedures,
                    table_lineages=all_table_lineages,
                    field_mappings=all_field_mappings,
                )
                return self._lineage_tracer

            # 策略 2：从缓存数据重建 dataclass 对象（缓存启动时）
            if self._current_result is not None:
                logger.info("从缓存数据重建 LineageTracer dataclass 对象...")
                t0 = time.time()

                # 重建 TableInfo 对象
                tables = {}
                for t in self._current_result.tables:
                    full_name = t.get("full_name", "")
                    schema = t.get("schema", "")
                    table_name = t.get("table_name", "")
                    columns = [
                        ColumnInfo(
                            name=c.get("name", ""),
                            data_type=c.get("data_type", ""),
                            comment=c.get("comment", ""),
                        )
                        for c in t.get("columns", [])
                    ]
                    tables[full_name] = TableInfo(
                        schema=schema,
                        table_name=table_name,
                        full_name=full_name,
                        comment=t.get("comment", ""),
                        columns=columns,
                        primary_keys=t.get("primary_keys", []),
                    )

                # 重建 TableLineage + FieldMapping 对象
                # 先按 procedure 分组 field_mappings
                fm_by_proc: dict[str, list[FieldMapping]] = {}
                for fm in self._current_result.field_mappings:
                    proc_name = fm.get("procedure", "")
                    fm_obj = FieldMapping(
                        source_table=fm.get("source_table", ""),
                        source_column=fm.get("source_column", ""),
                        target_table=fm.get("target_table", ""),
                        target_column=fm.get("target_column", ""),
                        transform_logic=fm.get("transform_logic", ""),
                        procedure=proc_name,
                        confidence=fm.get("confidence", 1.0),
                    )
                    fm_by_proc.setdefault(proc_name, []).append(fm_obj)

                # 重建 ProcedureInfo 对象
                procedures = {}
                for p in self._current_result.procedures:
                    full_name = p.get("full_name", "")
                    proc_name = p.get("proc_name", "")
                    schema = p.get("schema", "")

                    # 该过程的字段映射
                    proc_field_mappings = fm_by_proc.get(full_name, [])

                    # 该过程的表级血缘
                    proc_table_lineages = [
                        TableLineage(
                            source_table=tl.get("source_table", ""),
                            target_table=tl.get("target_table", ""),
                            procedure=tl.get("procedure", ""),
                        )
                        for tl in self._current_result.table_lineages
                        if tl.get("procedure", "") == full_name
                    ]

                    proc_info = ProcedureInfo(
                        schema=schema,
                        proc_name=proc_name,
                        full_name=full_name,
                        description=p.get("description", ""),
                        source_tables=p.get("source_tables", []),
                        target_tables=p.get("target_tables", []),
                        config_tables=p.get("config_tables", []),
                        table_lineages=proc_table_lineages,
                        field_mappings=proc_field_mappings,
                    )
                    procedures[full_name] = proc_info
                    self._cached_procedures[full_name] = proc_info

                # 合并所有字段映射和表级血缘
                all_field_mappings = [
                    FieldMapping(
                        source_table=fm.get("source_table", ""),
                        source_column=fm.get("source_column", ""),
                        target_table=fm.get("target_table", ""),
                        target_column=fm.get("target_column", ""),
                        transform_logic=fm.get("transform_logic", ""),
                        procedure=fm.get("procedure", ""),
                        confidence=fm.get("confidence", 1.0),
                    )
                    for fm in self._current_result.field_mappings
                ]

                all_table_lineages = [
                    TableLineage(
                        source_table=tl.get("source_table", ""),
                        target_table=tl.get("target_table", ""),
                        procedure=tl.get("procedure", ""),
                    )
                    for tl in self._current_result.table_lineages
                ]

                self._lineage_tracer = LineageTracer(
                    tables=tables,
                    procedures=procedures,
                    table_lineages=all_table_lineages,
                    field_mappings=all_field_mappings,
                )
                elapsed = time.time() - t0
                logger.info(
                    "LineageTracer 从缓存重建完成: %d 表, %d 过程, 耗时 %.2fs",
                    len(tables), len(procedures), elapsed,
                )
                return self._lineage_tracer

            logger.warning("无可用的解析数据或缓存，无法构建 LineageTracer")
            return None

        except Exception as e:
            logger.error("构建 LineageTracer 失败: %s", e, exc_info=True)
            return None

    def _parse_tab_directory(self, directory: Path, result: ParseResult) -> None:
        """解析目录下所有 .tab 文件"""
        if not self._table_parser:
            return

        for file_path in directory.rglob("*.tab"):
            try:
                table_info = self._table_parser.parse_tab_file(str(file_path))
                if table_info:
                    table_dict = {
                        "full_name": table_info.full_name,
                        "schema": table_info.schema,
                        "table_name": table_info.table_name,
                        "comment": table_info.comment,
                        "columns": [
                            {"name": c.name, "data_type": c.data_type, "comment": c.comment}
                            for c in table_info.columns
                        ],
                        "primary_keys": table_info.primary_keys,
                    }
                    result.tables.append(table_dict)
            except Exception as e:
                logger.warning("解析 .tab 文件失败: %s - %s", file_path, e)
                result.errors.append(f"文件 {file_path.name}: {str(e)}")

    def _parse_proc_directory(self, directory: Path, result: ParseResult) -> None:
        """解析目录下所有 .prc 文件"""
        if not self._proc_parser:
            return

        procedures = self._proc_parser.parse_directory(str(directory))
        self._cached_procedures.update(procedures)
        for proc_info in procedures.values():
            try:
                proc_dict = {
                    "full_name": proc_info.full_name,
                    "schema": proc_info.schema,
                    "proc_name": proc_info.proc_name,
                    "description": proc_info.description,
                    "source_tables": proc_info.source_tables,
                    "target_tables": proc_info.target_tables,
                    "config_tables": getattr(proc_info, "config_tables", []),
                }
                result.procedures.append(proc_dict)

                for tl in proc_info.table_lineages:
                    result.table_lineages.append({
                        "source_table": tl.source_table,
                        "target_table": tl.target_table,
                        "procedure": tl.procedure,
                    })

                for fm in proc_info.field_mappings:
                    result.field_mappings.append({
                        "source_table": fm.source_table,
                        "source_column": fm.source_column,
                        "target_table": fm.target_table,
                        "target_column": fm.target_column,
                        "transform_logic": fm.transform_logic,
                        "procedure": fm.procedure,
                        "confidence": fm.confidence,
                    })

                caliber_infos = self._proc_parser.extract_caliber_from_proc(
                    proc_info, data_source="oracle"
                )
                for ci in caliber_infos:
                    result.caliber_infos.append(CaliberExtractor.to_dict(ci))

            except Exception as e:
                logger.warning("序列化过程信息失败: %s - %s", proc_info.full_name, e)
                result.errors.append(f"过程 {proc_info.full_name}: {str(e)}")

    def _parse_single_tab(self, file_path: Path, result: ParseResult) -> None:
        """解析单个 .tab 文件"""
        if not self._table_parser:
            return

        try:
            table_info = self._table_parser.parse_tab_file(str(file_path))
            if table_info:
                table_dict = {
                    "full_name": table_info.full_name,
                    "schema": table_info.schema,
                    "table_name": table_info.table_name,
                    "comment": table_info.comment,
                    "columns": [
                        {"name": c.name, "data_type": c.data_type, "comment": c.comment}
                        for c in table_info.columns
                    ],
                    "primary_keys": table_info.primary_keys,
                }
                result.tables.append(table_dict)
                logger.info("成功解析表: %s", table_info.full_name)
        except Exception as e:
            logger.error("解析文件失败: %s - %s", file_path, e)
            result.errors.append(f"文件 {file_path.name}: {str(e)}")

    def _parse_single_prc(self, file_path: Path, result: ParseResult) -> None:
        """解析单个 .prc 文件（直接调用 parse_prc_file，避免扫描整个目录）"""
        if not self._proc_parser:
            return

        try:
            proc_info = self._proc_parser.parse_prc_file(str(file_path))
            if not proc_info:
                logger.warning("文件解析无结果: %s", file_path)
                return

            proc_dict = {
                "full_name": proc_info.full_name,
                "schema": proc_info.schema,
                "proc_name": proc_info.proc_name,
                "description": proc_info.description,
                "source_tables": proc_info.source_tables,
                "target_tables": proc_info.target_tables,
                "config_tables": getattr(proc_info, "config_tables", []),
            }
            result.procedures.append(proc_dict)

            for tl in proc_info.table_lineages:
                result.table_lineages.append({
                    "source_table": tl.source_table,
                    "target_table": tl.target_table,
                    "procedure": tl.procedure,
                })

            for fm in proc_info.field_mappings:
                result.field_mappings.append({
                    "source_table": fm.source_table,
                    "source_column": fm.source_column,
                    "target_table": fm.target_table,
                    "target_column": fm.target_column,
                    "transform_logic": fm.transform_logic,
                    "procedure": fm.procedure,
                    "confidence": fm.confidence,
                })

            if self._proc_parser and CaliberExtractor is not None:
                caliber_infos = self._proc_parser.extract_caliber_from_proc(
                    proc_info, data_source="oracle"
                )
                for ci in caliber_infos:
                    result.caliber_infos.append(CaliberExtractor.to_dict(ci))

            logger.info("成功解析过程: %s", proc_info.full_name)

        except Exception as e:
            logger.error("解析过程文件失败: %s - %s", file_path, e)
            result.errors.append(f"文件 {file_path.name}: {str(e)}")

    def _save_result_to_cache(self, result: ParseResult) -> None:
        """将结果保存到缓存文件（JSON + pickle 双格式）"""
        try:
            data = {
                "metadata": {
                    "total_tables": len(result.tables),
                    "total_procedures": len(result.procedures),
                    "total_table_lineages": len(result.table_lineages),
                    "total_field_mappings": len(result.field_mappings),
                    "total_caliber_infos": len(result.caliber_infos),
                    "parser_version": "enhanced-v2",
                    "last_updated": time.strftime("%Y-%m-%d %H:%M:%S"),
                },
                "tables": result.tables,
                "procedures": result.procedures,
                "table_lineages": result.table_lineages,
                "field_mappings": result.field_mappings,
                "caliber_infos": result.caliber_infos,
            }

            # 保存 pickle 缓存（快速加载）
            self._save_pickle_cache(data)

            # 保存 JSON 缓存（人可读备份）
            cache_file = self.output_dir / "lineage_data.json"
            with open(cache_file, "w", encoding="utf-8") as f:
                json.dump(data, f, ensure_ascii=False, indent=2)

            if self._repository:
                self._repository.update(data)

            logger.info("JSON 数据缓存已保存: %s", cache_file)

        except Exception as e:
            logger.error("保存缓存数据失败: %s", e)
