# SQLite 数据存储迁移详细设计与任务清单

> 日期: 2026-05-25  
> 状态: Draft  
> 适用项目: 数据血缘分析系统  
> 范围: 将解析结果持久化层从 pickle/json 双写逐步迁移到 SQLite，同时保留现有内存图查询模型。

## 1. 背景与结论

当前系统的核心解析结果通过 `CacheStore` 持久化到 `output/lineage_data.pkl` 与 `output/lineage_data.json`。`DataRepository` 负责把 JSON 加载到内存并建立轻量索引，血缘和口径查询仍主要依赖 `ParseResult`、`LineageTracer`、`CaliberTracer` 等内存对象。

本地运行数据已经显示明显的存储膨胀:

| 路径 | 当前体积 | 说明 |
|------|----------|------|
| `output/lineage_data.json` | 约 3.1G | 全量 JSON 缓存，体积最大 |
| `output/lineage_data.pkl` | 约 928M | pickle 缓存 |
| `output/` | 约 4.1G | 包含缓存和历史 HTML 输出 |
| `SOURCE_DATA/` | 约 313M | 原始数据源 |

结论: SQLite 迁移可行且有必要，但应采用渐进式迁移。第一阶段只替换持久化层，第二阶段利用 SQLite 索引承接搜索类查询，第三阶段再实现真正的增量落库。短期不建议把图追踪算法完全改为 SQL 递归查询。

## 2. 迁移目标

### 2.1 必须达成

- 用 SQLite 替代默认的 pickle/json 双写缓存。
- 保留现有 `ParseResult`、`LineageTracer`、`CaliberTracer` 的内存查询方式。
- 启动时可以从 SQLite 加载解析结果并重建内存索引。
- 保留 JSON 导出能力，但不再把 JSON 作为默认运行缓存。
- 支持缓存 schema 版本、解析器版本、数据源摘要等元数据。
- 保持现有 API 响应结构兼容。
- 保持现有测试通过。

### 2.2 应该达成

- 搜索类接口优先使用 SQLite 索引降低全量扫描。
- 增量上传解析时只更新受影响过程和关系，不再全量重写大文件。
- 任务记录可选持久化，便于重启后查看最近任务历史。
- 提供 JSON/pickle 到 SQLite 的一次性迁移命令。
- 支持回滚到旧缓存模式。

### 2.3 不在首轮范围

- 不把 `SOURCE_DATA/` 原始 SQL 文件导入数据库。
- 不把 D3 可视化 HTML 输出存入 SQLite。
- 不把 SSE 订阅队列持久化。
- 不重写核心 BFS 图追踪为 SQL 递归查询。
- 不引入外部数据库服务。

## 3. 当前代码影响面

| 模块 | 当前职责 | 迁移影响 |
|------|----------|----------|
| `app/services/cache_store.py` | pickle/json 读写缓存 | 第一阶段核心改造点，新增 SQLite 后端 |
| `app/repository.py` | 从 JSON 加载数据并建内存索引 | 改为可从 SQLite 数据源加载数据（见附录 A） |
| `app/services/parser_service.py` | 解析、合并、保存解析结果 | 保存路径改为 SQLite，保留 `ParseResult` |
| `app/services/lineage_service.py` | 构建内存索引、血缘查询 | 第一阶段需改造缓存刷新检测（见附录 B），第二阶段搜索可读 SQLite |
| `app/services/caliber_service.py` | 构建口径索引、口径查询 | 第一阶段基本不改，第二阶段搜索可读 SQLite |
| `app/services/indicator_service.py` | 指标血缘查询，独立 CacheManager | 第一阶段不改，第二阶段明确是否入库（见附录 C） |
| `app/services/progress_service.py` | 内存任务状态和 SSE 推送 | 第三阶段可选持久化任务摘要 |
| `app/dependencies.py` | @lru_cache 单例服务工厂 | 第一阶段需配合 SQLite 连接策略调整（见附录 D） |
| `app/config.py` | 输出目录和缓存开关配置 | 新增 SQLite 路径和缓存后端配置 |
| `tests/` | 单元和 API 测试 | 需要补充 SQLite 存储和迁移测试 |

## 4. 推荐总体架构

### 4.1 存储分层

```text
ParserRegistry / core parsers
        |
        v
ParseResult dataclass objects
        |
        v
ParserService._save_result_to_cache()
        |
        v
CacheStore facade
        |
        +-- SQLiteResultStore    默认
        +-- JsonPickleStore      兼容/回滚
        |
        v
output/lineage.db
```

### 4.2 查询分层

```text
FastAPI route
   |
   v
LineageService / CaliberService
   |
   +-- 内存 tracer: 复杂血缘和口径追踪
   +-- SQLite indexes: 搜索、列表、直接命中类查询
```

### 4.3 设计原则

- `CacheStore` 保持 facade 角色，调用方不感知底层是 SQLite 还是 json/pickle。
- SQLite 是持久化事实来源，内存对象是运行时查询加速结构。
- 数据库 schema 以解析结果结构为中心，不强行过度范式化复杂字段。
- 对可搜索、可关联字段使用列；对复杂扩展字段使用 JSON 文本列。
- 增量更新以 `procedure.full_name`、`table.full_name`、关系唯一键为边界。

## 5. SQLite 数据模型设计

### 5.1 数据库文件

默认路径:

```text
output/lineage.db
```

新增配置建议:

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| `STORAGE_BACKEND` | `sqlite` | 可选 `sqlite` / `legacy` |
| `SQLITE_DB_PATH` | `output/lineage.db` | SQLite 文件路径 |
| `ENABLE_LEGACY_CACHE_WRITE` | `false` | 是否继续写 json/pickle |
| `ENABLE_JSON_EXPORT` | `true` | 是否允许手动导出 JSON |

### 5.2 表结构

#### `storage_metadata`

保存缓存版本、解析器版本、更新时间、统计数。

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `key` | TEXT | PRIMARY KEY | 元数据键 |
| `value` | TEXT | NOT NULL | 元数据值 |
| `updated_at` | REAL | NOT NULL | 更新时间戳 |

推荐 key:

- `cache_schema_version`
- `parser_version`
- `last_updated`
- `total_tables`
- `total_procedures`
- `total_table_lineages`
- `total_field_mappings`
- `total_caliber_infos`
- `data_sources_json`

#### `tables`

保存表结构摘要。复杂字段如 columns 可先用 JSON 存储。

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `full_name` | TEXT | PRIMARY KEY | 大写归一化全名 |
| `schema_name` | TEXT | INDEX | schema |
| `table_name` | TEXT | INDEX | 短表名 |
| `description` | TEXT | | 描述 |
| `layer` | TEXT | INDEX | 分层标识 |
| `data_source` | TEXT | INDEX | 数据源 |
| `columns_json` | TEXT | | 字段列表 JSON |
| `raw_json` | TEXT | NOT NULL | 原始 dict JSON |
| `updated_at` | REAL | NOT NULL | 更新时间 |

#### `procedures`

保存过程摘要及原始数据。

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `full_name` | TEXT | PRIMARY KEY | 过程全名 |
| `schema_name` | TEXT | INDEX | schema |
| `proc_name` | TEXT | INDEX | 过程短名 |
| `description` | TEXT | | 描述 |
| `data_source` | TEXT | INDEX | 数据源 |
| `source_tables_json` | TEXT | | 来源表 JSON |
| `target_tables_json` | TEXT | | 目标表 JSON |
| `raw_json` | TEXT | NOT NULL | 原始 dict JSON |
| `updated_at` | REAL | NOT NULL | 更新时间 |

#### `table_lineages`

保存表级血缘边。

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `id` | INTEGER | PRIMARY KEY AUTOINCREMENT | 自增 ID |
| `source_table` | TEXT | INDEX | 来源表 |
| `target_table` | TEXT | INDEX | 目标表 |
| `procedure_name` | TEXT | INDEX | 过程 |
| `data_source` | TEXT | INDEX | 数据源 |
| `raw_json` | TEXT | NOT NULL | 原始 dict JSON |
| `updated_at` | REAL | NOT NULL | 更新时间 |

唯一约束:

```sql
UNIQUE(source_table, target_table, procedure_name)
```

#### `field_mappings`

保存字段级映射。

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `id` | INTEGER | PRIMARY KEY AUTOINCREMENT | 自增 ID |
| `source_table` | TEXT | INDEX | 来源表 |
| `source_column` | TEXT | INDEX | 来源字段 |
| `target_table` | TEXT | INDEX | 目标表 |
| `target_column` | TEXT | INDEX | 目标字段 |
| `procedure_name` | TEXT | INDEX | 过程 |
| `confidence` | REAL | | 置信度 |
| `transform_logic` | TEXT | | 转换逻辑 |
| `raw_json` | TEXT | NOT NULL | 原始 dict JSON |
| `updated_at` | REAL | NOT NULL | 更新时间 |

唯一约束:

```sql
UNIQUE(source_table, source_column, target_table, target_column, procedure_name)
```

#### `caliber_infos`

保存口径信息。

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `id` | INTEGER | PRIMARY KEY AUTOINCREMENT | 自增 ID |
| `target_table` | TEXT | INDEX | 目标表 |
| `target_column` | TEXT | INDEX | 目标字段 |
| `source_table` | TEXT | INDEX | 来源表 |
| `source_column` | TEXT | INDEX | 来源字段 |
| `procedure_name` | TEXT | INDEX | 过程 |
| `step_num` | INTEGER | INDEX | 步骤号 |
| `data_source` | TEXT | INDEX | 数据源 |
| `raw_json` | TEXT | NOT NULL | 原始 dict JSON |
| `updated_at` | REAL | NOT NULL | 更新时间 |

唯一约束:

```sql
UNIQUE(target_table, target_column, source_table, source_column, procedure_name, step_num)
```

#### `parse_tasks`（第三阶段可选）

保存任务摘要，SSE 实时队列仍保留内存。

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `task_id` | TEXT | PRIMARY KEY | 任务 ID |
| `status` | TEXT | INDEX | 状态 |
| `files_received` | INTEGER | | 文件数量 |
| `progress_percent` | REAL | | 进度 |
| `current_file` | TEXT | | 当前文件 |
| `message` | TEXT | | 消息 |
| `result_json` | TEXT | | 结果摘要 |
| `error` | TEXT | | 错误 |
| `created_at` | REAL | INDEX | 创建时间 |
| `updated_at` | REAL | INDEX | 更新时间 |

### 5.3 索引建议

```sql
CREATE INDEX IF NOT EXISTS idx_tables_short_name ON tables(table_name);
CREATE INDEX IF NOT EXISTS idx_tables_schema ON tables(schema_name);
CREATE INDEX IF NOT EXISTS idx_procedures_short_name ON procedures(proc_name);
CREATE INDEX IF NOT EXISTS idx_table_lineages_source ON table_lineages(source_table);
CREATE INDEX IF NOT EXISTS idx_table_lineages_target ON table_lineages(target_table);
CREATE INDEX IF NOT EXISTS idx_table_lineages_proc ON table_lineages(procedure_name);
CREATE INDEX IF NOT EXISTS idx_field_mappings_source ON field_mappings(source_table, source_column);
CREATE INDEX IF NOT EXISTS idx_field_mappings_target ON field_mappings(target_table, target_column);
CREATE INDEX IF NOT EXISTS idx_field_mappings_proc ON field_mappings(procedure_name);
CREATE INDEX IF NOT EXISTS idx_caliber_target ON caliber_infos(target_table, target_column);
CREATE INDEX IF NOT EXISTS idx_caliber_source ON caliber_infos(source_table, source_column);
CREATE INDEX IF NOT EXISTS idx_caliber_proc ON caliber_infos(procedure_name);
```

### 5.4 SQLite pragma 建议

启动连接时设置:

```sql
PRAGMA journal_mode=WAL;
PRAGMA synchronous=NORMAL;
PRAGMA foreign_keys=ON;
PRAGMA temp_store=MEMORY;
```

说明:

- WAL 支持读写并发，适合 FastAPI 查询与后台解析并存。
- `synchronous=NORMAL` 在本地工具型应用中性能和可靠性较均衡。
- 写入仍应放在显式事务中，避免半写入状态。

## 6. 阶段一: SQLite 替代 pickle/json 持久化

### 6.1 目标

将 `CacheStore` 默认后端改为 SQLite，保留现有服务层接口和内存查询行为。

### 6.2 设计

新增模块建议:

```text
app/services/storage/
├── __init__.py
├── sqlite_store.py
├── legacy_store.py
└── migrations.py
```

核心接口:

```python
class ResultStoreProtocol(Protocol):
    def load(self) -> Optional[dict[str, Any]]: ...
    def save(self, result_data: dict[str, Any]) -> None: ...
    def clear(self) -> None: ...
    def export_json(self, path: Path) -> None: ...
```

`CacheStore` 调整为 facade:

- 初始化时根据 `config.storage_backend` 选择 `SQLiteResultStore` 或 `LegacyJsonPickleStore`。
- `load_from_cache()` 继续返回 dict。
- `save_to_cache()` 继续接收 dict。
- `get_repository()` 继续返回 `DataRepository`。
- `clear_cache()` 清理 SQLite 表数据或旧文件。

`SQLiteResultStore.save()` 行为:

1. 开启事务。
2. 清空解析结果表或按全量 replace 策略写入。
3. 批量插入 `tables`、`procedures`、`table_lineages`、`field_mappings`、`caliber_infos`。
4. 写入 `storage_metadata`。
5. 提交事务。

第一阶段可以先采用“全量 replace”策略，因为它已经能替代 3.1G JSON 和 928M pickle 双写。真正增量更新放到第三阶段。

`SQLiteResultStore.load()` 行为:

1. 读取 `storage_metadata`。
2. 校验 `cache_schema_version`。
3. 查询所有结果表。
4. 用 `raw_json` 还原为当前 `ParseResult.from_serializable()` 兼容的 dict 结构。
5. 返回:

```python
{
    "metadata": {...},
    "tables": [...],
    "procedures": [...],
    "table_lineages": [...],
    "field_mappings": [...],
    "caliber_infos": [...],
}
```

### 6.3 任务清单

#### Wave 1.0: 存储基础设施

- [T1.0.1] 创建 SQLite 存储包
  - 操作: 新建 `app/services/storage/__init__.py`。
  - 输入: 现有 `app/services/cache_store.py`。
  - 输出: `app/services/storage/__init__.py`。
  - 完成标准: 包可被测试导入。
  - 依赖: 无。

- [T1.0.2] 定义存储协议
  - 操作: 新建 `app/services/storage/protocol.py`，定义 `ResultStoreProtocol`。
  - 输入: `CacheStore.load_from_cache()` 和 `save_to_cache()` 当前签名。
  - 输出: `app/services/storage/protocol.py`。
  - 完成标准: mypy/静态导入无循环依赖。
  - 依赖: T1.0.1。

- [T1.0.3] 编写 SQLite migrations
  - 操作: 新建 `app/services/storage/migrations.py`，包含 schema 创建 SQL。
  - 输入: 本设计第 5 节。
  - 输出: `app/services/storage/migrations.py`。
  - 完成标准: 测试能在临时目录创建完整数据库表。
  - 依赖: T1.0.1。

- [T1.0.4] 增加配置项
  - 操作: 修改 `app/config.py`，加入 `storage_backend`、`sqlite_db_path`、`enable_legacy_cache_write`。
  - 输入: 当前 `AppConfig`。
  - 输出: `app/config.py`。
  - 完成标准: 环境变量可覆盖默认配置。
  - 依赖: 无。

#### Wave 1.1: SQLiteResultStore 实现

- [T1.1.1] 实现 SQLite 连接管理
  - 操作: 新建 `app/services/storage/sqlite_store.py`，实现 `SQLiteConnectionManager`（`threading.local()` 每线程连接）、pragma 设置、schema 初始化。
  - 输入: T1.0.3。
  - 输出: `app/services/storage/sqlite_store.py`。
  - 完成标准: 多线程并发读写测试通过，无 `ProgrammingError: SQLite objects created in a thread can only be used in that same thread` 异常。
  - 依赖: T1.0.2, T1.0.3。

- [T1.1.2] 实现元数据读写
  - 操作: 在 `SQLiteResultStore` 中实现 `storage_metadata` upsert 和读取。
  - 输入: result_data.metadata。
  - 输出: `app/services/storage/sqlite_store.py`。
  - 完成标准: 保存后可读取 `cache_schema_version`、统计数和更新时间。
  - 依赖: T1.1.1。

- [T1.1.3] 实现解析结果批量写入
  - 操作: 将 result_data 的五类数据批量写入 SQLite。
  - 输入: `tables`、`procedures`、`table_lineages`、`field_mappings`、`caliber_infos`。
  - 输出: `app/services/storage/sqlite_store.py`。
  - 完成标准: 测试保存样例数据后行数与 metadata 一致。
  - 依赖: T1.1.2。

- [T1.1.4] 实现 SQLite 到 dict 反序列化
  - 操作: 从各表 `raw_json` 还原现有 dict 结构。
  - 输入: SQLite 表数据。
  - 输出: `app/services/storage/sqlite_store.py`。
  - 完成标准: `ParseResult.from_serializable()` 可消费返回数据。
  - 依赖: T1.1.3。

- [T1.1.5] 实现 clear 和 export_json
  - 操作: 支持清空 SQLite 数据，并可手动导出 JSON。
  - 输入: SQLite 数据。
  - 输出: `app/services/storage/sqlite_store.py`。
  - 完成标准: clear 后 load 返回 None，export 文件 JSON 可读。
  - 依赖: T1.1.4。

#### Wave 1.2: CacheStore 集成

- [T1.2.1] 保留 LegacyJsonPickleStore
  - 操作: 抽出现有 pickle/json 逻辑到 `app/services/storage/legacy_store.py`。
  - 输入: `app/services/cache_store.py` 当前实现。
  - 输出: `app/services/storage/legacy_store.py`。
  - 完成标准: legacy 模式现有缓存测试通过。
  - 依赖: T1.0.2。

- [T1.2.2] 改造 CacheStore facade
  - 操作: 修改 `app/services/cache_store.py`，根据配置委派到 SQLite 或 legacy。
  - 输入: T1.1.x, T1.2.1。
  - 输出: `app/services/cache_store.py`。
  - 完成标准: `ParserService` 无需改签名即可读写 SQLite。
  - 依赖: T1.1.5, T1.2.1。

- [T1.2.3] 调整 DataRepository 加载入口
  - 操作: 将 `DataRepository.__init__` 改为无路径参数，新增 `load_from_dict()` 和 `load_from_json()` 方法，移除对 JSON 文件路径的硬依赖。详见附录 A。
  - 输入: `DataRepository` 当前实现。
  - 输出: `app/repository.py`。
  - 完成标准: SQLite load 后 repository 内存索引可用，legacy 模式下 `load_from_json()` 正常工作。
  - 依赖: T1.2.2。

- [T1.2.4] 保持 JSON 导出兼容
  - 操作: 在系统 API 或脚本入口提供手动导出 JSON 能力。
  - 输入: `SQLiteResultStore.export_json()`。
  - 输出: `app/api/system.py` 或 `scripts/export_lineage_json.py`。
  - 完成标准: 用户可显式导出 `lineage_data.json`。
  - 依赖: T1.1.5。

- [T1.2.5] 改造 LineageService 缓存刷新检测
  - 操作: 将 `_check_and_refresh_cache()` 从检测 `lineage_data.json` 文件 mtime 改为检测 `DataRepository.get_metadata()` 中的 `last_updated` 时间戳。详见附录 B。
  - 输入: `LineageService._check_and_refresh_cache()` 当前实现。
  - 输出: `app/services/lineage_service.py`。
  - 完成标准: SQLite 模式下数据更新后缓存自动刷新，legacy 模式下行为不变。
  - 依赖: T1.2.2。

#### Wave 1.3: 测试与验证

- [T1.3.1] 增加 SQLite store 单元测试
  - 操作: 新建 `tests/test_sqlite_store.py`。
  - 输入: 小型 result_data fixture。
  - 输出: `tests/test_sqlite_store.py`。
  - 完成标准: save/load/clear/export 全覆盖。
  - 依赖: T1.1.5。

- [T1.3.2] 增加 CacheStore 后端选择测试
  - 操作: 验证 `STORAGE_BACKEND=sqlite` 和 `legacy` 均可工作。
  - 输入: T1.2.2。
  - 输出: `tests/test_cache_store_backend.py`。
  - 完成标准: 两种后端测试通过。
  - 依赖: T1.2.2。

- [T1.3.3] 跑现有核心测试
  - 操作: 执行 repository、parse、lineage、caliber 相关测试。
  - 输入: 全部一阶段改动。
  - 输出: 测试结果。
  - 完成标准: 现有 API 行为不回归。
  - 依赖: T1.3.1, T1.3.2。

### 6.4 阶段一验收标准

| AC-ID | 验收标准 | 验证方式 |
|-------|----------|----------|
| AC-1.1 | 启动后可以从 `output/lineage.db` 加载解析结果 | 自动化测试 + 手动启动 |
| AC-1.2 | 默认不再生成 3G 级 `lineage_data.json` | 文件系统检查 |
| AC-1.3 | `ParserService.get_current_data()` 返回结构不变 | 单元测试 |
| AC-1.4 | 现有血缘和口径 API 响应结构不变 | API 测试 |
| AC-1.5 | legacy 后端可通过配置回滚 | 配置测试 |

## 7. 阶段二: SQLite 索引承接搜索类查询

### 7.1 目标

在不改变复杂图追踪的前提下，把表搜索、过程搜索、口径直接搜索等适合数据库索引的查询迁移到 SQLite。

### 7.2 设计

新增查询方法建议:

```python
class SQLiteResultStore:
    def search_tables(self, keyword: str, limit: int = 50) -> list[dict]: ...
    def search_procedures(self, keyword: str, limit: int = 50) -> list[dict]: ...
    def search_caliber(self, table: str, field: str = "", limit: int = 200) -> list[dict]: ...
    def get_table(self, full_name: str) -> Optional[dict]: ...
    def get_procedure(self, full_name: str) -> Optional[dict]: ...
```

查询策略:

- 精确匹配优先: `table_name = ?`、`full_name = ?`。
- schema 语义加权保留: 复用 `search_table_dicts()` 的排序规则，或者在 SQL 初筛后 Python 排序。
- LIKE 初筛限制范围: `UPPER(table_name) LIKE ? OR UPPER(full_name) LIKE ?`。
- 数据库只负责缩小候选集，最终排序仍可复用现有 Python 逻辑。

`LineageService` 与 `CaliberService` 的复杂查询仍保持:

- 内存 tracer 处理 BFS。
- `CacheManager` 继续缓存最终结果。
- SQLite 只参与搜索和直接列表类接口。

### 7.3 任务清单

#### Wave 2.0: Repository 查询适配

- [T2.0.1] 扩展 DataRepository 数据源接口
  - 操作: 让 `DataRepository` 可委托 store 执行搜索。
  - 输入: `DataRepository.search_tables()` 当前实现。
  - 输出: `app/repository.py`。
  - 完成标准: repository 支持内存和 SQLite 两种搜索来源。
  - 依赖: 阶段一完成。

- [T2.0.2] 实现 SQLite 表搜索
  - 操作: 在 `SQLiteResultStore` 中实现 `search_tables()`。
  - 输入: `tables` 表和索引。
  - 输出: `app/services/storage/sqlite_store.py`。
  - 完成标准: 搜索结果排序与现有 `search_table_dicts()` 兼容。
  - 依赖: T2.0.1。

- [T2.0.3] 实现 SQLite 过程搜索
  - 操作: 在 `SQLiteResultStore` 中实现 `search_procedures()`。
  - 输入: `procedures` 表和索引。
  - 输出: `app/services/storage/sqlite_store.py`。
  - 完成标准: 过程搜索返回原始 dict。
  - 依赖: T2.0.1。

- [T2.0.4] 实现 SQLite 口径搜索
  - 操作: 在 `SQLiteResultStore` 中实现 `search_caliber()`。
  - 输入: `caliber_infos` 表和索引。
  - 输出: `app/services/storage/sqlite_store.py`。
  - 完成标准: 按表名和字段过滤结果，limit 生效。
  - 依赖: T2.0.1。

#### Wave 2.1: 服务层使用索引

- [T2.1.1] 接入 ParserService.search_tables
  - 操作: 当 `_current_result` 不存在或配置启用 SQLite 搜索时，调用 repository/store 搜索。
  - 输入: `ParserService.search_tables()`。
  - 输出: `app/services/parser_service.py`。
  - 完成标准: 表搜索无需全量读取 JSON。
  - 依赖: T2.0.2。

- [T2.1.2] 接入 LineageService 过程搜索
  - 操作: 将过程搜索路径改为优先 SQLite 索引，保留内存 fallback。
  - 输入: `LineageService.search_procedures()`。
  - 输出: `app/services/lineage_service.py`。
  - 完成标准: 搜索 API 响应结构不变。
  - 依赖: T2.0.3。

- [T2.1.3] 接入 CaliberService 快速搜索
  - 操作: 对关键词和直接口径搜索优先使用 SQLite 初筛。
  - 输入: `CaliberService.search_indicators()`、`get_direct_sources()` 相关路径。
  - 输出: `app/services/caliber_service.py`。
  - 完成标准: 口径搜索结果与旧逻辑一致或更稳定。
  - 依赖: T2.0.4。

#### Wave 2.2: 性能与一致性测试

- [T2.2.1] 增加搜索一致性测试
  - 操作: 同一 fixture 下比较内存搜索与 SQLite 搜索结果。
  - 输入: 小型解析结果 fixture。
  - 输出: `tests/test_sqlite_search.py`。
  - 完成标准: 表、过程、口径搜索结果一致。
  - 依赖: T2.1.x。

- [T2.2.2] 增加大样本性能 smoke test
  - 操作: 构造至少万级 rows 的临时 SQLite 数据，验证搜索在可接受时间内返回。
  - 输入: synthetic fixture。
  - 输出: `tests/test_sqlite_search_performance.py`。
  - 完成标准: 搜索不触发全量 Python 扫描。
  - 依赖: T2.0.x。

- [T2.2.3] 验证并发读写行为
  - 操作: WAL 模式下模拟后台写入和前台读取。
  - 输入: SQLite store。
  - 输出: `tests/test_sqlite_concurrency.py`。
  - 完成标准: 读请求不因写事务出现未处理异常。
  - 依赖: T2.0.x。

### 7.4 阶段二验收标准

| AC-ID | 验收标准 | 验证方式 |
|-------|----------|----------|
| AC-2.1 | 表搜索可由 SQLite 索引返回候选结果 | 单元测试 |
| AC-2.2 | 过程搜索可由 SQLite 索引返回候选结果 | 单元测试 |
| AC-2.3 | 口径搜索可由 SQLite 索引返回候选结果 | 单元测试 |
| AC-2.4 | 复杂血缘查询仍使用现有 tracer，结果不回归 | API 测试 |
| AC-2.5 | 大样本搜索避免全量 JSON 加载 | 性能 smoke test |

## 8. 阶段三: 增量解析真正落库

### 8.1 目标

上传或重新解析局部文件时，只更新受影响的表、过程、血缘和字段映射，避免全量重写 SQLite 结果集。

### 8.2 设计

第一阶段的 save 是全量 replace。第三阶段引入增量写入接口:

```python
class SQLiteResultStore:
    def replace_result(self, result_data: dict[str, Any]) -> None: ...
    def upsert_partial_result(self, partial_data: dict[str, Any], mode: str) -> None: ...
    def delete_by_procedures(self, procedure_names: list[str]) -> None: ...
    def delete_by_tables(self, table_names: list[str]) -> None: ...
```

增量上传处理建议:

1. 解析上传文件得到 partial `ParseResult`。
2. 从 partial 中提取受影响过程:
   - `procedures[*].full_name`
   - `table_lineages[*].procedure`
   - `field_mappings[*].procedure`
   - `caliber_infos[*].procedure`
3. 在事务中删除这些过程对应的旧关系。
4. upsert 新的 `procedures`、`table_lineages`、`field_mappings`、`caliber_infos`。
5. 对 `tables` 做 upsert，不轻易删除，除非 full refresh。
6. 更新 metadata 统计数。
7. 发布 `DATA_CHANGED`，重建内存 tracer。

全量解析处理建议:

- 使用 `replace_result()`。
- 先写入临时表或在事务内清空后批量插入。
- 失败时事务回滚，旧数据仍可用。

任务历史处理建议:

- `ProgressService` 仍保留内存订阅队列。
- `parse_tasks` 只保存任务摘要和最终状态。
- 重启后 `/api/parse/tasks` 可以展示历史任务，但不能恢复 SSE 连接。

### 8.3 任务清单

#### Wave 3.0: 增量边界定义

- [T3.0.1] 实现 partial result 影响范围提取器
  - 操作: 新建函数提取 affected procedures/tables。
  - 输入: partial `ParseResult.to_serializable()`。
  - 输出: `app/services/storage/delta.py`。
  - 完成标准: 测试覆盖 procedure、table、caliber 三类来源。
  - 依赖: 阶段一完成。

- [T3.0.2] 定义增量删除策略
  - 操作: 明确按 procedure 删除关系、按 table upsert 表结构的策略。
  - 输入: 当前 `ParseResult.merge()` 逻辑。
  - 输出: `app/services/storage/delta.py` 或设计注释。
  - 完成标准: 重复解析同一过程不会留下旧边。
  - 依赖: T3.0.1。

#### Wave 3.1: SQLite 增量写入

- [T3.1.1] 实现 delete_by_procedures
  - 操作: 删除指定过程关联的 procedure、table_lineages、field_mappings、caliber_infos。
  - 输入: procedure_names。
  - 输出: `app/services/storage/sqlite_store.py`。
  - 完成标准: 删除后相关边和口径均不存在。
  - 依赖: T3.0.2。

- [T3.1.2] 实现 upsert_partial_result
  - 操作: 在事务中先删旧关系再插入新结果。
  - 输入: partial result_data。
  - 输出: `app/services/storage/sqlite_store.py`。
  - 完成标准: 同一文件重复增量解析行数稳定。
  - 依赖: T3.1.1。

- [T3.1.3] 更新 metadata 统计
  - 操作: 增量写入后按表计数刷新 metadata。
  - 输入: SQLite 当前行数。
  - 输出: `app/services/storage/sqlite_store.py`。
  - 完成标准: `/api/stats` 展示统计准确。
  - 依赖: T3.1.2。

#### Wave 3.2: ParserService 增量接入

- [T3.2.1] 区分 full replace 与 incremental upsert
  - 操作: 修改 `ParserService.parse_uploaded_files()` 保存路径。
  - 输入: `mode` 参数。
  - 输出: `app/services/parser_service.py`。
  - 完成标准: incremental 模式调用 `upsert_partial_result()`。
  - 依赖: T3.1.2。

- [T3.2.2] 增量后重载内存结果
  - 操作: 增量写库成功后从 SQLite load 最新全量 dict 并重建 `_current_result`。
  - 输入: SQLiteResultStore.load()。
  - 输出: `app/services/parser_service.py`。
  - 完成标准: 增量解析后查询能看到新数据。
  - 依赖: T3.2.1。

- [T3.2.3] 失效 tracer 与查询缓存
  - 操作: 确认 `DATA_CHANGED` 后所有 tracer/cache 被清理或重建。
  - 输入: `EventBus` 当前事件。
  - 输出: `app/services/parser_service.py`、`lineage_service.py`、`caliber_service.py`。
  - 完成标准: 增量解析后没有旧图缓存污染。
  - 依赖: T3.2.2。

#### Wave 3.3: 任务历史持久化（可选）

- [T3.3.1] 实现 ParseTaskStore
  - 操作: 新增 `app/services/storage/task_store.py`。
  - 输入: `ParseTask` dataclass。
  - 输出: `app/services/storage/task_store.py`。
  - 完成标准: create/update/complete/fail 可写入 `parse_tasks`。
  - 依赖: 阶段一 schema。

- [T3.3.2] 接入 ProgressService
  - 操作: 在任务创建、进度更新、完成、失败时写任务摘要。
  - 输入: `ProgressService`。
  - 输出: `app/services/progress_service.py`。
  - 完成标准: 重启后可列出最近任务摘要。
  - 依赖: T3.3.1。

- [T3.3.3] 限制历史任务保留
  - 操作: 增加按时间或数量清理 `parse_tasks` 的逻辑。
  - 输入: config。
  - 输出: `app/services/storage/task_store.py`。
  - 完成标准: 任务历史不会无限增长。
  - 依赖: T3.3.2。

#### Wave 3.4: 增量测试

- [T3.4.1] 重复增量解析测试
  - 操作: 同一过程重复写入两次。
  - 输入: partial fixture。
  - 输出: `tests/test_sqlite_incremental_store.py`。
  - 完成标准: 行数不重复，旧关系被替换。
  - 依赖: T3.1.2。

- [T3.4.2] 增量解析 API 测试
  - 操作: 通过上传接口模拟增量解析。
  - 输入: TestClient。
  - 输出: `tests/test_parse_sqlite_incremental.py`。
  - 完成标准: 上传后任务完成且查询结果更新。
  - 依赖: T3.2.2。

- [T3.4.3] 回滚模式测试
  - 操作: 配置 legacy 后端，验证旧逻辑仍可运行。
  - 输入: `STORAGE_BACKEND=legacy`。
  - 输出: `tests/test_storage_rollback_mode.py`。
  - 完成标准: legacy 模式不依赖 SQLite。
  - 依赖: T3.2.x。

### 8.4 阶段三验收标准

| AC-ID | 验收标准 | 验证方式 |
|-------|----------|----------|
| AC-3.1 | 增量解析同一过程不会重复插入旧血缘 | 单元测试 |
| AC-3.2 | 增量解析后查询能看到最新结果 | API 测试 |
| AC-3.3 | 全量解析失败不会破坏旧 SQLite 数据 | 事务回滚测试 |
| AC-3.4 | 任务历史可选持久化且不会影响 SSE 实时推送 | 集成测试 |
| AC-3.5 | legacy 回滚模式仍可用 | 配置测试 |

## 9. 迁移脚本设计

### 9.1 命令

建议新增:

```bash
python scripts/migrate_cache_to_sqlite.py --input output/lineage_data.pkl --output output/lineage.db
python scripts/migrate_cache_to_sqlite.py --input output/lineage_data.json --output output/lineage.db
```

### 9.2 行为

1. 优先读取 pickle；pickle 不存在或版本不匹配时读取 JSON。
2. 校验 metadata 和必要字段。
3. 调用 `SQLiteResultStore.replace_result()`。
4. 输出迁移统计:
   - tables
   - procedures
   - table_lineages
   - field_mappings
   - caliber_infos
   - db size
5. 不删除旧缓存文件。

### 9.3 验收标准

- 迁移脚本运行后 `output/lineage.db` 存在。
- 从 SQLite load 的统计数等于旧缓存 metadata。
- 旧缓存文件仍保留，可用于回滚。

## 10. 回滚策略

### 10.1 配置回滚

设置:

```bash
STORAGE_BACKEND=legacy
```

系统恢复使用 `lineage_data.pkl` / `lineage_data.json`。

### 10.2 数据回滚

- 迁移脚本默认不删除旧缓存。
- 第一阶段完成前不默认清理 `lineage_data.json` 和 `lineage_data.pkl`。
- 若 SQLite 损坏，可删除 `output/lineage.db` 后重新迁移或全量解析。

### 10.3 代码回滚

- `CacheStore` facade 是回滚边界。
- 上层 `ParserService` 和 API 尽量不感知具体后端。
- 若 SQLite 后端出现问题，可只切换配置，不需要回滚全部业务代码。

## 11. 风险与缓解

| 风险 | 影响 | 缓解 |
|------|------|------|
| SQLite 写入大批量数据耗时过长 | 解析完成后保存慢 | 使用事务、`executemany`、WAL、必要时分批（详见附录 F） |
| raw_json 重复存储导致 DB 仍偏大 | 空间收益不足 | 阶段一不优化，按阈值决策拆分或压缩（详见附录 E） |
| 增量删除边界不准 | 查询出现旧边或漏边 | 第三阶段前先全量 replace，增量策略单独测试 |
| 服务层缓存与 DB 不一致 | 查询结果过期 | 统一通过 `DATA_CHANGED` 事件失效 tracer/cache |
| JSON 导出被依赖 | 外部脚本读取失败 | 保留手动导出接口和 legacy 后端 |
| 多线程读写冲突 | API 偶发失败 | `threading.local()` 每线程连接 + WAL + 事务（详见附录 D） |
| `LineageService` 缓存刷新依赖 JSON 文件 | SQLite 模式下缓存不刷新 | 改用 metadata 时间戳检测（详见附录 B） |
| `DataRepository` 硬绑定 JSON 路径 | SQLite 模式下无法加载 | 改为数据源无关的内存容器（详见附录 A） |
| 性能退化超预期 | 启动/查询变慢 | 按附录 G 回退阈值判断，超 2x 目标值回退到 legacy |

## 12. 推荐实施顺序

1. 先做阶段一，目标是替代默认持久化层并保持现有功能完全兼容。
2. 阶段一稳定后，清理默认 JSON 双写，观察 `output/` 体积和启动耗时变化。
3. 再做阶段二，把搜索类查询接到 SQLite 索引。
4. 最后做阶段三增量落库，因为它涉及数据一致性和旧关系删除策略，风险最高。

## 13. 最小可交付版本

如果希望先快速落地，MVP 可只包含:

- `SQLiteResultStore.load/save/clear`
- `CacheStore` 后端选择
- `STORAGE_BACKEND` 和 `SQLITE_DB_PATH` 配置
- SQLite schema 创建
- save/load 单元测试
- 迁移脚本

MVP 不包含:

- 搜索接口改造
- 增量 upsert
- 任务历史持久化
- JSON 导出 API

## 14. 最终验证清单

- [ ] `pytest tests/test_repository_search.py` 通过。
- [ ] `pytest tests/test_parse_api.py` 通过。
- [ ] `pytest tests/test_lineage_api.py` 通过。
- [ ] `pytest tests/test_caliber_api.py` 通过。
- [ ] 新增 SQLite store 测试通过。
- [ ] 使用现有 `output/lineage_data.pkl` 可迁移生成 `output/lineage.db`。
- [ ] 删除或移动 `lineage_data.json` 后系统仍可从 SQLite 启动。
- [ ] legacy 模式仍可从旧缓存启动。
- [ ] 增量解析后 `DATA_CHANGED` 能触发索引重建。
- [ ] `output/` 不再默认产生 3G 级 JSON 缓存。
- [ ] 多线程并发请求无 SQLite 线程安全异常（附录 D）。
- [ ] `LineageService` 缓存刷新不依赖 `lineage_data.json` 文件（附录 B）。
- [ ] `DataRepository` 可从 dict 加载，不依赖 JSON 文件路径（附录 A）。
- [ ] 性能指标在附录 G 目标范围内。

---

## 附录 A: DataRepository 改造签名与加载行为

### A.1 问题

当前 `DataRepository.__init__` 硬绑定 JSON 文件路径：

```python
class DataRepository:
    def __init__(self, data_path: Path):
        self._data_path = data_path  # JSON 文件路径
```

`CacheStore._update_repository()` 也通过 JSON 路径初始化：

```python
self._repository = DataRepository(self.json_file)
```

迁移到 SQLite 后，数据不再经过 JSON 文件，`DataRepository` 的 `load()` 方法（从 JSON 文件读取）将无法使用。

### A.2 改造方案

将 `DataRepository` 改为**数据源无关**的内存索引容器，不再持有文件路径：

```python
class DataRepository:
    def __init__(self):
        self._lock = threading.Lock()
        self._data: Optional[dict[str, Any]] = None
        self._table_map: dict[str, dict] = {}
        self._procedure_map: dict[str, dict] = {}
        self._loaded_at: float = 0.0

    def load_from_dict(self, data: dict[str, Any]) -> bool:
        """从内存 dict 加载数据（SQLite 或 legacy 均适用）。"""
        with self._lock:
            self._data = data
            self._migrate_if_needed()
            self._build_indexes()
            self._loaded_at = time.time()
            return True

    def load_from_json(self, json_path: Path) -> bool:
        """从 JSON 文件加载（仅 legacy 模式使用）。"""
        with self._lock:
            if not json_path.exists():
                return False
            with open(json_path, "r", encoding="utf-8") as f:
                self._data = json.load(f)
            self._migrate_if_needed()
            self._build_indexes()
            self._loaded_at = time.time()
            return True
```

### A.3 CacheStore 适配

`CacheStore` 改造后不再传递文件路径，而是传递已加载的 dict：

```python
class CacheStore:
    def __init__(self, output_dir: Path, config=None):
        self.output_dir = Path(output_dir)
        self.config = config
        self._repository = DataRepository()  # 无路径参数
        self._store: ResultStoreProtocol = self._create_store()

    def load_from_cache(self) -> Optional[dict[str, Any]]:
        data = self._store.load()
        if data is not None:
            self._repository.load_from_dict(data)
        return data
```

### A.4 向后兼容

- `DataRepository.load()` 方法保留但标记为 deprecated，内部调用 `load_from_json()`。
- legacy 模式下 `LegacyJsonPickleStore.load()` 返回 dict 后，同样走 `load_from_dict()` 路径。
- 阶段一完成并稳定后，移除 `load()` 和 `_data_path` 字段。

---

## 附录 B: LineageService 缓存刷新检测改造

### B.1 问题

`LineageService._check_and_refresh_cache()` 硬编码检测 `lineage_data.json` 的 mtime：

```python
def _check_and_refresh_cache(self) -> None:
    cache_file = self.parser.output_dir / "lineage_data.json"
    if not cache_file.exists():
        return
    current_mtime = cache_file.stat().st_mtime
    if current_mtime > self._last_data_mtime:
        self.cache.clear()
        self._build_indexes()
        self._last_data_mtime = current_mtime
```

迁移到 SQLite 后，`lineage_data.json` 可能不再生成，此检测逻辑失效。

### B.2 改造方案

统一使用 `CacheStore` 提供的数据变更时间戳，不依赖具体文件：

```python
class LineageService:
    def _check_and_refresh_cache(self) -> None:
        last_updated = self._get_store_last_updated()
        if last_updated is None:
            return
        if self._last_data_mtime == 0:
            self._last_data_mtime = last_updated
            return
        if last_updated > self._last_data_mtime:
            logger.info(
                "检测到数据已更新 (%.2f > %.2f)，自动清除缓存",
                last_updated, self._last_data_mtime,
            )
            self.cache.clear()
            self._table_tracer.adjacency_up.clear()
            self._table_tracer.adjacency_down.clear()
            self._transitive_cache.clear()
            self._build_indexes()
            self._last_data_mtime = last_updated

    def _get_store_last_updated(self) -> Optional[float]:
        """从 CacheStore 获取最后更新时间戳。"""
        repo = self.parser._cache_store.get_repository()
        metadata = repo.get_metadata()
        last_updated_str = metadata.get("last_updated", "")
        if not last_updated_str:
            return None
        try:
            from datetime import datetime
            dt = datetime.strptime(last_updated_str, "%Y-%m-%d %H:%M:%S")
            return dt.timestamp()
        except (ValueError, TypeError):
            return None
```

### B.3 SQLite 模式下的时间戳来源

`SQLiteResultStore.save()` 写入 `storage_metadata` 时记录 `last_updated`：

```sql
INSERT OR REPLACE INTO storage_metadata (key, value, updated_at)
VALUES ('last_updated', '2026-05-25 14:30:00', 1748157000.0);
```

`_get_store_last_updated()` 从 `DataRepository.get_metadata()` 读取，无需感知底层是 SQLite 还是 JSON。

### B.4 阶段一任务补充

在 Wave 1.2 中增加：

- [T1.2.5] 改造 LineageService 缓存刷新检测
  - 操作: 将 `_check_and_refresh_cache()` 从检测 JSON 文件 mtime 改为检测 `DataRepository.get_metadata()` 中的 `last_updated`。
  - 输入: `LineageService._check_and_refresh_cache()` 当前实现。
  - 输出: `app/services/lineage_service.py`。
  - 完成标准: SQLite 模式下数据更新后缓存自动刷新，legacy 模式下行为不变。
  - 依赖: T1.2.2。

---

## 附录 C: IndicatorService 迁移范围

### C.1 现状

`IndicatorService` 有独立的数据加载路径：

- 从 `SOURCE_DATA/FDM/` 目录的 `.xlsx` / `.proc` 文件直接解析
- 使用独立的 `CacheManager`（倒排索引）
- 不经过 `CacheStore`，不写入 `lineage_data.json` / `lineage_data.pkl`
- 通过 `bridge_to_field_lineage()` 方法桥接到 `LineageService` 做字段血缘查询

### C.2 迁移决策

| 阶段 | IndicatorService 处理 |
|------|----------------------|
| 阶段一 | **不改动**。指标数据仍从 xlsx 文件实时解析，不入 SQLite。 |
| 阶段二 | **仅搜索走 SQLite**。如果指标数据量增大（>5000 条指标），可将 `indicator_configs` 入库以加速 `search_indicators()`。但指标图结构（`IndicatorGraphBuilder` 产出）仍保留内存。 |
| 阶段三 | **可选入库**。指标配置和图结构可持久化到 SQLite，避免每次启动重新解析 xlsx。但这是低优先级，仅在指标解析成为启动瓶颈时实施。 |

### C.3 阶段二搜索入库设计（如需实施）

新增表 `indicator_configs`：

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `index_no` | TEXT | PRIMARY KEY | 指标编号 |
| `index_measure` | TEXT | INDEX | 指标度量 |
| `index_type` | TEXT | INDEX | 指标类型 |
| `algo_type` | TEXT | | 算法类型 |
| `layer` | TEXT | INDEX | 层级 |
| `src_table` | TEXT | INDEX | 来源表 |
| `raw_json` | TEXT | NOT NULL | 原始配置 JSON |
| `updated_at` | REAL | NOT NULL | 更新时间 |

### C.4 影响面补充

`IndicatorService` 的 `CacheManager` 与 `LineageService` / `CaliberService` 共享同一个实例（通过 `dependencies.py` 的 `get_cache_manager()` 单例），但指标数据不经过 `CacheStore`。因此：

- 阶段一改造 `CacheStore` 不影响 `IndicatorService`。
- `CacheManager.build_index()` 的表/过程索引仍由 `LineageService._build_indexes()` 调用，指标搜索走独立的 `_graph_builder.search_indicators()`。
- 桥接方法 `bridge_to_field_lineage()` 调用 `LineageService.query_lineage()`，后者在阶段一改造后仍正常工作。

---

## 附录 D: SQLite 连接线程策略

### D.1 问题

`app/dependencies.py` 使用 `@lru_cache` 创建服务单例。FastAPI 的异步端点在不同线程执行请求（通过 `anyio` 线程池），而 SQLite 的 Python 驱动默认不允许跨线程共享连接（`check_same_thread=True`）。

### D.2 策略选择

| 方案 | 优点 | 缺点 | 推荐度 |
|------|------|------|--------|
| 单连接 + `check_same_thread=False` | 最简单 | 需自行加锁，写操作串行化 | ⭐⭐ |
| `threading.local()` 每线程连接 | 线程安全，无锁竞争 | 连接数随线程数增长，需清理 | ⭐⭐⭐⭐ |
| 每请求新建连接 | 最安全 | 连接开销大，不适合高频查询 | ⭐⭐ |
| 连接池（`sqlite3` + queue） | 可控并发 | 实现复杂 | ⭐⭐⭐ |

**推荐方案: `threading.local()` 每线程连接 + WAL 模式**

### D.3 实现设计

```python
class SQLiteConnectionManager:
    """线程安全的 SQLite 连接管理器。"""

    def __init__(self, db_path: Path):
        self._db_path = db_path
        self._local = threading.local()

    def get_connection(self) -> sqlite3.Connection:
        conn = getattr(self._local, "connection", None)
        if conn is not None:
            try:
                conn.execute("SELECT 1")
                return conn
            except sqlite3.Error:
                conn.close()
                conn = None

        conn = sqlite3.connect(str(self._db_path))
        conn.execute("PRAGMA journal_mode=WAL")
        conn.execute("PRAGMA synchronous=NORMAL")
        conn.execute("PRAGMA foreign_keys=ON")
        conn.execute("PRAGMA temp_store=MEMORY")
        conn.row_factory = sqlite3.Row
        self._local.connection = conn
        return conn

    def close_all(self) -> None:
        conn = getattr(self._local, "connection", None)
        if conn is not None:
            conn.close()
            self._local.connection = None
```

### D.4 与 FastAPI 集成

`SQLiteResultStore` 持有 `SQLiteConnectionManager`，每次操作通过 `get_connection()` 获取当前线程的连接：

```python
class SQLiteResultStore:
    def __init__(self, db_path: Path):
        self._conn_mgr = SQLiteConnectionManager(db_path)

    def save(self, result_data: dict[str, Any]) -> None:
        conn = self._conn_mgr.get_connection()
        with conn:
            # 事务内批量写入
            ...

    def load(self) -> Optional[dict[str, Any]]:
        conn = self._conn_mgr.get_connection()
        # 读取操作
        ...
```

### D.5 写操作串行化

虽然每线程有独立连接，但 SQLite WAL 模式下写操作仍然是串行的（一次只有一个写事务）。对于本系统：

- 写操作只在解析完成时发生（低频），不会成为瓶颈。
- 读操作可以并发（WAL 允许多个读与一个写并行）。
- 如果未来写并发成为问题，可引入写队列 + 单写线程。

### D.6 阶段一任务补充

在 T1.1.1 中增加：

- [T1.1.1] 实现 SQLite 连接管理
  - 操作: 新建 `app/services/storage/sqlite_store.py`，实现 `SQLiteConnectionManager`（`threading.local()`）、pragma 设置、schema 初始化。
  - 输入: T1.0.3。
  - 输出: `app/services/storage/sqlite_store.py`。
  - 完成标准: 多线程并发读写测试通过，无 `ProgrammingError: SQLite objects created in a thread can only be used in that same thread` 异常。
  - 依赖: T1.0.2, T1.0.3。

---

## 附录 E: raw_json 存储开销量化与优化策略

### E.1 开销估算

基于当前数据量（3.1G JSON → 约 928M pickle），各表 `raw_json` 估算：

| 表 | 预估行数 | 单行 raw_json 均大小 | raw_json 总大小 | 列字段总大小 | 冗余率 |
|----|----------|---------------------|----------------|-------------|--------|
| `tables` | ~3,000 | ~2 KB | ~6 MB | ~1 MB | 6x |
| `procedures` | ~2,000 | ~5 KB | ~10 MB | ~2 MB | 5x |
| `table_lineages` | ~20,000 | ~0.3 KB | ~6 MB | ~3 MB | 2x |
| `field_mappings` | ~200,000 | ~0.5 KB | ~100 MB | ~40 MB | 2.5x |
| `caliber_infos` | ~100,000 | ~3 KB | ~300 MB | ~60 MB | 5x |

**总计 raw_json 约 422 MB，列字段约 106 MB，数据库总预估约 500-600 MB**（含索引）。

对比当前 3.1G JSON + 928M pickle，SQLite 方案空间节省约 80%。

### E.2 阈值与决策

| 场景 | 阈值 | 策略 |
|------|------|------|
| DB 总体积 < 1 GB | — | 保留 raw_json，不做优化。加载时直接 `json.loads(raw_json)` 还原。 |
| DB 总体积 1-3 GB | caliber_infos 的 raw_json > 200 MB | 拆分 `where_conditions`、`join_conditions`、`select_columns` 等大字段到子表或独立 JSON 列，减少 raw_json 中重复数据。 |
| DB 总体积 > 3 GB | 整体 raw_json 占比 > 60% | 启用 zlib 压缩 raw_json 列（`COMPRESSED_RAW BLOB`），加载时解压。预估压缩率 60-70%。 |

### E.3 阶段一策略

阶段一**不压缩、不拆分 raw_json**，原因：

1. 预估 500-600 MB 远小于当前 4.1G，空间收益已足够。
2. 压缩/拆分增加代码复杂度，与"阶段一只替换持久化层"的目标冲突。
3. 后续如需优化，可在阶段二通过 `ALTER TABLE ADD COLUMN` 增量实施，不影响已有数据。

### E.4 监控

在 `storage_metadata` 中记录数据库体积：

```sql
INSERT OR REPLACE INTO storage_metadata (key, value, updated_at)
VALUES ('db_size_mb', '580', <timestamp>);
```

每次 `save()` 后更新。当 `db_size_mb` 超过 1000 时，日志输出 WARNING 提示考虑优化。

---

## 附录 F: 全量 replace 实现策略

### F.1 策略选择

| 方案 | 优点 | 缺点 |
|------|------|------|
| A: `DELETE FROM` + `INSERT` | 简单，事务内原子替换 | 大事务，WAL 文件可能暴涨 |
| B: 分表 `DELETE FROM` + 分批 `executemany` | 控制事务大小 | 需要处理中间状态 |
| C: 写临时表 + `DROP` 旧表 + `ALTER TABLE` 换名 | 最快，无大事务 | schema 变更风险，索引需重建 |

**推荐方案: A + 分批 executemany**

### F.2 实现伪代码

```python
def replace_result(self, result_data: dict[str, Any]) -> None:
    conn = self._conn_mgr.get_connection()
    try:
        with conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM tables")
            cursor.execute("DELETE FROM procedures")
            cursor.execute("DELETE FROM table_lineages")
            cursor.execute("DELETE FROM field_mappings")
            cursor.execute("DELETE FROM caliber_infos")

            batch_size = 5000

            self._batch_insert_tables(cursor, result_data["tables"], batch_size)
            self._batch_insert_procedures(cursor, result_data["procedures"], batch_size)
            self._batch_insert_lineages(cursor, result_data["table_lineages"], batch_size)
            self._batch_insert_mappings(cursor, result_data["field_mappings"], batch_size)
            self._batch_insert_calibers(cursor, result_data["caliber_infos"], batch_size)

            self._upsert_metadata(cursor, result_data["metadata"])
    except Exception:
        logger.error("全量写入失败，事务已回滚，旧数据保留")
        raise

def _batch_insert_tables(
    self, cursor: sqlite3.Cursor, tables: list[dict], batch_size: int
) -> None:
    rows = [self._table_to_row(t) for t in tables]
    for i in range(0, len(rows), batch_size):
        cursor.executemany(
            "INSERT INTO tables (full_name, schema_name, table_name, "
            "description, layer, data_source, columns_json, raw_json, updated_at) "
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
            rows[i:i + batch_size],
        )
```

### F.3 WAL 文件控制

大事务期间 WAL 文件可能增长到数百 MB。缓解措施：

1. 写入前执行 `PRAGMA wal_checkpoint(TRUNCATE)` 清理旧 WAL。
2. 写入完成后再次 checkpoint。
3. 如果 WAL 增长超过 1 GB，考虑分批提交（每张表一个事务），但需要处理部分写入状态。

### F.4 预估耗时

基于 20 万条 field_mappings + 10 万条 caliber_infos 的数据量：

| 操作 | 预估耗时 |
|------|----------|
| DELETE 5 张表 | < 1s |
| INSERT tables (3K rows) | < 0.5s |
| INSERT procedures (2K rows) | < 0.5s |
| INSERT table_lineages (20K rows) | ~1s |
| INSERT field_mappings (200K rows, batch=5K) | ~5-10s |
| INSERT caliber_infos (100K rows, batch=5K) | ~5-10s |
| metadata upsert | < 0.1s |
| **总计** | **~15-25s** |

对比当前写入 3.1G JSON（约 30-60s）和 928M pickle（约 10-20s），SQLite 写入耗时在可接受范围内。

---

## 附录 G: 性能基准与目标指标

### G.1 当前基准（pickle/JSON 模式）

| 指标 | 当前值 | 测量方式 |
|------|--------|----------|
| 启动加载时间（从 pickle） | ~8-15s | `main.py` lifespan 计时 |
| 启动加载时间（从 JSON） | ~30-60s | `DataRepository.load()` 计时 |
| 缓存文件总体积 | ~4.1 GB | `du -sh output/` |
| 表搜索响应时间 | < 50ms | 内存 dict 遍历 |
| 血缘查询响应时间 | 50-500ms | BFS 图遍历 |
| 口径搜索响应时间 | 10-100ms | 内存索引 |
| 全量写入时间（JSON + pickle） | 40-80s | `_save_result_to_cache()` 计时 |

### G.2 迁移后目标

| 指标 | 目标值 | 允许退化 | 验证方式 |
|------|--------|----------|----------|
| 启动加载时间（从 SQLite） | **< 10s** | 不超过当前 pickle 模式的 1.5x | 自动化测试计时 |
| 数据库文件体积 | **< 800 MB** | 不超过当前 pickle 的 1x | `os.path.getsize()` |
| 表搜索响应时间 | **< 50ms** | 不退化 | API 响应计时 |
| 血缘查询响应时间 | **50-500ms** | 不退化（仍用内存 tracer） | API 响应计时 |
| 口径搜索响应时间 | **< 100ms** | 不退化 | API 响应计时 |
| 全量写入时间（SQLite） | **< 30s** | 不超过当前 JSON 模式 | `_save_result_to_cache()` 计时 |
| 增量写入时间（阶段三） | **< 5s** | — | 单文件上传计时 |
| 内存占用（启动后） | **< 2 GB** | 不超过当前模式的 1.2x | `psutil.Process().memory_info().rss` |

### G.3 性能测试方法

阶段一验收时执行以下基准测试：

```bash
# 1. 启动耗时
time python -c "from app.dependencies import get_parser_service; get_parser_service()"

# 2. 数据库体积
ls -lh output/lineage.db

# 3. 搜索性能（通过 API）
curl -w "%{time_total}" "http://localhost:8899/api/lineage/search?keyword=EAST5&limit=50"

# 4. 全量写入性能
# 在日志中观察 _save_result_to_cache() 的耗时输出
```

### G.4 回退阈值

如果阶段一上线后任何指标超过目标值的 2x，应回退到 legacy 模式并排查原因：

- 启动加载 > 20s → 检查是否缺少索引或 raw_json 过大
- 数据库体积 > 1.5 GB → 检查 raw_json 冗余率，考虑附录 E 的优化
- 写入耗时 > 60s → 检查 WAL 配置和 batch_size
