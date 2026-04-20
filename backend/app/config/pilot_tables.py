"""
试点配置文件
定义试点表列表、数据源配置和采集任务配置
"""

from dataclasses import dataclass, field
from enum import Enum
from typing import Any, Dict, List, Optional


class DataSourceType(str, Enum):
    """数据源类型枚举"""

    ORACLE = "oracle"
    TDH = "tdh"
    OCEANBASE = "oceanbase"
    GBASE = "gbase"
    YASHAN = "yashan"


class CollectionType(str, Enum):
    """采集类型枚举"""

    STATIC = "static"
    RUNTIME = "runtime"
    FULL = "full"


class TablePriority(str, Enum):
    """表优先级枚举"""

    HIGH = "high"
    MEDIUM = "medium"
    LOW = "low"


@dataclass
class PilotTable:
    """试点表定义"""

    table_id: str
    table_name: str
    schema_name: str
    data_source_id: str
    priority: TablePriority = TablePriority.MEDIUM
    business_domain: Optional[str] = None
    description: Optional[str] = None
    expected_lineage_count: int = 0
    has_manual_annotation: bool = False
    tags: List[str] = field(default_factory=list)


@dataclass
class DataSourceConfig:
    """数据源配置"""

    data_source_id: str
    name: str
    type: DataSourceType
    host: str
    port: int
    database_name: str
    username: str
    password: str
    service_name: Optional[str] = None
    connection_params: Dict[str, Any] = field(default_factory=dict)
    enabled: bool = True
    priority: TablePriority = TablePriority.MEDIUM


@dataclass
class CollectionTaskConfig:
    """采集任务配置"""

    task_id: str
    task_name: str
    data_source_id: str
    collection_type: CollectionType
    target_tables: List[str] = field(default_factory=list)
    schedule: Optional[str] = None
    batch_size: int = 1000
    timeout_seconds: int = 300
    max_retries: int = 3
    retry_delay_seconds: float = 1.0
    enabled: bool = True
    priority: TablePriority = TablePriority.MEDIUM


@dataclass
class ManualAnnotation:
    """人工标注血缘"""

    annotation_id: str
    source_table_id: str
    target_table_id: str
    source_field_name: Optional[str] = None
    target_field_name: Optional[str] = None
    transformation_type: Optional[str] = None
    expression: Optional[str] = None
    confidence: float = 1.0
    annotator: Optional[str] = None
    annotation_date: Optional[str] = None
    notes: Optional[str] = None


@dataclass
class PilotTableConfig:
    """试点配置"""

    pilot_tables: List[PilotTable] = field(default_factory=list)
    data_sources: List[DataSourceConfig] = field(default_factory=list)
    collection_tasks: List[CollectionTaskConfig] = field(default_factory=list)
    manual_annotations: List[ManualAnnotation] = field(default_factory=list)
    validation_threshold: float = 0.85
    coverage_threshold: float = 0.80

    def get_table_by_id(self, table_id: str) -> Optional[PilotTable]:
        """
        根据 ID 获取试点表

        Args:
            table_id: 表 ID

        Returns:
            Optional[PilotTable]: 试点表
        """
        for table in self.pilot_tables:
            if table.table_id == table_id:
                return table
        return None

    def get_tables_by_data_source(self, data_source_id: str) -> List[PilotTable]:
        """
        根据数据源获取试点表列表

        Args:
            data_source_id: 数据源 ID

        Returns:
            List[PilotTable]: 试点表列表
        """
        return [
            table
            for table in self.pilot_tables
            if table.data_source_id == data_source_id
        ]

    def get_tables_by_priority(self, priority: TablePriority) -> List[PilotTable]:
        """
        根据优先级获取试点表列表

        Args:
            priority: 优先级

        Returns:
            List[PilotTable]: 试点表列表
        """
        return [
            table for table in self.pilot_tables if table.priority == priority
        ]

    def get_data_source_by_id(self, data_source_id: str) -> Optional[DataSourceConfig]:
        """
        根据 ID 获取数据源配置

        Args:
            data_source_id: 数据源 ID

        Returns:
            Optional[DataSourceConfig]: 数据源配置
        """
        for ds in self.data_sources:
            if ds.data_source_id == data_source_id:
                return ds
        return None

    def get_task_by_id(self, task_id: str) -> Optional[CollectionTaskConfig]:
        """
        根据 ID 获取采集任务配置

        Args:
            task_id: 任务 ID

        Returns:
            Optional[CollectionTaskConfig]: 采集任务配置
        """
        for task in self.collection_tasks:
            if task.task_id == task_id:
                return task
        return None

    def get_annotations_by_table(self, table_id: str) -> List[ManualAnnotation]:
        """
        根据表获取人工标注列表

        Args:
            table_id: 表 ID（可以是源表或目标表）

        Returns:
            List[ManualAnnotation]: 人工标注列表
        """
        return [
            annotation
            for annotation in self.manual_annotations
            if annotation.source_table_id == table_id
            or annotation.target_table_id == table_id
        ]

    def get_high_priority_tables(self) -> List[PilotTable]:
        """
        获取高优先级试点表

        Returns:
            List[PilotTable]: 高优先级试点表列表
        """
        return self.get_tables_by_priority(TablePriority.HIGH)

    def get_tables_with_annotations(self) -> List[PilotTable]:
        """
        获取有人工标注的试点表

        Returns:
            List[PilotTable]: 有人工标注的试点表列表
        """
        return [table for table in self.pilot_tables if table.has_manual_annotation]

    def get_total_expected_lineage_count(self) -> int:
        """
        获取总预期血缘数量

        Returns:
            int: 总预期血缘数量
        """
        return sum(table.expected_lineage_count for table in self.pilot_tables)

    def get_annotation_count(self) -> int:
        """
        获取人工标注数量

        Returns:
            int: 人工标注数量
        """
        return len(self.manual_annotations)


def get_default_pilot_tables() -> List[PilotTable]:
    """
    获取默认试点表列表（核心业务表）

    Returns:
        List[PilotTable]: 试点表列表
    """
    return [
        PilotTable(
            table_id="oracle:finance:account_balance",
            table_name="account_balance",
            schema_name="finance",
            data_source_id="oracle_finance",
            priority=TablePriority.HIGH,
            business_domain="财务",
            description="账户余额表",
            expected_lineage_count=15,
            has_manual_annotation=True,
            tags=["核心表", "财务", "日终"],
        ),
        PilotTable(
            table_id="oracle:finance:transaction_log",
            table_name="transaction_log",
            schema_name="finance",
            data_source_id="oracle_finance",
            priority=TablePriority.HIGH,
            business_domain="财务",
            description="交易流水表",
            expected_lineage_count=20,
            has_manual_annotation=True,
            tags=["核心表", "财务", "实时"],
        ),
        PilotTable(
            table_id="oracle:finance:daily_report",
            table_name="daily_report",
            schema_name="finance",
            data_source_id="oracle_finance",
            priority=TablePriority.HIGH,
            business_domain="财务",
            description="日报汇总表",
            expected_lineage_count=12,
            has_manual_annotation=True,
            tags=["核心表", "财务", "报表"],
        ),
        PilotTable(
            table_id="oracle:finance:monthly_summary",
            table_name="monthly_summary",
            schema_name="finance",
            data_source_id="oracle_finance",
            priority=TablePriority.HIGH,
            business_domain="财务",
            description="月度汇总表",
            expected_lineage_count=8,
            has_manual_annotation=True,
            tags=["核心表", "财务", "报表"],
        ),
        PilotTable(
            table_id="oracle:crm:customer_info",
            table_name="customer_info",
            schema_name="crm",
            data_source_id="oracle_crm",
            priority=TablePriority.HIGH,
            business_domain="客户管理",
            description="客户信息表",
            expected_lineage_count=18,
            has_manual_annotation=True,
            tags=["核心表", "CRM", "主数据"],
        ),
        PilotTable(
            table_id="oracle:crm:customer_contact",
            table_name="customer_contact",
            schema_name="crm",
            data_source_id="oracle_crm",
            priority=TablePriority.MEDIUM,
            business_domain="客户管理",
            description="客户联系方式表",
            expected_lineage_count=10,
            has_manual_annotation=True,
            tags=["CRM", "主数据"],
        ),
        PilotTable(
            table_id="oracle:crm:order_detail",
            table_name="order_detail",
            schema_name="crm",
            data_source_id="oracle_crm",
            priority=TablePriority.HIGH,
            business_domain="订单管理",
            description="订单明细表",
            expected_lineage_count=25,
            has_manual_annotation=True,
            tags=["核心表", "CRM", "订单"],
        ),
        PilotTable(
            table_id="oracle:crm:order_summary",
            table_name="order_summary",
            schema_name="crm",
            data_source_id="oracle_crm",
            priority=TablePriority.MEDIUM,
            business_domain="订单管理",
            description="订单汇总表",
            expected_lineage_count=8,
            has_manual_annotation=True,
            tags=["CRM", "订单", "报表"],
        ),
        PilotTable(
            table_id="oracle:hr:employee_info",
            table_name="employee_info",
            schema_name="hr",
            data_source_id="oracle_hr",
            priority=TablePriority.MEDIUM,
            business_domain="人力资源",
            description="员工信息表",
            expected_lineage_count=12,
            has_manual_annotation=True,
            tags=["HR", "主数据"],
        ),
        PilotTable(
            table_id="oracle:hr:salary_record",
            table_name="salary_record",
            schema_name="hr",
            data_source_id="oracle_hr",
            priority=TablePriority.MEDIUM,
            business_domain="人力资源",
            description="薪资记录表",
            expected_lineage_count=15,
            has_manual_annotation=True,
            tags=["HR", "薪资"],
        ),
        PilotTable(
            table_id="oracle:hr:attendance_log",
            table_name="attendance_log",
            schema_name="hr",
            data_source_id="oracle_hr",
            priority=TablePriority.LOW,
            business_domain="人力资源",
            description="考勤记录表",
            expected_lineage_count=6,
            has_manual_annotation=False,
            tags=["HR", "考勤"],
        ),
        PilotTable(
            table_id="oracle:inventory:product_info",
            table_name="product_info",
            schema_name="inventory",
            data_source_id="oracle_inventory",
            priority=TablePriority.HIGH,
            business_domain="库存管理",
            description="产品信息表",
            expected_lineage_count=20,
            has_manual_annotation=True,
            tags=["核心表", "库存", "主数据"],
        ),
        PilotTable(
            table_id="oracle:inventory:stock_record",
            table_name="stock_record",
            schema_name="inventory",
            data_source_id="oracle_inventory",
            priority=TablePriority.HIGH,
            business_domain="库存管理",
            description="库存记录表",
            expected_lineage_count=18,
            has_manual_annotation=True,
            tags=["核心表", "库存"],
        ),
        PilotTable(
            table_id="oracle:inventory:warehouse_info",
            table_name="warehouse_info",
            schema_name="inventory",
            data_source_id="oracle_inventory",
            priority=TablePriority.MEDIUM,
            business_domain="库存管理",
            description="仓库信息表",
            expected_lineage_count=8,
            has_manual_annotation=True,
            tags=["库存", "主数据"],
        ),
        PilotTable(
            table_id="oracle:inventory:stock_movement",
            table_name="stock_movement",
            schema_name="inventory",
            data_source_id="oracle_inventory",
            priority=TablePriority.MEDIUM,
            business_domain="库存管理",
            description="库存移动记录表",
            expected_lineage_count=12,
            has_manual_annotation=True,
            tags=["库存", "流水"],
        ),
        PilotTable(
            table_id="tdh:datalake:raw_transaction",
            table_name="raw_transaction",
            schema_name="datalake",
            data_source_id="tdh_datalake",
            priority=TablePriority.HIGH,
            business_domain="数据湖",
            description="原始交易数据表",
            expected_lineage_count=30,
            has_manual_annotation=True,
            tags=["核心表", "数据湖", "原始数据"],
        ),
        PilotTable(
            table_id="tdh:datalake:cleaned_transaction",
            table_name="cleaned_transaction",
            schema_name="datalake",
            data_source_id="tdh_datalake",
            priority=TablePriority.HIGH,
            business_domain="数据湖",
            description="清洗后交易数据表",
            expected_lineage_count=25,
            has_manual_annotation=True,
            tags=["核心表", "数据湖", "清洗数据"],
        ),
        PilotTable(
            table_id="tdh:datalake:aggregated_report",
            table_name="aggregated_report",
            schema_name="datalake",
            data_source_id="tdh_datalake",
            priority=TablePriority.MEDIUM,
            business_domain="数据湖",
            description="聚合报表数据表",
            expected_lineage_count=15,
            has_manual_annotation=True,
            tags=["数据湖", "报表"],
        ),
        PilotTable(
            table_id="tdh:datalake:customer_profile",
            table_name="customer_profile",
            schema_name="datalake",
            data_source_id="tdh_datalake",
            priority=TablePriority.HIGH,
            business_domain="数据湖",
            description="客户画像表",
            expected_lineage_count=22,
            has_manual_annotation=True,
            tags=["核心表", "数据湖", "画像"],
        ),
        PilotTable(
            table_id="tdh:datalake:product_analysis",
            table_name="product_analysis",
            schema_name="datalake",
            data_source_id="tdh_datalake",
            priority=TablePriority.MEDIUM,
            business_domain="数据湖",
            description="产品分析表",
            expected_lineage_count=10,
            has_manual_annotation=True,
            tags=["数据湖", "分析"],
        ),
        PilotTable(
            table_id="oceanbase:report:daily_metrics",
            table_name="daily_metrics",
            schema_name="report",
            data_source_id="oceanbase_report",
            priority=TablePriority.HIGH,
            business_domain="报表",
            description="日指标报表",
            expected_lineage_count=20,
            has_manual_annotation=True,
            tags=["核心表", "报表", "指标"],
        ),
        PilotTable(
            table_id="oceanbase:report:weekly_metrics",
            table_name="weekly_metrics",
            schema_name="report",
            data_source_id="oceanbase_report",
            priority=TablePriority.MEDIUM,
            business_domain="报表",
            description="周指标报表",
            expected_lineage_count=15,
            has_manual_annotation=True,
            tags=["报表", "指标"],
        ),
        PilotTable(
            table_id="oceanbase:report:monthly_metrics",
            table_name="monthly_metrics",
            schema_name="report",
            data_source_id="oceanbase_report",
            priority=TablePriority.MEDIUM,
            business_domain="报表",
            description="月指标报表",
            expected_lineage_count=12,
            has_manual_annotation=True,
            tags=["报表", "指标"],
        ),
        PilotTable(
            table_id="oceanbase:report:kpi_dashboard",
            table_name="kpi_dashboard",
            schema_name="report",
            data_source_id="oceanbase_report",
            priority=TablePriority.HIGH,
            business_domain="报表",
            description="KPI仪表盘数据表",
            expected_lineage_count=18,
            has_manual_annotation=True,
            tags=["核心表", "报表", "KPI"],
        ),
        PilotTable(
            table_id="gbase:analytics:user_behavior",
            table_name="user_behavior",
            schema_name="analytics",
            data_source_id="gbase_analytics",
            priority=TablePriority.HIGH,
            business_domain="分析",
            description="用户行为分析表",
            expected_lineage_count=25,
            has_manual_annotation=True,
            tags=["核心表", "分析", "用户行为"],
        ),
        PilotTable(
            table_id="gbase:analytics:product_sales",
            table_name="product_sales",
            schema_name="analytics",
            data_source_id="gbase_analytics",
            priority=TablePriority.HIGH,
            business_domain="分析",
            description="产品销售分析表",
            expected_lineage_count=20,
            has_manual_annotation=True,
            tags=["核心表", "分析", "销售"],
        ),
        PilotTable(
            table_id="gbase:analytics:market_trend",
            table_name="market_trend",
            schema_name="analytics",
            data_source_id="gbase_analytics",
            priority=TablePriority.MEDIUM,
            business_domain="分析",
            description="市场趋势分析表",
            expected_lineage_count=12,
            has_manual_annotation=True,
            tags=["分析", "市场"],
        ),
        PilotTable(
            table_id="gbase:analytics:customer_segment",
            table_name="customer_segment",
            schema_name="analytics",
            data_source_id="gbase_analytics",
            priority=TablePriority.MEDIUM,
            business_domain="分析",
            description="客户分群表",
            expected_lineage_count=15,
            has_manual_annotation=True,
            tags=["分析", "客户分群"],
        ),
        PilotTable(
            table_id="yashan:archive:transaction_archive",
            table_name="transaction_archive",
            schema_name="archive",
            data_source_id="yashan_archive",
            priority=TablePriority.LOW,
            business_domain="归档",
            description="交易归档表",
            expected_lineage_count=8,
            has_manual_annotation=False,
            tags=["归档", "历史数据"],
        ),
        PilotTable(
            table_id="yashan:archive:customer_archive",
            table_name="customer_archive",
            schema_name="archive",
            data_source_id="yashan_archive",
            priority=TablePriority.LOW,
            business_domain="归档",
            description="客户归档表",
            expected_lineage_count=6,
            has_manual_annotation=False,
            tags=["归档", "历史数据"],
        ),
        PilotTable(
            table_id="oracle:finance:budget_plan",
            table_name="budget_plan",
            schema_name="finance",
            data_source_id="oracle_finance",
            priority=TablePriority.MEDIUM,
            business_domain="财务",
            description="预算计划表",
            expected_lineage_count=10,
            has_manual_annotation=True,
            tags=["财务", "预算"],
        ),
        PilotTable(
            table_id="oracle:finance:expense_record",
            table_name="expense_record",
            schema_name="finance",
            data_source_id="oracle_finance",
            priority=TablePriority.MEDIUM,
            business_domain="财务",
            description="费用记录表",
            expected_lineage_count=12,
            has_manual_annotation=True,
            tags=["财务", "费用"],
        ),
        PilotTable(
            table_id="oracle:finance:invoice_detail",
            table_name="invoice_detail",
            schema_name="finance",
            data_source_id="oracle_finance",
            priority=TablePriority.MEDIUM,
            business_domain="财务",
            description="发票明细表",
            expected_lineage_count=15,
            has_manual_annotation=True,
            tags=["财务", "发票"],
        ),
        PilotTable(
            table_id="oracle:crm:product_catalog",
            table_name="product_catalog",
            schema_name="crm",
            data_source_id="oracle_crm",
            priority=TablePriority.MEDIUM,
            business_domain="产品管理",
            description="产品目录表",
            expected_lineage_count=8,
            has_manual_annotation=True,
            tags=["CRM", "产品"],
        ),
        PilotTable(
            table_id="oracle:crm:price_list",
            table_name="price_list",
            schema_name="crm",
            data_source_id="oracle_crm",
            priority=TablePriority.MEDIUM,
            business_domain="价格管理",
            description="价格列表表",
            expected_lineage_count=10,
            has_manual_annotation=True,
            tags=["CRM", "价格"],
        ),
        PilotTable(
            table_id="oracle:crm:promotion_record",
            table_name="promotion_record",
            schema_name="crm",
            data_source_id="oracle_crm",
            priority=TablePriority.LOW,
            business_domain="营销",
            description="促销记录表",
            expected_lineage_count=6,
            has_manual_annotation=False,
            tags=["CRM", "促销"],
        ),
        PilotTable(
            table_id="oracle:hr:department_info",
            table_name="department_info",
            schema_name="hr",
            data_source_id="oracle_hr",
            priority=TablePriority.MEDIUM,
            business_domain="人力资源",
            description="部门信息表",
            expected_lineage_count=8,
            has_manual_annotation=True,
            tags=["HR", "组织"],
        ),
        PilotTable(
            table_id="oracle:hr:position_info",
            table_name="position_info",
            schema_name="hr",
            data_source_id="oracle_hr",
            priority=TablePriority.MEDIUM,
            business_domain="人力资源",
            description="职位信息表",
            expected_lineage_count=6,
            has_manual_annotation=True,
            tags=["HR", "组织"],
        ),
        PilotTable(
            table_id="oracle:hr:training_record",
            table_name="training_record",
            schema_name="hr",
            data_source_id="oracle_hr",
            priority=TablePriority.LOW,
            business_domain="人力资源",
            description="培训记录表",
            expected_lineage_count=5,
            has_manual_annotation=False,
            tags=["HR", "培训"],
        ),
        PilotTable(
            table_id="oracle:inventory:supplier_info",
            table_name="supplier_info",
            schema_name="inventory",
            data_source_id="oracle_inventory",
            priority=TablePriority.MEDIUM,
            business_domain="库存管理",
            description="供应商信息表",
            expected_lineage_count=10,
            has_manual_annotation=True,
            tags=["库存", "供应商"],
        ),
        PilotTable(
            table_id="oracle:inventory:purchase_order",
            table_name="purchase_order",
            schema_name="inventory",
            data_source_id="oracle_inventory",
            priority=TablePriority.MEDIUM,
            business_domain="库存管理",
            description="采购订单表",
            expected_lineage_count=12,
            has_manual_annotation=True,
            tags=["库存", "采购"],
        ),
        PilotTable(
            table_id="tdh:datalake:log_archive",
            table_name="log_archive",
            schema_name="datalake",
            data_source_id="tdh_datalake",
            priority=TablePriority.LOW,
            business_domain="数据湖",
            description="日志归档表",
            expected_lineage_count=5,
            has_manual_annotation=False,
            tags=["数据湖", "日志"],
        ),
        PilotTable(
            table_id="tdh:datalake:error_record",
            table_name="error_record",
            schema_name="datalake",
            data_source_id="tdh_datalake",
            priority=TablePriority.LOW,
            business_domain="数据湖",
            description="错误记录表",
            expected_lineage_count=4,
            has_manual_annotation=False,
            tags=["数据湖", "错误"],
        ),
        PilotTable(
            table_id="oceanbase:report:audit_log",
            table_name="audit_log",
            schema_name="report",
            data_source_id="oceanbase_report",
            priority=TablePriority.LOW,
            business_domain="报表",
            description="审计日志表",
            expected_lineage_count=3,
            has_manual_annotation=False,
            tags=["报表", "审计"],
        ),
        PilotTable(
            table_id="gbase:analytics:report_config",
            table_name="report_config",
            schema_name="analytics",
            data_source_id="gbase_analytics",
            priority=TablePriority.LOW,
            business_domain="分析",
            description="报表配置表",
            expected_lineage_count=2,
            has_manual_annotation=False,
            tags=["分析", "配置"],
        ),
        PilotTable(
            table_id="yashan:archive:log_backup",
            table_name="log_backup",
            schema_name="archive",
            data_source_id="yashan_archive",
            priority=TablePriority.LOW,
            business_domain="归档",
            description="日志备份表",
            expected_lineage_count=2,
            has_manual_annotation=False,
            tags=["归档", "备份"],
        ),
    ]


def get_default_data_sources() -> List[DataSourceConfig]:
    """
    获取默认数据源配置

    Returns:
        List[DataSourceConfig]: 数据源配置列表
    """
    return [
        DataSourceConfig(
            data_source_id="oracle_finance",
            name="Oracle财务系统",
            type=DataSourceType.ORACLE,
            host="192.168.1.100",
            port=1521,
            database_name="finance",
            username="finance_user",
            password="finance_pass",
            service_name="FINANCE",
            enabled=True,
            priority=TablePriority.HIGH,
        ),
        DataSourceConfig(
            data_source_id="oracle_crm",
            name="Oracle CRM系统",
            type=DataSourceType.ORACLE,
            host="192.168.1.101",
            port=1521,
            database_name="crm",
            username="crm_user",
            password="crm_pass",
            service_name="CRM",
            enabled=True,
            priority=TablePriority.HIGH,
        ),
        DataSourceConfig(
            data_source_id="oracle_hr",
            name="Oracle人力资源系统",
            type=DataSourceType.ORACLE,
            host="192.168.1.102",
            port=1521,
            database_name="hr",
            username="hr_user",
            password="hr_pass",
            service_name="HR",
            enabled=True,
            priority=TablePriority.MEDIUM,
        ),
        DataSourceConfig(
            data_source_id="oracle_inventory",
            name="Oracle库存管理系统",
            type=DataSourceType.ORACLE,
            host="192.168.1.103",
            port=1521,
            database_name="inventory",
            username="inventory_user",
            password="inventory_pass",
            service_name="INVENTORY",
            enabled=True,
            priority=TablePriority.HIGH,
        ),
        DataSourceConfig(
            data_source_id="tdh_datalake",
            name="TDH数据湖",
            type=DataSourceType.TDH,
            host="192.168.2.100",
            port=9030,
            database_name="datalake",
            username="datalake_user",
            password="datalake_pass",
            enabled=True,
            priority=TablePriority.HIGH,
        ),
        DataSourceConfig(
            data_source_id="oceanbase_report",
            name="OceanBase报表系统",
            type=DataSourceType.OCEANBASE,
            host="192.168.3.100",
            port=2881,
            database_name="report",
            username="report_user",
            password="report_pass",
            enabled=True,
            priority=TablePriority.HIGH,
        ),
        DataSourceConfig(
            data_source_id="gbase_analytics",
            name="GBase分析系统",
            type=DataSourceType.GBASE,
            host="192.168.4.100",
            port=5258,
            database_name="analytics",
            username="analytics_user",
            password="analytics_pass",
            enabled=True,
            priority=TablePriority.HIGH,
        ),
        DataSourceConfig(
            data_source_id="yashan_archive",
            name="Yashan归档系统",
            type=DataSourceType.YASHAN,
            host="192.168.5.100",
            port=1688,
            database_name="archive",
            username="archive_user",
            password="archive_pass",
            enabled=True,
            priority=TablePriority.LOW,
        ),
    ]


def get_default_collection_tasks() -> List[CollectionTaskConfig]:
    """
    获取默认采集任务配置

    Returns:
        List[CollectionTaskConfig]: 采集任务配置列表
    """
    return [
        CollectionTaskConfig(
            task_id="task_oracle_finance_static",
            task_name="Oracle财务系统静态采集",
            data_source_id="oracle_finance",
            collection_type=CollectionType.STATIC,
            target_tables=[
                "oracle:finance:account_balance",
                "oracle:finance:transaction_log",
                "oracle:finance:daily_report",
                "oracle:finance:monthly_summary",
                "oracle:finance:budget_plan",
                "oracle:finance:expense_record",
                "oracle:finance:invoice_detail",
            ],
            schedule="0 2 * * *",
            batch_size=1000,
            timeout_seconds=300,
            max_retries=3,
            enabled=True,
            priority=TablePriority.HIGH,
        ),
        CollectionTaskConfig(
            task_id="task_oracle_crm_static",
            task_name="Oracle CRM系统静态采集",
            data_source_id="oracle_crm",
            collection_type=CollectionType.STATIC,
            target_tables=[
                "oracle:crm:customer_info",
                "oracle:crm:customer_contact",
                "oracle:crm:order_detail",
                "oracle:crm:order_summary",
                "oracle:crm:product_catalog",
                "oracle:crm:price_list",
                "oracle:crm:promotion_record",
            ],
            schedule="0 3 * * *",
            batch_size=1000,
            timeout_seconds=300,
            max_retries=3,
            enabled=True,
            priority=TablePriority.HIGH,
        ),
        CollectionTaskConfig(
            task_id="task_oracle_hr_static",
            task_name="Oracle人力资源系统静态采集",
            data_source_id="oracle_hr",
            collection_type=CollectionType.STATIC,
            target_tables=[
                "oracle:hr:employee_info",
                "oracle:hr:salary_record",
                "oracle:hr:attendance_log",
                "oracle:hr:department_info",
                "oracle:hr:position_info",
                "oracle:hr:training_record",
            ],
            schedule="0 4 * * *",
            batch_size=500,
            timeout_seconds=200,
            max_retries=3,
            enabled=True,
            priority=TablePriority.MEDIUM,
        ),
        CollectionTaskConfig(
            task_id="task_oracle_inventory_static",
            task_name="Oracle库存管理系统静态采集",
            data_source_id="oracle_inventory",
            collection_type=CollectionType.STATIC,
            target_tables=[
                "oracle:inventory:product_info",
                "oracle:inventory:stock_record",
                "oracle:inventory:warehouse_info",
                "oracle:inventory:stock_movement",
                "oracle:inventory:supplier_info",
                "oracle:inventory:purchase_order",
            ],
            schedule="0 5 * * *",
            batch_size=1000,
            timeout_seconds=300,
            max_retries=3,
            enabled=True,
            priority=TablePriority.HIGH,
        ),
        CollectionTaskConfig(
            task_id="task_tdh_datalake_full",
            task_name="TDH数据湖全量采集",
            data_source_id="tdh_datalake",
            collection_type=CollectionType.FULL,
            target_tables=[
                "tdh:datalake:raw_transaction",
                "tdh:datalake:cleaned_transaction",
                "tdh:datalake:aggregated_report",
                "tdh:datalake:customer_profile",
                "tdh:datalake:product_analysis",
                "tdh:datalake:log_archive",
                "tdh:datalake:error_record",
            ],
            schedule="0 6 * * *",
            batch_size=2000,
            timeout_seconds=600,
            max_retries=5,
            enabled=True,
            priority=TablePriority.HIGH,
        ),
        CollectionTaskConfig(
            task_id="task_oceanbase_report_runtime",
            task_name="OceanBase报表系统运行态采集",
            data_source_id="oceanbase_report",
            collection_type=CollectionType.RUNTIME,
            target_tables=[
                "oceanbase:report:daily_metrics",
                "oceanbase:report:weekly_metrics",
                "oceanbase:report:monthly_metrics",
                "oceanbase:report:kpi_dashboard",
                "oceanbase:report:audit_log",
            ],
            schedule="*/30 * * * *",
            batch_size=500,
            timeout_seconds=180,
            max_retries=3,
            enabled=True,
            priority=TablePriority.HIGH,
        ),
        CollectionTaskConfig(
            task_id="task_gbase_analytics_full",
            task_name="GBase分析系统全量采集",
            data_source_id="gbase_analytics",
            collection_type=CollectionType.FULL,
            target_tables=[
                "gbase:analytics:user_behavior",
                "gbase:analytics:product_sales",
                "gbase:analytics:market_trend",
                "gbase:analytics:customer_segment",
                "gbase:analytics:report_config",
            ],
            schedule="0 7 * * *",
            batch_size=1500,
            timeout_seconds=400,
            max_retries=3,
            enabled=True,
            priority=TablePriority.HIGH,
        ),
        CollectionTaskConfig(
            task_id="task_yashan_archive_static",
            task_name="Yashan归档系统静态采集",
            data_source_id="yashan_archive",
            collection_type=CollectionType.STATIC,
            target_tables=[
                "yashan:archive:transaction_archive",
                "yashan:archive:customer_archive",
                "yashan:archive:log_backup",
            ],
            schedule="0 0 * * 0",
            batch_size=500,
            timeout_seconds=200,
            max_retries=2,
            enabled=True,
            priority=TablePriority.LOW,
        ),
    ]


def get_default_manual_annotations() -> List[ManualAnnotation]:
    """
    获取默认人工标注血缘

    Returns:
        List[ManualAnnotation]: 人工标注列表
    """
    return [
        ManualAnnotation(
            annotation_id="anno_001",
            source_table_id="oracle:finance:transaction_log",
            source_field_name="account_id",
            target_table_id="oracle:finance:account_balance",
            target_field_name="account_id",
            transformation_type="direct",
            expression="account_id",
            confidence=1.0,
            annotator="张三",
            annotation_date="2024-01-15",
            notes="直接映射",
        ),
        ManualAnnotation(
            annotation_id="anno_002",
            source_table_id="oracle:finance:transaction_log",
            source_field_name="amount",
            target_table_id="oracle:finance:account_balance",
            target_field_name="balance",
            transformation_type="aggregation",
            expression="SUM(amount)",
            confidence=1.0,
            annotator="张三",
            annotation_date="2024-01-15",
            notes="聚合计算",
        ),
        ManualAnnotation(
            annotation_id="anno_003",
            source_table_id="oracle:finance:transaction_log",
            source_field_name="transaction_date",
            target_table_id="oracle:finance:daily_report",
            target_field_name="report_date",
            transformation_type="direct",
            expression="transaction_date",
            confidence=1.0,
            annotator="李四",
            annotation_date="2024-01-16",
            notes="日期直接映射",
        ),
        ManualAnnotation(
            annotation_id="anno_004",
            source_table_id="oracle:finance:transaction_log",
            source_field_name="amount",
            target_table_id="oracle:finance:daily_report",
            target_field_name="total_amount",
            transformation_type="aggregation",
            expression="SUM(amount) GROUP BY transaction_date",
            confidence=1.0,
            annotator="李四",
            annotation_date="2024-01-16",
            notes="按日期聚合",
        ),
        ManualAnnotation(
            annotation_id="anno_005",
            source_table_id="oracle:crm:customer_info",
            source_field_name="customer_id",
            target_table_id="oracle:crm:order_detail",
            target_field_name="customer_id",
            transformation_type="direct",
            expression="customer_id",
            confidence=1.0,
            annotator="王五",
            annotation_date="2024-01-17",
            notes="客户ID直接映射",
        ),
        ManualAnnotation(
            annotation_id="anno_006",
            source_table_id="oracle:crm:order_detail",
            source_field_name="order_id",
            target_table_id="oracle:crm:order_summary",
            target_field_name="order_id",
            transformation_type="direct",
            expression="order_id",
            confidence=1.0,
            annotator="王五",
            annotation_date="2024-01-17",
            notes="订单ID直接映射",
        ),
        ManualAnnotation(
            annotation_id="anno_007",
            source_table_id="oracle:crm:order_detail",
            source_field_name="quantity",
            target_table_id="oracle:crm:order_summary",
            target_field_name="total_quantity",
            transformation_type="aggregation",
            expression="SUM(quantity) GROUP BY order_id",
            confidence=1.0,
            annotator="王五",
            annotation_date="2024-01-17",
            notes="数量聚合",
        ),
        ManualAnnotation(
            annotation_id="anno_008",
            source_table_id="oracle:crm:order_detail",
            source_field_name="unit_price",
            target_table_id="oracle:crm:order_summary",
            target_field_name="total_amount",
            transformation_type="aggregation",
            expression="SUM(quantity * unit_price) GROUP BY order_id",
            confidence=1.0,
            annotator="王五",
            annotation_date="2024-01-17",
            notes="金额计算",
        ),
        ManualAnnotation(
            annotation_id="anno_009",
            source_table_id="tdh:datalake:raw_transaction",
            source_field_name="transaction_id",
            target_table_id="tdh:datalake:cleaned_transaction",
            target_field_name="transaction_id",
            transformation_type="direct",
            expression="transaction_id",
            confidence=1.0,
            annotator="赵六",
            annotation_date="2024-01-18",
            notes="交易ID直接映射",
        ),
        ManualAnnotation(
            annotation_id="anno_010",
            source_table_id="tdh:datalake:raw_transaction",
            source_field_name="raw_amount",
            target_table_id="tdh:datalake:cleaned_transaction",
            target_field_name="amount",
            transformation_type="transformation",
            expression="CAST(raw_amount AS DECIMAL(18,2))",
            confidence=1.0,
            annotator="赵六",
            annotation_date="2024-01-18",
            notes="类型转换",
        ),
        ManualAnnotation(
            annotation_id="anno_011",
            source_table_id="tdh:datalake:cleaned_transaction",
            source_field_name="customer_id",
            target_table_id="tdh:datalake:customer_profile",
            target_field_name="customer_id",
            transformation_type="direct",
            expression="customer_id",
            confidence=1.0,
            annotator="赵六",
            annotation_date="2024-01-18",
            notes="客户ID直接映射",
        ),
        ManualAnnotation(
            annotation_id="anno_012",
            source_table_id="tdh:datalake:cleaned_transaction",
            source_field_name="amount",
            target_table_id="tdh:datalake:customer_profile",
            target_field_name="total_spent",
            transformation_type="aggregation",
            expression="SUM(amount) GROUP BY customer_id",
            confidence=1.0,
            annotator="赵六",
            annotation_date="2024-01-18",
            notes="消费总额聚合",
        ),
        ManualAnnotation(
            annotation_id="anno_013",
            source_table_id="oracle:inventory:product_info",
            source_field_name="product_id",
            target_table_id="oracle:inventory:stock_record",
            target_field_name="product_id",
            transformation_type="direct",
            expression="product_id",
            confidence=1.0,
            annotator="孙七",
            annotation_date="2024-01-19",
            notes="产品ID直接映射",
        ),
        ManualAnnotation(
            annotation_id="anno_014",
            source_table_id="oracle:inventory:stock_record",
            source_field_name="quantity",
            target_table_id="oracle:inventory:stock_movement",
            target_field_name="movement_quantity",
            transformation_type="direct",
            expression="quantity",
            confidence=1.0,
            annotator="孙七",
            annotation_date="2024-01-19",
            notes="库存数量直接映射",
        ),
        ManualAnnotation(
            annotation_id="anno_015",
            source_table_id="gbase:analytics:user_behavior",
            source_field_name="user_id",
            target_table_id="gbase:analytics:customer_segment",
            target_field_name="user_id",
            transformation_type="direct",
            expression="user_id",
            confidence=1.0,
            annotator="周八",
            annotation_date="2024-01-20",
            notes="用户ID直接映射",
        ),
    ]


def get_pilot_config() -> PilotTableConfig:
    """
    获取试点配置实例

    Returns:
        PilotTableConfig: 试点配置
    """
    return PilotTableConfig(
        pilot_tables=get_default_pilot_tables(),
        data_sources=get_default_data_sources(),
        collection_tasks=get_default_collection_tasks(),
        manual_annotations=get_default_manual_annotations(),
        validation_threshold=0.85,
        coverage_threshold=0.80,
    )


_pilot_config: Optional[PilotTableConfig] = None


def get_cached_pilot_config() -> PilotTableConfig:
    """
    获取缓存的试点配置实例

    Returns:
        PilotTableConfig: 试点配置
    """
    if _pilot_config is None:
        _pilot_config = get_pilot_config()
    return _pilot_config


def reload_pilot_config() -> PilotTableConfig:
    """
    重新加载试点配置

    Returns:
        PilotTableConfig: 试点配置
    """
    global _pilot_config
    _pilot_config = get_pilot_config()
    return _pilot_config