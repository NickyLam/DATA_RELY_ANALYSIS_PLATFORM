/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_cap_supv_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_cap_supv_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_cap_supv_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cap_supv_tran_flow(
   evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_flow_num varchar2(500) -- 交易流水号
    ,tran_tm timestamp -- 交易时间
    ,coprator_id varchar2(250) -- 合作商编号
    ,intnal_cust_id varchar2(250) -- 内部客户编号
    ,intnal_cust_name varchar2(2000) -- 内部客户名称
    ,vtual_acct_id varchar2(250) -- 虚拟账户编号
    ,vtual_acct_type_cd varchar2(500) -- 虚拟账户类型代码
    ,tran_code varchar2(250) -- 交易码
    ,tran_status_cd varchar2(500) -- 交易状态代码
    ,trdpty_flow_num varchar2(250) -- 第三方流水号
    ,init_tran_flow_num varchar2(250) -- 原交易流水号
    ,payer_intnal_cust_id varchar2(250) -- 付款人内部客户编号
    ,payer_vtual_acct_id varchar2(250) -- 付款人虚拟账户编号
    ,payer_bank_acct_name varchar2(2000) -- 付款人银行账户名称
    ,payer_bank_acct_id varchar2(250) -- 付款人银行账户编号
    ,payer_open_bank_name varchar2(2000) -- 付款人开户银行名称
    ,payer_open_bank_id varchar2(250) -- 付款人开户银行编号
    ,payer_open_ghb_flg varchar2(250) -- 付款人开户银行本行标志
    ,recver_intnal_cust_id varchar2(250) -- 收款人内部客户编号
    ,recver_vtual_acct_id varchar2(250) -- 收款人虚拟账户编号
    ,guar_amt number(30,2) -- 担保金额
    ,guar_surp_amt number(30,2) -- 担保剩余金额
    ,avl_amt number(30,2) -- 到账金额
    ,recver_bank_acct_name varchar2(2000) -- 收款人银行账户名称
    ,recver_bank_acct_id varchar2(250) -- 收款人银行账户编号
    ,recver_open_bank_name varchar2(2000) -- 收款人开户银行名称
    ,recver_open_bank_id varchar2(250) -- 收款人开户银行编号
    ,mode_pay varchar2(500) -- 支付方式
    ,refund_idf_cd varchar2(500) -- 退汇退款标识代码
    ,refund_src_flow_num varchar2(250) -- 退汇退款源流水号
    ,refund_src_sub_flow_num varchar2(500) -- 退汇退款源子流水号
    ,comm_fee number(30,2) -- 手续费
    ,pay_amt number(30,2) -- 支付金额
    ,actl_bal number(30,2) -- 实际余额
    ,aval_bal number(30,2) -- 可用余额
    ,mobile_no varchar2(500) -- 手机号
    ,check_code varchar2(250) -- 验证码
    ,return_code varchar2(500) -- 返回码
    ,return_info varchar2(2000) -- 返回信息
    ,clear_dt date -- 清算日期
    ,core_tran_flow_num varchar2(250) -- 核心交易流水号
    ,core_tran_dt date -- 核心交易日期
    ,recge_rest_advise_cnt number(30,2) -- 充值结果通知次数
    ,recge_rest_advise_status_cd varchar2(500) -- 充值结果通知状态代码
    ,recge_rest_advise_tm timestamp -- 充值结果通知时间
    ,bank_batch_id varchar2(250) -- 银行批次编号
    ,trdpty_batch_id varchar2(250) -- 第三方批次编号
    ,memo varchar2(2000) -- 摘要
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_cap_supv_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_cap_supv_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_cap_supv_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_cap_supv_tran_flow is '资金监管交易流水';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.coprator_id is '合作商编号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.intnal_cust_id is '内部客户编号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.intnal_cust_name is '内部客户名称';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.vtual_acct_id is '虚拟账户编号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.vtual_acct_type_cd is '虚拟账户类型代码';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.trdpty_flow_num is '第三方流水号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.init_tran_flow_num is '原交易流水号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.payer_intnal_cust_id is '付款人内部客户编号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.payer_vtual_acct_id is '付款人虚拟账户编号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.payer_bank_acct_name is '付款人银行账户名称';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.payer_bank_acct_id is '付款人银行账户编号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.payer_open_bank_name is '付款人开户银行名称';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.payer_open_bank_id is '付款人开户银行编号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.payer_open_ghb_flg is '付款人开户银行本行标志';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.recver_intnal_cust_id is '收款人内部客户编号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.recver_vtual_acct_id is '收款人虚拟账户编号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.guar_amt is '担保金额';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.guar_surp_amt is '担保剩余金额';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.avl_amt is '到账金额';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.recver_bank_acct_name is '收款人银行账户名称';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.recver_bank_acct_id is '收款人银行账户编号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.recver_open_bank_name is '收款人开户银行名称';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.recver_open_bank_id is '收款人开户银行编号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.mode_pay is '支付方式';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.refund_idf_cd is '退汇退款标识代码';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.refund_src_flow_num is '退汇退款源流水号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.refund_src_sub_flow_num is '退汇退款源子流水号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.comm_fee is '手续费';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.pay_amt is '支付金额';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.actl_bal is '实际余额';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.aval_bal is '可用余额';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.mobile_no is '手机号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.check_code is '验证码';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.return_code is '返回码';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.return_info is '返回信息';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.core_tran_flow_num is '核心交易流水号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.core_tran_dt is '核心交易日期';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.recge_rest_advise_cnt is '充值结果通知次数';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.recge_rest_advise_status_cd is '充值结果通知状态代码';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.recge_rest_advise_tm is '充值结果通知时间';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.bank_batch_id is '银行批次编号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.trdpty_batch_id is '第三方批次编号';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.memo is '摘要';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.start_dt is '开始时间';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.end_dt is '结束时间';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.id_mark is '增删标志';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_cap_supv_tran_flow.etl_timestamp is 'ETL处理时间戳';
