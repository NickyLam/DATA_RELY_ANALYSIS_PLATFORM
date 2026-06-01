/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fdps_balance_change
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fdps_balance_change_ex purge;
alter table ${iol_schema}.fdps_balance_change add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.fdps_balance_change;

-- 2.3 insert data to ex table
create table ${iol_schema}.fdps_balance_change_ex nologging
compress
as
select * from ${iol_schema}.fdps_balance_change where 0=1;

insert /*+ append */ into ${iol_schema}.fdps_balance_change_ex(
    balance_change_id -- 动账明细表标识
    ,transaction_id -- 交易流水号
    ,order_id -- 订单号
    ,order_time -- 订单时间
    ,parent_merchant_id -- 银行合作商编号
    ,merchant_id -- 银行客户编号
    ,customer_name -- 银行客户名称
    ,account_no -- 主账号
    ,vir_acc_type -- 虚拟账户类型
    ,trans_mode -- 交易模式
    ,tran_status -- 交易状态
    ,old_req_seq_no -- 第三方流水
    ,old_req_account -- 第三方客户标识
    ,org_order_id -- 原订单号
    ,payer_merchant_id -- 付款人银行客户编号
    ,payer_account_no -- 付款人主账号
    ,payer_ac_name -- 付款人银行户名
    ,payer_ac_no -- 付款人银行账号
    ,payer_bank_name -- 付款人开户行名称
    ,payer_bank_no -- 付款人开户行号
    ,other_bank_flag -- 本他行标志
    ,payee_merchant_id -- 收款人银行客户编号
    ,payee_account_no -- 收款人主账号
    ,payee_ac_name -- 收款人银行户名
    ,payee_ac_no -- 收款人银行账号
    ,payee_bank_name -- 收款人开户行名称
    ,load_amount -- 在途金额
    ,guarant_amount -- 担保金额
    ,settle_balance -- 中间结算子账户
    ,payee_bank_no -- 收款人开户行号
    ,pay_type -- 支付方式
    ,retreat_sign -- 退汇退款标志
    ,retreat_seq_no -- 退汇退款原流水号
    ,payer_channel -- 支付通道
    ,payer_tool -- 支付工具类型
    ,fee_amount -- 手续费
    ,amount -- 支付金额
    ,actual_balance -- 实际余额
    ,mobile -- 手机号
    ,validate_code -- 验证码
    ,available_balance -- 可用余额
    ,resp_code -- 响应码
    ,resp_msg -- 响应信息
    ,clear_date -- 银行清算日期
    ,host_seq_no -- 核心流水号
    ,host_date -- 核心日期
    ,third_batch_id -- 第三方批次编号
    ,batch_id -- 银行批次编号
    ,note -- 附言
    ,remark -- 备注
    ,summary -- 摘要
    ,last_updated_stamp -- 最后更新时间
    ,last_updated_tx_stamp -- 最后更新事务时间
    ,created_stamp -- 创建时间
    ,created_tx_stamp -- 创建事务时间
    ,receipt_num -- 电子回单打印次数
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    balance_change_id -- 动账明细表标识
    ,transaction_id -- 交易流水号
    ,order_id -- 订单号
    ,order_time -- 订单时间
    ,parent_merchant_id -- 银行合作商编号
    ,merchant_id -- 银行客户编号
    ,customer_name -- 银行客户名称
    ,account_no -- 主账号
    ,vir_acc_type -- 虚拟账户类型
    ,trans_mode -- 交易模式
    ,tran_status -- 交易状态
    ,old_req_seq_no -- 第三方流水
    ,old_req_account -- 第三方客户标识
    ,org_order_id -- 原订单号
    ,payer_merchant_id -- 付款人银行客户编号
    ,payer_account_no -- 付款人主账号
    ,payer_ac_name -- 付款人银行户名
    ,payer_ac_no -- 付款人银行账号
    ,payer_bank_name -- 付款人开户行名称
    ,payer_bank_no -- 付款人开户行号
    ,other_bank_flag -- 本他行标志
    ,payee_merchant_id -- 收款人银行客户编号
    ,payee_account_no -- 收款人主账号
    ,payee_ac_name -- 收款人银行户名
    ,payee_ac_no -- 收款人银行账号
    ,payee_bank_name -- 收款人开户行名称
    ,load_amount -- 在途金额
    ,guarant_amount -- 担保金额
    ,settle_balance -- 中间结算子账户
    ,payee_bank_no -- 收款人开户行号
    ,pay_type -- 支付方式
    ,retreat_sign -- 退汇退款标志
    ,retreat_seq_no -- 退汇退款原流水号
    ,payer_channel -- 支付通道
    ,payer_tool -- 支付工具类型
    ,fee_amount -- 手续费
    ,amount -- 支付金额
    ,actual_balance -- 实际余额
    ,mobile -- 手机号
    ,validate_code -- 验证码
    ,available_balance -- 可用余额
    ,resp_code -- 响应码
    ,resp_msg -- 响应信息
    ,clear_date -- 银行清算日期
    ,host_seq_no -- 核心流水号
    ,host_date -- 核心日期
    ,third_batch_id -- 第三方批次编号
    ,batch_id -- 银行批次编号
    ,note -- 附言
    ,remark -- 备注
    ,summary -- 摘要
    ,last_updated_stamp -- 最后更新时间
    ,last_updated_tx_stamp -- 最后更新事务时间
    ,created_stamp -- 创建时间
    ,created_tx_stamp -- 创建事务时间
    ,receipt_num -- 电子回单打印次数
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.fdps_balance_change
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.fdps_balance_change exchange partition p_${batch_date} with table ${iol_schema}.fdps_balance_change_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fdps_balance_change to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.fdps_balance_change_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fdps_balance_change',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);