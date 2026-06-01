/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rpas_rpa_billrate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rpas_rpa_billrate
whenever sqlerror continue none;
drop table ${iol_schema}.rpas_rpa_billrate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rpas_rpa_billrate(
    brnm varchar2(250) -- 曲线名称
    ,trdt varchar2(10) -- 成交日期
    ,keynm varchar2(50) -- 关键期限点名称
    ,keyday varchar2(10) -- 关键期限点天数
    ,rate varchar2(10) -- 利率
    ,yield varchar2(10) -- 收益率
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
grant select on ${iol_schema}.rpas_rpa_billrate to ${iml_schema};
grant select on ${iol_schema}.rpas_rpa_billrate to ${icl_schema};
grant select on ${iol_schema}.rpas_rpa_billrate to ${idl_schema};
grant select on ${iol_schema}.rpas_rpa_billrate to ${iel_schema};

-- comment
comment on table ${iol_schema}.rpas_rpa_billrate is '银票转贴现利率曲线';
comment on column ${iol_schema}.rpas_rpa_billrate.brnm is '曲线名称';
comment on column ${iol_schema}.rpas_rpa_billrate.trdt is '成交日期';
comment on column ${iol_schema}.rpas_rpa_billrate.keynm is '关键期限点名称';
comment on column ${iol_schema}.rpas_rpa_billrate.keyday is '关键期限点天数';
comment on column ${iol_schema}.rpas_rpa_billrate.rate is '利率';
comment on column ${iol_schema}.rpas_rpa_billrate.yield is '收益率';
comment on column ${iol_schema}.rpas_rpa_billrate.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rpas_rpa_billrate.etl_timestamp is 'ETL处理时间戳';
