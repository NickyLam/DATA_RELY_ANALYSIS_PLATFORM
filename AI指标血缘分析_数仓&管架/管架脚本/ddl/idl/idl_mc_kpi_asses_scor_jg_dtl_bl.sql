/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_kpi_asses_scor_jg_dtl_bl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl
whenever sqlerror continue none;
drop table ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl(
    stat_dt varchar2(200) -- 统计日期
    ,org_no varchar2(200) -- 机构编号
    ,org_name varchar2(200) -- 机构名称
    ,prop_name varchar2(200) -- 指标分类
    ,index_name varchar2(200) -- 指标名称
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
    ,std_scor number(38,8) -- 目标得分
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)

storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl to ${iel_schema};

-- comment
comment on table ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl is 'KPI考核得分明细_补录';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.stat_dt is '统计日期';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.org_no is '机构编号';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.org_name is '机构名称';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.prop_name is '指标分类';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.index_name is '指标名称';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.scor_uplmi is '最高分';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.scor_lolmi is '最低分';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.budget_val is '年度目标值';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.prog_target_val is '时间进度值';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.last_year_base is '上年基数';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.index_val is '指标值';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.net_incre is '净增值';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.asses_scor is '考核得分';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.year_cmplt_rat is '年度完成率';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.tm_prog_cmplt_rat is '时间进度完成率';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.index_no is '指标编号';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.std_scor is '目标得分';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl_bl.etl_timestamp is 'ETL处理时间戳';