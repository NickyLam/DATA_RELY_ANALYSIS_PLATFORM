# Data Lineage Analysis Platform — Ideal System Design Specification

> **Document Type**: Design Specification (Analysis & Gap Report)
> **Date**: 2026-05-18
> **Scope**: System architecture assessment, ideal design, and gap analysis

---

## 1. Current Architecture Assessment

### 1.1 System Overview

The current system is a Python-based data lineage analysis platform that parses Oracle stored procedures (`.prc`) and table definitions (`.tab`) to construct field-level data lineage relationships. It serves lineage data through an HTTP API and renders directed graphs via D3.js on the frontend.

**Key Statistics**: 3,041 tables, 1,754 stored procedures, ~6-8 minute initialization time.

### 1.2 Current Component Inventory

| Layer | Component | File | Responsibility |
|-------|-----------|------|----------------|
| Parsing | Table Parser | `core/table_parser.py` | `.tab` file → `TableInfo` |
| Parsing | Procedure Parser | `core/procedure_parser.py` | `.prc` file → `ProcedureInfo`, `FieldMapping`, `TableLineage` |
| Parsing | Field Cleaner | `core/field_cleaner.py` | Column name normalization, alias resolution |
| Parsing | Table Name Resolver | `core/table_name_resolver.py` | Schema-qualified table name resolution |
| Parsing | Indicator Config Parser | `core/indicator_config_parser.py` | Excel-based indicator configuration parsing |
| Parsing | Indicator SQL Parser | `core/indicator_sql_parser.py` | Indicator SQL expression parsing |
| Core | Lineage Tracer | `core/lineage_tracer.py` | BFS upstream/downstream field tracing |
| Core | Caliber Extractor | `core/caliber_extractor.py` | WHERE/JOIN/CTE condition extraction |
| Core | Caliber Tracer | `core/caliber_tracer.py` | BFS with condition accumulation (standalone) |
| Core | Indicator Graph Builder | `core/indicator_graph_builder.py` | Indicator dependency graph construction |
| Core | Layer Detector | `core/layer_detector.py` | Table-to-layer classification (ODS/DIIS/BASE/MDL/APP/EAST) |
| Core | SQL Boundary Detector | `core/sql_boundary_detector.py` | DML boundary detection within procedures |
| Core | Data Validator | `core/data_validator.py` | Data quality validation |
| API | HTTP Server | `api_server.py` | REST API + static file serving |
| Frontend | Display Tab | `static/js/display-tab.js` | D3.js graph rendering |
| Frontend | Caliber Tab | `static/js/caliber-tab.js` | Pipeline visualization v3.0 |
| Models | Data Models | `core/models.py` | All shared dataclasses |
| Models | Indicator Models | `core/indicator_models.py` | Indicator-specific dataclasses |

### 1.3 Current Architecture Strengths

1. **Multi-strategy field resolution**: The BFS tracer employs 5 fallback strategies (index lookup → fuzzy match → schema variant merge → TMP bridge → procedure scan) to handle Oracle schema variant complexity (O_ICL_*/ICL.*/ICL.V_*).
2. **Rich caliber extraction**: `CaliberExtractor` extracts WHERE, JOIN, GROUP BY, HAVING, CTE, custom functions, window functions, subqueries, and step-isolated conditions.
3. **Dual tracking mode**: Both upstream and downstream BFS tracing are supported.
4. **Indicator-aware**: Separate indicator models (`IndicatorCalcBase`, `IndicatorCalcGL`) and graph builder for indicator-type field lineage.
5. **Chain deduplication**: Public prefix detection for caliber chain semantic deduplication.

### 1.4 Current Architecture Weaknesses

1. **No persistent storage**: All data held in memory; 6-8 minute cold start required on every restart.
2. **Monolithic coupling**: `api_server.py` contains 1,289 lines mixing routing, business logic, serialization, graph transformation, and caliber chain construction.
3. **Duplicate logic**: `_bare_table()` implemented identically in both `api_server.py` and `lineage_tracer.py`; graph transformation logic (`_result_to_graph`) duplicates `to_graph_result()` in `LineageTracer`.
4. **No separation of detailed vs. indicator fields**: The system treats all fields uniformly through BFS, with no differentiated tracing strategy for basic indicators, general ledger indicators, and detailed fields.
5. **Linear scan fallbacks**: When index misses occur, fuzzy matching iterates all keys (O(N)) — acceptable at current scale but not scalable.
6. **Single-process server**: `http.server.HTTPServer` is single-threaded, blocking; no concurrency support.
7. **No incremental update**: Adding or modifying a single `.prc` requires full re-initialization.

---

## 2. Ideal System Design Specification

### 2.1 Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        Presentation Layer                        │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────────────┐ │
│  │  Graph View   │  │ Pipeline View│  │  Indicator Topology   │ │
│  │  (D3.js/SVG)  │  │  (Pipeline)   │  │  (D3.js/SVG)          │ │
│  └──────────────┘  └──────────────┘  └───────────────────────┘ │
├─────────────────────────────────────────────────────────────────┤
│                         API Gateway                              │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────────┐  │
│  │ Table API │ │Lineage   │ │Caliber   │ │Indicator API     │  │
│  │          │ │API       │ │API       │ │                  │  │
│  └──────────┘ └──────────┘ └──────────┘ └──────────────────┘  │
├─────────────────────────────────────────────────────────────────┤
│                      Service Layer                               │
│  ┌───────────────┐  ┌───────────────┐  ┌──────────────────┐   │
│  │ Detailed Field│  │ Basic Indicator│  │ GL Indicator     │   │
│  │ Tracing Svc   │  │ Tracing Svc    │  │ Tracing Svc      │   │
│  │ (Full BFS)    │  │ (BFS+Conditions)│ │ (Indicator Graph) │   │
│  └───────────────┘  └───────────────┘  └──────────────────┘   │
│  ┌───────────────┐  ┌───────────────┐                          │
│  │ Graph Transform│ │ Caliber Builder│                          │
│  │ Service        │ │ Service        │                          │
│  └───────────────┘  └───────────────┘                          │
├─────────────────────────────────────────────────────────────────┤
│                     Tracing Engine                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐ │
│  │ Schema-aware │  │ Condition-   │  │ Multi-strategy       │ │
│  │ BFS Engine   │  │ Accumulating │  │ Resolution Engine    │ │
│  │              │  │ BFS Engine   │  │                      │ │
│  └──────────────┘  └──────────────┘  └──────────────────────┘ │
├─────────────────────────────────────────────────────────────────┤
│                     Storage Layer                                │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │
│  │ Graph DB │  │ Relation │  │ Search   │  │ Cache Layer   │  │
│  │ (Neo4j/  │  │ Store    │  │ Index    │  │ (Redis/       │  │
│  │  NetworkX)│  │ (SQLite) │  │ (Whoosh/ │  │  in-memory)  │  │
│  │          │  │          │  │  SQLite FTS)│              │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────────┘  │
├─────────────────────────────────────────────────────────────────┤
│                     Parsing Layer                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐ │
│  │ Table Parser │  │ Procedure    │  │ Indicator Config     │ │
│  │              │  │ Parser       │  │ Parser               │ │
│  └──────────────┘  └──────────────┘  └──────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Data Model Design

#### 2.2.1 Core Entities

```yaml
Table:
  primary_key: bare_table_name          # Normalized logical identifier
  attributes:
    - full_names: list[string]          # All schema-qualified aliases
    - schema: string
    - layer: LayerType                  # ODS/DIIS/BASE/MDL/APP/EAST/CONFIG/OTHER
    - comment: string
    - is_temp: boolean
    - column_count: integer
  relationships:
    - has_columns → Column (1:N)
    - processed_by → Procedure (M:N)
    - upstream_of → Table (M:N via TableLineage)
    - downstream_of → Table (M:N via TableLineage)

Column:
  primary_key: (bare_table_name, column_name)
  attributes:
    - data_type: string
    - nullable: boolean
    - comment: string
    - is_primary_key: boolean
    - field_category: enum              # DETAILED | BASIC_INDICATOR | GL_INDICATOR
  relationships:
    - belongs_to → Table (N:1)
    - source_of → FieldMapping (1:N)
    - target_of → FieldMapping (1:N)

FieldMapping:
  primary_key: (source_bare_table, source_column, target_bare_table, target_column, procedure)
  attributes:
    - transform_logic: string
    - confidence: float
    - operation_type: SQLOperationType
  relationships:
    - source → Column (N:1)
    - target → Column (N:1)
    - produced_by → Procedure (N:1)
    - has_caliber → CaliberInfo (1:1)

Procedure:
  primary_key: full_name
  attributes:
    - schema: string
    - description: string
    - file_path: string
  relationships:
    - reads_from → Table (M:N, source_tables)
    - writes_to → Table (M:N, target_tables)
    - uses_temp → Table (M:N, temp_tables)
    - contains → SQLOperation (1:N)

SQLOperation:
  primary_key: (procedure, step_num)
  attributes:
    - op_type: INSERT | MERGE | UPDATE
    - target_table: string
    - sql_block: string
    - start_line: integer
    - end_line: integer

CaliberInfo:
  primary_key: (field_mapping_id)
  attributes:
    - where_conditions: list[SQLCondition]
    - join_conditions: list[SQLCondition]
    - group_by_clause: string
    - having_clause: string
    - step_isolated_where: list[SQLCondition]
    - step_isolated_join: list[SQLCondition]
    - cte_definitions: list[string]
    - custom_functions: list[string]
    - full_expression: string
    - operation_type: string
    - select_columns: list[SelectColumnMapping]
    - distinct_flag: boolean
    - set_operation: string
    - window_functions: list[string]

TableLineage:
  primary_key: (source_bare_table, target_bare_table, procedure)
  attributes:
    - procedure: string
  relationships:
    - source → Table (N:1)
    - target → Table (N:1)
    - produced_by → Procedure (N:1)

IndicatorDef:
  primary_key: index_no
  attributes:
    - index_name: string
    - index_bclass: string             # "1"=Basic, "2"=Derived, "3"=Special, "6"=KPI
    - stat_period: string
  relationships:
    - has_measures → IndicatorMeasureDef (1:N)
    - depends_on → IndicatorDef (M:N via IndicatorRel)
    - computed_by_base → IndicatorCalcBase (1:N)
    - computed_by_gl → IndicatorCalcGL (1:N)
```

#### 2.2.2 Schema Normalization (Canonical Identity)

All table references MUST be normalized to a **canonical bare name** using a single, authoritative function. The canonical form eliminates schema variants:

| Original Form | Canonical Form | Rule |
|---|---|---|
| `RRP_MDL.O_ICL_CMM_XXX` | `ICL_CMM_XXX` | Strip `O_` prefix from O_ICL_* |
| `ICL.V_CMM_XXX` | `ICL_CMM_XXX` | Strip `V_` prefix, add `ICL_` prefix |
| `ICL.CMM_XXX` | `ICL_CMM_XXX` | Add `ICL_` prefix |
| `RRP_EAST.EAST5_KHXXB` | `EAST5_KHXXB` | Strip schema prefix |

**Invariant**: There is exactly ONE implementation of this function, shared by all layers. No duplicate.

#### 2.2.3 Field Category Classification

Fields must be classified into one of three categories to enable differentiated tracing:

```yaml
DETAILED:
  description: "Non-indicator data fields requiring full upstream source tracing"
  tracing_strategy: "Full BFS through table/field relationships until source origin"
  display_requirements: "Complete chain with transform logic at each hop"

BASIC_INDICATOR:
  description: "Base indicators computed from raw data with specific algorithms"
  tracing_strategy: "BFS with condition accumulation — each layer shows its JOIN/WHERE"
  display_requirements: "Per-layer conditions (step-isolated), accumulated conditions, transform logic"

GL_INDICATOR:
  description: "General ledger indicators traced through indicator dependency graph to GL accounts"
  tracing_strategy: "Indicator graph traversal → GL account resolution (subj_no + sign_no + amt_val)"
  display_requirements: "Indicator-to-indicator chain, terminal GL account details"
```

### 2.3 Graph Representation and Traversal Algorithms

#### 2.3.1 Graph Model

The system uses a **multilayer directed graph** with two distinct graph structures:

**Graph A: Field-Level Lineage Graph** (for detailed & basic indicator fields)
- **Nodes**: `(bare_table_name, column_name)` tuples
- **Edges**: `FieldMapping` records with procedure/transform metadata
- **Properties per edge**: `transform_logic`, `confidence`, `operation_type`, `procedure`
- **Direction**: Source field → Target field (data flow direction)

**Graph B: Indicator Dependency Graph** (for GL indicator fields)
- **Nodes**: `(index_no, index_measure)` tuples, plus terminal GL account nodes
- **Edges**: `IndicatorRel` dependencies + `IndicatorCalcGL` GL mappings
- **Properties per edge**: `algo_type`, `condition_sql`, `measure_sql`, `gl_subj_no`, `gl_sign_no`
- **Edge types**: `data_flow`, `calc_dependency`, `procedure_step`, `gl_mapping`

#### 2.3.2 Traversal Algorithms

**Algorithm 1: Schema-Aware BFS (Detailed Fields)**
```
Input: (target_table, target_field, max_depth, direction)
Output: list[FieldLineageChain]

1. Normalize input to canonical bare names
2. Initialize BFS queue with root node
3. For each dequeued node (current_table, current_field):
   a. Lookup FieldMappings where target = (current_table, current_field)
      using canonical index (O(1))
   b. For each FieldMapping found:
      i.   Normalize source to canonical form
      ii.  Check visited set (both full key and bare key)
      iii. If not visited:
           - Create BFS tree node with parent link
           - Add to visited set
           - Enqueue
4. Build chains from BFS tree (leaf → root paths)
5. Sort by depth (longest first)
```

**Algorithm 2: Condition-Accumulating BFS (Basic Indicators)**
```
Input: (target_table, target_field, max_depth)
Output: CaliberChain with per-step conditions

1. Same BFS structure as Algorithm 1
2. Additional per-step processing:
   a. Extract SQL block for current mapping's procedure
   b. Parse WHERE/JOIN/CTE conditions from SQL block
   c. Compute step-isolated conditions (current - accumulated)
   d. Accumulate conditions for downstream steps
3. Build CaliberChain with steps ordered source → target
4. Each CaliberInfo includes:
   - step_isolated_where/join (conditions unique to this step)
   - accumulated conditions (all conditions up to this step)
```

**Algorithm 3: Indicator Graph Traversal (GL Indicators)**
```
Input: (index_no, index_measure)
Output: IndicatorChain with GL terminal nodes

1. Look up indicator in IndicatorRel graph
2. BFS through indicator dependency edges:
   a. For each dependency:
      - If algo_type == "2" (GL): resolve to GL account
        (subj_no, sign_no, amt_val)
      - If algo_type != "2": follow dependency chain
3. Terminal nodes are GL accounts with:
   - Subject number (subj_no)
   - Sign (sign_no: debit/credit)
   - Amount field (amt_val)
4. Build IndicatorChain with:
   - Indicator-to-indicator edges (calc_dependency)
   - Indicator-to-GL-account edges (gl_mapping)
```

#### 2.3.3 Cycle Detection

All three algorithms MUST implement cycle detection using **canonical bare names**:

- Maintain a `visited: set[str]` where keys are `bare_table_name.field_name`
- Before enqueuing any node, check both the full key and the bare key
- This prevents infinite loops from schema variant self-references (e.g., `ICL.V_CMM_XXX ↔ RRP_MDL.O_ICL_CMM_XXX`)

### 2.4 Storage Design

#### 2.4.1 Persistent Graph Store

The lineage graph must be persisted to avoid the 6-8 minute cold start:

**Option A: SQLite + Adjacency Lists** (Recommended for current scale)
```sql
-- Tables
CREATE TABLE tables (
    bare_name TEXT PRIMARY KEY,
    full_names TEXT,        -- JSON array of schema-qualified names
    schema_name TEXT,
    layer TEXT,
    comment TEXT,
    is_temp BOOLEAN,
    column_count INTEGER
);

CREATE TABLE columns (
    bare_table TEXT,
    column_name TEXT,
    data_type TEXT,
    nullable BOOLEAN,
    comment TEXT,
    field_category TEXT,    -- DETAILED | BASIC_INDICATOR | GL_INDICATOR
    PRIMARY KEY (bare_table, column_name),
    FOREIGN KEY (bare_table) REFERENCES tables(bare_name)
);

-- Field Mappings
CREATE TABLE field_mappings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_bare_table TEXT,
    source_column TEXT,
    target_bare_table TEXT,
    target_column TEXT,
    transform_logic TEXT,
    procedure_name TEXT,
    confidence REAL,
    operation_type TEXT,
    UNIQUE(source_bare_table, source_column, target_bare_table, target_column, procedure_name)
);

-- Indexes for O(1) lookup
CREATE INDEX idx_fm_target ON field_mappings(target_bare_table, target_column);
CREATE INDEX idx_fm_source ON field_mappings(source_bare_table, source_column);
CREATE INDEX idx_fm_procedure ON field_mappings(procedure_name);

-- Table Lineages
CREATE TABLE table_lineages (
    source_bare_table TEXT,
    target_bare_table TEXT,
    procedure_name TEXT,
    PRIMARY KEY (source_bare_table, target_bare_table, procedure_name)
);

-- Caliber Info
CREATE TABLE caliber_info (
    field_mapping_id INTEGER PRIMARY KEY,
    where_conditions TEXT,      -- JSON
    join_conditions TEXT,       -- JSON
    group_by_clause TEXT,
    step_isolated_where TEXT,   -- JSON
    step_isolated_join TEXT,    -- JSON
    cte_definitions TEXT,       -- JSON
    full_expression TEXT,
    FOREIGN KEY (field_mapping_id) REFERENCES field_mappings(id)
);

-- Indicator Definitions
CREATE TABLE indicators (
    index_no TEXT PRIMARY KEY,
    index_name TEXT,
    index_bclass TEXT,
    stat_period TEXT
);

-- Indicator Relations (dependency graph)
CREATE TABLE indicator_relations (
    index_no TEXT,
    depend_index_no TEXT,
    PRIMARY KEY (index_no, depend_index_no)
);

-- Full-text search for table search
CREATE VIRTUAL TABLE tables_fts USING fts5(bare_name, full_names, comment);
```

**Option B: Neo4j** (For future scale)
- Nodes: Table, Column, Procedure, Indicator, GLAccount
- Relationships: READS_FROM, WRITES_TO, MAPS_TO, DEPENDS_ON, GL_MAPS
- Traversal: Cypher queries for BFS paths

#### 2.4.2 Caching Layer

```yaml
Query_Cache:
  scope: "Per-query results (graph_data, caliber_result)"
  ttl: 300s (5 minutes)
  invalidation: "On source file change detection"
  storage: "In-memory LRU with max 1000 entries"

Index_Cache:
  scope: "Pre-built BFS indexes (field_mapping_idx, proc_target_idx, etc.)"
  ttl: "Until source change"
  storage: "Memory-mapped SQLite or pickle"

Search_Cache:
  scope: "Table search results by keyword"
  ttl: 60s
  storage: "In-memory Map with debounce"
```

#### 2.4.3 Redundancy Elimination

The current system has significant redundancy that must be eliminated:

| Current Redundancy | Ideal Solution |
|---|---|
| `FieldMapping` objects duplicated across `ProcedureInfo.field_mappings` and `LineageTracer.field_mappings` | Single source of truth in `field_mappings` table; procedures reference via foreign key |
| `TableLineage` objects embed full `FieldMapping` lists | `TableLineage` references `FieldMapping` IDs |
| `_bare_table()` logic in 2 files | Single module (`core/canonical.py`) imported by all |
| `_result_to_graph()` in `api_server.py` duplicates `LineageTracer.to_graph_result()` | Unified `GraphTransformService` |
| `CaliberInfo` re-extracted from SQL on every query | Pre-computed at parse time, stored in `caliber_info` table |
| `CaliberTracer` duplicates BFS logic from `LineageTracer` | Shared BFS engine with pluggable strategies |

### 2.5 Performance Optimization Strategies

#### 2.5.1 Initialization Optimization

| Strategy | Current | Target |
|---|---|---|
| Full re-parse on startup | 6-8 min | < 10s (load from SQLite) |
| Incremental update | Not supported | < 30s per changed file |
| Parallel parsing | Sequential | Multi-threaded (4-8 workers) |

**Incremental Update Design**:
```
1. Hash each source file (MD5 of content)
2. Store hash in `source_files` table
3. On startup, compare current hashes vs. stored hashes
4. Only re-parse changed files
5. Rebuild affected indexes incrementally
```

#### 2.5.2 Query-Time Optimization

| Strategy | Current | Target |
|---|---|---|
| Field mapping lookup | O(1) index + O(N) fuzzy fallback | O(1) always (canonical index) |
| Graph serialization | Full re-serialization per query | Cached serialization |
| Caliber extraction | Re-reads .prc files per query | Pre-computed at parse time |
| BFS visited check | String set | Integer set (node ID) |
| Chain deduplication | O(N²) pairwise comparison | O(N log N) sorted prefix check |

**Canonical Index Design**:
```
All lookups use bare_table_name as the primary key.
Schema variants map to the same canonical key.
No fuzzy matching required at query time.
Fuzzy matching is a PARSE-TIME concern, not a QUERY-TIME concern.
```

#### 2.5.3 Concurrency Model

```
Current: Single-threaded http.server.HTTPServer
Ideal:   ASGI server (uvicorn + FastAPI/Starlette)
         - Async I/O for API handlers
         - Thread pool for CPU-bound BFS queries
         - Process pool for batch operations
```

### 2.6 Visualization Design

#### 2.6.1 Three Visualization Modes

**Mode 1: Relationship Graph (Detailed Fields)**
- Directed graph with nodes = tables, edges = field mappings
- Nodes colored by layer (ODS/DIIS/BASE/MDL/APP/EAST)
- Vertical layout: source (top) → target (bottom)
- Edge details on hover: transform_logic, procedure name
- Currently implemented via D3.js force-directed layout

**Mode 2: Pipeline View (Basic Indicators)**
- Horizontal pipeline with step cards
- Each card shows: source→target, JOIN conditions, WHERE conditions
- Accumulated conditions summary bar
- Click to expand step detail drawer
- Currently implemented as Pipeline v3.0

**Mode 3: Indicator Topology (GL Indicators)**
- Graph with indicator nodes and GL account terminal nodes
- Different edge styles for calc_dependency vs. gl_mapping
- Collapsible indicator clusters by index_bclass
- GL terminal nodes show: subj_no, sign, amt_val
- **NOT YET IMPLEMENTED** in current system

---

## 3. Gap Analysis: Current vs. Ideal

### 3.1 Critical Gaps

| # | Gap | Current State | Ideal State | Impact |
|---|-----|---------------|-------------|--------|
| G1 | **No persistent storage** | All data in memory; 6-8 min cold start | SQLite-backed store; <10s startup | Operational |
| G2 | **No field category differentiation** | All fields traced via same BFS | Three tracing strategies based on field type | Functional |
| G3 | **Caliber info not pre-computed** | SQL re-read on every query; `.prc` file I/O per step | Pre-computed at parse time, stored in DB | Performance |
| G4 | **Duplicate `_bare_table()` implementation** | 2 copies in `api_server.py` + `lineage_tracer.py` | Single canonical module | Maintainability |
| G5 | **Monolithic API server** | 1,289-line `api_server.py` mixing all concerns | Layered architecture with service separation | Maintainability |
| G6 | **No indicator topology visualization** | GL indicator tracing implemented but no visual | Three-mode visualization system | User Experience |

### 3.2 Significant Gaps

| # | Gap | Current State | Ideal State | Impact |
|---|-----|---------------|-------------|--------|
| G7 | **Single-threaded HTTP server** | `http.server.HTTPServer` (blocking) | ASGI + async handlers | Performance |
| G8 | **Fuzzy matching at query time** | O(N) scan when index miss | Canonical index eliminates fuzzy at query time | Performance |
| G9 | **No incremental update** | Full re-parse on any change | File-hash-based incremental update | Operational |
| G10 | **Duplicate BFS engines** | `LineageTracer` + `CaliberTracer` with similar logic | Shared BFS core with pluggable strategies | Maintainability |
| G11 | **No field category metadata** | Fields have no category tag | `field_category: DETAILED/BASIC_INDICATOR/GL_INDICATOR` | Functional |
| G12 | **Graph transformation in API layer** | `_result_to_graph()` in `api_server.py` | Dedicated `GraphTransformService` | Separation of Concerns |
| G13 | **Chain deduplication is O(N²)** | Pairwise signature comparison | Sorted prefix check O(N log N) | Performance at scale |

### 3.3 Minor Gaps

| # | Gap | Current State | Ideal State | Impact |
|---|-----|---------------|-------------|--------|
| G14 | **No query result caching** | Every query re-computed | LRU cache with TTL | Performance |
| G15 | **Layer detection is rule-based only** | Hard-coded naming conventions | Configurable rules + learned patterns | Extensibility |
| G16 | **No API versioning** | Single unversioned API | Versioned endpoints (`/api/v1/`) | API Stability |
| G17 | **No health monitoring** | Basic `/health` endpoint | Metrics, profiling, slow-query logging | Operations |
| G18 | **Hard-coded schema variant rules** | `O_ICL_*`/`ICL.V_*` rules in code | Configurable synonym mapping table | Extensibility |
| G19 | **No access control** | Open API | Role-based query access | Security |

### 3.4 Gap-to-Objective Mapping

| Objective | Gaps Directly Affecting |
|---|---|
| **Detailed Field Analysis** (trace to source origin) | G2, G11 (no field differentiation), G8 (fuzzy matching delays) |
| **Indicator Analysis — Basic** (per-layer JOIN/WHERE) | G2, G3 (caliber not pre-computed), G10 (duplicate BFS) |
| **Indicator Analysis — GL** (trace to GL accounts) | G2, G6 (no GL topology visualization), G11 |
| **Visualization** | G6 (no indicator topology view), G12 (graph transform in API) |
| **Performance** | G1 (cold start), G3 (re-read files), G7 (single-threaded), G8 (fuzzy), G14 (no cache) |
| **Non-redundant Storage** | G4 (duplicate bare_table), G5 (monolithic), G9 (no incremental), G10 (duplicate BFS) |

---

## 4. Ideal Data Flow

### 4.1 Parse-Time Flow

```
.prc/.tab files
       │
       ▼
  ┌─────────────┐     ┌──────────────────┐
  │ Table Parser │     │ Procedure Parser  │
  └──────┬──────┘     └────────┬─────────┘
         │                     │
         ▼                     ▼
  ┌─────────────┐     ┌──────────────────┐
  │ Canonical   │     │ Field Mapping     │
  │ Normalizer  │     │ Extractor         │
  └──────┬──────┘     └────────┬─────────┘
         │                     │
         ▼                     ▼
  ┌─────────────────────────────────────┐
  │           Field Classifier           │
  │  (tag each field as DETAILED /       │
  │   BASIC_INDICATOR / GL_INDICATOR)    │
  └────────────────┬────────────────────┘
                   │
         ┌─────────┼──────────┐
         ▼         ▼          ▼
  ┌──────────┐ ┌──────────┐ ┌──────────────┐
  │ Caliber  │ │Indicator │ │ Schema       │
  │ Pre-Comp │ │Graph Bldr│ │ Synonym Table│
  └────┬─────┘ └────┬─────┘ └──────┬───────┘
       │            │              │
       ▼            ▼              ▼
  ┌──────────────────────────────────────┐
  │         Persistent Store (SQLite)     │
  └──────────────────────────────────────┘
```

### 4.2 Query-Time Flow

```
Client Request (table, field)
       │
       ▼
  ┌────────────────┐
  │ Field Category  │
  │ Resolver        │──→ DETAILED? ──→ BFS Engine (Algorithm 1)
  │                 │──→ BASIC_INDICATOR? ──→ Condition-BFS (Algorithm 2)
  │                 │──→ GL_INDICATOR? ──→ Indicator Graph (Algorithm 3)
  └────────────────┘
       │
       ▼
  ┌────────────────┐
  │ Graph Transform │
  │ Service         │
  └────────────────┘
       │
       ▼
  ┌────────────────┐
  │ Visualization   │
  │ Router          │──→ Relationship Graph / Pipeline / Topology
  └────────────────┘
```

---

## 5. Summary of Technical Gaps by Codebase File

| File | Identified Issues |
|---|---|
| `api_server.py` | Monolithic (1,289 lines); contains graph transform (`_result_to_graph`), caliber chain construction (`_chains_to_caliber_result`), duplicate `_bare_table()`, inline file I/O for SQL block extraction, no caching, no async |
| `core/lineage_tracer.py` | Duplicate `_bare_table()`; O(N) fuzzy matching fallback; `to_graph_result()` duplicates `api_server._result_to_graph()`; no canonical index (index keys use raw names, not bare names) |
| `core/caliber_tracer.py` | Duplicate BFS logic from `LineageTracer`; condition accumulation works but is isolated from main tracing engine |
| `core/procedure_parser.py` | Solid parsing; but stores `field_mappings` as list on `ProcedureInfo` (no DB normalization); TMP bridge logic in tracer should be parse-time |
| `core/caliber_extractor.py` | Good condition extraction; but called at query time instead of parse time |
| `core/models.py` | `FieldMapping` has no `field_category`; `CaliberInfo` has too many fields (should be normalized); `TableLineage` embeds full `FieldMapping` lists |
| `core/indicator_graph_builder.py` | Functional but disconnected from main API; no visualization endpoint |
| `core/layer_detector.py` | Hard-coded rules; not configurable |
| `core/sql_boundary_detector.py` | Good DML boundary detection but only used at query time, not at parse time |
| `core/table_parser.py` | Simple and functional; no issues |
| `static/js/display-tab.js` | D3.js graph works but no field-level detail on edges |
| `static/js/caliber-tab.js` | Pipeline v3.0 works; step detail drawer functional |
