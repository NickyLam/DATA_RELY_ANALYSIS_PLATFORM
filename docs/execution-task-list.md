# DATA_RELY_ANALYSIS_SYS 执行任务清单

> 生成时间: 2026-05-14 | 来源: docs/system-design-spec.md 第16章

---

## 任务概览

基于系统设计说明书未完成的 📋计划 内容，生成 **35 项可执行任务**，分为 **4 个独立批次**，每批次内部无跨批依赖，可独立开发/测试/上线。

| 批次 | 任务数 | 风险等级 | 核心目标 |
|------|--------|---------|---------|
| **批次A** | 7 | 🟢 低 | 行号定位基础实施 |
| **批次B** | 8 | 🟡 中 | SQL边界检测 + 步骤级隔离条件提取 |
| **批次C** | 8 | 🟢 低 | CTE/自定义函数/完整表达式解析 |
| **批次D** | 8 | 🟢 低 | API + 前端增强 |

---

## 执行策略

### 推荐执行顺序

```
批次A（基础） → 批次B（边界检测） → 批次C（高级解析） → 批次D（API/前端）
```

### 执行原则

| 原则 | 说明 |
|------|------|
| **批次独立** | 每批次完成后可独立上线，不影响其他批次 |
| **向后兼容** | 所有新增字段带默认值，不破坏已有代码路径 |
| **新路径隔离** | 新方法为独立模块，不修改已有方法签名 |
| **API纯增量** | 已有端点不修改，新端点为独立路由 |
| **展示层零影响** | lineage-graph.js / detail-panel.js 不受任何修改影响 |

---

## 批次A：行号定位基础实施（7项任务）

### 任务列表

| 任务ID | 任务名称 | 涉及文件 | 风险 | 依赖 | 状态 |
|--------|---------|---------|------|------|------|
| **A1** | SQLOperation新增行号字段 | `core/procedure_parser.py` | 🟢 低 | 无 | 📋待办 |
| **A2** | 填充SQL操作行号 | `core/procedure_parser.py` | 🟢 低 | A1 | 📋待办 |
| **A3** | 传递文件路径 | `core/procedure_parser.py` | 🟢 低 | A1 | 📋待办 |
| **A4** | CaliberInfo新增行号字段 | `core/models.py` | 🟢 低 | 无 | 📋待办 |
| **A5** | CaliberExtractor填充行号 | `core/caliber_extractor.py` | 🟢 低 | A1+A4 | 📋待办 |
| **A6** | CaliberExtractor序列化新字段 | `core/caliber_extractor.py` | 🟢 低 | A4 | 📋待办 |
| **A7** | API序列化新字段 | `api_server.py` | 🟢 低 | A4 | 📋待办 |

### 任务详情

#### A1：SQLOperation新增行号字段

**目标**: 在 `SQLOperation` 数据类中新增 `start_line`、`end_line`、`file_path` 字段（带默认值）

**修改内容**:
```python
@dataclass
class SQLOperation:
    op_type: str
    target_table: str
    sql_block: str
    step_num: int = 0
    step_desc: str = ""
    raw_text: str = ""
    # 新增字段（向后兼容）
    start_line: int = 0  # SQL操作在文件中的起始行号
    end_line: int = 0    # SQL操作在文件中的结束行号
    file_path: str = ""  # 来源.prc文件路径
```

**验证**: 已有 `SQLOperation(...)` 构造调用不受影响，所有测试正常通过

---

#### A2：填充SQL操作行号

**目标**: 在 `_extract_all_sql_operations()` 中计算 SQL 操作的起始和结束行号

**实现逻辑**:
1. 在正则匹配时记录匹配的起始位置
2. 计算起始行号：`start_line = content[:match.start()].count('\n') + 1`
3. 计算结束行号：`end_line = content[:match.end()].count('\n') + 1`
4. 填充到 `SQLOperation.start_line` 和 `end_line`

**验证**: 检查 `SQLOperation.start_line` 和 `end_line` 是否为有效行号（非0）

---

#### A3：传递文件路径

**目标**: 在 `parse_prc_file()` 中将 .prc 文件路径传递到 `SQLOperation.file_path`

**修改内容**:
```python
def parse_prc_file(file_path: str, ...):
    # 在构造 SQLOperation 时传递 file_path
    for op in operations:
        op.file_path = file_path  # 新增
```

**验证**: `SQLOperation.file_path` 包含完整文件路径

---

#### A4：CaliberInfo新增行号字段

**目标**: 在 `CaliberInfo` 数据类中新增 `file_path`、`start_line`、`end_line` 字段（带默认值）

**修改内容**:
```python
@dataclass
class CaliberInfo:
    # 已有字段...
    # 新增字段（向后兼容）
    file_path: str = ""          # 来源.prc文件路径
    start_line: int = 0          # SQL操作起始行号
    end_line: int = 0            # SQL操作结束行号
```

**验证**: 已有 `CaliberInfo(...)` 构造调用不受影响，所有测试正常通过

---

#### A5：CaliberExtractor填充行号

**目标**: 在 `build_caliber_info()` 中填充行号和文件路径字段到 `CaliberInfo`

**修改内容**:
```python
def build_caliber_info(self, sql_operation: SQLOperation, ...):
    caliber_info = CaliberInfo(...)
    # 新增：填充行号和文件路径
    caliber_info.file_path = sql_operation.file_path
    caliber_info.start_line = sql_operation.start_line
    caliber_info.end_line = sql_operation.end_line
    return caliber_info
```

**验证**: `CaliberInfo.file_path`、`start_line`、`end_line` 正确填充

---

#### A6：CaliberExtractor序列化新字段

**目标**: 在 `to_dict()` / `from_dict()` 中新增 `file_path`、`start_line`、`end_line` 序列化逻辑

**修改内容**:
```python
def to_dict(self) -> dict:
    d = {...}
    # 新增字段
    d['file_path'] = self.file_path
    d['start_line'] = self.start_line
    d['end_line'] = self.end_line
    return d

def from_dict(cls, d: dict) -> CaliberInfo:
    # 新增字段反序列化
    info.file_path = d.get('file_path', '')
    info.start_line = d.get('start_line', 0)
    info.end_line = d.get('end_line', 0)
    return info
```

**验证**: 序列化/反序列化测试通过，字段完整保留

---

#### A7：API序列化新字段

**目标**: 在 `_serialize_caliber_info()` 中新增 `file_path`、`start_line`、`end_line` 序列化逻辑

**修改内容**:
```python
def _serialize_caliber_info(info: CaliberInfo) -> dict:
    d = {...}
    # 新增字段
    d['file_path'] = info.file_path
    d['start_line'] = info.start_line
    d['end_line'] = info.end_line
    return d
```

**验证**: API 返回的 JSON 包含行号和文件路径信息

---

## 批次B：SQL边界检测 + 步骤级隔离条件提取（8项任务）

### 任务列表

| 任务ID | 任务名称 | 涉及文件 | 风险 | 依赖 | 状态 |
|--------|---------|---------|------|------|------|
| **B1** | 新建SQL边界检测模块 | `core/sql_boundary_detector.py`（新文件） | 🟢 低 | 无 | 📋待办 |
| **B2** | 实现SQL边界检测功能 | `core/sql_boundary_detector.py` | 🟡 中 | B1 | 📋待办 |
| **B3** | CaliberInfo新增隔离条件字段 | `core/models.py` | 🟢 低 | 无 | 📋待办 |
| **B4** | 新增隔离条件提取方法 | `core/caliber_extractor.py` | 🟡 中 | B2+B3 | 📋待办 |
| **B5** | build_caliber_info调用新方法 | `core/caliber_extractor.py` | 🟡 中 | B4 | 📋待办 |
| **B6** | 扩展口径规格优先级逻辑 | `core/models.py` | 🟡 中 | B3 | 📋待办 |
| **B7** | 序列化隔离条件新字段 | `core/caliber_extractor.py` | 🟢 低 | B3 | 📋待办 |
| **B8** | SQLBoundaryDetector单元测试 | `tests/test_sql_boundary_detector.py`（新文件） | 🟢 低 | B2 | 📋待办 |

### 任务详情

#### B1：新建SQL边界检测模块

**目标**: 创建 `core/sql_boundary_detector.py` 模块骨架

**文件结构**:
```python
# core/sql_boundary_detector.py

class SQLBoundaryDetector:
    """SQL 操作边界检测器"""

    def __init__(self, file_content: str):
        self.file_content = file_content
        self.lines = file_content.split('\n')

    def detect_dml_boundaries(self) -> list[dict]:
        """检测 INSERT/MERGE/UPDATE 操作的边界"""
        pass

    def detect_cte_boundaries(self) -> list[dict]:
        """检测 WITH ... AS (...) CTE 定义边界"""
        pass
```

**验证**: 模块可正常导入，无语法错误

---

#### B2：实现SQL边界检测功能

**目标**: 实现 `SQLBoundaryDetector` 核心功能

**实现能力**:
1. **精确行号定位**: 识别 INSERT/MERGE/UPDATE 在文件中的 `start_line` / `end_line`
2. **CTE 边界识别**: 识别 WITH ... AS (...) 子句的范围
3. **嵌套语句处理**: 处理 BEGIN...END 嵌套内的 DML 定位

**核心算法**:
```python
def detect_dml_boundaries(self) -> list[dict]:
    boundaries = []
    # 正则匹配 INSERT/MERGE/UPDATE
    for match in re.finditer(r'(INSERT\s+INTO|MERGE\s+INTO|UPDATE\s+\w+)', self.file_content):
        start_line = self.file_content[:match.start()].count('\n') + 1
        # 向下查找语句结束位置（分号或下一个 DML）
        end_line = self._find_statement_end(match.start())
        boundaries.append({
            'start_line': start_line,
            'end_line': end_line,
            'operation_type': match.group(1)
        })
    return boundaries

def detect_cte_boundaries(self) -> list[dict]:
    # 正则匹配 WITH ... AS (...)
    # 提取 CTE 名称、定义体范围
    pass
```

**验证**: 单元测试覆盖各类场景（简单 DML、嵌套 DML、CTE）

---

#### B3：CaliberInfo新增隔离条件字段

**目标**: 在 `CaliberInfo` 中新增 `step_isolated_where` 和 `step_isolated_join` 字段

**修改内容**:
```python
@dataclass
class CaliberInfo:
    # 已有字段...
    # 新增字段（向后兼容）
    step_isolated_where: list[SQLCondition] = []  # 步骤级隔离WHERE条件
    step_isolated_join: list[SQLCondition] = []   # 步骤级隔离JOIN条件
```

**验证**: 已有构造调用不受影响，序列化测试通过

---

#### B4：新增隔离条件提取方法

**目标**: 在 `CaliberExtractor` 中新增 `_extract_step_isolated_where()` 和 `_extract_step_isolated_join()` 方法

**实现逻辑**:
```python
def _extract_step_isolated_where(self, sql_operation: SQLOperation, boundary_info: dict) -> list[SQLCondition]:
    """提取步骤级隔离 WHERE 条件"""
    # 1. 使用 SQLBoundaryDetector 提供的边界信息
    # 2. 提取当前 SQL 块内新增的 WHERE 条件（非累积）
    # 3. 返回步骤级隔离条件列表
    pass

def _extract_step_isolated_join(self, sql_operation: SQLOperation, boundary_info: dict) -> list[SQLCondition]:
    """提取步骤级隔离 JOIN 条件"""
    pass
```

**验证**: 单元测试验证隔离条件提取准确性

---

#### B5：build_caliber_info调用新方法

**目标**: 在 `build_caliber_info()` 中调用新方法填充隔离条件字段

**修改内容**:
```python
def build_caliber_info(self, sql_operation: SQLOperation, ...):
    # 已有逻辑...

    # 新增：步骤级隔离条件提取
    boundary_detector = SQLBoundaryDetector(sql_operation.raw_text)
    boundary_info = boundary_detector.detect_dml_boundaries()[0]  # 取当前操作边界

    caliber_info.step_isolated_where = self._extract_step_isolated_where(sql_operation, boundary_info)
    caliber_info.step_isolated_join = self._extract_step_isolated_join(sql_operation, boundary_info)

    return caliber_info
```

**验证**: `CaliberInfo.step_isolated_where` 和 `step_isolated_join` 正确填充

---

#### B6：扩展口径规格优先级逻辑

**目标**: 在 `generate_caliber_spec()` 中扩展 WHERE 优先级逻辑

**修改内容**:
```python
def generate_caliber_spec(self) -> str:
    spec = []

    # WHERE 条件优先级：step_isolated → accumulated → where_conditions
    where_to_use = self.step_isolated_where or self.accumulated_where or self.where_conditions
    if where_to_use:
        spec.append("WHERE 条件:")
        for cond in where_to_use:
            spec.append(f"  - {cond.raw_text}")

    # 其他字段...
    return "\n".join(spec)
```

**验证**: 口径规格描述优先使用步骤级隔离条件

---

#### B7：序列化隔离条件新字段

**目标**: 在 `to_dict()` / `from_dict()` 中新增 `step_isolated_where` 和 `step_isolated_join` 序列化逻辑

**修改内容**:
```python
def to_dict(self) -> dict:
    d = {...}
    # 新增字段
    d['step_isolated_where'] = [c.to_dict() for c in self.step_isolated_where]
    d['step_isolated_join'] = [c.to_dict() for c in self.step_isolated_join]
    return d

def from_dict(cls, d: dict) -> CaliberInfo:
    # 新增字段反序列化
    info.step_isolated_where = [SQLCondition.from_dict(c) for c in d.get('step_isolated_where', [])]
    info.step_isolated_join = [SQLCondition.from_dict(c) for c in d.get('step_isolated_join', [])]
    return info
```

**验证**: 序列化/反序列化测试通过

---

#### B8：SQLBoundaryDetector单元测试

**目标**: 编写 `SQLBoundaryDetector` 单元测试

**测试场景**:
1. 简单 INSERT 语句行号定位
2. 嵌套 BEGIN...END 内的 MERGE 定位
3. 多个 DML 操作连续定位
4. WITH 子句 CTE 边界识别
5. CTE 内 DML 定位

**文件**: `tests/test_sql_boundary_detector.py`

**验证**: pytest 测试全部通过

---

## 批次C：CTE/自定义函数/完整表达式解析（8项任务）

### 任务列表

| 任务ID | 任务名称 | 涉及文件 | 风险 | 依赖 | 状态 |
|--------|---------|---------|------|------|------|
| **C1** | CaliberInfo新增CTE/函数/表达式字段 | `core/models.py` | 🟢 低 | 无 | 📋待办 |
| **C2** | 新增CTE提取方法 | `core/caliber_extractor.py` | 🟢 低 | C1 | 📋待办 |
| **C3** | 新增自定义函数检测方法 | `core/caliber_extractor.py` | 🟢 低 | C1 | 📋待办 |
| **C4** | 新增完整表达式提取方法 | `core/caliber_extractor.py` | 🟢 低 | C1 | 📋待办 |
| **C5** | build_caliber_info填充新字段 | `core/caliber_extractor.py` | 🟢 低 | C2+C3+C4 | 📋待办 |
| **C6** | 序列化CTE/函数/表达式字段 | `core/caliber_extractor.py` | 🟢 低 | C1 | 📋待办 |
| **C7** | 扩展口径规格渲染逻辑 | `core/models.py` | 🟢 低 | C1 | 📋待办 |
| **C8** | CTE/函数/表达式提取单元测试 | `tests/test_caliber_extraction_advanced.py`（新文件） | 🟢 低 | C2+C3+C4 | 📋待办 |

### 任务详情

#### C1：CaliberInfo新增CTE/函数/表达式字段

**目标**: 在 `CaliberInfo` 中新增 4 个字段（带默认值）

**修改内容**:
```python
@dataclass
class CaliberInfo:
    # 已有字段...
    # 新增字段（向后兼容）
    cte_definitions: list[str] = []           # WITH子句CTE定义
    custom_functions: list[str] = []          # 自定义函数调用列表
    full_expression: str = ""                 # 完整字段表达式（含函数嵌套）
    is_custom_function_call: bool = False     # 是否为自定义函数调用
```

**验证**: 已有构造调用不受影响

---

#### C2：新增CTE提取方法

**目标**: 实现 `_extract_cte_definitions()` 方法

**实现逻辑**:
```python
def _extract_cte_definitions(self, sql_block: str) -> list[str]:
    """提取 WITH ... AS (...) CTE 定义"""
    cte_defs = []
    # 正则匹配 WITH name AS (...)
    pattern = r'WITH\s+(\w+)\s+AS\s*\((.*?)\)'
    for match in re.finditer(pattern, sql_block, re.DOTALL | re.IGNORECASE):
        cte_name = match.group(1)
        cte_body = match.group(2)
        cte_defs.append(f"{cte_name}: {cte_body}")
    return cte_defs
```

**验证**: CTE 定义提取准确，包含名称和定义体

---

#### C3：新增自定义函数检测方法

**目标**: 实现 `_extract_custom_functions()` 方法

**实现逻辑**:
```python
def _extract_custom_functions(self, sql_block: str) -> list[str]:
    """检测 Oracle 自定义函数调用"""
    custom_funcs = []
    # 匹配 Oracle 自定义函数模式：PKG_FUNC(...), FN_XXX(...)
    pattern = r'(PKG_\w+|FN_\w+|FUNC_\w+)\s*\('
    for match in re.finditer(pattern, sql_block, re.IGNORECASE):
        custom_funcs.append(match.group(1))
    return custom_funcs
```

**验证**: 自定义函数检测准确，列表完整

---

#### C4：新增完整表达式提取方法

**目标**: 实现 `_extract_full_expression()` 方法

**实现逻辑**:
```python
def _extract_full_expression(self, sql_block: str, target_column: str) -> str:
    """提取 SELECT 中字段的完整表达式"""
    # 1. 定位 SELECT 列列表
    # 2. 查找 target_column 对应的表达式
    # 3. 提取完整表达式（含函数嵌套、CASE WHEN 等）
    # 4. 不截断，保留完整内容
    pass
```

**验证**: 表达式提取完整，无截断

---

#### C5：build_caliber_info填充新字段

**目标**: 在 `build_caliber_info()` 中调用新方法填充新字段

**修改内容**:
```python
def build_caliber_info(self, sql_operation: SQLOperation, ...):
    # 已有逻辑...

    # 新增：CTE/函数/表达式提取
    caliber_info.cte_definitions = self._extract_cte_definitions(sql_operation.sql_block)
    caliber_info.custom_functions = self._extract_custom_functions(sql_operation.sql_block)
    caliber_info.full_expression = self._extract_full_expression(sql_operation.sql_block, caliber_info.target_column)
    caliber_info.is_custom_function_call = len(caliber_info.custom_functions) > 0

    return caliber_info
```

**验证**: 新字段正确填充

---

#### C6：序列化CTE/函数/表达式字段

**目标**: 在 `to_dict()` / `from_dict()` 中新增新字段序列化逻辑

**修改内容**:
```python
def to_dict(self) -> dict:
    d = {...}
    # 新增字段
    d['cte_definitions'] = self.cte_definitions
    d['custom_functions'] = self.custom_functions
    d['full_expression'] = self.full_expression
    d['is_custom_function_call'] = self.is_custom_function_call
    return d

def from_dict(cls, d: dict) -> CaliberInfo:
    # 新增字段反序列化
    info.cte_definitions = d.get('cte_definitions', [])
    info.custom_functions = d.get('custom_functions', [])
    info.full_expression = d.get('full_expression', '')
    info.is_custom_function_call = d.get('is_custom_function_call', False)
    return info
```

**验证**: 序列化/反序列化测试通过

---

#### C7：扩展口径规格渲染逻辑

**目标**: 在 `generate_caliber_spec()` 中扩展口径规格描述渲染

**修改内容**:
```python
def generate_caliber_spec(self) -> str:
    spec = []

    # 已有渲染...

    # 新增：CTE 定义
    if self.cte_definitions:
        spec.append("CTE 定义:")
        for cte in self.cte_definitions:
            spec.append(f"  - {cte}")

    # 新增：自定义函数调用
    if self.custom_functions:
        spec.append("自定义函数调用:")
        for func in self.custom_functions:
            spec.append(f"  - {func}")

    # 新增：完整表达式
    if self.full_expression:
        spec.append(f"完整表达式: {self.full_expression}")

    return "\n".join(spec)
```

**验证**: 口径规格描述包含 CTE/函数/表达式信息

---

#### C8：CTE/函数/表达式提取单元测试

**目标**: 编写 CTE/函数/表达式提取的单元测试

**测试场景**:
1. WITH 子句 CTE 定义提取
2. 多层嵌套 CTE
3. 自定义函数检测（PKG_FUNC, FN_XXX）
4. CASE WHEN 完整表达式提取
5. 函数嵌套完整表达式提取

**文件**: `tests/test_caliber_extraction_advanced.py`

**验证**: pytest 测试全部通过

---

## 批次D：API + 前端增强（8项任务）

### 任务列表

| 任务ID | 任务名称 | 涉及文件 | 风险 | 依赖 | 状态 |
|--------|---------|---------|------|------|------|
| **D1** | 新增/api/caliber/trace/detail端点 | `api_server.py` | 🟢 低 | A+B+C | 📋待办 |
| **D2** | 新增/api/caliber/sql-detail端点 | `api_server.py` | 🟢 低 | A+B | 📋待办 |
| **D3** | 补充API口径序列化完整字段 | `api_server.py` | 🟢 低 | A4+B3+C1 | 📋待办 |
| **D4** | 口径Tab行号跳转功能 | `static/js/caliber-tab.js` | 🟢 低 | A+D1 | 📋待办 |
| **D5** | 口径Tab隔离条件高亮 | `static/js/caliber-tab.js` | 🟢 低 | B+D1 | 📋待办 |
| **D6** | 口径TabCTE折叠展示 | `static/js/caliber-tab.js` | 🟢 低 | C+D1 | 📋待办 |
| **D7** | 口径Tab自定义函数标注 | `static/js/caliber-tab.js` | 🟢 低 | C+D1 | 📋待办 |
| **D8** | 口径Tab完整表达式展示 | `static/js/caliber-tab.js` | 🟢 低 | C+D1 | 📋待办 |

### 任务详情

#### D1：新增/api/caliber/trace/detail端点

**目标**: 新增增强口径追溯 API 端点

**API 定义**:
```
GET /api/caliber/trace/detail?table={table}&field={field}

响应示例:
{
  "success": true,
  "data": {
    "chains": [...],
    "total_steps": 5,
    "complete_caliber_spec": "...",
    "enhanced_features": {
      "line_numbers": true,
      "isolated_conditions": true,
      "cte_definitions": true,
      "custom_functions": true,
      "full_expressions": true
    }
  }
}
```

**实现逻辑**:
```python
def _handle_caliber_trace_detail(table: str, field: str):
    # 调用 CaliberTracer.trace_caliber()
    # 使用增强序列化（包含所有新字段）
    result = caliber_tracer.trace_caliber(table, field)
    return {
        "success": True,
        "data": _serialize_caliber_result_enhanced(result)
    }
```

**验证**: API 返回包含行号/隔离条件/CTE/函数/表达式信息

---

#### D2：新增/api/caliber/sql-detail端点

**目标**: 新增单步 SQL 详细解析 API 端点

**API 定义**:
```
GET /api/caliber/sql-detail?file_path={path}&start_line={start}&end_line={end}

响应示例:
{
  "success": true,
  "data": {
    "sql_block": "...",
    "step_isolated_where": [...],
    "step_isolated_join": [...],
    "boundary_info": {...},
    "operation_type": "INSERT"
  }
}
```

**实现逻辑**:
```python
def _handle_caliber_sql_detail(file_path: str, start_line: int, end_line: int):
    # 读取指定行号的 SQL 块
    # 使用 SQLBoundaryDetector 检测边界
    # 使用 CaliberExtractor 提取隔离条件
    pass
```

**验证**: API 返回正确的步骤级隔离条件和边界信息

---

#### D3：补充API口径序列化完整字段

**目标**: 在 `_serialize_caliber_info()` 中补充所有新增字段

**修改内容**:
```python
def _serialize_caliber_info(info: CaliberInfo) -> dict:
    d = {...}

    # 批次A新增字段
    d['file_path'] = info.file_path
    d['start_line'] = info.start_line
    d['end_line'] = info.end_line

    # 批次B新增字段
    d['step_isolated_where'] = [_serialize_sql_condition(c) for c in info.step_isolated_where]
    d['step_isolated_join'] = [_serialize_sql_condition(c) for c in info.step_isolated_join]

    # 批次C新增字段
    d['cte_definitions'] = info.cte_definitions
    d['custom_functions'] = info.custom_functions
    d['full_expression'] = info.full_expression
    d['is_custom_function_call'] = info.is_custom_function_call

    return d
```

**验证**: API 返回的 JSON 包含所有新增字段

---

#### D4：口径Tab行号跳转功能

**目标**: 在口径Tab前端中实现行号跳转功能

**实现内容**:
1. 显示 `file_path:start_line-end_line` 文件定位信息
2. 点击定位信息跳转到源文件对应行
3. 高亮显示当前 SQL 操作范围

**UI 设计**:
```html
<div class="caliber-step-info">
  <span class="file-location" onclick="jumpToLine('${file_path}', ${start_line})">
    ${file_path}:${start_line}-${end_line}
  </span>
</div>
```

**验证**: 点击定位信息可正确跳转到源文件对应行

---

#### D5：口径Tab隔离条件高亮

**目标**: 在口径Tab前端中实现隔离条件高亮功能

**实现内容**:
1. 步骤级隔离条件以不同样式高亮（如橙色背景）
2. 累积条件以默认样式显示（如灰色背景）
3. 条件类型标签标注（"步骤级"/"累积")

**UI 设计**:
```html
<div class="caliber-condition">
  <span class="condition-type-badge ${type}">${type}</span>
  <span class="condition-text">${raw_text}</span>
</div>
```

**验证**: 隔离条件和累积条件样式有明显区分

---

#### D6：口径TabCTE折叠展示

**目标**: 在口径Tab前端中实现 CTE 折叠展示功能

**实现内容**:
1. WITH 子句默认折叠显示（显示 CTE 名称）
2. 点击展开按钮显示完整 CTE 定义体
3. 折叠/展开状态记忆

**UI 设计**:
```html
<div class="cte-definition collapsible">
  <div class="cte-header" onclick="toggleCTE('${cte_name}')">
    <span class="cte-name">${cte_name}</span>
    <span class="toggle-icon">▼</span>
  </div>
  <div class="cte-body" style="display: none;">
    ${cte_body}
  </div>
</div>
```

**验证**: CTE 默认折叠，点击可展开查看完整定义

---

#### D7：口径Tab自定义函数标注

**目标**: 在口径Tab前端中实现自定义函数标注功能

**实现内容**:
1. 自定义函数调用以特殊样式标注（如紫色标签）
2. 点击函数标签可查看函数定义信息
3. 函数调用次数统计

**UI 设计**:
```html
<div class="custom-function-tag" onclick="showFunctionDetail('${func_name}')">
  <span class="func-icon">⚡</span>
  <span class="func-name">${func_name}</span>
</div>
```

**验证**: 自定义函数以特殊样式标注，点击可查看详情

---

#### D8：口径Tab完整表达式展示

**目标**: 在口径Tab前端中实现完整表达式展示功能

**实现内容**:
1. 显示字段的完整表达式（含函数嵌套、CASE WHEN 等）
2. 表达式不截断，完整显示
3. 表达式格式化渲染（高亮函数名/关键字）

**UI 设计**:
```html
<div class="full-expression">
  <pre class="expression-code">${full_expression}</pre>
</div>
```

**验证**: 表达式完整显示，无截断，格式化渲染清晰

---

## 任务依赖关系图

```
批次A（基础）
├─ A1 (SQLOperation新增字段) ──┐
│  ├─ A2 (填充行号)           │
│  ├─ A3 (传递路径)           │
│  └─ A5 (CaliberExtractor)   │
└─ A4 (CaliberInfo新增字段) ──┤
   ├─ A6 (序列化)            │
   └─ A7 (API序列化)         │
                              │
批次B（边界检测）              │
├─ B1 (新建模块) ──┐         │
│  └─ B2 (实现功能) │         │
│     ├─ B4 (提取方法)│        │
│     │  └─ B5 (填充) │        │
│     └─ B8 (单元测试)│        │
└─ B3 (新增字段) ──┤         │
   ├─ B4 (提取方法)  │        │
   ├─ B6 (优先级)    │        │
   └─ B7 (序列化)    │        │
                    │        │
批次C（高级解析）    │        │
├─ C1 (新增字段) ──┐│        │
│  ├─ C2 (CTE)    ││        │
│  ├─ C3 (函数)   ││        │
│  ├─ C4 (表达式) ││        │
│  └─ C5 (填充) ──┼┼┐       │
└─ C6 (序列化) ──┤││       │
   ├─ C7 (渲染)  │││       │
   └─ C8 (测试)  │││       │
                 │││       │
批次D（API/前端） │││       │
├─ D1 (API详情) ──┼┼┼┐     │
│  ├─ D4 (行号跳转) ││││     │
│  ├─ D5 (隔离高亮) ││││     │
│  ├─ D6 (CTE折叠) ││││     │
│  ├─ D7 (函数标注) ││││     │
│  └─ D8 (表达式)   ││││     │
├─ D2 (API详情) ──┼┼┼┼┐    │
└─ D3 (API序列化) ─┼┼┼┼┼── A7 + B7 + C6
                    ││││
                    └──└─└─└─ 批次A + B + C 完成后可执行
```

---

## 验证与质量保障

### 每批次完成后验证项

| 批次 | 验证项 | 验证方法 |
|------|--------|---------|
| **A** | 行号定位准确性 | 检查 SQLOperation.start_line/end_line 是否为有效行号 |
| **A** | 序列化完整性 | API 返回 JSON 包含 file_path/start_line/end_line |
| **B** | 隔离条件准确性 | 对比 step_isolated_where 与 accumulated_where |
| **B** | 口径优先级正确 | generate_caliber_spec() 优先使用 step_isolated |
| **C** | CTE 提取准确 | cte_definitions 包含完整 WITH 子句定义 |
| **C** | 函数检测准确 | custom_functions 包含所有自定义函数调用 |
| **C** | 表达式完整 | full_expression 无截断，包含完整内容 |
| **D** | API 响应正确 | /api/caliber/trace/detail 返回所有新字段 |
| **D** | 前端跳转正确 | 点击行号定位跳转到正确源文件行 |
| **D** | 样式区分明显 | 隔离条件与累积条件样式有明显差异 |

### 单元测试覆盖

| 批次 | 测试文件 | 测试数量 |
|------|---------|---------|
| **B** | `tests/test_sql_boundary_detector.py` | 5+ |
| **C** | `tests/test_caliber_extraction_advanced.py` | 5+ |

---

## 实施建议

### 开发顺序

1. **批次A → 批次B → 批次C → 批次D**（推荐）
2. 每批次完成后进行独立测试和验证
3. 批次间可并行开发（无跨批依赖）

### 风险缓解

| 风险 | 缓解措施 |
|------|---------|
| 数据类向后兼容破坏 | 所有新增字段带默认值，构造测试验证 |
| 旧路径逻辑影响 | 新方法为独立函数，不修改已有方法 |
| 序列化字段遗漏 | to_dict/from_dict 增量添加，单元测试覆盖 |
| 前端样式冲突 | 隔离条件使用独立 CSS 类，不覆盖已有样式 |

### 交付标准

每批次完成后应满足：
1. 所有单元测试通过
2. API 响应包含新字段
3. 前端功能正常可用
4. 系统设计文档状态更新（📋待办 → ✅已有）

---

## 附录：文件修改清单

| 批次 | 涉及文件 | 新增/修改 |
|------|---------|---------|
| **A** | `core/procedure_parser.py` | 修改（新增字段） |
| **A** | `core/models.py` | 修改（新增字段） |
| **A** | `core/caliber_extractor.py` | 修改（新增序列化） |
| **A** | `api_server.py` | 修改（新增序列化） |
| **B** | `core/sql_boundary_detector.py` | 新增（新模块） |
| **B** | `core/models.py` | 修改（新增字段） |
| **B** | `core/caliber_extractor.py` | 修改（新增方法） |
| **B** | `tests/test_sql_boundary_detector.py` | 新增（单元测试） |
| **C** | `core/models.py` | 修改（新增字段） |
| **C** | `core/caliber_extractor.py` | 修改（新增方法） |
| **C** | `tests/test_caliber_extraction_advanced.py` | 新增（单元测试） |
| **D** | `api_server.py` | 修改（新增端点） |
| **D** | `static/js/caliber-tab.js` | 修改（新增功能） |

---

> **文档维护**: 本执行任务清单随系统迭代更新。每完成一项任务，更新任务状态（📋待办 → 🚀进行 → ✅完成），并同步更新 `docs/system-design-spec.md` 对应章节状态。
