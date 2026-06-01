/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_pay_account_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_pay_account_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_pay_account_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_pay_account_info(
    id number(22) -- 
    ,account_no varchar2(29) -- 
    ,txn_type varchar2(2) -- 
    ,branch_no varchar2(9) -- 
    ,txn_date varchar2(12) -- 
    ,seqno varchar2(30) -- 
    ,total_amt number(15,2) -- 
    ,send_bank_no varchar2(18) -- 
    ,pay_account_no varchar2(48) -- 
    ,pay_name varchar2(150) -- 
    ,pay_addr varchar2(150) -- 
    ,rcv_bank_no varchar2(18) -- 
    ,rcv_branch_no varchar2(18) -- 
    ,rcv_account_no varchar2(48) -- 
    ,rcv_name varchar2(150) -- 
    ,rcv_addr varchar2(150) -- 
    ,remark varchar2(150) -- 
    ,account_flag varchar2(2) -- 
    ,account_msg varchar2(11) -- 
    ,status varchar2(2) -- 
    ,last_upd_time varchar2(21) -- 
    ,misc varchar2(384) -- 
    ,draft_number varchar2(45) -- 
    ,draft_id number(22) -- 
    ,virtual_account_no varchar2(29) -- 
    ,tran_no varchar2(24) -- 
    ,op_no varchar2(15) -- 
    ,return_date varchar2(12) -- 
    ,trans_seq varchar2(24) -- 
    ,snd_brn varchar2(21) -- 
    ,entry_no varchar2(30) -- 
    ,acctou varchar2(60) -- 
    ,audit_status varchar2(2) -- 
    ,vostro_account_type varchar2(2) -- 
    ,account_status varchar2(2) -- 
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
grant select on ${iol_schema}.bdps_pay_account_info to ${iml_schema};
grant select on ${iol_schema}.bdps_pay_account_info to ${icl_schema};
grant select on ${iol_schema}.bdps_pay_account_info to ${idl_schema};
grant select on ${iol_schema}.bdps_pay_account_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_pay_account_info is '支付来帐信息表';
comment on column ${iol_schema}.bdps_pay_account_info.id is '';
comment on column ${iol_schema}.bdps_pay_account_info.account_no is '';
comment on column ${iol_schema}.bdps_pay_account_info.txn_type is '';
comment on column ${iol_schema}.bdps_pay_account_info.branch_no is '';
comment on column ${iol_schema}.bdps_pay_account_info.txn_date is '';
comment on column ${iol_schema}.bdps_pay_account_info.seqno is '';
comment on column ${iol_schema}.bdps_pay_account_info.total_amt is '';
comment on column ${iol_schema}.bdps_pay_account_info.send_bank_no is '';
comment on column ${iol_schema}.bdps_pay_account_info.pay_account_no is '';
comment on column ${iol_schema}.bdps_pay_account_info.pay_name is '';
comment on column ${iol_schema}.bdps_pay_account_info.pay_addr is '';
comment on column ${iol_schema}.bdps_pay_account_info.rcv_bank_no is '';
comment on column ${iol_schema}.bdps_pay_account_info.rcv_branch_no is '';
comment on column ${iol_schema}.bdps_pay_account_info.rcv_account_no is '';
comment on column ${iol_schema}.bdps_pay_account_info.rcv_name is '';
comment on column ${iol_schema}.bdps_pay_account_info.rcv_addr is '';
comment on column ${iol_schema}.bdps_pay_account_info.remark is '';
comment on column ${iol_schema}.bdps_pay_account_info.account_flag is '';
comment on column ${iol_schema}.bdps_pay_account_info.account_msg is '';
comment on column ${iol_schema}.bdps_pay_account_info.status is '';
comment on column ${iol_schema}.bdps_pay_account_info.last_upd_time is '';
comment on column ${iol_schema}.bdps_pay_account_info.misc is '';
comment on column ${iol_schema}.bdps_pay_account_info.draft_number is '';
comment on column ${iol_schema}.bdps_pay_account_info.draft_id is '';
comment on column ${iol_schema}.bdps_pay_account_info.virtual_account_no is '';
comment on column ${iol_schema}.bdps_pay_account_info.tran_no is '';
comment on column ${iol_schema}.bdps_pay_account_info.op_no is '';
comment on column ${iol_schema}.bdps_pay_account_info.return_date is '';
comment on column ${iol_schema}.bdps_pay_account_info.trans_seq is '';
comment on column ${iol_schema}.bdps_pay_account_info.snd_brn is '';
comment on column ${iol_schema}.bdps_pay_account_info.entry_no is '';
comment on column ${iol_schema}.bdps_pay_account_info.acctou is '';
comment on column ${iol_schema}.bdps_pay_account_info.audit_status is '';
comment on column ${iol_schema}.bdps_pay_account_info.vostro_account_type is '';
comment on column ${iol_schema}.bdps_pay_account_info.account_status is '';
comment on column ${iol_schema}.bdps_pay_account_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_pay_account_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_pay_account_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_pay_account_info.etl_timestamp is 'ETL处理时间戳';
