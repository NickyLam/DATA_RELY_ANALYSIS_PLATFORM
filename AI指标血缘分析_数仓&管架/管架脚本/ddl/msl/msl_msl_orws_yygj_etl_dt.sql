/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_orws_yygj_etl_dt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_orws_yygj_etl_dt
whenever sqlerror continue none;
drop table ${msl_schema}.msl_orws_yygj_etl_dt purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_orws_yygj_etl_dt(
    etl_dt date -- 
    ,etl_timestamp timestamp --
    ,num number(5)
    ,import_way number(1)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_orws_yygj_etl_dt to ${itl_schema};