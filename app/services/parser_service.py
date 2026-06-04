"""
解析服务（统一路由版本）

封装所有数据源的解析逻辑，通过 ParserRegistry 统一路由，
支持 Oracle (.tab/.prc)、数仓 (.sql/.ctl)、指标 (.xlsx/.proc) 等多种数据源。

改造要点：
  - 所有数据源统一走 Registry 路由，消除双路径
  - Oracle 数据源通过 OracleTabAdapter/OraclePrcAdapter 走 Registry
  - 数仓数据源通过 WarehouseSQLParser 走 Registry，支持多系统配置注入
  - 指标数据源通过 IndicatorAdapter 走 Registry
  - 保留 _parse_tab_directory/_parse_proc_directory 作为兼容回退
"""

from __future__ import annotations

import logging
import threading
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from typing import Any

from app.config import config
from app.repository import DataRepository, search_table_dicts
from app.services.cache_store import CacheStore
from app.services.event_bus import EventType, get_event_bus
from app.services.tracer_factory import TracerFactory
from core.parser_protocol import ParseOutput

logger = logging.getLogger(__name__)

try:
    from core.adapters import IndicatorAdapter, OraclePrcAdapter, OracleTabAdapter
    from core.caliber_extractor import CaliberExtractor
    from core.layer_detector import LayerDetector
    from core.models import FieldMapping, ProcedureInfo, TableInfo, TableLineage
    from core.pam import PamParser
    from core.parser_registry import ParserRegistry
    from core.procedure_parser import EnhancedProcedureParser
    from core.table_parser import OracleTableParser
    from core.warehouse import SchemaResolver, WarehouseSQLParser
except ImportError as e:
    logger.warning("无法导入核心解析模块: %s", e)
    OracleTableParser = None
    EnhancedProcedureParser = None
    CaliberExtractor = None
    ParserRegistry = None
    OracleTabAdapter = None
    OraclePrcAdapter = None
    IndicatorAdapter = None
    WarehouseSQLParser = None
    SchemaResolver = None
    LayerDetector = None
    PamParser = None


class ParseResult:
    def __init__(self):
        self.tables: list[TableInfo] = []
        self.procedures: list[ProcedureInfo] = []
        self.table_lineages: list[TableLineage] = []
        self.field_mappings: list[FieldMapping] = []
        self.caliber_infos: list[dict] = []
        self.errors: list[str] = []
        self.parse_time_sec: float = 0.0
        # ★ 优化：增量去重集合，避免每次 merge 重建全量 set
        self._seen_lineage_keys: set[tuple] = set()
        self._seen_mapping_keys: set[tuple] = set()
        self._seen_caliber_keys: set[tuple] = set()

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

    def to_serializable(self) -> dict[str, Any]:
        return {
            "tables": [t.to_dict() for t in self.tables],
            "procedures": [p.to_dict() for p in self.procedures],
            "table_lineages": [tl.to_dict() for tl in self.table_lineages],
            "field_mappings": [fm.to_dict() for fm in self.field_mappings],
            "caliber_infos": self.caliber_infos,
        }

    @classmethod
    def from_serializable(cls, data: dict[str, Any]) -> ParseResult:
        result = cls()
        result.tables = [TableInfo.from_dict(t) for t in data.get("tables", [])]
        result.procedures = [ProcedureInfo.from_dict(p) for p in data.get("procedures", [])]
        result.table_lineages = [TableLineage.from_dict(tl) for tl in data.get("table_lineages", [])]
        result.field_mappings = [FieldMapping.from_dict(fm) for fm in data.get("field_mappings", [])]
        result.caliber_infos = data.get("caliber_infos", [])
        return result

    def merge(self, other: ParseResult) -> None:
        # ====== 表去重 ======
        existing_tables = {t.full_name: i for i, t in enumerate(self.tables)}
        for table in other.tables:
            if table.full_name not in existing_tables:
                self.tables.append(table)
            else:
                idx = existing_tables[table.full_name]
                self.tables[idx] = table

        # ====== 存储过程去重（旧→新替换，清除关联血缘） ======
        existing_procs = {p.full_name: p for p in self.procedures}
        new_proc_names = {p.full_name for p in other.procedures}

        removed_procs = set(existing_procs.keys()) & new_proc_names
        if removed_procs:
            logger.info(
                "检测到 %d 个重复存储过程，将清除旧血缘关系后重新添加",
                len(removed_procs),
            )
            old_lineages_to_remove = set()
            old_mappings_to_remove = set()

            for proc_name in removed_procs:
                old_lineages_to_remove.update(
                    (tl.source_table, tl.target_table, tl.procedure)
                    for tl in self.table_lineages
                    if tl.procedure == proc_name
                )
                old_mappings_to_remove.update(
                    (
                        fm.source_table,
                        fm.source_column,
                        fm.target_table,
                        fm.target_column,
                    )
                    for fm in self.field_mappings
                    if fm.procedure == proc_name
                )

            if old_lineages_to_remove:
                self.table_lineages = [
                    tl
                    for tl in self.table_lineages
                    if (tl.source_table, tl.target_table, tl.procedure) not in old_lineages_to_remove
                ]
                self._seen_lineage_keys -= old_lineages_to_remove
                logger.info("已清除 %d 条旧血缘关系", len(old_lineages_to_remove))

            if old_mappings_to_remove:
                self.field_mappings = [
                    fm
                    for fm in self.field_mappings
                    if (
                        fm.source_table,
                        fm.source_column,
                        fm.target_table,
                        fm.target_column,
                    )
                    not in old_mappings_to_remove
                ]
                self._seen_mapping_keys -= old_mappings_to_remove
                logger.info("已清除 %d 条旧字段映射", len(old_mappings_to_remove))

        for proc in other.procedures:
            existing_procs[proc.full_name] = proc

        self.procedures = list(existing_procs.values())

        # ====== ★ 优化：增量去重，避免重建全量 set ======
        for tl in other.table_lineages:
            key = (tl.source_table, tl.target_table, tl.procedure)
            if key not in self._seen_lineage_keys:
                self._seen_lineage_keys.add(key)
                self.table_lineages.append(tl)

        for fm in other.field_mappings:
            key = (fm.source_table, fm.source_column, fm.target_table, fm.target_column)
            if key not in self._seen_mapping_keys:
                self._seen_mapping_keys.add(key)
                self.field_mappings.append(fm)

        for ci in other.caliber_infos:
            key = (
                ci.get("target_table", ""),
                ci.get("target_column", ""),
                ci.get("source_table", ""),
                ci.get("source_column", ""),
                ci.get("procedure", ""),
                ci.get("step_num", 0),
            )
            if key not in self._seen_caliber_keys:
                self._seen_caliber_keys.add(key)
                self.caliber_infos.append(ci)

        self.errors.extend(other.errors)


class ParserService:
    """数据库对象解析服务（统一路由版本）"""

    def __init__(self, data_dir: str, schema_dirs: list[str], output_dir: str):
        self.data_dir = Path(data_dir)
        self.schema_dirs = schema_dirs
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)

        self._table_parser: OracleTableParser | None = None
        self._proc_parser: EnhancedProcedureParser | None = None
        self._registry: ParserRegistry | None = None
        self._pam_parser: PamParser | None = None
        self._layer_detector: LayerDetector | None = None
        self._current_result: ParseResult | None = None
        self._current_data_cache: dict[str, Any] | None = None  # 缓存 to_serializable() 结果
        self._cache_store = CacheStore(self.output_dir, config=config)
        self._tracer_factory = TracerFactory()
        self._result_lock = threading.Lock()
        self._cached_procedures: dict[str, Any] = {}
        self._event_bus = get_event_bus()

        # 并行解析线程池：数据源级并发 (L1) + 文件级并发 (L3)
        self._datasource_workers = 6  # 数据源级并行度（Oracle/EDW/BRT/PAM/GBASE/指标）
        self._file_workers = 4  # 文件级并行度（同类文件内部）
        self._executor = ThreadPoolExecutor(max_workers=self._datasource_workers)

    def shutdown(self) -> None:
        """关闭线程池，释放资源。幂等操作，可多次调用。"""
        if self._executor is not None:
            self._executor.shutdown(wait=True)
            self._executor = None
            logger.info("ParserService 线程池已关闭")

    def __del__(self) -> None:
        """析构时确保线程池被关闭（best-effort 兜底）。"""
        try:
            self.shutdown()
        except Exception:
            pass  # __del__ 中忽略异常

    def initialize_parsers(self) -> None:
        if OracleTableParser is None:
            raise RuntimeError("核心解析模块未安装，请检查依赖")

        if self._table_parser is None:
            self._table_parser = OracleTableParser()
            logger.info("表结构解析器初始化完成")

        if self._proc_parser is None and EnhancedProcedureParser is not None:
            tables = self._table_parser.tables if self._table_parser else {}
            self._proc_parser = EnhancedProcedureParser(tables=tables)
            logger.info("存储过程解析器初始化完成 (Enhanced)")

        if self._layer_detector is None and LayerDetector is not None:
            self._layer_detector = LayerDetector.from_manifests(config.source_data_path)
            logger.info("LayerDetector 初始化完成 (从 manifest 加载)")

        if self._registry is None and ParserRegistry is not None:
            self._registry = ParserRegistry()

            if OracleTabAdapter is not None:
                self._registry.register(OracleTabAdapter(self._table_parser))
            if OraclePrcAdapter is not None:
                self._registry.register(OraclePrcAdapter(self._proc_parser))

            indicator_registered = False

            # ★ 收集所有需要 warehouse 解析器的系统名（用于 schema 变量映射）
            warehouse_systems: list[str] = []

            for ds_config in config.datasource_configs:
                if not ds_config.enabled:
                    continue

                ds_path = self._resolve_ds_path(ds_config.data_dir)
                if not ds_path.exists():
                    continue

                if ds_config.parser == "warehouse":
                    if ds_config.name not in warehouse_systems:
                        warehouse_systems.append(ds_config.name)

                elif ds_config.parser == "indicator" and ds_config.name not in warehouse_systems:
                    warehouse_systems.append(ds_config.name)

            # 注册 WarehouseSQLParser（支持多系统）
            if warehouse_systems and WarehouseSQLParser is not None and SchemaResolver is not None:
                schema_resolver = SchemaResolver()
                # 用第一个系统作为主 system，其他系统通过 parse_directory 时按路径处理
                primary_system = warehouse_systems[0]
                warehouse_parser = WarehouseSQLParser(
                    schema_resolver=schema_resolver,
                    system=primary_system,
                )
                self._registry.register(warehouse_parser)
                logger.info(
                    "数仓脚本解析器注册完成: systems=%s (primary=%s)",
                    warehouse_systems,
                    primary_system,
                )

            for ds_config in config.datasource_configs:
                if not ds_config.enabled:
                    continue

                ds_path = self._resolve_ds_path(ds_config.data_dir)
                if not ds_path.exists():
                    continue

                if ds_config.parser == "indicator" and IndicatorAdapter is not None:
                    if not indicator_registered:
                        indicator_adapter = IndicatorAdapter(
                            layer_detector=self._layer_detector,
                            system=ds_config.name,
                        )
                        self._registry.register(indicator_adapter)
                        indicator_registered = True
                        logger.info(
                            "指标解析器适配器注册完成: %s (system=%s)",
                            ds_config.display_name,
                            ds_config.name,
                        )
                    else:
                        logger.info(
                            "指标解析器适配器已注册，跳过重复注册: %s (system=%s)",
                            ds_config.display_name,
                            ds_config.name,
                        )

                elif ds_config.parser == "pam" and PamParser is not None:
                    if self._pam_parser is None:
                        self._pam_parser = PamParser(default_schema="pam")
                        logger.info(
                            "PAM 解析器初始化完成: %s (system=%s)",
                            ds_config.display_name,
                            ds_config.name,
                        )

            logger.info("解析器注册表初始化完成: %s", self._registry)

    def load_from_cache(self) -> ParseResult | None:
        data = self._cache_store.load_from_cache()
        if data is None:
            return None
        return self._populate_result_from_data(data)

    def _populate_result_from_data(self, data: dict) -> ParseResult:
        result = ParseResult.from_serializable(data)
        result.parse_time_sec = 0.0

        self._current_result = result
        # 直接缓存已反序列化的 data，避免后续 get_current_data() 重复 to_serializable()
        self._current_data_cache = data

        repository = self._cache_store.get_repository()
        repository.update(data)

        return result

    def parse_existing_data(self, force: bool = False) -> ParseResult:
        if not force:
            cached = self.load_from_cache()
            if cached is not None:
                return cached

        start_time = time.time()
        result = ParseResult()

        try:
            self._event_bus.publish(EventType.PARSE_STARTED)
            self.initialize_parsers()

            # ====== 并行解析：收集所有独立数据源任务 ======
            tasks: list[tuple[str, Path]] = []
            pam_tasks: list[tuple[str, Path]] = []

            # Oracle schema 目录
            for schema_dir in self.schema_dirs:
                schema_path = self.data_dir / schema_dir
                if schema_path.exists():
                    tasks.append((f"oracle/{schema_dir}", schema_path))

            # 其他数据源目录
            for ds_config in config.datasource_configs:
                if ds_config.name == "oracle":
                    continue
                if not ds_config.enabled:
                    logger.info("数据源 %s 已禁用，跳过", ds_config.display_name)
                    continue
                ds_path = self._resolve_ds_path(ds_config.data_dir)
                if not ds_path.exists():
                    logger.info("数据源目录不存在，跳过: %s (%s)", ds_config.name, ds_path)
                    continue
                if ds_config.parser == "pam":
                    pam_tasks.append((ds_config.name, ds_path))
                else:
                    tasks.append((ds_config.name, ds_path))

            logger.info(
                "开始并行解析 %d 个数据源 (workers=%d), PAM 数据源 %d 个",
                len(tasks),
                self._datasource_workers,
                len(pam_tasks),
            )

            # ====== 数据源级并行执行 ======
            all_futures: dict = {}

            if self._registry is not None and tasks:
                for name, path in tasks:
                    future = self._executor.submit(self._registry.parse_directory, path)
                    all_futures[future] = name

            if self._pam_parser is not None and pam_tasks:
                for name, path in pam_tasks:
                    future = self._executor.submit(self._pam_parser.parse_directory, path)
                    all_futures[future] = name

            if all_futures:
                for future in as_completed(all_futures):
                    name = all_futures[future]
                    try:
                        output = future.result()
                        with self._result_lock:
                            self._merge_output_to_result(output, result)
                        summary = output.summary()
                        logger.info(
                            "数据源 %s 解析完成: %d 表, %d 血缘",
                            name,
                            summary["tables"],
                            summary["table_lineages"],
                        )
                    except Exception as e:
                        logger.error("数据源 %s 解析失败: %s", name, e, exc_info=True)
                        result.errors.append(f"数据源 {name}: {str(e)}")

            result.parse_time_sec = time.time() - start_time
            self._current_result = result
            self._current_data_cache = None  # 由 _save_result_to_cache 填充

            self._save_result_to_cache(result)
            self._event_bus.publish(EventType.DATA_CHANGED)
            self._event_bus.publish(EventType.PARSE_COMPLETED)
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
            self._event_bus.publish(EventType.PARSE_FAILED)

        return result

    def parse_uploaded_files(
        self,
        file_paths: list[Path],
        mode: str = "incremental",
        progress_callback=None,
    ) -> ParseResult:
        start_time = time.time()
        result = ParseResult()

        try:
            self._event_bus.publish(EventType.PARSE_STARTED)
            self.initialize_parsers()

            total_files = len(file_paths)
            logger.info("开始串行解析上传文件: 共 %d 个文件", total_files)

            if progress_callback:
                progress_callback(5, "", "初始化解析引擎...")

            for idx, file_path in enumerate(file_paths):
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
                    if self._registry is not None and self._registry.get_parser(file_path) is not None:
                        output = self._registry.parse_file(file_path)
                        self._merge_output_to_result(output, result)
                    elif file_path.suffix.lower() == ".tab":
                        self._parse_single_tab(file_path, result)
                    elif file_path.suffix.lower() == ".prc":
                        self._parse_single_prc(file_path, result)
                    else:
                        logger.warning("不支持的文件类型: %s", file_path.suffix)
                        result.errors.append(f"不支持的文件类型: {file_path.suffix}")

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
                with self._result_lock:
                    self._current_result.merge(result)
                    self._current_data_cache = None  # 数据变更，清除缓存
                self._save_result_to_cache(self._current_result)
            else:
                self._current_result = result
                self._current_data_cache = None
                self._save_result_to_cache(result)

            self._event_bus.publish(EventType.DATA_CHANGED)
            self._event_bus.publish(EventType.PARSE_COMPLETED)

            if progress_callback:
                progress_callback(100, "", "解析完成！")

            logger.info(
                "文件解析完成: %d 张表, %d 个过程, 耗时 %.2fs",
                len(self._current_result.tables),
                len(self._current_result.procedures),
                result.parse_time_sec,
            )

        except Exception as e:
            logger.error("文件解析异常: %s", e, exc_info=True)
            result.errors.append(f"解析异常: {str(e)}")
            self._event_bus.publish(EventType.PARSE_FAILED)
            if progress_callback:
                progress_callback(-1, "", f"解析失败: {str(e)}")

        return result

    def _get_repository(self) -> DataRepository:
        return self._cache_store.get_repository()

    def get_current_data(self) -> dict[str, Any] | None:
        # 优先返回缓存的 data dict，避免重复全量 to_serializable()
        if self._current_data_cache is not None:
            return self._current_data_cache
        if self._current_result is not None:
            # 惰性构建并缓存
            self._current_data_cache = self._current_result.to_serializable()
            return self._current_data_cache
        repo = self._get_repository()
        cached = repo.get_raw_data()
        if cached:
            self._current_data_cache = cached
            return cached
        # Fallback: 从存储后端加载（SQLite 或 legacy）
        data = self._cache_store.load_from_cache()
        if data:
            self._current_data_cache = data
            return data
        return None

    def get_table_list(self) -> list[dict]:
        if self._current_result is not None:
            return [t.to_dict() for t in self._current_result.tables]
        data = self.get_current_data()
        if data:
            return data.get("tables", [])
        return []

    def search_tables(self, keyword: str, limit: int = 50) -> list[dict]:
        if self._current_result is not None:
            return search_table_dicts([t.to_dict() for t in self._current_result.tables], keyword, limit)
        return self._get_repository().search_tables(keyword, limit)

    def get_procedure_list(self) -> list[dict]:
        if self._current_result is not None:
            return [p.to_dict() for p in self._current_result.procedures]
        data = self.get_current_data()
        if data:
            return data.get("procedures", [])
        return []

    def get_lineage_tracer(self) -> Any | None:
        if self._tracer_factory.lineage_tracer is not None:
            return self._tracer_factory.lineage_tracer

        try:
            if self._current_result is not None:
                result = self._current_result
                tables = {t.full_name: t for t in result.tables}
                procedures = {}
                for p in result.procedures:
                    procedures[p.full_name] = p
                    self._cached_procedures[p.full_name] = p
                return self._tracer_factory.create_lineage_tracer(
                    tables=tables,
                    procedures=procedures,
                    table_lineages=result.table_lineages,
                    field_mappings=result.field_mappings,
                )

            logger.warning("无可用的解析数据或缓存，无法构建 LineageTracer")
            return None

        except Exception as e:
            logger.error("构建 LineageTracer 失败: %s", e, exc_info=True)
            return None

    def get_caliber_tracer(self) -> Any | None:
        if self._tracer_factory.caliber_tracer is not None:
            return self._tracer_factory.caliber_tracer

        try:
            if self._current_result is not None:
                result = self._current_result
                tables = {t.full_name: t for t in result.tables}
                procedures = {}
                for p in result.procedures:
                    procedures[p.full_name] = p
                return self._tracer_factory.create_caliber_tracer(
                    tables=tables,
                    procedures=procedures,
                    table_lineages=result.table_lineages,
                    field_mappings=result.field_mappings,
                    caliber_infos=result.caliber_infos,
                )

            logger.warning("无可用的解析数据或缓存，无法构建 CaliberTracer")
            return None

        except Exception as e:
            logger.error("构建 CaliberTracer 失败: %s", e, exc_info=True)
            return None

    def get_unified_tracer(self) -> Any | None:
        """获取或懒加载 UnifiedTracer（P1 引入，P2 由 API 使用）。"""
        if self._tracer_factory.unified_tracer is not None:
            return self._tracer_factory.unified_tracer

        try:
            if self._current_result is not None:
                result = self._current_result
                tables = {t.full_name: t for t in result.tables}
                procedures = {p.full_name: p for p in result.procedures}
                return self._tracer_factory.create_unified_tracer(
                    tables=tables,
                    procedures=procedures,
                    table_lineages=result.table_lineages,
                    field_mappings=result.field_mappings,
                    caliber_infos=result.caliber_infos,
                )

            logger.warning("无可用的解析数据或缓存，无法构建 UnifiedTracer")
            return None

        except Exception as e:
            logger.error("构建 UnifiedTracer 失败: %s", e, exc_info=True)
            return None

    def clear_cache(self) -> None:
        self._current_data_cache = None
        self._cache_store.clear_cache()
        self._tracer_factory.invalidate()
        self._event_bus.publish(EventType.CACHE_INVALIDATED)

    def _parse_tab_directory(self, directory: Path, result: ParseResult) -> None:
        if not self._table_parser:
            return
        for file_path in directory.rglob("*.tab"):
            try:
                table_info = self._table_parser.parse_tab_file(str(file_path))
                if table_info:
                    result.tables.append(table_info)
            except Exception as e:
                logger.warning("解析 .tab 文件失败: %s - %s", file_path, e)
                result.errors.append(f"文件 {file_path.name}: {str(e)}")

    def _parse_proc_directory(self, directory: Path, result: ParseResult) -> None:
        if not self._proc_parser:
            return
        procedures = self._proc_parser.parse_directory(str(directory))
        self._cached_procedures.update(procedures)
        for proc_info in procedures.values():
            try:
                result.procedures.append(proc_info)
                result.table_lineages.extend(proc_info.table_lineages)
                result.field_mappings.extend(proc_info.field_mappings)
                caliber_infos = self._proc_parser.extract_caliber_from_proc(proc_info, data_source="oracle")
                for ci in caliber_infos:
                    result.caliber_infos.append(CaliberExtractor.to_dict(ci))
            except Exception as e:
                logger.warning("序列化过程信息失败: %s - %s", proc_info.full_name, e)
                result.errors.append(f"过程 {proc_info.full_name}: {str(e)}")

    def _parse_single_tab(self, file_path: Path, result: ParseResult) -> None:
        if not self._table_parser:
            return
        try:
            table_info = self._table_parser.parse_tab_file(str(file_path))
            if table_info:
                result.tables.append(table_info)
                logger.info("成功解析表: %s", table_info.full_name)
        except Exception as e:
            logger.error("解析文件失败: %s - %s", file_path, e)
            result.errors.append(f"文件 {file_path.name}: {str(e)}")

    def _parse_single_prc(self, file_path: Path, result: ParseResult) -> None:
        if not self._proc_parser:
            return
        try:
            proc_info = self._proc_parser.parse_prc_file(str(file_path))
            if not proc_info:
                logger.warning("文件解析无结果: %s", file_path)
                return

            result.procedures.append(proc_info)
            result.table_lineages.extend(proc_info.table_lineages)
            result.field_mappings.extend(proc_info.field_mappings)

            if self._proc_parser and CaliberExtractor is not None:
                caliber_infos = self._proc_parser.extract_caliber_from_proc(proc_info, data_source="oracle")
                for ci in caliber_infos:
                    result.caliber_infos.append(CaliberExtractor.to_dict(ci))

            logger.info("成功解析过程: %s", proc_info.full_name)

        except Exception as e:
            logger.error("解析过程文件失败: %s - %s", file_path, e)
            result.errors.append(f"文件 {file_path.name}: {str(e)}")

    def _save_result_to_cache(self, result: ParseResult) -> None:
        try:
            serializable = result.to_serializable()
            data = {
                "metadata": {
                    "total_tables": len(result.tables),
                    "total_procedures": len(result.procedures),
                    "total_table_lineages": len(result.table_lineages),
                    "total_field_mappings": len(result.field_mappings),
                    "total_caliber_infos": len(result.caliber_infos),
                    "parser_version": "unified-v1",
                    "data_sources": [ds.name for ds in config.datasource_configs] if config else [],
                },
                **serializable,
            }
            self._current_data_cache = data  # 同步填充 data cache，避免后续重复 to_serializable()
            self._cache_store.save_to_cache(data)
        except Exception as e:
            logger.error("保存缓存数据失败: %s", e)

    def _resolve_ds_path(self, data_dir: str) -> Path:
        path = Path(data_dir)
        if path.is_absolute():
            return path
        return self.data_dir.parent / path

    def _merge_output_to_result(self, output: ParseOutput, result: ParseResult) -> None:
        temp = ParseResult()
        temp.tables = [TableInfo.from_dict(t) for t in output.tables]
        temp.procedures = [ProcedureInfo.from_dict(p) for p in output.procedures]
        temp.table_lineages = [TableLineage.from_dict(tl) for tl in output.table_lineages]
        temp.field_mappings = [FieldMapping.from_dict(fm) for fm in output.field_mappings]
        temp.caliber_infos = output.caliber_infos
        temp.errors = output.errors
        result.merge(temp)
