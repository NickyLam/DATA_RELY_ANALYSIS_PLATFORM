/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ccdb_ochat_message_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ccdb_ochat_message_info
whenever sqlerror continue none;
drop table ${iol_schema}.ccdb_ochat_message_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_ochat_message_info(
    room_no varchar2(100) -- 房间编号
    ,msg_content_code varchar2(50) -- 消息内容编号
    ,from_member_no varchar2(50) -- 消息发送者
    ,to_member_no varchar2(50) -- 消息接受者
    ,time date -- 消息时间
    ,sender_name varchar2(50) -- 发送者名称
    ,sender_code varchar2(50) -- 发送者坐席用户号
    ,sender_type varchar2(4) -- 发送者类型（0.系统 1.客户 2.坐席 3.机器人）
    ,reply_interval number(22) -- 坐席回复时间间隔（单位：秒）
    ,buss_code varchar2(10) -- 业务线编码
    ,skill_group_code varchar2(30) -- 技能组编码
    ,chat_sign varchar2(5) -- 对话标识（0.人-机 1.人-人 2.系统-人 3.留言）
    ,chat_seq number(22) -- 对话序列
    ,msg_type varchar2(4) -- 消息类型（1.文本 2.普通文本 3.图片 4.满意度 5.历史记录）
    ,reply_sign varchar2(4) -- 回复标识（0.未分配 1.已回复 2.未回复）
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
grant select on ${iol_schema}.ccdb_ochat_message_info to ${iml_schema};
grant select on ${iol_schema}.ccdb_ochat_message_info to ${icl_schema};
grant select on ${iol_schema}.ccdb_ochat_message_info to ${idl_schema};
grant select on ${iol_schema}.ccdb_ochat_message_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ccdb_ochat_message_info is '在线客服消息体主表';
comment on column ${iol_schema}.ccdb_ochat_message_info.room_no is '房间编号';
comment on column ${iol_schema}.ccdb_ochat_message_info.msg_content_code is '消息内容编号';
comment on column ${iol_schema}.ccdb_ochat_message_info.from_member_no is '消息发送者';
comment on column ${iol_schema}.ccdb_ochat_message_info.to_member_no is '消息接受者';
comment on column ${iol_schema}.ccdb_ochat_message_info.time is '消息时间';
comment on column ${iol_schema}.ccdb_ochat_message_info.sender_name is '发送者名称';
comment on column ${iol_schema}.ccdb_ochat_message_info.sender_code is '发送者坐席用户号';
comment on column ${iol_schema}.ccdb_ochat_message_info.sender_type is '发送者类型（0.系统 1.客户 2.坐席 3.机器人）';
comment on column ${iol_schema}.ccdb_ochat_message_info.reply_interval is '坐席回复时间间隔（单位：秒）';
comment on column ${iol_schema}.ccdb_ochat_message_info.buss_code is '业务线编码';
comment on column ${iol_schema}.ccdb_ochat_message_info.skill_group_code is '技能组编码';
comment on column ${iol_schema}.ccdb_ochat_message_info.chat_sign is '对话标识（0.人-机 1.人-人 2.系统-人 3.留言）';
comment on column ${iol_schema}.ccdb_ochat_message_info.chat_seq is '对话序列';
comment on column ${iol_schema}.ccdb_ochat_message_info.msg_type is '消息类型（1.文本 2.普通文本 3.图片 4.满意度 5.历史记录）';
comment on column ${iol_schema}.ccdb_ochat_message_info.reply_sign is '回复标识（0.未分配 1.已回复 2.未回复）';
comment on column ${iol_schema}.ccdb_ochat_message_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ccdb_ochat_message_info.etl_timestamp is 'ETL处理时间戳';
