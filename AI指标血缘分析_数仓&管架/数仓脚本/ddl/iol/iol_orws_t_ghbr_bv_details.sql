/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orws_t_ghbr_bv_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orws_t_ghbr_bv_details
whenever sqlerror continue none;
drop table ${iol_schema}.orws_t_ghbr_bv_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_t_ghbr_bv_details(
    txn_dt timestamp -- 
    ,txn_tm varchar2(45) -- 
    ,parent_org_id varchar2(75) -- 
    ,blng_org_id varchar2(75) -- 
    ,oper_teller_id varchar2(75) -- 
    ,oper_teller_name varchar2(383) -- 
    ,auth_teller_id varchar2(75) -- 
    ,auth_teller_name varchar2(383) -- 
    ,txn_num varchar2(45) -- 
    ,txn_desc varchar2(750) -- 
    ,biz_sys_evt_id varchar2(90) -- 
    ,bcs_evt_id varchar2(90) -- 
    ,data_src_cd varchar2(15) -- 
    ,pay_agt_id varchar2(90) -- 
    ,rcv_agt_id varchar2(90) -- 
    ,txn_amt number(18,2) -- 
    ,menuid varchar2(30) -- 
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
grant select on ${iol_schema}.orws_t_ghbr_bv_details to ${iml_schema};
grant select on ${iol_schema}.orws_t_ghbr_bv_details to ${icl_schema};
grant select on ${iol_schema}.orws_t_ghbr_bv_details to ${idl_schema};
grant select on ${iol_schema}.orws_t_ghbr_bv_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.orws_t_ghbr_bv_details is '业务量明细表';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.txn_dt is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.txn_tm is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.parent_org_id is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.blng_org_id is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.oper_teller_id is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.oper_teller_name is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.auth_teller_id is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.auth_teller_name is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.txn_num is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.txn_desc is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.biz_sys_evt_id is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.bcs_evt_id is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.data_src_cd is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.pay_agt_id is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.rcv_agt_id is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.txn_amt is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.menuid is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.orws_t_ghbr_bv_details.etl_timestamp is 'ETL处理时间戳';
