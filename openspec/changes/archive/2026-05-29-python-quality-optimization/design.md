## Context

本项目是数据血缘分析系统——以文件解析引擎（.tab/.prc/.sql/.xlsx）为核心、FastAPI 提供 API 的内部工具。当前状态：

- **无 ruff/mypy 配置**：代码风格依赖人工检查，类型安全无保障
- **测试覆盖率门槛 30%**：远低于行业基线，214 个测试中 113 个使用 mock
- **`Any` 类型滥用**：app 层约 20+ 处，尤其 `BaseResponse.data: Any` 和 `dict[str, Any]`
- **架构未文档化**：实际是 API → Service → Core 三层，但无正式定位说明
- **无 pre-commit hooks**：提交前无自动化质量门禁

关键约束：本项目是 CPU 密集型解析引擎，非 CRUD Web 服务。Python_Rules_Recommend 规范中的 Repository 层、SQLAlchemy ORM、async 全链路、Alembic 迁移等均不适用。

## Goals / Non-Goals

**Goals:**
- 建立自动化代码质量门禁（ruff + mypy + coverage），适配项目特性
- 分层配置工具链：app 层严格、core 层适度放宽
- 渐进式提升覆盖率门槛至 60%
- 清理 app 层 `Any` 类型滥用
- 固化三层架构定位和同步 Service 决策

**Non-Goals:**
- 不引入 Repository 层或 SQLAlchemy ORM
- 不将 Service 层改为 async
- 不迁移到 `src/` 布局
- 不引入 BusinessError + ErrorCode 体系（当前 HTTPException 足够）
- 不要求 core 层消除所有 `Any`（解析引擎动态结构不可避免）
- 不引入 CI/CD 流水线（内部工具，无 GitHub Actions）

## Decisions

### D1: 使用 pyproject.toml 统一工具配置

**选择**: 创建 pyproject.toml，集中管理 ruff/mypy/pytest 配置

**替代方案**: 继续用 ruff.toml + mypy.ini + pytest.ini 分散配置

**理由**: pyproject.toml 是 Python 生态标准（PEP 517/518），减少配置文件数量，与 Python_Rules_Recommend 规范一致。pytest.ini 保留但指向 pyproject.toml 的 pytest 配置段。

### D2: ruff 规则集选择

**选择**: 基础规则集 `E, F, W, I, N, UP, B, SIM` + line-length=120

**排除**: `A`（flake8-builtins）过于严格会误报 `id`/`type`/`dict` 等内置名覆盖；`TCH`（type-checking）需要大量 `if TYPE_CHECKING` 改造

**理由**: 渐进式引入，先解决真正的代码质量问题（未使用导入、可简化逻辑等），避免一次性大量改动。

### D3: mypy 分层配置

**选择**:
- **app 层**: `--strict` 基线 + `disallow_untyped_defs=true` + `allow_explicit_any=true`
- **core 层**: `--ignore-missing-imports` + `allow_untyped_defs=true` + `allow_untyped_calls=true`
- 通过 `[[tool.mypy.overrides]]` 按模块路径配置

**替代方案**: 全局 `--strict` + 大量 `# type: ignore` 注释

**理由**: core 层解析引擎使用 dataclass + 动态结构 + 正则匹配，强制 strict 会产生数百个噪音错误。分层配置让 app 层获得类型安全收益，core 层不被噪音淹没。

### D4: 覆盖率渐进提升策略

**选择**: 三步走——Phase 1: 40% → Phase 2: 50% → Phase 3: 60%

**分层目标**: app 层 ≥70%、core 层 ≥50%、整体 ≥60%

**理由**: 一次性从 30% 跳到 60% 会阻塞所有 PR。渐进式允许团队在提升覆盖率的同时继续功能开发。每阶段补充高 ROI 测试（API 端点、Service 核心方法）。

### D5: `Any` 类型清理范围

**选择**: 仅清理 app 层，core 层保留

**具体替换**:
- `BaseResponse.data: Any` → 使用 `ApiResponse[T]` 泛型（已有）
- `dict[str, Any]` 在响应模型中 → 定义具体 Pydantic 模型
- `Any` 在函数签名中 → 使用 `object` 或具体类型

**不清理**: core 层解析引擎内部的 `Any`（SQL 解析产出结构多变，强制类型化收益低）

### D6: pre-commit hooks 最小集

**选择**: ruff format + ruff check + trailing-whitespace + end-of-file-fixer + check-merge-conflict + check-added-large-files

**排除**: mypy（太慢，影响提交体验）、bandit（内部工具安全扫描优先级低）

**理由**: pre-commit 应快速（<5s），mypy 放在手动/CI 阶段执行。

## Risks / Trade-offs

- **[ruff 首次运行大量报错]** → 先 `ruff check --fix` 自动修复安全规则，剩余手动处理。配置 `--ignore` 暂时跳过无法快速修复的规则
- **[mypy core 层噪音]** → 分层配置已缓解。若仍过多，可对特定文件加 `# type: ignore`
- **[覆盖率提升阻塞开发]** → 渐进式策略（40→50→60），每阶段间隔 1-2 周
- **[pre-commit 影响提交速度]** → 仅配置快速 hooks（ruff <1s），mypy 不纳入
- **[pyproject.toml 与现有 pytest.ini 冲突]** → pytest.ini 保留但配置迁移到 pyproject.toml，pytest.ini 仅做兼容引用