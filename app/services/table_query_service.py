"""
表查询服务
封装表/存储过程搜索、字段获取、系统统计等查询功能
"""

from __future__ import annotations

from typing import Any

from app.services.index_service import IndexService
from app.services.index_snapshot import IndexSnapshot
from app.services.parser_service import ParserService
from app.services.system_membership import (
    build_schema_to_system,
    normalize_data_source,
    table_belongs_to_system,
    table_system_name,
)
from app.utils.cache_manager import CacheManager
from core.table_name_resolver import TableNameResolver


class TableQueryService:
    """表信息查询服务（从 LineageService 拆分）"""

    def __init__(
        self,
        parser_service: ParserService,
        cache_manager: CacheManager,
        index_service: IndexService | None = None,
    ):
        self._parser = parser_service
        self._cache = cache_manager
        self._index_service = index_service
        self._resolver = TableNameResolver()

    def _capture_snapshot(self) -> IndexSnapshot | None:
        """兼容 U5 composition 接线前的无 owner 构造，不回退 live parser。"""
        if self._index_service is None:
            return None
        return self._index_service.capture_snapshot()

    def search_tables(
        self,
        keyword: str,
        limit: int = 50,
    ) -> list[dict]:
        """
        搜索表名（智能排序 - 精确匹配优先）

        排序优先级（从高到低）：
        1. 短名完全匹配（如 EAST5_201_GRJCXXB == EAST5_201_GRJCXXB）
        2. 全名以关键词结尾（如 RRP_MDL.EAST5_201_GRJCXXB）
        3. 包含匹配（如 T_COM_RRP_EAST_EAST5_201_GRJCXXB）
        """
        snapshot = self._capture_snapshot()
        if snapshot is None:
            return []
        return self._format_table_search_results(snapshot.search_tables(keyword, limit), limit)

    def _format_table_search_results(self, table_results: list[dict], limit: int) -> list[dict]:
        tables = []
        seen = set()

        for table_info in table_results[:limit]:
            name = table_info.get("full_name", "")
            if not name or name in seen:
                continue

            seen.add(name)
            short = table_info.get("table_name") or (name.split(".")[-1] if "." in name else name)
            columns = [column.get("name", "") for column in table_info.get("columns", []) if column.get("name")]

            tables.append(
                {
                    "full_name": name,
                    "short_name": short,
                    "layer": self._detect_layer(name),
                    "field_count": len(columns),
                    "columns": columns if columns else None,
                }
            )

        return tables

    def search_procedures(
        self,
        keyword: str,
        limit: int = 50,
    ) -> list[dict]:
        """搜索存储过程名称"""
        snapshot = self._capture_snapshot()
        if snapshot is None:
            return []
        results = snapshot.search_procedures(keyword, limit)

        procedures = []
        seen = set()
        for procedure in results[:limit]:
            name = procedure.get("full_name", "")
            if not name:
                continue
            if name not in seen:
                seen.add(name)
                short = name.split(".")[-1] if "." in name else name
                procedures.append({"full_name": name, "short_name": short})

        return procedures

    def get_table_fields(self, table: str) -> list[str] | None:
        """获取指定表的字段名列表。

        查找策略：
        1. 精确匹配 .tab 表（table_name 或 full_name）
        2. 从字段映射中查找过程表（短名或全名）
        3. 模糊匹配过程表
        """
        snapshot = self._capture_snapshot()
        if snapshot is None:
            return None
        data = snapshot.get_source_data()

        norm_name = table.strip().upper()

        # 1. 精确匹配 .tab 表
        for t in data.get("tables", []):
            tbl_name = (t.get("table_name") or "").upper()
            full_name = (t.get("full_name") or "").upper()
            if tbl_name == norm_name or full_name == norm_name:
                columns = t.get("columns", [])
                return [c.get("name", "") for c in columns if c.get("name")]

        # 2. 从字段映射中查找过程表（按 target_table 聚合字段名）
        field_mappings = data.get("field_mappings", [])
        proc_fields: dict[str, set[str]] = {}
        for fm in field_mappings:
            tgt_table = (fm.get("target_table") or "").upper()
            tgt_col = fm.get("target_column", "")
            if tgt_table and tgt_col:
                proc_fields.setdefault(tgt_table, set()).add(tgt_col)

        for proc_tbl, fields in proc_fields.items():
            short = proc_tbl.split(".")[-1] if "." in proc_tbl else proc_tbl
            if short == norm_name or proc_tbl == norm_name:
                return sorted(fields)

        # 3. 模糊匹配过程表
        for proc_tbl, fields in proc_fields.items():
            if norm_name in proc_tbl or proc_tbl.endswith(norm_name):
                return sorted(fields)

        return None

    def get_table_info(self, table: str) -> dict | None:
        """获取指定表的详细结构信息。"""
        snapshot = self._capture_snapshot()
        if snapshot is None:
            return None

        table_upper = table.upper()
        for table_info in snapshot.get_source_data().get("tables", []):
            if table_info.get("full_name", "").upper() == table_upper:
                return table_info
        return None

    def get_system_stats(self) -> dict[str, Any]:
        """获取系统统计信息"""
        snapshot = self._capture_snapshot()
        data = snapshot.get_source_data() if snapshot is not None else None

        base_stats = {
            "total_tables": 0,
            "total_procedures": 0,
            "total_table_lineages": 0,
            "total_field_mappings": 0,
            "total_caliber_infos": 0,
            "cache_size": 0,
            "active_tasks": 0,
            "uptime_seconds": 0.0,
        }

        if data:
            metadata = data.get("metadata", {})
            base_stats.update(
                {
                    "total_tables": metadata.get("total_tables", 0),
                    "total_procedures": metadata.get("total_procedures", 0),
                    "total_table_lineages": metadata.get("total_table_lineages", 0),
                    "total_field_mappings": metadata.get("total_field_mappings", 0),
                    "total_caliber_infos": metadata.get("total_caliber_infos", 0),
                }
            )

        base_stats["cache_size"] = self._cache.size

        return base_stats

    def get_runtime_stats(self) -> dict[str, Any]:
        """返回 system API 所需的同代运行态查询统计。"""
        snapshot = self._capture_snapshot()
        if snapshot is None:
            return {
                "loaded": False,
                "tables": 0,
                "procedures": 0,
                "lineages": 0,
                "index_status": "empty",
            }

        data = snapshot.get_source_data()
        metadata = data.get("metadata", {})
        return {
            "loaded": bool(data),
            "tables": metadata.get("total_tables", 0),
            "procedures": metadata.get("total_procedures", 0),
            "lineages": metadata.get("total_table_lineages", 0),
            "index_status": "ready" if snapshot.is_ready else "empty",
        }

    # --- 级联查询方法（系统→Schema→表）---

    @staticmethod
    def _build_schema_to_system(data: dict[str, Any]) -> dict[str, str]:
        """构建 schema_name → system_name 映射。

        每次调用时从数据和配置中重新计算，确保数据刷新后映射正确。
        """
        all_tables = data.get("tables", [])
        return build_schema_to_system(all_tables)

    def get_systems(self) -> list[dict]:
        """返回所有启用的数据源列表（含表计数）。"""
        from app.config import config

        snapshot = self._capture_snapshot()
        data = snapshot.get_source_data() if snapshot is not None else {}
        all_tables = data.get("tables", [])

        schema_to_system = self._build_schema_to_system(data)

        # 统计每个系统的表数
        system_table_counts: dict[str, int] = {c.name: 0 for c in config.datasource_configs if c.enabled}

        for t in all_tables:
            if not (t.get("full_name") or ""):
                continue

            sys_name = table_system_name(t, schema_to_system)
            if sys_name in system_table_counts:
                system_table_counts[sys_name] = system_table_counts.get(sys_name, 0) + 1

        result = []
        for ds_cfg in config.datasource_configs:
            if not ds_cfg.enabled:
                continue
            result.append(
                {
                    "name": ds_cfg.name,
                    "display_name": ds_cfg.display_name,
                    "table_count": system_table_counts.get(ds_cfg.name, 0),
                }
            )
        return result

    def get_schemas(self, system: str) -> list[dict]:
        """返回指定系统下的 schema 列表（含表计数）。"""
        from app.config import config

        snapshot = self._capture_snapshot()
        data = snapshot.get_source_data() if snapshot is not None else {}
        all_tables = data.get("tables", [])

        ds_cfg = next((c for c in config.datasource_configs if c.name == system), None)
        if not ds_cfg:
            return []

        schema_to_system = self._build_schema_to_system(data)

        # 从数据中提取所有 schema 及其表计数
        system_schemas: dict[str, int] = {}
        unclassified_count = 0

        for t in all_tables:
            full_name = t.get("full_name") or ""
            if not full_name:
                continue

            data_source = self._normalize_data_source(t.get("data_source"))
            if data_source and data_source != system:
                continue

            if "." in full_name:
                schema = full_name.split(".")[0].upper()
                # 检查该 schema 是否属于该系统
                mapped_system = data_source or schema_to_system.get(schema)
                if mapped_system == system:
                    system_schemas[schema] = system_schemas.get(schema, 0) + 1
            else:
                # 无 schema 的表归属数仓系统
                if data_source == system or (not data_source and ds_cfg.parser != "oracle"):
                    unclassified_count += 1

        # 构建结果
        result = []
        for schema_name, count in sorted(system_schemas.items()):
            result.append(
                {
                    "schema_name": schema_name,
                    "table_count": count,
                }
            )

        # 未分类表
        if unclassified_count > 0:
            result.append(
                {
                    "schema_name": "__unclassified__",
                    "table_count": unclassified_count,
                }
            )

        return result

    def get_tables_by_system(
        self,
        system_name: str,
        keyword: str = "",
    ) -> list[dict]:
        """返回指定系统下所有表（跨 schema 聚合）。

        用于三级级联查询（系统→表→字段），不区分 schema。
        """
        from app.config import config

        snapshot = self._capture_snapshot()
        data = snapshot.get_source_data() if snapshot is not None else {}
        all_tables = data.get("tables", [])

        ds_cfg = next((c for c in config.datasource_configs if c.name == system_name), None)
        if not ds_cfg:
            return []

        schema_to_system = self._build_schema_to_system(data)

        keyword_upper = keyword.upper() if keyword else ""

        tables = []
        for t in all_tables:
            full_name = t.get("full_name", "")
            if not full_name:
                continue

            if not table_belongs_to_system(t, system_name, schema_to_system):
                continue

            short_name = full_name.split(".")[-1] if "." in full_name else full_name

            # 关键词过滤
            if keyword_upper and keyword_upper not in full_name.upper() and keyword_upper not in short_name.upper():
                continue

            columns = [c.get("name", "") for c in t.get("columns", []) if c.get("name")]

            tables.append(
                {
                    "full_name": full_name,
                    "short_name": short_name,
                    "layer": self._detect_layer(full_name),
                    "field_count": len(columns),
                }
            )

        return tables

    def get_tables_by_schema(
        self,
        system: str,
        schema: str,
        keyword: str = "",
    ) -> list[dict]:
        """返回指定系统+schema 下的表列表。"""
        from app.config import config

        snapshot = self._capture_snapshot()
        data = snapshot.get_source_data() if snapshot is not None else {}
        all_tables = data.get("tables", [])

        ds_cfg = next((c for c in config.datasource_configs if c.name == system), None)
        if not ds_cfg:
            return []

        schema_to_system = self._build_schema_to_system(data)

        keyword_upper = keyword.upper() if keyword else ""

        tables = []
        for t in all_tables:
            full_name = t.get("full_name", "")
            if not full_name:
                continue

            data_source = self._normalize_data_source(t.get("data_source"))
            if data_source and data_source != system:
                continue

            # 确定 schema
            if "." in full_name:  # noqa: SIM108
                table_schema = full_name.split(".")[0].upper()
            else:
                table_schema = "__unclassified__"

            # 检查该表是否属于该系统
            if schema == "__unclassified__":
                # 未分类：只有无 schema 前缀的表
                if "." in full_name:
                    continue
                # 且系统应该是数仓类
                if ds_cfg.parser == "oracle":
                    continue
            else:
                # 有 schema 的表：检查系统归属
                mapped_system = data_source or schema_to_system.get(table_schema)
                if mapped_system != system:
                    continue
                # 检查 schema 匹配
                if table_schema != schema.upper():
                    continue

            short_name = full_name.split(".")[-1] if "." in full_name else full_name

            # 关键词过滤
            if keyword_upper and keyword_upper not in full_name.upper() and keyword_upper not in short_name.upper():
                continue

            columns = [c.get("name", "") for c in t.get("columns", []) if c.get("name")]

            tables.append(
                {
                    "full_name": full_name,
                    "short_name": short_name,
                    "layer": self._detect_layer(full_name),
                    "field_count": len(columns),
                }
            )

        return tables

    @staticmethod
    def _normalize_data_source(value: Any) -> str:
        return normalize_data_source(value)

    @staticmethod
    def _detect_layer(table_name: str) -> str:
        """检测表所属层级"""
        from core.layer_detector import detect_layer_str

        return detect_layer_str(table_name)
