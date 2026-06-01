## Behavior

`pytest --cov` 运行后，整体覆盖率不低于 60%（Phase 3 目标）。app 层 ≥70%，core 层 ≥50%。覆盖率门槛渐进提升：Phase 1: 40% → Phase 2: 50% → Phase 3: 60%。

## Interface

- **CLI**: `pytest --cov=app --cov=core --cov-fail-under=60`
- **配置**: `pyproject.toml` 中 `[tool.pytest.ini_options]` 段

## Configuration

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "--cov=app --cov=core --cov-fail-under=40 -q"
markers = [
    "slow: marks tests as slow",
]

[tool.coverage.run]
source = ["app", "core"]
omit = ["tests/*", "app/main.py"]

[tool.coverage.report]
fail_under = 40
exclude_lines = [
    "pragma: no cover",
    "if TYPE_CHECKING:",
    "raise NotImplementedError",
]
```

## Phased Thresholds

| Phase | Overall | app Layer | core Layer | Timeline |
|-------|---------|-----------|------------|----------|
| 1     | 40%     | 50%       | 35%        | Week 1   |
| 2     | 50%     | 60%       | 40%        | Week 2-3 |
| 3     | 60%     | 70%       | 50%        | Week 4+  |

## Acceptance Criteria

- `pytest --cov` 通过且 `cov-fail-under=40`（Phase 1 交付标准）
- 覆盖率报告可按模块分组查看
- 现有测试全部通过（无回归）