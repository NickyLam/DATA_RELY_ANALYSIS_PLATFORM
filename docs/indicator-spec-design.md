# 指标口径查询功能设计方案

> 目标：让开发人员基于查询结果，能够在新的数据库环境中独立完成数据加工指标的开发设计。

---

## 一、当前效果问题诊断

当前"指标口径" Tab 虽然能够拉出数据，但对开发人员的实际帮助有限，核心问题在于：**原始信息堆砌，缺少可指导重新开发的技术蓝图**。

| 问题 | 表现 | 对开发的影响 |
|------|------|-------------|
| **信息过载，缺少焦点** | 82 个筛选条件、45 个加工步骤一股脑铺开 | 开发人员找不到"我这个字段到底在哪一步被怎么算的" |
| **"累积"逻辑误导性强** | WHERE / JOIN 是累积的，不是单步特有的 | 无法判断某条筛选在哪张临时表、哪次插入时生效，复现时会多写或少写条件 |
| **缺少核心计算表达式** | 只看到 `CUST_NM → CUST_NM_DESEN` 的映射 | 不知道 `CUST_NM_DESEN` 是用什么函数、什么表达式生成的（加密？脱敏？拼接？） |
| **与存储过程/脚本脱节** | 看不到每一步属于哪个 .prc 文件的哪段 SQL | 开发人员想去源码里核对都无从下手 |
| **数据流向是平铺的** | 链路只是文字罗列 | 看不到并行分支（如某个指标同时依赖两个源表，走两条路径汇聚） |

---

## 二、功能重新定位

血缘展示（展示层 Tab）回答的是：**"这个数据从哪来、到哪去"** —— 它是图问题。

指标口径查询回答的应该是：**"这个字段具体是怎么算出来的，每一步发生了什么"** —— 它是**计算逻辑的解剖问题**。

### 设计目标

> **让一个接手这个数据需求的开发人员，在不看原始 .prc 文件的情况下，能够基于查询结果写出等价的建表语句、插入逻辑、筛选条件和关联关系。**

---

## 三、设计原则：面向"可复现开发"

1. **分层聚焦，从整体到局部**：先给宏观链路，再进单步详情，不要一次性全展开。
2. **单步自治，拒绝累积**：每一步只展示该 INSERT / UPDATE / MERGE 语句本身的逻辑，不要把前面步骤的条件带进来。
3. **表达式优先**：字段映射只是骨架，核心是 `目标字段 = 什么表达式（源字段 / 函数 / 常量）`。
4. **源码锚定**：每一步都要能追溯到原始文件和代码片段，方便核对。
5. **可导出为设计文档**：最终能一键导出成 Markdown / Word，直接贴进需求设计文档。

---

## 四、建议的模块结构设计

将"指标口径" Tab 重新拆成三个视图层级：

### 层级 1：指标概览卡（Summary Card）

顶部固定区域，组织方式如下：

```
┌─────────────────────────────────────────────────────────────┐
│ 指标：rrp_east.east5_201_grjcxxb.KHXM（客户姓名）             │
│ 业务口径：个人客户基本信息表中的客户名称（若有业务元数据）       │
├─────────────────────────────────────────────────────────────┤
│ 技术口径摘要：                                                │
│   TRIM(UPPER(O_ICL_CMM_INDV_CUST_BASIC_INFO.CUST_NAME))      │
│   → [MDL 层脱敏处理]                                          │
│   → [EAST 层标准映射]                                         │
│   → east5_201_grjcxxb.KHXM                                    │
├─────────────────────────────────────────────────────────────┤
│ 链路统计：3 条并行路径 | 7 个加工步骤 | 涉及 4 个 .prc 文件   │
│ 数据质量：是否有 NULL 分支 / 是否有硬编码 / 是否有跨库关联      │
└─────────────────────────────────────────────────────────────┘
```

**关键改进**："技术口径摘要"给出**从最源头到最终目标的完整表达式链路**，开发人员第一眼就知道这个数据经历了什么。

---

### 层级 2：加工链路图（Pipeline View）

用一个**横向流水线**替代文字链路：

```
源层                    MDL层                   ODS层                目标层
┌─────────────┐        ┌─────────────┐        ┌─────────────┐      ┌─────────────┐
│ O_ICL_CMM   │──SQL1─→│ M_CUST_IND  │──SQL2─→│ M_CUST_IND  │──SQL3→│ EAST5_201   │
│ _INDV_CUST  │        │ _INFO       │        │ _INFO_EAST  │      │ _GRJCXXB    │
│ _BASIC_INFO │        │             │        │             │      │             │
│ .CUST_NAME  │        │ .CUST_NM    │        │.CUST_NM_    │      │ .KHXM       │
└─────────────┘        └─────────────┘        │ DESEN       │      └─────────────┘
                                              └─────────────┘
                                                      ↑
                                              [另一条分支]
                                              ┌─────────────┐
                                              │ V_CMM_INDV  │
                                              │ _CUST_BASIC │
                                              │ _INFO       │
                                              └─────────────┘
```

**交互**：点击每个节点或边，展开该步骤的详情。

**关键改进**：并行路径、汇聚点要能一眼看出。同表内字段转换（如 `M_CUST_IND_INFO_EAST.CUST_NM → CUST_NM_DESEN`）应表现为**内部加工节点**，而非两个独立节点。

---

### 层级 3：单步详情面板（Step Detail）

点击流水线中的任意一步，右侧滑出详情面板，这是**最核心的改进**。

示例（点击 SQL2 步骤）：

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
步骤 #2：M_CUST_IND_INFO → M_CUST_IND_INFO_EAST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【所属脚本】
文件：P_M_CUST_IND_INFO_EAST.prc
位置：第 142 行 ~ 第 189 行
操作类型：INSERT INTO ... SELECT ...

【目标字段表达式】
CUST_NM_DESEN = PKG_DESEN.ENCRYPT_NAME(A.CUST_NM)

【源字段清单】
┌ 字段名          ┌ 来源表/别名    ┌ 上游步骤
│ CUST_NM        │ A (M_CUST_IND_INFO) │ 步骤 #1
│ CUST_ID        │ A                   │ 步骤 #1
│ ...

【该步骤筛选条件】（仅本 INSERT 的 WHERE）
WHERE A.ETL_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
  AND A.IS_VALID = '1'

【该步骤 JOIN 关系】（仅本 INSERT 的 JOIN）
LEFT JOIN TMP_ALB_TMP1 K
  ON K.CUSTOMER_NO = A.CUST_ID AND K.NUM = 1

【窗口 / 聚合函数】
ROW_NUMBER() OVER(PARTITION BY CUST_CODE ORDER BY CRT_DATE DESC)

【临时表 / CTE】
WITH TMP_ALB_TMP2 AS (
  SELECT /*+MATERIALIZE*/ CUST_CODE, CRT_DATE, ...
)

【原始 SQL 片段】（可折叠）
> INSERT INTO M_CUST_IND_INFO_EAST (...)
> SELECT ... FROM M_CUST_IND_INFO A
> LEFT JOIN ...
> WHERE ...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**关键改进对比**：

| 当前做法 | 建议做法 | 理由 |
|---------|---------|------|
| 累积 WHERE / JOIN | **单步 WHERE / JOIN** | 开发人员要知道的是"这一步插入了哪些数据"，不是"到这一步为止所有历史条件" |
| 只展示字段映射 | **展示完整表达式** | `CUST_NM_DESEN = PKG_DESEN.ENCRYPT_NAME(A.CUST_NM)` 才能指导重写 |
| 不展示临时表 | **展示 CTE / 临时表** | 临时表是存储过程的核心逻辑，开发人员重构时必须重建 |
| 缺少原始代码定位 | **文件 + 行号 + SQL 片段** | 核对和 Debug 时的刚需 |

---

## 五、数据解析层面需要增强的能力

前端展示成什么样，取决于后端能解析出什么。当前系统还需要在解析层增强：

### 1. 表达式解析（Expression Parser）

- 当前可能只解析了 `INSERT INTO ... SELECT ...` 的字段对应关系。
- 需要进一步解析 SELECT 列表中每个字段的**完整表达式**。
- 例如：`SELECT SUBSTR(TRIM(CUST_NAME), 1, 50) AS CUST_NM`，要知道 `CUST_NM` 的来源是 `CUST_NAME`，表达式是 `SUBSTR(TRIM(...), 1, 50)`。

### 2. 单语句边界提取

- 当前"累积"问题的根源是解析时没有把每个 INSERT / UPDATE 语句当成独立单元。
- 需要精确切割每个 DML 语句的**私有** WHERE、JOIN、GROUP BY。

### 3. 临时表（Temp Table）追踪

- 存储过程里大量使用 `CREATE TABLE ... AS SELECT` 或 `WITH ... AS (...)`。
- 需要把这些临时表也纳入链路，显示它们在哪一步被创建、在哪一步被消费。

### 4. 函数依赖识别

- 如果使用了 `PKG_DESEN.ENCRYPT_NAME()` 这样的自定义函数，要标记出来。
- 开发人员重构时，需要知道这些函数在新环境是否存在、是否需要重写。

---

## 六、建议的交互流程

```
1. 开发人员输入：表名 + 字段名 + 方向（上游追溯 / 下游去向）
      ↓
2. 系统返回：指标概览卡（技术口径摘要一眼可见）
      ↓
3. 开发人员点击"查看加工链路"
      ↓
4. 系统展示：Pipeline 流水线图（横向，支持并行路径）
      ↓
5. 开发人员点击某一步（比如步骤 #3）
      ↓
6. 右侧滑出：单步详情面板（表达式、筛选、JOIN、原始 SQL）
      ↓
7. 开发人员点击"导出口径文档"
      ↓
8. 系统生成：Markdown / Word 文档，包含完整加工逻辑，可直接贴进设计文档
```

---

## 七、核心改进点总结

| 维度 | 当前状态 | 建议目标 |
|------|---------|---------|
| **信息组织** | 平铺堆砌，累积混合 | 分层聚焦，单步自治 |
| **核心内容** | 字段映射 | 完整计算表达式 + 筛选上下文 |
| **开发指导** | 看完还是不知道怎么做 | 看了能直接重写 SQL |
| **溯源能力** | 无法定位原始代码 | 精确到文件、行号、SQL 片段 |
| **输出价值** | 仅供查看 | 可导出为设计文档 |

---

## 八、现有能力盘点

对照方案需求，逐项评估当前系统的已实现和缺失能力：

### 解析层能力

| 能力 | 当前状态 | 代码位置 | 差距说明 |
|------|---------|---------|---------|
| INSERT / MERGE / UPDATE 检测 | ✅ 已实现 | `procedure_parser.py` `_extract_all_sql_operations()` | 支持全局查找多步 DML |
| V_STEP 步骤分组 | ✅ 已实现 | `procedure_parser.py` `_find_step_context()` | 可关联 step_num / step_desc |
| 字段映射提取 | ✅ 已实现 | `procedure_parser.py` `_extract_insert_mappings()` | 支持别名解析、UNION ALL |
| SELECT 列表达式解析 | ⚠️ 部分实现 | `caliber_extractor.py` `_extract_select_columns()` | 解析了 AS 别名映射，但 `SelectColumnMapping.source_expression` 常为空或截断 |
| WHERE 条件提取 | ✅ 已实现 | `caliber_extractor.py` `_extract_where()` | 但仍是**全 SQL 块**的 WHERE，非单步隔离 |
| JOIN 条件提取 | ✅ 已实现 | `caliber_extractor.py` `_extract_joins()` | 同上，全 SQL 块级别 |
| GROUP BY / HAVING | ✅ 已实现 | `caliber_extractor.py` | - |
| 窗口函数识别 | ✅ 已实现 | `caliber_extractor.py` `_extract_window_functions()` | 正则匹配，覆盖主要场景 |
| 子查询提取 | ✅ 已实现 | `caliber_extractor.py` `_extract_subqueries()` | 支持别名和内部表引用 |
| 集合运算识别 | ✅ 已实现 | `caliber_extractor.py` `_detect_set_operation()` | UNION / UNION ALL / INTERSECT / MINUS |
| 操作类型检测 | ✅ 已实现 | `caliber_extractor.py` `_detect_operation_type()` | INSERT_SELECT / MERGE / UPDATE / CTAS / DELETE |
| **单语句边界切割** | ❌ 未实现 | — | 当前 SQLOperation 包含 `sql_block`，但 `_INSERT_INTO_PATTERN` 匹配范围过大，WHERE/JOIN 未隔离 |
| **表达式完整保留** | ❌ 未实现 | — | `FieldCleaner.parse_select_columns()` 清洗时丢失了函数嵌套结构 |
| **CTE / WITH 追踪** | ❌ 未实现 | — | 只识别了 CTAS 模式（`CREATE TABLE AS SELECT`），未识别 `WITH ... AS (...)` |
| **函数依赖标记** | ❌ 未实现 | — | 未识别 `PKG_*.FUNC()` 等自定义函数调用 |
| **行号定位** | ❌ 未实现 | — | `CaliberInfo` 无 `file_path` / `start_line` / `end_line` 字段 |
| **临时表创建/消费生命周期** | ⚠️ 部分实现 | `procedure_parser.py` `_detect_internal_dependencies()` | 识别了 TMP 表读写步骤，但未纳入 CaliberInfo 链路 |

### 数据模型能力

| 模型 | 当前状态 | 差距说明 |
|------|---------|---------|
| `CaliberInfo` | ✅ 结构丰富 | 有 where/join/select_columns/window_functions 等字段 |
| `CaliberInfo.raw_sql_fragment` | ⚠️ 截断到 2000 字符 | 无法看到完整 SQL |
| `CaliberInfo.accumulated_where/join` | ⚠️ 存在但误导 | 累积逻辑是问题根源 |
| `CaliberInfo.file_path / start_line / end_line` | ❌ 缺失 | 无法锚定源码位置 |
| `CaliberInfo.custom_functions` | ❌ 缺失 | 无法标记函数依赖 |
| `CaliberInfo.cte_definitions` | ❌ 缺失 | 无法展示 CTE 临时表 |
| `CaliberInfo.step_isolated_where/join` | ❌ 缺失 | 单步隔离条件未实现 |
| `CaliberResult` | ✅ 基本完整 | 但缺少"技术口径摘要"字段 |
| `CaliberResult.summary_card` | ❌ 缺失 | 无概览卡数据 |

### API 能力

| 接口 | 当前状态 | 差距说明 |
|------|---------|---------|
| `GET /api/caliber/trace` | ✅ 已实现 | 返回 CaliberResult（chains 格式） |
| `GET /api/caliber/fields` | ✅ 已实现 | 返回某表有口径数据的字段列表 |
| `GET /api/lineage/query` | ✅ 已实现 | 返回 nodes/edges/field_mappings 图格式 |
| `GET /api/caliber/trace?mode=pipeline` | ❌ 缺失 | 无 Pipeline 视图数据接口 |
| `GET /api/caliber/trace?mode=step_detail&step=N` | ❌ 缺失 | 无单步详情接口 |
| `GET /api/caliber/export?format=markdown` | ❌ 缺失 | 无导出接口 |
| `GET /api/caliber/summary` | ❌ 缺失 | 无概览卡专用接口 |

### 前端能力

| 组件 | 当前状态 | 差距说明 |
|------|---------|---------|
| 指标口径 Tab | ✅ 基本可用 | 平铺展示 chains/steps 列表 |
| 概览卡 | ❌ 缺失 | 无 Summary Card 组件 |
| Pipeline 图 | ❌ 缺失 | 无横向流水线图 |
| 单步详情面板 | ❌ 缺失 | 无右侧滑出面板 |
| 导出按钮 | ❌ 缺失 | 无导出功能 |

---

## 九、API 接口设计

### 9.1 概览卡接口

```
GET /api/caliber/summary?table=RRP_EAST.EAST5_201_GRJCXXB&field=KHXM
```

**响应**：

```json
{
  "success": true,
  "data": {
    "indicator": "RRP_EAST.EAST5_201_GRJCXXB.KHXM",
    "indicator_short": "EAST5_201_GRJCXXB.KHXM",
    "business_caliber": "客户姓名（脱敏后）",
    "technical_caliber_summary": "TRIM(UPPER(O_ICL_CMM_INDV_CUST_BASIC_INFO.CUST_NAME)) → [MDL 脱敏] → [EAST 映射] → EAST5_201_GRJCXXB.KHXM",
    "caliber_chain_text": [
      "O_ICL_CMM_INDV_CUST_BASIC_INFO.CUST_NAME → M_CUST_IND_INFO.CUST_NM  [TRIM/UPPER]",
      "M_CUST_IND_INFO.CUST_NM → M_CUST_IND_INFO_EAST.CUST_NM_DESEN  [PKG_DESEN.ENCRYPT_NAME]",
      "M_CUST_IND_INFO_EAST.CUST_NM_DESEN → EAST5_201_GRJCXXB.KHXM  [DIRECT]"
    ],
    "stats": {
      "parallel_paths": 2,
      "total_steps": 5,
      "procedures_count": 3,
      "procedures": ["P_M_CUST_IND_INFO", "P_M_CUST_IND_INFO_EAST", "P_EAST5_201_GRJCXXB"],
      "tables_count": 4,
      "tables": ["O_ICL_CMM_INDV_CUST_BASIC_INFO", "M_CUST_IND_INFO", "M_CUST_IND_INFO_EAST", "EAST5_201_GRJCXXB"],
      "custom_functions": ["PKG_DESEN.ENCRYPT_NAME"],
      "has_hardcoded_values": true,
      "has_cross_schema_join": false,
      "has_null_branch": false
    },
    "query_time_ms": 123.45
  }
}
```

### 9.2 Pipeline 视图接口

```
GET /api/caliber/trace?table=RRP_EAST.EAST5_201_GRJCXXB&field=KHXM&mode=pipeline
```

**响应**：

```json
{
  "success": true,
  "data": {
    "target": { "table": "RRP_EAST.EAST5_201_GRJCXXB", "field": "KHXM" },
    "pipeline": {
      "nodes": [
        {
          "id": "O_ICL_CMM_INDV_CUST_BASIC_INFO",
          "layer": "ODS",
          "label": "O_ICL_CMM_INDV_CUST_BASIC_INFO",
          "field": "CUST_NAME",
          "is_source": true,
          "is_internal_transform": false
        },
        {
          "id": "M_CUST_IND_INFO",
          "layer": "DWD",
          "label": "M_CUST_IND_INFO",
          "field": "CUST_NM",
          "is_source": false,
          "is_internal_transform": false
        },
        {
          "id": "M_CUST_IND_INFO_EAST.CUST_NM",
          "layer": "DWS",
          "label": "M_CUST_IND_INFO_EAST",
          "field": "CUST_NM",
          "is_source": false,
          "is_internal_transform": false
        },
        {
          "id": "M_CUST_IND_INFO_EAST.CUST_NM_DESEN",
          "layer": "DWS",
          "label": "M_CUST_IND_INFO_EAST",
          "field": "CUST_NM_DESEN",
          "is_source": false,
          "is_internal_transform": true,
          "transform_note": "同表内字段转换：脱敏处理"
        },
        {
          "id": "EAST5_201_GRJCXXB",
          "layer": "ADS",
          "label": "EAST5_201_GRJCXXB",
          "field": "KHXM",
          "is_source": false,
          "is_internal_transform": false
        }
      ],
      "edges": [
        {
          "id": "step_1",
          "source": "O_ICL_CMM_INDV_CUST_BASIC_INFO",
          "target": "M_CUST_IND_INFO",
          "source_field": "CUST_NAME",
          "target_field": "CUST_NM",
          "expression": "TRIM(UPPER(A.CUST_NAME))",
          "procedure": "P_M_CUST_IND_INFO",
          "step_num": 1,
          "operation_type": "INSERT_SELECT",
          "has_detail": true
        },
        {
          "id": "step_2",
          "source": "M_CUST_IND_INFO",
          "target": "M_CUST_IND_INFO_EAST.CUST_NM",
          "source_field": "CUST_NM",
          "target_field": "CUST_NM",
          "expression": "A.CUST_NM",
          "procedure": "P_M_CUST_IND_INFO_EAST",
          "step_num": 2,
          "operation_type": "INSERT_SELECT",
          "has_detail": true
        },
        {
          "id": "step_2b",
          "source": "M_CUST_IND_INFO_EAST.CUST_NM",
          "target": "M_CUST_IND_INFO_EAST.CUST_NM_DESEN",
          "source_field": "CUST_NM",
          "target_field": "CUST_NM_DESEN",
          "expression": "PKG_DESEN.ENCRYPT_NAME(A.CUST_NM)",
          "procedure": "P_M_CUST_IND_INFO_EAST",
          "step_num": 2,
          "operation_type": "INTERNAL_TRANSFORM",
          "has_detail": true
        },
        {
          "id": "step_3",
          "source": "M_CUST_IND_INFO_EAST.CUST_NM_DESEN",
          "target": "EAST5_201_GRJCXXB",
          "source_field": "CUST_NM_DESEN",
          "target_field": "KHXM",
          "expression": "A.CUST_NM_DESEN",
          "procedure": "P_EAST5_201_GRJCXXB",
          "step_num": 3,
          "operation_type": "INSERT_SELECT",
          "has_detail": true
        }
      ],
      "branches": [
        {
          "merge_point": "M_CUST_IND_INFO_EAST",
          "source_node": "V_CMM_INDV_CUST_BASIC_INFO",
          "label": "ICL 视图直传"
        }
      ]
    },
    "query_time_ms": 150.3
  }
}
```

### 9.3 单步详情接口

```
GET /api/caliber/step-detail?table=RRP_EAST.EAST5_201_GRJCXXB&field=KHXM&step_num=2&procedure=P_M_CUST_IND_INFO_EAST
```

**响应**：

```json
{
  "success": true,
  "data": {
    "step_num": 2,
    "step_desc": "加工客户信息EAST层",
    "procedure": "P_M_CUST_IND_INFO_EAST",
    "source_table": "RRP_MDL.M_CUST_IND_INFO",
    "target_table": "RRP_EAST.M_CUST_IND_INFO_EAST",
    "operation_type": "INSERT_SELECT",
    "source_code_location": {
      "file_path": "RRP_ORACLE/rrp_east/P_M_CUST_IND_INFO_EAST.prc",
      "start_line": 142,
      "end_line": 189,
      "can_open_file": true
    },
    "target_field_expressions": [
      {
        "target_column": "CUST_NM_DESEN",
        "expression": "PKG_DESEN.ENCRYPT_NAME(A.CUST_NM)",
        "source_columns": ["CUST_NM"],
        "source_tables": ["M_CUST_IND_INFO"],
        "is_custom_function": true,
        "custom_function_name": "PKG_DESEN.ENCRYPT_NAME"
      },
      {
        "target_column": "CUST_NM",
        "expression": "A.CUST_NM",
        "source_columns": ["CUST_NM"],
        "source_tables": ["M_CUST_IND_INFO"],
        "is_custom_function": false
      }
    ],
    "step_isolated_where": [
      {
        "raw_text": "A.ETL_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')",
        "tables_involved": ["M_CUST_IND_INFO"],
        "fields_involved": ["ETL_DT"]
      },
      {
        "raw_text": "A.IS_VALID = '1'",
        "tables_involved": ["M_CUST_IND_INFO"],
        "fields_involved": ["IS_VALID"]
      }
    ],
    "step_isolated_join": [
      {
        "raw_text": "LEFT JOIN TMP_ALB_TMP1 K ON K.CUSTOMER_NO = A.CUST_ID AND K.NUM = 1",
        "tables_involved": ["TMP_ALB_TMP1", "M_CUST_IND_INFO"],
        "fields_involved": ["CUSTOMER_NO", "CUST_ID", "NUM"]
      }
    ],
    "window_functions": [
      "ROW_NUMBER() OVER(PARTITION BY CUST_CODE ORDER BY CRT_DATE DESC)"
    ],
    "cte_definitions": [
      {
        "name": "TMP_ALB_TMP2",
        "definition": "SELECT /*+MATERIALIZE*/ CUST_CODE, CRT_DATE FROM ...",
        "consumed_in_step": 2
      }
    ],
    "group_by_clause": "",
    "having_clause": "",
    "distinct_flag": false,
    "set_operation": "",
    "order_by_clause": "",
    "custom_functions": [
      {
        "name": "PKG_DESEN.ENCRYPT_NAME",
        "signature": "PKG_DESEN.ENCRYPT_NAME(p_name IN VARCHAR2) RETURN VARCHAR2",
        "is_custom": true,
        "migration_risk": "HIGH",
        "risk_note": "自定义加密包，新环境需确认是否存在或需重写"
      }
    ],
    "raw_sql": "INSERT INTO M_CUST_IND_INFO_EAST (...) SELECT ... FROM M_CUST_IND_INFO A LEFT JOIN ... WHERE ...",
    "confidence": 0.95
  }
}
```

### 9.4 导出接口

```
POST /api/caliber/export
Content-Type: application/json

{
  "table": "RRP_EAST.EAST5_201_GRJCXXB",
  "field": "KHXM",
  "format": "markdown",        // markdown | word | html
  "include_sql": true,         // 是否包含原始 SQL
  "include_source_location": true  // 是否包含源码定位
}
```

**响应**：返回文件流（Content-Type 根据 format 不同设置），或返回 JSON 包含下载链接。

---

## 十、数据模型扩展

### 10.1 `CaliberInfo` 新增字段

```python
@dataclass
class CaliberInfo:
    # ... 保留所有现有字段 ...

    # ===== 新增字段 =====

    # 源码定位
    file_path: str = ""                    # 所属 .prc 文件路径
    start_line: int = 0                    # SQL 语句起始行号
    end_line: int = 0                      # SQL 语句结束行号

    # 单步隔离条件（替代累积条件）
    step_isolated_where: list[SQLCondition] = field(default_factory=list)  # 仅本步 WHERE
    step_isolated_join: list[SQLCondition] = field(default_factory=list)   # 仅本步 JOIN

    # CTE / WITH 定义
    cte_definitions: list[CTEDefinition] = field(default_factory=list)     # CTE 临时表定义

    # 自定义函数依赖
    custom_functions: list[FunctionDependency] = field(default_factory=list)  # 自定义函数列表

    # 完整表达式（优先于 transform_logic 使用）
    full_expression: str = ""              # 完整的 SELECT 表达式，如 PKG_DESEN.ENCRYPT_NAME(A.CUST_NM)
    is_custom_function_call: bool = False  # 是否调用了自定义函数
```

### 10.2 新增数据结构

```python
@dataclass
class CTEDefinition:
    """CTE / WITH 临时表定义"""
    name: str = ""                         # CTE 名称
    definition: str = ""                   # CTE 的 SELECT 定义
    source_tables: list[str] = field(default_factory=list)  # CTE 内引用的源表
    consumed_in_step: int = 0              # 在哪个步骤被消费
    start_line: int = 0                    # CTE 定义起始行号
    end_line: int = 0                      # CTE 定义结束行号


@dataclass
class FunctionDependency:
    """自定义函数依赖"""
    name: str = ""                         # 函数全名，如 PKG_DESEN.ENCRYPT_NAME
    signature: str = ""                    # 函数签名（如果能解析）
    is_custom: bool = True                 # 是否为自定义函数（vs 内置函数）
    migration_risk: str = "LOW"            # 迁移风险：LOW / MEDIUM / HIGH
    risk_note: str = ""                    # 风险说明
    definition_file: str = ""              # 函数定义所在文件（.fnc）


@dataclass
class SourceCodeLocation:
    """源码位置锚定"""
    file_path: str = ""                    # 文件路径
    start_line: int = 0                    # 起始行号
    end_line: int = 0                      # 结束行号
    can_open_file: bool = False            # 是否可在 IDE 中直接打开


@dataclass
class CaliberSummaryCard:
    """指标概览卡数据"""
    indicator: str = ""                    # 完整指标标识（SCHEMA.TABLE.FIELD）
    indicator_short: str = ""              # 短标识（TABLE.FIELD）
    business_caliber: str = ""             # 业务口径描述
    technical_caliber_summary: str = ""    # 技术口径摘要（一行文字）
    caliber_chain_text: list[str] = field(default_factory=list)  # 每步转换的文字描述
    stats: dict = field(default_factory=dict)  # 统计信息
    query_time_ms: float = 0.0


@dataclass
class PipelineNode:
    """Pipeline 视图节点"""
    id: str = ""                           # 唯一标识（表名或 表名.字段名）
    layer: str = ""                        # 数据分层
    label: str = ""                        # 显示标签
    field: str = ""                        # 关联字段名
    is_source: bool = False                # 是否为源头节点
    is_internal_transform: bool = False    # 是否为同表内字段转换
    transform_note: str = ""               # 转换说明


@dataclass
class PipelineEdge:
    """Pipeline 视图边"""
    id: str = ""                           # 步骤 ID
    source: str = ""                       # 源节点 ID
    target: str = ""                       # 目标节点 ID
    source_field: str = ""                 # 源字段
    target_field: str = ""                 # 目标字段
    expression: str = ""                   # 完整表达式
    procedure: str = ""                    # 所属存储过程
    step_num: int = 0                      # 步骤编号
    operation_type: str = ""               # 操作类型
    has_detail: bool = True                # 是否有详情可展开


@dataclass
class PipelineBranch:
    """Pipeline 视图分支"""
    merge_point: str = ""                  # 汇聚节点 ID
    source_node: str = ""                  # 分支来源节点 ID
    label: str = ""                        # 分支标签


@dataclass
class PipelineView:
    """Pipeline 完整视图"""
    nodes: list[PipelineNode] = field(default_factory=list)
    edges: list[PipelineEdge] = field(default_factory=list)
    branches: list[PipelineBranch] = field(default_factory=list)
```

---

## 十一、解析层增强详细设计

### 11.1 单语句边界切割

**问题**：当前 `_INSERT_INTO_PATTERN` 的正则匹配范围不精确，`sql_block` 可能包含多步内容或截断不完整。

**方案**：引入"语句边界检测器"，在 `_extract_all_sql_operations` 后对每个 `SQLOperation.sql_block` 做二次切割。

```python
class SQLBoundaryDetector:
    """单条 DML 语句边界切割器"""

    @staticmethod
    def split_sql_operations(content: str) -> list[str]:
        """将存储过程正文按 DML 语句边界切割，返回每条语句的文本块。

        切割规则：
          1. 以 INSERT / MERGE / UPDATE / DELETE / CREATE TABLE AS SELECT 为起始
          2. 以分号(;)或下一条 DML 起始为结束
          3. 跳过 PL/SQL 控制流（IF/ELSE/LOOP 等）但不切断语句
          4. 保持括号平衡（嵌套子查询不误切）
        """

    @staticmethod
    def extract_isolated_clauses(sql_block: str) -> dict:
        """从单条 SQL 中提取隔离的 WHERE / JOIN / GROUP BY。

        与 CaliberExtractor.extract_conditions() 的区别：
          - 只处理输入的单条 SQL，不做跨语句累积
          - 识别 FROM 子句中的主表和 JOIN 表，分别关联条件
          - 标注每个 WHERE 条件涉及的表别名

        Returns:
            {
                "main_from": "M_CUST_IND_INFO A",
                "joins": [
                    {"type": "LEFT JOIN", "table": "TMP_ALB_TMP1 K",
                     "condition": "K.CUSTOMER_NO = A.CUST_ID AND K.NUM = 1"}
                ],
                "where": [
                    {"text": "A.ETL_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')",
                     "aliases": ["A"]},
                    {"text": "A.IS_VALID = '1'", "aliases": ["A"]}
                ],
                "group_by": "",
                "having": ""
            }
        """
```

**实施位置**：新增 `core/sql_boundary_detector.py`，被 `CaliberExtractor` 和 `procedure_parser.py` 调用。

### 11.2 表达式完整保留

**问题**：当前 `FieldCleaner.parse_select_columns()` 在清洗时过度简化，丢失了函数嵌套结构。

**方案**：改进 SELECT 列解析器，保留完整表达式。

```python
class ExpressionParser:
    """SELECT 列表达式解析器"""

    @staticmethod
    def parse_select_list(select_text: str) -> list[SelectColumnMapping]:
        """解析 SELECT 列表，保留完整表达式。

        改进点（vs FieldCleaner.parse_select_columns）：
          1. 按括号深度切割逗号，不切断函数嵌套
          2. 保留完整的 source_expression，不做清洗/简化
          3. 正确识别 CASE WHEN ... END 整体为一个表达式
          4. 识别子查询表达式（SELECT ... FROM ...）并标记

        示例输入：
            TRIM(UPPER(A.CUST_NAME)) AS CUST_NM,
            PKG_DESEN.ENCRYPT_NAME(A.CUST_NM) AS CUST_NM_DESEN,
            CASE WHEN A.SEX = '1' THEN '男' ELSE '女' END AS SEX_DESC

        示例输出：
            [
                SelectColumnMapping(
                    source_expression="TRIM(UPPER(A.CUST_NAME))",
                    target_column="CUST_NM", alias="CUST_NM"),
                SelectColumnMapping(
                    source_expression="PKG_DESEN.ENCRYPT_NAME(A.CUST_NM)",
                    target_column="CUST_NM_DESEN", alias="CUST_NM_DESEN"),
                SelectColumnMapping(
                    source_expression="CASE WHEN A.SEX = '1' THEN '男' ELSE '女' END",
                    target_column="SEX_DESC", alias="SEX_DESC"),
            ]
        """
```

**实施位置**：新增 `core/expression_parser.py`，替代 `FieldCleaner.parse_select_columns()` 在口径场景中的调用。

### 11.3 CTE / WITH 追踪

**问题**：当前未解析 `WITH ... AS (...)` 语句。

**方案**：

```python
class CTEDetector:
    """CTE / WITH 临时表检测器"""

    _CTE_PATTERN = re.compile(
        r"\bWITH\s+(\w+)\s+AS\s*\(",
        re.IGNORECASE | re.DOTALL,
    )

    @staticmethod
    def extract_ctes(sql_block: str) -> list[CTEDefinition]:
        """从 SQL 块中提取所有 CTE 定义。

        解析逻辑：
          1. 匹配 WITH name AS ( ... ) 中的 name 和括号内定义
          2. 括号内容按深度匹配（嵌套子查询不误断）
          3. 提取 CTE 内部的 FROM / JOIN 表引用
          4. 记录 CTE 定义在原文件中的行号范围
        """

    @staticmethod
    def resolve_cte_references(sql_block: str, ctes: list[CTEDefinition]) -> list[str]:
        """解析后续 SQL 中对 CTE 的引用。

        场景：FROM tmp_alb_tmp2 → 识别为 CTE 引用，而非物理表。
        返回被引用的 CTE 名称列表。
        """
```

**实施位置**：新增 `core/cte_detector.py`，集成到 `CaliberExtractor.extract_enhanced_metadata()` 中。

### 11.4 函数依赖识别

**问题**：当前未识别自定义函数调用。

**方案**：

```python
class FunctionDetector:
    """自定义函数依赖识别器"""

    # 内置函数白名单（不需要标记迁移风险）
    BUILT_IN_FUNCTIONS = {
        "TRIM", "UPPER", "LOWER", "SUBSTR", "INSTR", "LENGTH",
        "TO_DATE", "TO_CHAR", "TO_NUMBER", "NVL", "NVL2",
        "DECODE", "CASE", "COALESCE", "ROW_NUMBER", "RANK",
        "DENSE_RANK", "SUM", "COUNT", "AVG", "MAX", "MIN",
        "LPAD", "RPAD", "REPLACE", "TRANSLATE", "ROUND",
    }

    _FUNCTION_CALL_PATTERN = re.compile(
        r"(\w+(?:\.\w+)?)\s*\(",  # 匹配 PKG_NAME.FUNC_NAME( 或 FUNC_NAME(
        re.IGNORECASE,
    )

    @staticmethod
    def detect_custom_functions(expression: str) -> list[FunctionDependency]:
        """从表达式中识别自定义函数调用。

        识别规则：
          1. 提取所有 function_call 模式
          2. 排除 SQL 关键字（SELECT, FROM, WHERE 等）
          3. 排除内置函数白名单
          4. 包含点号的调用（PKG.FUNC）直接标记为自定义
          5. 尝试在 .fnc 文件中查找函数定义

        迁移风险评估：
          - HIGH：PKG_*.FUNC_NAME() — 自定义包函数，新环境几乎肯定不存在
          - MEDIUM：独立自定义函数 — 可能需要迁移
          - LOW：仅使用内置函数
        """

    @staticmethod
    def scan_fnc_files(prc_dir: str) -> dict[str, str]:
        """扫描 .fnc 文件，建立函数名→文件路径映射。

        Returns: { "PKG_DESEN.ENCRYPT_NAME": "RRP_ORACLE/rrp_east/PKG_DESEN.fnc" }
        """
```

**实施位置**：新增 `core/function_detector.py`，在 `CaliberExtractor.build_caliber_info()` 中调用。

### 11.5 行号定位

**问题**：`CaliberInfo` 无源码位置字段。

**方案**：在 `_extract_all_sql_operations()` 中计算每个 `SQLOperation` 的行号范围。

```python
@dataclass
class SQLOperation:
    # ... 现有字段 ...
    start_line: int = 0    # 新增：SQL 块在文件中的起始行号
    end_line: int = 0      # 新增：SQL 块在文件中的结束行号
    file_path: str = ""    # 新增：所属文件路径
```

**计算方式**：

```python
def _calculate_line_range(content: str, match_start: int, match_end: int) -> tuple[int, int]:
    """根据字符偏移计算行号范围。"""
    start_line = content[:match_start].count('\n') + 1
    end_line = content[:match_end].count('\n') + 1
    return start_line, end_line
```

在 `_extract_all_sql_operations()` 中，对每个 `match` 调用 `_calculate_line_range()`，将结果写入 `SQLOperation.start_line / end_line`，再透传到 `CaliberInfo.file_path / start_line / end_line`。

---

## 十二、前端组件技术方案

### 12.1 整体架构

指标口径 Tab 前端重构为 3 个独立组件：

```
static/js/caliber/
├── summary-card.js      # 层级 1：指标概览卡
├── pipeline-view.js     # 层级 2：加工链路图
├── step-detail.js       # 层级 3：单步详情面板
└── caliber-export.js    # 导出功能
```

**组件通信**：

```
summary-card  ──(点击"查看加工链路")──→  pipeline-view
pipeline-view ──(点击节点/边)────────→  step-detail (右侧滑出)
step-detail   ──(点击"导出")──────────→  caliber-export
```

### 12.2 指标概览卡（summary-card.js）

**渲染方案**：纯 HTML/CSS 卡片组件，固定在指标口径 Tab 的顶部。

**核心功能**：
1. 调用 `GET /api/caliber/summary` 获取概览数据
2. 渲染指标标识、业务口径、技术口径摘要
3. 渲染链路统计（路径数、步骤数、涉及文件数）
4. 渲染数据质量标签（硬编码 / 跨库关联 / 自定义函数）
5. "查看加工链路" 按钮 → 触发 pipeline-view 渲染

**技术口径摘要渲染**：

```
TRIM(UPPER(CUST_NAME))  →  [MDL 脱敏]  →  [EAST 映射]  →  KHXM
     ODS层                    DWD层            DWS层          ADS层
```

使用 `<span class="caliber-step">` + CSS 箭头连接，每段可 hover 显示详情。

### 12.3 加工链路图（pipeline-view.js）

**渲染方案**：D3.js 横向流水线布局。

**核心功能**：
1. 调用 `GET /api/caliber/trace?mode=pipeline` 获取 Pipeline 数据
2. 横向布局：从左到右按 ODS → DWD → DWS → ADS 排列
3. 节点样式：
   - 普通节点：圆角矩形，显示表名+字段名
   - 同表内转换节点：虚线边框，标注"内部转换"
   - 源头节点：绿色边框
   - 目标节点：蓝色边框
4. 边样式：
   - 实线箭头 + 步骤编号标签
   - 点击边 → 展开单步详情
5. 分支路径：虚线箭头，标注分支来源
6. 交互：
   - 点击节点：高亮该节点所有上下游路径
   - 点击边：右侧滑出单步详情面板
   - 鼠标悬浮：显示 expression tooltip

**布局算法**：

```javascript
// 借鉴现有 lineage-graph.js 的 BFS 布局，但改为横向
function pipelineLayout(nodes, edges) {
    // 1. 按 layer_type 排列列：ODS → DWD → DWS → ADS
    // 2. 同列内按拓扑序排列
    // 3. 分支路径在汇聚点下方展示
    // 4. 同表内转换节点紧贴父节点下方
}
```

### 12.4 单步详情面板（step-detail.js）

**渲染方案**：右侧滑出面板（Drawer），固定宽度 480px。

**核心功能**：
1. 调用 `GET /api/caliber/step-detail` 获取单步数据
2. 分区展示：
   - 所属脚本（文件名 + 行号 + 操作类型）
   - 目标字段表达式（核心区域，语法高亮）
   - 源字段清单（表格形式，标注上游步骤）
   - 该步骤筛选条件（仅本步 WHERE）
   - 该步骤 JOIN 关系（仅本步 JOIN）
   - 窗口 / 聚合函数
   - CTE / 临时表定义
   - 自定义函数（迁移风险标签）
   - 原始 SQL（可折叠，语法高亮）
3. "复制 SQL" 按钮
4. "导出此步骤" 按钮

**表达式语法高亮**：

```javascript
// 简单的 SQL 语法高亮
function highlightExpression(expr) {
    return expr
        .replace(/(PKG_\w+\.\w+)/g, '<span class="custom-func">$1</span>')  // 自定义函数
        .replace(/\b(TRIM|UPPER|LOWER|SUBSTR|TO_DATE|NVL)\b/g, '<span class="builtin-func">$1</span>')  // 内置函数
        .replace(/\b(A|B|C)\.(\w+)/g, '<span class="alias-ref">$1</span>.<span class="column-ref">$2</span>')  // 别名.字段
}
```

### 12.5 导出功能（caliber-export.js）

**渲染方案**：调用 `POST /api/caliber/export`，下载生成的文件。

**支持的导出格式**：

| 格式 | 实现方式 | 说明 |
|------|---------|------|
| Markdown | 后端 Python 字符串拼接 | 最轻量，可直接贴入设计文档 |
| Word (.docx) | 后端 python-docx 库 | 带格式化的正式文档 |
| HTML | 后端 Jinja2 模板 | 可在浏览器中查看/打印 |

**Markdown 导出模板**：

```markdown
# 指标口径规格：{indicator}

## 技术口径摘要
{technical_caliber_summary}

## 加工链路
{caliber_chain_text}

## 逐步骤详情

### 步骤 1：{source_table}.{source_field} → {target_table}.{target_field}
- **操作类型**：{operation_type}
- **所属脚本**：{procedure}（{file_path}:{start_line}-{end_line}）
- **目标字段表达式**：`{full_expression}`
- **筛选条件**：{step_isolated_where}
- **关联条件**：{step_isolated_join}
- **自定义函数**：{custom_functions}
- **原始 SQL**：
```sql
{raw_sql}
```

---

## 数据质量标记
- 硬编码值：{has_hardcoded_values}
- 跨库关联：{has_cross_schema_join}
- 自定义函数：{custom_functions}

*生成时间：{timestamp}*
*数据血缘分析系统 v2.0*
```

---

## 十三、实施阶段分解

### Phase 1：解析层增强（预计 3-5 天）

| 序号 | 任务 | 交付物 | 验收标准 | 涉及文件 |
|------|------|--------|---------|---------|
| 1.1 | 新增 `SQLBoundaryDetector` | `core/sql_boundary_detector.py` | 单条 SQL 的 WHERE/JOIN 可从 `step_isolated_where/join` 获取，不再累积 | 新建 |
| 1.2 | 新增 `ExpressionParser` | `core/expression_parser.py` | `SelectColumnMapping.source_expression` 保留完整函数嵌套 | 新建 |
| 1.3 | 新增 `CTEDetector` | `core/cte_detector.py` | `WITH ... AS (...)` 被识别为 CTEDefinition | 新建 |
| 1.4 | 新增 `FunctionDetector` | `core/function_detector.py` | `PKG_DESEN.ENCRYPT_NAME()` 被标记为自定义函数，迁移风险 HIGH | 新建 |
| 1.5 | 扩展 `CaliberInfo` 数据模型 | `core/models.py` | 新增 `file_path/start_line/end_line/step_isolated_where/join/cte_definitions/custom_functions/full_expression` | 修改 |
| 1.6 | 新增 `CTEDefinition / FunctionDependency / SourceCodeLocation / CaliberSummaryCard / PipelineNode / PipelineEdge / PipelineBranch / PipelineView` 数据结构 | `core/models.py` | 类型定义完整，`to_dict()` / `from_dict()` 可用 | 修改 |
| 1.7 | 集成到 `CaliberExtractor` | `core/caliber_extractor.py` | `build_caliber_info()` 输出包含新字段数据 | 修改 |
| 1.8 | 集成到 `procedure_parser.py` | `core/procedure_parser.py` | `SQLOperation` 包含 `start_line/end_line/file_path`，`extract_caliber_from_proc()` 使用新解析器 | 修改 |
| 1.9 | 单元测试 | `tests/test_sql_boundary.py` / `tests/test_expression_parser.py` / `tests/test_cte_detector.py` / `tests/test_function_detector.py` | 覆盖主要场景，CTE/自定义函数识别准确率 > 90% | 新建 |

### Phase 2：API 层扩展（预计 2-3 天）

| 序号 | 任务 | 交付物 | 验收标准 | 涉及文件 |
|------|------|--------|---------|---------|
| 2.1 | 新增 `/api/caliber/summary` 接口 | `api_server.py` | 返回 CaliberSummaryCard 结构 | 修改 |
| 2.2 | 扩展 `/api/caliber/trace?mode=pipeline` | `api_server.py` | 返回 PipelineView 结构 | 修改 |
| 2.3 | 新增 `/api/caliber/step-detail` 接口 | `api_server.py` | 返回单步详情 JSON | 修改 |
| 2.4 | 新增 `/api/caliber/export` 接口 | `api_server.py` + `core/caliber_exporter.py` | 支持 markdown / word / html 导出 | 修改+新建 |
| 2.5 | 实现导出引擎 | `core/caliber_exporter.py` | Markdown / HTML / Word 三种格式可用 | 新建 |
| 2.6 | API 测试 | `tests/test_caliber_api.py` | 所有新接口响应结构正确 | 新建 |

### Phase 3：前端重构（预计 4-6 天）

| 序号 | 任务 | 交付物 | 验收标准 | 涉及文件 |
|------|------|--------|---------|---------|
| 3.1 | 新增 `summary-card.js` | `static/js/caliber/summary-card.js` + `static/css/caliber.css` | 概览卡正确渲染，技术口径摘要可见 | 新建 |
| 3.2 | 新增 `pipeline-view.js` | `static/js/caliber/pipeline-view.js` | 横向流水线图渲染，节点/边可点击 | 新建 |
| 3.3 | 新增 `step-detail.js` | `static/js/caliber/step-detail.js` | 右侧滑出面板，表达式语法高亮 | 新建 |
| 3.4 | 新增 `caliber-export.js` | `static/js/caliber/caliber-export.js` | 导出按钮 → 下载文件 | 新建 |
| 3.5 | 集成到 `index.html` | `static/index.html` | 指标口径 Tab 加载新组件 | 修改 |
| 3.6 | 样式优化 | `static/css/caliber.css` | 浅色风格统一，响应式适配 | 新建 |
| 3.7 | E2E 测试 | 手动验证 | 查询 EAST5_201_GRJCXXB.KHXM，三层视图正确联动 | - |

### 里程碑验收

| 里程碑 | 验收标准 |
|--------|---------|
| **Phase 1 完成** | `GET /api/caliber/trace` 返回的 `CaliberInfo` 包含 `step_isolated_where/join`、`full_expression`、`file_path/start_line/end_line`、`custom_functions`、`cte_definitions` |
| **Phase 2 完成** | 四个新 API 接口可用；Markdown 导出结果可读且包含完整信息 |
| **Phase 3 完成** | 查询 `EAST5_201_GRJCXXB.KHXM`：概览卡显示技术口径摘要 → 点击查看 Pipeline → 点击步骤 2 查看详情面板 → 导出为 Markdown。全流程无断点 |

---

## 十四、风险与应对

| 风险 | 概率 | 影响 | 应对 |
|------|------|------|------|
| Oracle SQL 方言复杂，正则解析覆盖不全 | 高 | 部分 CTE / 嵌套子查询解析失败 | 采用"尽力解析 + 降级展示原始 SQL"策略；预留 10% 的 fallback 率 |
| `FieldCleaner` 改动影响现有字段映射 | 中 | 展示层血缘图回归 | Phase 1 不修改 FieldCleaner，ExpressionParser 作为独立模块，口径场景走新路径 |
| D3.js Pipeline 布局在大量节点时性能差 | 低 | 页面卡顿 | 限制 Pipeline 最大节点数为 20；超出时折叠中间层 |
| python-docx 导出 Word 格式不美观 | 低 | 用户体验差 | 优先实现 Markdown 导出，Word 作为后续优化 |
| .fnc 文件格式不规范，函数签名提取失败 | 中 | FunctionDetector 无法自动匹配 | 允许函数签名字段为空，仅标记函数名和迁移风险 |

---

## 十五、附录：关键查询示例对照

### 示例 1：`EAST5_201_GRJCXXB.KHXM`（客户姓名）

**当前输出**（CaliberResult chains 格式）：
```
Step 1: O_ICL_CMM_INDV_CUST_BASIC_INFO.CUST_NAME → M_CUST_IND_INFO.CUST_NM
  WHERE: A.ETL_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD') AND A.IS_VALID = '1'
         ... (82 条累积条件)
  JOIN: ... (45 条累积 JOIN)

Step 2: M_CUST_IND_INFO.CUST_NM → M_CUST_IND_INFO_EAST.CUST_NM_DESEN
  transform_logic: "DIRECT"
```

**目标输出**（新方案）：
```
概览卡：TRIM(UPPER(CUST_NAME)) → [脱敏] → [映射] → KHXM

Pipeline：O_ICL → M_CUST_IND → M_CUST_IND_EAST.CUST_NM → .CUST_NM_DESEN → EAST5_201

步骤 2 详情：
  表达式：CUST_NM_DESEN = PKG_DESEN.ENCRYPT_NAME(A.CUST_NM)  ← 自定义函数 ⚠️
  本步 WHERE：A.ETL_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD') AND A.IS_VALID = '1'  ← 仅 2 条
  本步 JOIN：LEFT JOIN TMP_ALB_TMP1 K ON K.CUSTOMER_NO = A.CUST_ID AND K.NUM = 1
  文件：P_M_CUST_IND_INFO_EAST.prc:142-189
```

---

*文档版本：v2.0*
*生成日期：2026-05-14*
*适用项目：数据血缘分析系统 v2.0*
*更新说明：新增第八~十五章，补充现有能力盘点、API 接口设计、数据模型扩展、解析层增强详细设计、前端组件技术方案、导出功能设计、实施阶段分解、风险应对*
