## Behavior

开发者执行 `ruff check .` 可检测所有代码质量问题，`ruff format .` 可自动格式化代码。规则集覆盖：未使用导入、可简化逻辑、命名规范、导入排序、弃用语法等。line-length=120 允许中文注释行稍长。

## Interface

- **CLI**: `ruff check .` / `ruff check --fix .` / `ruff format .`
- **配置**: `pyproject.toml` 中 `[tool.ruff]` 段

## Configuration

```toml
[tool.ruff]
line-length = 120
target-version = "py311"

[tool.ruff.lint]
select = ["E", "F", "W", "I", "N", "UP", "B", "SIM"]
ignore = ["E501"]  # line-length 由 formatter 处理

[tool.ruff.lint.isort]
known-first-party = ["app", "core"]

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
```

## Acceptance Criteria

- `ruff check .` 对 app/ 和 core/ 零错误（允许 `--ignore` 暂时跳过的规则）
- `ruff format --check .` 通过（所有文件已格式化）
- 首次运行使用 `ruff check --fix` 自动修复安全规则，手动修复剩余