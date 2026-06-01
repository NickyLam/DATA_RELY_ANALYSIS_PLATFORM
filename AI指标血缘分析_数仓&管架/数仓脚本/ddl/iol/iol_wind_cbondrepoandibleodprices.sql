/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondrepoandibleodprices
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondrepoandibleodprices
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondrepoandibleodprices purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondrepoandibleodprices(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,trade_dt varchar2(12) -- 日期
    ,s_dq_open number(20,4) -- 开盘价(%)
    ,s_dq_high number(20,4) -- 最高价(%)
    ,s_dq_low number(20,4) -- 最低价(%)
    ,s_dq_close number(20,4) -- 收盘价(%)
    ,b_dq_waveragerate number(20,8) -- 加权价(%)
    ,s_dq_volume number(20,4) -- 成交笔数
    ,s_dq_amount number(20,4) -- 成交金额(元)
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
grant select on ${iol_schema}.wind_cbondrepoandibleodprices to ${iml_schema};
grant select on ${iol_schema}.wind_cbondrepoandibleodprices to ${icl_schema};
grant select on ${iol_schema}.wind_cbondrepoandibleodprices to ${idl_schema};
grant select on ${iol_schema}.wind_cbondrepoandibleodprices to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondrepoandibleodprices is '中国银行间债券回购及同业拆借日行情';
comment on column ${iol_schema}.wind_cbondrepoandibleodprices.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondrepoandibleodprices.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_cbondrepoandibleodprices.trade_dt is '日期';
comment on column ${iol_schema}.wind_cbondrepoandibleodprices.s_dq_open is '开盘价(%)';
comment on column ${iol_schema}.wind_cbondrepoandibleodprices.s_dq_high is '最高价(%)';
comment on column ${iol_schema}.wind_cbondrepoandibleodprices.s_dq_low is '最低价(%)';
comment on column ${iol_schema}.wind_cbondrepoandibleodprices.s_dq_close is '收盘价(%)';
comment on column ${iol_schema}.wind_cbondrepoandibleodprices.b_dq_waveragerate is '加权价(%)';
comment on column ${iol_schema}.wind_cbondrepoandibleodprices.s_dq_volume is '成交笔数';
comment on column ${iol_schema}.wind_cbondrepoandibleodprices.s_dq_amount is '成交金额(元)';
comment on column ${iol_schema}.wind_cbondrepoandibleodprices.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondrepoandibleodprices.etl_timestamp is 'ETL处理时间戳';
