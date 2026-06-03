## Why

`core/caliber_metadata.py` 的 `MetadataExtractor._extract_subqueries()` 方法使用了 `SQLCondition` 类（第69-77行），但该文件未从 `core.models` 导入 `SQLCondition`。这导致所有包含子查询的 `.prc` 文件解析时抛出 `NameError: name 'SQLCondition' is not defined`，造成 **117 个存储过程文件解析失败**，严重损失口径提取覆盖率。

## What Changes

- 在 `core/caliber_metadata.py` 的导入行中补充 `SQLCondition`，修复缺失的导入
- 无 API 变更，无行为变更，仅修复运行时 `NameError`

## Capabilities

### New Capabilities

（无新增能力）

### Modified Capabilities

（无需求变更，仅为 bug 修复）

## Impact

- **受影响文件**: `core/caliber_metadata.py`（1行导入修改）
- **受影响功能**: `.prc` 文件解析 → 口径提取链路（`OraclePrcAdapter` → `EnhancedProcedureParser` → `CaliberExtractor` → `ExpressionBuilder` → `MetadataExtractor._extract_subqueries()`）
- **影响范围**: 修复后约 117 个此前解析失败的 `.prc` 文件将恢复正常解析，口径提取覆盖率将显著提升
- **无破坏性变更**: 纯补充缺失导入，不影响任何现有功能
