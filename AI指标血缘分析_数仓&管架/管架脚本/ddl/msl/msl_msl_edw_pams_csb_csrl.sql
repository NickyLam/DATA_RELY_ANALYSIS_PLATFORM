/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_csb_csrl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_csb_csrl
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_csb_csrl purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_csb_csrl(
    etl_dt date
    ,tjrq number(22)
    ,xqj varchar2(6)
    ,sfcs varchar2(6)
    ,csts number(22)
    ,csqsrq number(22)
    ,csjsrq number(22)
    ,rqlx varchar2(6)
    ,dqcsrq number(22)
    ,cszt varchar2(6)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_csb_csrl to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_csb_csrl is '重算日历表';
comment on column ${msl_schema}.msl_edw_pams_csb_csrl.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pams_csb_csrl.tjrq is '统计日期';
comment on column ${msl_schema}.msl_edw_pams_csb_csrl.xqj is '星期几';
comment on column ${msl_schema}.msl_edw_pams_csb_csrl.sfcs is '是否重算';
comment on column ${msl_schema}.msl_edw_pams_csb_csrl.csts is '重算天数';
comment on column ${msl_schema}.msl_edw_pams_csb_csrl.csqsrq is '重算起始日期';
comment on column ${msl_schema}.msl_edw_pams_csb_csrl.csjsrq is '重算结束日期';
comment on column ${msl_schema}.msl_edw_pams_csb_csrl.rqlx is '日期类型（2:节假日 1:周末 0:工作日）';
comment on column ${msl_schema}.msl_edw_pams_csb_csrl.dqcsrq is '当前重算日期';
comment on column ${msl_schema}.msl_edw_pams_csb_csrl.cszt is '重算状态（1:可执行 0:已完成）';
