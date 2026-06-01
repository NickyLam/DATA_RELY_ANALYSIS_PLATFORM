/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0nds_accounting_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0nds_accounting_flow
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0nds_accounting_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0nds_accounting_flow(
    org varchar2(18) -- 
    ,cps_txn_seq varchar2(54) -- 
    ,card_no varchar2(29) -- 
    ,curr_cd varchar2(5) -- 
    ,txn_code varchar2(6) -- 
    ,txn_desc varchar2(120) -- 
    ,db_cr_ind varchar2(2) -- 
    ,post_amt number(15,2) -- 
    ,post_gl_ind varchar2(2) -- 
    ,owning_branch varchar2(14) -- 
    ,subject varchar2(60) -- 
    ,red_flag varchar2(2) -- 
    ,queue number(20,0) -- 
    ,product_cd varchar2(9) -- 
    ,ref_nbr varchar2(35) -- 
    ,age_group varchar2(2) -- 
    ,plan_nbr varchar2(9) -- 
    ,bnp_group varchar2(3) -- 
    ,bank_group_id varchar2(8) -- 
    ,bank_no varchar2(15) -- 
    ,term number(22) -- 
    ,batchdate date -- 
    ,batchfilename varchar2(90) -- 
    ,seqno varchar2(30) -- 
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
grant select on ${iol_schema}.mpcs_a0nds_accounting_flow to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0nds_accounting_flow to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0nds_accounting_flow to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0nds_accounting_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0nds_accounting_flow is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.org is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.cps_txn_seq is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.card_no is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.curr_cd is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.txn_code is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.txn_desc is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.db_cr_ind is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.post_amt is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.post_gl_ind is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.owning_branch is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.subject is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.red_flag is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.queue is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.product_cd is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.ref_nbr is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.age_group is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.plan_nbr is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.bnp_group is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.bank_group_id is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.bank_no is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.term is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.batchdate is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.batchfilename is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.seqno is '';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a0nds_accounting_flow.etl_timestamp is 'ETL处理时间戳';
