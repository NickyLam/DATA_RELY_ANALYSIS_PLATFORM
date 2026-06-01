/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_csb_csddjl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_csb_csddjl
whenever sqlerror continue none;
drop table ${iol_schema}.pams_csb_csddjl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_csb_csddjl(
    tjrq number(22,0) -- 统计日期
    ,csqsrq number(22,0) -- 重算起始日期
    ,csjsrq number(22,0) -- 重算结束日期
    ,csts number(22,0) -- 重算天数
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pams_csb_csddjl to ${iml_schema};
grant select on ${iol_schema}.pams_csb_csddjl to ${icl_schema};
grant select on ${iol_schema}.pams_csb_csddjl to ${idl_schema};
grant select on ${iol_schema}.pams_csb_csddjl to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_csb_csddjl is '参数表_重算调度记录';
comment on column ${iol_schema}.pams_csb_csddjl.tjrq is '统计日期';
comment on column ${iol_schema}.pams_csb_csddjl.csqsrq is '重算起始日期';
comment on column ${iol_schema}.pams_csb_csddjl.csjsrq is '重算结束日期';
comment on column ${iol_schema}.pams_csb_csddjl.csts is '重算天数';
comment on column ${iol_schema}.pams_csb_csddjl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_csb_csddjl.etl_timestamp is 'ETL处理时间戳';
