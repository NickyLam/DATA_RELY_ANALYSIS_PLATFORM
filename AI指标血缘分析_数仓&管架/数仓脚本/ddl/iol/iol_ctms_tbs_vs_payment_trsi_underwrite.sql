/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_payment_trsi_underwrite
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite(
    cpty_id number -- 
    ,settledate number -- 
    ,generatedate number -- 
    ,releasedate number -- 
    ,actiontype varchar2(60) -- 
    ,dealtype varchar2(60) -- 
    ,buztype varchar2(60) -- 
    ,assettype varchar2(60) -- 
    ,keepfolder_id number -- 
    ,payment_id_prev number -- 
    ,sequence number -- 
    ,eventtype varchar2(5) -- 
    ,deal_id number -- 
    ,deal_tablename varchar2(45) -- 
    ,dealsconfirm_id number -- 
    ,aspclient_id number -- 
    ,payment_id number -- 
    ,cpty_datasymbol_id number -- 
    ,cpty_lastmodified timestamp -- 
    ,cpty_g_mgr_bank varchar2(384) -- 
    ,cpty_g_stl_date varchar2(384) -- 
    ,cpty_g_ba_no varchar2(384) -- 
    ,cpty_g_ba_bank varchar2(384) -- 
    ,cpty_g_ba_name varchar2(384) -- 
    ,cpty_g_ca_bank_ex varchar2(384) -- 
    ,cpty_g_ca_no varchar2(384) -- 
    ,cpty_g_ca_bank varchar2(384) -- 
    ,cpty_g_ca_name varchar2(384) -- 
    ,cpty_g_bond_total_amt varchar2(384) -- 
    ,cpty_g_bond_amt varchar2(384) -- 
    ,cpty_g_bond_name varchar2(384) -- 
    ,cpty_g_bond_id varchar2(384) -- 
    ,cpty_g_cash_amt varchar2(384) -- 
    ,cpty_bond_acc_no varchar2(384) -- 
    ,cpty_bond_acc_bank varchar2(384) -- 
    ,cpty_bond_acc_name varchar2(384) -- 
    ,cpty_cash_acc_bank_ex varchar2(384) -- 
    ,cpty_cash_acc_no varchar2(384) -- 
    ,cpty_cash_acc_bank varchar2(384) -- 
    ,cpty_cash_acc_cname varchar2(384) -- 
    ,cpty_cash_acc_ename varchar2(384) -- 
    ,cpty_bs varchar2(3) -- 
    ,cpty_serial_number varchar2(23) -- 
    ,self_datasymbol_id number -- 
    ,self_lastmodified timestamp -- 
    ,self_g_mgr_bank varchar2(384) -- 
    ,self_g_stl_date varchar2(384) -- 
    ,self_g_ba_no varchar2(384) -- 
    ,self_g_ba_bank varchar2(384) -- 
    ,self_g_ba_name varchar2(384) -- 
    ,self_g_ca_bank_ex varchar2(384) -- 
    ,self_g_ca_no varchar2(384) -- 
    ,self_g_ca_bank varchar2(384) -- 
    ,self_g_ca_name varchar2(384) -- 
    ,self_g_bond_total_amt varchar2(384) -- 
    ,self_g_bond_amt varchar2(384) -- 
    ,self_g_bond_name varchar2(384) -- 
    ,self_g_bond_id varchar2(384) -- 
    ,self_g_cash_amt varchar2(384) -- 
    ,self_bond_acc_no varchar2(384) -- 
    ,self_bond_acc_bank varchar2(384) -- 
    ,self_bond_acc_name varchar2(384) -- 
    ,self_cash_acc_bank_ex varchar2(384) -- 
    ,self_cash_acc_no varchar2(384) -- 
    ,self_cash_acc_bank varchar2(384) -- 
    ,self_cash_acc_cname varchar2(384) -- 
    ,self_cash_acc_ename varchar2(384) -- 
    ,self_bs varchar2(3) -- 
    ,self_serial_number varchar2(23) -- 
    ,bs varchar2(2) -- 
    ,serial_number varchar2(23) -- 
    ,note varchar2(600) -- 
    ,act_advance_amount number -- 
    ,act_settlemethod varchar2(5) -- 
    ,settlemethod varchar2(5) -- 
    ,users_id_modifier number -- 
    ,lastmodified timestamp -- 
    ,pstatus varchar2(3) -- 
    ,act_quantity number -- 
    ,act_securitycode varchar2(48) -- 
    ,act_settleamount number -- 
    ,act_settlecurrency varchar2(5) -- 
    ,act_settledate number -- 
    ,quantity number -- 
    ,securitycode varchar2(48) -- 
    ,settleamount number -- 
    ,settlecurrency varchar2(5) -- 
    ,payreceivetype varchar2(2) -- 
    ,cpty_name varchar2(192) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_id is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.settledate is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.generatedate is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.releasedate is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.actiontype is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.dealtype is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.buztype is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.assettype is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.keepfolder_id is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.payment_id_prev is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.sequence is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.eventtype is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.deal_id is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.deal_tablename is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.dealsconfirm_id is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.aspclient_id is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.payment_id is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_datasymbol_id is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_lastmodified is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_g_mgr_bank is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_g_stl_date is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_g_ba_no is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_g_ba_bank is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_g_ba_name is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_g_ca_bank_ex is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_g_ca_no is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_g_ca_bank is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_g_ca_name is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_g_bond_total_amt is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_g_bond_amt is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_g_bond_name is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_g_bond_id is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_g_cash_amt is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_bond_acc_no is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_bond_acc_bank is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_bond_acc_name is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_cash_acc_bank_ex is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_cash_acc_no is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_cash_acc_bank is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_cash_acc_cname is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_cash_acc_ename is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_bs is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_serial_number is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_datasymbol_id is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_lastmodified is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_g_mgr_bank is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_g_stl_date is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_g_ba_no is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_g_ba_bank is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_g_ba_name is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_g_ca_bank_ex is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_g_ca_no is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_g_ca_bank is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_g_ca_name is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_g_bond_total_amt is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_g_bond_amt is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_g_bond_name is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_g_bond_id is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_g_cash_amt is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_bond_acc_no is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_bond_acc_bank is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_bond_acc_name is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_cash_acc_bank_ex is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_cash_acc_no is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_cash_acc_bank is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_cash_acc_cname is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_cash_acc_ename is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_bs is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.self_serial_number is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.bs is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.serial_number is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.note is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.act_advance_amount is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.act_settlemethod is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.settlemethod is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.users_id_modifier is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.lastmodified is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.pstatus is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.act_quantity is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.act_securitycode is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.act_settleamount is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.act_settlecurrency is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.act_settledate is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.quantity is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.securitycode is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.settleamount is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.settlecurrency is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.payreceivetype is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.cpty_name is '';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite.etl_timestamp is 'ETL处理时间戳';
