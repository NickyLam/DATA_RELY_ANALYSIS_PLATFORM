/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_evt_ifs_main_acct_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl
whenever sqlerror continue none;
drop table ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl(
    etl_dt date -- 数据日期   
    ,evt_id varchar2(60) -- 事件编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,tran_flow_id varchar2(60) -- 交易流水编号   
    ,acct_id varchar2(60) -- 账户编号   
    ,dep_sub_acct_id varchar2(60) -- 存款子户编号   
    ,cust_id varchar2(60) -- 客户编号   
    ,ext_prod_id varchar2(100) -- 外部产品编号   
    ,tran_dt date -- 交易日期   
    ,tran_tm varchar2(10) -- 交易时间   
    ,tran_type_cd varchar2(30) -- 交易类型代码   
    ,tran_chn_cd varchar2(10) -- 交易渠道代码   
    ,tran_status_cd varchar2(30) -- 交易状态代码   
    ,tran_org_id varchar2(60) -- 交易机构编号   
    ,call_sys_id varchar2(60) -- 调用系统编号   
    ,ext_flow_id varchar2(60) -- 外部流水编号   
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
grant select on ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl is '联合存款主账户交易明细';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.evt_id is '事件编号';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.lp_id is '法人编号';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.tran_flow_id is '交易流水编号';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.acct_id is '账户编号';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.dep_sub_acct_id is '存款子户编号';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.cust_id is '客户编号';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.ext_prod_id is '外部产品编号';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.tran_dt is '交易日期';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.tran_tm is '交易时间';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.tran_type_cd is '交易类型代码';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.tran_chn_cd is '交易渠道代码';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.tran_status_cd is '交易状态代码';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.tran_org_id is '交易机构编号';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.call_sys_id is '调用系统编号';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.ext_flow_id is '外部流水编号';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.job_cd is '任务代码';
comment on column ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl.etl_timestamp is '数据处理时间';