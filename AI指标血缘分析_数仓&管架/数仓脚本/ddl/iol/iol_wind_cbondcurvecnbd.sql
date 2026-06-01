/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondcurvecnbd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondcurvecnbd
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondcurvecnbd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondcurvecnbd(
    trade_dt varchar2(12) -- 发生日期
    ,b_anal_curvenumber number(10,0) -- 中债登收益率曲线ID
    ,b_anal_curvename varchar2(300) -- 曲线名称
    ,b_anal_curvetype varchar2(120) -- 曲线类型
    ,b_anal_curveterm number(20,4) -- 标准期限(年)
    ,b_anal_yield number(20,6) -- 收益率(%)
    ,b_anal_base_yield number(20,4) -- 估值日基础利率
    ,b_anal_yield_total number(20,4) -- 收益率曲线数值
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
grant select on ${iol_schema}.wind_cbondcurvecnbd to ${iml_schema};
grant select on ${iol_schema}.wind_cbondcurvecnbd to ${icl_schema};
grant select on ${iol_schema}.wind_cbondcurvecnbd to ${idl_schema};
grant select on ${iol_schema}.wind_cbondcurvecnbd to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondcurvecnbd is '中债登债券收益率曲线';
comment on column ${iol_schema}.wind_cbondcurvecnbd.trade_dt is '发生日期';
comment on column ${iol_schema}.wind_cbondcurvecnbd.b_anal_curvenumber is '中债登收益率曲线ID';
comment on column ${iol_schema}.wind_cbondcurvecnbd.b_anal_curvename is '曲线名称';
comment on column ${iol_schema}.wind_cbondcurvecnbd.b_anal_curvetype is '曲线类型';
comment on column ${iol_schema}.wind_cbondcurvecnbd.b_anal_curveterm is '标准期限(年)';
comment on column ${iol_schema}.wind_cbondcurvecnbd.b_anal_yield is '收益率(%)';
comment on column ${iol_schema}.wind_cbondcurvecnbd.b_anal_base_yield is '估值日基础利率';
comment on column ${iol_schema}.wind_cbondcurvecnbd.b_anal_yield_total is '收益率曲线数值';
comment on column ${iol_schema}.wind_cbondcurvecnbd.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondcurvecnbd.etl_timestamp is 'ETL处理时间戳';
