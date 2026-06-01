/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hiborprices
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hiborprices
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hiborprices purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hiborprices(
    object_id varchar2(150) -- 对象id
    ,s_info_windcode varchar2(60) -- wind代码
    ,trade_dt varchar2(12) -- 交易日期
    ,b_info_rate number(20,8) -- 利率(%)
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
grant select on ${iol_schema}.wind_hiborprices to ${iml_schema};
grant select on ${iol_schema}.wind_hiborprices to ${icl_schema};
grant select on ${iol_schema}.wind_hiborprices to ${idl_schema};
grant select on ${iol_schema}.wind_hiborprices to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hiborprices is 'Hibor行情';
comment on column ${iol_schema}.wind_hiborprices.object_id is '对象id';
comment on column ${iol_schema}.wind_hiborprices.s_info_windcode is 'wind代码';
comment on column ${iol_schema}.wind_hiborprices.trade_dt is '交易日期';
comment on column ${iol_schema}.wind_hiborprices.b_info_rate is '利率(%)';
comment on column ${iol_schema}.wind_hiborprices.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_hiborprices.etl_timestamp is 'ETL处理时间戳';
