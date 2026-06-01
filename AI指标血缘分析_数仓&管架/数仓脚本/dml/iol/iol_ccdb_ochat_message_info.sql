/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ccdb_ochat_message_info
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
drop table ${iol_schema}.ccdb_ochat_message_info_ex purge;
alter table ${iol_schema}.ccdb_ochat_message_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ccdb_ochat_message_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ccdb_ochat_message_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ccdb_ochat_message_info where 0=1;

insert /*+ append */ into ${iol_schema}.ccdb_ochat_message_info_ex(
    room_no -- 房间编号
    ,msg_content_code -- 消息内容编号
    ,from_member_no -- 消息发送者
    ,to_member_no -- 消息接受者
    ,time -- 消息时间
    ,sender_name -- 发送者名称
    ,sender_code -- 发送者坐席用户号
    ,sender_type -- 发送者类型（0.系统 1.客户 2.坐席 3.机器人）
    ,reply_interval -- 坐席回复时间间隔（单位：秒）
    ,buss_code -- 业务线编码
    ,skill_group_code -- 技能组编码
    ,chat_sign -- 对话标识（0.人-机 1.人-人 2.系统-人 3.留言）
    ,chat_seq -- 对话序列
    ,msg_type -- 消息类型（1.文本 2.普通文本 3.图片 4.满意度 5.历史记录）
    ,reply_sign -- 回复标识（0.未分配 1.已回复 2.未回复）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    room_no -- 房间编号
    ,msg_content_code -- 消息内容编号
    ,from_member_no -- 消息发送者
    ,to_member_no -- 消息接受者
    ,time -- 消息时间
    ,sender_name -- 发送者名称
    ,sender_code -- 发送者坐席用户号
    ,sender_type -- 发送者类型（0.系统 1.客户 2.坐席 3.机器人）
    ,reply_interval -- 坐席回复时间间隔（单位：秒）
    ,buss_code -- 业务线编码
    ,skill_group_code -- 技能组编码
    ,chat_sign -- 对话标识（0.人-机 1.人-人 2.系统-人 3.留言）
    ,chat_seq -- 对话序列
    ,msg_type -- 消息类型（1.文本 2.普通文本 3.图片 4.满意度 5.历史记录）
    ,reply_sign -- 回复标识（0.未分配 1.已回复 2.未回复）
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ccdb_ochat_message_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ccdb_ochat_message_info exchange partition p_${batch_date} with table ${iol_schema}.ccdb_ochat_message_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ccdb_ochat_message_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ccdb_ochat_message_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ccdb_ochat_message_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);