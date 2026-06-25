# CodeReview 2026-06-22 核验结论与修复任务清单

源报告：`docs/DATA_RELY_ANALYSIS_SYS_CodeReview_20260622.html`

核验时间：2026-06-23

## 总体结论

报告大部分代码位置判断属实，但严重性排序需要调整：

- 真正应优先处理的是会影响解析结果或并发行为的项目：`procedure_parser` 共享缓存、`GraphConverter.direction`、`DMLParser._extract_from_clause`、`PamDMLParser` 字段映射和 DELETE、`find_matching_paren_sql` 失败返回值、动态 schema 前缀快照。
- 报告把若干可维护性问题评为 Critical/Major，偏重：`caliber_extractor.py` 重复、BFS 重复、大模块、循环依赖、底部导入、Markdown 转换器、`slots=True` 等不应进入第一轮修复闭环。
- `M-10 核心解析器缺少单元测试` 表述不准确：当前已有 `tests/test_warehouse_parser.py`、`tests/test_caliber_batch_c.py`、`tests/test_concurrency_comprehensive.py` 等核心解析测试，顶层 `test_*.py` 为 23 个。准确问题是“缺少本报告列出的回归场景覆盖”。

## 逐项核验

| ID | 核验结论 | 证据 | 处理意见 |
| --- | --- | --- | --- |
| C-1 caliber_extractor 大规模重复 | 属实，但不应定为 Critical | `core/caliber_extractor.py` 833 行；拆分模块合计约 920 行；调用方仍依赖 `CaliberExtractor` 门面 | P2 重构，先保兼容 API，再委托到拆分模块 |
| C-2 procedure_parser 共享缓存线程安全 | 属实，影响描述略夸大 | `core/procedure_parser.py:115` 定义 `_last_parse_cache`，`173` 写入，`247` 读取；`parse_directory` 在 `209-210` 并行调用 `parse_prc_file` | P0 修复，锁或局部缓存 |
| C-3 layer_detector 单例初始化 | 属实，影响描述略夸大 | `core/layer_detector.py:357-359` 使用函数属性懒加载 | P0 小修，`lru_cache` 或模块级锁 |
| M-1 caliber_tracer BFS 重复 | 属实 | `_trace_upstream` 与 `_trace_downstream` 分别在 `core/caliber_tracer.py:271`、`366` | P3 重构，先不阻塞缺陷修复 |
| M-2 lineage_tracer BFS 重复 | 属实 | `_bfs_trace` 与 `_bfs_trace_downstream` 分别在 `core/lineage_tracer.py:214`、`364` | P3 重构 |
| M-3 models.py 模块过大 | 属实 | `core/models.py` 1187 行，`CaliberInfo` 字段多且含 property 委托 | P3 架构任务，不和 bug 修复混做 |
| M-4 procedure_parser 模块过大 | 属实 | `core/procedure_parser.py` 1234 行，`_parse_from_aliases` 在 `597` 附近 | P3 架构任务 |
| M-5 caliber_expression 与 metadata 延迟导入 | 属实，但当前是有意规避循环 | `core/caliber_metadata.py:25-29`、`core/caliber_expression.py:31-35` | P3 设计清理 |
| M-6 Schema 名称硬编码 | 部分属实 | `table_name_resolver` 已支持 `LayerDetector` 配置，但仍有 RRP fallback；`warehouse/schema_resolver.py:19-29` 为全局映射 | P2 配置收敛 |
| M-7 _extract_from_clause 朴素搜索 | 属实 | `core/warehouse/dml_parser.py:625-650` 用 `upper().find()` 搜索 `UNION` 等 | P1 修复并加字符串/注释回归测试 |
| M-8 GraphConverter direction 无效 | 属实 | `core/lineage/graph_converter.py:37-46` if/else 完全相同 | P1 先测试确认语义，再修复或删除参数 |
| M-9 PamDMLParser 字段映射仅单源 | 属实 | `core/pam/pam_dml_parser.py:299-313` 只处理简单列且固定 `sources[0]` | P1 分两步修复：INSERT 映射、DELETE 处理 |
| M-10 核心解析器缺少单元测试 | 不准确 | 已有 `tests/test_warehouse_parser.py`、`tests/test_caliber_batch_c.py`、`tests/test_concurrency_comprehensive.py` | 改为“补本轮缺陷回归测试” |
| M-11 OracleTabAdapter 未用 as_completed | 属实，性能问题 | `core/adapters/oracle_tab_adapter.py:62-71` 按提交顺序 `future.result()` | P2 小修 |
| m-1 base_sql_parser 废弃文件 | 属实，但保留兼容说明 | `core/base_sql_parser.py:4-7` 已声明 deprecated；无生产引用 | 暂缓删除，可加 `DeprecationWarning` |
| m-2 logger f-string | 属实 | `core/table_parser.py:29,163` | P3 或随手小修 |
| m-3 find_matching_paren_sql 失败返回 start | 属实 | `core/utils/bracket_matcher.py:58-61,85` | P1 修复，需先查调用方 |
| m-4 is_temp_table 重复且规则不一致 | 属实 | `core/utils/__init__.py:10-19` vs `core/warehouse/temp_table_filter.py:67-98` | P2 统一 |
| m-5 schema_resolver 底部导入 | 属实 | `core/warehouse/schema_resolver.py:237-238` | P3 小修 |
| m-6 DDLParser parse_directory 锁竞争 | 属实，性能问题 | `core/warehouse/ddl_parser.py:121-133` | P2 小修 |
| m-7 IndicatorAdapter 字段映射笛卡尔积 | 属实，需确认语义 | `core/adapters/indicator_adapter.py:109-128` 对每个 mapping 复制到每个 source table | P2，先补测试/确认数据语义 |
| m-8 WarehouseSQLParser DDL 返回类型不一致 | 属实但已有显式转换 | `core/warehouse/warehouse_parser.py:84-99` 对 `DDLParser.parse_file()` 返回做检查和转换 | 暂缓 |
| m-9 Markdown 转 HTML 脆弱 | 属实但非核心 | `core/caliber_exporter.py:292-390` 自实现转换 | 暂缓，除非导出 HTML 是近期重点 |
| m-10 PamDMLParser 忽略 DELETE | 属实 | `_DELETE_FROM_RE` 在 `core/pam/pam_dml_parser.py:80-84` 定义，`_parse_dml_from_sql` 未使用 | P1 独立任务 |
| m-11 _KNOWN_SCHEMA_PREFIXES 导入时快照 | 属实 | `core/warehouse/dml_parser.py:29` 计算，`985` 使用；`SchemaResolver(custom_mapping=...)` 不会更新它 | P1/P2 小修 |
| m-12 CaliberInfo property setter 隐式耦合 | 属实但兼容性风险高 | `core/models.py:562-585` | 暂缓，不作为 bug 修 |
| m-13 PamParser DDL 串行解析 | 属实，性能问题 | `core/pam/pam_parser.py:74-82` | P2 小修 |
| m-14 _CTAS_PATTERN 非贪婪 DOTALL | 属实 | `core/warehouse/dml_parser.py:184-191` | P1/P2，依赖 SQL 边界测试 |
| S-1 到 S-8 | 多为合理建议，不是缺陷 | `pyproject.toml` 要求 Python >=3.11，技术上支持 `slots=True`，但仍有兼容和收益验证成本 | 本轮不纳入 |

## 修复策略

原则：

- 每个任务只修一个可独立验证的问题。
- 每个任务先补最小回归测试，再改实现。
- 不把架构重构与行为修复混做。
- 涉及语义不确定的项，先写“当前行为锁定测试/失败测试”，再决定改逻辑还是删除参数/文档化。

## 最小可重试任务清单

### P0：并发与共享状态

#### T01 procedure_parser 缓存线程安全

- 范围：`core/procedure_parser.py`
- 测试：新增/更新 `tests/test_parser_concurrency.py` 或 `tests/test_tracer_procedure.py`，覆盖同一个 `EnhancedProcedureParser` 并发解析多个 `.prc` 后缓存读取不串数据。
- 实现：优先把 `content/operations` 缓存限制为单次解析局部结果；若保留实例缓存，则用 `threading.RLock` 包住读写并限制 key 为唯一 `full_name + file_path`。
- 验证：`python -m pytest tests/test_tracer_procedure.py tests/test_parser_concurrency.py -q`

#### T02 layer_detector 默认实例线程安全

- 范围：`core/layer_detector.py`
- 测试：新增并发调用 `detect_layer()` 的小测试，确认所有线程返回一致且不抛错。
- 实现：用 `@functools.lru_cache(maxsize=1)` 提供 `_default_detector()`，`detect_layer()` 调用缓存函数；或模块级锁初始化。
- 验证：`python -m pytest tests/test_parser_concurrency.py -q`

### P1：解析结果正确性

#### T03 GraphConverter direction 语义修复

- 范围：`core/lineage/graph_converter.py`
- 测试：新增 `tests/test_graph_converter.py`，构造一条 upstream chain 和 downstream chain，断言 edge/mapping 的 source/target 方向符合 API 期望。
- 实现：若链条顺序已经由调用方保证，则删除 `direction` 分支并移除参数；若 downstream 需要反向输出，则在 `direction == "downstream"` 时交换 source/target，并同步 procedure/transform 取值。
- 验证：`python -m pytest tests/test_graph_converter.py tests/test_lineage_api.py -q`

#### T04 DMLParser _extract_from_clause 使用 token 感知边界

- 范围：`core/warehouse/dml_parser.py`
- 测试：在 `tests/test_warehouse_parser.py` 增加 `UNION` 出现在字符串、行注释、块注释、嵌套子查询中的样例。
- 实现：复用或扩展 `_find_top_level_keyword()`，替代 `search_text.upper().find()`。
- 验证：`python -m pytest tests/test_warehouse_parser.py -q`

#### T05 DMLParser CTAS 边界回归

- 范围：`core/warehouse/dml_parser.py`
- 测试：新增 CTAS 中嵌套 SELECT、多 FROM、字符串 `FROM` 的样例。
- 实现：避免 `_CTAS_PATTERN` 依赖 `.*?` 捕获复杂 SQL；用 SQL 边界扫描拆出完整 statement，再拆 SELECT/FROM。
- 验证：`python -m pytest tests/test_warehouse_parser.py -q`

#### T06 PamDMLParser INSERT 字段映射增强

- 范围：`core/pam/pam_dml_parser.py`
- 测试：新增 `tests/test_pam_dml_parser.py`，覆盖多源 JOIN、带别名列、函数表达式、简单列四类 INSERT。
- 实现：复用 `FieldCleaner.parse_select_columns()` 或抽出 `DMLParser` 的位置映射逻辑；不要固定使用 `sources[0]`。
- 验证：`python -m pytest tests/test_pam_dml_parser.py -q`

#### T07 PamDMLParser DELETE 处理

- 范围：`core/pam/pam_dml_parser.py`
- 测试：在 `tests/test_pam_dml_parser.py` 增加 DELETE+INSERT 同目标表样例。
- 实现：最低限度先对 DELETE 产出可观测 warning/metadata；如业务确认 DELETE+INSERT 表示重载，则把 DELETE 目标与后续 INSERT 目标关联为同一复合操作。
- 验证：`python -m pytest tests/test_pam_dml_parser.py -q`

#### T08 find_matching_paren_sql 失败返回 -1

- 范围：`core/utils/bracket_matcher.py` 及调用方
- 测试：新增/更新 `tests/test_sql_boundary_detector.py` 或新建 `tests/test_bracket_matcher.py`，覆盖非括号起点、不平衡括号、引号内括号。
- 实现：失败统一返回 `-1`；更新所有 `end > start`、`end == start` 判断逻辑。
- 验证：`python -m pytest tests/test_sql_boundary_detector.py tests/test_caliber_batch_c.py -q`

#### T09 DMLParser 动态 schema 前缀

- 范围：`core/warehouse/dml_parser.py`
- 测试：在 `tests/test_warehouse_parser.py` 使用 `SchemaResolver(custom_mapping=...)`，验证 alias 过滤识别自定义 schema。
- 实现：把 `_KNOWN_SCHEMA_PREFIXES` 改为实例级，从 `self._resolver` 的映射动态读取；或由 `SchemaResolver` 暴露 `known_schema_prefixes()`。
- 验证：`python -m pytest tests/test_warehouse_parser.py -q`

### P2：低风险可维护性/性能修复

#### T10 CaliberExtractor 委托到拆分模块

- 范围：`core/caliber_extractor.py`、`core/caliber_condition.py`、`core/caliber_metadata.py`、`core/caliber_expression.py`
- 测试：保留并扩展 `tests/test_caliber_batch_c.py`，先确保当前 `CaliberExtractor` public/private API 行为被锁定。
- 实现：让 `CaliberExtractor` 成为兼容门面，静态方法委托给 `ConditionExtractor`、`MetadataExtractor`、`ExpressionBuilder`；不要一次性删除调用方依赖。
- 验证：`python -m pytest tests/test_caliber_batch_c.py tests/test_caliber_api.py -q`

#### T11 OracleTabAdapter 使用 as_completed

- 范围：`core/adapters/oracle_tab_adapter.py`
- 测试：mock 一个慢 future/快 future，确认结果合并不依赖提交顺序。
- 实现：`from concurrent.futures import as_completed`，遍历 `as_completed(futures)`。
- 验证：`python -m pytest tests/test_warehouse_parser.py -q`

#### T12 DDLParser parse_directory 去共享锁

- 范围：`core/warehouse/ddl_parser.py`
- 测试：复用并发测试，确认解析结果数量一致。
- 实现：worker 返回 `TableInfo | None`，主线程统一合并结果。
- 验证：`python -m pytest tests/test_concurrency_comprehensive.py -q`

#### T13 PamParser DDL 阶段并行

- 范围：`core/pam/pam_parser.py`
- 测试：新增多 DDL 文件目录样例，断言表数量和错误收集一致。
- 实现：只并行 Phase 1 DDL 文件解析，Phase 2 DML 暂不动，避免改变两阶段语义。
- 验证：`python -m pytest tests/test_pam_parser.py -q`

#### T14 is_temp_table 统一

- 范围：`core/utils/__init__.py`、`core/warehouse/temp_table_filter.py`、调用方
- 测试：列出 `_BK/_TM/_OP/_CL/_OLD/_NEW/TMP_/ETL_/STG_` 等样例。
- 实现：`core.utils.is_temp_table()` 委托到共享单例 `TempTableFilter().is_temp_table()`，或把规则抽到 `core/utils/temp_tables.py`。
- 验证：`python -m pytest tests/test_warehouse_parser.py tests/test_tracer_procedure.py -q`

### P3：暂缓或需产品/架构确认

#### T15 IndicatorAdapter 字段映射笛卡尔积语义确认

- 范围：`core/adapters/indicator_adapter.py`
- 前置：确认 `base_calc.field_mappings` 是否包含源表字段信息；如果没有，不能凭空恢复字段级血缘。
- 最小动作：先新增测试固定当前笛卡尔积行为，再根据样例数据决定“关联实际源表”还是“文档化为表级展开”。

#### T16 大模块/BFS/模型拆分

- 范围：`core/models.py`、`core/procedure_parser.py`、`core/caliber_tracer.py`、`core/lineage_tracer.py`
- 前置：P0/P1 完成后再做，避免大范围重构掩盖行为修复。
- 最小动作：先提取无状态 helper，不改变 public API；每次只拆一个类或一个 BFS 引擎。

#### T17 Suggestions 延后处理

- `dataclass(slots=True)`：Python 版本支持，但要验证序列化、动态属性、测试 fixture。
- `SchemaResolver.resolve_table_name lru_cache`：必须按实例状态缓存，不能缓存到全局函数。
- `py.typed`、正则类型注解、结构化指标日志、自定义 `__repr__`：收益低，不进入本轮修复。

## 推荐执行顺序

1. 先执行 T01-T02，消除共享状态风险。
2. 执行 T03-T09，每个任务先写失败测试，再修实现。
3. 执行 T10-T14，处理低风险重构和性能问题。
4. T15-T17 只在样例数据和接口语义确认后进入新一轮计划。

## 每轮完成标准

- 任务对应的 focused pytest 命令通过。
- 若改了共享解析逻辑，再运行：`python -m pytest tests/test_warehouse_parser.py tests/test_concurrency_comprehensive.py -q`
- 若改了 API 输出图结构，再运行：`python -m pytest tests/test_lineage_api.py tests/test_lineage_result_cleanup.py -q`
- 不把 P3 架构重构和 P1 行为缺陷放在同一个提交中。
