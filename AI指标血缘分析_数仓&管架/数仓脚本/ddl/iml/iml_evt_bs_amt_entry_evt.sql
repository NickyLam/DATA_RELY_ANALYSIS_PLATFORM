/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bs_amt_entry_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bs_amt_entry_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bs_amt_entry_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bs_amt_entry_evt(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,bs_amt_entry_id varchar2(60) -- 大小额记账编号
    ,sys_cd varchar2(10) -- 系统代码
    ,tran_dt date -- 交易日期
    ,tran_tm varchar2(10) -- 交易时间
    ,bank_int_bus_seq_num varchar2(60) -- 行内业务序号
    ,bus_seq_num varchar2(60) -- 业务序号
    ,msg_type_id varchar2(60) -- 报文类型编号
    ,host_tran_code varchar2(45) -- 主机交易码
    ,midgrod_tran_code varchar2(45) -- 中台交易码
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,teller_id varchar2(60) -- 柜员编号
    ,status_cd varchar2(10) -- 状态代码
    ,host_dt date -- 主机日期
    ,host_flow_num varchar2(100) -- 主机流水号
    ,payer_acct_num varchar2(60) -- 付款人账号
    ,payer_name varchar2(375) -- 付款人名称
    ,recver_acct_num varchar2(60) -- 收款人账号
    ,recver_name varchar2(375) -- 收款人名称
    ,trdpty_idf_id varchar2(60) -- 第三方标识编号
    ,err_return_code varchar2(45) -- 错误返回编码
    ,return_info varchar2(750) -- 返回信息
    ,check_entry_status_cd varchar2(10) -- 对账状态代码
    ,tran_amt number(30,2) -- 交易金额
    ,entry_code varchar2(45) -- 记账分录编码
    ,check_entry_dt date -- 对账日期
    ,e_acct_cd varchar2(10) -- 电子账户代码
    ,req_flow_num varchar2(60) -- 请求流水号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,init_entry_flow_num varchar2(100) -- 原记账流水号
    ,tran_type_cd varchar2(30) -- 交易类型代码
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
grant select on ${iml_schema}.evt_bs_amt_entry_evt to ${icl_schema};
grant select on ${iml_schema}.evt_bs_amt_entry_evt to ${idl_schema};
grant select on ${iml_schema}.evt_bs_amt_entry_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bs_amt_entry_evt is '大小额记账事件';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.bs_amt_entry_id is '大小额记账编号';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.sys_cd is '系统代码';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.bank_int_bus_seq_num is '行内业务序号';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.bus_seq_num is '业务序号';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.msg_type_id is '报文类型编号';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.host_tran_code is '主机交易码';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.midgrod_tran_code is '中台交易码';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.teller_id is '柜员编号';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.status_cd is '状态代码';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.host_dt is '主机日期';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.host_flow_num is '主机流水号';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.payer_acct_num is '付款人账号';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.payer_name is '付款人名称';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.recver_acct_num is '收款人账号';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.recver_name is '收款人名称';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.trdpty_idf_id is '第三方标识编号';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.err_return_code is '错误返回编码';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.return_info is '返回信息';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.check_entry_status_cd is '对账状态代码';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.entry_code is '记账分录编码';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.check_entry_dt is '对账日期';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.e_acct_cd is '电子账户代码';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.req_flow_num is '请求流水号';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.init_entry_flow_num is '原记账流水号';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bs_amt_entry_evt.etl_timestamp is 'ETL处理时间戳';
