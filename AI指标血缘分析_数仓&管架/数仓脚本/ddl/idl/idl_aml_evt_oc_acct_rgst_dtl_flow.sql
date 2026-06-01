/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_evt_oc_acct_rgst_dtl_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow
whenever sqlerror continue none;
drop table ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow(
    etl_dt date -- 数据日期   
    ,evt_id varchar2(60) -- 事件编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,oc_acct_dt date -- 开销户日期   
    ,oc_acct_flow varchar2(60) -- 开销户流水   
    ,tran_flow varchar2(60) -- 交易流水   
    ,oc_acct_flg varchar2(10) -- 开销户标志   
    ,acct_clear_opera_flg varchar2(10) -- 冲账作业标志   
    ,opera_org_id varchar2(60) -- 作业机构编号   
    ,acct_org_line_id varchar2(60) -- 账户机构编号   
    ,dep_acct_id varchar2(60) -- 存款账户编号   
    ,dep_sub_acct_id varchar2(60) -- 存款子户编号   
    ,acct_name varchar2(200) -- 账户名称   
    ,curr_cd varchar2(10) -- 币种代码   
    ,ec_flg varchar2(10) -- 钞汇标志   
    ,sav_type_cd varchar2(10) -- 储种代码   
    ,dep_term_cd varchar2(10) -- 存期代码   
    ,open_acct_vouch_cd varchar2(10) -- 开户凭证代码   
    ,open_acct_vouch_no varchar2(60) -- 开户凭证号码   
    ,src_vouch_mgmt_id varchar2(60) -- 源凭证管理编号   
    ,amt number(30,2) -- 金额   
    ,edu_saving_proof_cd varchar2(10) -- 教育储蓄证明代码   
    ,int_amt number(30,2) -- 利息金额   
    ,int_tax_lmt number(30,2) -- 利息税金额   
    ,in_cust_acct_int number(30,2) -- 入客户账利息   
    ,in_trdpty_int number(30,2) -- 入第三方利息   
    ,job_cd varchar2(10) -- 任务代码   
    ,etl_timestamp timestamp -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow is '开销户登记明细流水';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.evt_id is '事件编号';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.lp_id is '法人编号';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.oc_acct_dt is '开销户日期';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.oc_acct_flow is '开销户流水';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.tran_flow is '交易流水';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.oc_acct_flg is '开销户标志';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.acct_clear_opera_flg is '冲账作业标志';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.opera_org_id is '作业机构编号';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.acct_org_line_id is '账户机构编号';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.dep_acct_id is '存款账户编号';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.dep_sub_acct_id is '存款子户编号';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.acct_name is '账户名称';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.curr_cd is '币种代码';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.ec_flg is '钞汇标志';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.sav_type_cd is '储种代码';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.dep_term_cd is '存期代码';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.open_acct_vouch_cd is '开户凭证代码';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.open_acct_vouch_no is '开户凭证号码';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.src_vouch_mgmt_id is '源凭证管理编号';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.amt is '金额';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.edu_saving_proof_cd is '教育储蓄证明代码';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.int_amt is '利息金额';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.int_tax_lmt is '利息税金额';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.in_cust_acct_int is '入客户账利息';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.in_trdpty_int is '入第三方利息';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.job_cd is '任务代码';
comment on column ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow.etl_timestamp is '数据处理时间';