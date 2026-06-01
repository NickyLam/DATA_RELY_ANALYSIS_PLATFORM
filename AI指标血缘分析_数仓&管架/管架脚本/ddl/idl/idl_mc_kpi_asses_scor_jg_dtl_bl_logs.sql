/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_kpi_asses_scor_jg_dtl_bl_logs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs
whenever sqlerror continue none;
drop table ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs(
    stat_dt varchar2(200) -- 统计日期
    ,org_no varchar2(200) -- 机构编号
    ,org_name varchar2(200) -- 机构名称
    ,prop_name varchar2(200) -- 指标分类
    ,index_name varchar2(200) -- 指标名称
    ,std_scor number(38,8) -- 目标分
    ,scor_uplmi number(38,8) -- 最高分
    ,scor_lolmi number(38,8) -- 最低分
    ,budget_val number(38,8) -- 年度目标值
    ,prog_target_val number(38,8) -- 时间进度值
    ,last_year_base number(38,8) -- 上年基数
    ,index_val number(38,8) -- 指标值
    ,net_incre number(38,8) -- 净增值
    ,asses_scor number(38,8) -- 考核得分
    ,year_cmplt_rat number(38,8) -- 年度完成率
    ,tm_prog_cmplt_rat number(38,8) -- 时间进度完成率
    ,index_no varchar2(200) -- 指标编号
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
grant select on ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs to ${iel_schema};

-- comment
comment on table ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs is 'KPI考核得分明细_补录日志';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.stat_dt is '统计日期';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.org_no is '机构编号';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.org_name is '机构名称';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.prop_name is '指标分类';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.index_name is '指标名称';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.std_scor is '目标分';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.scor_uplmi is '最高分';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.scor_lolmi is '最低分';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.budget_val is '年度目标值';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.prog_target_val is '时间进度值';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.last_year_base is '上年基数';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.index_val is '指标值';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.net_incre is '净增值';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.asses_scor is '考核得分';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.year_cmplt_rat is '年度完成率';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.tm_prog_cmplt_rat is '时间进度完成率';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.index_no is '指标编号';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.user_id is '用户ID';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.user_name is '用户名称';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.nick_name is '用户昵称';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl_logs.etl_timestamp is 'ETL处理时间戳';