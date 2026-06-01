# 数据血缘分析系统 — P0~P3 改造详细设计方案

> 版本：v1.0 | 日期：2026-05-28 | 基于 CODE_QUALITY_ASSESSMENT.md 评估报告

---

## 总览：改造项与依赖关系

```
P0-1 消除 TableNameResolver 重复 ──┐
P0-2 Pydantic 模型接入路由         ├── P1-5 拆分 God Method
P0-3 业务逻辑下沉 LineageService   │   P1-6 BFS 方向参数化
P0-4 消除私有属性访问             ──┘   P1-7 合并重复枚举
                                        P1-8 统一错误处理
                                        P1-9 pytest-cov 配置
                                        P1-10 API 版本控制
                                              │
                                    P2-11~16 SRP 重构 + 测试补齐
                                              │
                                    P3-17~20 架构统一 + 认证升级 + 前端工程化 + 异步化
```

**执行原则**：
- 每个 P-level 内部的改造项**可并行开发**，无前后依赖
- **跨 P-level 必须严格顺序执行**（P0 → P1 → P2 → P3），因为后续依赖前序重构后的代码结构
- 每个改造项完成后必须**运行全量测试**（`pytest tests/ -x`）确认零回归

---

## P0 — 立即修复（1-2 周）

### P0-1：消除 `procedure_parser.py` 对 `TableNameResolver` 的重复实现

#### 问题定位

`EnhancedProcedureParser` 自行实现了 `TableNameResolver` 的全套逻辑，存在以下重复：

| 重复方法/常量 | `procedure_parser.py` 位置 | `table_name_resolver.py` 位置 |
|---|---|---|
| `_INVALID_TABLE_PREFIXES` 常量 | 第 52-61 行 | 第 22-24 行 `INVALID_TABLE_PREFIXES` |
| `_TEMP_TABLE_SUFFIXES` 常量 | 第 64 行 | 第 18-20 行 `TEMP_TABLE_SUFFIXES` |
| `_is_valid_table()` | 第 1043-1051 行 | 第 171-178 行 `is_valid_table()` |
| `_is_temp_table()` | 第 884-887 行 | 第 181-185 行 `is_temp_table()` |
| `_normalize_table_name()` | 第 1053-1072 行 | 第 83-103 行 `normalize()` |
| `_find_best_table_match()` | 第 1074-1101 行 | 第 252-275 行 `_find_best_match()` |

**风险**：修改 `bare_table()` 或匹配规则时，`procedure_parser.py` 不会同步，导致静默血缘错误。

#### 改造方案

**Step 1**：在 `EnhancedProcedureParser.__init__()` 中注入 `TableNameResolver` 实例

```python
# procedure_parser.py — 修改 __init__

class EnhancedProcedureParser:
    def __init__(
        self,
        tables: dict[str, TableInfo],
        resolver: Optional[TableNameResolver] = None,
    ) -> None:
        self.tables: dict[str, TableInfo] = tables
        # 注入统一解析器；如果未传入则自动创建（向后兼容）
        self._resolver = resolver or TableNameResolver(
            known_full_names=set(tables.keys()),
        )
        self._last_parse_cache: dict[str, tuple[str, list[SQLOperation]]] = {}
```

**Step 2**：删除重复方法，改为委托调用

```python
# procedure_parser.py — 删除以下方法/常量，替换为委托调用

# ❌ 删除：_INVALID_TABLE_PREFIXES（第 52-61 行）
# ❌ 删除：_TEMP_TABLE_SUFFIXES（第 64 行）
# ❌ 删除：_is_valid_table()（第 1043-1051 行）
# ❌ 删除：_is_temp_table()（第 884-887 行）
# ❌ 删除：_normalize_table_name()（第 1053-1072 行）
# ❌ 删除：_find_best_table_match()（第 1074-1101 行）

# ✅ 替换调用点（全局搜索替换）：
#   self._is_valid_table(xxx)    →  TableNameResolver.is_valid_table(xxx)
#   self._is_temp_table(xxx)     →  TableNameResolver.is_temp_table(xxx)
#   self._normalize_table_name(xxx) →  self._resolver.normalize(xxx)
#   self._find_best_table_match(xxx, ...) →  self._resolver._find_best_match(xxx, ...)
```

**Step 3**：修正调用点清单（逐一确认）

| 文件 | 原调用 | 替换为 |
|---|---|---|
| `procedure_parser.py:420` | `self._is_valid_table(target_table)` | `TableNameResolver.is_valid_table(target_table)` |
| `procedure_parser.py:446` | `self._is_valid_table(target_table)` | `TableNameResolver.is_valid_table(target_table)` |
| `procedure_parser.py:469` | `self._is_valid_table(target_table)` | `TableNameResolver.is_valid_table(target_table)` |
| `procedure_parser.py:698` | `self._normalize_table_name(target_table)` | `self._resolver.normalize(target_table)` |
| `procedure_parser.py:760` | `self._normalize_table_name(target_table)` | `self._resolver.normalize(target_table)` |
| `procedure_parser.py:828` | `self._normalize_table_name(target_table)` | `self._resolver.normalize(target_table)` |
| `procedure_parser.py:870` | `self._is_temp_table(tbl)` | `TableNameResolver.is_temp_table(tbl)` |
| `procedure_parser.py:877` | `self._is_temp_table(tbl)` | `TableNameResolver.is_temp_table(tbl)` |
| `procedure_parser.py:906` | `self._is_temp_table(op.target_table)` | `TableNameResolver.is_temp_table(op.target_table)` |
| `procedure_parser.py:954` | `self._normalize_table_name(tbl)` | `self._resolver.normalize(tbl)` |
| `procedure_parser.py:961` | `self._normalize_table_name(tbl)` | `self._resolver.normalize(tbl)` |
| `procedure_parser.py:965` | `self._normalize_table_name(tbl)` | `self._resolver.normalize(tbl)` |
| `procedure_parser.py:983` | `self._normalize_table_name(tbl)` | `self._resolver.normalize(tbl)` |
| `procedure_parser.py:990` | `self._normalize_table_name(tbl)` | `self._resolver.normalize(tbl)` |
| `procedure_parser.py:994` | `self._normalize_table_name(tbl)` | `self._resolver.normalize(tbl)` |
| `procedure_parser.py:960` | `self._is_valid_table(tbl)` | `TableNameResolver.is_valid_table(tbl)` |
| `procedure_parser.py:964` | `self._is_valid_table(tbl)` | `TableNameResolver.is_valid_table(tbl)` |
| `procedure_parser.py:989` | `self._is_valid_table(tbl)` | `TableNameResolver.is_valid_table(tbl)` |
| `procedure_parser.py:993` | `self._is_valid_table(tbl)` | `TableNameResolver.is_valid_table(tbl)` |
| `procedure_parser.py:997` | `self._is_valid_table(tbl)` | `TableNameResolver.is_valid_table(tbl)` |

**Step 4**：更新 Oracle 适配器传递 resolver

```python
# core/adapters/oracle_prc_adapter.py — 修改解析器创建

class OraclePrcAdapter:
    def __init__(self, ...):
        # 原代码：
        # self._parser = EnhancedProcedureParser(tables)
        # 修改为：
        self._resolver = TableNameResolver(known_full_names=set(tables.keys()))
        self._parser = EnhancedProcedureParser(tables, resolver=self._resolver)
```

**Step 5**：验证

- 运行 `pytest tests/ -x -k "procedure or parse or lineage"` 确认零回归
- 手动验证：调用 `parse_prc_file()` 对 3 个已知 `.prc` 文件解析，对比改造前后 `field_mappings` 输出完全一致

#### 预期收益
- 消除 ~75 行重复代码
- 消除规则分叉风险（唯一真相源）
- `bare_table()` / `normalize()` 规则修改只需改 `table_name_resolver.py` 一处

---

### P0-2：将 Pydantic 响应模型接入路由返回类型

#### 问题定位

所有路由函数返回 `-> dict`，Pydantic 模型（`BaseResponse`、`LineageQueryResponse`、`CaliberQueryResponse` 等）定义了不用。后果：
- OpenAPI 自动文档无法生成精确的响应 schema
- 运行时无响应数据校验
- 模型定义与实际响应可能不同步

#### 改造方案

**Step 1**：统一响应包装器

在 `app/models/__init__.py` 中新增 `ApiResponse` 泛型模型：

```python
# app/models/__init__.py — 新增

from typing import TypeVar, Generic

T = TypeVar("T")

class ApiResponse(BaseModel, Generic[T]):
    """统一 API 响应模型"""
    code: int = Field(default=0, description="状态码: 0=成功, 非0=错误")
    message: str = Field(default="", description="提示信息")
    data: Optional[T] = Field(default=None, description="响应数据")
    timestamp: datetime = Field(default_factory=datetime.now)
```

**Step 2**：定义每个端点的具体响应类型

```python
# app/models/responses.py — 新建

from typing import Any, Optional
from pydantic import BaseModel, Field
from app.models import ApiResponse

# ---- 血缘查询 ----
class LineageQueryResult(BaseModel):
    query_time_ms: float = 0
    nodes_count: int = 0
    edges_count: int = 0
    nodes: list[dict[str, Any]] = Field(default_factory=list)
    edges: list[dict[str, Any]] = Field(default_factory=list)
    has_more: bool = False
    cache_hit: bool = False
    tables_involved: Optional[int] = None
    procedures_involved: Optional[int] = None
    max_depth_reached: Optional[int] = None
    query_target: Optional[dict[str, Optional[str]]] = None
    field_mappings: list[dict[str, Any]] = Field(default_factory=list)
    field_mapping_count: int = 0

LineageQueryResponse = ApiResponse[LineageQueryResult]

# ---- 表搜索 ----
TableSearchResponse = ApiResponse[list[dict[str, Any]]]

# ---- 系统统计 ----
SystemStatsResult = BaseModel:
    total_tables: int = 0
    total_procedures: int = 0
    total_table_lineages: int = 0
    total_field_mappings: int = 0
    total_caliber_infos: int = 0
    cache_size: int = 0
    active_tasks: int = 0
    uptime_seconds: float = 0.0

SystemStatsResponse = ApiResponse[SystemStatsResult]

# ---- 通用成功/失败 ----
SuccessResponse = ApiResponse[None]
```

**Step 3**：逐一修改路由返回类型

```python
# app/api/lineage.py — 修改前后对比

# ❌ 修改前
def search_tables(...) -> dict:
    ...
    return {"code": 0, "message": "", "data": [t.model_dump() for t in table_list]}

# ✅ 修改后
from app.models.responses import TableSearchResponse

def search_tables(...) -> TableSearchResponse:
    ...
    return TableSearchResponse(data=[t.model_dump() for t in table_list])
```

**Step 4**：修改清单（4 个路由文件，~42 个端点）

| 文件 | 端点数 | 修改要点 |
|---|---|---|
| `app/api/lineage.py` | ~10 | 全部改返回类型 + `ApiResponse` 包装 |
| `app/api/parse.py` | ~6 | SSE 端点不改（返回 StreamingResponse） |
| `app/api/indicator.py` | ~6 | 全部改返回类型 |
| `app/api/system.py` | ~4 | 全部改返回类型 |

**注意**：SSE 端点（`/api/parse/progress/{task_id}`）返回 `StreamingResponse`，不适用此方案，保持原样。

**Step 5**：验证

- 启动服务后访问 `/docs`，确认每个端点的 Response Body 展示正确 schema
- 运行全量测试，确认响应格式不变（`code`/`message`/`data` 三字段仍在）

#### 预期收益
- OpenAPI 文档精准反映响应结构
- 运行时自动校验响应数据类型
- 前端对接有明确契约

---

### P0-3：将 `lineage.py` 路由层业务逻辑下沉到 `LineageService`

#### 问题定位

`lineage.py:119-170` 的 `get_table_fields()` 端点包含约 50 行业务逻辑：
1. 精确匹配 .tab 表
2. 从字段映射中查找过程表
3. 模糊匹配过程表

这些逻辑应属于 Service 层，不应在路由层实现。

#### 改造方案

**Step 1**：在 `LineageService` 中新增方法

```python
# app/services/lineage_service.py — 新增方法

def get_table_fields(self, table_name: str) -> list[str]:
    """获取指定表的字段名列表。

    查找策略（与旧版 api_server.py 一致）：
    1. 精确匹配 .tab 表（table_name 或 full_name）
    2. 从字段映射中查找过程表（短名或全名）
    3. 模糊匹配过程表
    """
    data = self.parser.get_current_data()
    if not data:
        return []

    norm_name = table_name.strip().upper()

    # 1. 精确匹配 .tab 表
    for t in data.get("tables", []):
        tbl_name = (t.get("table_name") or "").upper()
        full_name = (t.get("full_name") or "").upper()
        if tbl_name == norm_name or full_name == norm_name:
            columns = t.get("columns", [])
            return [c.get("name", "") for c in columns if c.get("name")]

    # 2. 从字段映射中查找过程表
    field_mappings = data.get("field_mappings", [])
    proc_fields: dict[str, set[str]] = {}
    for fm in field_mappings:
        tgt_table = (fm.get("target_table") or "").upper()
        tgt_col = fm.get("target_column", "")
        if tgt_table and tgt_col:
            proc_fields.setdefault(tgt_table, set()).add(tgt_col)

    for proc_tbl, fields in proc_fields.items():
        short = proc_tbl.split(".")[-1] if "." in proc_tbl else proc_tbl
        if short == norm_name or proc_tbl == norm_name:
            return sorted(fields)

    # 3. 模糊匹配过程表
    for proc_tbl, fields in proc_fields.items():
        if norm_name in proc_tbl or proc_tbl.endswith(norm_name):
            return sorted(fields)

    return []  # 返回空列表而非抛异常，由路由层决定 404
```

**Step 2**：精简路由层

```python
# app/api/lineage.py — 修改 get_table_fields

@router.get("/tables/{table}/fields", ...)
def get_table_fields(
    table: str,
    lineage_service: LineageServiceDep,  # 改用 LineageService
) -> TableFieldsResponse:
    _validate_table_name(table)
    fields = lineage_service.get_table_fields(table)
    if not fields:
        raise HTTPException(status_code=404, detail=f"未找到表: {table}")
    return TableFieldsResponse(data=fields)
```

**Step 3**：验证

- 运行 `pytest tests/ -x -k "table_fields"` 确认零回归
- 手动测试 `GET /api/tables/{table}/fields` 返回一致

#### 预期收益
- 路由层精简 ~40 行业务逻辑
- `get_table_fields` 可被其他 Service 复用
- 符合"瘦 Controller、胖 Service"原则

---

### P0-4：消除 `LineageService` 对 `ParserService` 私有属性的访问

#### 问题定位

```python
# app/services/lineage_service.py:89
self.parser._tracer_factory.invalidate()

# app/services/lineage_service.py:562（推测）
self.parser._cache_store.get_repository()
```

直接访问 `ParserService` 的私有属性（`_tracer_factory`、`_cache_store`），破坏封装。

#### 改造方案

**Step 1**：在 `ParserService` 中暴露公开方法

```python
# app/services/parser_service.py — 新增公开方法

class ParserService:
    # ... 现有代码 ...

    def invalidate_tracer(self) -> None:
        """使血缘追踪器缓存失效（供 LineageService 调用）"""
        self._tracer_factory.invalidate()

    def get_repository(self) -> Optional[DataRepository]:
        """获取当前数据仓库（供 LineageService 调用）"""
        store = self._cache_store
        if store:
            return store.get_repository()
        return None
```

**Step 2**：替换调用点

```python
# app/services/lineage_service.py — 替换私有属性访问

# ❌ 修改前
self.parser._tracer_factory.invalidate()

# ✅ 修改后
self.parser.invalidate_tracer()

# ❌ 修改前
self.parser._cache_store.get_repository()

# ✅ 修改后
self.parser.get_repository()
```

**Step 3**：全局搜索确认无遗漏

```bash
grep -rn "self\.parser\._\|\.parser\._" app/services/
```

确认输出为空。

**Step 4**：验证

- 运行 `pytest tests/ -x -k "lineage_service or cache"`
- 手动测试缓存失效逻辑：`POST /api/cache/rebuild` → 索引重建成功

#### 预期收益
- 消除私有属性访问，封装修复
- `ParserService` 内部重构不影响 `LineageService`

---

## P1 — 短期改进（2-4 周）

### P1-5：拆分 God Method `_bfs_trace`

#### 问题定位

`lineage_tracer.py:190-350` 的 `_bfs_trace()` 方法 160 行，圈复杂度 18-22，嵌套深度 5 层。

#### 改造方案

**拆分策略**：按职责提取子方法

```python
# core/lineage_tracer.py — _bfs_trace 拆分

def _bfs_trace(self, target_table: str, target_field: str, max_depth: int = 10) -> dict[str, _BFSNode]:
    norm_table = self.normalize_name(target_table)
    norm_field = self._normalize_field_name(target_field)

    bfs_tree, visited, root_node = self._init_bfs_root(norm_table, norm_field)
    queue: deque[_BFSNode] = deque([root_node])

    while queue:
        current = queue.popleft()
        if current.layer >= max_depth:
            continue

        sources = self._find_source_fields(current.table_name, current.field_name)
        if not sources:
            continue

        # 同表变换折叠
        sources, transform_note = self._fold_same_table_transforms(
            current, sources, bfs_tree
        )

        # 扩展 BFS 树
        current_key = f"{current.table_name}.{current.field_name}"
        self._update_transform_annotation(bfs_tree, current_key, transform_note)
        self._expand_bfs_neighbors(
            bfs_tree, visited, queue, current, sources, current_key
        )

    logger.info("BFS 遍历结束: 根节点=%s.%s, 共访问 %d 个节点", norm_table, norm_field, len(bfs_tree))
    return bfs_tree


def _init_bfs_root(self, table: str, field: str) -> tuple[dict[str, _BFSNode], set[str], _BFSNode]:
    """创建 BFS 根节点和初始 visited 集合"""
    root_key = f"{table}.{field}"
    visited: set[str] = {root_key}
    root_bare = self.bare_table(table)
    if root_bare != table:
        visited.add(f"{root_bare}.{field}")

    root_node = _BFSNode(
        table_name=table, field_name=field, layer=0,
        procedure="", transform_logic="(目标字段)", parent_key="",
    )
    bfs_tree: dict[str, _BFSNode] = {root_key: root_node}
    return bfs_tree, visited, root_node


def _fold_same_table_transforms(
    self, current: _BFSNode, sources: list[_SourceRecord], bfs_tree: dict[str, _BFSNode]
) -> tuple[list[_SourceRecord], str]:
    """同表字段变换折叠：跳过中间同表节点，直接找到跨表上游"""
    cur_bare = self.bare_table(current.table_name)
    final_sources: list[_SourceRecord] = []
    same_table_transform_note = ""

    for src in sources:
        src_bare = self.bare_table(self.normalize_name(src.source_table))
        if src_bare == cur_bare:
            transform_note = src.transform_logic or "同表字段转换"
            same_table_transform_note = transform_note
            inner_sources = self._find_source_fields(src.source_table, src.source_field)
            if inner_sources:
                found_cross_table = False
                for inner in inner_sources:
                    inner_bare = self.bare_table(self.normalize_name(inner.source_table))
                    if inner_bare != cur_bare:
                        final_sources.append(inner)
                        found_cross_table = True
                if not found_cross_table:
                    src.transform_logic = transform_note
                    final_sources.append(src)
            else:
                src.transform_logic = transform_note
                final_sources.append(src)
        else:
            final_sources.append(src)

    return final_sources, same_table_transform_note


def _update_transform_annotation(self, bfs_tree: dict, key: str, note: str) -> None:
    """更新 BFS 节点的变换注解"""
    if not note or key not in bfs_tree:
        return
    existing = bfs_tree[key].transform_logic
    if existing and existing != "(目标字段)":
        bfs_tree[key].transform_logic = f"{existing}; {note}"
    else:
        bfs_tree[key].transform_logic = note


def _expand_bfs_neighbors(
    self, bfs_tree: dict, visited: set, queue: deque,
    current: _BFSNode, sources: list[_SourceRecord], current_key: str,
) -> None:
    """将当前节点的上游来源扩展到 BFS 树中"""
    for src in sources:
        src_norm_table = self.normalize_name(src.source_table)
        src_norm_field = self._normalize_field_name(src.source_field)
        src_key = f"{src_norm_table}.{src_norm_field}"

        if not src_norm_table or not src_norm_field:
            continue

        bare_key = ""
        bare_tbl = self.bare_table(src_norm_table)
        if bare_tbl != src_norm_table:
            bare_key = f"{bare_tbl}.{src_norm_field}"

        if src_key in visited or (bare_key and bare_key in visited):
            continue

        if not self.is_layer_compatible(src_norm_table, current.table_name):
            continue

        visited.add(src_key)
        if bare_key:
            visited.add(bare_key)

        src_node = _BFSNode(
            table_name=src_norm_table, field_name=src_norm_field,
            layer=current.layer + 1, procedure=src.procedure,
            transform_logic=src.transform_logic, parent_key=current_key,
        )
        bfs_tree[src_key] = src_node
        queue.append(src_node)
```

**验证**：
- 对 5 个目标字段执行 `trace_field()`，对比拆分前后结果完全一致
- 运行 `pytest tests/ -x -k "lineage"`

---

### P1-6：参数化 BFS 方向，合并上游/下游两个方法

#### 问题定位

`_bfs_trace()` 和 `_bfs_trace_downstream()` 代码结构几乎相同（~100 行重复），区别仅在：
- 查找方向：`_find_source_fields` vs `_find_target_fields`
- 层级兼容性：`is_layer_compatible` vs `is_downstream_layer_compatible`
- 起始标记：`"(目标字段)"` vs `"(起始字段)"`

#### 改造方案

```python
# core/lineage_tracer.py — 统一 BFS 引擎

from enum import Enum

class BFSDirection(Enum):
    UPSTREAM = "upstream"
    DOWNSTREAM = "downstream"


def _bfs_trace_unified(
    self,
    table: str,
    field: str,
    max_depth: int = 10,
    direction: BFSDirection = BFSDirection.UPSTREAM,
) -> dict[str, _BFSNode]:
    """统一 BFS 追溯引擎（上游/下游）"""
    norm_table = self.normalize_name(table)
    norm_field = self._normalize_field_name(field)

    is_upstream = direction == BFSDirection.UPSTREAM
    root_label = "(目标字段)" if is_upstream else "(起始字段)"
    root_key = f"{norm_table}.{norm_field}"

    bfs_tree, visited = self._init_bfs_root(norm_table, norm_field, root_label)
    queue: deque[_BFSNode] = deque([bfs_tree[root_key]])

    while queue:
        current = queue.popleft()
        if current.layer >= max_depth:
            continue

        # 方向感知：选择查找方法
        if is_upstream:
            neighbors = self._find_source_fields(current.table_name, current.field_name)
            neighbor_records = self._source_records_to_expand(current, neighbors)
        else:
            neighbors = self._find_target_fields(current.table_name, current.field_name)
            neighbor_records = self._target_records_to_expand(current, neighbors)

        if not neighbor_records and is_upstream:
            continue

        current_key = f"{current.table_name}.{current.field_name}"

        for rec in neighbor_records:
            self._try_enqueue_neighbor(
                bfs_tree, visited, queue, current, current_key,
                rec, is_upstream
            )

    logger.info(
        "%s BFS 遍历结束: 根=%s.%s, 节点数=%d",
        direction.value, norm_table, norm_field, len(bfs_tree),
    )
    return bfs_tree


# ---- 保留原方法作为薄代理 ----

def _bfs_trace(self, target_table: str, target_field: str, max_depth: int = 10) -> dict[str, _BFSNode]:
    return self._bfs_trace_unified(target_table, target_field, max_depth, BFSDirection.UPSTREAM)

def _bfs_trace_downstream(self, source_table: str, source_field: str, max_depth: int = 10) -> dict[str, _BFSNode]:
    return self._bfs_trace_unified(source_table, source_field, max_depth, BFSDirection.DOWNSTREAM)
```

**验证**：
- 对比 10 组输入的 `_bfs_trace()` 和 `_bfs_trace_unified(upstream)` 结果一致
- 对比 10 组输入的 `_bfs_trace_downstream()` 和 `_bfs_trace_unified(downstream)` 结果一致

---

### P1-7：合并三个重复枚举

#### 问题定位

```python
# app/models/__init__.py
class QueryMode(str, Enum):        # 第 27 行
class CaliberQueryMode(str, Enum):  # 第 40 行
class IndicatorQueryMode(str, Enum): # 第 257 行
```

三个枚举的值完全相同：`UPSTREAM / DOWNSTREAM / BOTH`。

#### 改造方案

```python
# app/models/__init__.py

class LineageDirection(str, Enum):
    """统一血缘查询方向枚举"""
    UPSTREAM = "upstream"
    DOWNSTREAM = "downstream"
    BOTH = "both"

# 向后兼容别名（保留 2 个版本后删除）
QueryMode = LineageDirection
CaliberQueryMode = LineageDirection
IndicatorQueryMode = LineageDirection
```

全局搜索替换所有使用点：
```bash
grep -rn "QueryMode\|CaliberQueryMode\|IndicatorQueryMode" app/ core/ tests/
```

逐一改为 `LineageDirection`。别名保留 2 个版本后删除。

---

### P1-8：统一错误处理

#### 问题定位

三种错误处理风格并存：
1. `indicator.py` — 自定义 `_ok()` / `_err()` 辅助函数
2. `lineage.py` / `parse.py` — 手工构造 `{"code": 0, ...}` 字典
3. 全局异常处理器 — 返回 `{"code": 500, ...}`

#### 改造方案

**Step 1**：创建统一响应构建器

```python
# app/utils/response_utils.py — 新建

from typing import Any, Optional
from fastapi import HTTPException
from app.models.responses import ApiResponse

def ok(data: Any = None, message: str = "查询成功") -> dict:
    """统一成功响应"""
    return {"code": 0, "message": message, "data": data}

def err(code: int = 1, message: str = "查询失败") -> dict:
    """统一错误响应（非 HTTP 异常）"""
    return {"code": code, "message": message, "data": None}

def raise_not_found(message: str) -> None:
    """统一 404 响应"""
    raise HTTPException(status_code=404, detail=message)

def raise_bad_request(message: str) -> None:
    """统一 400 响应"""
    raise HTTPException(status_code=400, detail=message)
```

**Step 2**：全局搜索替换

```python
# ❌ 删除 indicator.py 中的 _ok() / _err()（第 20-25 行）
# ❌ 删除所有路由中的手工构造 {"code": 0, ...}

# ✅ 替换为
from app.utils.response_utils import ok, err, raise_not_found

# 示例：lineage.py
def search_tables(...) -> TableSearchResponse:
    ...
    return ok(data=[t.model_dump() for t in table_list])

# 示例：indicator.py
def search_indicators(...) -> IndicatorSearchResponse:
    ...
    return ok(results)
```

---

### P1-9：添加 `pytest-cov` 配置

#### 改造方案

**Step 1**：安装依赖

```bash
pip install pytest-cov
```

**Step 2**：更新 `pyproject.toml`（如有）或 `pytest.ini`

```ini
# pytest.ini — 新增

[pytest]
addopts = --cov=core --cov=app --cov-report=term-missing --cov-report=html:output/htmlcov
cov_fail_under = 40
```

**Step 3**：更新 `requirements.txt`

```
pytest-cov>=5.0.0
```

**Step 4**：CI 集成（可选）

```yaml
# .github/workflows/test.yml
- name: Run tests with coverage
  run: pytest --cov=core --cov=app --cov-fail-under=40
```

---

### P1-10：引入 `/api/v1/` 版本前缀

#### 改造方案

**Step 1**：路由文件修改

```python
# app/api/lineage.py — 修改前缀

# ❌ 修改前
router = APIRouter(prefix="/api", tags=["血缘查询"])

# ✅ 修改后
router = APIRouter(prefix="/api/v1", tags=["血缘查询"])
```

同样修改 `parse.py`、`indicator.py`、`system.py`。

**Step 2**：保留旧路由兼容层

```python
# app/main.py — 新增兼容路由

from fastapi import APIRouter

# 旧路由兼容层（重定向到 v1，标记 deprecated）
legacy_router = APIRouter(prefix="/api", tags=["旧版API(即将下线)"], deprecated=True)

@legacy_router.api_route("/{path:path}", methods=["GET", "POST"])
async def legacy_redirect(path: str):
    """旧版 API 兼容层：所有 /api/* 请求转发到 /api/v1/*"""
    from fastapi.responses import RedirectResponse
    return RedirectResponse(url=f"/api/v1/{path}", status_code=307)

app.include_router(legacy_router)
```

**Step 3**：更新前端 API 调用

```javascript
// static/js/config.js — 修改 API 基础路径
const API_BASE = '/api/v1';
```

**Step 4**：验证

- 访问 `/api/v1/tables?keyword=test` 确认新路由可用
- 访问 `/api/tables?keyword=test` 确认旧路由重定向到 v1

---

## P2 — 中期重构（1-2 月）

### P2-11：拆分 `LineageTracer`（SRP 重构）

#### 当前职责（7 项 → 拆分为 4 个类）

| 新类 | 职责 | 来源方法 |
|---|---|---|
| `LineageIndex` | 索引构建与查询 | `_build_lineage_indexes`, `_find_source_fields`, `_find_target_fields`, `_fuzzy_match_*`, `_try_tmp_bridge`, `_find_procedures_for_table`, `_find_source_fields_in_procedure` |
| `BFSEngine` | BFS 遍历引擎 | `_bfs_trace_unified`, `_fold_same_table_transforms`, `_expand_bfs_neighbors`, `_init_bfs_root` |
| `ChainBuilder` | BFS 树→链路转换 | `_build_chains_from_bfs_tree` |
| `GraphConverter` | 链路→图结果转换 | `to_graph_result` |

#### 改造方案

```python
# core/lineage/index.py — 新建
class LineageIndex:
    """血缘索引构建与 O(1) 查询"""

    def __init__(self, tables, procedures, table_lineages, field_mappings): ...
    def find_source_fields(self, table, field) -> list[_SourceRecord]: ...
    def find_target_fields(self, table, field) -> list[_TargetRecord]: ...
    def fuzzy_match_table_key(self, table_name) -> Optional[str]: ...
    def try_tmp_bridge(self, target_table, target_field) -> Optional[_SourceRecord]: ...


# core/lineage/bfs_engine.py — 新建
class BFSEngine:
    """BFS 遍历引擎（无状态，依赖 LineageIndex）"""

    def __init__(self, index: LineageIndex, resolver: TableNameResolver): ...
    def trace(self, table, field, max_depth, direction) -> dict[str, _BFSNode]: ...


# core/lineage/chain_builder.py — 新建
class ChainBuilder:
    """BFS 树→FieldLineageChain 转换"""

    @staticmethod
    def build_chains(bfs_tree, target, reverse=False) -> list[FieldLineageChain]: ...


# core/lineage/graph_converter.py — 新建
class GraphConverter:
    """FieldLineageChain→图结果（节点+边+映射）"""

    @staticmethod
    def to_graph(chains, direction="upstream") -> tuple[set[str], list[dict], list[dict]]: ...
```

**`LineageTracer` 改为编排层**：

```python
# core/lineage_tracer.py — 精简为编排器

class LineageTracer(BaseTracer):
    def __init__(self, tables, procedures, table_lineages, field_mappings, max_depth=10):
        super().__init__(tables, procedures, table_lineages, field_mappings, max_depth)
        self._index = LineageIndex(tables, procedures, table_lineages, field_mappings)
        self._engine = BFSEngine(self._index, self._resolver)
        self._chain_builder = ChainBuilder()
        self._graph_converter = GraphConverter()

    def trace_field(self, target_table, target_field) -> FieldLineageResult:
        bfs_tree = self._engine.trace(target_table, target_field, self.max_depth, BFSDirection.UPSTREAM)
        chains = self._chain_builder.build_chains(bfs_tree, ...)
        # ... 构建 FieldLineageResult ...
```

---

### P2-12：拆分 `CaliberExtractor`（SRP 重构）

#### 当前职责（16 项 → 拆分为 4 个类）

| 新类 | 职责 |
|---|---|
| `ConditionExtractor` | WHERE/JOIN/GROUP BY/HAVING/DISTINCT/ORDER BY 条件提取 |
| `MetadataExtractor` | CTE/自定义函数/窗口函数/集合运算/子查询元数据提取 |
| `ExpressionBuilder` | SELECT 列映射/完整表达式/CaliberInfo 构建 |
| `CaliberExtractor` | 编排层，组合上述三个组件 |

---

### P2-13：提取公共括号匹配工具

#### 改造方案

```python
# core/utils/bracket_matcher.py — 新建

def find_matching_bracket(text: str, start: int, open_char: str = "(", close_char: str = ")") -> int:
    """从 start 位置（open_char 所在位置）开始，找到匹配的 close_char 位置。
    
    Returns:
        匹配的 close_char 位置索引，未找到返回 -1
    """
    depth = 0
    i = start
    while i < len(text):
        if text[i] == open_char:
            depth += 1
        elif text[i] == close_char:
            depth -= 1
            if depth == 0:
                return i
        i += 1
    return -1


def extract_balanced(text: str, open_char: str = "(", close_char: str = ")") -> list[tuple[int, int]]:
    """提取文本中所有平衡的括号对位置"""
    ...
```

在 `sql_boundary_detector.py` 和 `caliber_extractor.py` 中替换为：

```python
from core.utils.bracket_matcher import find_matching_bracket, extract_balanced
```

---

### P2-14：拆分 `LineageService`（1089 行 → 3-4 个服务）

| 新服务 | 职责 | 来源方法 |
|---|---|---|
| `TableQueryService` | 表搜索、表信息、字段列表 | `search_tables`, `get_table_info`, `get_table_fields`, `get_system_stats` |
| `FieldLineageService` | 字段级血缘追溯 | `query_lineage`, `trace_field_lineage`, `get_edge_caliber`, `get_node_detail` |
| `CaliberQueryService` | 口径查询（已存在 `caliber_service.py`，合并逻辑） | `query_caliber`, `search_indicators`, `build_summary_card`, `build_pipeline_view` |
| `IndexService` | 索引管理 | `_build_indexes`, `rebuild_indexes`, `_on_data_changed`, `_on_cache_invalidated` |

---

### P2-15：为 `core/warehouse/` 添加专门测试

#### 改造方案

```python
# tests/test_warehouse_parser.py — 新建

import pytest
from core.warehouse.warehouse_parser import WarehouseParser
from core.warehouse.schema_resolver import SchemaResolver
from core.warehouse.temp_table_filter import TempTableFilter
from core.warehouse.ddl_parser import DDLParser
from core.warehouse.dml_parser import DMLParser
from core.warehouse.ctl_parser import CTLParser

class TestSchemaResolver:
    """测试 ${xxx_schema} 变量替换"""
    def test_resolve_single_variable(self): ...
    def test_resolve_nested_variable(self): ...
    def test_resolve_9_known_schemas(self): ...

class TestDDLParser:
    """测试 DDL 文件解析"""
    def test_parse_create_table(self): ...
    def test_parse_create_table_with_schema_prefix(self): ...

class TestDMLParser:
    """测试 DML 文件解析"""
    def test_parse_insert_select(self): ...
    def test_parse_merge_into(self): ...

class TestCTLParser:
    """测试 CTL 控制文件解析"""
    def test_parse_load_data(self): ...
    def test_parse_into_table(self): ...

class TestTempTableFilter:
    """测试临时表过滤"""
    def test_filter_tmp_tables(self): ...
    def test_preserve_non_tmp(self): ...

class TestWarehouseParserIntegration:
    """集成测试：两阶段解析"""
    @pytest.fixture
    def sample_data_dir(self, tmp_path): ...
    def test_two_phase_parse_ddl_then_dml(self): ...
```

---

### P2-16：Mock 数据层

#### 改造方案

```python
# tests/fixtures/mock_data.py — 新建

from core.models import TableInfo, ProcedureInfo, FieldMapping, TableLineage

def create_mock_tables(count: int = 10) -> dict[str, TableInfo]:
    """创建模拟表数据"""
    ...

def create_mock_procedures(count: int = 5) -> dict[str, ProcedureInfo]:
    """创建模拟存储过程数据"""
    ...

def create_mock_field_mappings(count: int = 50) -> list[FieldMapping]:
    """创建模拟字段映射"""
    ...

def create_mock_data_repository() -> dict:
    """创建完整的模拟数据仓库"""
    return {
        "tables": [...],
        "procedures": [...],
        "field_mappings": [...],
        "table_lineages": [...],
    }


# tests/conftest.py — 补充 fixture

import pytest
from tests.fixtures.mock_data import create_mock_data_repository

@pytest.fixture
def mock_data():
    return create_mock_data_repository()

@pytest.fixture
def mock_tracer(mock_data):
    from core.lineage_tracer import LineageTracer
    return LineageTracer(
        tables={t["full_name"]: TableInfo(**t) for t in mock_data["tables"]},
        procedures={p["full_name"]: ProcedureInfo(**p) for p in mock_data["procedures"]},
        table_lineages=[TableLineage(**tl) for tl in mock_data["table_lineages"]],
        field_mappings=[FieldMapping(**fm) for fm in mock_data["field_mappings"]],
    )

@pytest.fixture
def client(mock_data):
    """FastAPI TestClient with mocked data"""
    from fastapi.testclient import TestClient
    from unittest.mock import patch

    with patch("app.services.parser_service.ParserService.get_current_data", return_value=mock_data):
        from app.main import app
        yield TestClient(app)
```

---

## P3 — 长期演进

### P3-17：核心解析器直接实现 `FileParser` Protocol

#### 当前架构

```
OracleTableParser ──→ OracleTabAdapter ──→ ParserRegistry
EnhancedProcedureParser ──→ OraclePrcAdapter ──→ ParserRegistry
```

#### 目标架构

```
OracleTableParser(FileParser) ──→ ParserRegistry
EnhancedProcedureParser(FileParser) ──→ ParserRegistry
```

#### 改造方案

**Step 1**：让 `OracleTableParser` 实现 `FileParser` Protocol

```python
# core/table_parser.py — 实现 Protocol

from core.parser_protocol import FileParser, ParseOutput

class OracleTableParser(FileParser):  # 新增 Protocol 实现
    @classmethod
    def supported_extensions(cls) -> list[str]:
        return [".tab"]

    def parse(self, file_path: str) -> ParseOutput:
        """Protocol 要求的统一接口"""
        result = self.parse_tab_file(file_path)
        if result is None:
            return ParseOutput(success=False, error="解析失败")
        return ParseOutput(success=True, data=result)
```

**Step 2**：让 `EnhancedProcedureParser` 实现 `FileParser` Protocol

```python
# core/procedure_parser.py — 实现 Protocol

class EnhancedProcedureParser(FileParser):  # 新增 Protocol 实现
    @classmethod
    def supported_extensions(cls) -> list[str]:
        return [".prc"]

    def parse(self, file_path: str) -> ParseOutput:
        """Protocol 要求的统一接口"""
        result = self.parse_prc_file(file_path)
        if result is None:
            return ParseOutput(success=False, error="解析失败")
        return ParseOutput(success=True, data=result)
```

**Step 3**：逐步废弃 Adapter 层

```python
# core/adapters/oracle_tab_adapter.py — 标记 deprecated

import warnings

class OracleTabAdapter:
    def __init__(self, ...):
        warnings.warn(
            "OracleTabAdapter 已废弃，请直接使用 OracleTableParser（已实现 FileParser Protocol）",
            DeprecationWarning,
            stacklevel=2,
        )
```

---

### P3-18：JWT/OAuth2 认证替代单一 API Key

#### 改造方案

```python
# app/auth/jwt.py — 新建

from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer

SECRET_KEY = "your-secret-key"  # 从环境变量读取
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/token")

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

async def get_current_user(token: str = Depends(oauth2_scheme)) -> dict:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="无法验证凭据",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    return {"username": username}
```

**过渡策略**：同时支持 API Key 和 JWT，3 个月后下线 API Key。

---

### P3-19：前端构建工具链（Vite + TypeScript）

#### 改造方案

```
static/
├── js/           ← 保留（运行时产物）
├── css/          ← 保留（运行时产物）
└── src/          ← 新建（源码）
    ├── main.ts
    ├── components/
    │   ├── LineageGraph.vue
    │   ├── SearchBar.vue
    │   └── CaliberPanel.vue
    ├── api/
    │   └── lineage.ts       ← API 调用封装
    ├── types/
    │   └── lineage.ts       ← TypeScript 类型定义
    └── utils/
        └── d3-helpers.ts

vite.config.ts
tsconfig.json
package.json
```

**迁移策略**：逐步迁移，每次迁移一个 JS 文件到 TS，不搞大爆炸。

---

### P3-20：异步 BFS 追溯

#### 改造方案

```python
# core/lineage/bfs_engine_async.py — 新建

import anyio
from typing import AsyncIterator

class AsyncBFSEngine:
    """异步 BFS 追溯引擎

    在大规模查询（深度>5，节点>100）时不阻塞事件循环。
    """

    async def trace(
        self, table: str, field: str, max_depth: int, direction: BFSDirection
    ) -> dict[str, _BFSNode]:
        """异步 BFS 追溯"""
        bfs_tree = {}
        visited = set()
        # ... 同步逻辑，但在每个 BFS 层后 yield 控制权 ...
        while queue:
            current = queue.popleft()
            # ... 处理逻辑 ...
            # 每处理 10 个节点后让出控制权
            if len(bfs_tree) % 10 == 0:
                await anyio.sleep(0)
        return bfs_tree
```

**注意**：此改造需要先将 FastAPI 路由从 `def` 改为 `async def`，确保 `ParserService` 的线程池模型兼容。

---

## 附录 A：改造检查清单

每个改造项完成后的必检项：

```
□ 代码改动已提交（Conventional Commits 格式：feat/fix/refactor: xxx）
□ pytest tests/ -x 全量通过
□ 手动冒烟测试通过（启动服务 → 前端操作 → 关键功能正常）
□ 无新增 lint 警告
□ 如果涉及 API 变更，已更新 /docs 文档
□ 如果涉及新增依赖，已更新 requirements.txt
□ 记忆文件已更新（.workbuddy/memory/YYYY-MM-DD.md）
```

## 附录 B：风险与回滚策略

| 改造项 | 风险等级 | 回滚策略 |
|---|---|---|
| P0-1 TableNameResolver 委托 | **高** | 保留旧方法 2 个版本，`git revert` 即回滚 |
| P0-2 Pydantic 模型接入 | 中 | 模型不匹配时返回 fallback dict |
| P0-3 业务逻辑下沉 | 低 | 路由层重新内联即可 |
| P0-4 消除私有访问 | 低 | 恢复直接访问即可 |
| P1-6 BFS 参数化 | **高** | 保留旧方法作为代理，旧方法直接调用旧实现 |
| P1-10 API 版本控制 | 中 | 移除 v1 前缀，恢复 /api/ 即可 |
| P2-11/12 SRP 重构 | **高** | LineageTracer 原实现完整保留在新类中，可一键回退 |

**核心原则**：所有高风险改造都保留"薄代理"层，旧方法签名不变，内部委托到新实现。回滚时只需恢复委托为旧实现。

## 附录 C：新增文件清单

| 文件路径 | 对应改造项 |
|---|---|
| `app/models/responses.py` | P0-2 |
| `app/utils/response_utils.py` | P1-8 |
| `core/utils/bracket_matcher.py` | P2-13 |
| `core/lineage/__init__.py` | P2-11 |
| `core/lineage/index.py` | P2-11 |
| `core/lineage/bfs_engine.py` | P2-11 |
| `core/lineage/chain_builder.py` | P2-11 |
| `core/lineage/graph_converter.py` | P2-11 |
| `core/lineage/bfs_engine_async.py` | P3-20 |
| `app/auth/jwt.py` | P3-18 |
| `tests/test_warehouse_parser.py` | P2-15 |
| `tests/fixtures/mock_data.py` | P2-16 |
| `static/src/main.ts` | P3-19 |
