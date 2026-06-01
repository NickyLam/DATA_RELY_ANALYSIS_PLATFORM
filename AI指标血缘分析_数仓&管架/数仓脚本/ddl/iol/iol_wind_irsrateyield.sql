/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_irsrateyield
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_irsrateyield
whenever sqlerror continue none;
drop table ${iol_schema}.wind_irsrateyield purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_irsrateyield(
    object_id varchar2(150) -- OBJECT_ID
    ,trade_dt varchar2(12) -- 交易日期
    ,b_anal_curvetype varchar2(60) -- 曲线类型
    ,b_anal_curvetypecode number(9,0) -- 曲线类型代码
    ,b_anal_curveterm number(20,4) -- 期限(年)
    ,b_anal_ytm number(20,4) -- 到期收益率(%)
    ,b_tbf_sytm number(20,4) -- 即期利率(%)
    ,b_tbf_fytm number(20,4) -- 远期利率(%)
    ,opdate date -- 
    ,opmode varchar2(2) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.wind_irsrateyield to ${iml_schema};
grant select on ${iol_schema}.wind_irsrateyield to ${icl_schema};
grant select on ${iol_schema}.wind_irsrateyield to ${idl_schema};
grant select on ${iol_schema}.wind_irsrateyield to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_irsrateyield is '利率互换收益率曲线数据';
comment on column ${iol_schema}.wind_irsrateyield.object_id is 'OBJECT_ID';
comment on column ${iol_schema}.wind_irsrateyield.trade_dt is '交易日期';
comment on column ${iol_schema}.wind_irsrateyield.b_anal_curvetype is '曲线类型';
comment on column ${iol_schema}.wind_irsrateyield.b_anal_curvetypecode is '曲线类型代码';
comment on column ${iol_schema}.wind_irsrateyield.b_anal_curveterm is '期限(年)';
comment on column ${iol_schema}.wind_irsrateyield.b_anal_ytm is '到期收益率(%)';
comment on column ${iol_schema}.wind_irsrateyield.b_tbf_sytm is '即期利率(%)';
comment on column ${iol_schema}.wind_irsrateyield.b_tbf_fytm is '远期利率(%)';
comment on column ${iol_schema}.wind_irsrateyield.opdate is '';
comment on column ${iol_schema}.wind_irsrateyield.opmode is '';
comment on column ${iol_schema}.wind_irsrateyield.start_dt is '开始时间';
comment on column ${iol_schema}.wind_irsrateyield.end_dt is '结束时间';
comment on column ${iol_schema}.wind_irsrateyield.id_mark is '增删标志';
comment on column ${iol_schema}.wind_irsrateyield.etl_timestamp is 'ETL处理时间戳';
