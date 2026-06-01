/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_ppps_t_txn_credit
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_ppps_t_txn_credit drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_ppps_t_txn_credit drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_ppps_t_txn_credit add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_ppps_t_txn_credit partition for (to_date('${batch_date}','yyyymmdd')) (
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
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(id), 0) as id -- 自增主键
    ,nvl(trim(global_no), ' ') as global_no -- 全局流水号
    ,nvl(trim(txn_no), ' ') as txn_no -- 平台流水号
    ,nvl(trim(txn_date), ' ') as txn_date -- 平台交易日期，格式：yyyyMMdd
    ,nvl(trim(txn_time), ' ') as txn_time -- 平台交易时间，格式：HHmmss
    ,nvl(trim(txn_type), ' ') as txn_type -- 来往标识，往账-O，来账-I
    ,nvl(trim(corporate), ' ') as corporate -- 法人标识
    ,nvl(trim(mcht_no), ' ') as mcht_no -- 商户/支付机构编号
    ,nvl(trim(product_no), ' ') as product_no -- 产品编号
    ,nvl(trim(tran_no), ' ') as tran_no -- 商户交易流水号 / 交易流水号
    ,nvl(trim(tran_date), ' ') as tran_date -- 商户流水日期，格式：yyyyMMdd
    ,nvl(trim(tran_time), ' ') as tran_time -- 商户流水时间，格式：HHmmss
    ,nvl(trim(status), ' ') as status -- 交易处理状态，取值：StatusEnum
    ,nvl(trim(biz_status), ' ') as biz_status -- 业务处理状态
    ,nvl(trim(trade_type), ' ') as trade_type -- 交易类别，例如：协议支付，取值：TradeTypeEnum
    ,nvl(trim(route_type), ' ') as route_type -- 交易路由方式，默认：自动，取值：RouteType
    ,nvl(trim(priority), ' ') as priority -- 交易时效，默认：R-实时，取值：PriorityEnum
    ,nvl(trim(work_date), ' ') as work_date -- 工作日期
    ,nvl(trim(amount), 0) as amount -- 交易金额，默认：零元-0.00，单位：元
    ,nvl(trim(currency), ' ') as currency -- 交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
    ,nvl(trim(payee_acct_no), ' ') as payee_acct_no -- 收款方账号
    ,nvl(trim(payee_acct_name), ' ') as payee_acct_name -- 收款方账户户名
    ,nvl(trim(payee_acct_type), ' ') as payee_acct_type -- 收款方账号类别，取值：AcctTypeEnum
    ,nvl(trim(payee_host_type), ' ') as payee_host_type -- 收款方账号所属核心类别
    ,nvl(trim(payee_bank_code), ' ') as payee_bank_code -- 收款行清算行行号
    ,nvl(trim(payer_acct_no), ' ') as payer_acct_no -- 付款方账号
    ,nvl(trim(payer_acct_name), ' ') as payer_acct_name -- 付款方账户户名
    ,nvl(trim(payer_acct_type), ' ') as payer_acct_type -- 付款方账号类别，取值：AcctTypeEnum
    ,nvl(trim(payer_host_type), ' ') as payer_host_type -- 付款方账号所属核心类别
    ,nvl(trim(payer_phone), ' ') as payer_phone -- 付款方手机号
    ,nvl(trim(payer_valid_date), ' ') as payer_valid_date -- 付款方贷记卡有效期
    ,nvl(trim(payer_cvn2), ' ') as payer_cvn2 -- 付款方贷记卡安全码
    ,nvl(trim(payer_bank_code), ' ') as payer_bank_code -- 付款行清算行行号
    ,nvl(trim(real_payer_acct_no), ' ') as real_payer_acct_no -- 实际付款人账号
    ,nvl(trim(real_payer_acct_name), ' ') as real_payer_acct_name -- 实际付款人名称
    ,nvl(trim(real_payer_acct_type), ' ') as real_payer_acct_type -- 实际付款人账户类型
    ,nvl(trim(real_payer_host_type), ' ') as real_payer_host_type -- 实际付款人所属核心类型
    ,nvl(trim(ret_code), ' ') as ret_code -- 平台返回码
    ,nvl(trim(ret_msg), ' ') as ret_msg -- 平台返回码描述
    ,nvl(trim(is_limited), ' ') as is_limited -- 是否已累计客户限额,Y-已限额处理 N-未限额处理
    ,nvl(trim(action_type), ' ') as action_type -- 请求的业务接口类型，取值：ActionType
    ,nvl(trim(host_status), ' ') as host_status -- 交易核心账务状态
    ,nvl(trim(account_cnt), 0) as account_cnt -- 本次记账操作步骤总数
    ,nvl(trim(host_code_list), ' ') as host_code_list -- 请求的核心系统编码，适用于多核心业务系统（DEBIT_HOST-EAS_HOST）
    ,nvl(trim(host_no), ' ') as host_no -- 核心交易流水号
    ,nvl(trim(reverse_no), ' ') as reverse_no -- 核心冲正流水号
    ,nvl(trim(refunded), ' ') as refunded -- 是否已经退款，取值：BooleanEnum
    ,nvl(trim(pmc_code), ' ') as pmc_code -- 通道系统编码
    ,nvl(trim(pmc_no), ' ') as pmc_no -- 通道交易流水号
    ,nvl(trim(pmc_status), ' ') as pmc_status -- 通道原始状态值
    ,nvl(trim(pmc_ret_code), ' ') as pmc_ret_code -- 通道的原始返回码
    ,nvl(trim(pmc_ret_msg), ' ') as pmc_ret_msg -- 通道的原始返回码描述
    ,nvl(trim(pmc_date), ' ') as pmc_date -- 通道交易日期，无法获取时，取平台交易日期
    ,nvl(trim(pmc_time), ' ') as pmc_time -- 通道交易时间，无法获取时，取平台交易时间
    ,nvl(trim(pmc_cost), 0) as pmc_cost -- 通道成本费，单位：元
    ,nvl(trim(mcht_fee), 0) as mcht_fee -- 渠道交易手续费，单位：元
    ,nvl(trim(fee_no), ' ') as fee_no -- 渠道手续费记账流水号（核心流水）
    ,nvl(trim(fee_status), ' ') as fee_status -- 手续费计收状态，取值：FeeStatus
    ,nvl(trim(charge_type), ' ') as charge_type -- 计费类型，取值：ChargeTypeEnum
    ,nvl(trim(check_date), ' ') as check_date -- 对账日期，亦是通道认为的交易时间
    ,nvl(trim(checked), ' ') as checked -- 对账处理标识，取值：CheckedEnum
    ,nvl(trim(check_state), ' ') as check_state -- 对账状态，用于描述对账是对平或是具体差错类型
    ,nvl(trim(is_charge), ' ') as is_charge -- 是否收取手续费（Y-收取；N-不收取）
    ,nvl(trim(is_delay), ' ') as is_delay -- 是否需要延时转账（Y-需要延时转账；N-不需要延时转账）
    ,nvl(trim(delay_time), ' ') as delay_time -- 延时时间（以小时为单位）
    ,nvl(trim(fee_amount), 0) as fee_amount -- 客户手续费，一般与渠道交易手续费一致
    ,nvl(trim(chl_checking_code), ' ') as chl_checking_code -- 渠道对账产品代码
    ,nvl(trim(chl_check_date), ' ') as chl_check_date -- 渠道对账日期
    ,nvl(trim(auth_teller_no), ' ') as auth_teller_no -- 授权柜员号
    ,nvl(trim(check_teller_no), ' ') as check_teller_no -- 复核柜员号
    ,nvl(trim(trans_org_no), ' ') as trans_org_no -- 交易机构号
    ,nvl(trim(summery_code), ' ') as summery_code -- 交易机构号
    ,nvl(trim(consumer_id), ' ') as consumer_id -- 调用方系统ID
    ,nvl(trim(is_notify), ' ') as is_notify -- 是否需要异步通知（Y：接受；N：不接受）
    ,nvl(trim(notify_addr), ' ') as notify_addr -- 异步通知地址
    ,nvl(trim(notify_service_name), ' ') as notify_service_name -- 异步通知服务名称
    ,nvl(trim(payer_ext_map_id), ' ') as payer_ext_map_id -- 付款方扩展MAP编号
    ,nvl(trim(payee_ext_map_id), ' ') as payee_ext_map_id -- 收款方扩展MAP编号
    ,nvl(trim(route_map_id), ' ') as route_map_id -- 明细扩展MAP编号
    ,nvl(trim(host_desc), ' ') as host_desc -- 核心对账处理描述信息
    ,nvl(trim(channel_desc), ' ') as channel_desc -- 通道对账处理描述信息
    ,nvl(trim(balance_desc), ' ') as balance_desc -- 平衡性检查处理描述信息
    ,nvl(check_time, to_date('00010101', 'yyyymmdd')) as check_time -- 对账处理时间，格式：yyyy-MM-dd HH:mm:ss
    ,nvl(trim(buiness_module), ' ') as buiness_module -- LOCAL-本行；CROSS：跨行
    ,nvl(trim(init_mcht_no), ' ') as init_mcht_no -- 源发起渠道编号
    ,nvl(trim(sys_comm_no), ' ') as sys_comm_no -- 业务流水号
    ,nvl(trim(pmc_ret_no), ' ') as pmc_ret_no -- 通道响应流水号
    ,nvl(trim(pmc_ret_date), ' ') as pmc_ret_date -- 通道响应日期
    ,nvl(trim(pmc_ret_time), ' ') as pmc_ret_time -- 通道响应时间
    ,nvl(trim(pmc_ret_status), ' ') as pmc_ret_status -- 通道原始状态
    ,nvl(trim(mcht_check_mode), ' ') as mcht_check_mode -- FIXED：渠道自定义对账；DEFAULT：系统默认对账代码对账
    ,nvl(trim(payer_bank_name), ' ') as payer_bank_name -- 付款行清算行行名
    ,nvl(trim(payee_bank_name), ' ') as payee_bank_name -- 收款行清算行行名
    ,nvl(trim(check_flag), ' ') as check_flag -- 对账标识（BALANCE-视作对平；NOT_CHECK-暂无需对账；PROCESSED-已处理）
    ,nvl(trim(host_date), ' ') as host_date -- 核心响应日期（会计日期）
    ,nvl(trim(host_time), ' ') as host_time -- 核心响应时间（会计时间）
    ,nvl(trim(acc_bean_json), ' ') as acc_bean_json -- 记账请求的bean报文信息（以json串存储）
    ,nvl(trim(clear_date), ' ') as clear_date -- 交易清算日期，给商户清算的日期，对账日期+对应清算类型的周期
    ,nvl(trim(cleared), ' ') as cleared -- 是否已经清算，取值：BooleanEnum
    ,nvl(trim(clear_no), ' ') as clear_no -- 清算流水号
    ,nvl(trim(clear_type), ' ') as clear_type -- 清算类型，取值：ClearTypeEnum
    ,nvl(trim(clear_cycle), 0) as clear_cycle -- 清算周期，实时清算时为0，周期清算时0~99
    ,nvl(trim(teller_no), ' ') as teller_no -- 交易柜员号
    ,nvl(trim(payee_phone), ' ') as payee_phone -- 收款方手机号
    ,nvl(trim(payee_valid_date), ' ') as payee_valid_date -- 收款方贷记卡有效期
    ,nvl(trim(payee_cvn2), ' ') as payee_cvn2 -- 收款方贷记卡安全码
    ,nvl(trim(biz_type), ' ') as biz_type -- 业务类型，例如：水电气缴费
    ,nvl(trim(sign_no), ' ') as sign_no -- 渠道协议签约号
    ,nvl(trim(batch_no), ' ') as batch_no -- 交易批次号
    ,nvl(trim(purpose), ' ') as purpose -- 交易附言
    ,nvl(trim(log_id), ' ') as log_id -- 交易日志文件ID
    ,nvl(trim(server_id), ' ') as server_id -- 交易服务器ID
    ,nvl(trim(sharding), ' ') as sharding -- 分库参考值专用字段，无业务含义
    ,nvl(trim(remark), ' ') as remark -- 备注信息
    ,nvl(create_time, to_date('00010101', 'yyyymmdd')) as create_time -- 流水创建时间，格式：yyyy-MM-dd HH:mm:ss
    ,nvl(update_time, to_date('00010101', 'yyyymmdd')) as update_time -- 流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
    ,nvl(trim(trace_msg), ' ') as trace_msg -- 链路跟踪信息
    ,nvl(trim(advance_flag), ' ') as advance_flag -- 是否垫资标识(00：不垫支;1：垫支)
    ,nvl(trim(biz_sys_code), ' ') as biz_sys_code -- 业务所属系统
    ,nvl(trim(checking_code), ' ') as checking_code -- 内部对账代码/核心对账代码
    ,nvl(trim(business_code), ' ') as business_code -- 业务场景码
    ,nvl(trim(payee_cert_type), ' ') as payee_cert_type -- 收款人证件类型
    ,nvl(trim(payer_cert_type), ' ') as payer_cert_type -- 付款人证件类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_ppps_t_txn_credit
where etl_dt = to_date('${batch_date}','yyyymmdd') 
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_ppps_t_txn_credit to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_ppps_t_txn_credit',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);