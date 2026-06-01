/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_orws_yygj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_orws_yygj
whenever sqlerror continue none;
drop table ${msl_schema}.msl_orws_yygj purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_orws_yygj(
    id number(18) -- 
    ,organnum varchar2(10) -- 
    ,risk_level number(1) -- 
    ,num number(5) -- 
    ,task_date date -- 
    ,craete_date timestamp(6) --
    ,type_name  varchar2(255)--
    ,problemer_no varchar2(50)--
    ,problemer_name varchar2(150)--
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_orws_yygj to ${itl_schema};