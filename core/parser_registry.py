"""
解析器注册表
文件扩展名 → 解析器实例 的路由分发中心。
新增文件类型只需 register() 即可，无需修改已有代码。
"""

from __future__ import annotations

import logging
from pathlib import Path
from typing import Optional

from core.parser_protocol import FileParser, ParseOutput

logger = logging.getLogger(__name__)


class ParserRegistry:
    """文件扩展名 → 解析器实例 的路由注册表

    用法:
        registry = ParserRegistry()
        registry.register(OracleTabAdapter(table_parser))
        registry.register(OraclePrcAdapter(proc_parser))
        registry.register(WarehouseSQLParser(schema_resolver))

        # 按文件类型自动路由
        output = registry.parse_file(Path("some_file.sql"))
        output = registry.parse_directory(Path("some_dir/"))
    """

    def __init__(self):
        self._parsers: dict[str, FileParser] = {}
        self._extension_map: dict[str, str] = {}  # ext → parser name (for logging)

    def register(self, parser: FileParser) -> None:
        """注册解析器

        Args:
            parser: 实现 FileParser Protocol 的解析器实例

        Raises:
            ValueError: 如果某个扩展名已被其他解析器注册
        """
        parser_name = type(parser).__name__
        for ext in parser.supported_extensions():
            ext_lower = ext.lower()
            if ext_lower in self._parsers:
                existing = self._extension_map[ext_lower]
                raise ValueError(
                    f"扩展名 {ext_lower} 已被 {existing} 注册，"
                    f"无法再注册 {parser_name}"
                )
            self._parsers[ext_lower] = parser
            self._extension_map[ext_lower] = parser_name

        logger.info(
            "注册解析器 %s: %s",
            parser_name,
            ", ".join(parser.supported_extensions()),
        )

    def get_parser(self, file_path: Path) -> Optional[FileParser]:
        """根据文件扩展名获取对应的解析器

        Args:
            file_path: 文件路径

        Returns:
            对应的解析器实例，无匹配则返回 None
        """
        return self._parsers.get(file_path.suffix.lower())

    def parse_file(self, file_path: Path) -> ParseOutput:
        """解析单个文件（自动路由到对应解析器）

        Args:
            file_path: 文件路径

        Returns:
            ParseOutput 统一产出
        """
        parser = self.get_parser(file_path)
        if parser is None:
            ext = file_path.suffix.lower()
            supported = ", ".join(sorted(self._parsers.keys())) or "无"
            logger.warning(
                "无可用的解析器处理文件 %s (扩展名: %s)，已注册: %s",
                file_path.name, ext, supported,
            )
            return ParseOutput(errors=[f"不支持的文件类型: {ext}"])

        try:
            return parser.parse_file(file_path)
        except Exception as e:
            logger.error("解析文件失败: %s - %s", file_path, e, exc_info=True)
            return ParseOutput(errors=[f"文件 {file_path.name}: {str(e)}"])

    def parse_directory(self, dir_path: Path) -> ParseOutput:
        """递归解析目录下所有支持的文件（自动路由到对应解析器）

        按扩展名分组文件，每组调用对应解析器的 parse_directory。
        对于解析器不支持批量目录解析的场景，回退到逐文件解析。

        Args:
            dir_path: 目录路径

        Returns:
            ParseOutput 合并后的统一产出
        """
        if not dir_path.exists():
            logger.warning("目录不存在: %s", dir_path)
            return ParseOutput(errors=[f"目录不存在: {dir_path}"])

        if not dir_path.is_dir():
            logger.warning("路径不是目录: %s", dir_path)
            return ParseOutput(errors=[f"路径不是目录: {dir_path}"])

        # 按解析器分组扫描文件
        parser_files: dict[FileParser, list[Path]] = {}
        skipped_extensions: set[str] = set()

        for file_path in dir_path.rglob("*"):
            if not file_path.is_file():
                continue
            ext = file_path.suffix.lower()
            parser = self._parsers.get(ext)
            if parser is not None:
                parser_files.setdefault(parser, []).append(file_path)
            else:
                skipped_extensions.add(ext)

        if skipped_extensions:
            logger.info(
                "跳过不支持的文件类型: %s",
                ", ".join(sorted(skipped_extensions)),
            )

        if not parser_files:
            logger.info("目录 %s 中无支持的文件", dir_path)
            return ParseOutput()

        # 按解析器分别处理（优先使用解析器自身的 parse_directory）
        total_output = ParseOutput()
        total_files = sum(len(files) for files in parser_files.values())

        logger.info(
            "开始解析目录 %s: %d 个文件, %d 个解析器",
            dir_path, total_files, len(parser_files),
        )

        for parser, files in parser_files.items():
            parser_name = type(parser).__name__
            exts = ", ".join(parser.supported_extensions())
            logger.info(
                "解析器 %s (%s): 处理 %d 个文件",
                parser_name, exts, len(files),
            )

            try:
                output = parser.parse_directory(dir_path)
                total_output.merge(output)
            except Exception as e:
                logger.warning(
                    "解析器 %s.parse_directory 失败，回退逐文件解析: %s",
                    parser_name, e,
                )
                for file_path in files:
                    try:
                        output = parser.parse_file(file_path)
                        total_output.merge(output)
                    except Exception as fe:
                        logger.error("解析文件失败: %s - %s", file_path, fe)
                        total_output.errors.append(f"文件 {file_path.name}: {str(fe)}")

        summary = total_output.summary()
        logger.info(
            "目录 %s 解析完成: %d 表, %d 过程, %d 血缘, %d 字段映射, %d 错误",
            dir_path,
            summary["tables"],
            summary["procedures"],
            summary["table_lineages"],
            summary["field_mappings"],
            summary["errors"],
        )

        return total_output

    def supported_extensions(self) -> list[str]:
        """所有已注册的扩展名列表"""
        return sorted(self._parsers.keys())

    def is_registered(self, ext: str) -> bool:
        """检查扩展名是否已注册"""
        return ext.lower() in self._parsers

    def __repr__(self) -> str:
        entries = [
            f"{ext} → {name}"
            for ext, name in sorted(self._extension_map.items())
        ]
        return f"ParserRegistry({', '.join(entries)})"
