## Context

`core/caliber_metadata.py` 是从原 `CaliberExtractor` 拆分出的 SRP 子模块，负责 SQL 元数据提取（CTE、窗口函数、子查询、自定义函数）。在拆分重构时，`_extract_subqueries()` 方法中使用了 `SQLCondition` 类来构建子查询的 WHERE 条件，但导入语句遗漏了 `SQLCondition`。

当前状态：
- `caliber_metadata.py` 第10行仅导入 `SubqueryInfo, SelectColumnMapping`
- 第69-77行使用 `SQLCondition` 构建子查询 WHERE 条件
- 运行时抛出 `NameError: name 'SQLCondition' is not defined`
- 影响所有包含子查询的 `.prc` 文件解析（server.log 中 117 条错误）

## Goals / Non-Goals

**Goals:**
- 修复 `SQLCondition` 缺失导入，恢复 `.prc` 文件解析链路
- 确保 117 个此前失败的文件能正常完成口径提取

**Non-Goals:**
- 不重构导入结构或模块边界
- 不修改 `SQLCondition` 类本身
- 不处理其他潜在但当前未触发的导入问题

## Decisions

**决策：直接在现有导入行补充 `SQLCondition`**

理由：
- 最小变更原则：仅修改 1 行导入
- `SQLCondition` 已在 `core/models.py` 中定义，同包内其他模块（`caliber_condition.py`、`caliber_expression.py`）均正确导入
- 不引入新的依赖或延迟导入（`_extract_subqueries` 是热路径，无需 lazy import）

替代方案（已排除）：
- 延迟导入（函数内 import）：不必要，`core.models` 无循环依赖风险
- 将子查询 WHERE 提取委托给 `ConditionExtractor`：过度重构，偏离 bug 修复目标

## Risks / Trade-offs

- **[风险] 修复后解析时间增加** → 117 个文件恢复口径提取，总解析时间可能增加数秒。可接受，因为口径数据是核心业务需求。
- **[风险] 其他模块存在类似遗漏** → 已全局搜索确认 `caliber_metadata.py` 是唯一遗漏点。
