/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_orws_yygj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_orws_yygj
whenever sqlerror continue none;
drop table ${itl_schema}.itl_orws_yygj purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_orws_yygj(
    etl_dt date -- 
    ,id number(18) -- 
    ,organnum varchar2(10) -- 
    ,risk_level number(1) -- 
    ,num number(5) -- 
    ,task_date date -- 
    ,craete_date timestamp(6) --
    ,type_name  varchar2(255)--
    ,problemer_no varchar2(50)--
    ,problemer_name varchar2(150)--
    ,etl_timestamp timestamp -- 
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_orws_yygj to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_orws_yygj is '营运管架系统数据表';
comment on column ${itl_schema}.itl_orws_yygj.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_orws_yygj.id is '主键';
comment on column ${itl_schema}.itl_orws_yygj.organnum is '机构号';
comment on column ${itl_schema}.itl_orws_yygj.risk_level is '风险等级';
comment on column ${itl_schema}.itl_orws_yygj.num is '数量';
comment on column ${itl_schema}.itl_orws_yygj.task_date is '业务日期';
comment on column ${itl_schema}.itl_orws_yygj.craete_date is '创建日期';
comment on column ${itl_schema}.itl_orws_yygj.type_name is '种类名称';
comment on column ${itl_schema}.itl_orws_yygj.problemer_no is '问题责任人柜员号';
comment on column ${itl_schema}.itl_orws_yygj.problemer_name is '问题责任人名称';
comment on column ${itl_schema}.itl_orws_yygj.etl_timestamp is '时间戳';