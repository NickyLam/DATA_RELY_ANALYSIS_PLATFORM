/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondspecialcurvecnbd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondspecialcurvecnbd
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondspecialcurvecnbd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondspecialcurvecnbd(
    object_id varchar2(57) -- 对象ID
    ,trade_dt varchar2(12) -- 日期
    ,b_anal_curvename varchar2(300) -- 曲线名称
    ,b_anal_curvenumber number(10,0) -- 曲线编号
    ,b_anal_curvetype varchar2(300) -- 曲线类型
    ,b_anal_curveterm number(24,8) -- 标准期限(年)
    ,b_anal_yield number(24,8) -- 收益率(%)
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
grant select on ${iol_schema}.wind_cbondspecialcurvecnbd to ${iml_schema};
grant select on ${iol_schema}.wind_cbondspecialcurvecnbd to ${icl_schema};
grant select on ${iol_schema}.wind_cbondspecialcurvecnbd to ${idl_schema};
grant select on ${iol_schema}.wind_cbondspecialcurvecnbd to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondspecialcurvecnbd is '中债登特殊收益率曲线';
comment on column ${iol_schema}.wind_cbondspecialcurvecnbd.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondspecialcurvecnbd.trade_dt is '日期';
comment on column ${iol_schema}.wind_cbondspecialcurvecnbd.b_anal_curvename is '曲线名称';
comment on column ${iol_schema}.wind_cbondspecialcurvecnbd.b_anal_curvenumber is '曲线编号';
comment on column ${iol_schema}.wind_cbondspecialcurvecnbd.b_anal_curvetype is '曲线类型';
comment on column ${iol_schema}.wind_cbondspecialcurvecnbd.b_anal_curveterm is '标准期限(年)';
comment on column ${iol_schema}.wind_cbondspecialcurvecnbd.b_anal_yield is '收益率(%)';
comment on column ${iol_schema}.wind_cbondspecialcurvecnbd.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondspecialcurvecnbd.etl_timestamp is 'ETL处理时间戳';
