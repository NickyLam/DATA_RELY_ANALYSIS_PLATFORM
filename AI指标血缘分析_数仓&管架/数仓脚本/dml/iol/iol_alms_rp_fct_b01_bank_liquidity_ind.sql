/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_alms_rp_fct_b01_bank_liquidity_ind
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind_ex purge;
alter table ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind;

-- 2.3 insert data to ex table
create table ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind_ex nologging
compress
as
select * from ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind where 0=1;

insert /*+ append */ into ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind_ex(
    as_of_date -- 
    ,n_as_of_date_skey -- 报表键值
    ,n_run_skey -- 运行键值
    ,n_entity_skey -- 法人键值
    ,n_business_unit_skey -- 业务条线编码
    ,n_org_unit_skey -- 一级分行代码(即填报机构号)
    ,n_forecast_point_skey -- 
    ,n_report_scenario_skey -- 业务情景键值：1：无预算情景假设；2：业务量不变情景；3：月度预算业务情景；4：年度预算业务情景
    ,n_rep_line_cd -- 报表项编码
    ,v_currency_type -- 
    ,n_rep_line_value -- 当前值
    ,d_created_dt -- 
    ,n_previous_day_variation -- 
    ,n_previous_month_variation -- 
    ,n_previous_year_variation -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    as_of_date -- 
    ,n_as_of_date_skey -- 报表键值
    ,n_run_skey -- 运行键值
    ,n_entity_skey -- 法人键值
    ,n_business_unit_skey -- 业务条线编码
    ,n_org_unit_skey -- 一级分行代码(即填报机构号)
    ,n_forecast_point_skey -- 
    ,n_report_scenario_skey -- 业务情景键值：1：无预算情景假设；2：业务量不变情景；3：月度预算业务情景；4：年度预算业务情景
    ,n_rep_line_cd -- 报表项编码
    ,v_currency_type -- 
    ,n_rep_line_value -- 当前值
    ,d_created_dt -- 
    ,n_previous_day_variation -- 
    ,n_previous_month_variation -- 
    ,n_previous_year_variation -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.alms_rp_fct_b01_bank_liquidity_ind
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind exchange partition p_${batch_date} with table ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'alms_rp_fct_b01_bank_liquidity_ind',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);