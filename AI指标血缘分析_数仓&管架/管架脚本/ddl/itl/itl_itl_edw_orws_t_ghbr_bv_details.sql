/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_orws_t_ghbr_bv_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_orws_t_ghbr_bv_details
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_orws_t_ghbr_bv_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_orws_t_ghbr_bv_details(
    txn_dt timestamp -- 
    ,txn_tm varchar2(30) -- 
    ,parent_org_id varchar2(50) -- 
    ,blng_org_id varchar2(50) -- 
    ,oper_teller_id varchar2(50) -- 
    ,oper_teller_name varchar2(255) -- 
    ,auth_teller_id varchar2(50) -- 
    ,auth_teller_name varchar2(255) -- 
    ,txn_num varchar2(30) -- 
    ,txn_desc varchar2(500) -- 
    ,biz_sys_evt_id varchar2(60) -- 
    ,bcs_evt_id varchar2(60) -- 
    ,data_src_cd varchar2(4) -- 
    ,pay_agt_id varchar2(60) -- 
    ,rcv_agt_id varchar2(60) -- 
    ,txn_amt number(18,2) -- 
    ,menuid varchar2(10) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_orws_t_ghbr_bv_details to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_orws_t_ghbr_bv_details is '业务量明细表';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.txn_dt is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.txn_tm is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.parent_org_id is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.blng_org_id is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.oper_teller_id is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.oper_teller_name is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.auth_teller_id is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.auth_teller_name is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.txn_num is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.txn_desc is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.biz_sys_evt_id is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.bcs_evt_id is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.data_src_cd is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.pay_agt_id is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.rcv_agt_id is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.txn_amt is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.menuid is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_details.etl_timestamp is 'ETL处理时间戳';