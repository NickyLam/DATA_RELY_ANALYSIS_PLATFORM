/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_storage_contract_xydbk
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_storage_contract_xydbk
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_storage_contract_xydbk purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_storage_contract_xydbk(
    id number(22) -- 
    ,storage_protocol_no varchar2(30) -- 
    ,contract_type varchar2(1) -- 
    ,draft_attr varchar2(1) -- 
    ,draft_type varchar2(1) -- 
    ,branch_id number(22) -- 
    ,operator_id number(22) -- 
    ,app_cust_id number(22) -- 
    ,txn_date varchar2(8) -- 
    ,bail_acct_no varchar2(30) -- 
    ,contract_status varchar2(1) -- 
    ,audit_status varchar2(1) -- 
    ,logic_check_status varchar2(1) -- 
    ,credit_check_status varchar2(1) -- 
    ,manager_id number(22) -- 
    ,depart_id number(22) -- 
    ,appno varchar2(30) -- 
    ,misc varchar2(100) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(14) -- 
    ,branch_id_opt number(22) -- 
    ,ebank_oper_no varchar2(80) -- 
    ,ebank_oper_name varchar2(100) -- 
    ,gbba_cust_oper_nm varchar2(80) -- 
    ,gbba_cust_oper_idtyp varchar2(2) -- 
    ,gbba_cust_oper_idnum varchar2(30) -- 
    ,gbba_cust_oper_com varchar2(80) -- 
    ,gbba_endorse_com varchar2(80) -- 
    ,ref_txn_type varchar2(2) -- 
    ,draft_src_type varchar2(1) -- 
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
grant select on ${iol_schema}.bdps_storage_contract_xydbk to ${iml_schema};
grant select on ${iol_schema}.bdps_storage_contract_xydbk to ${icl_schema};
grant select on ${iol_schema}.bdps_storage_contract_xydbk to ${idl_schema};
grant select on ${iol_schema}.bdps_storage_contract_xydbk to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_storage_contract_xydbk is '代保管批次表';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.id is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.storage_protocol_no is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.contract_type is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.draft_attr is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.draft_type is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.branch_id is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.operator_id is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.app_cust_id is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.txn_date is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.bail_acct_no is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.contract_status is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.audit_status is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.logic_check_status is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.credit_check_status is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.manager_id is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.depart_id is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.appno is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.misc is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.last_upd_time is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.branch_id_opt is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.ebank_oper_no is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.ebank_oper_name is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.gbba_cust_oper_nm is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.gbba_cust_oper_idtyp is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.gbba_cust_oper_idnum is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.gbba_cust_oper_com is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.gbba_endorse_com is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.ref_txn_type is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.draft_src_type is '';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_storage_contract_xydbk.etl_timestamp is 'ETL处理时间戳';
