/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_cass_r_rpt_rst0018
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_cass_r_rpt_rst0018
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_cass_r_rpt_rst0018 purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_cass_r_rpt_rst0018(
    etl_dt date
    ,etl_dt_ora date
    ,index_name varchar2(60)
    ,curr_cd varchar2(45)
    ,curr_name varchar2(60)
    ,manager_org varchar2(60)
    ,manager_org_name varchar2(300)
    ,kpi_value_mm number(38,8)
    ,kpi_value_mom number(38,8)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_cass_r_rpt_rst0018 to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_cass_r_rpt_rst0018 is '管驾指标表';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0018.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0018.etl_dt_ora is '数据日期';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0018.index_name is '指标名称';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0018.curr_cd is '币种';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0018.curr_name is '币种名称';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0018.manager_org is '考核机构';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0018.manager_org_name is '考核机构名称';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0018.kpi_value_mm is '当月值_分子';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0018.kpi_value_mom is '当月值_分母';
