"""
指标解析器适配器

将 IndicatorConfigParser 的输出转换为 ParseOutput 格式，
使指标体系的数据能够融入统一的血缘图谱。

适配器模式：IndicatorConfigParser 保持独立运行，
IndicatorAdapter 仅负责格式转换，不改变解析逻辑。
"""

from __future__ import annotations

import logging
from pathlib import Path

from core.layer_detector import LayerDetector
from core.parser_protocol import ParseOutput

logger = logging.getLogger(__name__)


def _split_comma_separated(name_str: str) -> list[str]:
    if not name_str:
        return []
    parts = [p.strip() for p in name_str.split(",")]
    return [p for p in parts if p]


class IndicatorAdapter:
    """指标解析器适配器 — 将 IndicatorConfigParser 输出转为 ParseOutput

    职责：
      1. 调用 IndicatorConfigParser 解析指标配置
      2. 将指标依赖关系转换为 TableLineage
      3. 将指标字段映射转换为 FieldMapping
      4. 将指标涉及的表注册到 tables 列表

    注意：
      IndicatorService 仍保留独立运行路径（含指标血缘图、指标流水线等），
      本适配器仅用于将指标数据融入统一血缘图谱。
    """

    def __init__(
        self,
        layer_detector: LayerDetector | None = None,
        system: str = "fdm",
    ):
        self._layer_detector = layer_detector or LayerDetector()
        self._system = system

    def supported_extensions(self) -> list[str]:
        return [".xlsx", ".proc"]

    def parse_file(self, file_path: Path) -> ParseOutput:
        return self.parse_directory(file_path.parent)

    def parse_directory(self, dir_path: Path) -> ParseOutput:
        if not dir_path.exists():
            return ParseOutput(errors=[f"目录不存在: {dir_path}"])

        try:
            from core.indicator_config_parser import IndicatorConfigParser
        except ImportError:
            logger.warning("IndicatorConfigParser 不可用，跳过指标适配")
            return ParseOutput(errors=["IndicatorConfigParser 模块不可用"])

        try:
            parser = IndicatorConfigParser(data_path=str(dir_path))
            result = parser.parse_all()
        except Exception as e:
            logger.error("指标配置解析失败: %s - %s", dir_path, e)
            return ParseOutput(errors=[f"指标配置解析失败: {str(e)}"])

        output = ParseOutput()

        seen_tables: set[str] = set()
        # ★ 优化：维护增量去重集合
        seen_lineage_keys: set[tuple] = set()

        for base_calc in result.base_calcs:
            target_table = getattr(base_calc, "trg_table_name", "")
            source_table_raw = getattr(base_calc, "src_table_name", "")

            if not target_table:
                continue

            self._register_table(target_table, output, seen_tables)

            source_tables = _split_comma_separated(source_table_raw)
            for source_table in source_tables:
                if source_table and source_table != target_table:
                    self._register_table(source_table, output, seen_tables)

                    key = (
                        source_table,
                        target_table,
                        getattr(base_calc, "procedure_name", ""),
                    )
                    if key not in seen_lineage_keys:
                        seen_lineage_keys.add(key)
                        output.table_lineages.append(
                            {
                                "source_table": source_table,
                                "target_table": target_table,
                                "procedure": getattr(base_calc, "procedure_name", ""),
                            }
                        )

            mappings = getattr(base_calc, "field_mappings", [])
            if mappings:
                for mapping in mappings:
                    src_col = getattr(mapping, "source_column", "")
                    tgt_col = getattr(mapping, "target_column", "")
                    expression = getattr(mapping, "expression", "")

                    if src_col or tgt_col:
                        for source_table in source_tables:
                            output.field_mappings.append(
                                {
                                    "source_table": source_table,
                                    "source_column": src_col,
                                    "target_table": target_table,
                                    "target_column": tgt_col,
                                    "transform_logic": expression,
                                    "procedure": getattr(base_calc, "procedure_name", ""),
                                    "confidence": 0.7,
                                }
                            )

        for rel in result.relations:
            src = getattr(rel, "source_table", "")
            tgt = getattr(rel, "target_table", "")
            proc = getattr(rel, "procedure_name", "")

            if src and tgt and src != tgt:
                key = (src, tgt, proc)
                if key not in seen_lineage_keys:
                    seen_lineage_keys.add(key)
                    output.table_lineages.append(
                        {
                            "source_table": src,
                            "target_table": tgt,
                            "procedure": proc,
                        }
                    )

                self._register_table(src, output, seen_tables)
                self._register_table(tgt, output, seen_tables)

        for proc_name, proc_info in result.procedures.items():
            src_tables = getattr(proc_info, "source_tables", [])
            tgt_tables = getattr(proc_info, "target_tables", [])

            for src in src_tables:
                for tgt in tgt_tables:
                    if src and tgt and src != tgt:
                        key = (src, tgt, proc_name)
                        # ★ 优化：使用 seen set 增量去重
                        if key not in seen_lineage_keys:
                            seen_lineage_keys.add(key)
                            output.table_lineages.append(
                                {
                                    "source_table": src,
                                    "target_table": tgt,
                                    "procedure": proc_name,
                                }
                            )

        summary = output.summary()
        logger.info(
            "IndicatorAdapter: %d 表, %d 血缘, %d 字段映射 (system=%s)",
            summary["tables"],
            summary["table_lineages"],
            summary["field_mappings"],
            self._system,
        )

        return output

    def _register_table(
        self,
        table_name: str,
        output: ParseOutput,
        seen: set[str],
    ) -> None:
        if not table_name or table_name in seen:
            return

        seen.add(table_name)

        layer = self._layer_detector.detect_layer(table_name, system=self._system)
        layer_config = self._layer_detector.get_layer_config(self._system)
        default_schema = layer_config.default_schema

        if "." in table_name:
            schema, name = table_name.split(".", 1)
        else:
            schema = default_schema
            name = table_name

        output.tables.append(
            {
                "full_name": f"{schema}.{name}" if schema else name,
                "schema": schema,
                "table_name": name,
                "comment": "",
                "columns": [],
                "primary_keys": [],
                "layer": layer.value if hasattr(layer, "value") else str(layer),
            }
        )
