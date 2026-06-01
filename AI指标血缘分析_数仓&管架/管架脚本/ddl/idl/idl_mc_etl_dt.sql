/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_etl_dt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_etl_dt
whenever sqlerror continue none;
drop table ${idl_schema}.mc_etl_dt purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_etl_dt(
     etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- comment
comment on table ${idl_schema}.mc_etl_dt is '管驾跑批时间监控表';
comment on column ${idl_schema}.mc_etl_dt.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_etl_dt.etl_timestamp is 'ETL处理时间戳';