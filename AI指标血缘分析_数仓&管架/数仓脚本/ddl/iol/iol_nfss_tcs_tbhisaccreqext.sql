/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tcs_tbhisaccreqext
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tcs_tbhisaccreqext
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tcs_tbhisaccreqext purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tcs_tbhisaccreqext(
    serial_no varchar2(48) -- 
    ,ex_serial varchar2(48) -- 
    ,cfm_no varchar2(48) -- 
    ,cfm_date number(22) -- 
    ,trans_date number(22) -- 
    ,trans_time number(22) -- 
    ,ta_code varchar2(14) -- 
    ,in_client_no varchar2(30) -- 
    ,glblsrlno varchar2(60) -- 
    ,cnsmrsysid varchar2(48) -- 
    ,cnltxncd varchar2(96) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
    ,reserve5 varchar2(375) -- 
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
grant select on ${iol_schema}.nfss_tcs_tbhisaccreqext to ${iml_schema};
grant select on ${iol_schema}.nfss_tcs_tbhisaccreqext to ${icl_schema};
grant select on ${iol_schema}.nfss_tcs_tbhisaccreqext to ${idl_schema};
grant select on ${iol_schema}.nfss_tcs_tbhisaccreqext to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tcs_tbhisaccreqext is '历史账户类请求流水扩展表';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.serial_no is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.ex_serial is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.cfm_no is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.cfm_date is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.trans_date is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.trans_time is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.ta_code is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.in_client_no is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.glblsrlno is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.cnsmrsysid is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.cnltxncd is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.reserve1 is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.reserve2 is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.reserve3 is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.reserve4 is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.reserve5 is '';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nfss_tcs_tbhisaccreqext.etl_timestamp is 'ETL处理时间戳';
