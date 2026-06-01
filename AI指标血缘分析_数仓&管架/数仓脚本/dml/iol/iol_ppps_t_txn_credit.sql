/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ppps_t_txn_credit
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
drop table ${iol_schema}.ppps_t_txn_credit_ex purge;
alter table ${iol_schema}.ppps_t_txn_credit add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ppps_t_txn_credit truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ppps_t_txn_credit_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_t_txn_credit where 0=1;

insert /*+ append */ into ${iol_schema}.ppps_t_txn_credit_ex(
    id -- 自增主键
    ,global_no -- 全局流水号
    ,txn_no -- 平台流水号
    ,txn_date -- 平台交易日期，格式：yyyyMMdd
    ,txn_time -- 平台交易时间，格式：HHmmss
    ,txn_type -- 来往标识，往账-O，来账-I
    ,corporate -- 法人标识
    ,mcht_no -- 商户/支付机构编号
    ,product_no -- 产品编号
    ,tran_no -- 商户交易流水号 / 交易流水号
    ,tran_date -- 商户流水日期，格式：yyyyMMdd
    ,tran_time -- 商户流水时间，格式：HHmmss
    ,status -- 交易处理状态，取值：StatusEnum
    ,biz_status -- 业务处理状态
    ,trade_type -- 交易类别，例如：协议支付，取值：TradeTypeEnum
    ,route_type -- 交易路由方式，默认：自动，取值：RouteType
    ,priority -- 交易时效，默认：R-实时，取值：PriorityEnum
    ,work_date -- 工作日期
    ,amount -- 交易金额，默认：零元-0.00，单位：元
    ,currency -- 交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
    ,payee_acct_no -- 收款方账号
    ,payee_acct_name -- 收款方账户户名
    ,payee_acct_type -- 收款方账号类别，取值：AcctTypeEnum
    ,payee_host_type -- 收款方账号所属核心类别
    ,payee_bank_code -- 收款行清算行行号
    ,payer_acct_no -- 付款方账号
    ,payer_acct_name -- 付款方账户户名
    ,payer_acct_type -- 付款方账号类别，取值：AcctTypeEnum
    ,payer_host_type -- 付款方账号所属核心类别
    ,payer_phone -- 付款方手机号
    ,payer_valid_date -- 付款方贷记卡有效期
    ,payer_cvn2 -- 付款方贷记卡安全码
    ,payer_bank_code -- 付款行清算行行号
    ,real_payer_acct_no -- 实际付款人账号
    ,real_payer_acct_name -- 实际付款人名称
    ,real_payer_acct_type -- 实际付款人账户类型
    ,real_payer_host_type -- 实际付款人所属核心类型
    ,ret_code -- 平台返回码
    ,ret_msg -- 平台返回码描述
    ,is_limited -- 是否已累计客户限额,Y-已限额处理 N-未限额处理
    ,action_type -- 请求的业务接口类型，取值：ActionType
    ,host_status -- 交易核心账务状态
    ,account_cnt -- 本次记账操作步骤总数
    ,host_code_list -- 请求的核心系统编码，适用于多核心业务系统（DEBIT_HOST-EAS_HOST）
    ,host_no -- 核心交易流水号
    ,reverse_no -- 核心冲正流水号
    ,refunded -- 是否已经退款，取值：BooleanEnum
    ,pmc_code -- 通道系统编码
    ,pmc_no -- 通道交易流水号
    ,pmc_status -- 通道原始状态值
    ,pmc_ret_code -- 通道的原始返回码
    ,pmc_ret_msg -- 通道的原始返回码描述
    ,pmc_date -- 通道交易日期，无法获取时，取平台交易日期
    ,pmc_time -- 通道交易时间，无法获取时，取平台交易时间
    ,pmc_cost -- 通道成本费，单位：元
    ,mcht_fee -- 渠道交易手续费，单位：元
    ,fee_no -- 渠道手续费记账流水号（核心流水）
    ,fee_status -- 手续费计收状态，取值：FeeStatus
    ,charge_type -- 计费类型，取值：ChargeTypeEnum
    ,check_date -- 对账日期，亦是通道认为的交易时间
    ,checked -- 对账处理标识，取值：CheckedEnum
    ,check_state -- 对账状态，用于描述对账是对平或是具体差错类型
    ,is_charge -- 是否收取手续费（Y-收取；N-不收取）
    ,is_delay -- 是否需要延时转账（Y-需要延时转账；N-不需要延时转账）
    ,delay_time -- 延时时间（以小时为单位）
    ,fee_amount -- 客户手续费，一般与渠道交易手续费一致
    ,chl_checking_code -- 渠道对账产品代码
    ,chl_check_date -- 渠道对账日期
    ,auth_teller_no -- 授权柜员号
    ,check_teller_no -- 复核柜员号
    ,trans_org_no -- 交易机构号
    ,summery_code -- 交易机构号
    ,consumer_id -- 调用方系统ID
    ,is_notify -- 是否需要异步通知（Y：接受；N：不接受）
    ,notify_addr -- 异步通知地址
    ,notify_service_name -- 异步通知服务名称
    ,payer_ext_map_id -- 付款方扩展MAP编号
    ,payee_ext_map_id -- 收款方扩展MAP编号
    ,route_map_id -- 明细扩展MAP编号
    ,host_desc -- 核心对账处理描述信息
    ,channel_desc -- 通道对账处理描述信息
    ,balance_desc -- 平衡性检查处理描述信息
    ,check_time -- 对账处理时间，格式：yyyy-MM-dd HH:mm:ss
    ,buiness_module -- LOCAL-本行；CROSS：跨行
    ,init_mcht_no -- 源发起渠道编号
    ,sys_comm_no -- 业务流水号
    ,pmc_ret_no -- 通道响应流水号
    ,pmc_ret_date -- 通道响应日期
    ,pmc_ret_time -- 通道响应时间
    ,pmc_ret_status -- 通道原始状态
    ,mcht_check_mode -- FIXED：渠道自定义对账；DEFAULT：系统默认对账代码对账
    ,payer_bank_name -- 付款行清算行行名
    ,payee_bank_name -- 收款行清算行行名
    ,check_flag -- 对账标识（BALANCE-视作对平；NOT_CHECK-暂无需对账；PROCESSED-已处理）
    ,host_date -- 核心响应日期（会计日期）
    ,host_time -- 核心响应时间（会计时间）
    ,acc_bean_json -- 记账请求的bean报文信息（以json串存储）
    ,clear_date -- 交易清算日期，给商户清算的日期，对账日期+对应清算类型的周期
    ,cleared -- 是否已经清算，取值：BooleanEnum
    ,clear_no -- 清算流水号
    ,clear_type -- 清算类型，取值：ClearTypeEnum
    ,clear_cycle -- 清算周期，实时清算时为0，周期清算时0~99
    ,teller_no -- 交易柜员号
    ,payee_phone -- 收款方手机号
    ,payee_valid_date -- 收款方贷记卡有效期
    ,payee_cvn2 -- 收款方贷记卡安全码
    ,biz_type -- 业务类型，例如：水电气缴费
    ,sign_no -- 渠道协议签约号
    ,batch_no -- 交易批次号
    ,purpose -- 交易附言
    ,log_id -- 交易日志文件ID
    ,server_id -- 交易服务器ID
    ,sharding -- 分库参考值专用字段，无业务含义
    ,remark -- 备注信息
    ,create_time -- 流水创建时间，格式：yyyy-MM-dd HH:mm:ss
    ,update_time -- 流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
    ,trace_msg -- 链路跟踪信息
    ,advance_flag -- 是否垫资标识(00：不垫支;1：垫支)
    ,biz_sys_code -- 业务所属系统
    ,checking_code -- 内部对账代码/核心对账代码
    ,business_code -- 业务场景码
    ,payee_cert_type -- 收款人证件类型
    ,payer_cert_type -- 付款人证件类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 自增主键
    ,global_no -- 全局流水号
    ,txn_no -- 平台流水号
    ,txn_date -- 平台交易日期，格式：yyyyMMdd
    ,txn_time -- 平台交易时间，格式：HHmmss
    ,txn_type -- 来往标识，往账-O，来账-I
    ,corporate -- 法人标识
    ,mcht_no -- 商户/支付机构编号
    ,product_no -- 产品编号
    ,tran_no -- 商户交易流水号 / 交易流水号
    ,tran_date -- 商户流水日期，格式：yyyyMMdd
    ,tran_time -- 商户流水时间，格式：HHmmss
    ,status -- 交易处理状态，取值：StatusEnum
    ,biz_status -- 业务处理状态
    ,trade_type -- 交易类别，例如：协议支付，取值：TradeTypeEnum
    ,route_type -- 交易路由方式，默认：自动，取值：RouteType
    ,priority -- 交易时效，默认：R-实时，取值：PriorityEnum
    ,work_date -- 工作日期
    ,amount -- 交易金额，默认：零元-0.00，单位：元
    ,currency -- 交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
    ,payee_acct_no -- 收款方账号
    ,payee_acct_name -- 收款方账户户名
    ,payee_acct_type -- 收款方账号类别，取值：AcctTypeEnum
    ,payee_host_type -- 收款方账号所属核心类别
    ,payee_bank_code -- 收款行清算行行号
    ,payer_acct_no -- 付款方账号
    ,payer_acct_name -- 付款方账户户名
    ,payer_acct_type -- 付款方账号类别，取值：AcctTypeEnum
    ,payer_host_type -- 付款方账号所属核心类别
    ,payer_phone -- 付款方手机号
    ,payer_valid_date -- 付款方贷记卡有效期
    ,payer_cvn2 -- 付款方贷记卡安全码
    ,payer_bank_code -- 付款行清算行行号
    ,real_payer_acct_no -- 实际付款人账号
    ,real_payer_acct_name -- 实际付款人名称
    ,real_payer_acct_type -- 实际付款人账户类型
    ,real_payer_host_type -- 实际付款人所属核心类型
    ,ret_code -- 平台返回码
    ,ret_msg -- 平台返回码描述
    ,is_limited -- 是否已累计客户限额,Y-已限额处理 N-未限额处理
    ,action_type -- 请求的业务接口类型，取值：ActionType
    ,host_status -- 交易核心账务状态
    ,account_cnt -- 本次记账操作步骤总数
    ,host_code_list -- 请求的核心系统编码，适用于多核心业务系统（DEBIT_HOST-EAS_HOST）
    ,host_no -- 核心交易流水号
    ,reverse_no -- 核心冲正流水号
    ,refunded -- 是否已经退款，取值：BooleanEnum
    ,pmc_code -- 通道系统编码
    ,pmc_no -- 通道交易流水号
    ,pmc_status -- 通道原始状态值
    ,pmc_ret_code -- 通道的原始返回码
    ,pmc_ret_msg -- 通道的原始返回码描述
    ,pmc_date -- 通道交易日期，无法获取时，取平台交易日期
    ,pmc_time -- 通道交易时间，无法获取时，取平台交易时间
    ,pmc_cost -- 通道成本费，单位：元
    ,mcht_fee -- 渠道交易手续费，单位：元
    ,fee_no -- 渠道手续费记账流水号（核心流水）
    ,fee_status -- 手续费计收状态，取值：FeeStatus
    ,charge_type -- 计费类型，取值：ChargeTypeEnum
    ,check_date -- 对账日期，亦是通道认为的交易时间
    ,checked -- 对账处理标识，取值：CheckedEnum
    ,check_state -- 对账状态，用于描述对账是对平或是具体差错类型
    ,is_charge -- 是否收取手续费（Y-收取；N-不收取）
    ,is_delay -- 是否需要延时转账（Y-需要延时转账；N-不需要延时转账）
    ,delay_time -- 延时时间（以小时为单位）
    ,fee_amount -- 客户手续费，一般与渠道交易手续费一致
    ,chl_checking_code -- 渠道对账产品代码
    ,chl_check_date -- 渠道对账日期
    ,auth_teller_no -- 授权柜员号
    ,check_teller_no -- 复核柜员号
    ,trans_org_no -- 交易机构号
    ,summery_code -- 交易机构号
    ,consumer_id -- 调用方系统ID
    ,is_notify -- 是否需要异步通知（Y：接受；N：不接受）
    ,notify_addr -- 异步通知地址
    ,notify_service_name -- 异步通知服务名称
    ,payer_ext_map_id -- 付款方扩展MAP编号
    ,payee_ext_map_id -- 收款方扩展MAP编号
    ,route_map_id -- 明细扩展MAP编号
    ,host_desc -- 核心对账处理描述信息
    ,channel_desc -- 通道对账处理描述信息
    ,balance_desc -- 平衡性检查处理描述信息
    ,check_time -- 对账处理时间，格式：yyyy-MM-dd HH:mm:ss
    ,buiness_module -- LOCAL-本行；CROSS：跨行
    ,init_mcht_no -- 源发起渠道编号
    ,sys_comm_no -- 业务流水号
    ,pmc_ret_no -- 通道响应流水号
    ,pmc_ret_date -- 通道响应日期
    ,pmc_ret_time -- 通道响应时间
    ,pmc_ret_status -- 通道原始状态
    ,mcht_check_mode -- FIXED：渠道自定义对账；DEFAULT：系统默认对账代码对账
    ,payer_bank_name -- 付款行清算行行名
    ,payee_bank_name -- 收款行清算行行名
    ,check_flag -- 对账标识（BALANCE-视作对平；NOT_CHECK-暂无需对账；PROCESSED-已处理）
    ,host_date -- 核心响应日期（会计日期）
    ,host_time -- 核心响应时间（会计时间）
    ,acc_bean_json -- 记账请求的bean报文信息（以json串存储）
    ,clear_date -- 交易清算日期，给商户清算的日期，对账日期+对应清算类型的周期
    ,cleared -- 是否已经清算，取值：BooleanEnum
    ,clear_no -- 清算流水号
    ,clear_type -- 清算类型，取值：ClearTypeEnum
    ,clear_cycle -- 清算周期，实时清算时为0，周期清算时0~99
    ,teller_no -- 交易柜员号
    ,payee_phone -- 收款方手机号
    ,payee_valid_date -- 收款方贷记卡有效期
    ,payee_cvn2 -- 收款方贷记卡安全码
    ,biz_type -- 业务类型，例如：水电气缴费
    ,sign_no -- 渠道协议签约号
    ,batch_no -- 交易批次号
    ,purpose -- 交易附言
    ,log_id -- 交易日志文件ID
    ,server_id -- 交易服务器ID
    ,sharding -- 分库参考值专用字段，无业务含义
    ,remark -- 备注信息
    ,create_time -- 流水创建时间，格式：yyyy-MM-dd HH:mm:ss
    ,update_time -- 流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
    ,trace_msg -- 链路跟踪信息
    ,advance_flag -- 是否垫资标识(00：不垫支;1：垫支)
    ,biz_sys_code -- 业务所属系统
    ,checking_code -- 内部对账代码/核心对账代码
    ,business_code -- 业务场景码
    ,payee_cert_type -- 收款人证件类型
    ,payer_cert_type -- 付款人证件类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ppps_t_txn_credit
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ppps_t_txn_credit exchange partition p_${batch_date} with table ${iol_schema}.ppps_t_txn_credit_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ppps_t_txn_credit to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ppps_t_txn_credit_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ppps_t_txn_credit',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);