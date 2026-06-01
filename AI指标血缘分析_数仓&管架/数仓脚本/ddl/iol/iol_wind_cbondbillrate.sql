/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondbillrate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondbillrate
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondbillrate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondbillrate(
    object_id varchar2(150) -- 对象id
    ,b_info_ratetype varchar2(150) -- 利率类型
    ,trade_dt varchar2(12) -- 交易日期
    ,b_info_rate number(20,6) -- 利率(%)
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
grant select on ${iol_schema}.wind_cbondbillrate to ${iml_schema};
grant select on ${iol_schema}.wind_cbondbillrate to ${icl_schema};
grant select on ${iol_schema}.wind_cbondbillrate to ${idl_schema};
grant select on ${iol_schema}.wind_cbondbillrate to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondbillrate is '票据利率';
comment on column ${iol_schema}.wind_cbondbillrate.object_id is '对象id';
comment on column ${iol_schema}.wind_cbondbillrate.b_info_ratetype is '利率类型';
comment on column ${iol_schema}.wind_cbondbillrate.trade_dt is '交易日期';
comment on column ${iol_schema}.wind_cbondbillrate.b_info_rate is '利率(%)';
comment on column ${iol_schema}.wind_cbondbillrate.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondbillrate.etl_timestamp is 'ETL处理时间戳';
