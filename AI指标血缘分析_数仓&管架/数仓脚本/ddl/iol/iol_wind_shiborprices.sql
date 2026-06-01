/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_shiborprices
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_shiborprices
whenever sqlerror continue none;
drop table ${iol_schema}.wind_shiborprices purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_shiborprices(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,trade_dt varchar2(12) -- 交易日期
    ,b_info_rate number(20,4) -- 利率(%)
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
grant select on ${iol_schema}.wind_shiborprices to ${iml_schema};
grant select on ${iol_schema}.wind_shiborprices to ${icl_schema};
grant select on ${iol_schema}.wind_shiborprices to ${idl_schema};
grant select on ${iol_schema}.wind_shiborprices to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_shiborprices is 'Shibor行情';
comment on column ${iol_schema}.wind_shiborprices.object_id is '对象ID';
comment on column ${iol_schema}.wind_shiborprices.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_shiborprices.trade_dt is '交易日期';
comment on column ${iol_schema}.wind_shiborprices.b_info_rate is '利率(%)';
comment on column ${iol_schema}.wind_shiborprices.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_shiborprices.etl_timestamp is 'ETL处理时间戳';
