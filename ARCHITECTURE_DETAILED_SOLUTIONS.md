# 数据血缘分析系统 — 问题详解与优化方案

> 基于 ARCHITECTURE_REVIEW.md 中的评估结论，本文档对每个问题进行根因分析、影响评估，并给出包含代码示例的详细解决方案。

---

## 目录

1. [问题一：dict/dataclass 双轨数据模型](#问题一dictdataclass-双轨数据模型)
2. [问题二：ParserService God Class](#问题二parserservice-god-class)
3. [问题三：LineageService.query_lineage 超长方法](#问题三lineageservicequery_lineage-超长方法)
4. [问题四：CaliberInfo 字段膨胀](#问题四caliberinfo-字段膨胀)
5. [问题五：LineageTracer 与 CaliberTracer 代码重复](#问题五lineagetracer-与-calibertracer-代码重复)
6. [问题六：缓存策略一致性问题](#问题六缓存策略一致性问题)
7. [问题七：API 响应格式不统一](#问题七api-响应格式不统一)
8. [问题八：性能风险](#问题八性能风险)
9. [问题九：测试覆盖不足](#问题九测试覆盖不足)
10. [问题十：安全与代码卫生](#问题十安全与代码卫生)
11. [实施路线图](#实施路线图)

---

## 问题一：dict/dataclass 双轨数据模型

### 1.1 问题描述

项目同时使用两套数据表示，且在多处进行手工转换：

| 表示形式 | 使用位置 | 特点 |
|----------|----------|------|
| `@dataclass` | `core/models.py` 中的 `TableInfo`, `ProcedureInfo`, `FieldMapping`, `CaliberInfo` 等 | 类型安全，有 `@property`，IDE 可补全 |
| `dict` | `ParseResult.tables`, `ParseResult.procedures`, JSON 缓存文件 | 无类型检查，字段名拼写错误只能在运行时发现 |

### 1.2 根因分析

**历史演进路径**：

1. 最初 `core/models.py` 定义了 dataclass，解析器（`OracleTableParser`, `EnhancedProcedureParser`）产出 dataclass 对象
2. 为了 JSON 序列化/缓存，`ParserService` 在 `_parse_tab_directory()` 和 `_parse_proc_directory()` 中手工将 dataclass 转为 dict
3. `ParseResult` 全部使用 `list[dict]` 存储
4. 后续需要构建 `LineageTracer` / `CaliberTracer` 时，又需要从 dict 反向重建 dataclass
5. 每次新增字段，需要在 3-4 处同步修改序列化/反序列化代码

**核心矛盾**：dataclass 是"内存中的工作模型"，dict 是"持久化模型"，但两者之间没有统一的转换层，转换逻辑散落在业务代码中。

### 1.3 具体影响

**影响点 1 — 序列化代码散落 5+ 处**：

| 位置 | 转换方向 | 行数 |
|------|----------|------|
| [parser_service.py:718-729](app/services/parser_service.py#L718-L729) `_parse_tab_directory` | dataclass → dict | ~12 行 |
| [parser_service.py:743-770](app/services/parser_service.py#L743-L770) `_parse_proc_directory` | dataclass → dict | ~28 行 |
| [parser_service.py:790-800](app/services/parser_service.py#L790-L800) `_parse_single_tab` | dataclass → dict | ~12 行 |
| [parser_service.py:818-845](app/services/parser_service.py#L818-L845) `_parse_single_prc` | dataclass → dict | ~28 行 |
| [parser_service.py:593-700](app/services/parser_service.py#L593-L700) `get_lineage_tracer` | dict → dataclass | ~108 行 |
| [caliber_service.py:109-160](app/services/caliber_service.py#L109-L160) `_build_tracer` | dict → dataclass | ~52 行 |

**影响点 2 — 字段遗漏风险**：

以 `FieldMapping` 为例，dataclass 有 9 个字段，但序列化时只写了 7 个：

```python
# dataclass 定义（core/models.py）
@dataclass
class FieldMapping:
    source_schema: str = ""    # ← 序列化时遗漏
    source_table: str = ""
    source_column: str = ""
    target_schema: str = ""    # ← 序列化时遗漏
    target_table: str = ""
    target_column: str = ""
    transform_logic: str = ""
    procedure: str = ""
    confidence: float = 1.0

# 序列化代码（parser_service.py:761-770）
for fm in proc_info.field_mappings:
    result.field_mappings.append({
        "source_table": fm.source_table,       # source_schema 丢失！
        "source_column": fm.source_column,
        "target_table": fm.target_table,       # target_schema 丢失！
        "target_column": fm.target_column,
        "transform_logic": fm.transform_logic,
        "procedure": fm.procedure,
        "confidence": fm.confidence,
    })
```

`source_schema` 和 `target_schema` 在序列化时被静默丢弃，反序列化时也无法恢复。如果后续逻辑依赖这两个字段，将产生空值 bug。

**影响点 3 — 重复的反序列化逻辑**：

`ParserService.get_lineage_tracer()` 和 `CaliberService._build_tracer()` 都在做"dict → dataclass"重建，但实现略有差异：

```python
# parser_service.py:606-613 — 重建 TableInfo 时包含 columns
tables[full_name] = TableInfo(
    schema=schema,
    table_name=table_name,
    full_name=full_name,
    comment=t.get("comment", ""),
    columns=columns,               # ← 包含列信息
    primary_keys=t.get("primary_keys", []),
)

# caliber_service.py:111-118 — 重建 TableInfo 时不包含 columns
ti = TableInfo(
    schema=t.get("schema", ""),
    table_name=t.get("table_name", ""),
    full_name=t.get("full_name", t.get("table_name", "")),
)                                   # ← columns 为空列表（默认值）
```

两处行为不一致：`LineageTracer` 拿到的 `TableInfo` 有列信息，`CaliberTracer` 拿到的没有。如果 `CaliberTracer` 未来需要列信息，将产生空指针错误。

### 1.4 解决方案

#### 方案：统一数据模型 + 集中序列化层

**Step 1**：为每个 dataclass 添加 `to_dict()` 和 `from_dict()` 类方法

```python
# core/models.py — 以 FieldMapping 为例

@dataclass
class FieldMapping:
    source_schema: str = ""
    source_table: str = ""
    source_column: str = ""
    target_schema: str = ""
    target_table: str = ""
    target_column: str = ""
    transform_logic: str = ""
    procedure: str = ""
    confidence: float = 1.0

    def to_dict(self) -> dict[str, Any]:
        return {
            "source_schema": self.source_schema,
            "source_table": self.source_table,
            "source_column": self.source_column,
            "target_schema": self.target_schema,
            "target_table": self.target_table,
            "target_column": self.target_column,
            "transform_logic": self.transform_logic,
            "procedure": self.procedure,
            "confidence": self.confidence,
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> FieldMapping:
        return cls(
            source_schema=data.get("source_schema", ""),
            source_table=data.get("source_table", ""),
            source_column=data.get("source_column", ""),
            target_schema=data.get("target_schema", ""),
            target_table=data.get("target_table", ""),
            target_column=data.get("target_column", ""),
            transform_logic=data.get("transform_logic", ""),
            procedure=data.get("procedure", ""),
            confidence=data.get("confidence", 1.0),
        )
```

**Step 2**：`ParseResult` 内部改用 dataclass 存储，对外提供统一的序列化接口

```python
# app/services/parser_service.py

class ParseResult:
    def __init__(self):
        self.tables: list[TableInfo] = []           # ← 改为 dataclass
        self.procedures: list[ProcedureInfo] = []    # ← 改为 dataclass
        self.table_lineages: list[TableLineage] = []
        self.field_mappings: list[FieldMapping] = []
        self.caliber_infos: list[CaliberInfo] = []
        self.errors: list[str] = []
        self.parse_time_sec: float = 0.0

    def to_serializable(self) -> dict[str, Any]:
        return {
            "metadata": self._build_metadata(),
            "tables": [t.to_dict() for t in self.tables],
            "procedures": [p.to_dict() for p in self.procedures],
            "table_lineages": [tl.to_dict() for tl in self.table_lineages],
            "field_mappings": [fm.to_dict() for fm in self.field_mappings],
            "caliber_infos": [ci.to_dict() for ci in self.caliber_infos],
        }

    @classmethod
    def from_serializable(cls, data: dict[str, Any]) -> ParseResult:
        result = cls()
        result.tables = [TableInfo.from_dict(t) for t in data.get("tables", [])]
        result.procedures = [ProcedureInfo.from_dict(p) for p in data.get("procedures", [])]
        result.table_lineages = [TableLineage.from_dict(tl) for tl in data.get("table_lineages", [])]
        result.field_mappings = [FieldMapping.from_dict(fm) for fm in data.get("field_mappings", [])]
        result.caliber_infos = [CaliberInfo.from_dict(ci) for ci in data.get("caliber_infos", [])]
        return result
```

**Step 3**：消除 `ParserService` 中的手工序列化代码

```python
# 修改前（parser_service.py:718-729）
def _parse_tab_directory(self, directory: Path, result: ParseResult) -> None:
    for file_path in directory.rglob("*.tab"):
        table_info = self._table_parser.parse_tab_file(str(file_path))
        if table_info:
            table_dict = {
                "full_name": table_info.full_name,
                "schema": table_info.schema,
                # ... 手工逐字段转换 ...
            }
            result.tables.append(table_dict)

# 修改后
def _parse_tab_directory(self, directory: Path, result: ParseResult) -> None:
    for file_path in directory.rglob("*.tab"):
        table_info = self._table_parser.parse_tab_file(str(file_path))
        if table_info:
            result.tables.append(table_info)   # 直接存 dataclass
```

**Step 4**：消除 `get_lineage_tracer()` 和 `_build_tracer()` 中的反序列化代码

```python
# 修改前（parser_service.py:593-700）— 约 108 行反序列化代码
# 修改后
def get_lineage_tracer(self) -> Optional[LineageTracer]:
    if self._lineage_tracer is not None:
        return self._lineage_tracer

    if self._current_result is None:
        return None

    result = self._current_result
    self._lineage_tracer = LineageTracer(
        tables={t.full_name: t for t in result.tables},
        procedures={p.full_name: p for p in result.procedures},
        table_lineages=result.table_lineages,
        field_mappings=result.field_mappings,
    )
    return self._lineage_tracer
```

### 1.5 迁移策略

由于 `ParseResult` 的 dict 格式被 API 层、前端、缓存文件广泛消费，建议分阶段迁移：

| 阶段 | 内容 | 风险 |
|------|------|------|
| 阶段 1 | 为所有 dataclass 添加 `to_dict()` / `from_dict()` | 低 — 纯新增，不修改现有代码 |
| 阶段 2 | `ParseResult` 内部改为 dataclass，`to_serializable()` 保持输出格式兼容 | 中 — 需确保 JSON 缓存格式不变 |
| 阶段 3 | 消除 `ParserService` 中的手工序列化代码 | 中 — 需要回归测试 |
| 阶段 4 | 消除 `get_lineage_tracer()` / `_build_tracer()` 中的反序列化代码 | 低 — 行为等价替换 |

---

## 问题二：ParserService God Class

### 2.1 问题描述

`ParserService` 承担了 7 项不相关的职责，总计约 920 行代码。

### 2.2 职责清单与代码行数

| 职责 | 方法 | 行数 | 依赖 |
|------|------|------|------|
| 解析器初始化与注册 | `initialize_parsers()` | ~40 | OracleTableParser, ParserRegistry |
| 缓存加载 | `load_from_cache()`, `_populate_result_from_data()` | ~70 | pickle, json |
| 文件解析（全量） | `parse_existing_data()`, `_parse_tab_directory()`, `_parse_proc_directory()` | ~80 | OracleTableParser, EnhancedProcedureParser |
| 文件解析（上传） | `parse_uploaded_files()`, `_parse_single_tab()`, `_parse_single_prc()` | ~80 | 同上 |
| 数据查询 | `get_current_data()`, `get_table_list()`, `search_tables()`, `get_procedure_list()` | ~40 | DataRepository |
| LineageTracer 构建 | `get_lineage_tracer()` | ~110 | LineageTracer, dataclass 重建 |
| 缓存持久化 | `_save_result_to_cache()`, `_save_pickle_cache()` | ~40 | json, pickle |

### 2.3 根因分析

`ParserService` 最初只是一个简单的"解析编排器"，但随着功能迭代（缓存、增量解析、上传、Tracer 构建），新功能被不断追加到同一个类中，而没有进行职责拆分。

**依赖关系图**：

```
ParserService
  ├── OracleTableParser (解析器)
  ├── EnhancedProcedureParser (解析器)
  ├── ParserRegistry (解析器路由)
  ├── DataRepository (数据仓库)
  ├── LineageTracer (血缘引擎)
  ├── CaliberExtractor (口径提取)
  └── pickle/json (缓存)
```

7 个不同方向的依赖，违反了单一职责原则。

### 2.4 解决方案

#### 拆分为 4 个专职类

```
ParseOrchestrator        ← 编排解析流程
CacheStore               ← 缓存读写
DataSerializer           ← dataclass ↔ dict 转换（问题一解决后可简化）
LineageTracerFactory     ← 构建 Tracer 实例
```

**类 1：CacheStore — 缓存读写**

```python
# app/services/cache_store.py

CACHE_SCHEMA_VERSION = "v3"

class CacheStore:
    """解析结果缓存管理器"""

    def __init__(self, output_dir: Path):
        self._output_dir = output_dir
        self._pkl_path = output_dir / "lineage_data.pkl"
        self._json_path = output_dir / "lineage_data.json"

    def load(self) -> Optional[dict[str, Any]]:
        if self._pkl_path.exists():
            data = self._load_pickle()
            if data and self._validate_schema(data):
                return data
            self._pkl_path.unlink(missing_ok=True)

        if self._json_path.exists():
            data = self._load_json()
            if data and self._validate_schema(data):
                self._save_pickle(data)
                return data

        return None

    def save(self, data: dict[str, Any]) -> None:
        self._save_pickle(data)
        self._save_json(data)

    def _validate_schema(self, data: dict) -> bool:
        metadata = data.get("metadata", {})
        version = metadata.get("cache_schema_version", "")
        if not metadata.get("total_tables"):
            return False
        if version and version != CACHE_SCHEMA_VERSION:
            logger.warning("缓存版本不匹配: 期望=%s, 实际=%s", CACHE_SCHEMA_VERSION, version)
            return False
        return True

    def _load_pickle(self) -> Optional[dict]:
        try:
            with open(self._pkl_path, "rb") as f:
                return pickle.load(f)
        except Exception as e:
            logger.warning("pickle 加载失败: %s", e)
            return None

    def _load_json(self) -> Optional[dict]:
        try:
            with open(self._json_path, "r", encoding="utf-8") as f:
                return json.load(f)
        except Exception as e:
            logger.error("JSON 加载失败: %s", e)
            return None

    def _save_pickle(self, data: dict) -> None:
        try:
            with open(self._pkl_path, "wb") as f:
                pickle.dump(data, f, protocol=pickle.HIGHEST_PROTOCOL)
        except Exception as e:
            logger.warning("pickle 保存失败: %s", e)

    def _save_json(self, data: dict) -> None:
        try:
            with open(self._json_path, "w", encoding="utf-8") as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
        except Exception as e:
            logger.error("JSON 保存失败: %s", e)
```

**类 2：ParseOrchestrator — 解析编排**

```python
# app/services/parse_orchestrator.py

class ParseOrchestrator:
    """解析流程编排器"""

    def __init__(
        self,
        cache_store: CacheStore,
        registry: Optional[ParserRegistry] = None,
    ):
        self._cache = cache_store
        self._registry = registry
        self._table_parser: Optional[OracleTableParser] = None
        self._proc_parser: Optional[EnhancedProcedureParser] = None

    def parse_existing_data(self, force: bool = False) -> ParseResult:
        if not force:
            cached = self._cache.load()
            if cached:
                return ParseResult.from_serializable(cached)

        result = self._do_parse()
        self._cache.save(result.to_serializable())
        return result

    def parse_uploaded_files(
        self,
        file_paths: list[Path],
        mode: str = "incremental",
        current_result: Optional[ParseResult] = None,
        progress_callback=None,
    ) -> ParseResult:
        result = self._parse_files(file_paths, progress_callback)

        if mode == "incremental" and current_result:
            current_result.merge(result)
            self._cache.save(current_result.to_serializable())
            return current_result

        self._cache.save(result.to_serializable())
        return result
```

**类 3：LineageTracerFactory — Tracer 构建**

```python
# app/services/tracer_factory.py

class LineageTracerFactory:
    """LineageTracer / CaliberTracer 工厂"""

    @staticmethod
    def build_lineage_tracer(result: ParseResult) -> Optional[LineageTracer]:
        tables = {t.full_name: t for t in result.tables}
        procedures = {p.full_name: p for p in result.procedures}
        return LineageTracer(
            tables=tables,
            procedures=procedures,
            table_lineages=result.table_lineages,
            field_mappings=result.field_mappings,
        )

    @staticmethod
    def build_caliber_tracer(result: ParseResult) -> Optional[CaliberTracer]:
        tables = {t.full_name: t for t in result.tables}
        procedures = {p.full_name: p for p in result.procedures}
        return CaliberTracer(
            tables=tables,
            procedures=procedures,
            table_lineages=result.table_lineages,
            field_mappings=result.field_mappings,
            caliber_infos=[ci.to_dict() for ci in result.caliber_infos],
        )
```

**重构后的 ParserService**：

```python
class ParserService:
    """数据库对象解析服务（重构后 — 仅保留对外接口和编排逻辑）"""

    def __init__(self, data_dir: str, schema_dirs: list[str], output_dir: str):
        self._cache = CacheStore(Path(output_dir))
        self._orchestrator = ParseOrchestrator(self._cache)
        self._tracer_factory = LineageTracerFactory()
        self._current_result: Optional[ParseResult] = None
        self._lineage_tracer: Optional[LineageTracer] = None
        self._repository: Optional[DataRepository] = None

    def parse_existing_data(self, force: bool = False) -> ParseResult:
        self._current_result = self._orchestrator.parse_existing_data(force)
        self._invalidate_tracer()
        return self._current_result

    def get_lineage_tracer(self) -> Optional[LineageTracer]:
        if self._lineage_tracer is not None:
            return self._lineage_tracer
        if self._current_result is None:
            return None
        self._lineage_tracer = self._tracer_factory.build_lineage_tracer(self._current_result)
        return self._lineage_tracer
```

### 2.5 收益

| 指标 | 重构前 | 重构后 |
|------|--------|--------|
| ParserService 行数 | ~920 | ~150 |
| 类数量 | 1 | 4 |
| 最大方法行数 | ~110 | ~40 |
| 可独立测试的单元 | 1 | 4 |

---

## 问题三：LineageService.query_lineage 超长方法

### 3.1 问题描述

`LineageService.query_lineage()` 方法约 250 行，包含 8 种不同逻辑。

### 3.2 逻辑拆解

```
query_lineage()
├── 1. 缓存刷新检测 (_check_and_refresh_cache)          ~5 行
├── 2. 缓存查询                                         ~10 行
├── 3. 数据获取与表名解析                                ~20 行
├── 4. schema 严格校验                                  ~15 行
├── 5. 字段级血缘追溯（上游）                            ~30 行
│   ├── 5a. LineageTracer 追溯
│   └── 5b. 旧版回退逻辑
├── 6. 字段级血缘追溯（下游）                            ~30 行
│   ├── 6a. LineageTracer 追溯
│   └── 6b. 旧版回退逻辑
├── 7. 表级血缘补充（节点过少时）                        ~30 行
├── 8. 字段映射过滤与补充                                ~20 行
├── 9. 纯表级查询                                       ~15 行
├── 10. 节点构建、去重、结果组装                         ~30 行
└── 11. 缓存写入                                       ~5 行
```

### 3.3 根因分析

方法最初只处理表级查询，后来追加了字段级查询、旧版回退、表级补充等逻辑，每次都是"在原有 if-else 中追加分支"，没有重构。

### 3.4 解决方案

#### 拆分为策略模式 + 子方法

```python
class LineageService:
    def query_lineage(
        self,
        table: str,
        field: Optional[str] = None,
        depth: int = 3,
        mode: str = "both",
        include_fields: bool = True,
        limit: int = 1000,
        use_cache: bool = True,
    ) -> dict[str, Any]:
        start_time = time.perf_counter()
        self._check_and_refresh_cache()

        cached = self._try_cache(table, field, depth, mode, use_cache, start_time)
        if cached:
            return cached

        data = self.parser.get_current_data()
        if not data:
            return self._empty_result(start_time)

        resolved_table = self._resolve_and_validate(table, data)
        if resolved_table is None:
            return self._empty_result(start_time)

        if field:
            result = self._query_field_lineage(resolved_table, field, depth, mode, data, include_fields, limit)
        else:
            result = self._query_table_lineage(resolved_table, depth, mode, data, include_fields, field, limit)

        result["query_time_ms"] = round((time.perf_counter() - start_time) * 1000, 2)
        self._maybe_cache(table, field, depth, mode, use_cache, result)
        return result

    def _query_field_lineage(
        self, table: str, field: str, depth: int,
        mode: str, data: dict, include_fields: bool, limit: int,
    ) -> dict[str, Any]:
        all_nodes, all_edges, all_mappings = set(), [], []

        tracer = self.parser.get_lineage_tracer()
        if tracer:
            self._trace_field_with_tracer(tracer, table, field, depth, mode, all_nodes, all_edges, all_mappings)
        else:
            self._trace_field_legacy(table, field, depth, mode, data, all_nodes, all_edges, all_mappings)

        if len(all_nodes) < 3:
            self._supplement_table_lineage(table, mode, data, all_nodes, all_edges)

        if include_fields:
            self._supplement_field_mappings(data, all_nodes, all_mappings, table, field)

        return self._assemble_result(all_nodes, all_edges, all_mappings, table, field, limit)

    def _query_table_lineage(
        self, table: str, depth: int,
        mode: str, data: dict, include_fields: bool,
        field: Optional[str], limit: int,
    ) -> dict[str, Any]:
        all_nodes, all_edges = set(), []

        if mode in ("upstream", "both"):
            up_nodes, up_edges = self._table_tracer.trace(table, data, depth, direction="up")
            all_nodes.update(up_nodes)
            all_edges.extend(up_edges)

        if mode in ("downstream", "both"):
            down_nodes, down_edges = self._table_tracer.trace(table, data, depth, direction="down")
            all_nodes.update(down_nodes)
            all_edges.extend(down_edges)

        all_mappings = []
        if field and include_fields:
            all_mappings = self._filter_field_mappings(
                data.get("field_mappings", []), all_nodes, table, field
            )

        return self._assemble_result(all_nodes, all_edges, all_mappings, table, field, limit)
```

### 3.5 收益

| 指标 | 重构前 | 重构后 |
|------|--------|--------|
| `query_lineage` 行数 | ~250 | ~25 |
| 最大子方法行数 | N/A | ~40 |
| 可独立测试的方法数 | 1 | 6+ |
| 字段级/表级逻辑耦合度 | 高 | 隔离 |

---

## 问题四：CaliberInfo 字段膨胀

### 4.1 问题描述

`CaliberInfo` 有 32 个字段，通过"批次A/B/C"不断追加，违反单一职责原则。

### 4.2 当前字段清单

```python
@dataclass
class CaliberInfo:
    # 核心字段（约 15 个）
    target_table: str = ""
    target_column: str = ""
    source_table: str = ""
    source_column: str = ""
    transform_logic: str = ""
    where_conditions: list[SQLCondition] = field(default_factory=list)
    join_conditions: list[SQLCondition] = field(default_factory=list)
    group_by_clause: str = ""
    having_clause: str = ""
    procedure: str = ""
    step_num: int = 0
    step_desc: str = ""
    data_source: str = "oracle"
    raw_sql_fragment: str = ""
    confidence: float = 1.0

    # SQL 增强字段（约 7 个）
    operation_type: str = ""
    select_columns: list[SelectColumnMapping] = field(default_factory=list)
    distinct_flag: bool = False
    order_by_clause: str = ""
    set_operation: str = ""
    subqueries: list[SubqueryInfo] = field(default_factory=list)
    window_functions: list[str] = field(default_factory=list)

    # 层级字段（2 个）
    source_table_layer: str = ""
    target_table_layer: str = ""

    # 累积条件字段（4 个）
    sql_operation_sequence: int = 0
    accumulated_where: list[SQLCondition] = field(default_factory=list)
    accumulated_join: list[SQLCondition] = field(default_factory=list)
    caliber_spec: str = ""

    # 批次A：行号定位（3 个）
    file_path: str = ""
    start_line: int = 0
    end_line: int = 0

    # 批次B：步骤级隔离条件（2 个）
    step_isolated_where: list[SQLCondition] = field(default_factory=list)
    step_isolated_join: list[SQLCondition] = field(default_factory=list)

    # 批次C：CTE/函数/表达式（4 个）
    cte_definitions: list[str] = field(default_factory=list)
    custom_functions: list[str] = field(default_factory=list)
    full_expression: str = ""
    is_custom_function_call: bool = False
```

### 4.3 根因分析

每次需求迭代（行号定位、步骤级隔离、CTE 解析）都在 `CaliberInfo` 上追加字段，而非提取子结构。这导致：

1. **序列化代码膨胀**：`CaliberExtractor.to_dict()` 需要处理 32 个字段
2. **构造困难**：创建 `CaliberInfo` 时需要传入大量默认值参数
3. **理解困难**：无法快速区分"核心口径信息"和"辅助定位信息"

### 4.4 解决方案

#### 使用组合模式拆分为 5 个子结构

```python
@dataclass
class SourceLocation:
    file_path: str = ""
    start_line: int = 0
    end_line: int = 0


@dataclass
class StepIsolation:
    isolated_where: list[SQLCondition] = field(default_factory=list)
    isolated_join: list[SQLCondition] = field(default_factory=list)


@dataclass
class ExpressionDetail:
    cte_definitions: list[str] = field(default_factory=list)
    custom_functions: list[str] = field(default_factory=list)
    full_expression: str = ""
    is_custom_function_call: bool = False


@dataclass
class SQLEnhancement:
    operation_type: str = ""
    select_columns: list[SelectColumnMapping] = field(default_factory=list)
    distinct_flag: bool = False
    order_by_clause: str = ""
    set_operation: str = ""
    subqueries: list[SubqueryInfo] = field(default_factory=list)
    window_functions: list[str] = field(default_factory=list)


@dataclass
class CaliberInfo:
    target_table: str = ""
    target_column: str = ""
    source_table: str = ""
    source_column: str = ""
    transform_logic: str = ""
    where_conditions: list[SQLCondition] = field(default_factory=list)
    join_conditions: list[SQLCondition] = field(default_factory=list)
    group_by_clause: str = ""
    having_clause: str = ""
    procedure: str = ""
    step_num: int = 0
    step_desc: str = ""
    data_source: str = "oracle"
    raw_sql_fragment: str = ""
    confidence: float = 1.0
    source_table_layer: str = ""
    target_table_layer: str = ""
    sql_operation_sequence: int = 0
    accumulated_where: list[SQLCondition] = field(default_factory=list)
    accumulated_join: list[SQLCondition] = field(default_factory=list)
    caliber_spec: str = ""

    source_location: SourceLocation = field(default_factory=SourceLocation)
    step_isolation: StepIsolation = field(default_factory=StepIsolation)
    expression_detail: ExpressionDetail = field(default_factory=ExpressionDetail)
    sql_enhancement: SQLEnhancement = field(default_factory=SQLEnhancement)
```

**向后兼容的 `to_dict()`**：

```python
def to_dict(self) -> dict[str, Any]:
    d = {
        "target_table": self.target_table,
        # ... 核心字段 ...
    }
    # 扁平化子结构，保持 JSON 格式兼容
    d.update(dataclasses.asdict(self.source_location))
    d.update({
        "step_isolated_where": [c.__dict__ for c in self.step_isolation.isolated_where],
        "step_isolated_join": [c.__dict__ for c in self.step_isolation.isolated_join],
    })
    d.update(dataclasses.asdict(self.expression_detail))
    d.update(dataclasses.asdict(self.sql_enhancement))
    return d
```

### 4.5 收益

| 指标 | 重构前 | 重构后 |
|------|--------|--------|
| CaliberInfo 直接字段数 | 32 | 22（核心） + 4（组合） |
| 新增字段时的修改范围 | CaliberInfo + to_dict + from_dict + 所有消费者 | 仅子结构 + to_dict |
| 构造时需关心的参数 | 32 | 核心参数 + 按需设置子结构 |

---

## 问题五：LineageTracer 与 CaliberTracer 代码重复

### 5.1 问题描述

两个 Tracer 共享大量 BFS 遍历基础设施代码，但各自独立实现。

### 5.2 重复代码对照

| 功能 | LineageTracer | CaliberTracer | 差异 |
|------|---------------|---------------|------|
| 表名归一化 | `_normalize_table_name()` (L260) | `_normalize_name()` (L275) | 几乎相同 |
| 裸表名提取 | `_bare_table()` (L268) | `_make_key()` 静态方法 | 相同逻辑 |
| 循环依赖检测 | `_is_cycle()` (L310) | 内联在 `_trace_upstream()` 中 | 实现略有差异 |
| 层级兼容性过滤 | `_is_layer_compatible()` (L350) | 内联在 BFS 中 | 逻辑相同 |
| TMP 表桥接 | `_try_tmp_bridge()` (L400) | `_try_tmp_bridge()` (L500) | 实现相似 |
| 模糊匹配 | `_fuzzy_match_table()` (L450) | `_fuzzy_match_table()` (L550) | 相同 |
| BFS 遍历框架 | `_bfs_trace_upstream()` | `_trace_upstream()` | 结构相同，回调不同 |
| 索引构建 | `_build_index()` | `_build_indexes()` | 字段名不同，结构相同 |

### 5.3 根因分析

`CaliberTracer` 是在 `LineageTracer` 基础上"复制+修改"而来。两者的 BFS 框架、表名处理、层级过滤逻辑完全相同，差异仅在于：

- **LineageTracer** 关注"数据从哪来"（字段流向）
- **CaliberTracer** 关注"数据怎么加工"（WHERE/JOIN/GROUP BY 条件）

### 5.4 解决方案

#### 提取 BaseTracer 公共基类

```python
# core/base_tracer.py

class BaseTracer:
    """BFS 追溯引擎公共基类"""

    def __init__(
        self,
        tables: dict[str, TableInfo],
        procedures: dict[str, ProcedureInfo],
        table_lineages: list[TableLineage],
        field_mappings: list[FieldMapping],
        max_depth: int = 10,
    ) -> None:
        self.tables = tables
        self.procedures = procedures
        self.table_lineages = table_lineages
        self.field_mappings = field_mappings
        self.max_depth = max_depth
        self._resolver = TableNameResolver()

        self._proc_target_idx: dict[str, list[ProcedureInfo]] = {}
        self._table_proc_idx: dict[str, list[ProcedureInfo]] = {}
        self._fm_target_idx: dict[str, dict[str, list[FieldMapping]]] = {}
        self._fm_source_idx: dict[str, dict[str, list[FieldMapping]]] = {}
        self._tl_target_idx: dict[str, list[TableLineage]] = {}
        self._tl_source_idx: dict[str, list[TableLineage]] = {}

        self._build_common_indexes()

    def _build_common_indexes(self) -> None:
        for proc in self.procedures.values():
            for tl in proc.table_lineages:
                tgt = tl.target_table.upper().split(".")[-1]
                self._proc_target_idx.setdefault(tgt, []).append(proc)
            for fm in proc.field_mappings:
                tgt_tbl = fm.target_table.upper().split(".")[-1]
                tgt_col = fm.target_column.upper()
                self._fm_target_idx.setdefault(tgt_tbl, {}).setdefault(tgt_col, []).append(fm)
                src_tbl = fm.source_table.upper().split(".")[-1]
                src_col = fm.source_column.upper()
                self._fm_source_idx.setdefault(src_tbl, {}).setdefault(src_col, []).append(fm)
            for t in set(proc.source_tables):
                short_t = t.upper().split(".")[-1]
                self._table_proc_idx.setdefault(short_t, []).append(proc)

        for tl in self.table_lineages:
            tgt_short = tl.target_table.upper().split(".")[-1]
            src_short = tl.source_table.upper().split(".")[-1]
            self._tl_target_idx.setdefault(tgt_short, []).append(tl)
            self._tl_source_idx.setdefault(src_short, []).append(tl)

    @staticmethod
    def normalize_name(name: str) -> str:
        return TableNameResolver.bare_table(name.strip().upper())

    @staticmethod
    def bare_table(table_name: str) -> str:
        return TableNameResolver.bare_table(table_name)

    @staticmethod
    def make_key(table: str, column: str) -> tuple[str, str]:
        short = table.split(".")[-1] if "." in table else table
        return (short.upper(), column.upper())

    def is_layer_compatible(self, source_layer: str, target_layer: str) -> bool:
        if source_layer == target_layer:
            return True
        order_map = {lt.value: i for i, lt in enumerate(LayerType)}
        src_order = order_map.get(source_layer, 99)
        tgt_order = order_map.get(target_layer, 99)
        return src_order <= tgt_order

    def is_cycle(self, table: str, visited: set[str]) -> bool:
        bare = self.bare_table(table)
        return bare in visited

    def try_tmp_bridge(self, table: str, field: str, visited: set) -> Optional[Any]:
        bare = self.bare_table(table)
        if not TableNameResolver.is_temp_table(bare):
            return None
        tmp_procs = self._proc_target_idx.get(bare, [])
        for proc in tmp_procs:
            for fm in proc.field_mappings:
                if fm.target_column.upper() == field.upper():
                    if self.bare_table(fm.source_table) not in visited:
                        return fm
        return None

    def fuzzy_match_table(self, query: str, candidates: list[str]) -> Optional[str]:
        for candidate in candidates:
            if self._resolver.match(query, candidate):
                return candidate
        return None
```

**LineageTracer 继承 BaseTracer**：

```python
class LineageTracer(BaseTracer):
    def __init__(self, tables, procedures, table_lineages, field_mappings, max_depth=10):
        super().__init__(tables, procedures, table_lineages, field_mappings, max_depth)
        self._build_lineage_specific_indexes()

    def _build_lineage_specific_indexes(self):
        pass  # LineageTracer 特有的索引

    def trace_field_upstream(self, table, field, max_depth=None):
        # 使用 self.normalize_name(), self.is_layer_compatible() 等继承方法
        ...
```

**CaliberTracer 继承 BaseTracer**：

```python
class CaliberTracer(BaseTracer):
    def __init__(self, tables, procedures, table_lineages, field_mappings,
                 caliber_infos, max_depth=10):
        super().__init__(tables, procedures, table_lineages, field_mappings, max_depth)
        self.caliber_infos_raw = caliber_infos
        self._target_idx: dict[tuple[str, str], list[dict]] = {}
        self._source_idx: dict[tuple[str, str], list[dict]] = {}
        self._build_caliber_indexes()

    def _build_caliber_indexes(self):
        for ci_dict in self.caliber_infos_raw:
            target_table = ci_dict.get("target_table", "").upper()
            target_column = ci_dict.get("target_column", "").upper()
            source_table = ci_dict.get("source_table", "").upper()
            source_column = ci_dict.get("source_column", "").upper()
            if not (target_table and target_column):
                continue
            tgt_key = self.make_key(target_table, target_column)
            self._target_idx.setdefault(tgt_key, []).append(ci_dict)
            if source_table and source_column:
                src_key = self.make_key(source_table, source_column)
                self._source_idx.setdefault(src_key, []).append(ci_dict)
```

### 5.5 收益

| 指标 | 重构前 | 重构后 |
|------|--------|--------|
| 重复代码行数 | ~400 行 | 0 |
| 修改表名归一化逻辑时 | 改 2 处 | 改 1 处 |
| 行为一致性 | 不保证 | 基类保证 |

---

## 问题六：缓存策略一致性问题

### 6.1 问题描述

三个独立的缓存/数据持有者之间缺乏一致性保证。

### 6.2 三个数据源

```
ParserService._current_result (ParseResult, 内存)
     ↕ 手工同步
DataRepository (内存 + JSON 文件)
     ↕ 文件 mtime 检测
LineageService._last_data_mtime (float, 文件修改时间)
```

### 6.3 具体问题

**问题 1：pickle 缓存无版本校验**

```python
# parser_service.py:232-233
metadata = data.get("metadata", {})
if not metadata or not metadata.get("total_tables"):
    # 只检查 total_tables 是否非零，不校验数据结构版本
```

如果 `CaliberInfo` 新增了字段（如批次C的 `cte_definitions`），旧 pickle 中没有该字段，反序列化后 `CaliberInfo.cte_definitions` 为默认值（空列表），而非报错提示用户重新解析。

**问题 2：DataRepository 与 ParseResult 双写**

```python
# parser_service.py:299-305
def _populate_result_from_data(self, data: dict) -> ParseResult:
    result = ParseResult()
    result.tables = data.get("tables", [])
    # ... 填充 result ...
    self._current_result = result

    # 同时更新 DataRepository
    self._repository = DataRepository(json_file)
    self._repository.update(data)
```

`_current_result` 和 `_repository` 持有相同数据的不同表示。`parse_uploaded_files()` 更新 `_current_result` 后调用 `_save_result_to_cache()`，后者会更新 `_repository`。但如果中间发生异常，两者可能不一致。

**问题 3：LineageService 的 mtime 检测不可靠**

```python
# lineage_service.py
def _check_and_refresh_cache(self) -> None:
    json_file = self.parser.output_dir / "lineage_data.json"
    if not json_file.exists():
        return
    mtime = json_file.stat().st_mtime
    if mtime > self._last_data_mtime:
        self._last_data_mtime = mtime
        self._build_indexes()
        self._transitive_cache.clear()
```

问题：`ParserService.parse_uploaded_files()` 在内存中更新了 `_current_result`，但只有在调用 `_save_result_to_cache()` 后才会更新 JSON 文件的 mtime。如果 `_save_result_to_cache()` 失败或延迟，`LineageService` 的缓存将过期。

### 6.4 解决方案

#### 方案：事件驱动的缓存失效 + 版本校验

**Step 1：添加缓存版本号**

```python
CACHE_SCHEMA_VERSION = "v4"

# _save_result_to_cache 中写入版本号
data = {
    "metadata": {
        "cache_schema_version": CACHE_SCHEMA_VERSION,
        "total_tables": len(result.tables),
        # ...
    },
    # ...
}

# load_from_cache 中校验版本号
def _validate_schema(self, data: dict) -> bool:
    metadata = data.get("metadata", {})
    version = metadata.get("cache_schema_version", "")
    if version != CACHE_SCHEMA_VERSION:
        logger.warning("缓存版本不匹配: 期望=%s, 实际=%s, 将重新解析", CACHE_SCHEMA_VERSION, version)
        return False
    return bool(metadata.get("total_tables"))
```

**Step 2：使用回调替代 mtime 检测**

```python
# parser_service.py
class ParserService:
    def __init__(self, ...):
        self._on_data_changed_callbacks: list[Callable] = []

    def register_data_changed_callback(self, callback: Callable) -> None:
        self._on_data_changed_callbacks.append(callback)

    def _notify_data_changed(self) -> None:
        for callback in self._on_data_changed_callbacks:
            try:
                callback()
            except Exception as e:
                logger.warning("数据变更回调异常: %s", e)

    def parse_uploaded_files(self, ...):
        # ... 解析逻辑 ...
        self._notify_data_changed()  # 替代依赖文件 mtime

# lineage_service.py
class LineageService:
    def __init__(self, parser_service, cache_manager):
        self.parser = parser_service
        self.cache = cache_manager
        parser_service.register_data_changed_callback(self._on_data_changed)

    def _on_data_changed(self) -> None:
        self._build_indexes()
        self._transitive_cache.clear()
```

**Step 3：统一数据持有者**

消除 `_current_result` 和 `_repository` 的双数据源问题：

```python
class ParserService:
    def __init__(self, ...):
        self._current_result: Optional[ParseResult] = None
        # 移除 self._repository，所有数据访问通过 _current_result

    def get_current_data(self) -> Optional[dict[str, Any]]:
        if self._current_result is not None:
            return self._current_result.to_serializable()
        return None
```

---

## 问题七：API 响应格式不统一

### 7.1 问题描述

不同 API 端点返回格式不一致。

### 7.2 具体差异

| 端点 | 返回类型 | 成功格式 | 失败格式 |
|------|----------|----------|----------|
| `/api/lineage/query` | `dict` | `{"nodes": [...], "edges": [...]}` | `{"nodes": [], "edges": []}` |
| `/api/caliber/query` | `dict` | `{"success": True, "data": {...}}` | `{"success": False, "message": "..."}` |
| `/api/indicator/query` | `dict` | `{"nodes": [...], "edges": [...]}` | `{"nodes": [], "edges": []}` |
| `/api/parse/upload` | `dict` | `{"success": True, "stats": {...}}` | `{"success": False, "error": "..."}` |
| `/api/system/tables/search` | `list[dict]` | `[...]` | `[]` |

### 7.3 解决方案

#### 定义统一响应模型

```python
# app/models/response.py

from typing import Any, Generic, Optional, TypeVar
from pydantic import BaseModel

T = TypeVar("T")

class ApiResponse(BaseModel, Generic[T]):
    success: bool
    data: Optional[T] = None
    message: str = ""
    query_time_ms: float = 0.0

class LineageData(BaseModel):
    nodes: list[dict[str, Any]] = []
    edges: list[dict[str, Any]] = []
    field_mappings: list[dict[str, Any]] = []
    nodes_count: int = 0
    edges_count: int = 0
    has_more: bool = False
    query_target: Optional[dict[str, str]] = None

class CaliberData(BaseModel):
    target_table: str = ""
    target_column: str = ""
    chains: list[dict[str, Any]] = []
    total_steps: int = 0
    total_conditions: int = 0

class ParseStats(BaseModel):
    tables_parsed: int = 0
    procedures_parsed: int = 0
    lineages_found: int = 0
    errors: list[str] = []
```

**API 路由使用统一模型**：

```python
# app/api/lineage.py

@router.post("/query", response_model=ApiResponse[LineageData])
async def query_lineage(request: LineageQueryRequest, ...):
    result = lineage_service.query_lineage(...)
    return ApiResponse(
        success=True,
        data=LineageData(**result),
        query_time_ms=result.get("query_time_ms", 0),
    )
```

---

## 问题八：性能风险

### 8.1 BFS 结果爆炸

**问题**：`LineageTracer` 的 BFS 没有节点数上限。在菱形依赖图（多个路径汇聚到同一节点）中，链路数可能指数级增长。

**解决方案**：添加 `max_nodes` 参数

```python
class LineageTracer(BaseTracer):
    def __init__(self, ..., max_depth: int = 10, max_nodes: int = 5000):
        super().__init__(...)
        self.max_nodes = max_nodes

    def _bfs_trace_upstream(self, ...):
        visited = set()
        queue = deque([start_node])
        node_count = 0

        while queue and node_count < self.max_nodes:
            current = queue.popleft()
            node_count += 1
            # ... BFS 逻辑 ...

        if node_count >= self.max_nodes:
            logger.warning("BFS 达到节点上限 (%d)，可能存在未探索的链路", self.max_nodes)
```

### 8.2 同步阻塞

**问题**：所有 API 使用 `def` 而非 `async def`，BFS 追溯在主线程执行。

**解决方案**：将重查询放入线程池

```python
# app/api/lineage.py

@router.post("/query")
async def query_lineage(request: LineageQueryRequest, ...):
    loop = asyncio.get_event_loop()
    result = await loop.run_in_executor(
        None,  # 默认线程池
        lineage_service.query_lineage,
        request.table, request.field, request.depth, request.mode,
    )
    return result
```

### 8.3 全量内存加载

**问题**：所有数据（表/过程/血缘/映射/口径）全部加载到内存。

**当前内存估算**（基于典型数据量）：

| 数据类型 | 数量 | 单条大小 | 总内存 |
|----------|------|----------|--------|
| tables | ~500 | ~2KB | ~1MB |
| procedures | ~200 | ~10KB | ~2MB |
| field_mappings | ~50,000 | ~200B | ~10MB |
| caliber_infos | ~100,000 | ~500B | ~50MB |
| 索引 | — | — | ~20MB |
| **合计** | | | **~83MB** |

当前规模下内存不是问题。但如果数据量增长 10 倍（5,000 表、1,000,000 口径信息），内存将达到 ~800MB，需要考虑分页或 SQLite。

**建议**：暂不优化，但添加内存监控：

```python
import psutil

def log_memory_usage():
    process = psutil.Process()
    mem_mb = process.memory_info().rss / 1024 / 1024
    logger.info("当前内存使用: %.1f MB", mem_mb)
    if mem_mb > 500:
        logger.warning("内存使用超过 500MB，建议考虑数据分页")
```

---

## 问题九：测试覆盖不足

### 9.1 问题描述

| 测试类型 | 现状 |
|----------|------|
| 核心引擎单元测试 | 几乎没有 |
| API 集成测试 | 少量 |
| 临时测试文件 | 根目录有 6+ 个 |

### 9.2 解决方案

#### 优先为核心引擎添加单元测试

```python
# tests/test_lineage_tracer.py

import pytest
from core.lineage_tracer import LineageTracer
from core.models import TableInfo, ProcedureInfo, FieldMapping, TableLineage

@pytest.fixture
def sample_tracer():
    tables = {
        "RRP_MDL.M_DEP_RCPT_INFO": TableInfo(
            schema="RRP_MDL", table_name="M_DEP_RCPT_INFO",
            full_name="RRP_MDL.M_DEP_RCPT_INFO",
        ),
        "RRP_EAST.EAST5_201_GRJCXXB": TableInfo(
            schema="RRP_EAST", table_name="EAST5_201_GRJCXXB",
            full_name="RRP_EAST.EAST5_201_GRJCXXB",
        ),
    }
    procedures = {
        "SP_LOAD_EAST5": ProcedureInfo(
            full_name="SP_LOAD_EAST5",
            source_tables=["RRP_MDL.M_DEP_RCPT_INFO"],
            target_tables=["RRP_EAST.EAST5_201_GRJCXXB"],
            field_mappings=[
                FieldMapping(
                    source_table="RRP_MDL.M_DEP_RCPT_INFO",
                    source_column="ACCT_BAL",
                    target_table="RRP_EAST.EAST5_201_GRJCXXB",
                    target_column="ACCT_BAL",
                    procedure="SP_LOAD_EAST5",
                ),
            ],
            table_lineages=[
                TableLineage(
                    source_table="RRP_MDL.M_DEP_RCPT_INFO",
                    target_table="RRP_EAST.EAST5_201_GRJCXXB",
                    procedure="SP_LOAD_EAST5",
                ),
            ],
        ),
    }
    return LineageTracer(
        tables=tables,
        procedures=procedures,
        table_lineages=procedures["SP_LOAD_EAST5"].table_lineages,
        field_mappings=procedures["SP_LOAD_EAST5"].field_mappings,
    )


class TestLineageTracer:
    def test_trace_field_upstream_basic(self, sample_tracer):
        result = sample_tracer.trace_field_upstream("EAST5_201_GRJCXXB", "ACCT_BAL", 3)
        assert len(result.chains) >= 1
        chain = result.chains[0]
        assert chain.target_field == "ACCT_BAL"
        assert any("M_DEP_RCPT_INFO" in n.table_name for n in chain.chain)

    def test_trace_field_upstream_no_result(self, sample_tracer):
        result = sample_tracer.trace_field_upstream("NONEXISTENT_TABLE", "FIELD_X", 3)
        assert len(result.chains) == 0

    def test_cycle_detection(self, sample_tracer):
        # 添加循环依赖
        # ... 构造循环数据 ...
        result = sample_tracer.trace_field_upstream("EAST5_201_GRJCXXB", "ACCT_BAL", 10)
        # 不应无限循环
        assert result is not None
```

#### 清理临时测试文件

```bash
# 将根目录的临时测试文件移动到 tests/ 或删除
mv _test_graph.py tests/test_graph.py
mv _test_parser.py tests/test_parser.py
mv _basic_test.py tests/test_basic.py
rm _full_test.py comprehensive_test.py e2e_verify.py
```

---

## 问题十：安全与代码卫生

### 10.1 CORS 配置过于宽松

```python
# 修改前
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,  # ← 与 allow_origins=["*"] 冲突
    allow_methods=["*"],
    allow_headers=["*"],
)

# 修改后
ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://localhost:8080",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS if os.getenv("PRODUCTION") else ["*"],
    allow_credentials=True,
    allow_methods=["GET", "POST"],
    allow_headers=["Content-Type"],
)
```

### 10.2 废弃代码清理

| 文件 | 状态 | 建议 |
|------|------|------|
| `core/base_sql_parser.py` | 标注 `@deprecated` | 删除 |
| `deprecated/api_server.py` | 已被 `app/main.py` 替代 | 删除整个 `deprecated/` 目录 |
| `_excel_full_output.txt` | 临时输出文件 | 删除 |
| `test_*.py`（根目录） | 临时测试 | 迁移到 `tests/` 或删除 |

### 10.3 魔法字符串

```python
# 修改前 — 散落在各处的硬编码字符串
if direction == "upstream":
if data_source == "oracle":
if operation_type == "INSERT_SELECT":

# 修改后 — 使用枚举
from enum import Enum

class TraceDirection(str, Enum):
    UPSTREAM = "upstream"
    DOWNSTREAM = "downstream"
    BOTH = "both"

class DataSource(str, Enum):
    ORACLE = "oracle"
    WAREHOUSE = "warehouse"

class SQLOperationType(str, Enum):
    INSERT_SELECT = "INSERT_SELECT"
    INSERT_VALUES = "INSERT_VALUES"
    MERGE = "MERGE"
    UPDATE = "UPDATE"
    DELETE = "DELETE"
    CTAS = "CREATE_TABLE_AS_SELECT"
```

---

## 实施路线图

### 阶段 1：基础加固（建议优先实施）

| 任务 | 依赖 | 风险 | 预期效果 |
|------|------|------|----------|
| 为所有 dataclass 添加 `to_dict()` / `from_dict()` | 无 | 低 | 为后续重构打基础 |
| 添加缓存版本号校验 | 无 | 低 | 防止旧缓存导致数据错乱 |
| CORS 安全加固 | 无 | 低 | 安全合规 |
| 清理废弃代码 | 无 | 低 | 减少认知负担 |

### 阶段 2：核心重构

| 任务 | 依赖 | 风险 | 预期效果 |
|------|------|------|----------|
| `ParseResult` 内部改用 dataclass | 阶段 1 | 中 | 消除双轨数据模型 |
| 拆分 `ParserService` | 阶段 1 | 中 | 提高可维护性 |
| 提取 `BaseTracer` 公共基类 | 无 | 中 | 消除 ~400 行重复代码 |
| 拆分 `LineageService.query_lineage` | 无 | 低 | 提高可读性 |

### 阶段 3：质量提升

| 任务 | 依赖 | 风险 | 预期效果 |
|------|------|------|----------|
| `CaliberInfo` 字段组合拆分 | 阶段 1 | 低 | 防止字段膨胀 |
| 统一 API 响应格式 | 无 | 中 | 前端开发体验 |
| BFS 结果限制 + 异步化 | 无 | 低 | 性能与稳定性 |
| 事件驱动缓存失效 | 拆分 ParserService | 中 | 数据一致性 |
| 核心引擎单元测试 | 提取 BaseTracer | 低 | 回归防护 |

### 阶段 4：长期优化

| 任务 | 依赖 | 风险 | 预期效果 |
|------|------|------|----------|
| 魔法字符串枚举化 | 无 | 低 | 代码可读性 |
| 内存监控与告警 | 无 | 低 | 运维可观测性 |
| 增量索引更新 | 阶段 2 | 高 | 大数据量性能 |

---

> 本文档中的代码示例基于 2026-05-20 的代码快照，实际实施时需根据最新代码调整。
