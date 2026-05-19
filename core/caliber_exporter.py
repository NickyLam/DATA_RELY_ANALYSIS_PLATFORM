"""口径文档导出引擎

将口径追溯结果导出为 Markdown 或 HTML 格式文档，
可直接用于需求设计文档、数据字典等场景。
"""

from __future__ import annotations

import html
import logging
from typing import Any, Optional

logger = logging.getLogger(__name__)


class CaliberExporter:
    """口径文档导出引擎

    支持导出格式:
      - Markdown: 结构化文档，可直接贴入设计文档
      - HTML: 带样式的可读文档
    """

    def export_markdown(
        self,
        summary_card: dict,
        pipeline_view: Optional[dict] = None,
        step_details: Optional[list[dict]] = None,
        include_sql: bool = True,
        include_source_location: bool = True,
    ) -> str:
        """导出为 Markdown 格式文档。

        Args:
            summary_card: build_summary_card() 返回的 data 字段
            pipeline_view: build_pipeline_view() 返回的 data 字段 (可选)
            step_details: build_step_detail() 返回的 data 字段列表 (可选)
            include_sql: 是否包含原始 SQL
            include_source_location: 是否包含源码定位信息
        """
        lines: list[str] = []

        # 标题
        indicator = summary_card.get("indicator", "UNKNOWN")
        lines.append(f"# 指标口径规格：{indicator}")
        lines.append("")

        # 概览信息
        indicator_short = summary_card.get("indicator_short", "")
        if indicator_short:
            lines.append(f"**短标识**: `{indicator_short}`")
            lines.append("")

        business_caliber = summary_card.get("business_caliber", "")
        if business_caliber:
            lines.append(f"**业务口径**: {business_caliber}")
            lines.append("")

        tech_summary = summary_card.get("technical_caliber_summary", "")
        if tech_summary:
            lines.append("## 技术口径摘要")
            lines.append("")
            lines.append(f"> {tech_summary}")
            lines.append("")

        # 统计信息
        stats = summary_card.get("stats", {})
        if stats:
            lines.append("## 链路统计")
            lines.append("")
            lines.append(f"| 指标 | 值 |")
            lines.append(f"|------|-----|")
            lines.append(f"| 并行路径数 | {stats.get('parallel_paths', 0)} |")
            lines.append(f"| 总步骤数 | {stats.get('total_steps', 0)} |")
            lines.append(f"| 涉及存储过程数 | {stats.get('procedures_count', 0)} |")
            lines.append(f"| 涉及表数 | {stats.get('tables_count', 0)} |")
            tables = stats.get("tables", [])
            if tables:
                lines.append(f"| 涉及表 | {', '.join(f'`{t}`' for t in tables)} |")
            custom_funcs = stats.get("custom_functions", [])
            if custom_funcs:
                lines.append(f"| 自定义函数 | {', '.join(f'`{f}`' for f in custom_funcs)} |")
            lines.append("")

        # 数据质量标记
        quality = summary_card.get("data_quality_flags", {})
        if quality:
            lines.append("## 数据质量标记")
            lines.append("")
            flags = []
            if quality.get("has_hardcoded_values"):
                flags.append("⚠️ 包含硬编码值")
            if quality.get("has_cross_schema_join"):
                flags.append("⚠️ 存在跨 Schema JOIN")
            if quality.get("has_null_branch"):
                flags.append("ℹ️ 包含 NULL 分支 (NVL/COALESCE)")
            if quality.get("has_custom_function"):
                flags.append("⚠️ 使用自定义函数")
            if flags:
                for f in flags:
                    lines.append(f"- {f}")
            else:
                lines.append("- ✅ 无特殊标记")
            lines.append("")

        # 加工链路
        chain_text = summary_card.get("caliber_chain_text", [])
        if chain_text:
            lines.append("## 加工链路")
            lines.append("")
            for i, text in enumerate(chain_text, 1):
                if text.strip():
                    lines.append(f"{i}. {text}")
            lines.append("")

        # Pipeline 概览
        if pipeline_view:
            lines.append("## Pipeline 概览")
            lines.append("")
            nodes = pipeline_view.get("nodes", [])
            edges = pipeline_view.get("edges", [])
            branches = pipeline_view.get("branches", [])
            layer_order = pipeline_view.get("layer_order", [])

            if layer_order:
                lines.append(f"**数据流向**: {' → '.join(layer_order)}")
                lines.append("")

            lines.append(f"**节点数**: {len(nodes)}  |  **边数**: {len(edges)}  |  **分支数**: {len(branches)}")
            lines.append("")

            if nodes:
                lines.append("### 节点列表")
                lines.append("")
                lines.append("| 节点 | 分层 | 类型 |")
                lines.append("|------|------|------|")
                for node in nodes:
                    node_type = []
                    if node.get("is_source"):
                        node_type.append("源头")
                    if node.get("is_target"):
                        node_type.append("目标")
                    if node.get("is_internal_transform"):
                        node_type.append("内部转换")
                    type_str = "/".join(node_type) if node_type else "中间"
                    lines.append(f"| `{node.get('id', '')}` | {node.get('layer', '')} | {type_str} |")
                lines.append("")

        # 逐步骤详情
        if step_details:
            lines.append("## 逐步骤详情")
            lines.append("")
            for detail in step_details:
                step_num = detail.get("step_num", 0)
                src = detail.get("source_table", "")
                tgt = detail.get("target_table", "")
                src_short = src.split(".")[-1] if "." in src else src
                tgt_short = tgt.split(".")[-1] if "." in tgt else tgt

                lines.append(f"### 步骤 {step_num}: {src_short} → {tgt_short}")
                lines.append("")

                op_type = detail.get("operation_type", "")
                if op_type:
                    lines.append(f"- **操作类型**: {op_type}")

                proc = detail.get("procedure", "")
                if proc:
                    lines.append(f"- **所属脚本**: `{proc}`")

                if include_source_location:
                    loc = detail.get("source_code_location", {})
                    fp = loc.get("file_path", "")
                    sl = loc.get("start_line", 0)
                    el = loc.get("end_line", 0)
                    if fp:
                        lines.append(f"- **源码定位**: `{fp}:{sl}-{el}`")

                lines.append("")

                # 目标字段表达式
                exprs = detail.get("target_field_expressions", [])
                if exprs:
                    lines.append("**目标字段表达式**:")
                    lines.append("")
                    for expr in exprs:
                        tgt_col = expr.get("target_column", "")
                        expression = expr.get("expression", "")
                        is_custom = expr.get("is_custom_function", False)
                        marker = " ⚠️" if is_custom else ""
                        if expression and expression.upper() != tgt_col.upper():
                            lines.append(f"- `{tgt_col}` = `{expression}`{marker}")
                        else:
                            lines.append(f"- `{tgt_col}` (直接映射)")
                    lines.append("")

                # 步骤级隔离条件
                iso_where = detail.get("step_isolated_where", [])
                if iso_where:
                    lines.append("**本步筛选条件**:")
                    lines.append("")
                    for w in iso_where:
                        lines.append(f"- {w.get('raw_text', '')}")
                    lines.append("")

                iso_join = detail.get("step_isolated_join", [])
                if iso_join:
                    lines.append("**本步 JOIN 关系**:")
                    lines.append("")
                    for j in iso_join:
                        lines.append(f"- {j.get('raw_text', '')}")
                    lines.append("")

                # CTE
                ctes = detail.get("cte_definitions", [])
                if ctes:
                    lines.append("<details><summary>CTE / 临时表</summary>")
                    lines.append("")
                    for cte in ctes:
                        lines.append(f"**{cte.get('name', '')}**:")
                        lines.append(f"```sql\n{cte.get('definition', '')}\n```")
                        lines.append("")
                    lines.append("</details>")
                    lines.append("")

                # 自定义函数
                custom_funcs = detail.get("custom_functions", [])
                if custom_funcs:
                    lines.append("**自定义函数**:")
                    lines.append("")
                    for cf in custom_funcs:
                        risk = cf.get("migration_risk", "LOW")
                        note = cf.get("risk_note", "")
                        risk_icon = "🔴" if risk == "HIGH" else "🟡" if risk == "MEDIUM" else "🟢"
                        lines.append(f"- {risk_icon} `{cf.get('name', '')}` [{risk}] {note}")
                    lines.append("")

                # 原始 SQL
                if include_sql:
                    raw_sql = detail.get("raw_sql", "")
                    if raw_sql:
                        lines.append("<details><summary>原始 SQL</summary>")
                        lines.append("")
                        lines.append("```sql")
                        lines.append(raw_sql)
                        lines.append("```")
                        lines.append("")
                        lines.append("</details>")
                        lines.append("")

                lines.append("---")
                lines.append("")

        # 文档尾部
        lines.append("---")
        lines.append("")
        lines.append(f"*生成时间: {self._timestamp()}*")
        lines.append(f"*数据血缘分析系统 v2.1.0*")

        return "\n".join(lines)

    def export_html(
        self,
        summary_card: dict,
        pipeline_view: Optional[dict] = None,
        step_details: Optional[list[dict]] = None,
        include_sql: bool = True,
        include_source_location: bool = True,
    ) -> str:
        """导出为 HTML 格式文档。"""
        md = self.export_markdown(
            summary_card=summary_card,
            pipeline_view=pipeline_view,
            step_details=step_details,
            include_sql=include_sql,
            include_source_location=include_source_location,
        )
        # 将 Markdown 转换为简易 HTML
        body = self._md_to_html(md)
        return self._html_template(body, title=summary_card.get("indicator", "口径文档"))

    # ===================================================================
    # 内部工具
    # ===================================================================

    @staticmethod
    def _timestamp() -> str:
        from datetime import datetime
        return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    @staticmethod
    def _md_to_html(md_text: str) -> str:
        """简易 Markdown → HTML 转换（仅覆盖文档中使用的语法）。"""
        lines = md_text.split("\n")
        html_lines: list[str] = []
        in_table = False
        in_code_block = False
        in_details = False

        for line in lines:
            # 代码块
            if line.startswith("```"):
                if in_code_block:
                    html_lines.append("</code></pre>")
                    in_code_block = False
                else:
                    html_lines.append('<pre><code class="language-sql">')
                    in_code_block = True
                continue

            if in_code_block:
                html_lines.append(html.escape(line))
                continue

            # HTML details 标签 (直接透传)
            if line.startswith("<details>") or line.startswith("</details>"):
                if line.startswith("<details>"):
                    in_details = True
                    html_lines.append("<details>")
                else:
                    in_details = False
                    html_lines.append("</details>")
                continue
            if line.startswith("<summary>"):
                html_lines.append(line)  # 直接透传
                continue
            if in_details and line.strip():
                # details 内部内容
                html_lines.append(f"<p>{CaliberExporter._inline_md(line)}</p>")
                continue

            # 标题
            if line.startswith("# "):
                html_lines.append(f"<h1>{html.escape(line[2:])}</h1>")
                continue
            if line.startswith("## "):
                html_lines.append(f"<h2>{html.escape(line[3:])}</h2>")
                continue
            if line.startswith("### "):
                html_lines.append(f"<h3>{html.escape(line[4:])}</h3>")
                continue

            # 水平线
            if line.strip() == "---":
                html_lines.append("<hr>")
                continue

            # 表格
            if line.startswith("|") and "|" in line[1:]:
                cells = [c.strip() for c in line.strip("|").split("|")]
                if all(set(c) <= {"-", ":"} for c in cells):
                    # 分隔行，跳过
                    continue
                tag = "th" if not in_table else "td"
                row = "".join(f"<{tag}>{CaliberExporter._inline_md(c)}</{tag}>" for c in cells)
                if not in_table:
                    html_lines.append("<table><thead><tr>" + row + "</tr></thead><tbody>")
                    in_table = True
                else:
                    html_lines.append("<tr>" + row + "</tr>")
                continue
            elif in_table:
                html_lines.append("</tbody></table>")
                in_table = False

            # 引用
            if line.startswith("> "):
                html_lines.append(f"<blockquote>{CaliberExporter._inline_md(line[2:])}</blockquote>")
                continue

            # 列表
            if line.startswith("- "):
                html_lines.append(f"<li>{CaliberExporter._inline_md(line[2:])}</li>")
                continue
            if len(line) > 2 and line[0].isdigit() and line[1] == ".":
                html_lines.append(f"<li>{CaliberExporter._inline_md(line[3:])}</li>")
                continue

            # 空行
            if not line.strip():
                html_lines.append("")
                continue

            # 普通段落
            html_lines.append(f"<p>{CaliberExporter._inline_md(line)}</p>")

        if in_table:
            html_lines.append("</tbody></table>")

        return "\n".join(html_lines)

    @staticmethod
    def _inline_md(text: str) -> str:
        """处理行内 Markdown 语法 (code, bold, italic)。"""
        import re
        # 转义 HTML
        text = html.escape(text)
        # 行内代码
        text = re.sub(r'`([^`]+)`', r'<code>\1</code>', text)
        # 粗体
        text = re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', text)
        # 斜体
        text = re.sub(r'\*([^*]+)\*', r'<em>\1</em>', text)
        return text

    @staticmethod
    def _html_template(body: str, title: str = "口径文档") -> str:
        """生成完整 HTML 页面模板。"""
        return f"""<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{html.escape(title)}</title>
    <style>
        body {{
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            max-width: 960px;
            margin: 0 auto;
            padding: 2rem;
            color: #1a1a1a;
            line-height: 1.6;
        }}
        h1 {{ color: #1e3a5f; border-bottom: 2px solid #1e3a5f; padding-bottom: 0.5rem; }}
        h2 {{ color: #2d5986; border-bottom: 1px solid #e2e8f0; padding-bottom: 0.3rem; }}
        h3 {{ color: #3b7dd8; }}
        table {{ border-collapse: collapse; width: 100%; margin: 1rem 0; }}
        th, td {{ border: 1px solid #e2e8f0; padding: 0.5rem 0.75rem; text-align: left; }}
        th {{ background: #f1f5f9; font-weight: 600; }}
        tr:nth-child(even) {{ background: #f8fafc; }}
        code {{ background: #f1f5f9; padding: 0.15rem 0.4rem; border-radius: 3px; font-size: 0.9em; }}
        pre {{ background: #1e293b; color: #e2e8f0; padding: 1rem; border-radius: 6px; overflow-x: auto; }}
        pre code {{ background: none; padding: 0; color: inherit; }}
        blockquote {{ border-left: 4px solid #3b82f6; padding-left: 1rem; color: #475569; margin: 1rem 0; }}
        details {{ background: #f8fafc; padding: 0.75rem; border-radius: 6px; margin: 0.5rem 0; }}
        summary {{ cursor: pointer; font-weight: 500; }}
        hr {{ border: none; border-top: 1px solid #e2e8f0; margin: 2rem 0; }}
        li {{ margin: 0.25rem 0; }}
    </style>
</head>
<body>
{body}
</body>
</html>"""
