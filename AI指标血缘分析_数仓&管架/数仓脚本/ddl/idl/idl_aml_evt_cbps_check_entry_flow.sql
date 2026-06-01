/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_evt_cbps_check_entry_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_evt_cbps_check_entry_flow
whenever sqlerror continue none;
drop table ${idl_schema}.aml_evt_cbps_check_entry_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_evt_cbps_check_entry_flow(
    etl_dt date -- 数据日期   
    ,evt_id varchar2(250) -- 事件编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,sys_id varchar2(100) -- 系统编号   
    ,midgrod_flow_num varchar2(100) -- 中台流水号   
    ,midgrod_tran_dt date -- 中台交易日期   
    ,midgrod_tran_tm timestamp -- 中台交易时间   
    ,msg_type_id varchar2(100) -- 报文类型编号   
    ,core_tran_code varchar2(60) -- 核心交易码   
    ,midgrod_tran_code varchar2(60) -- 中台交易码   
    ,mgmt_org_id varchar2(100) -- 管理机构编号   
    ,tran_org_id varchar2(100) -- 交易机构编号   
    ,teller_id varchar2(100) -- 柜员编号   
    ,tran_type_cd varchar2(30) -- 交易类型代码   
    ,tran_status_cd varchar2(30) -- 交易状态代码   
    ,core_tran_dt date -- 核心交易日期   
    ,core_tran_flow_num varchar2(100) -- 核心交易流水号   
    ,payer_acct_num varchar2(100) -- 付款人账号   
    ,payer_name varchar2(250) -- 付款人名称   
    ,recver_acct_num varchar2(100) -- 收款人账号   
    ,recver_name varchar2(250) -- 收款人名称   
    ,pay_flow_num varchar2(100) -- 支付流水号   
    ,init_pay_flow_num varchar2(100) -- 原支付流水号   
    ,return_cd varchar2(60) -- 返回代码   
    ,return_info_desc varchar2(500) -- 返回信息描述   
    ,tran_amt number(30,2) -- 交易金额   
    ,entry_code varchar2(30) -- 记账分录编码   
    ,check_entry_dt date -- 对账日期   
    ,check_entry_status_cd varchar2(30) -- 对账状态代码   
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
grant select on ${idl_schema}.aml_evt_cbps_check_entry_flow to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_evt_cbps_check_entry_flow is '城银清算对账流水';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.evt_id is '事件编号';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.lp_id is '法人编号';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.sys_id is '系统编号';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.midgrod_flow_num is '中台流水号';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.midgrod_tran_dt is '中台交易日期';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.midgrod_tran_tm is '中台交易时间';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.msg_type_id is '报文类型编号';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.core_tran_code is '核心交易码';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.midgrod_tran_code is '中台交易码';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.mgmt_org_id is '管理机构编号';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.tran_org_id is '交易机构编号';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.teller_id is '柜员编号';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.tran_type_cd is '交易类型代码';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.tran_status_cd is '交易状态代码';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.core_tran_dt is '核心交易日期';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.core_tran_flow_num is '核心交易流水号';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.payer_acct_num is '付款人账号';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.payer_name is '付款人名称';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.recver_acct_num is '收款人账号';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.recver_name is '收款人名称';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.pay_flow_num is '支付流水号';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.init_pay_flow_num is '原支付流水号';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.return_cd is '返回代码';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.return_info_desc is '返回信息描述';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.tran_amt is '交易金额';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.entry_code is '记账分录编码';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.check_entry_dt is '对账日期';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.check_entry_status_cd is '对账状态代码';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.job_cd is '任务代码';
comment on column ${idl_schema}.aml_evt_cbps_check_entry_flow.etl_timestamp is '数据处理时间';