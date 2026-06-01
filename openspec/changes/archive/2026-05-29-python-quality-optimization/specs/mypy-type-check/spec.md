## Behavior

开发者执行 `mypy app/` 可对 app 层进行严格类型检查，`mypy core/` 可对 core 层进行宽松类型检查。app 层禁止隐式 `Any`，要求显式类型标注；core 层允许未标注函数和动态调用。

## Interface

- **CLI**: `mypy app/` / `mypy core/` / `mypy .`（全局，使用 overrides）
- **配置**: `pyproject.toml` 中 `[tool.mypy]` 段

## Configuration

```toml
[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
allow_explicit_any = true

[[tool.mypy.overrides]]
module = "core.*"
disallow_untyped_defs = false
allow_untyped_calls = true
allow_untyped_defs = true
ignore_missing_imports = true

[[tool.mypy.overrides]]
module = "app.*"
disallow_untyped_defs = true
allow_explicit_any = true
```

## Acceptance Criteria

- `mypy app/` 零错误（允许 `allow_explicit_any` 下的显式 `Any`）
- `mypy core/` 零错误（宽松模式）
- 现有 `Any` 类型按分层策略处理：app 层逐步替换为具体类型，core 层保留