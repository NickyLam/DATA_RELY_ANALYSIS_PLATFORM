## Why

项目当前缺乏自动化代码质量工具链（ruff/mypy）和结构化的质量门槛，导致代码风格不一致、类型安全无保障、测试覆盖率门槛仅 30%。Python_Rules_Recommend 规范分析表明，本项目作为数据血缘解析引擎（非 CRUD Web 服务），需要一套适配自身特性的质量方案，而非照搬通用后端规范。

## What Changes

- 引入 ruff 作为 lint + format 工具，替代手动风格检查
- 引入 mypy 类型检查，分层配置：app 层严格、core 层适度放宽
- 提升测试覆盖率门槛：30% → 60%（渐进式），分层设目标
- 明确本项目三层架构定位（API → Service → Core），在文档中固化
- 清理 app 层中的 `Any` 类型滥用，逐步替换为具体类型
- 保持同步 Service 架构（不强行 async 改造），在架构文档中记录决策理由
- 配置 pre-commit hooks（ruff + 基础检查）

## Capabilities

### New Capabilities
- `ruff-lint-format`: 引入 ruff 工具链，配置规则集（兼容现有代码风格），设置 pyproject.toml 配置项
- `mypy-type-check`: 引入 mypy 分层配置——app 层 `--strict` 基线（允许 explicit Any）、core 层 `--ignore-missing-imports` + `--allow-untyped-defs`
- `coverage-threshold`: 测试覆盖率门槛提升策略，app 层 ≥70%、core 层 ≥50%、整体 ≥60%
- `pre-commit-hooks`: 配置 .pre-commit-config.yaml，集成 ruff format/check、trailing-whitespace、check-merge-conflict

### Modified Capabilities

## Impact

- **依赖**: 新增 ruff、mypy 到 requirements.txt 或 pyproject.toml dev 依赖
- **配置**: 新增 pyproject.toml（工具配置段）、.pre-commit-config.yaml
- **代码**: app 层 ~20 处 `Any` 类型需逐步替换；部分 `except Exception: pass` 需加日志
- **测试**: pytest.ini 的 `cov-fail-under` 从 30 调至 60（渐进式，先 40 再 50 再 60）
- **CI**: 若有 CI 流程，需新增 ruff/mypy/coverage 检查步骤
- **文档**: CLAUDE.md 或项目 README 中补充架构定位说明