/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tcs_tbhxyncycle
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tcs_tbhxyncycle
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tcs_tbhxyncycle purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tcs_tbhxyncycle(
    cycle_no varchar2(375) -- 
    ,ta_code varchar2(14) -- 
    ,prd_code varchar2(30) -- 
    ,start_date number(22,0) -- 
    ,end_date number(22,0) -- 
    ,serial_no varchar2(48) -- 
    ,prd_limit number(22,0) -- 
    ,int1 number(22,0) -- 
    ,int2 number(22,0) -- 
    ,int3 number(22,0) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
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
grant select on ${iol_schema}.nfss_tcs_tbhxyncycle to ${iml_schema};
grant select on ${iol_schema}.nfss_tcs_tbhxyncycle to ${icl_schema};
grant select on ${iol_schema}.nfss_tcs_tbhxyncycle to ${idl_schema};
grant select on ${iol_schema}.nfss_tcs_tbhxyncycle to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tcs_tbhxyncycle is '华兴银行周期产品大周期表';
comment on column ${iol_schema}.nfss_tcs_tbhxyncycle.cycle_no is '';
comment on column ${iol_schema}.nfss_tcs_tbhxyncycle.ta_code is '';
comment on column ${iol_schema}.nfss_tcs_tbhxyncycle.prd_code is '';
comment on column ${iol_schema}.nfss_tcs_tbhxyncycle.start_date is '';
comment on column ${iol_schema}.nfss_tcs_tbhxyncycle.end_date is '';
comment on column ${iol_schema}.nfss_tcs_tbhxyncycle.serial_no is '';
comment on column ${iol_schema}.nfss_tcs_tbhxyncycle.prd_limit is '';
comment on column ${iol_schema}.nfss_tcs_tbhxyncycle.int1 is '';
comment on column ${iol_schema}.nfss_tcs_tbhxyncycle.int2 is '';
comment on column ${iol_schema}.nfss_tcs_tbhxyncycle.int3 is '';
comment on column ${iol_schema}.nfss_tcs_tbhxyncycle.reserve1 is '';
comment on column ${iol_schema}.nfss_tcs_tbhxyncycle.reserve2 is '';
comment on column ${iol_schema}.nfss_tcs_tbhxyncycle.reserve3 is '';
comment on column ${iol_schema}.nfss_tcs_tbhxyncycle.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nfss_tcs_tbhxyncycle.etl_timestamp is 'ETL处理时间戳';
