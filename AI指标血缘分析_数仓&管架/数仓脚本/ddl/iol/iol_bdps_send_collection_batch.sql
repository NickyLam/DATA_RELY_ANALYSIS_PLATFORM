/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_send_collection_batch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_send_collection_batch
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_send_collection_batch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_send_collection_batch(
    id number(22) -- 
    ,branch_id number(22) -- 
    ,src_type varchar2(2) -- 
    ,draft_attr varchar2(2) -- 
    ,draft_type varchar2(2) -- 
    ,collection_date varchar2(12) -- 
    ,ubank_no varchar2(30) -- 
    ,ems_no varchar2(30) -- 
    ,status varchar2(2) -- 
    ,sttlm_mk varchar2(6) -- 
    ,account_status varchar2(2) -- 
    ,audit_status varchar2(2) -- 
    ,appno varchar2(45) -- 
    ,operator_id number(22) -- 
    ,txn_date varchar2(12) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(21) -- 
    ,branch_id_opt number(22) -- 
    ,ebank_apply varchar2(2) -- 
    ,traceno varchar2(60) -- 
    ,is_collztn varchar2(2) -- 
    ,contract_type varchar2(2) -- 
    ,ubank_address varchar2(150) -- 
    ,ubank_name varchar2(150) -- 
    ,out_storage_no varchar2(30) -- 
    ,ems_from_name varchar2(45) -- 
    ,ems_from_tele_no varchar2(30) -- 
    ,ems_contents varchar2(120) -- 
    ,bail_account_id varchar2(30) -- 回款账户id
    ,cust_id number(22) -- 客户id
    ,recepit_bank_address varchar2(180) -- 
    ,recepit_bank varchar2(120) -- 
    ,bsnssq varchar2(96) -- 全局流水号
    ,transq varchar2(96) -- 业务流水号
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
grant select on ${iol_schema}.bdps_send_collection_batch to ${iml_schema};
grant select on ${iol_schema}.bdps_send_collection_batch to ${icl_schema};
grant select on ${iol_schema}.bdps_send_collection_batch to ${idl_schema};
grant select on ${iol_schema}.bdps_send_collection_batch to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_send_collection_batch is '发出托收批次表';
comment on column ${iol_schema}.bdps_send_collection_batch.id is '';
comment on column ${iol_schema}.bdps_send_collection_batch.branch_id is '';
comment on column ${iol_schema}.bdps_send_collection_batch.src_type is '';
comment on column ${iol_schema}.bdps_send_collection_batch.draft_attr is '';
comment on column ${iol_schema}.bdps_send_collection_batch.draft_type is '';
comment on column ${iol_schema}.bdps_send_collection_batch.collection_date is '';
comment on column ${iol_schema}.bdps_send_collection_batch.ubank_no is '';
comment on column ${iol_schema}.bdps_send_collection_batch.ems_no is '';
comment on column ${iol_schema}.bdps_send_collection_batch.status is '';
comment on column ${iol_schema}.bdps_send_collection_batch.sttlm_mk is '';
comment on column ${iol_schema}.bdps_send_collection_batch.account_status is '';
comment on column ${iol_schema}.bdps_send_collection_batch.audit_status is '';
comment on column ${iol_schema}.bdps_send_collection_batch.appno is '';
comment on column ${iol_schema}.bdps_send_collection_batch.operator_id is '';
comment on column ${iol_schema}.bdps_send_collection_batch.txn_date is '';
comment on column ${iol_schema}.bdps_send_collection_batch.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_send_collection_batch.last_upd_time is '';
comment on column ${iol_schema}.bdps_send_collection_batch.branch_id_opt is '';
comment on column ${iol_schema}.bdps_send_collection_batch.ebank_apply is '';
comment on column ${iol_schema}.bdps_send_collection_batch.traceno is '';
comment on column ${iol_schema}.bdps_send_collection_batch.is_collztn is '';
comment on column ${iol_schema}.bdps_send_collection_batch.contract_type is '';
comment on column ${iol_schema}.bdps_send_collection_batch.ubank_address is '';
comment on column ${iol_schema}.bdps_send_collection_batch.ubank_name is '';
comment on column ${iol_schema}.bdps_send_collection_batch.out_storage_no is '';
comment on column ${iol_schema}.bdps_send_collection_batch.ems_from_name is '';
comment on column ${iol_schema}.bdps_send_collection_batch.ems_from_tele_no is '';
comment on column ${iol_schema}.bdps_send_collection_batch.ems_contents is '';
comment on column ${iol_schema}.bdps_send_collection_batch.bail_account_id is '回款账户id';
comment on column ${iol_schema}.bdps_send_collection_batch.cust_id is '客户id';
comment on column ${iol_schema}.bdps_send_collection_batch.recepit_bank_address is '';
comment on column ${iol_schema}.bdps_send_collection_batch.recepit_bank is '';
comment on column ${iol_schema}.bdps_send_collection_batch.bsnssq is '全局流水号';
comment on column ${iol_schema}.bdps_send_collection_batch.transq is '业务流水号';
comment on column ${iol_schema}.bdps_send_collection_batch.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_send_collection_batch.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_send_collection_batch.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_send_collection_batch.etl_timestamp is 'ETL处理时间戳';
