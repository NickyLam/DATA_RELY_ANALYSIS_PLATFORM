"""
Oracle .prc 文件解析器适配器
将 EnhancedProcedureParser 适配为 FileParser Protocol，无需修改原始代码。
"""

from __future__ import annotations

import logging
from pathlib import Path

from core.caliber_extractor import CaliberExtractor
from core.parser_protocol import ParseOutput
from core.procedure_parser import EnhancedProcedureParser

logger = logging.getLogger(__name__)


class OraclePrcAdapter:
    """适配 EnhancedProcedureParser → FileParser Protocol

    将 EnhancedProcedureParser 的返回值（ProcedureInfo 对象）
    转换为 ParseOutput 的 dict 列表格式，与 ParserService.ParseResult 对齐。
    """

    def __init__(self, proc_parser: EnhancedProcedureParser):
        self._parser = proc_parser

    def supported_extensions(self) -> list[str]:
        return [".prc"]

    def parse_file(self, file_path: Path) -> ParseOutput:
        """解析单个 .prc 文件"""
        proc_info = self._parser.parse_prc_file(str(file_path))
        if proc_info is None:
            return ParseOutput()

        return self._proc_info_to_output(proc_info)

    def parse_directory(self, dir_path: Path) -> ParseOutput:
        """递归解析目录下所有 .prc 文件"""
        output = ParseOutput()

        if not dir_path.exists() or not dir_path.is_dir():
            output.errors.append(f"目录不存在或不是目录: {dir_path}")
            return output

        procedures = self._parser.parse_directory(str(dir_path))

        for proc_info in procedures.values():
            try:
                proc_output = self._proc_info_to_output(proc_info)
                output.merge(proc_output)
            except Exception as e:
                logger.warning("序列化过程信息失败: %s - %s", proc_info.full_name, e)
                output.errors.append(f"过程 {proc_info.full_name}: {str(e)}")

        logger.info(
            "OraclePrcAdapter: 解析目录 %s, 共 %d 个过程, %d 条血缘",
            dir_path, len(output.procedures), len(output.table_lineages),
        )
        return output

    def _proc_info_to_output(self, proc_info) -> ParseOutput:
        """将 ProcedureInfo 转换为 ParseOutput（对齐 ParserService 的序列化逻辑）"""
        output = ParseOutput()

        # 过程基本信息
        proc_dict = {
            "full_name": proc_info.full_name,
            "schema": proc_info.schema,
            "proc_name": proc_info.proc_name,
            "description": proc_info.description,
            "source_tables": proc_info.source_tables,
            "target_tables": proc_info.target_tables,
            "config_tables": getattr(proc_info, "config_tables", []),
        }
        output.procedures.append(proc_dict)

        # 表级血缘
        for tl in proc_info.table_lineages:
            output.table_lineages.append({
                "source_table": tl.source_table,
                "target_table": tl.target_table,
                "procedure": tl.procedure,
            })

        # 字段映射
        for fm in proc_info.field_mappings:
            output.field_mappings.append({
                "source_table": fm.source_table,
                "source_column": fm.source_column,
                "target_table": fm.target_table,
                "target_column": fm.target_column,
                "transform_logic": fm.transform_logic,
                "procedure": fm.procedure,
                "confidence": fm.confidence,
            })

        # 口径信息
        try:
            caliber_infos = self._parser.extract_caliber_from_proc(
                proc_info, data_source="oracle"
            )
            for ci in caliber_infos:
                output.caliber_infos.append(CaliberExtractor.to_dict(ci))
        except Exception as e:
            logger.debug("口径提取失败: %s - %s", proc_info.full_name, e)

        return output
