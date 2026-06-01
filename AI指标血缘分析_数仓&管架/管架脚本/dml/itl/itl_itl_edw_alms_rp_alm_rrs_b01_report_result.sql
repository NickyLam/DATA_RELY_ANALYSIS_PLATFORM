/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_alms_rp_alm_rrs_b01_report_result
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
truncate table itl_edw_alms_rp_alm_rrs_b01_report_result;
alter table ${itl_schema}.itl_edw_alms_rp_alm_rrs_b01_report_result drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_alms_rp_alm_rrs_b01_report_result drop partition p_${batch_date};
-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_alms_rp_alm_rrs_b01_report_result add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_alms_rp_alm_rrs_b01_report_result partition for (to_date('${batch_date}','yyyymmdd')) (
    as_of_date -- 数据日期
    ,n_as_of_date_skey -- 报表键值
    ,n_run_skey -- 运行键值
    ,n_entity_skey -- 法人键值
    ,n_business_unit_skey -- 业务条线编码
    ,n_org_unit_skey -- 一级分行代码(即 填报 机构 号 )
    ,n_forecast_point_skey -- 时间窗口键值：0：当前时点；1：当月末时点；2：未来1月末时点；3：未来2月末时点；4：未来3月末时点；5：未来二季度末时点；6：未来三季度末时点;7 :未来四季度末时点
    ,n_report_scenario_skey -- 业务情景键值：1：无预算情景假设；2：业务量不变情景；3：月度预算业务情景；4：年度预算业务情景
    ,n_rep_line_cd -- 报表项编码
    ,v_currency_type -- 币种 1:人民币;2:外币折人民币;3:本外币合计
    ,n_rep_line_value -- 金额
    ,d_created_dt -- 创建日期
    ,n_previous_day_variation -- 较上日变动
    ,n_previous_month_variation -- 较上月变动
    ,n_previous_year_variation -- 较上年变动
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(as_of_date, to_date('00010101', 'yyyymmdd')) as as_of_date -- 数据日期
    ,nvl(trim(n_as_of_date_skey), 0) as n_as_of_date_skey -- 报表键值
    ,nvl(trim(n_run_skey), 0) as n_run_skey -- 运行键值
    ,nvl(trim(n_entity_skey), 0) as n_entity_skey -- 法人键值
    ,nvl(trim(n_business_unit_skey), 0) as n_business_unit_skey -- 业务条线编码
    ,nvl(trim(n_org_unit_skey), 0) as n_org_unit_skey -- 一级分行代码(即 填报 机构 号 )
    ,nvl(trim(n_forecast_point_skey), 0) as n_forecast_point_skey -- 时间窗口键值：0：当前时点；1：当月末时点；2：未来1月末时点；3：未来2月末时点；4：未来3月末时点；5：未来二季度末时点；6：未来三季度末时点;7 :未来四季度末时点
    ,nvl(trim(n_report_scenario_skey), 0) as n_report_scenario_skey -- 业务情景键值：1：无预算情景假设；2：业务量不变情景；3：月度预算业务情景；4：年度预算业务情景
    ,nvl(trim(n_rep_line_cd), 0) as n_rep_line_cd -- 报表项编码
    ,nvl(trim(v_currency_type), ' ') as v_currency_type -- 币种 1:人民币;2:外币折人民币;3:本外币合计
    ,nvl(trim(n_rep_line_value), 0) as n_rep_line_value -- 金额
    ,nvl(d_created_dt, to_date('00010101', 'yyyymmdd')) as d_created_dt -- 创建日期
    ,nvl(trim(n_previous_day_variation), 0) as n_previous_day_variation -- 较上日变动
    ,nvl(trim(n_previous_month_variation), 0) as n_previous_month_variation -- 较上月变动
    ,nvl(trim(n_previous_year_variation), 0) as n_previous_year_variation -- 较上年变动
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_alms_rp_alm_rrs_b01_report_result to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_alms_rp_alm_rrs_b01_report_result',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);