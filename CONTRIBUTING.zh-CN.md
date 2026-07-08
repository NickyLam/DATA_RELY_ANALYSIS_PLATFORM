# 贡献指南

语言版本：中文 | [English](CONTRIBUTING.md)

感谢你改进这个数据血缘分析器。本项目可能处理来自企业环境的 SQL 和元数据，因此贡献时必须特别注意测试数据、日志、缓存和截图是否包含敏感信息。

## 开发环境

```bash
python3.11 -m venv .venv
source .venv/bin/activate
python3.11 -m pip install -r requirements.txt
```

启动应用：

```bash
python3.11 run_app.py
```

运行检查：

```bash
python3.11 -m pytest tests/
ruff check app/ core/ tests/
mypy app/ core/
```

如已安装本地 Git hooks：

```bash
bash scripts/install-git-hooks.sh
scripts/agent-verify.sh quick
scripts/agent-verify.sh full
```

## 贡献流程

1. 非平凡改动先开 Issue 说明问题和方案。
2. API 路由保持轻薄，业务逻辑放在 `app/services/`。
3. `core/` 保持框架无关，不得从 `core/` 导入 FastAPI。
4. 解析器、血缘、API 或前端行为发生变化时，同步新增或更新测试。
5. 用户可见行为、启动方式、API 或导出格式变化时，同步更新文档。
6. 使用 Conventional Commits，例如 `fix: 修复字段血缘方向`。

## 敏感数据规则

不要提交：

- 真实 `SOURCE_DATA/` 内容。
- `output/` 里的本地缓存。
- `.db`、`.sqlite` 等数据库文件。
- 日志、凭据、API Key、包含客户名称的截图或专有 SQL。
- 内容不明的压缩包。

提交 Issue 或测试时，使用 `docs/examples/oracle_warehouse_lineage.sql` 这类安全合成样例。

## 编码规范

- 只使用 Python 3.11+ 兼容语法。
- 新代码需要类型标注。
- 函数和变量使用 `snake_case`。
- Pydantic 模型和 dataclass 使用 `PascalCase`。
- `isinstance()` 第二个参数不要使用 PEP 604 union；使用 tuple，例如 `isinstance(value, (A, B))`。
- 新解析器通过 duck typing 实现 parser protocol，并注册到 `ParserRegistry`。

## 测试建议

- 解析器改动：增加窄范围单元测试。
- API 改动：增加带 mocked service 的 API 测试。
- 图谱/UI 行为：必要时更新前端 E2E 覆盖。
- 存储/缓存改动：增加迁移或兼容性测试。

## Pull Request 检查清单

- [ ] 已新增或更新测试。
- [ ] `python3.11 -m pytest tests/` 通过，或 PR 中说明无法运行的原因。
- [ ] `ruff check app/ core/ tests/` 对涉及文件通过。
- [ ] 用户可见行为变化已更新文档。
- [ ] 没有包含真实数据、本地缓存、日志、数据库、压缩包或密钥。
