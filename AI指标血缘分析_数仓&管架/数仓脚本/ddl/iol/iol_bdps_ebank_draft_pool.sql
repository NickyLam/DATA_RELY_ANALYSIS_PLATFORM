/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_ebank_draft_pool
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_ebank_draft_pool
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_ebank_draft_pool purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_ebank_draft_pool(
    id number(22) -- 
    ,txn_type varchar2(3) -- 
    ,ref_detail_id number(22) -- 
    ,detail_table varchar2(120) -- 
    ,draft_id number(22) -- 
    ,draft_number varchar2(45) -- 
    ,lock_flag varchar2(3) -- 
    ,app_status varchar2(3) -- 
    ,app_date varchar2(12) -- 
    ,check_date varchar2(12) -- 
    ,ebank_seq_no varchar2(75) -- 
    ,cust_org_code varchar2(30) -- 
    ,reason varchar2(384) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(21) -- 
    ,branch_id number(22) -- 
    ,cust_no varchar2(30) -- 
    ,int_tm timestamp -- 
    ,gbba_endorse_com varchar2(120) -- 
    ,cust_oper_no varchar2(45) -- 
    ,cust_oper_nm varchar2(120) -- 
    ,cust_oper_sex varchar2(2) -- 
    ,cust_oper_idtyp varchar2(3) -- 
    ,cust_oper_idnum varchar2(45) -- 
    ,cust_oper_idval varchar2(12) -- 
    ,misc varchar2(768) -- 
    ,chn_flag varchar2(15) -- 
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
grant select on ${iol_schema}.bdps_ebank_draft_pool to ${iml_schema};
grant select on ${iol_schema}.bdps_ebank_draft_pool to ${icl_schema};
grant select on ${iol_schema}.bdps_ebank_draft_pool to ${idl_schema};
grant select on ${iol_schema}.bdps_ebank_draft_pool to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_ebank_draft_pool is '网银任务池表';
comment on column ${iol_schema}.bdps_ebank_draft_pool.id is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.txn_type is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.ref_detail_id is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.detail_table is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.draft_id is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.draft_number is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.lock_flag is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.app_status is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.app_date is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.check_date is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.ebank_seq_no is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.cust_org_code is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.reason is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.last_upd_time is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.branch_id is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.cust_no is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.int_tm is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.gbba_endorse_com is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.cust_oper_no is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.cust_oper_nm is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.cust_oper_sex is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.cust_oper_idtyp is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.cust_oper_idnum is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.cust_oper_idval is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.misc is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.chn_flag is '';
comment on column ${iol_schema}.bdps_ebank_draft_pool.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_ebank_draft_pool.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_ebank_draft_pool.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_ebank_draft_pool.etl_timestamp is 'ETL处理时间戳';
