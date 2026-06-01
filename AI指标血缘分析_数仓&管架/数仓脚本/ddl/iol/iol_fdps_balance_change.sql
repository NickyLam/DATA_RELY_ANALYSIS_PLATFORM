/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fdps_balance_change
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fdps_balance_change
whenever sqlerror continue none;
drop table ${iol_schema}.fdps_balance_change purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fdps_balance_change(
    balance_change_id varchar2(60) -- 动账明细表标识
    ,transaction_id varchar2(60) -- 交易流水号
    ,order_id varchar2(180) -- 订单号
    ,order_time timestamp -- 订单时间
    ,parent_merchant_id varchar2(60) -- 银行合作商编号
    ,merchant_id varchar2(60) -- 银行客户编号
    ,customer_name varchar2(765) -- 银行客户名称
    ,account_no varchar2(60) -- 主账号
    ,vir_acc_type varchar2(60) -- 虚拟账户类型
    ,trans_mode varchar2(60) -- 交易模式
    ,tran_status varchar2(60) -- 交易状态
    ,old_req_seq_no varchar2(60) -- 第三方流水
    ,old_req_account varchar2(60) -- 第三方客户标识
    ,org_order_id varchar2(60) -- 原订单号
    ,payer_merchant_id varchar2(60) -- 付款人银行客户编号
    ,payer_account_no varchar2(60) -- 付款人主账号
    ,payer_ac_name varchar2(765) -- 付款人银行户名
    ,payer_ac_no varchar2(60) -- 付款人银行账号
    ,payer_bank_name varchar2(765) -- 付款人开户行名称
    ,payer_bank_no varchar2(60) -- 付款人开户行号
    ,other_bank_flag varchar2(60) -- 本他行标志
    ,payee_merchant_id varchar2(60) -- 收款人银行客户编号
    ,payee_account_no varchar2(60) -- 收款人主账号
    ,payee_ac_name varchar2(765) -- 收款人银行户名
    ,payee_ac_no varchar2(60) -- 收款人银行账号
    ,payee_bank_name varchar2(765) -- 收款人开户行名称
    ,load_amount number(18,2) -- 在途金额
    ,guarant_amount number(18,2) -- 担保金额
    ,settle_balance varchar2(32) -- 中间结算子账户
    ,payee_bank_no varchar2(60) -- 收款人开户行号
    ,pay_type varchar2(180) -- 支付方式
    ,retreat_sign varchar2(60) -- 退汇退款标志
    ,retreat_seq_no varchar2(60) -- 退汇退款原流水号
    ,payer_channel varchar2(60) -- 支付通道
    ,payer_tool varchar2(60) -- 支付工具类型
    ,fee_amount number(18,2) -- 手续费
    ,amount number(18,2) -- 支付金额
    ,actual_balance number(18,2) -- 实际余额
    ,mobile varchar2(180) -- 手机号
    ,validate_code varchar2(60) -- 验证码
    ,available_balance number(18,2) -- 可用余额
    ,resp_code varchar2(60) -- 响应码
    ,resp_msg varchar2(765) -- 响应信息
    ,clear_date varchar2(60) -- 银行清算日期
    ,host_seq_no varchar2(60) -- 核心流水号
    ,host_date varchar2(60) -- 核心日期
    ,third_batch_id varchar2(60) -- 第三方批次编号
    ,batch_id varchar2(60) -- 银行批次编号
    ,note varchar2(765) -- 附言
    ,remark varchar2(765) -- 备注
    ,summary varchar2(765) -- 摘要
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,receipt_num varchar2(40) -- 电子回单打印次数
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
grant select on ${iol_schema}.fdps_balance_change to ${iml_schema};
grant select on ${iol_schema}.fdps_balance_change to ${icl_schema};
grant select on ${iol_schema}.fdps_balance_change to ${idl_schema};
grant select on ${iol_schema}.fdps_balance_change to ${iel_schema};

-- comment
comment on table ${iol_schema}.fdps_balance_change is '动账明细表';
comment on column ${iol_schema}.fdps_balance_change.balance_change_id is '动账明细表标识';
comment on column ${iol_schema}.fdps_balance_change.transaction_id is '交易流水号';
comment on column ${iol_schema}.fdps_balance_change.order_id is '订单号';
comment on column ${iol_schema}.fdps_balance_change.order_time is '订单时间';
comment on column ${iol_schema}.fdps_balance_change.parent_merchant_id is '银行合作商编号';
comment on column ${iol_schema}.fdps_balance_change.merchant_id is '银行客户编号';
comment on column ${iol_schema}.fdps_balance_change.customer_name is '银行客户名称';
comment on column ${iol_schema}.fdps_balance_change.account_no is '主账号';
comment on column ${iol_schema}.fdps_balance_change.vir_acc_type is '虚拟账户类型';
comment on column ${iol_schema}.fdps_balance_change.trans_mode is '交易模式';
comment on column ${iol_schema}.fdps_balance_change.tran_status is '交易状态';
comment on column ${iol_schema}.fdps_balance_change.old_req_seq_no is '第三方流水';
comment on column ${iol_schema}.fdps_balance_change.old_req_account is '第三方客户标识';
comment on column ${iol_schema}.fdps_balance_change.org_order_id is '原订单号';
comment on column ${iol_schema}.fdps_balance_change.payer_merchant_id is '付款人银行客户编号';
comment on column ${iol_schema}.fdps_balance_change.payer_account_no is '付款人主账号';
comment on column ${iol_schema}.fdps_balance_change.payer_ac_name is '付款人银行户名';
comment on column ${iol_schema}.fdps_balance_change.payer_ac_no is '付款人银行账号';
comment on column ${iol_schema}.fdps_balance_change.payer_bank_name is '付款人开户行名称';
comment on column ${iol_schema}.fdps_balance_change.payer_bank_no is '付款人开户行号';
comment on column ${iol_schema}.fdps_balance_change.other_bank_flag is '本他行标志';
comment on column ${iol_schema}.fdps_balance_change.payee_merchant_id is '收款人银行客户编号';
comment on column ${iol_schema}.fdps_balance_change.payee_account_no is '收款人主账号';
comment on column ${iol_schema}.fdps_balance_change.payee_ac_name is '收款人银行户名';
comment on column ${iol_schema}.fdps_balance_change.payee_ac_no is '收款人银行账号';
comment on column ${iol_schema}.fdps_balance_change.payee_bank_name is '收款人开户行名称';
comment on column ${iol_schema}.fdps_balance_change.load_amount is '在途金额';
comment on column ${iol_schema}.fdps_balance_change.guarant_amount is '担保金额';
comment on column ${iol_schema}.fdps_balance_change.settle_balance is '中间结算子账户';
comment on column ${iol_schema}.fdps_balance_change.payee_bank_no is '收款人开户行号';
comment on column ${iol_schema}.fdps_balance_change.pay_type is '支付方式';
comment on column ${iol_schema}.fdps_balance_change.retreat_sign is '退汇退款标志';
comment on column ${iol_schema}.fdps_balance_change.retreat_seq_no is '退汇退款原流水号';
comment on column ${iol_schema}.fdps_balance_change.payer_channel is '支付通道';
comment on column ${iol_schema}.fdps_balance_change.payer_tool is '支付工具类型';
comment on column ${iol_schema}.fdps_balance_change.fee_amount is '手续费';
comment on column ${iol_schema}.fdps_balance_change.amount is '支付金额';
comment on column ${iol_schema}.fdps_balance_change.actual_balance is '实际余额';
comment on column ${iol_schema}.fdps_balance_change.mobile is '手机号';
comment on column ${iol_schema}.fdps_balance_change.validate_code is '验证码';
comment on column ${iol_schema}.fdps_balance_change.available_balance is '可用余额';
comment on column ${iol_schema}.fdps_balance_change.resp_code is '响应码';
comment on column ${iol_schema}.fdps_balance_change.resp_msg is '响应信息';
comment on column ${iol_schema}.fdps_balance_change.clear_date is '银行清算日期';
comment on column ${iol_schema}.fdps_balance_change.host_seq_no is '核心流水号';
comment on column ${iol_schema}.fdps_balance_change.host_date is '核心日期';
comment on column ${iol_schema}.fdps_balance_change.third_batch_id is '第三方批次编号';
comment on column ${iol_schema}.fdps_balance_change.batch_id is '银行批次编号';
comment on column ${iol_schema}.fdps_balance_change.note is '附言';
comment on column ${iol_schema}.fdps_balance_change.remark is '备注';
comment on column ${iol_schema}.fdps_balance_change.summary is '摘要';
comment on column ${iol_schema}.fdps_balance_change.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.fdps_balance_change.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.fdps_balance_change.created_stamp is '创建时间';
comment on column ${iol_schema}.fdps_balance_change.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.fdps_balance_change.receipt_num is '电子回单打印次数';
comment on column ${iol_schema}.fdps_balance_change.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.fdps_balance_change.etl_timestamp is 'ETL处理时间戳';
