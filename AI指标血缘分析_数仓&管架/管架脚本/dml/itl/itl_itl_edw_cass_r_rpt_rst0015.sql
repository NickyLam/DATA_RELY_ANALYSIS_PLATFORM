/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_cass_r_rpt_rst0015
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_cass_r_rpt_rst0015 drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_cass_r_rpt_rst0015 drop partition p_${last_month_end};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_cass_r_rpt_rst0015 add  partition p_${last_month_end} values (to_date('${last_month_end}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_cass_r_rpt_rst0015 partition for (to_date('${last_month_end}','yyyymmdd')) (
    etl_dt_ora -- 数据日期
    ,curr_cd -- 币种
    ,curr_name -- 币种名称
    ,com_line -- 常规条线
    ,com_line_name -- 常规条线名称
    ,index_level1_class -- 指标一级分类
    ,index_level2_class -- 指标二级分类
    ,index_level3_class -- 指标三级分类
    ,std_pro_no -- 财务集市标准产品
    ,std_pro_name -- 产品名称
    ,manager_org -- 考核机构
    ,manager_org_name -- 考核机构名称
    ,cust_mgr_no -- 客户经理编号
    ,cust_mgr_name -- 客户经理名称
    ,kpi_value_y -- 当年值
    ,kpi_value_m -- 当月值
    ,kpi_value_yy -- 当年值_分子（存贷利差指标：分子）
    ,kpi_value_mm -- 当月值_分子（存贷利差指标：分子）
    ,kpi_value_yoy -- 当年值_分母（存贷利差指标：分母）
    ,kpi_value_mom -- 当月值_分母（存贷利差指标：分母）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(etl_dt_ora, to_date('00010101', 'yyyymmdd')) as etl_dt_ora -- 数据日期
    ,nvl(trim(curr_cd), ' ') as curr_cd -- 币种
    ,nvl(trim(curr_name), ' ') as curr_name -- 币种名称
    ,nvl(trim(com_line), ' ') as com_line -- 常规条线
    ,nvl(trim(com_line_name), ' ') as com_line_name -- 常规条线名称
    ,nvl(trim(index_level1_class), ' ') as index_level1_class -- 指标一级分类
    ,nvl(trim(index_level2_class), ' ') as index_level2_class -- 指标二级分类
    ,nvl(trim(index_level3_class), ' ') as index_level3_class -- 指标三级分类
    ,nvl(trim(std_pro_no), ' ') as std_pro_no -- 财务集市标准产品
    ,nvl(trim(std_pro_name), ' ') as std_pro_name -- 产品名称
    ,nvl(trim(manager_org), ' ') as manager_org -- 考核机构
    ,nvl(trim(manager_org_name), ' ') as manager_org_name -- 考核机构名称
    ,nvl(trim(cust_mgr_no), ' ') as cust_mgr_no -- 客户经理编号
    ,nvl(trim(cust_mgr_name), ' ') as cust_mgr_name -- 客户经理名称
    ,nvl(trim(kpi_value_y), 0) as kpi_value_y -- 当年值
    ,nvl(trim(kpi_value_m), 0) as kpi_value_m -- 当月值
    ,nvl(trim(kpi_value_yy), 0) as kpi_value_yy -- 当年值_分子（存贷利差指标：分子）
    ,nvl(trim(kpi_value_mm), 0) as kpi_value_mm -- 当月值_分子（存贷利差指标：分子）
    ,nvl(trim(kpi_value_yoy), 0) as kpi_value_yoy -- 当年值_分母（存贷利差指标：分母）
    ,nvl(trim(kpi_value_mom), 0) as kpi_value_mom -- 当月值_分母（存贷利差指标：分母）
    ,to_date('${last_month_end}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_cass_r_rpt_rst0015
where etl_dt = to_date('${last_month_end}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_cass_r_rpt_rst0015 to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_cass_r_rpt_rst0015',partname => 'p_${last_month_end}', granularity => 'PARTITION', degree => 8, cascade => true);