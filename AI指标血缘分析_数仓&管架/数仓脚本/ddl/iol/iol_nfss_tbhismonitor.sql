/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbhismonitor
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbhismonitor
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbhismonitor purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbhismonitor(
    log_serial varchar2(48) -- 
    ,serial_no varchar2(48) -- 
    ,ex_serial varchar2(48) -- 
    ,trans_date number(22,0) -- 
    ,trans_time number(22,0) -- 
    ,channel varchar2(2) -- 
    ,branch_no varchar2(24) -- 
    ,term_no varchar2(24) -- 
    ,oper_no varchar2(48) -- 
    ,auth_oper varchar2(48) -- 
    ,in_client_no varchar2(30) -- 
    ,bank_no varchar2(32) -- 
    ,client_no varchar2(36) -- 
    ,bank_acc varchar2(64) -- 
    ,trans_account varchar2(48) -- 
    ,trans_account_type varchar2(2) -- 
    ,trans_code varchar2(32) -- 
    ,trans_name varchar2(250) -- 
    ,ta_code varchar2(18) -- 
    ,asset_acc varchar2(30) -- 
    ,prd_code varchar2(32) -- 
    ,amt number(18,2) -- 
    ,vol number(18,3) -- 
    ,err_code varchar2(12) -- 
    ,err_msg varchar2(512) -- 
    ,status varchar2(2) -- 
    ,deal_mode varchar2(2) -- 
    ,trans_type varchar2(2) -- 
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
grant select on ${iol_schema}.nfss_tbhismonitor to ${iml_schema};
grant select on ${iol_schema}.nfss_tbhismonitor to ${icl_schema};
grant select on ${iol_schema}.nfss_tbhismonitor to ${idl_schema};
grant select on ${iol_schema}.nfss_tbhismonitor to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbhismonitor is '金融产品代销系统-业务量统计';
comment on column ${iol_schema}.nfss_tbhismonitor.log_serial is '';
comment on column ${iol_schema}.nfss_tbhismonitor.serial_no is '';
comment on column ${iol_schema}.nfss_tbhismonitor.ex_serial is '';
comment on column ${iol_schema}.nfss_tbhismonitor.trans_date is '';
comment on column ${iol_schema}.nfss_tbhismonitor.trans_time is '';
comment on column ${iol_schema}.nfss_tbhismonitor.channel is '';
comment on column ${iol_schema}.nfss_tbhismonitor.branch_no is '';
comment on column ${iol_schema}.nfss_tbhismonitor.term_no is '';
comment on column ${iol_schema}.nfss_tbhismonitor.oper_no is '';
comment on column ${iol_schema}.nfss_tbhismonitor.auth_oper is '';
comment on column ${iol_schema}.nfss_tbhismonitor.in_client_no is '';
comment on column ${iol_schema}.nfss_tbhismonitor.bank_no is '';
comment on column ${iol_schema}.nfss_tbhismonitor.client_no is '';
comment on column ${iol_schema}.nfss_tbhismonitor.bank_acc is '';
comment on column ${iol_schema}.nfss_tbhismonitor.trans_account is '';
comment on column ${iol_schema}.nfss_tbhismonitor.trans_account_type is '';
comment on column ${iol_schema}.nfss_tbhismonitor.trans_code is '';
comment on column ${iol_schema}.nfss_tbhismonitor.trans_name is '';
comment on column ${iol_schema}.nfss_tbhismonitor.ta_code is '';
comment on column ${iol_schema}.nfss_tbhismonitor.asset_acc is '';
comment on column ${iol_schema}.nfss_tbhismonitor.prd_code is '';
comment on column ${iol_schema}.nfss_tbhismonitor.amt is '';
comment on column ${iol_schema}.nfss_tbhismonitor.vol is '';
comment on column ${iol_schema}.nfss_tbhismonitor.err_code is '';
comment on column ${iol_schema}.nfss_tbhismonitor.err_msg is '';
comment on column ${iol_schema}.nfss_tbhismonitor.status is '';
comment on column ${iol_schema}.nfss_tbhismonitor.deal_mode is '';
comment on column ${iol_schema}.nfss_tbhismonitor.trans_type is '';
comment on column ${iol_schema}.nfss_tbhismonitor.reserve1 is '';
comment on column ${iol_schema}.nfss_tbhismonitor.reserve2 is '';
comment on column ${iol_schema}.nfss_tbhismonitor.reserve3 is '';
comment on column ${iol_schema}.nfss_tbhismonitor.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nfss_tbhismonitor.etl_timestamp is 'ETL处理时间戳';
