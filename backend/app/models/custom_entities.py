"""
DataHub 自定义血缘实体模型
用于扩展 DataHub 的元数据模型，支持 Oracle 19c 血缘关系
"""

from datahub.metadata.schema_classes import (
    DatasetSnapshotClass,
    SchemaMetadataClass,
    SchemaFieldClass,
    GlobalTagsClass,
    TagAssociationClass,
    EditableSchemaMetadataClass,
    EditableSchemaFieldInfoClass,
)

# ============================================
# 1. Oracle 19c 数据源实体
# ============================================

class OracleDataSource:
    """
    Oracle 19c 数据源实体定义
    """
    
    # 数据源类型
    TYPE = "oracle"
    
    # 实体属性
    properties = {
        "host": "Oracle 数据库主机地址",
        "port": "Oracle 数据库端口（默认 1521）",
        "service_name": "Oracle 服务名",
        "sid": "Oracle SID",
        "username": "连接用户名",
        "password_encrypted": "加密后的密码",
        "connection_pool_size": "连接池大小",
        "query_timeout": "查询超时时间（秒）",
        "is_production": "是否生产环境",
        "regulatory_system": "关联的监管报送系统",
    }
    
    # 元数据字段
    metadata_fields = [
        "version",  # Oracle 版本（如 19c）
        "edition",  # Oracle 版本类型（Enterprise/Standard）
        "charset",  # 字符集
        "nls_language",  # NLS 语言
        "table_count",  # 表数量
        "last_collected_at",  # 最近采集时间
    ]


# ============================================
# 2. 表级血缘关系实体
# ============================================

class TableLineage:
    """
    表级血缘关系实体定义
    """
    
    # 血缘类型
    LINEAGE_TYPE = "TABLE_LINEAGE"
    
    # 实体属性
    properties = {
        "source_table": "来源表",
        "target_table": "目标表",
        "transformation_type": "转换类型（direct_map/calculation/aggregation/filter/join）",
        "transformation_logic": "转换逻辑描述",
        "job_name": "执行作业名称",
        "sql_statement": "SQL 语句",
        "confidence_score": "可信度评分（0.0-1.0）",
        "derivation_method": "来源方法（static_parse/runtime_capture/manual_entry）",
        "parse_engine": "解析引擎（JSqlParser/Druid/ANTLR）",
        "evidence": "解析依据（SQL 片段或日志片段）",
        "valid_from": "生效时间",
        "valid_to": "失效时间",
        "regulatory_tag": "监管标识（如 EAST 5.0-表 3）",
        "business_term": "业务术语",
    }
    
    # 转换类型枚举
    TRANSFORMATION_TYPES = [
        "DIRECT_MAP",  # 直接映射
        "CALCULATION",  # 计算转换
        "AGGREGATION",  # 聚合转换
        "FILTER",  # 过滤转换
        "JOIN",  # 关联转换
        "UNION",  # 合并转换
        "SORT",  # 排序转换
        "GROUP_BY",  # 分组转换
    ]
    
    # 来源方法枚举
    DERIVATION_METHODS = [
        "STATIC_PARSE",  # 静态解析
        "RUNTIME_CAPTURE",  # 运行时采集
        "MANUAL_ENTRY",  # 人工录入
        "MANUAL_REVIEW",  # 人工审核确认
    ]


# ============================================
# 3. 字段级血缘关系实体
# ============================================

class FieldLineage:
    """
    字段级血缘关系实体定义
    """
    
    # 血缘类型
    LINEAGE_TYPE = "FIELD_LINEAGE"
    
    # 实体属性
    properties = {
        "source_field": "来源字段",
        "target_field": "目标字段",
        "source_table": "来源表",
        "target_table": "目标表",
        "transformation_type": "转换类型",
        "expression": "转换表达式（如 SUM(amount) AS total_amount）",
        "data_type_change": "数据类型是否变化",
        "source_data_type": "来源字段数据类型",
        "target_data_type": "目标字段数据类型",
        "is_nullable_change": "是否可空属性是否变化",
        "confidence_score": "可信度评分",
        "derivation_method": "来源方法",
        "parse_engine": "解析引擎",
        "evidence": "解析依据",
        "valid_from": "生效时间",
        "valid_to": "失效时间",
        "regulatory_tag": "监管标识",
        "business_term": "业务术语",
    }
    
    # 字段转换类型枚举
    FIELD_TRANSFORMATION_TYPES = [
        "DIRECT_MAP",  # 直接映射（如 SELECT field1 AS field2）
        "CALCULATION",  # 计算转换（如 field1 + field2）
        "AGGREGATION",  # 聚合转换（如 SUM(field1)）
        "FUNCTION_CALL",  # 函数调用（如 UPPER(field1)）
        "CASE_WHEN",  # 条件转换（如 CASE WHEN field1 > 0 THEN 'Y' ELSE 'N'）
        "TYPE_CAST",  # 类型转换（如 CAST(field1 AS VARCHAR)）
        "CONSTANT",  # 常量赋值（如 'DEFAULT_VALUE' AS field2）
    ]


# ============================================
# 4. 作业依赖关系实体
# ============================================

class JobDependency:
    """
    作业依赖关系实体定义
    """
    
    # 依赖类型
    DEPENDENCY_TYPE = "JOB_DEPENDENCY"
    
    # 实体属性
    properties = {
        "source_job": "来源作业",
        "target_job": "目标作业",
        "dependency_type": "依赖类型（sequential/parallel/conditional）",
        "schedule_time": "调度时间",
        "execution_order": "执行顺序",
        "condition_expression": "条件表达式（条件依赖时）",
        "last_run_status": "最近运行状态",
        "last_run_time": "最近运行时间",
        "average_duration": "平均执行时长",
    }
    
    # 依赖类型枚举
    DEPENDENCY_TYPES = [
        "SEQUENTIAL",  # 顺序依赖（作业 A 完成后执行作业 B）
        "PARALLEL",  # 并行依赖（作业 A 和 B 同时执行）
        "CONDITIONAL",  # 条件依赖（满足条件时执行）
        "DATA_DEPENDENCY",  # 数据依赖（作业 A 输出作为作业 B 输入）
    ]


# ============================================
# 5. 批次运行记录实体
# ============================================

class BatchRun:
    """
    批次运行记录实体定义
    """
    
    # 实体类型
    ENTITY_TYPE = "BATCH_RUN"
    
    # 实体属性
    properties = {
        "batch_id": "批次 ID",
        "job_name": "作业名称",
        "start_time": "开始时间",
        "end_time": "结束时间",
        "status": "运行状态（running/success/failed/cancelled）",
        "error_message": "错误信息",
        "records_processed": "处理记录数",
        "records_failed": "失败记录数",
        "execution_duration": "执行时长（秒）",
        "trigger_type": "触发类型（manual/scheduled/event）",
        "triggered_by": "触发人/触发源",
        "log_file_path": "日志文件路径",
        "checkpoint": "检查点信息",
    }
    
    # 运行状态枚举
    STATUS_TYPES = [
        "RUNNING",  # 运行中
        "SUCCESS",  # 成功
        "FAILED",  # 失败
        "CANCELLED",  # 已取消
        "TIMEOUT",  # 超时
        "RETRYING",  # 重试中
    ]


# ============================================
# 6. 血缘可信度评分规则
# ============================================

class LineageConfidenceScore:
    """
    血缘可信度评分规则
    """
    
    # 评分规则
    scoring_rules = {
        "STATIC_PARSE_SIMPLE": 0.98,  # 静态解析 - 简单 SQL
        "STATIC_PARSE_MEDIUM": 0.90,  # 静态解析 - 中等复杂度 SQL
        "STATIC_PARSE_COMPLEX": 0.80,  # 静态解析 - 复杂 SQL
        "STATIC_PARSE_EXTREME": 0.70,  # 静态解析 - 极复杂 SQL
        "RUNTIME_CAPTURE": 0.95,  # 运行时采集
        "MANUAL_ENTRY": 0.85,  # 人工录入
        "MANUAL_REVIEW_APPROVED": 1.00,  # 人工审核确认
    }
    
    # 评分因素
    scoring_factors = {
        "parse_engine_reliability": "解析引擎可靠性评分",
        "sql_complexity": "SQL 复杂度评分",
        "runtime_evidence": "运行时证据评分",
        "manual_review_count": "人工审核次数评分",
        "historical_accuracy": "历史准确率评分",
    }
    
    # 计算可信度评分
    def calculate_confidence_score(
        derivation_method: str,
        parse_engine: str = None,
        sql_complexity: str = None,
        has_runtime_evidence: bool = False,
        manual_review_count: int = 0,
    ) -> float:
        """
        计算血缘可信度评分
        
        Args:
            derivation_method: 来源方法
            parse_engine: 解析引擎
            sql_complexity: SQL 复杂度（L1/L2/L3/L4）
            has_runtime_evidence: 是否有运行时证据
            manual_review_count: 人工审核次数
        
        Returns:
            可信度评分（0.0-1.0）
        """
        base_score = LineageConfidenceScore.scoring_rules.get(derivation_method, 0.70)
        
        # 根据解析引擎调整评分
        if parse_engine == "JSqlParser":
            base_score += 0.02
        elif parse_engine == "Druid":
            base_score += 0.01
        
        # 根据 SQL 复杂度调整评分
        if sql_complexity == "L1":
            base_score += 0.05
        elif sql_complexity == "L2":
            base_score += 0.02
        elif sql_complexity == "L3":
            base_score -= 0.05
        elif sql_complexity == "L4":
            base_score -= 0.10
        
        # 根据运行时证据调整评分
        if has_runtime_evidence:
            base_score += 0.05
        
        # 根据人工审核次数调整评分
        if manual_review_count > 0:
            base_score += min(manual_review_count * 0.05, 0.15)
        
        # 确保评分在 0.0-1.0 范围内
        return max(0.0, min(1.0, base_score))


# ============================================
# 7. 监管报送标识实体
# ============================================

class RegulatoryTag:
    """
    监管报送标识实体定义
    """
    
    # 实体类型
    ENTITY_TYPE = "REGULATORY_TAG"
    
    # 实体属性
    properties = {
        "tag_id": "标识 ID",
        "regulation_name": "监管名称（如 EAST 5.0）",
        "table_number": "表编号（如 表 3）",
        "field_number": "字段编号（如 字段 12）",
        "field_name": "字段名称",
        "description": "字段描述",
        "data_type": "数据类型要求",
        "is_required": "是否必填",
        "validation_rule": "校验规则",
        "sample_value": "示例值",
        "business_definition": "业务定义",
        "source_system": "来源系统",
        "target_system": "报送目标系统",
        "submission_frequency": "报送频率",
    }
    
    # 监管报送系统枚举
    REGULATORY_SYSTEMS = [
        "EAST_5_0",  # EAST 5.0
        "EAST_4_0",  # EAST 4.0
        "1104",  # 1104 报送
        "CUSTOMS",  # 海关报送
        "SAFE",  # 外管局报送
        "PBOC",  # 人行报送
    ]


# ============================================
# 8. DataHub 自定义实体注册脚本
# ============================================

def register_custom_entities():
    """
    注册自定义实体到 DataHub
    
    使用 DataHub 的 Metadata Schema Extension 机制
    """
    
    # 注册 Oracle 数据源
    oracle_datasource_schema = {
        "entityType": "dataSource",
        "type": OracleDataSource.TYPE,
        "properties": OracleDataSource.properties,
    }
    
    # 注册表级血缘关系
    table_lineage_schema = {
        "entityType": "lineage",
        "type": TableLineage.LINEAGE_TYPE,
        "properties": TableLineage.properties,
    }
    
    # 注册字段级血缘关系
    field_lineage_schema = {
        "entityType": "lineage",
        "type": FieldLineage.LINEAGE_TYPE,
        "properties": FieldLineage.properties,
    }
    
    # 注册作业依赖关系
    job_dependency_schema = {
        "entityType": "dependency",
        "type": JobDependency.DEPENDENCY_TYPE,
        "properties": JobDependency.properties,
    }
    
    # 注册批次运行记录
    batch_run_schema = {
        "entityType": "batchRun",
        "type": BatchRun.ENTITY_TYPE,
        "properties": BatchRun.properties,
    }
    
    # 注册监管报送标识
    regulatory_tag_schema = {
        "entityType": "regulatoryTag",
        "type": RegulatoryTag.ENTITY_TYPE,
        "properties": RegulatoryTag.properties,
    }
    
    # 返回所有自定义实体 schema
    return {
        "oracle_datasource": oracle_datasource_schema,
        "table_lineage": table_lineage_schema,
        "field_lineage": field_lineage_schema,
        "job_dependency": job_dependency_schema,
        "batch_run": batch_run_schema,
        "regulatory_tag": regulatory_tag_schema,
    }


# ============================================
# 9. 使用示例
# ============================================

if __name__ == "__main__":
    # 注册自定义实体
    custom_entities = register_custom_entities()
    
    # 计算可信度评分示例
    confidence_score = LineageConfidenceScore.calculate_confidence_score(
        derivation_method="STATIC_PARSE",
        parse_engine="JSqlParser",
        sql_complexity="L1",
        has_runtime_evidence=True,
        manual_review_count=1,
    )
    
    print(f"可信度评分: {confidence_score}")
    print(f"自定义实体: {custom_entities}")