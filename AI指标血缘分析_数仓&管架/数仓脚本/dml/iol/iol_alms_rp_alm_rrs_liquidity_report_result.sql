/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_alms_rp_alm_rrs_liquidity_report_result
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
drop table ${iol_schema}.alms_rp_alm_rrs_liquidity_report_result_ex purge;
alter table ${iol_schema}.alms_rp_alm_rrs_liquidity_report_result add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.alms_rp_alm_rrs_liquidity_report_result;

-- 2.3 insert data to ex table
create table ${iol_schema}.alms_rp_alm_rrs_liquidity_report_result_ex nologging
compress
as
select * from ${iol_schema}.alms_rp_alm_rrs_liquidity_report_result where 0=1;

insert /*+ append */ into ${iol_schema}.alms_rp_alm_rrs_liquidity_report_result_ex(
    v_rep_cd -- 报表id
    ,v_rep_line_order -- 序号
    ,n_rep_line_cd -- 报表条目编号
    ,v_rep_line_name -- 报表条目名称(即指标名称)
    ,v_rep_line_display_order -- 报表条目展示顺序号
    ,n_bold_ind -- 粗体展示标识:0：正常；1：粗体
    ,n_indent_level -- 缩进级别：0：不缩进；1：缩进一级；2：缩进2级；3：缩进3级；4：缩进4级；；5：缩进5级；
    ,v_regulatory_level -- 监控级别
    ,v_index_class -- 指标分类
    ,v_supervision_require -- 监管要求
    ,v_limit_value -- 限额值
    ,v_prewarning_value -- 预警值
    ,v_index_type -- 指标类型
    ,v_statistical_frequency -- 统计频率
    ,v_monitor_frequency -- 监测频率
    ,v_read_lvl -- 审阅层级
    ,v_department_type -- 指标部门
    ,d_created_dt -- 创建日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    v_rep_cd -- 报表id
    ,v_rep_line_order -- 序号
    ,n_rep_line_cd -- 报表条目编号
    ,v_rep_line_name -- 报表条目名称(即指标名称)
    ,v_rep_line_display_order -- 报表条目展示顺序号
    ,n_bold_ind -- 粗体展示标识:0：正常；1：粗体
    ,n_indent_level -- 缩进级别：0：不缩进；1：缩进一级；2：缩进2级；3：缩进3级；4：缩进4级；；5：缩进5级；
    ,v_regulatory_level -- 监控级别
    ,v_index_class -- 指标分类
    ,v_supervision_require -- 监管要求
    ,v_limit_value -- 限额值
    ,v_prewarning_value -- 预警值
    ,v_index_type -- 指标类型
    ,v_statistical_frequency -- 统计频率
    ,v_monitor_frequency -- 监测频率
    ,v_read_lvl -- 审阅层级
    ,v_department_type -- 指标部门
    ,d_created_dt -- 创建日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.alms_rp_alm_rrs_liquidity_report_result
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.alms_rp_alm_rrs_liquidity_report_result exchange partition p_${batch_date} with table ${iol_schema}.alms_rp_alm_rrs_liquidity_report_result_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.alms_rp_alm_rrs_liquidity_report_result to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.alms_rp_alm_rrs_liquidity_report_result_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'alms_rp_alm_rrs_liquidity_report_result',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);