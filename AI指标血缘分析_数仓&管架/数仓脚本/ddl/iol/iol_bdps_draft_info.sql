/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_draft_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_draft_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_draft_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_draft_info(
    id number(22) -- 
    ,draft_number varchar2(45) -- 
    ,src_type varchar2(3) -- 
    ,end_or_sement_mk varchar2(6) -- 
    ,draft_attr varchar2(2) -- 
    ,draft_type varchar2(2) -- 
    ,remit_date varchar2(12) -- 
    ,maturity_date varchar2(12) -- 
    ,remitter_cmonid varchar2(15) -- 
    ,remitter_name varchar2(270) -- 
    ,remitter_account varchar2(60) -- 
    ,remitter_bank_no varchar2(30) -- 
    ,remitter_bank_name varchar2(270) -- 
    ,df_drwr_cdtratgs varchar2(5) -- 
    ,df_drwr_cdtratgsagcy varchar2(270) -- 
    ,df_drwr_cdtratgduedt varchar2(12) -- 
    ,acceptor varchar2(270) -- 
    ,acceptor_bank_no varchar2(30) -- 
    ,acceptor_actno varchar2(60) -- 
    ,acceptor_bank_name varchar2(270) -- 
    ,payee_name varchar2(270) -- 
    ,payee_account varchar2(60) -- 
    ,payee_bank_no varchar2(30) -- 
    ,payee_bank_name varchar2(270) -- 
    ,face_amount number(18,2) -- 
    ,drft_remark varchar2(1152) -- 
    ,drawer_bank_flag varchar2(2) -- 
    ,belong_branch_id number(22) -- 
    ,store_status varchar2(2) -- 
    ,status varchar2(3) -- 
    ,tmp_status varchar2(3) -- 
    ,collztn_status varchar2(3) -- 
    ,misc varchar2(150) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(21) -- 
    ,rebb_front_hander varchar2(120) -- 
    ,rebb_front_hander2 varchar2(120) -- 
    ,rebb_front_hander3 varchar2(120) -- 
    ,is_xz varchar2(2) -- 
    ,xz_info varchar2(768) -- 
    ,cust_oper_nm varchar2(120) -- 
    ,cust_oper_idtyp varchar2(3) -- 
    ,cust_oper_idnum varchar2(45) -- 
    ,cust_oper_com varchar2(120) -- 
    ,cust_oper_date varchar2(12) -- 
    ,ebank_oper_date varchar2(12) -- 
    ,ebank_oper_no varchar2(120) -- 
    ,ebank_oper_name varchar2(150) -- 
    ,owner_cust_id number(22) -- 
    ,credit_cust_no varchar2(30) -- 
    ,is_same_city varchar2(2) -- 
    ,gbba_endorse_com varchar2(120) -- 
    ,cust_account_no varchar2(90) -- 
    ,ref_txn_type varchar2(3) -- 
    ,deposit_limit varchar2(5) -- 
    ,delay_flag varchar2(2) -- 
    ,is_virtual_draft varchar2(2) -- 
    ,is_risk_draft varchar2(2) -- 
    ,risk_reason varchar2(150) -- 
    ,isclear varchar2(2) -- 是否结清，0未结清；1已结清
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
grant select on ${iol_schema}.bdps_draft_info to ${iml_schema};
grant select on ${iol_schema}.bdps_draft_info to ${icl_schema};
grant select on ${iol_schema}.bdps_draft_info to ${idl_schema};
grant select on ${iol_schema}.bdps_draft_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_draft_info is '票据信息表';
comment on column ${iol_schema}.bdps_draft_info.id is '';
comment on column ${iol_schema}.bdps_draft_info.draft_number is '';
comment on column ${iol_schema}.bdps_draft_info.src_type is '';
comment on column ${iol_schema}.bdps_draft_info.end_or_sement_mk is '';
comment on column ${iol_schema}.bdps_draft_info.draft_attr is '';
comment on column ${iol_schema}.bdps_draft_info.draft_type is '';
comment on column ${iol_schema}.bdps_draft_info.remit_date is '';
comment on column ${iol_schema}.bdps_draft_info.maturity_date is '';
comment on column ${iol_schema}.bdps_draft_info.remitter_cmonid is '';
comment on column ${iol_schema}.bdps_draft_info.remitter_name is '';
comment on column ${iol_schema}.bdps_draft_info.remitter_account is '';
comment on column ${iol_schema}.bdps_draft_info.remitter_bank_no is '';
comment on column ${iol_schema}.bdps_draft_info.remitter_bank_name is '';
comment on column ${iol_schema}.bdps_draft_info.df_drwr_cdtratgs is '';
comment on column ${iol_schema}.bdps_draft_info.df_drwr_cdtratgsagcy is '';
comment on column ${iol_schema}.bdps_draft_info.df_drwr_cdtratgduedt is '';
comment on column ${iol_schema}.bdps_draft_info.acceptor is '';
comment on column ${iol_schema}.bdps_draft_info.acceptor_bank_no is '';
comment on column ${iol_schema}.bdps_draft_info.acceptor_actno is '';
comment on column ${iol_schema}.bdps_draft_info.acceptor_bank_name is '';
comment on column ${iol_schema}.bdps_draft_info.payee_name is '';
comment on column ${iol_schema}.bdps_draft_info.payee_account is '';
comment on column ${iol_schema}.bdps_draft_info.payee_bank_no is '';
comment on column ${iol_schema}.bdps_draft_info.payee_bank_name is '';
comment on column ${iol_schema}.bdps_draft_info.face_amount is '';
comment on column ${iol_schema}.bdps_draft_info.drft_remark is '';
comment on column ${iol_schema}.bdps_draft_info.drawer_bank_flag is '';
comment on column ${iol_schema}.bdps_draft_info.belong_branch_id is '';
comment on column ${iol_schema}.bdps_draft_info.store_status is '';
comment on column ${iol_schema}.bdps_draft_info.status is '';
comment on column ${iol_schema}.bdps_draft_info.tmp_status is '';
comment on column ${iol_schema}.bdps_draft_info.collztn_status is '';
comment on column ${iol_schema}.bdps_draft_info.misc is '';
comment on column ${iol_schema}.bdps_draft_info.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_draft_info.last_upd_time is '';
comment on column ${iol_schema}.bdps_draft_info.rebb_front_hander is '';
comment on column ${iol_schema}.bdps_draft_info.rebb_front_hander2 is '';
comment on column ${iol_schema}.bdps_draft_info.rebb_front_hander3 is '';
comment on column ${iol_schema}.bdps_draft_info.is_xz is '';
comment on column ${iol_schema}.bdps_draft_info.xz_info is '';
comment on column ${iol_schema}.bdps_draft_info.cust_oper_nm is '';
comment on column ${iol_schema}.bdps_draft_info.cust_oper_idtyp is '';
comment on column ${iol_schema}.bdps_draft_info.cust_oper_idnum is '';
comment on column ${iol_schema}.bdps_draft_info.cust_oper_com is '';
comment on column ${iol_schema}.bdps_draft_info.cust_oper_date is '';
comment on column ${iol_schema}.bdps_draft_info.ebank_oper_date is '';
comment on column ${iol_schema}.bdps_draft_info.ebank_oper_no is '';
comment on column ${iol_schema}.bdps_draft_info.ebank_oper_name is '';
comment on column ${iol_schema}.bdps_draft_info.owner_cust_id is '';
comment on column ${iol_schema}.bdps_draft_info.credit_cust_no is '';
comment on column ${iol_schema}.bdps_draft_info.is_same_city is '';
comment on column ${iol_schema}.bdps_draft_info.gbba_endorse_com is '';
comment on column ${iol_schema}.bdps_draft_info.cust_account_no is '';
comment on column ${iol_schema}.bdps_draft_info.ref_txn_type is '';
comment on column ${iol_schema}.bdps_draft_info.deposit_limit is '';
comment on column ${iol_schema}.bdps_draft_info.delay_flag is '';
comment on column ${iol_schema}.bdps_draft_info.is_virtual_draft is '';
comment on column ${iol_schema}.bdps_draft_info.is_risk_draft is '';
comment on column ${iol_schema}.bdps_draft_info.risk_reason is '';
comment on column ${iol_schema}.bdps_draft_info.isclear is '是否结清，0未结清；1已结清';
comment on column ${iol_schema}.bdps_draft_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_draft_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_draft_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_draft_info.etl_timestamp is 'ETL处理时间戳';
