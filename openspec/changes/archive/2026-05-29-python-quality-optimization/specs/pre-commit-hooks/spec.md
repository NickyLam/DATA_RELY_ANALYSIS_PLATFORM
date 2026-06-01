## Behavior

`git commit` 前自动执行快速质量检查：代码格式化（ruff format）、lint 检查（ruff check）、空白符清理、大文件拦截。执行时间 <5 秒。mypy 不纳入 pre-commit（太慢），由开发者手动执行或 CI 阶段运行。

## Interface

- **CLI**: `pre-commit run --all-files` / 自动触发 on `git commit`
- **配置**: `.pre-commit-config.yaml`

## Configuration

```yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.11.0
    hooks:
      - id: ruff-format
      - id: ruff
        args: [--fix]
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-merge-conflict
      - id: check-added-large-files
        args: ['--maxkb=500']
```

## Acceptance Criteria

- `.pre-commit-config.yaml` 存在且 `pre-commit run --all-files` 通过
- `git commit` 时自动触发 hooks
- 首次安装需执行 `pre-commit install`
- mypy 不在 pre-commit 中（设计决策 D6）