/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbacccfm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbacccfm
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbacccfm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbacccfm(
    ta_code varchar2(18) -- 
    ,cfm_date number(22) -- 
    ,cfm_no varchar2(48) -- 
    ,from_flag varchar2(2) -- 
    ,trans_date number(22) -- 
    ,trans_time number(22) -- 
    ,serial_no varchar2(48) -- 
    ,trans_code varchar2(32) -- 
    ,busin_code varchar2(9) -- 
    ,branch_no varchar2(24) -- 
    ,open_branch varchar2(80) -- 
    ,channel varchar2(2) -- 
    ,term_no varchar2(24) -- 
    ,oper_no varchar2(48) -- 
    ,in_client_no varchar2(30) -- 
    ,client_type varchar2(2) -- 
    ,asset_acc varchar2(30) -- 
    ,bank_no varchar2(32) -- 
    ,client_no varchar2(36) -- 
    ,bank_acc varchar2(64) -- 
    ,ta_client varchar2(48) -- 
    ,trans_account_type varchar2(2) -- 
    ,trans_account varchar2(48) -- 
    ,sex varchar2(2) -- 
    ,id_type varchar2(3) -- 
    ,id_code varchar2(50) -- 
    ,client_name varchar2(375) -- 
    ,short_name varchar2(375) -- 
    ,birthday number(22) -- 
    ,address varchar2(512) -- 
    ,post_code varchar2(12) -- 
    ,mobile varchar2(45) -- 
    ,tel varchar2(45) -- 
    ,fax varchar2(45) -- 
    ,email varchar2(256) -- 
    ,send_freq varchar2(2) -- 
    ,send_mode varchar2(12) -- 
    ,asso_date number(22) -- 
    ,frozen_cause varchar2(2) -- 
    ,acc_card_no varchar2(12) -- 
    ,summary varchar2(375) -- 
    ,asso_serial varchar2(48) -- 
    ,client_manager varchar2(48) -- 
    ,err_code varchar2(12) -- 
    ,err_msg varchar2(512) -- 
    ,status varchar2(2) -- 
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
grant select on ${iol_schema}.ifms_tbacccfm to ${iml_schema};
grant select on ${iol_schema}.ifms_tbacccfm to ${icl_schema};
grant select on ${iol_schema}.ifms_tbacccfm to ${idl_schema};
grant select on ${iol_schema}.ifms_tbacccfm to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbacccfm is '账户类确认表';
comment on column ${iol_schema}.ifms_tbacccfm.ta_code is '';
comment on column ${iol_schema}.ifms_tbacccfm.cfm_date is '';
comment on column ${iol_schema}.ifms_tbacccfm.cfm_no is '';
comment on column ${iol_schema}.ifms_tbacccfm.from_flag is '';
comment on column ${iol_schema}.ifms_tbacccfm.trans_date is '';
comment on column ${iol_schema}.ifms_tbacccfm.trans_time is '';
comment on column ${iol_schema}.ifms_tbacccfm.serial_no is '';
comment on column ${iol_schema}.ifms_tbacccfm.trans_code is '';
comment on column ${iol_schema}.ifms_tbacccfm.busin_code is '';
comment on column ${iol_schema}.ifms_tbacccfm.branch_no is '';
comment on column ${iol_schema}.ifms_tbacccfm.open_branch is '';
comment on column ${iol_schema}.ifms_tbacccfm.channel is '';
comment on column ${iol_schema}.ifms_tbacccfm.term_no is '';
comment on column ${iol_schema}.ifms_tbacccfm.oper_no is '';
comment on column ${iol_schema}.ifms_tbacccfm.in_client_no is '';
comment on column ${iol_schema}.ifms_tbacccfm.client_type is '';
comment on column ${iol_schema}.ifms_tbacccfm.asset_acc is '';
comment on column ${iol_schema}.ifms_tbacccfm.bank_no is '';
comment on column ${iol_schema}.ifms_tbacccfm.client_no is '';
comment on column ${iol_schema}.ifms_tbacccfm.bank_acc is '';
comment on column ${iol_schema}.ifms_tbacccfm.ta_client is '';
comment on column ${iol_schema}.ifms_tbacccfm.trans_account_type is '';
comment on column ${iol_schema}.ifms_tbacccfm.trans_account is '';
comment on column ${iol_schema}.ifms_tbacccfm.sex is '';
comment on column ${iol_schema}.ifms_tbacccfm.id_type is '';
comment on column ${iol_schema}.ifms_tbacccfm.id_code is '';
comment on column ${iol_schema}.ifms_tbacccfm.client_name is '';
comment on column ${iol_schema}.ifms_tbacccfm.short_name is '';
comment on column ${iol_schema}.ifms_tbacccfm.birthday is '';
comment on column ${iol_schema}.ifms_tbacccfm.address is '';
comment on column ${iol_schema}.ifms_tbacccfm.post_code is '';
comment on column ${iol_schema}.ifms_tbacccfm.mobile is '';
comment on column ${iol_schema}.ifms_tbacccfm.tel is '';
comment on column ${iol_schema}.ifms_tbacccfm.fax is '';
comment on column ${iol_schema}.ifms_tbacccfm.email is '';
comment on column ${iol_schema}.ifms_tbacccfm.send_freq is '';
comment on column ${iol_schema}.ifms_tbacccfm.send_mode is '';
comment on column ${iol_schema}.ifms_tbacccfm.asso_date is '';
comment on column ${iol_schema}.ifms_tbacccfm.frozen_cause is '';
comment on column ${iol_schema}.ifms_tbacccfm.acc_card_no is '';
comment on column ${iol_schema}.ifms_tbacccfm.summary is '';
comment on column ${iol_schema}.ifms_tbacccfm.asso_serial is '';
comment on column ${iol_schema}.ifms_tbacccfm.client_manager is '';
comment on column ${iol_schema}.ifms_tbacccfm.err_code is '';
comment on column ${iol_schema}.ifms_tbacccfm.err_msg is '';
comment on column ${iol_schema}.ifms_tbacccfm.status is '';
comment on column ${iol_schema}.ifms_tbacccfm.reserve1 is '';
comment on column ${iol_schema}.ifms_tbacccfm.reserve2 is '';
comment on column ${iol_schema}.ifms_tbacccfm.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbacccfm.etl_timestamp is 'ETL处理时间戳';
