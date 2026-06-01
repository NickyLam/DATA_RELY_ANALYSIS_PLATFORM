/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fdps_order_header
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.fdps_order_header_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fdps_order_header;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fdps_order_header_op purge;
drop table ${iol_schema}.fdps_order_header_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fdps_order_header_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fdps_order_header where 0=1;

create table ${iol_schema}.fdps_order_header_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fdps_order_header where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fdps_order_header_cl(
            order_id_pk -- 订单标识
            ,order_id -- 订单号
            ,order_time -- 订单时间
            ,parent_merchant_id -- 银行合作商编号
            ,merchant_id -- 银行客户编号
            ,customer_name -- 银行客户名称
            ,account_no -- 主账号
            ,vir_acc_type -- 虚拟账户类型
            ,tran_type -- 交易类型
            ,tran_status -- 交易状态
            ,old_req_seq_no -- 第三方流水
            ,old_req_account -- 第三方客户标识
            ,org_order_id -- 原订单表标识
            ,payer_merchant_id -- 付款人银行客户编号
            ,payer_account_no -- 付款人主账号
            ,payer_ac_name -- 付款人银行户名
            ,payer_ac_no -- 付款人银行账号
            ,payer_bank_name -- 付款人开户行名称
            ,payer_bank_no -- 付款人开户行号
            ,payee_merchant_id -- 收款人银行客户编号
            ,payee_account_no -- 收款人主账号
            ,payee_ac_name -- 收款人银行户名
            ,payee_ac_no -- 收款人银行账号
            ,payee_bank_name -- 收款人开户行名称
            ,payee_bank_no -- 收款人开户行号
            ,pay_type -- 支付方式
            ,retreat_sign -- 是否退汇标志
            ,retreat_seq_no -- 退汇原流水号
            ,payer_channel -- 支付通道
            ,payer_tool -- 支付工具类型
            ,fee_amount -- 手续费
            ,amount -- 支付金额
            ,actual_balance -- 实际余额
            ,available_balance -- 可用余额
            ,mobile -- 手机号
            ,validate_code -- 验证码
            ,resp_code -- 响应码
            ,resp_msg -- 响应信息
            ,clear_date -- 银行清算日期
            ,host_seq_no -- 核心流水号
            ,host_date -- 核心日期
            ,ret_reform_cnt -- 充值结果通知次数
            ,ret_reform_status -- 充值结果通知状态
            ,ret_reform_time -- 充值结果通知时间
            ,note -- 附言
            ,remark -- 备注
            ,summary -- 摘要
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,other_bank_flag -- 本他行标志
            ,batch_id -- 银行批次编号
            ,third_batch_id -- 第三方批次编号
            ,guarant_amount -- 担保金额
            ,load_amount -- 在途金额
            ,arrival_amount -- 到账金额
            ,guarant_re_amount -- 担保剩余金额
            ,retreat_sub_seq_no -- 退汇退款原子流水号
            ,pay_global_seq_no -- 支付全局流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fdps_order_header_op(
            order_id_pk -- 订单标识
            ,order_id -- 订单号
            ,order_time -- 订单时间
            ,parent_merchant_id -- 银行合作商编号
            ,merchant_id -- 银行客户编号
            ,customer_name -- 银行客户名称
            ,account_no -- 主账号
            ,vir_acc_type -- 虚拟账户类型
            ,tran_type -- 交易类型
            ,tran_status -- 交易状态
            ,old_req_seq_no -- 第三方流水
            ,old_req_account -- 第三方客户标识
            ,org_order_id -- 原订单表标识
            ,payer_merchant_id -- 付款人银行客户编号
            ,payer_account_no -- 付款人主账号
            ,payer_ac_name -- 付款人银行户名
            ,payer_ac_no -- 付款人银行账号
            ,payer_bank_name -- 付款人开户行名称
            ,payer_bank_no -- 付款人开户行号
            ,payee_merchant_id -- 收款人银行客户编号
            ,payee_account_no -- 收款人主账号
            ,payee_ac_name -- 收款人银行户名
            ,payee_ac_no -- 收款人银行账号
            ,payee_bank_name -- 收款人开户行名称
            ,payee_bank_no -- 收款人开户行号
            ,pay_type -- 支付方式
            ,retreat_sign -- 是否退汇标志
            ,retreat_seq_no -- 退汇原流水号
            ,payer_channel -- 支付通道
            ,payer_tool -- 支付工具类型
            ,fee_amount -- 手续费
            ,amount -- 支付金额
            ,actual_balance -- 实际余额
            ,available_balance -- 可用余额
            ,mobile -- 手机号
            ,validate_code -- 验证码
            ,resp_code -- 响应码
            ,resp_msg -- 响应信息
            ,clear_date -- 银行清算日期
            ,host_seq_no -- 核心流水号
            ,host_date -- 核心日期
            ,ret_reform_cnt -- 充值结果通知次数
            ,ret_reform_status -- 充值结果通知状态
            ,ret_reform_time -- 充值结果通知时间
            ,note -- 附言
            ,remark -- 备注
            ,summary -- 摘要
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,other_bank_flag -- 本他行标志
            ,batch_id -- 银行批次编号
            ,third_batch_id -- 第三方批次编号
            ,guarant_amount -- 担保金额
            ,load_amount -- 在途金额
            ,arrival_amount -- 到账金额
            ,guarant_re_amount -- 担保剩余金额
            ,retreat_sub_seq_no -- 退汇退款原子流水号
            ,pay_global_seq_no -- 支付全局流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.order_id_pk, o.order_id_pk) as order_id_pk -- 订单标识
    ,nvl(n.order_id, o.order_id) as order_id -- 订单号
    ,nvl(n.order_time, o.order_time) as order_time -- 订单时间
    ,nvl(n.parent_merchant_id, o.parent_merchant_id) as parent_merchant_id -- 银行合作商编号
    ,nvl(n.merchant_id, o.merchant_id) as merchant_id -- 银行客户编号
    ,nvl(n.customer_name, o.customer_name) as customer_name -- 银行客户名称
    ,nvl(n.account_no, o.account_no) as account_no -- 主账号
    ,nvl(n.vir_acc_type, o.vir_acc_type) as vir_acc_type -- 虚拟账户类型
    ,nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型
    ,nvl(n.tran_status, o.tran_status) as tran_status -- 交易状态
    ,nvl(n.old_req_seq_no, o.old_req_seq_no) as old_req_seq_no -- 第三方流水
    ,nvl(n.old_req_account, o.old_req_account) as old_req_account -- 第三方客户标识
    ,nvl(n.org_order_id, o.org_order_id) as org_order_id -- 原订单表标识
    ,nvl(n.payer_merchant_id, o.payer_merchant_id) as payer_merchant_id -- 付款人银行客户编号
    ,nvl(n.payer_account_no, o.payer_account_no) as payer_account_no -- 付款人主账号
    ,nvl(n.payer_ac_name, o.payer_ac_name) as payer_ac_name -- 付款人银行户名
    ,nvl(n.payer_ac_no, o.payer_ac_no) as payer_ac_no -- 付款人银行账号
    ,nvl(n.payer_bank_name, o.payer_bank_name) as payer_bank_name -- 付款人开户行名称
    ,nvl(n.payer_bank_no, o.payer_bank_no) as payer_bank_no -- 付款人开户行号
    ,nvl(n.payee_merchant_id, o.payee_merchant_id) as payee_merchant_id -- 收款人银行客户编号
    ,nvl(n.payee_account_no, o.payee_account_no) as payee_account_no -- 收款人主账号
    ,nvl(n.payee_ac_name, o.payee_ac_name) as payee_ac_name -- 收款人银行户名
    ,nvl(n.payee_ac_no, o.payee_ac_no) as payee_ac_no -- 收款人银行账号
    ,nvl(n.payee_bank_name, o.payee_bank_name) as payee_bank_name -- 收款人开户行名称
    ,nvl(n.payee_bank_no, o.payee_bank_no) as payee_bank_no -- 收款人开户行号
    ,nvl(n.pay_type, o.pay_type) as pay_type -- 支付方式
    ,nvl(n.retreat_sign, o.retreat_sign) as retreat_sign -- 是否退汇标志
    ,nvl(n.retreat_seq_no, o.retreat_seq_no) as retreat_seq_no -- 退汇原流水号
    ,nvl(n.payer_channel, o.payer_channel) as payer_channel -- 支付通道
    ,nvl(n.payer_tool, o.payer_tool) as payer_tool -- 支付工具类型
    ,nvl(n.fee_amount, o.fee_amount) as fee_amount -- 手续费
    ,nvl(n.amount, o.amount) as amount -- 支付金额
    ,nvl(n.actual_balance, o.actual_balance) as actual_balance -- 实际余额
    ,nvl(n.available_balance, o.available_balance) as available_balance -- 可用余额
    ,nvl(n.mobile, o.mobile) as mobile -- 手机号
    ,nvl(n.validate_code, o.validate_code) as validate_code -- 验证码
    ,nvl(n.resp_code, o.resp_code) as resp_code -- 响应码
    ,nvl(n.resp_msg, o.resp_msg) as resp_msg -- 响应信息
    ,nvl(n.clear_date, o.clear_date) as clear_date -- 银行清算日期
    ,nvl(n.host_seq_no, o.host_seq_no) as host_seq_no -- 核心流水号
    ,nvl(n.host_date, o.host_date) as host_date -- 核心日期
    ,nvl(n.ret_reform_cnt, o.ret_reform_cnt) as ret_reform_cnt -- 充值结果通知次数
    ,nvl(n.ret_reform_status, o.ret_reform_status) as ret_reform_status -- 充值结果通知状态
    ,nvl(n.ret_reform_time, o.ret_reform_time) as ret_reform_time -- 充值结果通知时间
    ,nvl(n.note, o.note) as note -- 附言
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.summary, o.summary) as summary -- 摘要
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 最后更新时间
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 最后更新事务时间
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 创建时间
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 创建事务时间
    ,nvl(n.other_bank_flag, o.other_bank_flag) as other_bank_flag -- 本他行标志
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 银行批次编号
    ,nvl(n.third_batch_id, o.third_batch_id) as third_batch_id -- 第三方批次编号
    ,nvl(n.guarant_amount, o.guarant_amount) as guarant_amount -- 担保金额
    ,nvl(n.load_amount, o.load_amount) as load_amount -- 在途金额
    ,nvl(n.arrival_amount, o.arrival_amount) as arrival_amount -- 到账金额
    ,nvl(n.guarant_re_amount, o.guarant_re_amount) as guarant_re_amount -- 担保剩余金额
    ,nvl(n.retreat_sub_seq_no, o.retreat_sub_seq_no) as retreat_sub_seq_no -- 退汇退款原子流水号
    ,nvl(n.pay_global_seq_no, o.pay_global_seq_no) as pay_global_seq_no -- 支付全局流水号
    ,case when
            n.order_id_pk is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.order_id_pk is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.order_id_pk is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fdps_order_header_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fdps_order_header where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.order_id_pk = n.order_id_pk
where (
        o.order_id_pk is null
    )
    or (
        n.order_id_pk is null
    )
    or (
        o.order_id <> n.order_id
        or o.order_time <> n.order_time
        or o.parent_merchant_id <> n.parent_merchant_id
        or o.merchant_id <> n.merchant_id
        or o.customer_name <> n.customer_name
        or o.account_no <> n.account_no
        or o.vir_acc_type <> n.vir_acc_type
        or o.tran_type <> n.tran_type
        or o.tran_status <> n.tran_status
        or o.old_req_seq_no <> n.old_req_seq_no
        or o.old_req_account <> n.old_req_account
        or o.org_order_id <> n.org_order_id
        or o.payer_merchant_id <> n.payer_merchant_id
        or o.payer_account_no <> n.payer_account_no
        or o.payer_ac_name <> n.payer_ac_name
        or o.payer_ac_no <> n.payer_ac_no
        or o.payer_bank_name <> n.payer_bank_name
        or o.payer_bank_no <> n.payer_bank_no
        or o.payee_merchant_id <> n.payee_merchant_id
        or o.payee_account_no <> n.payee_account_no
        or o.payee_ac_name <> n.payee_ac_name
        or o.payee_ac_no <> n.payee_ac_no
        or o.payee_bank_name <> n.payee_bank_name
        or o.payee_bank_no <> n.payee_bank_no
        or o.pay_type <> n.pay_type
        or o.retreat_sign <> n.retreat_sign
        or o.retreat_seq_no <> n.retreat_seq_no
        or o.payer_channel <> n.payer_channel
        or o.payer_tool <> n.payer_tool
        or o.fee_amount <> n.fee_amount
        or o.amount <> n.amount
        or o.actual_balance <> n.actual_balance
        or o.available_balance <> n.available_balance
        or o.mobile <> n.mobile
        or o.validate_code <> n.validate_code
        or o.resp_code <> n.resp_code
        or o.resp_msg <> n.resp_msg
        or o.clear_date <> n.clear_date
        or o.host_seq_no <> n.host_seq_no
        or o.host_date <> n.host_date
        or o.ret_reform_cnt <> n.ret_reform_cnt
        or o.ret_reform_status <> n.ret_reform_status
        or o.ret_reform_time <> n.ret_reform_time
        or o.note <> n.note
        or o.remark <> n.remark
        or o.summary <> n.summary
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.other_bank_flag <> n.other_bank_flag
        or o.batch_id <> n.batch_id
        or o.third_batch_id <> n.third_batch_id
        or o.guarant_amount <> n.guarant_amount
        or o.load_amount <> n.load_amount
        or o.arrival_amount <> n.arrival_amount
        or o.guarant_re_amount <> n.guarant_re_amount
        or o.retreat_sub_seq_no <> n.retreat_sub_seq_no
        or o.pay_global_seq_no <> n.pay_global_seq_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fdps_order_header_cl(
            order_id_pk -- 订单标识
            ,order_id -- 订单号
            ,order_time -- 订单时间
            ,parent_merchant_id -- 银行合作商编号
            ,merchant_id -- 银行客户编号
            ,customer_name -- 银行客户名称
            ,account_no -- 主账号
            ,vir_acc_type -- 虚拟账户类型
            ,tran_type -- 交易类型
            ,tran_status -- 交易状态
            ,old_req_seq_no -- 第三方流水
            ,old_req_account -- 第三方客户标识
            ,org_order_id -- 原订单表标识
            ,payer_merchant_id -- 付款人银行客户编号
            ,payer_account_no -- 付款人主账号
            ,payer_ac_name -- 付款人银行户名
            ,payer_ac_no -- 付款人银行账号
            ,payer_bank_name -- 付款人开户行名称
            ,payer_bank_no -- 付款人开户行号
            ,payee_merchant_id -- 收款人银行客户编号
            ,payee_account_no -- 收款人主账号
            ,payee_ac_name -- 收款人银行户名
            ,payee_ac_no -- 收款人银行账号
            ,payee_bank_name -- 收款人开户行名称
            ,payee_bank_no -- 收款人开户行号
            ,pay_type -- 支付方式
            ,retreat_sign -- 是否退汇标志
            ,retreat_seq_no -- 退汇原流水号
            ,payer_channel -- 支付通道
            ,payer_tool -- 支付工具类型
            ,fee_amount -- 手续费
            ,amount -- 支付金额
            ,actual_balance -- 实际余额
            ,available_balance -- 可用余额
            ,mobile -- 手机号
            ,validate_code -- 验证码
            ,resp_code -- 响应码
            ,resp_msg -- 响应信息
            ,clear_date -- 银行清算日期
            ,host_seq_no -- 核心流水号
            ,host_date -- 核心日期
            ,ret_reform_cnt -- 充值结果通知次数
            ,ret_reform_status -- 充值结果通知状态
            ,ret_reform_time -- 充值结果通知时间
            ,note -- 附言
            ,remark -- 备注
            ,summary -- 摘要
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,other_bank_flag -- 本他行标志
            ,batch_id -- 银行批次编号
            ,third_batch_id -- 第三方批次编号
            ,guarant_amount -- 担保金额
            ,load_amount -- 在途金额
            ,arrival_amount -- 到账金额
            ,guarant_re_amount -- 担保剩余金额
            ,retreat_sub_seq_no -- 退汇退款原子流水号
            ,pay_global_seq_no -- 支付全局流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fdps_order_header_op(
            order_id_pk -- 订单标识
            ,order_id -- 订单号
            ,order_time -- 订单时间
            ,parent_merchant_id -- 银行合作商编号
            ,merchant_id -- 银行客户编号
            ,customer_name -- 银行客户名称
            ,account_no -- 主账号
            ,vir_acc_type -- 虚拟账户类型
            ,tran_type -- 交易类型
            ,tran_status -- 交易状态
            ,old_req_seq_no -- 第三方流水
            ,old_req_account -- 第三方客户标识
            ,org_order_id -- 原订单表标识
            ,payer_merchant_id -- 付款人银行客户编号
            ,payer_account_no -- 付款人主账号
            ,payer_ac_name -- 付款人银行户名
            ,payer_ac_no -- 付款人银行账号
            ,payer_bank_name -- 付款人开户行名称
            ,payer_bank_no -- 付款人开户行号
            ,payee_merchant_id -- 收款人银行客户编号
            ,payee_account_no -- 收款人主账号
            ,payee_ac_name -- 收款人银行户名
            ,payee_ac_no -- 收款人银行账号
            ,payee_bank_name -- 收款人开户行名称
            ,payee_bank_no -- 收款人开户行号
            ,pay_type -- 支付方式
            ,retreat_sign -- 是否退汇标志
            ,retreat_seq_no -- 退汇原流水号
            ,payer_channel -- 支付通道
            ,payer_tool -- 支付工具类型
            ,fee_amount -- 手续费
            ,amount -- 支付金额
            ,actual_balance -- 实际余额
            ,available_balance -- 可用余额
            ,mobile -- 手机号
            ,validate_code -- 验证码
            ,resp_code -- 响应码
            ,resp_msg -- 响应信息
            ,clear_date -- 银行清算日期
            ,host_seq_no -- 核心流水号
            ,host_date -- 核心日期
            ,ret_reform_cnt -- 充值结果通知次数
            ,ret_reform_status -- 充值结果通知状态
            ,ret_reform_time -- 充值结果通知时间
            ,note -- 附言
            ,remark -- 备注
            ,summary -- 摘要
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,other_bank_flag -- 本他行标志
            ,batch_id -- 银行批次编号
            ,third_batch_id -- 第三方批次编号
            ,guarant_amount -- 担保金额
            ,load_amount -- 在途金额
            ,arrival_amount -- 到账金额
            ,guarant_re_amount -- 担保剩余金额
            ,retreat_sub_seq_no -- 退汇退款原子流水号
            ,pay_global_seq_no -- 支付全局流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.order_id_pk -- 订单标识
    ,o.order_id -- 订单号
    ,o.order_time -- 订单时间
    ,o.parent_merchant_id -- 银行合作商编号
    ,o.merchant_id -- 银行客户编号
    ,o.customer_name -- 银行客户名称
    ,o.account_no -- 主账号
    ,o.vir_acc_type -- 虚拟账户类型
    ,o.tran_type -- 交易类型
    ,o.tran_status -- 交易状态
    ,o.old_req_seq_no -- 第三方流水
    ,o.old_req_account -- 第三方客户标识
    ,o.org_order_id -- 原订单表标识
    ,o.payer_merchant_id -- 付款人银行客户编号
    ,o.payer_account_no -- 付款人主账号
    ,o.payer_ac_name -- 付款人银行户名
    ,o.payer_ac_no -- 付款人银行账号
    ,o.payer_bank_name -- 付款人开户行名称
    ,o.payer_bank_no -- 付款人开户行号
    ,o.payee_merchant_id -- 收款人银行客户编号
    ,o.payee_account_no -- 收款人主账号
    ,o.payee_ac_name -- 收款人银行户名
    ,o.payee_ac_no -- 收款人银行账号
    ,o.payee_bank_name -- 收款人开户行名称
    ,o.payee_bank_no -- 收款人开户行号
    ,o.pay_type -- 支付方式
    ,o.retreat_sign -- 是否退汇标志
    ,o.retreat_seq_no -- 退汇原流水号
    ,o.payer_channel -- 支付通道
    ,o.payer_tool -- 支付工具类型
    ,o.fee_amount -- 手续费
    ,o.amount -- 支付金额
    ,o.actual_balance -- 实际余额
    ,o.available_balance -- 可用余额
    ,o.mobile -- 手机号
    ,o.validate_code -- 验证码
    ,o.resp_code -- 响应码
    ,o.resp_msg -- 响应信息
    ,o.clear_date -- 银行清算日期
    ,o.host_seq_no -- 核心流水号
    ,o.host_date -- 核心日期
    ,o.ret_reform_cnt -- 充值结果通知次数
    ,o.ret_reform_status -- 充值结果通知状态
    ,o.ret_reform_time -- 充值结果通知时间
    ,o.note -- 附言
    ,o.remark -- 备注
    ,o.summary -- 摘要
    ,o.last_updated_stamp -- 最后更新时间
    ,o.last_updated_tx_stamp -- 最后更新事务时间
    ,o.created_stamp -- 创建时间
    ,o.created_tx_stamp -- 创建事务时间
    ,o.other_bank_flag -- 本他行标志
    ,o.batch_id -- 银行批次编号
    ,o.third_batch_id -- 第三方批次编号
    ,o.guarant_amount -- 担保金额
    ,o.load_amount -- 在途金额
    ,o.arrival_amount -- 到账金额
    ,o.guarant_re_amount -- 担保剩余金额
    ,o.retreat_sub_seq_no -- 退汇退款原子流水号
    ,o.pay_global_seq_no -- 支付全局流水号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fdps_order_header_bk o
    left join ${iol_schema}.fdps_order_header_op n
        on
            o.order_id_pk = n.order_id_pk
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fdps_order_header_cl d
        on
            o.order_id_pk = d.order_id_pk
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fdps_order_header;

-- 4.2 exchange partition
alter table ${iol_schema}.fdps_order_header exchange partition p_19000101 with table ${iol_schema}.fdps_order_header_cl;
alter table ${iol_schema}.fdps_order_header exchange partition p_20991231 with table ${iol_schema}.fdps_order_header_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fdps_order_header to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fdps_order_header_op purge;
drop table ${iol_schema}.fdps_order_header_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fdps_order_header_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fdps_order_header',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
