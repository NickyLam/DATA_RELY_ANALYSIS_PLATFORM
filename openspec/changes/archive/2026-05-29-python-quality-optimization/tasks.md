## 1. 工具链安装与配置

- [x] 1.1 创建 pyproject.toml，配置 `[tool.ruff]` 规则集（E,F,W,I,N,UP,B,SIM）、line-length=120、target-version=py311
- [x] 1.2 配置 `[tool.ruff.lint.isort]` known-first-party = ["app", "core"]
- [x] 1.3 配置 `[tool.mypy]` 全局基线 + `[[tool.mypy.overrides]]` 分层（app 严格/core 宽松）
- [x] 1.4 配置 `[tool.pytest.ini_options]` 和 `[tool.coverage]` 段，迁移 pytest.ini 配置
- [x] 1.5 添加 ruff、mypy 到 requirements.txt 的 dev 依赖段
- [x] 1.6 创建 .pre-commit-config.yaml，配置 ruff-format、ruff-check、trailing-whitespace、end-of-file-fixer、check-merge-conflict、check-added-large-files

## 2. ruff 首次修复

- [x] 2.1 运行 `ruff check --fix .` 自动修复安全规则（未使用导入、导入排序等）
- [x] 2.2 手动修复 ruff 报告的不可自动修复问题（命名规范、逻辑简化等）
- [x] 2.3 运行 `ruff format .` 格式化全部代码
- [x] 2.4 验证 `ruff check .` 零错误、`ruff format --check .` 通过

## 3. mypy 类型检查适配

- [x] 3.1 运行 `mypy app/` 检查 app 层，记录错误清单
- [x] 3.2 修复 app 层 mypy 错误：补充缺失类型标注、替换隐式 Any
- [x] 3.3 运行 `mypy core/` 检查 core 层，确认宽松模式下零错误
- [x] 3.4 对无法快速修复的类型错误，添加 `# type: ignore[xxx]` 并附注释说明原因

## 4. app 层 Any 类型清理

- [x] 4.1 将 `BaseResponse.data: Any` 的使用方迁移到 `ApiResponse[T]` 泛型
- [x] 4.2 替换 `LineageResultData.nodes/edges` 中的 `dict[str, Any]` 为具体 Pydantic 模型
- [x] 4.3 替换 `IndicatorNodeData.detail: dict[str, Any]` 为具体模型或 `dict[str, str]`
- [x] 4.4 替换 `SingleTableInfoResponse.data: dict[str, Any]` 为具体模型
- [x] 4.5 替换 `response_utils.success(data: Any)` 参数类型为泛型或 `object`

## 5. 覆盖率门槛提升（Phase 1: 40%）

- [x] 5.1 运行 `pytest --cov` 获取当前覆盖率基线
- [x] 5.2 补充 app/api 层高 ROI 测试（lineage.py、system.py 未覆盖端点）
- [x] 5.3 补充 app/services 层核心方法测试（lineage_service、parser_service）
- [x] 5.4 更新 pytest.ini 的 `cov-fail-under=40`，验证通过

## 6. 异常处理清理

- [x] 6.1 搜索所有 `except Exception: pass` 模式，替换为带日志记录的 `except Exception as e: logger.warning(...)` 或具体异常类型
- [x] 6.2 搜索所有裸 `except:` 模式，替换为具体异常类型

## 7. 架构文档与收尾

- [x] 7.1 在 CLAUDE.md 或 README.md 中补充三层架构定位说明（API → Service → Core）及同步 Service 决策理由
- [x] 7.2 运行 `pre-commit run --all-files` 验证所有 hooks 通过
- [x] 7.3 运行完整测试套件确认无回归：`pytest tests/`
- [x] 7.4 清理 pytest.ini（配置已迁移到 pyproject.toml），保留最小兼容引用