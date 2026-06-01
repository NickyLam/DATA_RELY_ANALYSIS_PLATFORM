/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_asharepledgetrade
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_asharepledgetrade
whenever sqlerror continue none;
drop table ${iol_schema}.wind_asharepledgetrade purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharepledgetrade(
    object_id varchar2(57) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,trade_dt varchar2(12) -- 交易日期
    ,initial_num number(20,4) -- 初始交易数量
    ,repurchase_num number(20,4) -- 购回交易数量
    ,repurchase_allowance number(20,4) -- 待购回余量
    ,repurchase_allowance1 number(20,4) -- 待购回余量(无限售条件)
    ,repurchase_allowance2 number(20,4) -- 待购回余量(有限售条件)
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
grant select on ${iol_schema}.wind_asharepledgetrade to ${iml_schema};
grant select on ${iol_schema}.wind_asharepledgetrade to ${icl_schema};
grant select on ${iol_schema}.wind_asharepledgetrade to ${idl_schema};
grant select on ${iol_schema}.wind_asharepledgetrade to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_asharepledgetrade is '中国A股质押日交易明细';
comment on column ${iol_schema}.wind_asharepledgetrade.object_id is '对象ID';
comment on column ${iol_schema}.wind_asharepledgetrade.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_asharepledgetrade.trade_dt is '交易日期';
comment on column ${iol_schema}.wind_asharepledgetrade.initial_num is '初始交易数量';
comment on column ${iol_schema}.wind_asharepledgetrade.repurchase_num is '购回交易数量';
comment on column ${iol_schema}.wind_asharepledgetrade.repurchase_allowance is '待购回余量';
comment on column ${iol_schema}.wind_asharepledgetrade.repurchase_allowance1 is '待购回余量(无限售条件)';
comment on column ${iol_schema}.wind_asharepledgetrade.repurchase_allowance2 is '待购回余量(有限售条件)';
comment on column ${iol_schema}.wind_asharepledgetrade.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_asharepledgetrade.etl_timestamp is 'ETL处理时间戳';
