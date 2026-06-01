/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scrm_user_behavior_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scrm_user_behavior_data
whenever sqlerror continue none;
drop table ${iol_schema}.scrm_user_behavior_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scrm_user_behavior_data(
    id varchar2(32) -- 主键ID
    ,qw_user_id varchar2(32) -- 企微编号
    ,user_no varchar2(32) -- 员工号
    ,user_name varchar2(32) -- 员工姓名
    ,dept_id varchar2(32) -- 员工行内机构号
    ,behavior_date varchar2(19) -- 统计日期
    ,new_apply_cnt number(22) -- 发起申请数
    ,new_contact_cnt number(22) -- 新增客户数
    ,chat_cnt number(22) -- 聊天总数
    ,message_cnt number(22) -- 发送消息占比
    ,reply_percentage number(38,6) -- 已回复聊天占比
    ,avg_reply_time number(22) -- 平均首次回复时长
    ,negative_feedback_cnt number(22) -- 删除/拉黑成员的客户数
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
grant select on ${iol_schema}.scrm_user_behavior_data to ${iml_schema};
grant select on ${iol_schema}.scrm_user_behavior_data to ${icl_schema};
grant select on ${iol_schema}.scrm_user_behavior_data to ${idl_schema};
grant select on ${iol_schema}.scrm_user_behavior_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.scrm_user_behavior_data is '联系客户统计';
comment on column ${iol_schema}.scrm_user_behavior_data.id is '主键ID';
comment on column ${iol_schema}.scrm_user_behavior_data.qw_user_id is '企微编号';
comment on column ${iol_schema}.scrm_user_behavior_data.user_no is '员工号';
comment on column ${iol_schema}.scrm_user_behavior_data.user_name is '员工姓名';
comment on column ${iol_schema}.scrm_user_behavior_data.dept_id is '员工行内机构号';
comment on column ${iol_schema}.scrm_user_behavior_data.behavior_date is '统计日期';
comment on column ${iol_schema}.scrm_user_behavior_data.new_apply_cnt is '发起申请数';
comment on column ${iol_schema}.scrm_user_behavior_data.new_contact_cnt is '新增客户数';
comment on column ${iol_schema}.scrm_user_behavior_data.chat_cnt is '聊天总数';
comment on column ${iol_schema}.scrm_user_behavior_data.message_cnt is '发送消息占比';
comment on column ${iol_schema}.scrm_user_behavior_data.reply_percentage is '已回复聊天占比';
comment on column ${iol_schema}.scrm_user_behavior_data.avg_reply_time is '平均首次回复时长';
comment on column ${iol_schema}.scrm_user_behavior_data.negative_feedback_cnt is '删除/拉黑成员的客户数';
comment on column ${iol_schema}.scrm_user_behavior_data.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.scrm_user_behavior_data.etl_timestamp is 'ETL处理时间戳';
