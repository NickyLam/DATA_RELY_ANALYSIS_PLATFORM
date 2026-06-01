/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scrm_chat_msg_record
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
drop table ${iol_schema}.scrm_chat_msg_record_ex purge;
alter table ${iol_schema}.scrm_chat_msg_record add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.scrm_chat_msg_record truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.scrm_chat_msg_record_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scrm_chat_msg_record where 0=1;

insert /*+ append */ into ${iol_schema}.scrm_chat_msg_record_ex(
    pk_id -- 主键
    ,corp_id -- 企微ID
    ,from_id -- 发送人ID。行内企微USER_ID或外部联系人ID
    ,from_type -- 发送人类型。0 客户经理,1 客户;2 机器人
    ,to_id -- 接收人ID。行内企微USER_ID或外部联系人ID
    ,to_type -- 接收人类型。0 客户经理,1 客户;2 机器人
    ,msg_date -- 消息发送日期。yyyy-MM-dd
    ,msg_day -- 消息发送自然日：用于分区键
    ,msg_time -- 消息发送时间。HH:mm:ss
    ,msg_unix_time -- 消息发送时间。时间戳
    ,msg_type -- 消息类型。
    ,msg_cnt -- 聊天数。发送消息为1，撤回消息为0
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    pk_id -- 主键
    ,corp_id -- 企微ID
    ,from_id -- 发送人ID。行内企微USER_ID或外部联系人ID
    ,from_type -- 发送人类型。0 客户经理,1 客户;2 机器人
    ,to_id -- 接收人ID。行内企微USER_ID或外部联系人ID
    ,to_type -- 接收人类型。0 客户经理,1 客户;2 机器人
    ,msg_date -- 消息发送日期。yyyy-MM-dd
    ,msg_day -- 消息发送自然日：用于分区键
    ,msg_time -- 消息发送时间。HH:mm:ss
    ,msg_unix_time -- 消息发送时间。时间戳
    ,msg_type -- 消息类型。
    ,msg_cnt -- 聊天数。发送消息为1，撤回消息为0
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.scrm_chat_msg_record
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.scrm_chat_msg_record exchange partition p_${batch_date} with table ${iol_schema}.scrm_chat_msg_record_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scrm_chat_msg_record to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.scrm_chat_msg_record_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scrm_chat_msg_record',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);