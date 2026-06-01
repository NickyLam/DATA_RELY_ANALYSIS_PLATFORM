/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_storage_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_storage_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_storage_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_storage_contract(
    id number(22) -- 
    ,storage_protocol_no varchar2(45) -- 
    ,contract_type varchar2(2) -- 
    ,draft_attr varchar2(2) -- 
    ,draft_type varchar2(2) -- 
    ,branch_id number(22) -- 
    ,operator_id number(22) -- 
    ,app_cust_id number(22) -- 
    ,txn_date varchar2(12) -- 
    ,bail_acct_no varchar2(45) -- 
    ,contract_status varchar2(2) -- 
    ,audit_status varchar2(2) -- 
    ,logic_check_status varchar2(2) -- 
    ,credit_check_status varchar2(2) -- 
    ,manager_id number(22) -- 
    ,depart_id number(22) -- 
    ,appno varchar2(45) -- 
    ,misc varchar2(150) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(21) -- 
    ,branch_id_opt number(22) -- 
    ,ebank_oper_no varchar2(120) -- 
    ,ebank_oper_name varchar2(150) -- 
    ,gbba_cust_oper_nm varchar2(120) -- 
    ,gbba_cust_oper_idtyp varchar2(3) -- 
    ,gbba_cust_oper_idnum varchar2(45) -- 
    ,gbba_cust_oper_com varchar2(120) -- 
    ,gbba_endorse_com varchar2(120) -- 
    ,ref_txn_type varchar2(3) -- 
    ,draft_src_type varchar2(2) -- 
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
grant select on ${iol_schema}.bdps_storage_contract to ${iml_schema};
grant select on ${iol_schema}.bdps_storage_contract to ${icl_schema};
grant select on ${iol_schema}.bdps_storage_contract to ${idl_schema};
grant select on ${iol_schema}.bdps_storage_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_storage_contract is '代保管批次表';
comment on column ${iol_schema}.bdps_storage_contract.id is '';
comment on column ${iol_schema}.bdps_storage_contract.storage_protocol_no is '';
comment on column ${iol_schema}.bdps_storage_contract.contract_type is '';
comment on column ${iol_schema}.bdps_storage_contract.draft_attr is '';
comment on column ${iol_schema}.bdps_storage_contract.draft_type is '';
comment on column ${iol_schema}.bdps_storage_contract.branch_id is '';
comment on column ${iol_schema}.bdps_storage_contract.operator_id is '';
comment on column ${iol_schema}.bdps_storage_contract.app_cust_id is '';
comment on column ${iol_schema}.bdps_storage_contract.txn_date is '';
comment on column ${iol_schema}.bdps_storage_contract.bail_acct_no is '';
comment on column ${iol_schema}.bdps_storage_contract.contract_status is '';
comment on column ${iol_schema}.bdps_storage_contract.audit_status is '';
comment on column ${iol_schema}.bdps_storage_contract.logic_check_status is '';
comment on column ${iol_schema}.bdps_storage_contract.credit_check_status is '';
comment on column ${iol_schema}.bdps_storage_contract.manager_id is '';
comment on column ${iol_schema}.bdps_storage_contract.depart_id is '';
comment on column ${iol_schema}.bdps_storage_contract.appno is '';
comment on column ${iol_schema}.bdps_storage_contract.misc is '';
comment on column ${iol_schema}.bdps_storage_contract.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_storage_contract.last_upd_time is '';
comment on column ${iol_schema}.bdps_storage_contract.branch_id_opt is '';
comment on column ${iol_schema}.bdps_storage_contract.ebank_oper_no is '';
comment on column ${iol_schema}.bdps_storage_contract.ebank_oper_name is '';
comment on column ${iol_schema}.bdps_storage_contract.gbba_cust_oper_nm is '';
comment on column ${iol_schema}.bdps_storage_contract.gbba_cust_oper_idtyp is '';
comment on column ${iol_schema}.bdps_storage_contract.gbba_cust_oper_idnum is '';
comment on column ${iol_schema}.bdps_storage_contract.gbba_cust_oper_com is '';
comment on column ${iol_schema}.bdps_storage_contract.gbba_endorse_com is '';
comment on column ${iol_schema}.bdps_storage_contract.ref_txn_type is '';
comment on column ${iol_schema}.bdps_storage_contract.draft_src_type is '';
comment on column ${iol_schema}.bdps_storage_contract.bsnssq is '全局流水号';
comment on column ${iol_schema}.bdps_storage_contract.transq is '业务流水号';
comment on column ${iol_schema}.bdps_storage_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_storage_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_storage_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_storage_contract.etl_timestamp is 'ETL处理时间戳';
