/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_khfa_level_manage
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_khfa_level_manage
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_khfa_level_manage purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_khfa_level_manage(
    etl_dt date
    ,khnf number(22)
    ,fabh number(22)
    ,jg varchar2(300)
    ,lx varchar2(6)
    ,khzbbh number(22)
    ,khpl varchar2(6)
    ,dfly varchar2(300)
    ,xh number(22)
    ,czr number(22)
    ,czsj date
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_khfa_level_manage to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_khfa_level_manage is '考核方案层级管理';
comment on column ${msl_schema}.msl_edw_pams_khfa_level_manage.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pams_khfa_level_manage.khnf is '考核年份';
comment on column ${msl_schema}.msl_edw_pams_khfa_level_manage.fabh is '方案编号';
comment on column ${msl_schema}.msl_edw_pams_khfa_level_manage.jg is '结构';
comment on column ${msl_schema}.msl_edw_pams_khfa_level_manage.lx is '类型';
comment on column ${msl_schema}.msl_edw_pams_khfa_level_manage.khzbbh is '考核指标编号';
comment on column ${msl_schema}.msl_edw_pams_khfa_level_manage.khpl is '考核频率';
comment on column ${msl_schema}.msl_edw_pams_khfa_level_manage.dfly is '得分来源';
comment on column ${msl_schema}.msl_edw_pams_khfa_level_manage.xh is '序号';
comment on column ${msl_schema}.msl_edw_pams_khfa_level_manage.czr is '操作人';
comment on column ${msl_schema}.msl_edw_pams_khfa_level_manage.czsj is '操作时间';
