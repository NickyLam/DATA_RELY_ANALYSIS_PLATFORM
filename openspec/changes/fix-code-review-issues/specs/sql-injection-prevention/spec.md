## ADDED Requirements

### Requirement: SQLite table names must be validated against whitelist
SQLite 存储后端 (`sqlite_store.py`) 中所有动态拼接表名的 SQL 操作 SHALL 通过白名单校验。白名单 SHALL 定义为 `DATA_TABLE_NAMES` 的不可变集合。

#### Scenario: 使用合法表名执行操作
- **WHEN** `_replace_table_data()`、`_read_table()`、`clear()` 方法使用 `DATA_TABLE_NAMES` 中的表名
- **THEN** 操作 SHALL 正常执行

#### Scenario: 使用非法表名尝试 SQL 操作
- **WHEN** 内部逻辑错误导致传入不在白名单的表名（如用户注入值）
- **THEN** 系统 SHALL 抛出 `ValueError("Invalid table name: <name>")`
- **AND** 该非法表名 SHALL 不会出现在任何 SQL 语句中

### Requirement: All dynamic SQL values must use parameterized queries
SQLite 存储后端中所有涉及用户数据或动态值的 SQL 操作 SHALL 使用参数化占位符（`?`），禁止字符串拼接。

#### Scenario: 按 full_name 查询表
- **WHEN** 调用 `get_table_by_full_name(full_name)` 方法
- **THEN** 生成的 SQL SHALL 使用 `?` 占位符绑定 `full_name` 参数
