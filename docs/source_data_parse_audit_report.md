# SOURCE_DATA 解析、检查与展示一致性问题报告

生成日期：2026-06-12  
测试范围：`SOURCE_DATA/` 当前全部注册系统及默认启用系统  
测试方式：使用项目 `.venv/bin/python` 强制全量解析，并将临时缓存写入 `/private/tmp/source_data_audit/`，避免覆盖项目 `output/lineage.db`。

## 结论摘要

当前 `SOURCE_DATA` 中的脚本并未达到“按系统正确解析、检查分析与展示一致”的状态。

主要问题：

1. EDW、MCS、FDM 独立解析均有数据产出，但级联展示接口显示为 0 张表。
2. FDM 根注册表与系统 manifest 的解析器配置冲突，导致财务指标配置未按 `indicator` 路径解析。
3. 全量合并结果少于分系统独立解析合计，字段映射、口径信息存在明显合并丢失或过度去重风险。
4. 数据完整性校验产生 181,246 条 warning，集中在未知引用表、SQL 别名误识别、自环血缘和临时表未注册。

## 复现命令

```bash
.venv/bin/python - <<'PY'
# 见 /private/tmp/source_data_audit/summary.json 生成脚本
PY
```

本次保留的证据文件：

- `/private/tmp/source_data_audit/summary.json`：全量解析、校验、展示统计与样本查询。
- `/private/tmp/source_data_audit/per_source_summary.json`：分系统独立解析统计。
- `/private/tmp/source_data_audit/probe_queries.json`：使用分系统样本表对全量血缘服务进行查询。
- `/private/tmp/source_data_audit/validator_distribution.json`：校验 warning 分布。

## 源系统与文件盘点

| 系统 | 根注册状态 | 文件类型与数量 | 备注 |
| --- | --- | ---: | --- |
| RRP | enabled | `.tab` 3041, `.prc` 1784, `.fnc` 18, `.seq` 4 | 根 manifest 只注册 `.tab/.prc`，`.fnc/.seq` 未参与解析 |
| EDW | enabled | `.sql` 20680 | 默认启用 |
| MCS | enabled | `.sql` 775 | 默认启用，根 manifest 还声明 `.conf` 但当前无 `.conf` 文件 |
| FDM | enabled | `.sql` 717, `.xlsx` 1 | 根 manifest 配置为 `warehouse`，系统 manifest 配置为 `indicator` |
| PAM | enabled | `.sql` 2 | 默认启用，PAM 专用解析器 |
| TDH | disabled | 仅 `manifest.yml` | 目录存在但无脚本 |
| GBASE | disabled | 仅 `manifest.yml` | 目录存在但无脚本 |
| CCR | disabled | 仅 `manifest.yml` | 目录存在但无脚本 |
| ICR | disabled | 仅 `manifest.yml` | 目录存在但无脚本 |
| BRT | disabled | 仅 `manifest.yml` | 目录存在但无脚本 |

## 全量解析结果

强制全量解析耗时约 239.3 秒，服务级汇总如下：

| 指标 | 数量 |
| --- | ---: |
| 表 | 20,907 |
| 过程 | 6,105 |
| 表级血缘 | 133,797 |
| 字段映射 | 90,321 |
| 口径信息 | 76,682 |
| 解析错误 | 0 |
| 校验错误 | 0 |
| 校验 warning | 181,246 |
| 校验 info | 1 |

解析过程没有报错，但校验和展示结果显示存在数据质量与归属问题。

## 分系统抽样与展示一致性

分系统独立解析结果：

| 系统 | 独立解析表 | 独立解析过程 | 独立表级血缘 | 独立字段映射 | 展示系统表数 |
| --- | ---: | ---: | ---: | ---: | ---: |
| RRP | 3,041 | 1,784 | 27,589 | 103,932 | 10,323 |
| EDW | 6,129 | 3,084 | 98,407 | 410 | 0 |
| MCS | 440 | 263 | 2,200 | 4,682 | 0 |
| FDM | 713 | 0 | 0 | 0 | 0 |
| PAM | 10,584 | 1,004 | 9,785 | 18,535 | 10,584 |

展示接口样本：

| 系统 | `/api/systems` 表数 | `/api/systems/{system}/tables` 样本 |
| --- | ---: | --- |
| RRP | 10,323 | `IDL.BASE_D_ACCT_CLASS_BUS`, `IDL.ALGORITHM_CONFIGUARTION` |
| EDW | 0 | 空 |
| MCS | 0 | 空 |
| FDM | 0 | 空 |
| PAM | 10,584 | `PAM.A`, `PAM.ACT_EVT_LOG` |

直接使用分系统样本表查询全量血缘服务：

| 系统样本 | 查询表 | 结果 |
| --- | --- | --- |
| RRP | `RRP_EAST.EAST5_1001_HLXXB` | 11 节点 / 10 边 |
| EDW | `ICL.CMM_ABS_BASE_ASSET_INFO` | 46 节点 / 45 边 |
| MCS | `IDL.MCYY_HUMAN_RISK_REALTIME` | 29 节点 / 28 边 |
| FDM | `IDL.FDL_PAMS_STD_PROD_INFO` | 1 节点 / 0 边 |
| PAM | `PAM.NBZZ_ZQLZMX` | 14 节点 / 13 边 |

说明：EDW/MCS 的血缘数据在全量服务中可查，但从级联展示入口不可见；FDM 只解析出表结构，没有血缘。

## 问题清单

### P1：EDW/MCS/FDM 解析产出被展示层错误归属

现象：

- EDW 独立解析：6,129 表、98,407 条表级血缘。
- MCS 独立解析：440 表、2,200 条表级血缘。
- FDM 独立解析：713 表。
- 但展示层 `get_systems()` 中 EDW/MCS/FDM 都是 0 表。

根因定位：

- `app/services/table_query_service.py:181-210` 只把 `schema_dirs` 和数据源名映射到系统。
- EDW 实际解析出的 schema 是 `ICL/IDL/IML/IOL`，MCS 实际解析出的 schema 是 `IDL/ITL/MSL`，FDM 实际解析出的 schema 是 `IDL/IML/ITL`。
- 这些 schema 没有映射到 EDW/MCS/FDM，随后被 `unknown_schemas` 统一归到第一个 Oracle 系统 RRP。

影响：

- EDW/MCS/FDM 在级联选择器不可用。
- RRP 展示表数被污染，显示为 10,323，远高于 RRP 独立解析的 3,041 张表。
- 同名 schema 如 `IDL` 同时出现在 EDW/MCS/FDM，当前仅按 schema 归属无法区分来源系统。

### P1：FDM 配置冲突，指标链路未按系统 manifest 解析

现象：

- `SOURCE_DATA/manifest.yml:26-31` 将 FDM 配置为 `parser: warehouse`。
- `SOURCE_DATA/FDM/manifest.yml:6` 将 FDM 配置为 `parser: indicator`。
- 本次运行中 `config.datasource_configs` 实际采用根注册表，FDM 走 `warehouse`。
- FDM 独立解析结果为 713 表、0 过程、0 表级血缘、0 字段映射。

影响：

- `SOURCE_DATA/FDM/config/财务指标查询.xlsx` 没有进入指标适配器路径。
- FDM 指标配置与算法关系没有进入统一血缘图谱。
- 前端展示 FDM 为空，且直接查询 FDM 样本表也只有孤立节点。

### P1：全量合并结果少于分系统独立解析合计

分系统独立解析合计与全量解析对比：

| 指标 | 分系统合计 | 全量结果 | 差值 |
| --- | ---: | ---: | ---: |
| 表 | 20,907 | 20,907 | 0 |
| 过程 | 6,135 | 6,105 | 30 |
| 表级血缘 | 137,981 | 133,797 | 4,184 |
| 字段映射 | 127,559 | 90,321 | 37,238 |
| 口径信息 | 283,831 | 76,682 | 207,149 |

根因风险：

- `app/services/parser_service.py:178-182` 的字段映射去重键为 `(source_table, source_column, target_table, target_column)`，没有包含 `procedure`、转换表达式或系统来源。
- 多个过程内相同字段映射会被全量合并压缩，导致字段级分析与独立解析不一致。
- `app/services/parser_service.py:184-194` 对口径信息也做合并去重，实际压缩幅度达到 207,149 条，需要确认这些是否都是语义重复。

影响：

- 字段级血缘、口径详情和检查分析不再等于各系统真实解析产出的合计。
- 若用户按过程追溯，可能缺少某些过程下的字段映射或口径步骤。

### P2：完整性校验 warning 规模过大

本次校验：

- errors：0
- warnings：181,246
- info：`有 18546 张表无字段映射（可能仅作为源表）`

warning 分布样本：

| 类型 | Top schema / 来源 | 数量样例 |
| --- | --- | ---: |
| 字段映射未知源表 | `IOL` | 18,028 |
| 字段映射未知源表 | `IML` | 11,260 |
| 字段映射未知源表 | `ICL` | 7,526 |
| 字段映射未知目标表 | `PAM` | 3,288 |
| 表级血缘未知源表 | `[none]` | 68,453 |
| 表级血缘未知源表 | `T1` | 12,371 |
| 表级血缘未知目标表 | `RRP_MDL` | 8,266 |
| 自环血缘 | `IOL` | 1,703 |
| 自环血缘 | `PAM` | 648 |

典型未知引用：

- `CHR`
- `IOL.V_CRSS_BUSINESS_CONTRACT`
- `RRP_MDL.TMP1`
- `O.SRC_TABLE_NAME`
- `ICL.V_CMM_UNITE_WL_DUBIL_INFO`

影响：

- 部分 warning 可能是外部源表、视图、临时表或 SQL 别名，但当前校验不区分这些类型。
- 大量 `[none]`、`T1`、`O` 这类引用显示解析器可能把别名或字段误识别为表。
- 校验结果过噪，会掩盖真实缺表和断链问题。

### P2：目录存在但禁用系统未参与“所有系统”验证

TDH、GBASE、CCR、ICR、BRT 目录存在，但根注册表 `enabled: false`，且当前目录只有 manifest，没有业务脚本。

影响：

- 若用户理解的“所有系统”是 `SOURCE_DATA/` 下所有目录，当前运行只验证了默认启用系统。
- 若这些系统后续补充脚本，必须更新根注册表启用状态或环境变量，否则不会进入解析链路。

## 建议修复方向

1. 为解析结果增加稳定的 `system` 来源字段，并在表、过程、血缘、字段映射中贯穿保存。
2. 级联展示不要只用 schema 推断系统；应优先使用解析时来源系统，schema 只作为系统内层级。
3. 统一根 `SOURCE_DATA/manifest.yml` 与子系统 `manifest.yml` 的 parser 定义，尤其修正 FDM 的 `warehouse`/`indicator` 冲突。
4. 调整 `ParseResult.merge()` 去重键，至少字段映射应包含 `procedure` 和必要的转换上下文；口径信息应先区分“语义重复”与“不同步骤被压缩”。
5. 对校验器增加引用分类：外部源、视图、临时表、别名疑似、真实缺表，降低 warning 噪声。
6. 针对 EDW、MCS、FDM、PAM、RRP 增加固定样本回归测试，覆盖：
   - 分系统解析产出不为空；
   - `/api/systems` 表数与解析来源一致；
   - `/api/systems/{system}/tables` 能返回样本表；
   - 样本表血缘查询有可解释结果；
   - 全量合并不丢失跨过程字段映射。

