/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scrm_chat_msg_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scrm_chat_msg_record
whenever sqlerror continue none;
drop table ${iol_schema}.scrm_chat_msg_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scrm_chat_msg_record(
    pk_id varchar2(32) -- 主键
    ,corp_id varchar2(32) -- 企微ID
    ,from_id varchar2(64) -- 发送人ID。行内企微USER_ID或外部联系人ID
    ,from_type number(22) -- 发送人类型。0 客户经理,1 客户;2 机器人
    ,to_id varchar2(64) -- 接收人ID。行内企微USER_ID或外部联系人ID
    ,to_type number(22) -- 接收人类型。0 客户经理,1 客户;2 机器人
    ,msg_date varchar2(10) -- 消息发送日期。yyyy-MM-dd
    ,msg_day varchar2(2) -- 消息发送自然日：用于分区键
    ,msg_time varchar2(8) -- 消息发送时间。HH:mm:ss
    ,msg_unix_time number(22) -- 消息发送时间。时间戳
    ,msg_type varchar2(20) -- 消息类型。
    ,msg_cnt number(22) -- 聊天数。发送消息为1，撤回消息为0
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.scrm_chat_msg_record to ${iml_schema};
grant select on ${iol_schema}.scrm_chat_msg_record to ${icl_schema};
grant select on ${iol_schema}.scrm_chat_msg_record to ${idl_schema};
grant select on ${iol_schema}.scrm_chat_msg_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.scrm_chat_msg_record is '当日聊天记录表';
comment on column ${iol_schema}.scrm_chat_msg_record.pk_id is '主键';
comment on column ${iol_schema}.scrm_chat_msg_record.corp_id is '企微ID';
comment on column ${iol_schema}.scrm_chat_msg_record.from_id is '发送人ID。行内企微USER_ID或外部联系人ID';
comment on column ${iol_schema}.scrm_chat_msg_record.from_type is '发送人类型。0 客户经理,1 客户;2 机器人';
comment on column ${iol_schema}.scrm_chat_msg_record.to_id is '接收人ID。行内企微USER_ID或外部联系人ID';
comment on column ${iol_schema}.scrm_chat_msg_record.to_type is '接收人类型。0 客户经理,1 客户;2 机器人';
comment on column ${iol_schema}.scrm_chat_msg_record.msg_date is '消息发送日期。yyyy-MM-dd';
comment on column ${iol_schema}.scrm_chat_msg_record.msg_day is '消息发送自然日：用于分区键';
comment on column ${iol_schema}.scrm_chat_msg_record.msg_time is '消息发送时间。HH:mm:ss';
comment on column ${iol_schema}.scrm_chat_msg_record.msg_unix_time is '消息发送时间。时间戳';
comment on column ${iol_schema}.scrm_chat_msg_record.msg_type is '消息类型。';
comment on column ${iol_schema}.scrm_chat_msg_record.msg_cnt is '聊天数。发送消息为1，撤回消息为0';
comment on column ${iol_schema}.scrm_chat_msg_record.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.scrm_chat_msg_record.etl_timestamp is 'ETL处理时间戳';
