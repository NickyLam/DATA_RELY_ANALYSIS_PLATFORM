/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ccdb_ochat_log_call_worksum
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
drop table ${iol_schema}.ccdb_ochat_log_call_worksum_ex purge;
alter table ${iol_schema}.ccdb_ochat_log_call_worksum add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ccdb_ochat_log_call_worksum truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ccdb_ochat_log_call_worksum_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ccdb_ochat_log_call_worksum where 0=1;

insert /*+ append */ into ${iol_schema}.ccdb_ochat_log_call_worksum_ex(
    sum_no -- 会话小结流水号
    ,call_id -- 呼叫流水号
    ,call_date -- 
    ,skill_group -- 
    ,account_code -- 
    ,agent_id -- 
    ,call_type -- 
    ,channel -- 
    ,buss_code -- 
    ,call_flag -- 
    ,picktime -- 
    ,ringtime -- 
    ,hangtime -- 
    ,acwtime -- 
    ,call_no -- 
    ,ani -- 
    ,locationid -- 
    ,filepath -- 
    ,satisfied_type -- 
    ,satisfied_time -- 
    ,fcr -- 
    ,idcard -- 
    ,ivr_node_name -- 
    ,ivr_node_code -- 
    ,callback_state -- 
    ,by_gone -- 
    ,ext_no -- 
    ,province_name -- 
    ,city_name -- 
    ,workbill_type_code -- 
    ,workbill_type_name -- 
    ,email -- 
    ,emp_name -- 
    ,is_invite -- 
    ,duplicate_sign -- 
    ,line_no -- 
    ,recordid -- 
    ,status -- 小结表状态：1.暂存 2.保存
    ,firsts -- 
    ,cust_active -- 
    ,remark -- 
    ,cust_no -- 客户号
    ,cust_name -- 客户姓名
    ,device_no -- 设备号
    ,buss_type -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    sum_no -- 会话小结流水号
    ,call_id -- 呼叫流水号
    ,call_date -- 
    ,skill_group -- 
    ,account_code -- 
    ,agent_id -- 
    ,call_type -- 
    ,channel -- 
    ,buss_code -- 
    ,call_flag -- 
    ,picktime -- 
    ,ringtime -- 
    ,hangtime -- 
    ,acwtime -- 
    ,call_no -- 
    ,ani -- 
    ,locationid -- 
    ,filepath -- 
    ,satisfied_type -- 
    ,satisfied_time -- 
    ,fcr -- 
    ,idcard -- 
    ,ivr_node_name -- 
    ,ivr_node_code -- 
    ,callback_state -- 
    ,by_gone -- 
    ,ext_no -- 
    ,province_name -- 
    ,city_name -- 
    ,workbill_type_code -- 
    ,workbill_type_name -- 
    ,email -- 
    ,emp_name -- 
    ,is_invite -- 
    ,duplicate_sign -- 
    ,line_no -- 
    ,recordid -- 
    ,status -- 小结表状态：1.暂存 2.保存
    ,firsts -- 
    ,cust_active -- 
    ,remark -- 
    ,cust_no -- 客户号
    ,cust_name -- 客户姓名
    ,device_no -- 设备号
    ,buss_type -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ccdb_ochat_log_call_worksum
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ccdb_ochat_log_call_worksum exchange partition p_${batch_date} with table ${iol_schema}.ccdb_ochat_log_call_worksum_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ccdb_ochat_log_call_worksum to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ccdb_ochat_log_call_worksum_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ccdb_ochat_log_call_worksum',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);