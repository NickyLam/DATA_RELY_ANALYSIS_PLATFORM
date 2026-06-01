/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_ind_cmplt_situ_bl_now
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_ind_cmplt_situ_bl_now
whenever sqlerror continue none;
drop table ${idl_schema}.mc_ind_cmplt_situ_bl_now purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_ind_cmplt_situ_bl_now(
    index_no varchar2(200) -- 指标编号
    ,index_name varchar2(200) -- 指标名称
    ,org_no varchar2(200) -- 机构编号
    ,index_value number(38,8) -- 指标值
    ,budget_val varchar2(200) -- 年度目标值
    ,prog_target_val number(38,8) -- 时间进度值
    ,ind_net_incre number(38,8) -- 指标净增值
    ,last_year_base number(38,8) -- 上年基数
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)

storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mc_ind_cmplt_situ_bl_now to ${iel_schema};

-- comment
comment on table ${idl_schema}.mc_ind_cmplt_situ_bl_now is '指标完成情况_补录待提交';
comment on column ${idl_schema}.mc_ind_cmplt_situ_bl_now.index_no is '指标编号';
comment on column ${idl_schema}.mc_ind_cmplt_situ_bl_now.index_name is '指标名称';
comment on column ${idl_schema}.mc_ind_cmplt_situ_bl_now.org_no is '机构编号';
comment on column ${idl_schema}.mc_ind_cmplt_situ_bl_now.index_value is '指标值';
comment on column ${idl_schema}.mc_ind_cmplt_situ_bl_now.budget_val is '年度目标值';
comment on column ${idl_schema}.mc_ind_cmplt_situ_bl_now.prog_target_val is '时间进度值';
comment on column ${idl_schema}.mc_ind_cmplt_situ_bl_now.ind_net_incre is '指标净增值';
comment on column ${idl_schema}.mc_ind_cmplt_situ_bl_now.last_year_base is '上年基数';
comment on column ${idl_schema}.mc_ind_cmplt_situ_bl_now.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_ind_cmplt_situ_bl_now.etl_timestamp is 'ETL处理时间戳';