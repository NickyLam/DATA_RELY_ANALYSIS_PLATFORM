/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_assex_index_label_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_assex_index_label_info
whenever sqlerror continue none;
drop table ${idl_schema}.mc_assex_index_label_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_assex_index_label_info(
    index_no varchar2(150) -- 指标编号
    ,index_name varchar2(150) -- 指标名称
    ,label_key varchar2(150) -- 标签键
    ,label_key_desc varchar2(150) -- 标签键描述
    ,update_dt date -- 更新日期
    ,update_per varchar2(150) -- 更新人
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)

storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mc_assex_index_label_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.mc_assex_index_label_info is '考核模块指标标签信息表';
comment on column ${idl_schema}.mc_assex_index_label_info.index_no is '指标编号';
comment on column ${idl_schema}.mc_assex_index_label_info.index_name is '指标名称';
comment on column ${idl_schema}.mc_assex_index_label_info.label_key is '标签键';
comment on column ${idl_schema}.mc_assex_index_label_info.label_key_desc is '标签键描述';
comment on column ${idl_schema}.mc_assex_index_label_info.update_dt is '更新日期';
comment on column ${idl_schema}.mc_assex_index_label_info.update_per is '更新人';
comment on column ${idl_schema}.mc_assex_index_label_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_assex_index_label_info.etl_timestamp is 'ETL处理时间戳';