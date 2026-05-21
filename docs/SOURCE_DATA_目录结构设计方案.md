# 数据源目录结构整合设计方案

> **模型信息**: SOLO (Trae), 上下文窗口 ~200K tokens
>
> **版本**: v1.1 | **日期**: 2026-05-21

---

## 一、现状问题分析

### 1.1 当前数据源分布

| 数据源 | 当前路径 | 文件类型 | 归属系统 |
|--------|---------|---------|---------|
| Oracle 导出文件 | `RRP_ORACLE/` | `.tab`, `.prc` | 监管报送平台 |
| 数仓脚本 | `AI指标血缘分析_数仓&管架/数仓脚本/` | `.sql`, `.ctl` | 企业级数据仓库 |
| 管架脚本 | `AI指标血缘分析_数仓&管架/管架脚本/` | `.sql`, `.conf` | 绩效管理平台 |
| 财务指标配置 | `财务集市指标血缘分析/指标/` | `.xlsx`, `.proc` | 财务数据集市 |
| TDH 星环 | 环境变量动态注入 | `.hql`, `.sql` | TDH 大数据平台 |
| GBase 南大通用 | 环境变量动态注入 | `.sql` | GBase 数据库 |

### 1.2 存在的问题

1. **命名不统一**: 目录名混合了中英文、业务术语与技术术语（如 `AI指标血缘分析_数仓&管架`）
2. **层级混乱**: 数仓和管架脚本放在同一目录下，但属于不同业务系统
3. **路径硬编码**: `dependencies.py` 中财务指标路径直接拼接（`base_dir / "财务集市指标血缘分析" / "指标"`）
4. **扩展性差**: 新增数据源需要修改多处代码（config.py + dependencies.py）
5. **缺乏元数据**: 数据源没有自描述能力，无法自动发现和校验

---

## 二、设计原则

| 原则 | 说明 |
|------|------|
| **统一入口** | 所有原始数据统一存放于 `SOURCE_DATA/` 根目录 |
| **系统分类** | 按业务系统一级分类，每个系统独立目录 |
| **分层一致** | 每个系统内部采用统一的 `ddl/` + `dml/` + `config/` 分层结构 |
| **自描述** | 每个数据源目录包含 `manifest.yml` 元数据描述文件 |
| **配置驱动** | 数据源发现与注册由配置文件驱动，减少硬编码 |
| **向后兼容** | 提供迁移脚本，旧路径可通过符号链接兼容 |

---

## 三、目标目录结构

```
DATA_RELY_ANALYSIS_SYS/
│
├── SOURCE_DATA/                              # 统一数据源根目录
│   ├── manifest.yml                          # 全局数据源注册表
│   │
│   ├── RRP/                                  # 监管报送平台 (Regulatory Reporting Platform)
│   │   ├── manifest.yml                      # 数据源元数据描述
│   │   ├── ddl/                              # 表结构定义
│   │   │   ├── rrp_mdl/                      # MDL 模型层
│   │   │   │   ├── *.tab                     # 建表脚本
│   │   │   │   └── ...
│   │   │   └── rrp_east/                     # EAST 报送层
│   │   │       ├── *.tab
│   │   │       └── ...
│   │   └── dml/                              # 数据加工逻辑
│   │       ├── rrp_mdl/
│   │       │   ├── *.prc                     # 存储过程
│   │       │   └── ...
│   │       └── rrp_east/
│   │           ├── *.prc
│   │           └── ...
│   │
│   ├── EDW/                                  # 企业级数据仓库 (Enterprise Data Warehouse)
│   │   ├── manifest.yml
│   │   ├── ddl/                              # 建表脚本 (按数仓分层)
│   │   │   ├── icl/                          # ICL 核心账务层
│   │   │   │   └── *.sql
│   │   │   ├── idl/                          # IDL 接口明细层
│   │   │   │   └── *.sql
│   │   │   ├── iml/                          # IML 中间模型层
│   │   │   │   └── *.sql
│   │   │   └── iol/                          # IOL 操作层
│   │   │       └── *.sql
│   │   ├── dml/                              # 跑批脚本 (按数仓分层)
│   │   │   ├── icl/
│   │   │   ├── idl/
│   │   │   ├── iml/
│   │   │   └── iol/
│   │   └── config/                           # 配置文件
│   │       └── 数仓视图逻辑.xlsx
│   │
│   ├── MCS/                                  # 管理驾驶舱 (Management Cockpit System / 原管架)
│   │   ├── manifest.yml
│   │   ├── ddl/
│   │   │   ├── idl/                          # IDL 建表脚本
│   │   │   │   └── *.sql
│   │   │   └── itl/                          # ITL 建表脚本
│   │   │       └── *.sql
│   │   ├── dml/
│   │   │   ├── idl/                          # IDL 跑批脚本
│   │   │   │   └── *.sql
│   │   │   └── itl/                          # ITL 跑批脚本
│   │   │       └── *.sql
│   │   ├── ext/                              # 外部系统抽数
│   │   │   ├── hgls/                         # 核心系统卸数
│   │   │   ├── orws/                         # 运维系统卸数
│   │   │   └── *.conf                        # 卸数标记配置
│   │   └── config/
│   │       └── 管架脚本表级血缘关系.xlsx
│   │
│   ├── FDM/                                  # 财务数据集市 (Financial Data Mart)
│   │   ├── manifest.yml
│   │   ├── config/                           # 指标配置
│   │   │   └── 财务指标查询.xlsx
│   │   └── dml/                              # 指标加工存储过程
│   │       └── *.proc
│   │
│   ├── PAM/                                  # 绩效考核系统 (Performance Appraisal Management / 预留)
│   │   ├── manifest.yml
│   │   ├── ddl/
│   │   ├── dml/
│   │   └── config/
│   │
│   ├── CCR/                                  # 公司经营管理平台 (Corporate Comprehensive Management / 预留)
│   │   ├── manifest.yml
│   │   ├── ddl/
│   │   ├── dml/
│   │   └── config/
│   │
│   ├── ICR/                                  # 同业经营管理平台 (Interbank Comprehensive Management / 预留)
│   │   ├── manifest.yml
│   │   ├── ddl/
│   │   ├── dml/
│   │   └── config/
│   │
│   ├── BRT/                                  # 零售经营管理平台 (Branch Retail Management / 预留)
│   │   ├── manifest.yml
│   │   ├── ddl/
│   │   ├── dml/
│   │   └── config/
│   │
│   ├── TDH/                                  # TDH 星环大数据平台 (可选)
│   │   ├── manifest.yml
│   │   ├── ddl/
│   │   │   ├── dw/
│   │   │   └── ods/
│   │   └── dml/
│   │       ├── dw/
│   │       └── ods/
│   │
│   └── GBASE/                                # GBase 南大通用 (可选)
│       ├── manifest.yml
│       ├── ddl/
│       │   ├── dws/
│       │   └── ads/
│       └── dml/
│           ├── dws/
│           └── ads/
│
├── app/                                      # FastAPI 应用层 (不变)
├── core/                                     # 核心解析引擎 (不变)
├── static/                                   # 前端静态资源 (不变)
├── tests/                                    # 测试用例 (不变)
├── output/                                   # 解析结果缓存输出 (不变)
├── temp_uploads/                             # 上传临时目录 (不变)
├── scripts/                                  # 辅助脚本 (不变)
├── deprecated/                               # 废弃代码 (不变)
│
├── run_app.py                                # 运行入口
├── pyproject.toml
├── requirements.txt
└── ...
```

---

## 四、系统分类编码说明

| 编码 | 全称 | 中文 | 说明 |
|------|------|------|------|
| `RRP` | Regulatory Reporting Platform | 监管报送平台 | 原 `RRP_ORACLE/`，Oracle 导出的 .tab/.prc 文件 |
| `EDW` | Enterprise Data Warehouse | 企业级数据仓库 | 原 `数仓脚本/`，数仓分层 DDL/DML 脚本 |
| `MCS` | Management Cockpit System | 管理驾驶舱 | 原 `管架脚本/`，管架绩效指标加工脚本 |
| `FDM` | Financial Data Mart | 财务数据集市 | 原 `财务集市指标血缘分析/`，财务指标配置与算法 |
| `TDH` | Transwarp Data Hub | TDH 星环平台 | 可选，通过环境变量或 manifest 启用 |
| `GBASE` | GBase Database | GBase 南大通用 | 可选，通过环境变量或 manifest 启用 |

---

## 五、manifest.yml 元数据规范

### 5.1 全局注册表 `SOURCE_DATA/manifest.yml`

```yaml
version: "1.0"
description: "数据血缘分析系统 - 数据源注册表"

sources:
  - name: rrp
    display_name: "监管报送平台"
    path: RRP
    enabled: true
    file_extensions: [".tab", ".prc"]
    parser: oracle

  - name: edw
    display_name: "企业级数据仓库"
    path: EDW
    enabled: true
    file_extensions: [".sql", ".ctl"]
    parser: warehouse

  - name: mcs
    display_name: "管理驾驶舱"
    path: MCS
    enabled: true
    file_extensions: [".sql", ".conf"]
    parser: warehouse

  - name: fdm
    display_name: "财务数据集市"
    path: FDM
    enabled: true
    file_extensions: [".xlsx", ".proc"]
    parser: indicator

  - name: tdh
    display_name: "TDH星环大数据平台"
    path: TDH
    enabled: false
    file_extensions: [".hql", ".sql"]
    parser: warehouse
    env_override:
      enabled: TDH_DATA_DIR

  - name: gbase
    display_name: "GBase南大通用"
    path: GBASE
    enabled: false
    file_extensions: [".sql"]
    parser: warehouse
    env_override:
      enabled: GBASE_DATA_DIR
```

### 5.2 数据源级 manifest `SOURCE_DATA/{SYSTEM}/manifest.yml`

以 `SOURCE_DATA/RRP/manifest.yml` 为例：

```yaml
version: "1.0"
system: rrp
display_name: "监管报送平台"
description: "监管报送平台 Oracle 数据库导出文件，包含表结构与存储过程定义"

schemas:
  - name: rrp_mdl
    display_name: "MDL 模型层"
    description: "监管报送模型层表定义与加工逻辑"
    ddl_path: ddl/rrp_mdl
    dml_path: dml/rrp_mdl

  - name: rrp_east
    display_name: "EAST 报送层"
    description: "EAST 监管报送层表定义与加工逻辑"
    ddl_path: ddl/rrp_east
    dml_path: dml/rrp_east

file_extensions:
  ddl: [".tab"]
  dml: [".prc"]

parser: oracle
```

---

## 六、新旧路径映射表

| 旧路径 | 新路径 | 说明 |
|--------|--------|------|
| `RRP_ORACLE/rrp_mdl/*.tab` | `SOURCE_DATA/RRP/ddl/rrp_mdl/*.tab` | 表结构文件 |
| `RRP_ORACLE/rrp_mdl/*.prc` | `SOURCE_DATA/RRP/dml/rrp_mdl/*.prc` | 存储过程文件 |
| `RRP_ORACLE/rrp_east/*.tab` | `SOURCE_DATA/RRP/ddl/rrp_east/*.tab` | 表结构文件 |
| `RRP_ORACLE/rrp_east/*.prc` | `SOURCE_DATA/RRP/dml/rrp_east/*.prc` | 存储过程文件 |
| `AI指标血缘分析_数仓&管架/数仓脚本/ddl/icl/` | `SOURCE_DATA/EDW/ddl/icl/` | 数仓 ICL 层建表 |
| `AI指标血缘分析_数仓&管架/数仓脚本/ddl/idl/` | `SOURCE_DATA/EDW/ddl/idl/` | 数仓 IDL 层建表 |
| `AI指标血缘分析_数仓&管架/数仓脚本/ddl/iml/` | `SOURCE_DATA/EDW/ddl/iml/` | 数仓 IML 层建表 |
| `AI指标血缘分析_数仓&管架/数仓脚本/ddl/iol/` | `SOURCE_DATA/EDW/ddl/iol/` | 数仓 IOL 层建表 |
| `AI指标血缘分析_数仓&管架/管架脚本/ddl/idl/` | `SOURCE_DATA/MCS/ddl/idl/` | 管架 IDL 层建表 |
| `AI指标血缘分析_数仓&管架/管架脚本/ddl/itl/` | `SOURCE_DATA/MCS/ddl/itl/` | 管架 ITL 层建表 |
| `AI指标血缘分析_数仓&管架/管架脚本/dml/idl/` | `SOURCE_DATA/MCS/dml/idl/` | 管架 IDL 层跑批 |
| `AI指标血缘分析_数仓&管架/管架脚本/dml/itl/` | `SOURCE_DATA/MCS/dml/itl/` | 管架 ITL 层跑批 |
| `AI指标血缘分析_数仓&管架/管架脚本/ext/` | `SOURCE_DATA/MCS/ext/` | 管架外部抽数 |
| `财务集市指标血缘分析/指标/财务指标查询.xlsx` | `SOURCE_DATA/FDM/config/财务指标查询.xlsx` | 财务指标配置 |
| `财务集市指标血缘分析/指标/*.proc` | `SOURCE_DATA/FDM/dml/*.proc` | 财务指标加工过程 |

---

## 七、配置层改造方案

### 7.1 config.py 改造要点

```python
# 改造前: 硬编码多个 DataSourceConfig
datasource_configs: list[DataSourceConfig] = field(default_factory=lambda: [
    DataSourceConfig(name="oracle", data_dir="RRP_ORACLE", ...),
    DataSourceConfig(name="warehouse", data_dir="AI指标血缘分析_数仓&管架", ...),
])

# 改造后: 从 manifest.yml 自动发现与注册
datasource_configs: list[DataSourceConfig] = field(
    default_factory=lambda: DataSourceConfig.from_manifest(
        get_base_dir() / "SOURCE_DATA" / "manifest.yml"
    )
)
```

### 7.2 DataSourceConfig 扩展

```python
@dataclass
class DataSourceConfig:
    name: str
    display_name: str
    data_dir: str
    schema_dirs: list[str]
    file_extensions: list[str]
    parser_type: str = "warehouse"       # 新增: 解析器类型
    ddl_dir: str = "ddl"                 # 新增: DDL 子目录
    dml_dir: str = "dml"                 # 新增: DML 子目录
    config_dir: str = "config"           # 新增: 配置子目录
    enabled: bool = True                 # 新增: 是否启用

    @classmethod
    def from_manifest(cls, manifest_path: Path) -> list["DataSourceConfig"]:
        """从 manifest.yml 自动加载数据源配置"""
        ...
```

### 7.3 dependencies.py 改造要点

```python
# 改造前: 硬编码路径拼接
indicator_data_path = base_dir / "财务集市指标血缘分析" / "指标"

# 改造后: 从配置中动态获取
fdm_config = next(c for c in config.datasource_configs if c.name == "fdm")
indicator_data_path = config.base_dir / "SOURCE_DATA" / fdm_config.data_dir / fdm_config.config_dir
```

---

## 八、迁移策略

### 8.1 阶段一: 目录迁移 (低风险)

1. 创建 `SOURCE_DATA/` 及各系统子目录
2. 将现有数据文件按映射表复制到新路径
3. 编写 `manifest.yml` 文件
4. 旧目录保留，通过符号链接指向新路径 (兼容期)

```bash
# 示例: 创建兼容符号链接
ln -s SOURCE_DATA/RRP RRP_ORACLE
ln -s SOURCE_DATA/EDW "AI指标血缘分析_数仓&管架/数仓脚本"
```

### 8.2 阶段二: 配置层改造 (中风险)

1. 改造 `config.py`，支持从 `manifest.yml` 加载配置
2. 改造 `dependencies.py`，消除硬编码路径
3. 扩展 `DataSourceConfig`，增加 `parser_type` / `ddl_dir` / `dml_dir` 等字段
4. 保留环境变量覆盖能力

### 8.3 阶段三: 解析器适配 (中风险)

1. 改造 `ParserService`，支持按 `parser_type` 分发到对应解析器
2. 改造 `WarehouseSQLParser`，支持从 `ddl/` + `dml/` 子目录读取
3. 改造 `IndicatorConfigParser`，支持从 `FDM/config/` 读取
4. 清理旧符号链接

### 8.4 阶段四: 验证与清理 (低风险)

1. 全量回归测试，确保血缘解析结果一致
2. 删除旧目录和符号链接
3. 更新 `.gitignore`
4. 更新启动脚本和打包配置

---

## 九、扩展性设计

### 9.1 新增数据源流程

新增一个数据源只需三步:

1. 在 `SOURCE_DATA/` 下创建系统目录，按 `ddl/` + `dml/` + `config/` 组织数据
2. 编写该系统的 `manifest.yml`
3. 在 `SOURCE_DATA/manifest.yml` 的 `sources` 中注册

无需修改任何 Python 代码。

### 9.2 未来可扩展的系统分类

| 编码 | 全称 | 中文 | 场景 |
|------|------|------|------|
| `PAM` | Performance Appraisal Management | 绩效考核系统 | 绩效考核指标与评分脚本 |
| `CCR` | Corporate Comprehensive Management | 公司经营管理平台 | 公司级经营管理数据 |
| `ICR` | Interbank Comprehensive Management | 同业经营管理平台 | 同业业务经营管理数据 |
| `BRT` | Branch Retail Management | 零售经营管理平台 | 零售业务经营管理数据 |

---

## 十、关键收益

| 维度 | 改造前 | 改造后 |
|------|--------|--------|
| **数据源发现** | 需修改 config.py + dependencies.py | 只需编辑 manifest.yml |
| **新增系统** | 改 3+ 个文件 | 创建目录 + 写 manifest |
| **路径管理** | 硬编码散落多处 | 统一 SOURCE_DATA 入口 |
| **系统分类** | 按技术类型混合存放 | 按业务系统清晰分类 |
| **元数据** | 无自描述能力 | manifest.yml 自描述 |
| **可维护性** | 新人难以理解数据归属 | 目录名即业务含义 |
