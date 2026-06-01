/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_assex_trd_strtg_index_situ_bl_logs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs
whenever sqlerror continue none;
drop table ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs(
    index_no varchar2(200) -- 指标编号
    ,index_name varchar2(200) -- 指标名称
    ,org_no varchar2(200) -- 机构编号
    ,label_key varchar2(200) -- 标签键
    ,label_key_desc varchar2(200) -- 标签描述
    ,label_value varchar2(4000) -- 标签数值
    ,unit varchar2(200) -- 数值单位
    ,seq_num number -- 展示顺序
    ,user_id varchar2(200) -- 用户ID
    ,user_name varchar2(200) -- 用户名称
    ,nick_name varchar2(200) -- 用户昵称
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)

storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs to ${iel_schema};

-- comment
comment on table ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs is '考核模块三化指标情况_补录日志';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs.index_no is '指标编号';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs.index_name is '指标名称';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs.org_no is '机构编号';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs.label_key is '标签键';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs.label_key_desc is '标签描述';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs.label_value is '标签数值';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs.unit is '数值单位';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs.seq_num is '展示顺序';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs.user_id is '用户ID';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs.user_name is '用户名称';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs.nick_name is '用户昵称';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ_bl_logs.etl_timestamp is 'ETL处理时间戳';