/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbinsureaddreq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbinsureaddreq
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbinsureaddreq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinsureaddreq(
    trans_date number(22) -- 
    ,serial_no varchar2(48) -- 
    ,bank_no varchar2(3) -- 
    ,ta_code varchar2(14) -- 
    ,prd_code varchar2(30) -- 
    ,prd_add_code varchar2(30) -- 
    ,insure_vol number(22) -- 
    ,insure_fee number(18,3) -- 
    ,amt number(18,3) -- 
    ,pay_type varchar2(3) -- 
    ,pay_year varchar2(3) -- 
    ,insure_year_type varchar2(2) -- 
    ,insure_year varchar2(3) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbinsureaddreq to ${iml_schema};
grant select on ${iol_schema}.ifms_tbinsureaddreq to ${icl_schema};
grant select on ${iol_schema}.ifms_tbinsureaddreq to ${idl_schema};
grant select on ${iol_schema}.ifms_tbinsureaddreq to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbinsureaddreq is '附加险流水表';
comment on column ${iol_schema}.ifms_tbinsureaddreq.trans_date is '';
comment on column ${iol_schema}.ifms_tbinsureaddreq.serial_no is '';
comment on column ${iol_schema}.ifms_tbinsureaddreq.bank_no is '';
comment on column ${iol_schema}.ifms_tbinsureaddreq.ta_code is '';
comment on column ${iol_schema}.ifms_tbinsureaddreq.prd_code is '';
comment on column ${iol_schema}.ifms_tbinsureaddreq.prd_add_code is '';
comment on column ${iol_schema}.ifms_tbinsureaddreq.insure_vol is '';
comment on column ${iol_schema}.ifms_tbinsureaddreq.insure_fee is '';
comment on column ${iol_schema}.ifms_tbinsureaddreq.amt is '';
comment on column ${iol_schema}.ifms_tbinsureaddreq.pay_type is '';
comment on column ${iol_schema}.ifms_tbinsureaddreq.pay_year is '';
comment on column ${iol_schema}.ifms_tbinsureaddreq.insure_year_type is '';
comment on column ${iol_schema}.ifms_tbinsureaddreq.insure_year is '';
comment on column ${iol_schema}.ifms_tbinsureaddreq.reserve1 is '';
comment on column ${iol_schema}.ifms_tbinsureaddreq.reserve2 is '';
comment on column ${iol_schema}.ifms_tbinsureaddreq.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbinsureaddreq.etl_timestamp is 'ETL处理时间戳';
