/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_vtrd_set_instruction_cash
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_vtrd_set_instruction_cash
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_vtrd_set_instruction_cash purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_set_instruction_cash(
    cash_inst_id number(16,0) -- 
    ,inst_id number(16,0) -- 
    ,cash_inst_grp_id number(16,0) -- 
    ,biz_type varchar2(45) -- 
    ,direction varchar2(15) -- 
    ,cash_acct_id varchar2(45) -- 
    ,ext_cash_acct_id varchar2(30) -- 
    ,currency varchar2(15) -- 
    ,amount number(31,4) -- 
    ,freeze_amount number(31,4) -- 
    ,set_date varchar2(15) -- 
    ,set_finish_date varchar2(15) -- 
    ,transfer_type number(22,0) -- 
    ,acct_code varchar2(150) -- 
    ,acct_name varchar2(150) -- 
    ,bank_code varchar2(150) -- 
    ,bank_name varchar2(150) -- 
    ,party_acct_code varchar2(150) -- 
    ,party_acct_name varchar2(150) -- 
    ,party_bank_code varchar2(150) -- 
    ,party_bank_name varchar2(300) -- 
    ,create_time varchar2(29) -- 
    ,update_time varchar2(35) -- 
    ,update_user varchar2(150) -- 
    ,account_time varchar2(29) -- 
    ,account_user varchar2(30) -- 
    ,memo varchar2(750) -- 
    ,blc_state number(22,0) -- 
    ,acctg_state number(22,0) -- 
    ,opr_state number(22,0) -- 
    ,cash_inst_setgrp_id number(16,0) -- 
    ,acctg_inst_id number(16,0) -- 
    ,cancel_flag varchar2(2) -- 
    ,is_theory_blc varchar2(2) -- 
    ,nostro_ref_cash_inst_id number(16,0) -- 
    ,pending_flow_no varchar2(45) -- 
    ,pending_date varchar2(15) -- 
    ,is_theory_acct varchar2(2) -- 
    ,mid_bank_acct_code varchar2(75) -- 
    ,mid_bank_name varchar2(75) -- 
    ,mid_swift_code varchar2(75) -- 
    ,swift_code varchar2(75) -- 
    ,party_swift_code varchar2(75) -- 
    ,party_mid_bank_acct_code varchar2(75) -- 
    ,party_mid_bank_name varchar2(75) -- 
    ,party_mid_swift_code varchar2(75) -- 
    ,cl_status number(31,0) -- 
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
grant select on ${iol_schema}.ibms_vtrd_set_instruction_cash to ${iml_schema};
grant select on ${iol_schema}.ibms_vtrd_set_instruction_cash to ${icl_schema};
grant select on ${iol_schema}.ibms_vtrd_set_instruction_cash to ${idl_schema};
grant select on ${iol_schema}.ibms_vtrd_set_instruction_cash to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_vtrd_set_instruction_cash is '资金指令表(视图)';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.cash_inst_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.inst_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.cash_inst_grp_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.biz_type is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.direction is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.cash_acct_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.ext_cash_acct_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.currency is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.amount is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.freeze_amount is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.set_date is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.set_finish_date is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.transfer_type is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.acct_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.acct_name is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.bank_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.bank_name is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.party_acct_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.party_acct_name is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.party_bank_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.party_bank_name is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.create_time is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.update_time is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.update_user is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.account_time is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.account_user is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.memo is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.blc_state is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.acctg_state is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.opr_state is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.cash_inst_setgrp_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.acctg_inst_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.cancel_flag is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.is_theory_blc is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.nostro_ref_cash_inst_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.pending_flow_no is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.pending_date is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.is_theory_acct is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.mid_bank_acct_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.mid_bank_name is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.mid_swift_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.swift_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.party_swift_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.party_mid_bank_acct_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.party_mid_bank_name is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.party_mid_swift_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.cl_status is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_cash.etl_timestamp is 'ETL处理时间戳';
