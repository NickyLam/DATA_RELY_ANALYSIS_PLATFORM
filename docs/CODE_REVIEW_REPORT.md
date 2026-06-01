# 数据血缘分析系统 — 全量 Code Review 报告

> **审查日期**: 2026-05-27
> **审查范围**: `app/`, `core/`, `static/`, `start.sh`, `stop.sh`
> **代码规模**: 63 个 Python 源文件, ~18,351 行
> **审查重点**: 接口标准性与有效性 | 业务链路完整性 | 需求覆盖率 | 安全风险

---

## 目录

1. [总评](#1-总评)
2. [接口标准性与有效性](#2-接口标准性与有效性)
3. [业务功能链路逻辑完整性](#3-业务功能链路逻辑完整性)
4. [需求实现覆盖度](#4-需求实现覆盖度)
5. [安全漏洞风险](#5-安全漏洞风险)
6. [综合问题清单](#6-综合问题清单)
7. [修复优先级建议](#7-修复优先级建议)

---

## 1. 总评

系统整体架构清晰，完成了从单体 `api_server.py` (1,289行) 到 FastAPI 分层架构的合理重构。核心 BFS 追溯引擎功能完整，多数据源适配框架已就位。

**但存在以下系统性问题需重点解决：**

- **接口层**：响应格式不统一，部分端点缺失输入校验和错误处理，无认证/限流
- **业务逻辑**：缓存失效链路断裂（TracerFactory 未随解析结果刷新），并发安全问题广泛存在，CaliberInfo 序列化/反序列化存在 key 不一致
- **需求覆盖**：字段分类路由（DETAILED/BASIC_INDICATOR/GL_INDICATOR）完全缺失，4 个口径 API 端点未实现，前端口径交互组件全部缺失
- **安全**：XSS 风险点 6 处，文件上传路径穿越，CORS 配置不当，无认证无限流

| 严重级别 | 数量 | 说明 |
|---------|------|------|
| **CRITICAL** | 6 | 可直接导致数据错误、服务不可用或安全漏洞 |
| **HIGH** | 12 | 特定条件下触发错误或数据不一致 |
| **MEDIUM** | 18 | 边界/并发场景下的问题 |
| **LOW** | 14 | 代码质量/可维护性问题 |

---

## 2. 接口标准性与有效性

### 2.1 CRITICAL — 响应格式完全不统一

项目中至少存在 **5 种不同的响应格式**，API 消费者无法统一处理：

| 端点组 | 成功响应 | 错误响应 |
|--------|---------|---------|
| `lineage.py` (有类型) | `LineageQueryResponse(data=...)` | 无 catch → 裸 500 |
| `lineage.py` (无类型) | `{"success": True, "data": ...}` | `HTTPException(404)` |
| `indicator.py` | `{"success": True, "message": ..., "data": ...}` + 200 | `{"success": False, ...}` + **200** |
| `parse.py` | `FileUploadResponse(...)` (Pydantic) | `HTTPException(400/404)` |
| `system.py` | `{"status": ...}` / `{"success": True, "data": ...}` | `{"success": False, "error": ...}` + **200** |

**核心问题：**
- `indicator.py` 全部端点在异常时返回 HTTP 200 + `success: false`，违反 REST 规范
- `lineage.py` 的 `query_lineage`、`rebuild_cache` 端点无任何异常捕获，直接暴露 FastAPI 默认 500
- `system.py` 的 `force_reparse` 在失败时也返回 200

**建议：** 定义统一响应信封 `{"code": int, "message": str, "data": Any}`，配合全局异常处理器。所有业务错误使用合适的 HTTP 状态码。

---

### 2.2 CRITICAL — 指标端点 direction 参数无校验

**文件：** `app/api/indicator.py:72`

```python
direction: Annotated[str, Query(...)]
```

`direction` 接受任意字符串（如 `"DROP TABLE"`），直接传入 `IndicatorService.trace_indicator(direction=direction)`。而 `IndicatorLineageRequest` 模型 (`app/models/__init__.py:269`) 已定义 `IndicatorQueryMode` 枚举，但 GET 端点完全绕过了该模型。

同样问题存在于 `indicator.py:286` 的 `get_node_caliber`。

**建议：** 使用 `direction: IndicatorQueryMode = Query(...)` 直接约束枚举值。

---

### 2.3 HIGH — 错误信息泄露内部实现

**文件：** `app/api/indicator.py:36,61,89,118,139,155,180`; `app/api/system.py:238`

```python
{"success": False, "message": f"搜索失败: {str(e)}"}
```

异常消息直接暴露给客户端，可能包含文件路径、数据库结构、堆栈信息等。`system.py:238` 的 `"error": str(e)` 同理。

**建议：** 生产环境返回通用错误消息，详细信息仅写入日志。

---

### 2.4 HIGH — 端点缺失输入校验

| 位置 | 问题 |
|------|------|
| `lineage.py:110,164,184` | `table`/`field` 路径参数无长度/字符限制，含路径穿越字符时流入错误消息 |
| `indicator.py:21` | `keyword` 参数无空白字符串检查（`" "` 会通过 `min_length=1`），而 `lineage.py:47` 有此检查 |
| `indicator.py:289` | `data_source` 无白名单校验，文档说仅支持 `oracle|tdh|gbase` |
| `parse.py:48` | `schema_name` Form 参数从未使用，属于死参数 |

---

### 2.5 MEDIUM — 废弃端点未标记

**文件：** `app/api/lineage.py:279`

`/api/lineage/node-caliber` 的描述称"P5 迁移后续将下线"，但路由装饰器未设置 `deprecated=True`，响应头无 `Deprecation` 标记。`/tables/{table}/fields` 标注"兼容旧版"但同样未标记废弃。

---

### 2.6 MEDIUM — list_tasks 内存效率问题

**文件：** `app/api/parse.py:208`

```python
all_tasks_info = progress_service.list_tasks(limit=None)  # 加载全部任务到内存
tasks = all_tasks_info[:limit]  # 然后手动切片
```

应将 `limit` 直接传给 service 层，避免大量任务时 OOM。

---

## 3. 业务功能链路逻辑完整性

### 3.1 CRITICAL — TracerFactory 缓存失效链路断裂

**根因分析：** 解析完成后，`TracerFactory` 不会被刷新，导致后续查询始终使用旧数据。

链路追踪：

```
ParserService.parse_existing_data()
  → self._current_result = result          # 赋值，无锁
  → self._event_bus.publish(DATA_CHANGED)  # 通知
  → self._event_bus.publish(PARSE_COMPLETED)

LineageService._on_data_changed()
  → self._transitive_cache.clear()         # 清查询缓存
  → self._build_indexes()                  # 重建索引
  ❌ 未调用 self.parser._tracer_factory.invalidate()

TracerFactory.create_lineage_tracer()
  → if self.lineage_tracer: return it      # 返回旧实例！
```

**影响：** 解析新数据后，所有口径/血缘查询仍使用旧 Tracer 实例，直到手动调用 `clear_cache()` 或重启服务。

**涉及文件：**
- `app/services/parser_service.py:379-383` — 解析后未调用 invalidate
- `app/services/lineage_service.py:58-60` — `_on_data_changed` 未刷新 factory
- `app/services/tracer_factory.py:21-36` — 缓存的 tracer 永不过期

---

### 3.2 CRITICAL — CaliberInfo 去重 key 与序列化格式不匹配

**文件：** `app/services/parser_service.py:168-174`

```python
# merge() 去重 key
seen_key = (ci.get("target_table"), ci.get("target_column"),
            ci.get("source_table"),    # ← 顶层 key
            ci.get("source_column"),   # ← 顶层 key
            ci.get("procedure"), ci.get("step_num", 0))
```

但 `CaliberInfo.to_dict()` (`core/models.py:716-756`) 将 `source_table`/`source_column` 放在 `source_location` 子字典内，顶层无这两个 key。

**影响：** 经过 `CaliberExtractor.to_dict()` 序列化的口径记录，在 merge 时 `source_table` 和 `source_column` 永远为空字符串，导致：
1. 去重失效 — 不同源字段的记录因 key 相同被误合并
2. 去重遗漏 — 应合并的记录因 key 不同而重复

---

### 3.3 CRITICAL — _dict_to_record join_conditions 回退 key 错误

**文件：** `core/caliber_tracer.py:963`

```python
join_conds = expr_detail.get("join_conditions", [])  # ← 错误 key
```

`ExpressionDetail.to_dict()` (`core/models.py:437`) 序列化的字段名是 `"join_clauses"`，不是 `"join_conditions"`。

**影响：** 当顶层 `join_conditions` 缺失时，回退取值永远返回空列表，静默丢失 JOIN 数据。目前是潜在 bug（顶层总是有值），但数据源变化后将暴露。

此外，即使修正 key，`join_clauses` 类型是 `list[str]`，而第 971 行 `dict(c)` 对字符串会抛 `TypeError`。

---

### 3.4 HIGH — 下游追溯超出 max_depth 限制

**文件：** `core/caliber_tracer.py:414-432`

当 `current.depth >= max_depth` 时，下游追溯仍会创建 `depth = max_depth + 1` 的节点：

```python
if current.depth >= max_depth:
    for tgt in targets[:3]:
        tgt_node = _CaliberBFSNode(depth=current.depth + 1, ...)  # 超限！
        visited.add(tgt_key)   # 占用 visited 槽位
        leaf_paths.append(...)  # 记录为叶子
    continue
```

而上游追溯 (`lineage_tracer.py:316-319`) 在超限后仅记录当前节点，不扩展。

**影响：**
1. 下游追溯的实际深度比请求多 1 层
2. 超深路径的节点占用 `visited`，可能阻止更短路径到达同一节点

---

### 3.5 HIGH — BFS 扩展静默截断至 8 条

**文件：** `core/caliber_tracer.py:322, 435`

```python
for src in sources[:8]:   # 上游
for tgt in targets[:8]:   # 下游（非超深情况）
for tgt in targets[:3]:   # 下游（超深情况）
```

宽 UNION ALL 或多源 JOIN 场景下，超过 8 条的有效路径被静默丢弃，无日志警告。

**建议：** 截断时记录 `logger.warning`，或改为可配置参数。

---

### 3.6 HIGH — 字段名子串匹配导致错误映射

**文件：** `app/services/lineage_service.py:887`

```python
if field_upper in tgt_col:  # 子串匹配！
```

搜索字段 `"ID"` 会匹配 `"VALID"`、`"PROVID"` 等不相关字段。

**建议：** 改为精确匹配 `field_upper == tgt_col`，或至少用 `f"\\b{field_upper}\\b"` 正则。

---

### 3.7 HIGH — EventBus 非线程安全

**文件：** `app/services/event_bus.py:34-42`

```python
def publish(self, event_type, data=None):
    for handler in self._handlers.get(event_type, []):  # 迭代中可能被 subscribe 修改
        try:
            handler(data)
        except Exception as e:
            logger.error("Handler %s failed: %s", handler.__name__, e)  # lambda 无 __name__
```

**问题：**
1. `publish` 迭代 `self._handlers[event_type]` 时，`subscribe` 可能并发追加，导致 `RuntimeError: list changed size during iteration`
2. `handler.__name__` 对 lambda/functools.partial 会抛 `AttributeError`
3. 全局单例 `_event_bus` 的懒初始化无锁 (`event_bus.py:48-55`)

---

### 3.8 HIGH — ProcedureParser 重复生成 CaliberInfo

**文件：** `core/procedure_parser.py:312-326`

当一个目标表出现在多个步骤的 SQL 操作中时，该表的所有字段映射会被每个步骤的 SQL 块各处理一次。例如表 `T` 在 step 1 和 step 3 都被 INSERT，10 条字段映射会产生 20 条口径记录，其中 10 条使用错误的 SQL 上下文。

---

### 3.9 HIGH — _find_mapping_step 回退到无关步骤

**文件：** `core/procedure_parser.py:362-363`

```python
for op in operations:
    if op.step_num > 0:
        return op.step_num  # 返回第一个有步骤号的操作，与当前映射可能无关
```

当字段映射不匹配任何操作的目标表时，回退分配到第一个操作的步骤号。

---

### 3.10 MEDIUM — _current_result 并发读写无锁

**文件：** `app/services/parser_service.py:379, 463, 494, 507, 515`

`parse_existing_data` 赋值 `self._current_result = result` 在锁外；`parse_uploaded_files` 的 `merge()` 在锁外；而 `get_current_data()`、`get_table_list()`、`search_tables()` 等读方法也无锁。并发读写可能导致读到部分构造的状态。

---

### 3.11 MEDIUM — SQLite 读写间隙数据消失

**文件：** `app/services/storage/sqlite_store.py:219-235`

`_replace_table_data` 先 DELETE 再分批 INSERT，DELETE 和首批 INSERT 在不同事务中。并发读取时会看到空表。

**建议：** 将 DELETE + 首批 INSERT 放在同一事务内。

---

### 3.12 MEDIUM — LineageService 缓存刷新 TOCTOU

**文件：** `app/services/lineage_service.py:494-521`

`_check_and_refresh_cache` 读 mtime → 清缓存 → 重建索引，但无全局锁。两个并发请求可能同时检测到 mtime 变化并重复重建。

---

### 3.13 MEDIUM — 缓存保存失败对用户不可见

**文件：** `app/services/cache_store.py:80-102`

`save_to_cache` 捕获所有异常后仅记日志。用户看到解析成功，但下次重启时数据丢失。

---

### 3.14 MEDIUM — 双版本号体系不一致

**文件：** `app/services/storage/protocol.py` vs `app/services/storage/migrations.py`

- `protocol.py`: `CACHE_SCHEMA_VERSION = "v4"` (字符串)
- `migrations.py`: `SCHEMA_VERSION = 1` (整数)

两套独立的版本系统，`migrations.py` 写入 `SCHEMA_VERSION=1` 但从未被读取校验，`protocol.py` 的 `"v4"` 独立校验。两者可能漂移。

---

### 3.15 MEDIUM — is_upstream_of_target 无深度限制的 BFS

**文件：** `app/services/lineage_service.py:629-646`

`is_upstream_of_target` 函数做 BFS 时无深度限制，在字段映射图有环或非常宽时可导致指数级耗时，甚至挂死服务。

---

### 3.16 MEDIUM — lineage_service O(N*M) 性能问题

| 位置 | 问题 |
|------|------|
| `lineage_service.py:673-677` | 模糊匹配时遍历 `target_map` 全部 key，O(N) 每次 BFS 步骤 |
| `lineage_service.py:622-626` | 每次 `_trace_field_lineage` 都重建 `table_to_upstream`、`target_map`、`source_map` |
| `lineage_service.py:851-855` | `_is_node_in_set` 对每个映射遍历所有节点，O(M*N) |
| `lineage_service.py:774-827` | 表级血缘扩展无节点数上限 |

---

### 3.17 MEDIUM — FieldMapping 重复定义 to_dict/from_dict

**文件：** `core/models.py:109-161`

`FieldMapping` 类定义了 `to_dict()` 两次 (line 109 和 136) 和 `from_dict()` 两次 (line 122 和 149)。Python 使用最后定义，第一组成为死代码。若后续维护时只改了一处，将产生微妙的不一致。

---

### 3.18 LOW — Chain 排序方向不一致

- `LineageTracer` 按深度降序 (`reverse=True`)
- `CaliberTracer` 按深度升序

消费者混用两个 tracer 时，链路顺序相反。

---

### 3.19 LOW — 层级检测器过于宽泛的 ODS 规则

**文件：** `core/layer_detector.py:153`

默认配置中 `BareNameRule(pattern="^[A-Z]{1,10}$", layer="ods")` 将任意 1-10 位大写字母的表名归为 ODS 层，导致短表名如 `"APP"`、`"DIM"` 被误分类。

---

## 4. 需求实现覆盖度

### 4.1 完全缺失：字段分类路由机制

**需求来源：** 设计规范 2.2.3、2.3.2、4.2

设计规范要求将字段分为三类并路由到不同追溯算法：

| 字段类别 | 路由算法 | 实现状态 |
|---------|---------|---------|
| DETAILED | Schema-aware BFS | 所有字段统一走此路径 |
| BASIC_INDICATOR | Condition-accumulating BFS | 未实现分类路由 |
| GL_INDICATOR | Indicator graph traversal | 未实现分类路由 |

**缺失项：**
- `field_category: DETAILED | BASIC_INDICATOR | GL_INDICATOR` 枚举属性完全不存在
- 字段分类解析器 (Field Category Resolver) 完全不存在
- 查询时无路由逻辑，所有字段走同一追溯路径

**这是设计规范最核心的特性之一，完全未实现。**

---

### 4.2 未实现的 API 端点

| 需求端点 | 需求来源 | 状态 | 说明 |
|---------|---------|------|------|
| `GET /api/caliber/summary` | indicator-spec-design 9 | 未实现 | 后端逻辑已有 (`summary_card_builder.py`)，但无独立路由 |
| `GET /api/caliber/trace?mode=pipeline` | indicator-spec-design 9 | 未实现 | Pipeline 模型已定义，无 API 入口 |
| `GET /api/caliber/step-detail` | indicator-spec-design 9 | 未实现 | `StepDetail` 数据类已定义，无 API 入口 |
| `POST /api/caliber/export` | indicator-spec-design 9.4 | 未实现 | `CaliberExporter` 引擎已编码，无路由 |
| `GET /api/caliber/fields` | indicator-spec-design 8 | 未实现 | 旧 `api_server.py` 有此端点，未迁移 |
| `POST /api/indicator/build` | README 文档 | 未实现 | 指标图在服务初始化时自动构建，无显式 API |

---

### 4.3 未实现的前端组件

| 需求组件 | 需求来源 | 状态 |
|---------|---------|------|
| `static/js/caliber/summary-card.js` | indicator-spec-design Phase 3.1 | 目录不存在 |
| `static/js/caliber/pipeline-view.js` | indicator-spec-design Phase 3.2 | 目录不存在 |
| `static/js/caliber/step-detail.js` | indicator-spec-design Phase 3.3 | 目录不存在 |
| `static/js/caliber/caliber-export.js` | indicator-spec-design Phase 3.4 | 目录不存在 |
| 指标拓扑视图 (Mode 3) | 设计规范 2.6.1 | 未实现 — 现有 `indicator-tab.js` 无可折叠集群、不同边样式、GL 科目终端节点详情 |

---

### 4.4 架构差距对照

| 差距 ID | 描述 | 状态 |
|--------|------|------|
| G1 | 无持久化存储 / 6-8分钟冷启动 | 部分解决 — pickle/json 缓存缓解重启时间，SQLite 已实现但仍在迁移中 |
| G2 | 无字段分类区分 | **未解决** |
| G4 | 重复 `_bare_table()` | 已解决 — 统一为 `TableNameResolver` |
| G5 | 单体 API 服务器 | 已解决 — 拆分为 FastAPI 分层架构 |
| G6 | 无指标拓扑可视化 | **未解决** |
| G7 | 单线程 HTTP | 已解决 — uvicorn ASGI |
| G8 | 查询时模糊匹配 | 部分解决 — 仍有 5 级回退，未实现完全规范化索引 |
| G9 | 无增量更新 | **未解决** — 任何源文件变更需全量重解析 |
| G11 | 无字段分类元数据 | **未解决** |
| G16 | 无 API 版本控制 | **未解决** — 所有端点无版本前缀 |
| G19 | 无访问控制 | **未解决** |

---

### 4.5 README 与实际实现不一致

| README 声明 | 实际状态 |
|-------------|---------|
| `POST /api/indicator/build` | 不存在 |
| `POST /api/caliber/query` | 无独立路由，功能在 `/api/lineage/node-caliber` |
| `POST /api/caliber/export` (Excel) | 不存在；`CaliberExporter` 仅支持 Markdown/HTML |
| "v2.2.0" 指标血缘分析 | 三模式可视化未实现 |

---

## 5. 安全漏洞风险

### 5.1 CRITICAL — 文件上传路径穿越

**文件：** `app/utils/file_handler.py:58-59`

```python
safe_filename = f"{uuid.uuid4().hex}_{file.filename}"
save_path = task_dir / safe_filename
```

`file.filename` 未经过滤。如果客户端上传文件名 `../../../etc/cron.d/malicious.tab`，Python `Path` 对象的 `/` 操作会解析路径穿越。

虽然 `task_dir` 由 `config.upload_temp_path / task_id` (uuid4) 构成，攻击者仍可逃逸到 `temp_uploads/` 之外的任意位置。

**修复：**
```python
# 只保留文件名的最后一段，剥离路径
safe_name = Path(file.filename).name
safe_filename = f"{uuid.uuid4().hex}_{safe_name}"
# 确保解析后的路径仍在 task_dir 内
save_path = (task_dir / safe_filename).resolve()
if not str(save_path).startswith(str(task_dir.resolve())):
    raise ValueError("Invalid filename")
```

---

### 5.2 CRITICAL — 无认证、无权限控制

所有 API 端点完全开放，包括破坏性操作：
- `POST /api/system/reparse` — 触发 6-10 分钟全量重解析
- `POST /api/cache/rebuild` — 重建索引
- `POST /api/parse/upload` — 上传任意文件

且 `system.py:213-214` 直接修改 `ParserService` 私有属性：
```python
parser._lineage_tracer = None
parser._cached_procedures = {}
```

---

### 5.3 HIGH — 多处 XSS 风险

所有前端 JS 文件使用 `innerHTML` 插入服务端数据而未转义：

| 文件 | 行号 | 风险数据 |
|------|------|---------|
| `search-panel.js` | 49-56 | 表名、schema（可突破 onclick 引号） |
| `parse-tab.js` | 363-378 | 表名、过程名（同上） |
| `detail-panel.js` | 62-67 | targetTable/targetField（未使用已有 `_escape` 函数） |
| `indicator-tab.js` | 216-256 | 指标编号、度量值 |
| `indicator-tab.js` | 270-279 | 过程名、步骤详情 |

**注意：** `detail-panel.js` 已有 `_escape` 函数且在多处使用，但查询目标区域未使用，说明是遗漏而非设计选择。

---

### 5.4 HIGH — CORS 配置不当

**文件：** `app/main.py:135-147`

```python
allow_origins=ALLOWED_ORIGINS if os.getenv("PRODUCTION") else ["*"],
allow_credentials=True,
```

默认（无 `PRODUCTION` 环境变量）时 `allow_origins=["*"]` + `allow_credentials=True`。CORS 规范明确禁止此组合，部分浏览器处理不一致。`PRODUCTION` 环境变量未在任何文档中说明。

---

### 5.5 HIGH — 无速率限制

无任何限流中间件。以下端点可被滥用导致服务不可用：
- `POST /api/parse/upload` — 每次上传启动后台解析线程
- `POST /api/system/reparse` — 6-10 分钟 CPU 密集操作
- `GET /api/lineage/{table}/{field}` — BFS 图遍历
- 无限制并发线程 — `parse.py:116-117` 每次上传新建线程

---

### 5.6 MEDIUM — 缺失安全响应头

**文件：** `app/main.py`

无 `Content-Security-Policy`、`X-Content-Type-Options`、`X-Frame-Options`、`Strict-Transport-Security` 头。允许 iframe 嵌入（点击劫持），无 XSS 深度防御。

---

### 5.7 MEDIUM — temp_uploads 目录无清理

**文件：** `app/utils/file_handler.py:74-79`

`cleanup_task_files` 方法存在但从未被调用。解析完成后上传文件永久驻留磁盘。

---

### 5.8 MEDIUM — PID 文件符号链接攻击

**文件：** `start.sh:189`, `stop.sh:38`

`.server.pid` 文件写入和读取时未检查是否为符号链接。攻击者可创建指向任意文件的符号链接，导致 `stop.sh` 读取恶意 PID 后 `kill`。

---

### 5.9 MEDIUM — SQLite f-string SQL

**文件：** `app/services/storage/sqlite_store.py:191, 220, 426`

```python
cursor.execute(f"DELETE FROM {table_name}")
f"SELECT raw_json FROM {table_name}"
```

当前 `table_name` 来自硬编码列表，不可利用。但这是不安全模式，若代码重构引入用户输入将变成 SQL 注入。

---

### 5.10 LOW — 默认绑定所有网络接口

**文件：** `app/config.py:39`

```python
host: str = "0.0.0.0"
```

配合无认证、wildcard CORS，任何网络可达主机可访问所有功能。

---

### 5.11 LOW — legacy_store 删除损坏缓存文件

**文件：** `app/services/storage/legacy_store.py:43, 56`

加载失败时直接删除缓存文件，无法恢复。应重命名为备份文件。

---

## 6. 综合问题清单

### CRITICAL (必须修复)

| 编号 | 分类 | 问题 | 位置 |
|------|------|------|------|
| C1 | 业务逻辑 | TracerFactory 缓存失效链路断裂，解析后查询返回旧数据 | `parser_service.py:379` + `tracer_factory.py:21-36` |
| C2 | 业务逻辑 | CaliberInfo merge 去重 key 与 to_dict() 序列化格式不匹配 | `parser_service.py:169` vs `models.py:716` |
| C3 | 接口 | 响应格式完全不统一，indicator 全部返回 200 | `indicator.py`, `system.py`, `lineage.py` |
| C4 | 接口 | direction 参数无枚举校验 | `indicator.py:72, 286` |
| C5 | 安全 | 文件上传路径穿越 | `file_handler.py:58-59` |
| C6 | 安全 | 无认证无权限控制，破坏性端点完全开放 | 全局 |

### HIGH (应当修复)

| 编号 | 分类 | 问题 | 位置 |
|------|------|------|------|
| H1 | 业务逻辑 | _dict_to_record join_conditions 回退 key 错误 + 类型不匹配 | `caliber_tracer.py:963, 971` |
| H2 | 业务逻辑 | 下游追溯超出 max_depth 限制 | `caliber_tracer.py:414-432` |
| H3 | 业务逻辑 | BFS 静默截断至 8 条，丢失有效路径 | `caliber_tracer.py:322, 435` |
| H4 | 业务逻辑 | 字段名子串匹配返回错误映射 | `lineage_service.py:887` |
| H5 | 业务逻辑 | EventBus 非线程安全 | `event_bus.py:34-55` |
| H6 | 业务逻辑 | ProcedureParser 重复生成 CaliberInfo | `procedure_parser.py:312-326` |
| H7 | 业务逻辑 | _find_mapping_step 回退到无关步骤 | `procedure_parser.py:362-363` |
| H8 | 接口 | 错误信息泄露内部实现 | `indicator.py`, `system.py` |
| H9 | 接口 | 端点缺失输入校验 | `lineage.py`, `indicator.py` |
| H10 | 安全 | 多处 innerHTML XSS | `search-panel.js`, `parse-tab.js`, `detail-panel.js`, `indicator-tab.js` |
| H11 | 安全 | CORS 配置不当 (wildcard + credentials) | `main.py:143` |
| H12 | 安全 | 无速率限制 + 无限线程 | 全局 |

### MEDIUM (建议修复)

| 编号 | 分类 | 问题 | 位置 |
|------|------|------|------|
| M1 | 业务逻辑 | _current_result 并发读写无锁 | `parser_service.py` 多处 |
| M2 | 业务逻辑 | SQLite 读写间隙数据消失 | `sqlite_store.py:219-235` |
| M3 | 业务逻辑 | LineageService 缓存刷新 TOCTOU | `lineage_service.py:494-521` |
| M4 | 业务逻辑 | 缓存保存失败对用户不可见 | `cache_store.py:80-102` |
| M5 | 业务逻辑 | 双版本号体系不一致 | `protocol.py` vs `migrations.py` |
| M6 | 业务逻辑 | is_upstream_of_target 无深度限制 BFS | `lineage_service.py:629-646` |
| M7 | 业务逻辑 | O(N*M) 性能问题 (4处) | `lineage_service.py` 多处 |
| M8 | 业务逻辑 | FieldMapping 重复 to_dict/from_dict | `models.py:109-161` |
| M9 | 接口 | 废弃端点未标记 deprecated | `lineage.py:279` |
| M10 | 接口 | list_tasks 全量加载内存 | `parse.py:208` |
| M11 | 安全 | 缺失安全响应头 (CSP 等) | `main.py` |
| M12 | 安全 | temp_uploads 无清理 | `file_handler.py` |
| M13 | 安全 | PID 文件符号链接攻击 | `start.sh`, `stop.sh` |
| M14 | 安全 | SQLite f-string SQL | `sqlite_store.py` |
| M15 | 业务逻辑 | 窗口函数/子查询正则无法处理嵌套括号 | `caliber_extractor.py:97-108` |
| M16 | 业务逻辑 | 3 段式表名 (DB.SCHEMA.TABLE) 处理错误 | `table_name_resolver.py:92` |
| M17 | 业务逻辑 | 层级检测 ODS 规则过于宽泛 | `layer_detector.py:153` |
| M18 | 业务逻辑 | Chain 排序方向上游/下游不一致 | `lineage_tracer.py` vs `caliber_tracer.py` |

### LOW (可选改进)

| 编号 | 问题 | 位置 |
|------|------|------|
| L1 | 死代码: `lineage_tracer.py:893-903` if/else 分支相同 | `lineage_tracer.py` |
| L2 | 泄漏 ThreadPoolExecutor: `parser_service.py:202` 创建但未使用 | `parser_service.py` |
| L3 | `_last_parse_cache` 线程安全: `procedure_parser.py:117` | `procedure_parser.py` |
| L4 | 默认绑定 0.0.0.0 | `config.py:39` |
| L5 | legacy_store 删除损坏缓存而非备份 | `legacy_store.py:43,56` |
| L6 | BareNameRule 缺 re.IGNORECASE | `layer_detector.py:73` |
| L7 | "EAST" 子串检查脆弱 | `layer_detector.py:203` |
| L8 | 6 字符最小长度限制跨 schema 匹配 | `table_name_resolver.py:145` |
| L9 | ICL 特定硬编码逻辑 | `table_name_resolver.py:159-167` |
| L10 | 不必要的 `object.__setattr__` | `layer_detector.py:52,73,87` |
| L11 | README 记录不存在的端点 | `README.md` |
| L12 | CODE_WIKI.md 版本号回退 | `CODE_WIKI.md:3` |
| L13 | `start.sh` --dir 改名和默认目录变更为破坏性变更 | `start.sh` |
| L14 | 同表转换消解丢失中间节点 transform_note | `lineage_tracer.py:243-271` |

---

## 7. 修复优先级建议

### P0 — 立即修复 (影响数据正确性或安全)

1. **C1** — TracerFactory 失效链路：在 `parse_existing_data` 和 `_on_data_changed` 末尾调用 `tracer_factory.invalidate()`
2. **C2** — merge 去重 key：使用 `CaliberTracer._get_source_table(ci)` 替代 `ci.get("source_table")`
3. **C5** — 文件上传路径穿越：过滤 `file.filename`，验证 `save_path` 在 `task_dir` 内
4. **H4** — 字段名子串匹配：改为精确匹配

### P1 — 尽快修复 (影响接口正确性或安全)

5. **C3** — 统一响应格式 + 正确 HTTP 状态码
6. **C4** — direction 枚举校验
7. **C6** — 至少为破坏性端点添加简单认证 (API Key)
8. **H10** — innerHTML 替换为 textContent 或使用已有 `_escape`/`escapeHtml`
9. **H11** — 修正 CORS 配置，移除 `allow_credentials=True` + `["*"]` 组合
10. **H1** — 修正 `_dict_to_record` join_conditions 回退逻辑
11. **H2** — 下游追溯 max_depth 边界修复

### P2 — 计划修复 (影响健壮性)

12. **H5** — EventBus 加锁或改用 `copy()` 快照迭代
13. **H6/H7** — ProcedureParser 口径生成逻辑修正
14. **H12** — 添加速率限制中间件 + 线程池限制
15. **M1-M4** — 加锁保护 `_current_result`、修复 SQLite 事务、缓存失效通知
16. **M11-M14** — 安全响应头、temp_uploads 清理、PID 文件安全

### P3 — 需求补齐 (设计规范未实现)

17. 字段分类路由机制 (G2/G11) — 这是设计规范核心特性
18. 4 个口径 API 端点 (`/api/caliber/summary`, `trace`, `step-detail`, `export`)
19. 前端口径交互组件 (`static/js/caliber/`)
20. 指标拓扑可视化 (Mode 3)
21. 增量解析 (G9) / API 版本控制 (G16)
22. README 与实际实现同步

---

> **审查结论：** 系统核心追溯功能可用，但接口标准化程度低、缓存失效链路有关键断裂、并发安全缺陷广泛、需求覆盖率约 60%。建议优先修复 P0/P1 数据正确性和安全问题，再逐步补齐需求缺口。
