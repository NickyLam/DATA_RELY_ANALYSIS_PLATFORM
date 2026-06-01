/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_fxeodprices
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_fxeodprices
whenever sqlerror continue none;
drop table ${iol_schema}.wind_fxeodprices purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_fxeodprices(
    object_id varchar2(150) -- 对象ID
    ,trade_dt varchar2(12) -- 交易日期
    ,s_info_windcode varchar2(60) -- 外汇交易代码
    ,s_dq_open number(20,4) -- 开盘价
    ,s_dq_high number(20,4) -- 最高价
    ,s_dq_low number(20,4) -- 最低价
    ,s_dq_close number(20,4) -- 收盘价
    ,windcode varchar2(60) -- Wind代码
    ,s_dq_buy number(20,8) -- 买入价
    ,s_dq_sell number(20,8) -- 卖出价
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
grant select on ${iol_schema}.wind_fxeodprices to ${iml_schema};
grant select on ${iol_schema}.wind_fxeodprices to ${icl_schema};
grant select on ${iol_schema}.wind_fxeodprices to ${idl_schema};
grant select on ${iol_schema}.wind_fxeodprices to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_fxeodprices is '中国外汇交易行情';
comment on column ${iol_schema}.wind_fxeodprices.object_id is '对象ID';
comment on column ${iol_schema}.wind_fxeodprices.trade_dt is '交易日期';
comment on column ${iol_schema}.wind_fxeodprices.s_info_windcode is '外汇交易代码';
comment on column ${iol_schema}.wind_fxeodprices.s_dq_open is '开盘价';
comment on column ${iol_schema}.wind_fxeodprices.s_dq_high is '最高价';
comment on column ${iol_schema}.wind_fxeodprices.s_dq_low is '最低价';
comment on column ${iol_schema}.wind_fxeodprices.s_dq_close is '收盘价';
comment on column ${iol_schema}.wind_fxeodprices.windcode is 'Wind代码';
comment on column ${iol_schema}.wind_fxeodprices.s_dq_buy is '买入价';
comment on column ${iol_schema}.wind_fxeodprices.s_dq_sell is '卖出价';
comment on column ${iol_schema}.wind_fxeodprices.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_fxeodprices.etl_timestamp is 'ETL处理时间戳';
