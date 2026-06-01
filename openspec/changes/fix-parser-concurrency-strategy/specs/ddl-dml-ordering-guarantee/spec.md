## ADDED Requirements

### Requirement: 同一系统内 DDL 先于 DML 解析
WarehouseSQLParser.parse_directory SHALL 保证同一数据源系统内，所有 DDL 文件解析完成后才开始 DML 文件解析。DDL 解析产出的表结构字典 SHALL 注入 DMLParser 后再执行 DML 解析。

#### Scenario: DDL 结果注入 DML
- **WHEN** 数据源目录包含 ddl/ 和 dml/ 子目录
- **THEN** SHALL 先解析所有 ddl/ 目录，将结果注入 DMLParser，再解析 dml/ 目录

#### Scenario: 无 DDL 目录时的 DML 解析
- **WHEN** 数据源目录仅包含 dml/ 子目录，无 ddl/ 子目录
- **THEN** DML 解析 SHALL 使用空的表结构字典正常执行

#### Scenario: 多系统并发时的 DDL→DML 隔离
- **WHEN** 6 个数据源并发解析
- **THEN** 每个系统内部的 DDL→DML 顺序 SHALL 独立保证，不受其他系统并发影响

### Requirement: DDL 解析结果线程安全
多数据源并发解析时，各系统的 DDL 解析结果 SHALL 互不干扰。

#### Scenario: 并发 DDL 解析隔离
- **WHEN** EDW 和 BRT 同时执行 DDL 解析
- **THEN** EDW 的 DDL 结果 SHALL 仅注入 EDW 的 DMLParser，BRT 的 DDL 结果 SHALL 仅注入 BRT 的 DMLParser
