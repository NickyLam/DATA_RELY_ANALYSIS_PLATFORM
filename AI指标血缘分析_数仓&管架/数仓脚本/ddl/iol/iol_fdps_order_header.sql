/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fdps_order_header
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fdps_order_header
whenever sqlerror continue none;
drop table ${iol_schema}.fdps_order_header purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fdps_order_header(
    order_id_pk varchar2(120) -- 订单标识
    ,order_id varchar2(360) -- 订单号
    ,order_time timestamp -- 订单时间
    ,parent_merchant_id varchar2(120) -- 银行合作商编号
    ,merchant_id varchar2(120) -- 银行客户编号
    ,customer_name varchar2(1530) -- 银行客户名称
    ,account_no varchar2(120) -- 主账号
    ,vir_acc_type varchar2(120) -- 虚拟账户类型
    ,tran_type varchar2(120) -- 交易类型
    ,tran_status varchar2(120) -- 交易状态
    ,old_req_seq_no varchar2(120) -- 第三方流水
    ,old_req_account varchar2(120) -- 第三方客户标识
    ,org_order_id varchar2(120) -- 原订单表标识
    ,payer_merchant_id varchar2(120) -- 付款人银行客户编号
    ,payer_account_no varchar2(120) -- 付款人主账号
    ,payer_ac_name varchar2(1530) -- 付款人银行户名
    ,payer_ac_no varchar2(120) -- 付款人银行账号
    ,payer_bank_name varchar2(1530) -- 付款人开户行名称
    ,payer_bank_no varchar2(120) -- 付款人开户行号
    ,payee_merchant_id varchar2(120) -- 收款人银行客户编号
    ,payee_account_no varchar2(120) -- 收款人主账号
    ,payee_ac_name varchar2(1530) -- 收款人银行户名
    ,payee_ac_no varchar2(120) -- 收款人银行账号
    ,payee_bank_name varchar2(1530) -- 收款人开户行名称
    ,payee_bank_no varchar2(120) -- 收款人开户行号
    ,pay_type varchar2(360) -- 支付方式
    ,retreat_sign varchar2(120) -- 是否退汇标志
    ,retreat_seq_no varchar2(120) -- 退汇原流水号
    ,payer_channel varchar2(120) -- 支付通道
    ,payer_tool varchar2(120) -- 支付工具类型
    ,fee_amount number(18,2) -- 手续费
    ,amount number(18,2) -- 支付金额
    ,actual_balance number(18,2) -- 实际余额
    ,available_balance number(18,2) -- 可用余额
    ,mobile varchar2(360) -- 手机号
    ,validate_code varchar2(120) -- 验证码
    ,resp_code varchar2(360) -- 响应码
    ,resp_msg varchar2(1530) -- 响应信息
    ,clear_date varchar2(120) -- 银行清算日期
    ,host_seq_no varchar2(120) -- 核心流水号
    ,host_date varchar2(120) -- 核心日期
    ,ret_reform_cnt number(20) -- 充值结果通知次数
    ,ret_reform_status varchar2(120) -- 充值结果通知状态
    ,ret_reform_time timestamp -- 充值结果通知时间
    ,note varchar2(1530) -- 附言
    ,remark varchar2(1530) -- 备注
    ,summary varchar2(1530) -- 摘要
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,other_bank_flag varchar2(120) -- 本他行标志
    ,batch_id varchar2(120) -- 银行批次编号
    ,third_batch_id varchar2(120) -- 第三方批次编号
    ,guarant_amount number(18,2) -- 担保金额
    ,load_amount number(18,2) -- 在途金额
    ,arrival_amount number(18,2) -- 到账金额
    ,guarant_re_amount number(18,2) -- 担保剩余金额
    ,retreat_sub_seq_no varchar2(360) -- 退汇退款原子流水号
    ,pay_global_seq_no varchar2(360) -- 支付全局流水号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fdps_order_header to ${iml_schema};
grant select on ${iol_schema}.fdps_order_header to ${icl_schema};
grant select on ${iol_schema}.fdps_order_header to ${idl_schema};
grant select on ${iol_schema}.fdps_order_header to ${iel_schema};

-- comment
comment on table ${iol_schema}.fdps_order_header is '';
comment on column ${iol_schema}.fdps_order_header.order_id_pk is '订单标识';
comment on column ${iol_schema}.fdps_order_header.order_id is '订单号';
comment on column ${iol_schema}.fdps_order_header.order_time is '订单时间';
comment on column ${iol_schema}.fdps_order_header.parent_merchant_id is '银行合作商编号';
comment on column ${iol_schema}.fdps_order_header.merchant_id is '银行客户编号';
comment on column ${iol_schema}.fdps_order_header.customer_name is '银行客户名称';
comment on column ${iol_schema}.fdps_order_header.account_no is '主账号';
comment on column ${iol_schema}.fdps_order_header.vir_acc_type is '虚拟账户类型';
comment on column ${iol_schema}.fdps_order_header.tran_type is '交易类型';
comment on column ${iol_schema}.fdps_order_header.tran_status is '交易状态';
comment on column ${iol_schema}.fdps_order_header.old_req_seq_no is '第三方流水';
comment on column ${iol_schema}.fdps_order_header.old_req_account is '第三方客户标识';
comment on column ${iol_schema}.fdps_order_header.org_order_id is '原订单表标识';
comment on column ${iol_schema}.fdps_order_header.payer_merchant_id is '付款人银行客户编号';
comment on column ${iol_schema}.fdps_order_header.payer_account_no is '付款人主账号';
comment on column ${iol_schema}.fdps_order_header.payer_ac_name is '付款人银行户名';
comment on column ${iol_schema}.fdps_order_header.payer_ac_no is '付款人银行账号';
comment on column ${iol_schema}.fdps_order_header.payer_bank_name is '付款人开户行名称';
comment on column ${iol_schema}.fdps_order_header.payer_bank_no is '付款人开户行号';
comment on column ${iol_schema}.fdps_order_header.payee_merchant_id is '收款人银行客户编号';
comment on column ${iol_schema}.fdps_order_header.payee_account_no is '收款人主账号';
comment on column ${iol_schema}.fdps_order_header.payee_ac_name is '收款人银行户名';
comment on column ${iol_schema}.fdps_order_header.payee_ac_no is '收款人银行账号';
comment on column ${iol_schema}.fdps_order_header.payee_bank_name is '收款人开户行名称';
comment on column ${iol_schema}.fdps_order_header.payee_bank_no is '收款人开户行号';
comment on column ${iol_schema}.fdps_order_header.pay_type is '支付方式';
comment on column ${iol_schema}.fdps_order_header.retreat_sign is '是否退汇标志';
comment on column ${iol_schema}.fdps_order_header.retreat_seq_no is '退汇原流水号';
comment on column ${iol_schema}.fdps_order_header.payer_channel is '支付通道';
comment on column ${iol_schema}.fdps_order_header.payer_tool is '支付工具类型';
comment on column ${iol_schema}.fdps_order_header.fee_amount is '手续费';
comment on column ${iol_schema}.fdps_order_header.amount is '支付金额';
comment on column ${iol_schema}.fdps_order_header.actual_balance is '实际余额';
comment on column ${iol_schema}.fdps_order_header.available_balance is '可用余额';
comment on column ${iol_schema}.fdps_order_header.mobile is '手机号';
comment on column ${iol_schema}.fdps_order_header.validate_code is '验证码';
comment on column ${iol_schema}.fdps_order_header.resp_code is '响应码';
comment on column ${iol_schema}.fdps_order_header.resp_msg is '响应信息';
comment on column ${iol_schema}.fdps_order_header.clear_date is '银行清算日期';
comment on column ${iol_schema}.fdps_order_header.host_seq_no is '核心流水号';
comment on column ${iol_schema}.fdps_order_header.host_date is '核心日期';
comment on column ${iol_schema}.fdps_order_header.ret_reform_cnt is '充值结果通知次数';
comment on column ${iol_schema}.fdps_order_header.ret_reform_status is '充值结果通知状态';
comment on column ${iol_schema}.fdps_order_header.ret_reform_time is '充值结果通知时间';
comment on column ${iol_schema}.fdps_order_header.note is '附言';
comment on column ${iol_schema}.fdps_order_header.remark is '备注';
comment on column ${iol_schema}.fdps_order_header.summary is '摘要';
comment on column ${iol_schema}.fdps_order_header.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.fdps_order_header.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.fdps_order_header.created_stamp is '创建时间';
comment on column ${iol_schema}.fdps_order_header.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.fdps_order_header.other_bank_flag is '本他行标志';
comment on column ${iol_schema}.fdps_order_header.batch_id is '银行批次编号';
comment on column ${iol_schema}.fdps_order_header.third_batch_id is '第三方批次编号';
comment on column ${iol_schema}.fdps_order_header.guarant_amount is '担保金额';
comment on column ${iol_schema}.fdps_order_header.load_amount is '在途金额';
comment on column ${iol_schema}.fdps_order_header.arrival_amount is '到账金额';
comment on column ${iol_schema}.fdps_order_header.guarant_re_amount is '担保剩余金额';
comment on column ${iol_schema}.fdps_order_header.retreat_sub_seq_no is '退汇退款原子流水号';
comment on column ${iol_schema}.fdps_order_header.pay_global_seq_no is '支付全局流水号';
comment on column ${iol_schema}.fdps_order_header.start_dt is '开始时间';
comment on column ${iol_schema}.fdps_order_header.end_dt is '结束时间';
comment on column ${iol_schema}.fdps_order_header.id_mark is '增删标志';
comment on column ${iol_schema}.fdps_order_header.etl_timestamp is 'ETL处理时间戳';
