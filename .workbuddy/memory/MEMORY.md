# DATA_RELY_ANALYSIS_SYS 项目记忆（精简版）

## 项目概述
Oracle 数据库血缘分析系统，解析 .tab/.prc 文件，生成表级/字段级血缘关系。

## 关键文件
- `core/layer_detector.py` — 层级检测权威模块
- `core/table_parser.py` — OracleTableParser 表结构解析器
- `core/procedure_parser.py` — EnhancedProcedureParser 存储过程解析器
- `core/lineage_tracer.py` — LineageTracer 字段级血缘追踪（BFS）
- `core/caliber_extractor.py` — 口径提取器
- `core/sql_boundary_detector.py` — SQL边界检测器
- `api_server.py` — HTTP API 服务
- `static/js/caliber-tab.js` — 口径Tab前端（Pipeline可视化v3.0）
- `static/css/style.css` — 全局样式（含Pipeline专用样式）

## Schema 变体合并规则（`_bare()` 函数）
- `RRP_MDL.O_ICL_*` → `ICL_*`（去掉O_前缀）
- `ICL.V_*` → `ICL_*`（去掉V_前缀，加ICL_前缀）
- `ICL.XXX` → `ICL_XXX`（加ICL_前缀）

两处实现必须保持一致：`api_server.py` 和 `core/lineage_tracer.py`

## 数据规模
3041 张表，1754 个存储过程，服务初始化约需 6-8 分钟。

## 关键修复记录

### 2026-05-14：ICL 多余节点 + 字段映射重复
- `_bare()` 增加 ICL.V_* 处理
- 自环边过滤改为精确条件：`src_bare == tgt_bare AND src_table != tgt_table`
- 三元组去重：`(src_bare | tgt_bare.target_field)`

### 2026-05-15：Batch B/C/D 口径提取增强
- 行号定位、SQL边界检测、隔离条件、CTE/函数提取
- `procedure_parser.py` 增加 `_extend_with_cte()` 方法
- `_chains_to_caliber_result` 增强过程查找策略

### 2026-05-15：口径链路重复（BFS去重）
- BFS visited-set 改用 `_bare_table()` 归一化
- 口径链语义去重：`bare_target_table.target_column` 签名

### 2026-05-15：Pipeline 布局修复
- `.caliber-results` 增加 CSS class
- `.pipeline-container` 增加 `min-height: 0`
- `.pipeline-scroll` 改为 `flex-direction: column`

## 已解决问题（2026-05-15）

### 问题1：口径链路重复（公共前缀去重）
- **根因**：口径链去重仅比较单步签名，未比较完整路径签名
- **修复**：改为公共前缀检测，按深度降序排列，优先保留最长链（丢弃前缀子链）
- **代码位置**：`api_server.py` `_chains_to_caliber_result()` 第461-482行

### 问题2：口径详情为空（sql_block提取失败）
- **根因**：`tgt_node.procedure`为空、short-name精确匹配无法处理schema变体、索引key带schema前缀
- **修复**：3策略匹配（精确→bare归一化→INSERT/MERGE兜底）+ 多策略过程查找（tgt_node.procedure→src_node.procedure→_proc_target_idx）
- **验证**：Step 1-4 全部有 op_type=INSERT_VALUES、where>0、sql_len>0 ✅

### 问题3：Pipeline布局展示不完全
- **根因**：`.caliber-results` 缺少 CSS class、`.pipeline-container` 缺少 min-height:0
- **修复**：新增 `.caliber-results` CSS、调整 flex 属性、`.caliber-overview` 增加 flex-shrink:0
- **验证**：浏览器端到端测试通过，4节点全部渲染完整 ✅