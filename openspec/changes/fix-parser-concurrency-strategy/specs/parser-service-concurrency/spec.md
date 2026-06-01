## MODIFIED Requirements

### Requirement: 数据源级并行解析
ParserService.parse_existing_data SHALL 使用实例级线程池并行解析所有独立数据源。线程池的并发度 SHALL 由 `_datasource_workers` 配置驱动。

#### Scenario: 6个数据源并行解析
- **WHEN** 配置了 6 个启用的数据源且 `_datasource_workers=6`
- **THEN** 6 个数据源 SHALL 同时提交到线程池并行解析

#### Scenario: 数据源数超过并发度
- **WHEN** 配置了 8 个数据源但 `_datasource_workers=4`
- **THEN** 最多 4 个数据源同时解析，其余排队等待

#### Scenario: 解析结果合并线程安全
- **WHEN** 多个数据源并发解析完成
- **THEN** 各数据源的解析结果 SHALL 通过 `_result_lock` 安全合并到总结果中
