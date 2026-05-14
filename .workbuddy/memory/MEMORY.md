# DATA_RELY_ANALYSIS_SYS 项目记忆

## 项目概述
Oracle 数据库血缘分析系统，解析 .tab/.prc 文件，生成表级/字段级血缘关系，输出 JSON + HTML 可视化。

## 关键文件
- `core/layer_detector.py` — **层级检测权威模块**（LayerType/LAYER_CONFIG/detect_layer，支持 schema.table 全限定名）
- `core/table_parser.py` — OracleTableParser 表结构解析器（从 analyze_lineage.py 迁出）
- `core/models.py` — 数据模型（从 layer_detector re-export LayerType/detect_layer）
- `core/procedure_parser.py` — EnhancedProcedureParser 存储过程解析器
- `core/lineage_tracer.py` — LineageTracer 字段级血缘追踪（BFS上游+下游追溯）
- `app/services/lineage_service.py` — 血缘查询服务（委托 core.layer_detector 做层级检测）
- `app/services/parser_service.py` — 解析服务（使用 core.table_parser + core.procedure_parser）
- `api_server.py` — 遗留 HTTP 服务（使用 core.table_parser）
- `analyze_lineage.py` — **LEGACY**：向后兼容 wrapper，实际代码已迁入 core/
- `static/index.html` — 前端入口，双Tab（解析层+展示层）
- `static/js/app.js` — 全局状态管理、TAB切换、工具函数
- `static/js/search-panel.js` — 展示层搜索面板（表名搜索、字段选择、查询触发）
- `static/js/lineage-graph.js` — 展示层D3.js图谱渲染（BFS布局、节点/边绘制）
- `static/js/detail-panel.js` — 展示层详情面板（字段映射列表、节点信息浮窗）
- `static/js/display-tab.js` — **已拆分为以上3个模块，不再被 index.html 引入**
- `static/js/parse-tab.js` — 解析层文件上传/进度/SSE逻辑

## Schema 变体合并规则（`_bare()` 函数）

`_bare()` 在 `api_server.py` 和 `core/lineage_tracer.py` 两处实现，必须保持一致：

| 原始表名 | _bare() 映射结果 | 说明 |
|---------|-----------------|------|
| `RRP_MDL.O_ICL_CMM_XXX` | `ICL_CMM_XXX` | 去掉 O_ 前缀 |
| `ICL.V_CMM_XXX` | `ICL_CMM_XXX` | 去掉 V_ 视图前缀，加 ICL_ 前缀 |
| `ICL.CMM_XXX` | `ICL_CMM_XXX` | 加 ICL_ 前缀 |

三个变体都映射到同一个逻辑名，实现同义去重。如果后续有其他类似的 schema 映射（如 `O_ODS_*`），需扩展此函数。

## 2026-05-14 修复：ICL 多余节点 + 字段映射重复 + 同表内映射误过滤

### 根因（三个问题）
1. **`_bare()` 未处理 `ICL.V_*` 视图前缀**：`ICL.V_CMM_XXX` 被映射为 `ICL_V_CMM_XXX`（保留了 V_），与 `O_ICL_CMM_XXX` → `ICL_CMM_XXX` 不一致，导致去重失效，ICL 节点独立显示
2. **自环边过滤过于激进**：`src_bare == tgt_bare` 时直接跳过，误伤了同表内不同字段间的转换边（如 `CUST_NM → CUST_NM_DESEN`）
3. **字段映射重复**：schema 变体产生重复映射，三元组去重 `(逻辑源表|逻辑目标表.目标字段)` 未实现

### 修复内容
1. **`api_server.py` `_bare()` 增加 ICL.V_* 处理**：`ICL.V_CMM_XXX → ICL_CMM_XXX`（与 O_ICL_CMM_XXX 统一）
2. **自环边过滤改为精确条件**：`src_bare == tgt_bare AND src_table != tgt_table`（只跳过 schema 变体间的假边，保留同表内字段转换边）
3. **新增 `fm_dedup_keys` 三元组去重**：`(src_bare | tgt_bare.target_field)` 去重
4. **`core/lineage_tracer.py` `_bare_table()` 同步更新**：`_find_source_fields` 和 `_find_target_fields` 中的 `_bare_table()` 增加 ICL.V_* 处理

### 验证结果
查询 `RRP_MDL.EAST5_201_GRJCXXB.KHXM`：
- 修复前：5 节点、5 边、6 映射（含多余 ICL 节点和重复映射）
- 修复后：4 节点、4 边、4 映射（完整血缘链路无冗余）
- 完整链路：`O_ICL_CMM_INDV_CUST_BASIC_INFO.CUST_NAME → M_CUST_IND_INFO.CUST_NM → M_CUST_IND_INFO_EAST.CUST_NM → M_CUST_IND_INFO_EAST.CUST_NM_DESEN → EAST5_201_GRJCXXB.KHXM`

## 2026-05-11 修复：展示层Tab无法点击使用

### 根因
前端 `display-tab.js` 期望 `/api/lineage/query` 返回 `nodes/edges/field_mappings` 格式，但后端 `api_server.py` 返回的是 `chains` 格式，格式不匹配导致展示层渲染空数据。

### 修复内容（方案2：后端适配前端）
1. **新增 `_result_to_graph()` 转换函数**：将 `FieldLineageResult`（chains格式）转换为前端期望的 `{nodes, edges, field_mappings, query_target, query_time_ms}` 格式
2. **修改 `_handle_lineage_query()`**：使用 `_result_to_graph()` 替代 `_serialize_result()`，兼容前端 `depth`→`max_depth` 参数映射，接受 `mode` 参数
3. **修改 `_handle_lineage_get()`**：同上
4. **新增 `/health` 端点**：返回 `{status, uptime_seconds, total_tables, total_procedures}`

### 遗留问题
- `parse-tab.js` 调用的 `/api/parse/upload`、`/api/parse/parse-existing`、SSE 进度端点后端未实现（解析层Tab不可用）
- 双重血缘引擎未统一：`LineageService._trace_field_lineage` (JSON dict) vs `core/lineage_tracer` (dataclass)，建议后续独立重构

## 2026-05-11 修复：字段名大小写不敏感

`trace_field` / `trace_field_downstream` 在调用 `_build_chains_from_bfs_tree` 前未 normalize 参数，导致小写字段名拼接的 root_key 与 BFS 树中的大写 key 不匹配。修复：在两处入口方法中先对 table/field 做 normalize 再传入。

## 数据规模
- 3041 张表，1754 个存储过程
- 服务初始化约需 6-8 分钟（解析全部 .prc 文件）
