/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbhisaccreq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbhisaccreq
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbhisaccreq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbhisaccreq(
    serial_no varchar2(48) -- 
    ,ex_serial varchar2(48) -- 
    ,cfm_no varchar2(48) -- 
    ,trans_date number(22) -- 
    ,trans_time number(22) -- 
    ,occur_init_date number(22) -- 
    ,cfm_date number(22) -- 
    ,trans_code varchar2(32) -- 
    ,control_flag varchar2(512) -- 
    ,branch_no varchar2(24) -- 
    ,open_branch varchar2(80) -- 
    ,ta_code varchar2(18) -- 
    ,in_client_no varchar2(30) -- 
    ,client_type varchar2(2) -- 
    ,id_type varchar2(3) -- 
    ,id_code varchar2(50) -- 
    ,client_name varchar2(375) -- 
    ,short_name varchar2(375) -- 
    ,asset_acc varchar2(30) -- 
    ,base_acc varchar2(15) -- 
    ,seller_code varchar2(14) -- 
    ,bank_no varchar2(32) -- 
    ,client_no varchar2(36) -- 
    ,bank_acc varchar2(64) -- 
    ,trans_account_type varchar2(2) -- 
    ,trans_account varchar2(48) -- 
    ,sex varchar2(2) -- 
    ,birthday number(22) -- 
    ,address varchar2(512) -- 
    ,post_code varchar2(12) -- 
    ,mobile varchar2(45) -- 
    ,tel varchar2(45) -- 
    ,fax varchar2(45) -- 
    ,email varchar2(256) -- 
    ,send_mode varchar2(12) -- 
    ,send_freq varchar2(2) -- 
    ,asso_date number(22) -- 
    ,frozen_cause varchar2(2) -- 
    ,summary varchar2(375) -- 
    ,asso_serial varchar2(48) -- 
    ,channel varchar2(2) -- 
    ,term_no varchar2(24) -- 
    ,oper_no varchar2(48) -- 
    ,auth_oper varchar2(48) -- 
    ,client_manager varchar2(48) -- 
    ,err_code varchar2(12) -- 
    ,err_msg varchar2(512) -- 
    ,status varchar2(2) -- 
    ,deal_mode varchar2(2) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbhisaccreq to ${iml_schema};
grant select on ${iol_schema}.ifms_tbhisaccreq to ${icl_schema};
grant select on ${iol_schema}.ifms_tbhisaccreq to ${idl_schema};
grant select on ${iol_schema}.ifms_tbhisaccreq to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbhisaccreq is '帐户类请求历史流水表';
comment on column ${iol_schema}.ifms_tbhisaccreq.serial_no is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.ex_serial is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.cfm_no is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.trans_date is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.trans_time is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.occur_init_date is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.cfm_date is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.trans_code is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.control_flag is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.branch_no is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.open_branch is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.ta_code is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.in_client_no is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.client_type is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.id_type is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.id_code is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.client_name is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.short_name is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.asset_acc is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.base_acc is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.seller_code is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.bank_no is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.client_no is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.bank_acc is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.trans_account_type is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.trans_account is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.sex is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.birthday is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.address is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.post_code is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.mobile is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.tel is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.fax is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.email is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.send_mode is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.send_freq is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.asso_date is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.frozen_cause is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.summary is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.asso_serial is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.channel is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.term_no is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.oper_no is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.auth_oper is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.client_manager is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.err_code is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.err_msg is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.status is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.deal_mode is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.reserve1 is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.reserve2 is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.reserve3 is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.reserve4 is '';
comment on column ${iol_schema}.ifms_tbhisaccreq.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbhisaccreq.etl_timestamp is 'ETL处理时间戳';
