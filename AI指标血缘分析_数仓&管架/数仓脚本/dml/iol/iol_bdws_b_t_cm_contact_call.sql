/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdws_b_t_cm_contact_call
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
drop table ${iol_schema}.bdws_b_t_cm_contact_call_ex purge;
alter table ${iol_schema}.bdws_b_t_cm_contact_call add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.bdws_b_t_cm_contact_call truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.bdws_b_t_cm_contact_call_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdws_b_t_cm_contact_call where 0=1;

insert /*+ append */ into ${iol_schema}.bdws_b_t_cm_contact_call_ex(
    etl_dt_ora -- 数据日期
    ,contact_call_id -- 主键
    ,cust_id -- 客户编号
    ,call_id -- 外呼会话编号
    ,cust_phone -- 客户电话号码
    ,call_time -- 电话时长
    ,create_time -- 创建时间
    ,contact_id -- 客户联络主键
    ,caller_id_name -- 来电者名字
    ,caller_id_number -- 来电号码
    ,destination_number -- 被叫号码
    ,hang_up_cause -- 电话挂断原因  NORMAL_CLEARING-正常挂断  其他：未正常建立通话
    ,agent_phone -- 座席电话
    ,agent_id -- 座席工号
    ,record_url -- 录音地址
    ,hang_up_cause_cd -- 会话接通/断开标志
    ,load_date -- 数据日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    etl_dt_ora -- 数据日期
    ,contact_call_id -- 主键
    ,cust_id -- 客户编号
    ,call_id -- 外呼会话编号
    ,cust_phone -- 客户电话号码
    ,call_time -- 电话时长
    ,create_time -- 创建时间
    ,contact_id -- 客户联络主键
    ,caller_id_name -- 来电者名字
    ,caller_id_number -- 来电号码
    ,destination_number -- 被叫号码
    ,hang_up_cause -- 电话挂断原因  NORMAL_CLEARING-正常挂断  其他：未正常建立通话
    ,agent_phone -- 座席电话
    ,agent_id -- 座席工号
    ,record_url -- 录音地址
    ,hang_up_cause_cd -- 会话接通/断开标志
    ,load_date -- 数据日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdws_b_t_cm_contact_call
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdws_b_t_cm_contact_call exchange partition p_${batch_date} with table ${iol_schema}.bdws_b_t_cm_contact_call_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdws_b_t_cm_contact_call to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdws_b_t_cm_contact_call_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdws_b_t_cm_contact_call',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);