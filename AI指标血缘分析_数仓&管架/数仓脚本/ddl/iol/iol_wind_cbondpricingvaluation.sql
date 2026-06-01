/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondpricingvaluation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondpricingvaluation
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondpricingvaluation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondpricingvaluation(
    object_id varchar2(57) -- 对象ID
    ,trade_dt varchar2(12) -- 日期
    ,val_agency varchar2(60) -- 估值机构
    ,val_agency_id varchar2(15) -- 估值机构id
    ,credit_code number(9,0) -- 信用评级代码
    ,term number(20,4) -- 期限
    ,valuation number(20,4) -- 定价估值
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
grant select on ${iol_schema}.wind_cbondpricingvaluation to ${iml_schema};
grant select on ${iol_schema}.wind_cbondpricingvaluation to ${icl_schema};
grant select on ${iol_schema}.wind_cbondpricingvaluation to ${idl_schema};
grant select on ${iol_schema}.wind_cbondpricingvaluation to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondpricingvaluation is '债券定价估值';
comment on column ${iol_schema}.wind_cbondpricingvaluation.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondpricingvaluation.trade_dt is '日期';
comment on column ${iol_schema}.wind_cbondpricingvaluation.val_agency is '估值机构';
comment on column ${iol_schema}.wind_cbondpricingvaluation.val_agency_id is '估值机构id';
comment on column ${iol_schema}.wind_cbondpricingvaluation.credit_code is '信用评级代码';
comment on column ${iol_schema}.wind_cbondpricingvaluation.term is '期限';
comment on column ${iol_schema}.wind_cbondpricingvaluation.valuation is '定价估值';
comment on column ${iol_schema}.wind_cbondpricingvaluation.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondpricingvaluation.etl_timestamp is 'ETL处理时间戳';
