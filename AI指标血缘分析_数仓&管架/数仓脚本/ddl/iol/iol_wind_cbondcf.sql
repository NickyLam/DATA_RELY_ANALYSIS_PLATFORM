/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondcf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondcf
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondcf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondcf(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,b_info_carrydate varchar2(12) -- 计息起始日
    ,b_info_enddate varchar2(12) -- 计息截止日
    ,b_info_couponrate number(22,6) -- 票面利率(%)
    ,b_info_paymentdate varchar2(12) -- 现金流发放日
    ,b_info_paymentinterest number(22,12) -- 期末每百元面额应付利息
    ,b_info_paymentparvalue number(22,12) -- 期末每百元面额应付本金
    ,b_info_paymentsum number(22,12) -- 期末每百元面额现金流合计
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
grant select on ${iol_schema}.wind_cbondcf to ${iml_schema};
grant select on ${iol_schema}.wind_cbondcf to ${icl_schema};
grant select on ${iol_schema}.wind_cbondcf to ${idl_schema};
grant select on ${iol_schema}.wind_cbondcf to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondcf is '中国债券现金流';
comment on column ${iol_schema}.wind_cbondcf.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondcf.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_cbondcf.b_info_carrydate is '计息起始日';
comment on column ${iol_schema}.wind_cbondcf.b_info_enddate is '计息截止日';
comment on column ${iol_schema}.wind_cbondcf.b_info_couponrate is '票面利率(%)';
comment on column ${iol_schema}.wind_cbondcf.b_info_paymentdate is '现金流发放日';
comment on column ${iol_schema}.wind_cbondcf.b_info_paymentinterest is '期末每百元面额应付利息';
comment on column ${iol_schema}.wind_cbondcf.b_info_paymentparvalue is '期末每百元面额应付本金';
comment on column ${iol_schema}.wind_cbondcf.b_info_paymentsum is '期末每百元面额现金流合计';
comment on column ${iol_schema}.wind_cbondcf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondcf.etl_timestamp is 'ETL处理时间戳';
