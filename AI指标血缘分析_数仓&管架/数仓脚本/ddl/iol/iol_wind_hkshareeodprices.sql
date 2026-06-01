/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hkshareeodprices
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hkshareeodprices
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hkshareeodprices purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hkshareeodprices(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,trade_dt varchar2(12) -- 交易日期
    ,crncy_code varchar2(15) -- 货币代码
    ,s_dq_open number(20,4) -- 开盘价(元)
    ,s_dq_high number(20,4) -- 最高价(元)
    ,s_dq_low number(20,4) -- 最低价(元)
    ,s_dq_close number(20,4) -- 收盘价(元)
    ,s_dq_volume number(20,4) -- 成交量(股)
    ,s_dq_amount number(20,4) -- 成交金额(千元)
    ,s_dq_preclose number(20,4) -- 前收盘价(元)
    ,s_dq_adjpreclose number(20,8) -- 复权昨收盘价(元)
    ,s_dq_adjopen number(20,8) -- 复权开盘价(元)
    ,s_dq_adjhigh number(20,8) -- 复权最高价(元)
    ,s_dq_adjlow number(20,8) -- 复权最低价(元)
    ,s_dq_adjclose number(20,8) -- 复权收盘价(元)
    ,s_dq_adjfactor number(32,16) -- 复权因子
    ,s_dq_avgprice number(20,4) -- 均价(VWAP)
    ,dividend_yield number(20,4) -- 股息率(废弃)
    ,s_dq_adjclose_backward number(20,4) -- 前复权收盘价(元)
    ,opdate date -- 
    ,opmode varchar2(2) -- 
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
grant select on ${iol_schema}.wind_hkshareeodprices to ${iml_schema};
grant select on ${iol_schema}.wind_hkshareeodprices to ${icl_schema};
grant select on ${iol_schema}.wind_hkshareeodprices to ${idl_schema};
grant select on ${iol_schema}.wind_hkshareeodprices to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hkshareeodprices is '香港股票日行情';
comment on column ${iol_schema}.wind_hkshareeodprices.object_id is '对象ID';
comment on column ${iol_schema}.wind_hkshareeodprices.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_hkshareeodprices.trade_dt is '交易日期';
comment on column ${iol_schema}.wind_hkshareeodprices.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_hkshareeodprices.s_dq_open is '开盘价(元)';
comment on column ${iol_schema}.wind_hkshareeodprices.s_dq_high is '最高价(元)';
comment on column ${iol_schema}.wind_hkshareeodprices.s_dq_low is '最低价(元)';
comment on column ${iol_schema}.wind_hkshareeodprices.s_dq_close is '收盘价(元)';
comment on column ${iol_schema}.wind_hkshareeodprices.s_dq_volume is '成交量(股)';
comment on column ${iol_schema}.wind_hkshareeodprices.s_dq_amount is '成交金额(千元)';
comment on column ${iol_schema}.wind_hkshareeodprices.s_dq_preclose is '前收盘价(元)';
comment on column ${iol_schema}.wind_hkshareeodprices.s_dq_adjpreclose is '复权昨收盘价(元)';
comment on column ${iol_schema}.wind_hkshareeodprices.s_dq_adjopen is '复权开盘价(元)';
comment on column ${iol_schema}.wind_hkshareeodprices.s_dq_adjhigh is '复权最高价(元)';
comment on column ${iol_schema}.wind_hkshareeodprices.s_dq_adjlow is '复权最低价(元)';
comment on column ${iol_schema}.wind_hkshareeodprices.s_dq_adjclose is '复权收盘价(元)';
comment on column ${iol_schema}.wind_hkshareeodprices.s_dq_adjfactor is '复权因子';
comment on column ${iol_schema}.wind_hkshareeodprices.s_dq_avgprice is '均价(VWAP)';
comment on column ${iol_schema}.wind_hkshareeodprices.dividend_yield is '股息率(废弃)';
comment on column ${iol_schema}.wind_hkshareeodprices.s_dq_adjclose_backward is '前复权收盘价(元)';
comment on column ${iol_schema}.wind_hkshareeodprices.opdate is '';
comment on column ${iol_schema}.wind_hkshareeodprices.opmode is '';
comment on column ${iol_schema}.wind_hkshareeodprices.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_hkshareeodprices.etl_timestamp is 'ETL处理时间戳';
