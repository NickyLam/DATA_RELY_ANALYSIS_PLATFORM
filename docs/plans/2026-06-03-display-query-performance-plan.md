# 展示层指标查询性能优化落地方案与任务清单

> 日期: 2026-06-03
> 状态: Draft
> 适用项目: 数据血缘分析系统
> 范围: 展示层 `/api/lineage/query` 指标/字段血缘查询从 10+ 秒降到可交互响应；重点优化 SQLite 使用方式、内存查询结构、查询结果组装路径。

## 1. 背景与结论

当前展示层查询一个指标需要 10+ 秒。表面上数据已经落在 SQLite 中，但当前实现并没有把 SQLite 当成查询引擎使用，而是把 SQLite 当成大型 `raw_json` 持久化容器。

实际查询链路接近:

```text
SQLite raw_json / ParseResult
    -> 全量读取或全量序列化
    -> Python dict/list
    -> Python BFS 追踪
    -> 再扫描全量 tables / field_mappings 补充展示数据
    -> 返回前端 D3 图谱
```

理想查询链路应改为:

```text
查询参数(table, field, depth, mode)
    -> 命中查询缓存或内存索引
    -> 只访问相关表、相关边、相关字段映射
    -> 必要时按 SQLite 索引补查
    -> 组装小结果集
    -> 节点详情/字段详情/口径详情懒加载
```

本地数据库现状:

| 项 | 现状 |
|----|------|
| 真实 SQLite 路径 | `output/output/lineage.db` |
| SQLite 文件大小 | 约 5.7GB |
| WAL 文件大小 | 约 327MB |
| `output/lineage_data.json` | 约 3.1GB |
| `tables` | 20,906 |
| `procedures` | 6,105 |
| `table_lineages` | 133,797 |
| `field_mappings` | 225,000 |
| `caliber_infos` | 76,682 |

结论: 10+ 秒主要来自全量数据转换、全量扫描、raw_json 读写模型和返回体膨胀，不是 SQLite 索引本身不可用。

## 2. 目标

### 2.1 必须达成

- 修正 SQLite 路径解析，避免 `output/output/lineage.db` 这类重复拼接。
- 展示层单次查询不再触发全量 `ParseResult.to_serializable()`。
- 展示层单次查询不再扫描全部 `field_mappings` 来补充展示数据。
- 表名解析、schema 校验、节点构建使用预构建索引，不再每次重建全量 map/set。
- 保持 `/api/lineage/query` 响应结构兼容。
- 保持现有测试通过。

### 2.2 应该达成

- 常用查询结果可被内存 LRU/TTL 缓存稳定命中。
- 首次查询和缓存命中查询分别记录可观测耗时。
- 节点详情、字段列表、口径详情改为懒加载，减少图谱首屏返回体。
- SQLite 提供按 target/source 索引读取相关映射和血缘的 repository 方法。

### 2.3 不在本轮范围

- 不重写所有 BFS 为 SQLite 递归 SQL。
- 不替换 FastAPI 或 D3 前端框架。
- 不改变解析器产出的业务语义。
- 不删除 legacy JSON/pickle 导出能力。

## 3. 根因拆解

### 3.1 SQLite 被当作 raw_json 容器

`SQLiteResultStore.load()` 当前按表全量读取:

```text
tables
procedures
table_lineages
field_mappings
caliber_infos
```

每张表通过 `SELECT raw_json FROM <table>` 读取全部行，再逐行 `json.loads`。这会绕过已经建立的 `source_table/target_table/source_column/target_column` 索引优势。

### 3.2 SQLite 路径拼接错误

配置默认值是:

```text
sqlite_db_path = "output/lineage.db"
```

`CacheStore` 又将相对路径拼到 `output_dir` 下，导致真实路径变成:

```text
output/output/lineage.db
```

这会造成排查混乱，也可能让不同命令和运行时读取不同数据库。

### 3.3 每次查询可能发生全量序列化

`ParserService.get_current_data()` 在 `_current_result` 存在时返回:

```python
self._current_result.to_serializable()
```

这会把所有 tables、procedures、table_lineages、field_mappings、caliber_infos 重新转换为 dict 列表。数据量大时，单次查询还没开始 BFS 就已经付出明显成本。

### 3.4 查询组装阶段仍有全量扫描

字段查询后，`LineageService._supplement_field_mappings()` 会对 `data.get("field_mappings", [])` 做过滤。即使图上只有几十个节点，也会扫描全部字段映射。

`_build_nodes()` 每次根据所有 tables 构建 `table_map`。`_validate_schema()` 和 `TableLineageTracer.resolve_table_name()` 也有每次构建实际表集合或短名集合的问题。

### 3.5 返回体包含可延后加载的数据

展示层首屏图谱查询会携带节点字段列表、字段映射、口径相关信息。首屏图谱并不总是需要完整字段列表和全部详情，这些内容更适合点击节点或边时懒加载。

## 4. 推荐架构

### 4.1 运行时内存查询索引

新增或扩展一个运行时查询索引对象，建议由 `ParserService` 或独立 `LineageQueryIndex` 持有。

建议索引:

| 索引 | key | value |
|------|-----|-------|
| `table_by_full` | `FULL_TABLE` | table dict |
| `table_by_short` | `SHORT_TABLE` | list/table candidates |
| `table_full_names` | none | set of full table names |
| `field_mappings_by_target` | `(target_table, target_column)` | list of mapping dict |
| `field_mappings_by_source` | `(source_table, source_column)` | list of mapping dict |
| `field_mappings_by_bare_pair` | `(src_bare, src_col, tgt_bare, tgt_col)` | list of mapping dict |
| `table_lineages_by_target` | `target_table` | list of lineage dict |
| `table_lineages_by_source` | `source_table` | list of lineage dict |

构建时机:

- 启动加载缓存后构建一次。
- 解析完成后重建一次。
- 上传增量数据合并后重建一次。
- 数据变更事件触发时清理旧索引并重建。

### 4.2 SQLite repository 按条件查询

SQLite 不再只提供 `load()` 全量接口，应补充查询接口:

```python
get_table_by_full(full_name)
search_tables(keyword, limit)
get_field_mappings_by_target(table, column)
get_field_mappings_by_source(table, column)
get_table_lineages_upstream(table)
get_table_lineages_downstream(table)
get_caliber_by_edge(src_table, src_col, tgt_table, tgt_col, proc)
```

短期优先使用内存索引，SQLite repository 作为冷启动、懒加载和后续大数据量场景的基础能力。

### 4.3 图谱首屏和详情懒加载分离

首屏 `/api/lineage/query` 只返回:

- nodes 基础信息: id、full_name、short_name、layer、comment。
- edges 基础信息: source_table、target_table、必要字段信息。
- counts、has_more、query_target、query_time_ms。

点击节点再请求:

- `/api/lineage/node-detail`
- `/api/lineage/node-caliber`
- `/api/lineage/edge-caliber`

字段列表默认不随首屏返回，除非显式 `include_fields=true`。

## 5. 任务拆分原则

任务必须满足“最小可重试”:

- 每个任务只改一个明确行为或一个明确基础设施点。
- 每个任务都能独立运行测试或脚本验证。
- 失败时只需要回滚当前任务，不影响已完成任务。
- 每个任务必须有验收命令和预期结果。
- 优先先加观测，再做优化，避免盲改。

## 6. 任务清单

### T0. 建立查询性能基线

**目标:** 在改代码前固定可重复的性能度量。

**改动范围:**

- 新增一个本地诊断脚本，例如 `scripts/profile_lineage_query.py`。
- 支持传入 table、field、depth、mode、repeat。
- 输出每次查询耗时、cache_hit、nodes_count、edges_count、field_mapping_count。

**最小实现:**

- 优先直接调用服务层；如果服务层导入受本机 Python 版本影响，则记录阻塞并改为 HTTP 调用本地服务。

**验收:**

```bash
python -m pytest tests/test_lineage_api.py -v
python scripts/profile_lineage_query.py --table <TABLE> --field <FIELD> --repeat 3
```

**预期结果:**

- 能稳定复现当前慢查询。
- 输出能区分首次查询和缓存命中查询。

**失败重试边界:**

- 只回滚诊断脚本，不触碰业务逻辑。

### T1. 修正 SQLite 路径解析

**目标:** 统一 SQLite 实际路径，避免 `output/output/lineage.db`。

**改动范围:**

- `app/services/cache_store.py`
- 必要时补充 `app/config.py` 单元测试。

**实施要点:**

- 优先使用 `config.sqlite_db_full_path`。
- 若没有 config，则保留 `output_dir / "lineage.db"` 作为 fallback。
- 避免将已经包含 `output/` 的相对路径再次拼到 `output_dir`。

**验收:**

```bash
python -m pytest tests/test_sqlite_store.py tests/test_app_config_routes.py -v
```

**预期结果:**

- 默认 SQLite 路径解析为项目根下 `output/lineage.db`。
- 设置 `SQLITE_DB_PATH` 为绝对路径时不再二次拼接。

**失败重试边界:**

- 只回滚 `CacheStore` 路径逻辑和对应测试。

### T2. 缓存 `ParseResult.to_serializable()` 结果

**目标:** 避免每次展示层查询重复全量模型转 dict。

**改动范围:**

- `app/services/parser_service.py`
- 相关单元测试。

**实施要点:**

- 新增 `_current_data_cache: dict | None`。
- `_populate_result_from_data(data)` 后直接缓存 `data`。
- `parse_existing_data()`、`parse_uploaded_files()` 解析/合并后更新 `_current_data_cache`。
- `get_current_data()` 优先返回 `_current_data_cache`。
- 数据变更或缓存清理时置空。

**验收:**

```bash
python -m pytest tests/test_parse_api.py tests/test_lineage_api.py -v
```

**预期结果:**

- API 响应结构不变。
- 重复调用 `get_current_data()` 不再重复执行全量 `to_serializable()`。

**失败重试边界:**

- 只回滚 `ParserService` 缓存字段和测试。

### T3. 建立 tables 查询索引

**目标:** 表名解析、schema 校验、节点构建不再每次扫描全部 tables。

**改动范围:**

- 新增 `app/services/lineage_query_index.py` 或扩展现有 repository。
- `app/services/lineage_service.py`
- `app/services/table_lineage_tracer.py`

**实施要点:**

- 构建 `table_by_full`、`table_by_short`、`table_full_names`。
- `LineageService._validate_schema()` 使用 `table_full_names`。
- `LineageService._build_nodes()` 使用 `table_by_full`。
- `TableLineageTracer.resolve_table_name()` 接收可选索引或由调用方先解析。

**验收:**

```bash
python -m pytest tests/test_lineage_api.py tests/test_repository_search.py -v
```

**预期结果:**

- 查询结果节点内容与原来一致。
- 表名解析测试通过。

**失败重试边界:**

- 可以保留索引类，回滚调用方切换逻辑。

### T4. 建立字段映射查询索引

**目标:** 字段查询补充映射时不再扫描全部 `field_mappings`。

**改动范围:**

- `app/services/lineage_query_index.py`
- `app/services/lineage_service.py`
- 相关测试。

**实施要点:**

- 构建 `field_mappings_by_target`、`field_mappings_by_source`。
- 构建 `field_mappings_by_bare_pair`，用于 `_supplement_field_mappings()` 按 `(src_bare, src_col, tgt_bare, tgt_col)` 精确补充。
- 替换 `_filter_field_mappings(data.get("field_mappings", []), ...)` 的全量扫描路径。
- 保留原全量扫描方法作为临时 fallback，并打 debug 日志。

**验收:**

```bash
python -m pytest tests/test_lineage_api.py tests/test_lineage_dedup.py tests/test_tracer_procedure.py -v
```

**预期结果:**

- 字段映射数量和去重行为与现有测试一致。
- 慢查询 profile 中 Python 扫描时间明显下降。

**失败重试边界:**

- 只回滚 `_supplement_field_mappings()` 的索引读取分支，保留 fallback。

### T5. 建立表级血缘查询索引统一入口

**目标:** 表级 BFS 和字段补充表级血缘使用同一份邻接索引，不重复构建。

**改动范围:**

- `app/services/table_lineage_tracer.py`
- `app/services/lineage_service.py`
- 相关测试。

**实施要点:**

- 确保 `TableLineageTracer.build_graph()` 只在数据变更时调用。
- 表级 trace 不依赖完整 `data` 做重复解析；只在必要时使用 table 索引解析起点。
- 将方向枚举和邻接读取保持单一入口。

**验收:**

```bash
python -m pytest tests/test_lineage_api.py tests/test_lineage_result_cleanup.py -v
```

**预期结果:**

- 表级查询和字段级补充表级血缘结果不变。
- 重复查询不重建 adjacency。

**失败重试边界:**

- 回滚 `TableLineageTracer.trace()` 签名变化，保留旧调用。

### T6. SQLite repository 增加按条件查询能力

**目标:** 为后续冷数据和懒加载提供真正使用 SQLite 索引的查询接口。

**改动范围:**

- `app/services/storage/sqlite_store.py`
- `app/services/storage/protocol.py`
- `app/repository.py` 或新增 SQLite repository adapter。
- `tests/test_sqlite_store.py`

**实施要点:**

- 不改现有 `load()` 行为，先新增方法。
- 查询语句必须使用已有索引字段。
- 返回 dict 结构需与 raw_json 反序列化后的结构兼容。

**建议接口:**

```python
get_field_mappings_by_target(table: str, column: str) -> list[dict]
get_field_mappings_by_source(table: str, column: str) -> list[dict]
get_table_lineages_by_target(table: str) -> list[dict]
get_table_lineages_by_source(table: str) -> list[dict]
get_table_by_full(full_name: str) -> dict | None
```

**验收:**

```bash
python -m pytest tests/test_sqlite_store.py -v
```

**预期结果:**

- 新方法能命中小结果集。
- `EXPLAIN QUERY PLAN` 显示使用对应 index。

**失败重试边界:**

- 只回滚新增方法，不影响现有全量 load。

### T7. 展示层首屏返回体瘦身

**目标:** 减少 `/api/lineage/query` 首屏 payload 和前端绘图压力。

**改动范围:**

- `app/services/lineage_service.py`
- `static/js/search-panel.js`
- `static/js/detail-panel.js`
- API 测试和必要的前端 e2e。

**实施要点:**

- 默认首屏不返回完整 columns。
- `include_fields=true` 时保持兼容。
- 点击节点时通过已有 `/api/lineage/node-detail` 拉取字段详情。
- 点击边或口径卡时继续使用懒加载接口。

**验收:**

```bash
python -m pytest tests/test_lineage_api.py -v
python -m pytest tests/frontend_e2e_test.py -v
```

**预期结果:**

- 首屏图谱正常显示。
- 节点详情仍能查看字段。
- payload 大小明显下降。

**失败重试边界:**

- 先后端支持参数，前端切换可独立回滚。

### T8. 查询耗时分段日志

**目标:** 后续性能回归能定位到具体阶段。

**改动范围:**

- `app/services/lineage_service.py`
- 可选新增轻量计时 helper。

**实施要点:**

- 记录以下阶段耗时:
  - refresh/cache check
  - get_current_data
  - resolve table
  - trace lineage
  - supplement mappings
  - build nodes
  - assemble response
- 日志级别建议 `debug`，慢查询超过阈值时 `info`。

**验收:**

```bash
python -m pytest tests/test_lineage_api.py -v
```

**预期结果:**

- 慢查询日志能显示最耗时阶段。
- 正常请求日志不刷屏。

**失败重试边界:**

- 只回滚日志 helper 和调用点。

### T9. 查询缓存 key 和失效策略校验

**目标:** 确保重复查询能稳定命中缓存，数据更新后不会返回旧图。

**改动范围:**

- `app/utils/cache_manager.py`
- `app/services/lineage_service.py`
- 相关测试。

**实施要点:**

- cache key 包含 table、field、depth、mode、include_fields、limit。
- 数据变更事件清理查询缓存和索引。
- 缓存命中时不要修改缓存对象本体，避免污染后续返回。

**验收:**

```bash
python -m pytest tests/test_lineage_api.py tests/test_progress_tasks.py -v
```

**预期结果:**

- 第二次相同查询 `cache_hit=true`。
- 数据更新后查询缓存失效。

**失败重试边界:**

- 只回滚 cache key 和返回复制逻辑。

### T10. 性能回归测试与验收报告

**目标:** 用可重复证据证明优化有效。

**改动范围:**

- `scripts/profile_lineage_query.py`
- 新增 `docs/plans/2026-06-03-display-query-performance-result.md` 或在本文件补充结果。

**验收命令:**

```bash
python scripts/profile_lineage_query.py --table <TABLE> --field <FIELD> --repeat 5
python -m pytest tests/
```

**验收指标建议:**

| 场景 | 目标 |
|------|------|
| 缓存未命中字段查询 | P50 小于 2s |
| 缓存命中字段查询 | P50 小于 200ms |
| 表级查询 | P50 小于 1s |
| 首屏 payload | 较优化前下降 50% 以上 |

**失败重试边界:**

- 只调整 profile 脚本或验收文档，不影响业务代码。

## 7. 推荐执行顺序

```text
T0 基线
  -> T1 SQLite 路径
  -> T2 避免全量序列化
  -> T3 tables 索引
  -> T4 field_mappings 索引
  -> T5 table_lineages 索引统一
  -> T8 分段日志
  -> T9 缓存策略
  -> T7 返回体瘦身
  -> T6 SQLite 条件查询接口
  -> T10 验收报告
```

说明:

- T1、T2、T3、T4 是最可能快速降低 10+ 秒查询的主路径。
- T6 是架构正确性补强，但不一定要阻塞第一轮性能收益。
- T7 涉及前端行为，建议在后端性能稳定后做。

## 8. 风险与应对

| 风险 | 影响 | 应对 |
|------|------|------|
| 索引归一化规则与原逻辑不一致 | 查询结果缺边或多边 | 每个索引切换保留 fallback，并用现有 dedup/lineage 测试覆盖 |
| 缓存返回对象被原地修改 | 后续响应污染 | cache get 返回 copy 或命中后复制再写 `query_time_ms/cache_hit` |
| SQLite 路径修正后读不到旧库 | 启动误判无缓存 | 提供一次性迁移/复制说明，或兼容探测旧 `output/output/lineage.db` 并告警 |
| 首屏返回体瘦身破坏前端 | 图谱显示不完整 | 后端先保留 `include_fields=true` 兼容参数，前端分步切换 |
| 性能脚本依赖本机 Python 版本 | 无法直接导入服务层 | profile 脚本支持 HTTP 模式作为 fallback |

## 9. Definition of Done

- `python -m pytest tests/` 通过。
- 慢查询 profile 有优化前后对比。
- 常用字段查询不再出现 10+ 秒。
- 重复相同查询能稳定缓存命中。
- `/api/lineage/query` 响应结构向后兼容，前端展示层可正常查询和查看详情。
- SQLite 路径在日志中清晰可见，不再出现默认 `output/output/lineage.db`。

