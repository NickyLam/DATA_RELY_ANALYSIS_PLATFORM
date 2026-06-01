/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol less_le_pa_capital_project
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.less_le_pa_capital_project
whenever sqlerror continue none;
drop table ${iol_schema}.less_le_pa_capital_project purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.less_le_pa_capital_project(
    prjid varchar2(60) -- 资本项目编号
    ,prjname varchar2(100) -- 资本项目名称
    ,prjbal number(38,6) -- 资本项目余额
    ,prjorgname varchar2(60) -- 是否并表
    ,updateuserid varchar2(60) -- 更新人编号
    ,updateusername varchar2(100) -- 更新人名称
    ,updateorgid varchar2(60) -- 更新机构编号
    ,updateorgname varchar2(100) -- 更新机构名称
    ,updatetime varchar2(20) -- 更新时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.less_le_pa_capital_project to ${iml_schema};
grant select on ${iol_schema}.less_le_pa_capital_project to ${icl_schema};
grant select on ${iol_schema}.less_le_pa_capital_project to ${idl_schema};
grant select on ${iol_schema}.less_le_pa_capital_project to ${iel_schema};

-- comment
comment on table ${iol_schema}.less_le_pa_capital_project is '资本项目表';
comment on column ${iol_schema}.less_le_pa_capital_project.prjid is '资本项目编号';
comment on column ${iol_schema}.less_le_pa_capital_project.prjname is '资本项目名称';
comment on column ${iol_schema}.less_le_pa_capital_project.prjbal is '资本项目余额';
comment on column ${iol_schema}.less_le_pa_capital_project.prjorgname is '是否并表';
comment on column ${iol_schema}.less_le_pa_capital_project.updateuserid is '更新人编号';
comment on column ${iol_schema}.less_le_pa_capital_project.updateusername is '更新人名称';
comment on column ${iol_schema}.less_le_pa_capital_project.updateorgid is '更新机构编号';
comment on column ${iol_schema}.less_le_pa_capital_project.updateorgname is '更新机构名称';
comment on column ${iol_schema}.less_le_pa_capital_project.updatetime is '更新时间';
comment on column ${iol_schema}.less_le_pa_capital_project.start_dt is '开始时间';
comment on column ${iol_schema}.less_le_pa_capital_project.end_dt is '结束时间';
comment on column ${iol_schema}.less_le_pa_capital_project.id_mark is '增删标志';
comment on column ${iol_schema}.less_le_pa_capital_project.etl_timestamp is 'ETL处理时间戳';
