/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_aindexeodprices
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_aindexeodprices
whenever sqlerror continue none;
drop table ${iol_schema}.wind_aindexeodprices purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_aindexeodprices(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,trade_dt varchar2(12) -- 交易日期
    ,crncy_code varchar2(15) -- 货币代码
    ,s_dq_preclose number(20,4) -- 昨收盘价(点)
    ,s_dq_open number(20,4) -- 开盘价(点)
    ,s_dq_high number(20,4) -- 最高价(点)
    ,s_dq_low number(20,4) -- 最低价(点)
    ,s_dq_close number(20,4) -- 收盘价(点)
    ,s_dq_change number(20,4) -- 涨跌(点)
    ,s_dq_pctchange number(20,4) -- 涨跌幅(%)
    ,s_dq_volume number(20,4) -- 成交量(手)
    ,s_dq_amount number(20,4) -- 成交金额(千元)
    ,sec_id varchar2(15) -- 证券ID
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
grant select on ${iol_schema}.wind_aindexeodprices to ${iml_schema};
grant select on ${iol_schema}.wind_aindexeodprices to ${icl_schema};
grant select on ${iol_schema}.wind_aindexeodprices to ${idl_schema};
grant select on ${iol_schema}.wind_aindexeodprices to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_aindexeodprices is '中国A股指数日行情';
comment on column ${iol_schema}.wind_aindexeodprices.object_id is '对象ID';
comment on column ${iol_schema}.wind_aindexeodprices.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_aindexeodprices.trade_dt is '交易日期';
comment on column ${iol_schema}.wind_aindexeodprices.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_aindexeodprices.s_dq_preclose is '昨收盘价(点)';
comment on column ${iol_schema}.wind_aindexeodprices.s_dq_open is '开盘价(点)';
comment on column ${iol_schema}.wind_aindexeodprices.s_dq_high is '最高价(点)';
comment on column ${iol_schema}.wind_aindexeodprices.s_dq_low is '最低价(点)';
comment on column ${iol_schema}.wind_aindexeodprices.s_dq_close is '收盘价(点)';
comment on column ${iol_schema}.wind_aindexeodprices.s_dq_change is '涨跌(点)';
comment on column ${iol_schema}.wind_aindexeodprices.s_dq_pctchange is '涨跌幅(%)';
comment on column ${iol_schema}.wind_aindexeodprices.s_dq_volume is '成交量(手)';
comment on column ${iol_schema}.wind_aindexeodprices.s_dq_amount is '成交金额(千元)';
comment on column ${iol_schema}.wind_aindexeodprices.sec_id is '证券ID';
comment on column ${iol_schema}.wind_aindexeodprices.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_aindexeodprices.etl_timestamp is 'ETL处理时间戳';
