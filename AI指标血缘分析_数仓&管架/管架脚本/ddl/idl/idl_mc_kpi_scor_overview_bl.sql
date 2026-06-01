/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_kpi_scor_overview_bl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_kpi_scor_overview_bl
whenever sqlerror continue none;
drop table ${idl_schema}.mc_kpi_scor_overview_bl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_kpi_scor_overview_bl(
    seq_num number -- 展示顺序
    ,asses_year varchar2(200) -- 考核年份
    ,org_type varchar2(200) -- 机构类型
    ,sup_org_no varchar2(200) -- 上级机构编号
    ,org_no varchar2(200) -- 机构编号
    ,org_name varchar2(200) -- 机构名称
    ,index_name varchar2(200) -- 指标名称
    ,ind_scor number(38,8) -- 指标得分
    ,std_scor number(38,8) -- 标准得分
    ,scor_uplmi number(38,8) -- 得分上限
    ,scor_lolmi number(38,8) -- 得分下限
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)

storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mc_kpi_scor_overview_bl to ${iel_schema};

-- comment
comment on table ${idl_schema}.mc_kpi_scor_overview_bl is 'KPI得分概览_补录';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl.seq_num is '展示顺序';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl.asses_year is '考核年份';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl.org_type is '机构类型';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl.sup_org_no is '上级机构编号';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl.org_no is '机构编号';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl.org_name is '机构名称';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl.index_name is '指标名称';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl.ind_scor is '指标得分';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl.std_scor is '标准得分';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl.scor_uplmi is '得分上限';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl.scor_lolmi is '得分下限';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_kpi_scor_overview_bl.etl_timestamp is 'ETL处理时间戳';