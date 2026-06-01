## ADDED Requirements

### Requirement: 数据源级并发度由配置驱动
ParserService 的数据源级线程池 SHALL 使用 `_datasource_workers` 配置值作为 `max_workers`，而非硬编码值。

#### Scenario: 配置值生效
- **WHEN** ParserService 初始化时 `_datasource_workers=6`
- **THEN** 内部线程池的 `max_workers` SHALL 为 6

#### Scenario: 默认并发度
- **WHEN** 未显式设置 `_datasource_workers`
- **THEN** 默认值 SHALL 为 6

### Requirement: 线程池为实例变量
ParserService 的线程池 SHALL 为实例变量，而非类变量。每个 ParserService 实例 SHALL 拥有独立的线程池。

#### Scenario: 多实例隔离
- **WHEN** 创建两个 ParserService 实例
- **THEN** 两个实例 SHALL 拥有各自独立的线程池，互不影响

### Requirement: 线程池生命周期管理
ParserService SHALL 提供 `shutdown()` 方法，在服务停止时显式关闭线程池并等待正在执行的任务完成。

#### Scenario: 正常关闭
- **WHEN** 调用 `shutdown()` 方法
- **THEN** 线程池 SHALL 等待所有已提交任务完成后关闭

#### Scenario: 未关闭时的资源释放
- **WHEN** ParserService 实例被垃圾回收但未调用 `shutdown()`
- **THEN** 线程池 SHALL 通过 `__del__` 尝试清理资源（best-effort）
