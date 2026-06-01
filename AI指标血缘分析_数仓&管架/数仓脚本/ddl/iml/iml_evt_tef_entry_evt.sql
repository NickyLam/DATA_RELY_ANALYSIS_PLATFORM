/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_tef_entry_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_tef_entry_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_tef_entry_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tef_entry_evt(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,midgrod_flow_num varchar2(60) -- 中台流水号
    ,tran_dt date -- 交易日期
    ,sys_cd varchar2(10) -- 系统代码
    ,tran_tm varchar2(10) -- 交易时间
    ,front_flow_num varchar2(60) -- 前置流水号
    ,front_dt date -- 前置日期
    ,host_tran_code varchar2(150) -- 主机交易码
    ,midgrod_tran_code varchar2(45) -- 中台交易码
    ,proc_org_id varchar2(60) -- 处理机构编号
    ,proc_teller_id varchar2(60) -- 处理柜员编号
    ,status_cd varchar2(10) -- 状态代码
    ,host_dt date -- 主机日期
    ,host_flow_num varchar2(100) -- 主机流水号
    ,pay_acct varchar2(90) -- 付款账户
    ,pay_acct_name varchar2(375) -- 付款账户名称
    ,recvbl_acct varchar2(90) -- 收款账户
    ,recvbl_acct_name varchar2(375) -- 收款账户名称
    ,tran_index_num varchar2(60) -- 交易索引号
    ,err_return_code varchar2(45) -- 错误返回编码
    ,err_info varchar2(750) -- 错误信息
    ,check_entry_status_cd varchar2(10) -- 对账状态代码
    ,tran_amt number(30,2) -- 交易金额
    ,acct_ety_code varchar2(45) -- 会计分录编码
    ,check_entry_dt date -- 对账日期
    ,e_acct_cd varchar2(10) -- 电子账户代码
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,chn_code varchar2(150) -- 渠道编码
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_tef_entry_evt to ${icl_schema};
grant select on ${iml_schema}.evt_tef_entry_evt to ${idl_schema};
grant select on ${iml_schema}.evt_tef_entry_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_tef_entry_evt is '省金服记账事件';
comment on column ${iml_schema}.evt_tef_entry_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_tef_entry_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_tef_entry_evt.midgrod_flow_num is '中台流水号';
comment on column ${iml_schema}.evt_tef_entry_evt.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_tef_entry_evt.sys_cd is '系统代码';
comment on column ${iml_schema}.evt_tef_entry_evt.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_tef_entry_evt.front_flow_num is '前置流水号';
comment on column ${iml_schema}.evt_tef_entry_evt.front_dt is '前置日期';
comment on column ${iml_schema}.evt_tef_entry_evt.host_tran_code is '主机交易码';
comment on column ${iml_schema}.evt_tef_entry_evt.midgrod_tran_code is '中台交易码';
comment on column ${iml_schema}.evt_tef_entry_evt.proc_org_id is '处理机构编号';
comment on column ${iml_schema}.evt_tef_entry_evt.proc_teller_id is '处理柜员编号';
comment on column ${iml_schema}.evt_tef_entry_evt.status_cd is '状态代码';
comment on column ${iml_schema}.evt_tef_entry_evt.host_dt is '主机日期';
comment on column ${iml_schema}.evt_tef_entry_evt.host_flow_num is '主机流水号';
comment on column ${iml_schema}.evt_tef_entry_evt.pay_acct is '付款账户';
comment on column ${iml_schema}.evt_tef_entry_evt.pay_acct_name is '付款账户名称';
comment on column ${iml_schema}.evt_tef_entry_evt.recvbl_acct is '收款账户';
comment on column ${iml_schema}.evt_tef_entry_evt.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.evt_tef_entry_evt.tran_index_num is '交易索引号';
comment on column ${iml_schema}.evt_tef_entry_evt.err_return_code is '错误返回编码';
comment on column ${iml_schema}.evt_tef_entry_evt.err_info is '错误信息';
comment on column ${iml_schema}.evt_tef_entry_evt.check_entry_status_cd is '对账状态代码';
comment on column ${iml_schema}.evt_tef_entry_evt.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_tef_entry_evt.acct_ety_code is '会计分录编码';
comment on column ${iml_schema}.evt_tef_entry_evt.check_entry_dt is '对账日期';
comment on column ${iml_schema}.evt_tef_entry_evt.e_acct_cd is '电子账户代码';
comment on column ${iml_schema}.evt_tef_entry_evt.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_tef_entry_evt.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_tef_entry_evt.chn_code is '渠道编码';
comment on column ${iml_schema}.evt_tef_entry_evt.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_tef_entry_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_tef_entry_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_tef_entry_evt.etl_timestamp is 'ETL处理时间戳';
