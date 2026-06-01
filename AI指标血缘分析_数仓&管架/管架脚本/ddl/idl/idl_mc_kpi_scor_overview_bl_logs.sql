/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_kpi_scor_overview_bl_logs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_kpi_scor_overview_bl_logs
whenever sqlerror continue none;
drop table ${idl_schema}.mc_kpi_scor_overview_bl_logs purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_kpi_scor_overview_bl_logs(
    seq_num number -- 展示顺序
    ,org_type varchar2(200) -- 机构类型
    ,org_no varchar2(200) -- 机构编号
    ,org_name varchar2(200) -- 机构名称
    ,index_name varchar2(200) -- 指标名称
    ,ind_scor number(38,8) -- 指标得分
    ,std_scor number(38,8) -- 标准得分
    ,scor_uplmi number(38,8) -- 得分上限
    ,scor_lolmi number(38,8) -- 得分下限
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
grant select on ${idl_schema}.mc_kpi_scor_overview_bl_logs to ${iel_schema};

-- comment
comment on table ${idl_schema}.mc_kpi_scor_overview_bl_logs is 'KPI得分概览_补录日志';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl_logs.seq_num is '展示顺序';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl_logs.org_type is '机构类型';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl_logs.org_no is '机构编号';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl_logs.org_name is '机构名称';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl_logs.index_name is '指标名称';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl_logs.ind_scor is '指标得分';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl_logs.std_scor is '标准得分';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl_logs.scor_uplmi is '得分上限';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl_logs.scor_lolmi is '得分下限';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl_logs.user_id is '用户ID';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl_logs.user_name is '用户名称';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl_logs.nick_name is '用户昵称';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl_logs.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl_logs.etl_timestamp is 'ETL处理时间戳';