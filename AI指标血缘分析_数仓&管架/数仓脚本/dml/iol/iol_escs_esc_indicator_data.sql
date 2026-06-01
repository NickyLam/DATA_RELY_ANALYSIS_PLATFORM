/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_escs_esc_indicator_data
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
drop table ${iol_schema}.escs_esc_indicator_data_ex purge;
alter table ${iol_schema}.escs_esc_indicator_data add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.escs_esc_indicator_data;

-- 2.3 insert data to ex table
create table ${iol_schema}.escs_esc_indicator_data_ex nologging
compress
as
select * from ${iol_schema}.escs_esc_indicator_data where 0=1;

insert /*+ append */ into ${iol_schema}.escs_esc_indicator_data_ex(
    id -- ESC指标id
    ,esc_transaction_total_day -- ESC当日交易笔数
    ,transaction_succ_rate -- ESC当日交易成功率
    ,max_tps -- ESC当日最大TPS
    ,esc_transaction_total_month -- ESC月交易笔数
    ,esc_transaction_total_year -- ESC年交易笔数
    ,esc_transaction_total_year_avg -- ESC年均交易笔数
    ,esc_single_service_max_concurrency -- ESC单服务支持最大并发数
    ,esc_standalone_max_concurrency -- ESC单机支持最大并发数
    ,esc_service_num -- ESC服务治理接口数
    ,interface_stock_num -- 存量迁移接口数
    ,access_esc_system_num -- 接入ESC系统数
    ,trace_info_num -- ESC服务治理接口数
    ,transaction_failure_alarm_num -- 交易失败达到设置阀值发送邮件告警数
    ,intraday_interface_stock_active_num -- 当日存量迁移接口活跃数
    ,intraday_esc_service_active_num -- 当日服务治理接口活跃数
    ,softness_and_patent -- 软著和专利
    ,statistics_date -- 统计日期
    ,update_time -- 更新时间
    ,esc_call_total_day -- ESC当日调用笔数
    ,statistics_start_date -- 统计开始日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- ESC指标id
    ,esc_transaction_total_day -- ESC当日交易笔数
    ,transaction_succ_rate -- ESC当日交易成功率
    ,max_tps -- ESC当日最大TPS
    ,esc_transaction_total_month -- ESC月交易笔数
    ,esc_transaction_total_year -- ESC年交易笔数
    ,esc_transaction_total_year_avg -- ESC年均交易笔数
    ,esc_single_service_max_concurrency -- ESC单服务支持最大并发数
    ,esc_standalone_max_concurrency -- ESC单机支持最大并发数
    ,esc_service_num -- ESC服务治理接口数
    ,interface_stock_num -- 存量迁移接口数
    ,access_esc_system_num -- 接入ESC系统数
    ,trace_info_num -- ESC服务治理接口数
    ,transaction_failure_alarm_num -- 交易失败达到设置阀值发送邮件告警数
    ,intraday_interface_stock_active_num -- 当日存量迁移接口活跃数
    ,intraday_esc_service_active_num -- 当日服务治理接口活跃数
    ,softness_and_patent -- 软著和专利
    ,statistics_date -- 统计日期
    ,update_time -- 更新时间
    ,esc_call_total_day -- ESC当日调用笔数
    ,statistics_start_date -- 统计开始日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.escs_esc_indicator_data
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.escs_esc_indicator_data exchange partition p_${batch_date} with table ${iol_schema}.escs_esc_indicator_data_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.escs_esc_indicator_data to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.escs_esc_indicator_data_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'escs_esc_indicator_data',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);