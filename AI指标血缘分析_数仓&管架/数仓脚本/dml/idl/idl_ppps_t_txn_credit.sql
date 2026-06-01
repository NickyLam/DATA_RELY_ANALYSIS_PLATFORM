/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ppps_t_txn_credit
CreateDate: 20240109
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.ppps_t_txn_credit drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ppps_t_txn_credit add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ppps_t_txn_credit (
etl_dt  --数据日期
,id  --自增主键
,global_no  --全局流水号
,txn_no  --平台流水号
,txn_date  --平台交易日期，格式：yyyyMMdd
,txn_time  --平台交易时间，格式：HHmmss
,txn_type  --来往标识，往账-O，来账-I
,corporate  --法人标识
,mcht_no  --商户/支付机构编号
,product_no  --产品编号
,tran_no  --商户交易流水号 / 交易流水号
,tran_date  --商户流水日期，格式：yyyyMMdd
,tran_time  --商户流水时间，格式：HHmmss
,status  --交易处理状态，取值：StatusEnum
,biz_status  --业务处理状态
,trade_type  --交易类别，例如：协议支付，取值：TradeTypeEnum
,route_type  --交易路由方式，默认：自动，取值：RouteType
,priority  --交易时效，默认：R-实时，取值：PriorityEnum
,work_date  --工作日期
,amount  --交易金额，默认：零元-0.00，单位：元
,currency  --交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
,payee_acct_no  --收款方账号
,payee_acct_name  --收款方账户户名
,payee_acct_type  --收款方账号类别，取值：AcctTypeEnum
,payee_host_type  --收款方账号所属核心类别
,payee_bank_code  --收款行清算行行号
,payer_acct_no  --付款方账号
,payer_acct_name  --付款方账户户名
,payer_acct_type  --付款方账号类别，取值：AcctTypeEnum
,payer_host_type  --付款方账号所属核心类别
,payer_phone  --付款方手机号
,payer_valid_date  --付款方贷记卡有效期
,payer_cvn2  --付款方贷记卡安全码
,payer_bank_code  --付款行清算行行号
,real_payer_acct_no  --实际付款人账号
,real_payer_acct_name  --实际付款人名称
,real_payer_acct_type  --实际付款人账户类型
,real_payer_host_type  --实际付款人所属核心类型
,ret_code  --平台返回码
,ret_msg  --平台返回码描述
,is_limited  --是否已累计客户限额,Y-已限额处理 N-未限额处理
,action_type  --请求的业务接口类型，取值：ActionType
,host_status  --交易核心账务状态
,account_cnt  --本次记账操作步骤总数
,host_code_list  --请求的核心系统编码，适用于多核心业务系统（DEBIT_HOST-EAS_HOST）
,host_no  --核心交易流水号
,reverse_no  --核心冲正流水号
,refunded  --是否已经退款，取值：BooleanEnum
,pmc_code  --通道系统编码
,pmc_no  --通道交易流水号
,pmc_status  --通道原始状态值
,pmc_ret_code  --通道的原始返回码
,pmc_ret_msg  --通道的原始返回码描述
,pmc_date  --通道交易日期，无法获取时，取平台交易日期
,pmc_time  --通道交易时间，无法获取时，取平台交易时间
,pmc_cost  --通道成本费，单位：元
,mcht_fee  --渠道交易手续费，单位：元
,fee_no  --渠道手续费记账流水号（核心流水）
,fee_status  --手续费计收状态，取值：FeeStatus
,charge_type  --计费类型，取值：ChargeTypeEnum
,check_date  --对账日期，亦是通道认为的交易时间
,checked  --对账处理标识，取值：CheckedEnum
,check_state  --对账状态，用于描述对账是对平或是具体差错类型
,is_charge  --是否收取手续费（Y-收取；N-不收取）
,is_delay  --是否需要延时转账（Y-需要延时转账；N-不需要延时转账）
,delay_time  --延时时间（以小时为单位）
,fee_amount  --客户手续费，一般与渠道交易手续费一致
,chl_checking_code  --渠道对账产品代码
,chl_check_date  --渠道对账日期
,auth_teller_no  --授权柜员号
,check_teller_no  --复核柜员号
,trans_org_no  --交易机构号
,summery_code  --交易机构号
,consumer_id  --调用方系统ID
,is_notify  --是否需要异步通知（Y：接受；N：不接受）
,notify_addr  --异步通知地址
,notify_service_name  --异步通知服务名称
,payer_ext_map_id  --付款方扩展MAP编号
,payee_ext_map_id  --收款方扩展MAP编号
,route_map_id  --明细扩展MAP编号
,host_desc  --核心对账处理描述信息
,channel_desc  --通道对账处理描述信息
,balance_desc  --平衡性检查处理描述信息
,check_time  --对账处理时间，格式：yyyy-MM-dd HH:mm:ss
,buiness_module  --LOCAL-本行；CROSS：跨行
,init_mcht_no  --源发起渠道编号
,sys_comm_no  --业务流水号
,pmc_ret_no  --通道响应流水号
,pmc_ret_date  --通道响应日期
,pmc_ret_time  --通道响应时间
,pmc_ret_status  --通道原始状态
,mcht_check_mode  --FIXED：渠道自定义对账；DEFAULT：系统默认对账代码对账
,payer_bank_name  --付款行清算行行名
,payee_bank_name  --收款行清算行行名
,check_flag  --对账标识（BALANCE-视作对平；NOT_CHECK-暂无需对账；PROCESSED-已处理）
,host_date  --核心响应日期（会计日期）
,host_time  --核心响应时间（会计时间）
,acc_bean_json  --记账请求的bean报文信息（以json串存储）
,clear_date  --交易清算日期，给商户清算的日期，对账日期+对应清算类型的周期
,cleared  --是否已经清算，取值：BooleanEnum
,clear_no  --清算流水号
,clear_type  --清算类型，取值：ClearTypeEnum
,clear_cycle  --清算周期，实时清算时为0，周期清算时0~99
,teller_no  --交易柜员号
,payee_phone  --收款方手机号
,payee_valid_date  --收款方贷记卡有效期
,payee_cvn2  --收款方贷记卡安全码
,biz_type  --业务类型，例如：水电气缴费
,sign_no  --渠道协议签约号
,batch_no  --交易批次号
,purpose  --交易附言
,log_id  --交易日志文件ID
,server_id  --交易服务器ID
,sharding  --分库参考值专用字段，无业务含义
,remark  --备注信息
,create_time  --流水创建时间，格式：yyyy-MM-dd HH:mm:ss
,update_time  --流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
,trace_msg  --链路跟踪信息
,advance_flag  --是否垫资标识(00：不垫支;1：垫支)
,biz_sys_code  --业务所属系统
,checking_code  --内部对账代码/核心对账代码
,business_code  --业务场景码
,payee_cert_type  --收款人证件类型
,payer_cert_type  --付款人证件类型

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,t1.id as id --自增主键
,replace(replace(t1.global_no,chr(13),''),chr(10),'') as global_no --全局流水号
,replace(replace(t1.txn_no,chr(13),''),chr(10),'') as txn_no --平台流水号
,replace(replace(t1.txn_date,chr(13),''),chr(10),'') as txn_date --平台交易日期，格式：yyyyMMdd
,replace(replace(t1.txn_time,chr(13),''),chr(10),'') as txn_time --平台交易时间，格式：HHmmss
,replace(replace(t1.txn_type,chr(13),''),chr(10),'') as txn_type --来往标识，往账-O，来账-I
,replace(replace(t1.corporate,chr(13),''),chr(10),'') as corporate --法人标识
,replace(replace(t1.mcht_no,chr(13),''),chr(10),'') as mcht_no --商户/支付机构编号
,replace(replace(t1.product_no,chr(13),''),chr(10),'') as product_no --产品编号
,replace(replace(t1.tran_no,chr(13),''),chr(10),'') as tran_no --商户交易流水号 / 交易流水号
,replace(replace(t1.tran_date,chr(13),''),chr(10),'') as tran_date --商户流水日期，格式：yyyyMMdd
,replace(replace(t1.tran_time,chr(13),''),chr(10),'') as tran_time --商户流水时间，格式：HHmmss
,replace(replace(t1.status,chr(13),''),chr(10),'') as status --交易处理状态，取值：StatusEnum
,replace(replace(t1.biz_status,chr(13),''),chr(10),'') as biz_status --业务处理状态
,replace(replace(t1.trade_type,chr(13),''),chr(10),'') as trade_type --交易类别，例如：协议支付，取值：TradeTypeEnum
,replace(replace(t1.route_type,chr(13),''),chr(10),'') as route_type --交易路由方式，默认：自动，取值：RouteType
,replace(replace(t1.priority,chr(13),''),chr(10),'') as priority --交易时效，默认：R-实时，取值：PriorityEnum
,replace(replace(t1.work_date,chr(13),''),chr(10),'') as work_date --工作日期
,t1.amount as amount --交易金额，默认：零元-0.00，单位：元
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency --交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
,replace(replace(t1.payee_acct_no,chr(13),''),chr(10),'') as payee_acct_no --收款方账号
,replace(replace(t1.payee_acct_name,chr(13),''),chr(10),'') as payee_acct_name --收款方账户户名
,replace(replace(t1.payee_acct_type,chr(13),''),chr(10),'') as payee_acct_type --收款方账号类别，取值：AcctTypeEnum
,replace(replace(t1.payee_host_type,chr(13),''),chr(10),'') as payee_host_type --收款方账号所属核心类别
,replace(replace(t1.payee_bank_code,chr(13),''),chr(10),'') as payee_bank_code --收款行清算行行号
,replace(replace(t1.payer_acct_no,chr(13),''),chr(10),'') as payer_acct_no --付款方账号
,replace(replace(t1.payer_acct_name,chr(13),''),chr(10),'') as payer_acct_name --付款方账户户名
,replace(replace(t1.payer_acct_type,chr(13),''),chr(10),'') as payer_acct_type --付款方账号类别，取值：AcctTypeEnum
,replace(replace(t1.payer_host_type,chr(13),''),chr(10),'') as payer_host_type --付款方账号所属核心类别
,replace(replace(t1.payer_phone,chr(13),''),chr(10),'') as payer_phone --付款方手机号
,replace(replace(t1.payer_valid_date,chr(13),''),chr(10),'') as payer_valid_date --付款方贷记卡有效期
,replace(replace(t1.payer_cvn2,chr(13),''),chr(10),'') as payer_cvn2 --付款方贷记卡安全码
,replace(replace(t1.payer_bank_code,chr(13),''),chr(10),'') as payer_bank_code --付款行清算行行号
,replace(replace(t1.real_payer_acct_no,chr(13),''),chr(10),'') as real_payer_acct_no --实际付款人账号
,replace(replace(t1.real_payer_acct_name,chr(13),''),chr(10),'') as real_payer_acct_name --实际付款人名称
,replace(replace(t1.real_payer_acct_type,chr(13),''),chr(10),'') as real_payer_acct_type --实际付款人账户类型
,replace(replace(t1.real_payer_host_type,chr(13),''),chr(10),'') as real_payer_host_type --实际付款人所属核心类型
,replace(replace(t1.ret_code,chr(13),''),chr(10),'') as ret_code --平台返回码
,replace(replace(t1.ret_msg,chr(13),''),chr(10),'') as ret_msg --平台返回码描述
,replace(replace(t1.is_limited,chr(13),''),chr(10),'') as is_limited --是否已累计客户限额,Y-已限额处理 N-未限额处理
,replace(replace(t1.action_type,chr(13),''),chr(10),'') as action_type --请求的业务接口类型，取值：ActionType
,replace(replace(t1.host_status,chr(13),''),chr(10),'') as host_status --交易核心账务状态
,t1.account_cnt as account_cnt --本次记账操作步骤总数
,replace(replace(t1.host_code_list,chr(13),''),chr(10),'') as host_code_list --请求的核心系统编码，适用于多核心业务系统（DEBIT_HOST-EAS_HOST）
,replace(replace(t1.host_no,chr(13),''),chr(10),'') as host_no --核心交易流水号
,replace(replace(t1.reverse_no,chr(13),''),chr(10),'') as reverse_no --核心冲正流水号
,replace(replace(t1.refunded,chr(13),''),chr(10),'') as refunded --是否已经退款，取值：BooleanEnum
,replace(replace(t1.pmc_code,chr(13),''),chr(10),'') as pmc_code --通道系统编码
,replace(replace(t1.pmc_no,chr(13),''),chr(10),'') as pmc_no --通道交易流水号
,replace(replace(t1.pmc_status,chr(13),''),chr(10),'') as pmc_status --通道原始状态值
,replace(replace(t1.pmc_ret_code,chr(13),''),chr(10),'') as pmc_ret_code --通道的原始返回码
,replace(replace(t1.pmc_ret_msg,chr(13),''),chr(10),'') as pmc_ret_msg --通道的原始返回码描述
,replace(replace(t1.pmc_date,chr(13),''),chr(10),'') as pmc_date --通道交易日期，无法获取时，取平台交易日期
,replace(replace(t1.pmc_time,chr(13),''),chr(10),'') as pmc_time --通道交易时间，无法获取时，取平台交易时间
,t1.pmc_cost as pmc_cost --通道成本费，单位：元
,t1.mcht_fee as mcht_fee --渠道交易手续费，单位：元
,replace(replace(t1.fee_no,chr(13),''),chr(10),'') as fee_no --渠道手续费记账流水号（核心流水）
,replace(replace(t1.fee_status,chr(13),''),chr(10),'') as fee_status --手续费计收状态，取值：FeeStatus
,replace(replace(t1.charge_type,chr(13),''),chr(10),'') as charge_type --计费类型，取值：ChargeTypeEnum
,replace(replace(t1.check_date,chr(13),''),chr(10),'') as check_date --对账日期，亦是通道认为的交易时间
,replace(replace(t1.checked,chr(13),''),chr(10),'') as checked --对账处理标识，取值：CheckedEnum
,replace(replace(t1.check_state,chr(13),''),chr(10),'') as check_state --对账状态，用于描述对账是对平或是具体差错类型
,replace(replace(t1.is_charge,chr(13),''),chr(10),'') as is_charge --是否收取手续费（Y-收取；N-不收取）
,replace(replace(t1.is_delay,chr(13),''),chr(10),'') as is_delay --是否需要延时转账（Y-需要延时转账；N-不需要延时转账）
,replace(replace(t1.delay_time,chr(13),''),chr(10),'') as delay_time --延时时间（以小时为单位）
,t1.fee_amount as fee_amount --客户手续费，一般与渠道交易手续费一致
,replace(replace(t1.chl_checking_code,chr(13),''),chr(10),'') as chl_checking_code --渠道对账产品代码
,replace(replace(t1.chl_check_date,chr(13),''),chr(10),'') as chl_check_date --渠道对账日期
,replace(replace(t1.auth_teller_no,chr(13),''),chr(10),'') as auth_teller_no --授权柜员号
,replace(replace(t1.check_teller_no,chr(13),''),chr(10),'') as check_teller_no --复核柜员号
,replace(replace(t1.trans_org_no,chr(13),''),chr(10),'') as trans_org_no --交易机构号
,replace(replace(t1.summery_code,chr(13),''),chr(10),'') as summery_code --交易机构号
,replace(replace(t1.consumer_id,chr(13),''),chr(10),'') as consumer_id --调用方系统ID
,replace(replace(t1.is_notify,chr(13),''),chr(10),'') as is_notify --是否需要异步通知（Y：接受；N：不接受）
,replace(replace(t1.notify_addr,chr(13),''),chr(10),'') as notify_addr --异步通知地址
,replace(replace(t1.notify_service_name,chr(13),''),chr(10),'') as notify_service_name --异步通知服务名称
,replace(replace(t1.payer_ext_map_id,chr(13),''),chr(10),'') as payer_ext_map_id --付款方扩展MAP编号
,replace(replace(t1.payee_ext_map_id,chr(13),''),chr(10),'') as payee_ext_map_id --收款方扩展MAP编号
,replace(replace(t1.route_map_id,chr(13),''),chr(10),'') as route_map_id --明细扩展MAP编号
,replace(replace(t1.host_desc,chr(13),''),chr(10),'') as host_desc --核心对账处理描述信息
,replace(replace(t1.channel_desc,chr(13),''),chr(10),'') as channel_desc --通道对账处理描述信息
,replace(replace(t1.balance_desc,chr(13),''),chr(10),'') as balance_desc --平衡性检查处理描述信息
,t1.check_time as check_time --对账处理时间，格式：yyyy-MM-dd HH:mm:ss
,replace(replace(t1.buiness_module,chr(13),''),chr(10),'') as buiness_module --LOCAL-本行；CROSS：跨行
,replace(replace(t1.init_mcht_no,chr(13),''),chr(10),'') as init_mcht_no --源发起渠道编号
,replace(replace(t1.sys_comm_no,chr(13),''),chr(10),'') as sys_comm_no --业务流水号
,replace(replace(t1.pmc_ret_no,chr(13),''),chr(10),'') as pmc_ret_no --通道响应流水号
,replace(replace(t1.pmc_ret_date,chr(13),''),chr(10),'') as pmc_ret_date --通道响应日期
,replace(replace(t1.pmc_ret_time,chr(13),''),chr(10),'') as pmc_ret_time --通道响应时间
,replace(replace(t1.pmc_ret_status,chr(13),''),chr(10),'') as pmc_ret_status --通道原始状态
,replace(replace(t1.mcht_check_mode,chr(13),''),chr(10),'') as mcht_check_mode --FIXED：渠道自定义对账；DEFAULT：系统默认对账代码对账
,replace(replace(t1.payer_bank_name,chr(13),''),chr(10),'') as payer_bank_name --付款行清算行行名
,replace(replace(t1.payee_bank_name,chr(13),''),chr(10),'') as payee_bank_name --收款行清算行行名
,replace(replace(t1.check_flag,chr(13),''),chr(10),'') as check_flag --对账标识（BALANCE-视作对平；NOT_CHECK-暂无需对账；PROCESSED-已处理）
,replace(replace(t1.host_date,chr(13),''),chr(10),'') as host_date --核心响应日期（会计日期）
,replace(replace(t1.host_time,chr(13),''),chr(10),'') as host_time --核心响应时间（会计时间）
,replace(replace(t1.acc_bean_json,chr(13),''),chr(10),'') as acc_bean_json --记账请求的bean报文信息（以json串存储）
,replace(replace(t1.clear_date,chr(13),''),chr(10),'') as clear_date --交易清算日期，给商户清算的日期，对账日期+对应清算类型的周期
,replace(replace(t1.cleared,chr(13),''),chr(10),'') as cleared --是否已经清算，取值：BooleanEnum
,replace(replace(t1.clear_no,chr(13),''),chr(10),'') as clear_no --清算流水号
,replace(replace(t1.clear_type,chr(13),''),chr(10),'') as clear_type --清算类型，取值：ClearTypeEnum
,t1.clear_cycle as clear_cycle --清算周期，实时清算时为0，周期清算时0~99
,replace(replace(t1.teller_no,chr(13),''),chr(10),'') as teller_no --交易柜员号
,replace(replace(t1.payee_phone,chr(13),''),chr(10),'') as payee_phone --收款方手机号
,replace(replace(t1.payee_valid_date,chr(13),''),chr(10),'') as payee_valid_date --收款方贷记卡有效期
,replace(replace(t1.payee_cvn2,chr(13),''),chr(10),'') as payee_cvn2 --收款方贷记卡安全码
,replace(replace(t1.biz_type,chr(13),''),chr(10),'') as biz_type --业务类型，例如：水电气缴费
,replace(replace(t1.sign_no,chr(13),''),chr(10),'') as sign_no --渠道协议签约号
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no --交易批次号
,replace(replace(t1.purpose,chr(13),''),chr(10),'') as purpose --交易附言
,replace(replace(t1.log_id,chr(13),''),chr(10),'') as log_id --交易日志文件ID
,replace(replace(t1.server_id,chr(13),''),chr(10),'') as server_id --交易服务器ID
,replace(replace(t1.sharding,chr(13),''),chr(10),'') as sharding --分库参考值专用字段，无业务含义
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注信息
,t1.create_time as create_time --流水创建时间，格式：yyyy-MM-dd HH:mm:ss
,t1.update_time as update_time --流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
,replace(replace(t1.trace_msg,chr(13),''),chr(10),'') as trace_msg --链路跟踪信息
,replace(replace(t1.advance_flag,chr(13),''),chr(10),'') as advance_flag --是否垫资标识(00：不垫支;1：垫支)
,replace(replace(t1.biz_sys_code,chr(13),''),chr(10),'') as biz_sys_code --业务所属系统
,replace(replace(t1.checking_code,chr(13),''),chr(10),'') as checking_code --内部对账代码/核心对账代码
,replace(replace(t1.business_code,chr(13),''),chr(10),'') as business_code --业务场景码
,replace(replace(t1.payee_cert_type,chr(13),''),chr(10),'') as payee_cert_type --收款人证件类型
,replace(replace(t1.payer_cert_type,chr(13),''),chr(10),'') as payer_cert_type --付款人证件类型
from ${iol_schema}.ppps_t_txn_credit t1    --平台贷记类交易交互流水表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ppps_t_txn_credit',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
