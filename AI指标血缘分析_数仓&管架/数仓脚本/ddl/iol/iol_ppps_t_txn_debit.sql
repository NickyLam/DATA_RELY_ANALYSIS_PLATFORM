/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_t_txn_debit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_t_txn_debit
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_t_txn_debit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_t_txn_debit(
    id number(20) -- 自增主键
    ,global_no varchar2(64) -- 全局流水号
    ,txn_no varchar2(64) -- 平台流水号
    ,txn_date varchar2(8) -- 平台交易日期，格式：yyyyMMdd
    ,txn_time varchar2(6) -- 平台交易时间，格式：HHmmss
    ,txn_type varchar2(2) -- 来往标识，往账-O，来账-I
    ,corporate varchar2(64) -- 法人标识
    ,mcht_no varchar2(32) -- 商户/支付机构编号
    ,tran_no varchar2(64) -- 商户交易流水号 / 交易流水号
    ,tran_date varchar2(8) -- 商户流水日期，格式：yyyyMMdd
    ,tran_time varchar2(20) -- 商户流水时间，格式：HHmmss
    ,product_no varchar2(24) -- 产品编号
    ,status varchar2(30) -- 交易处理状态，取值：StatusEnum
    ,biz_status varchar2(30) -- 
    ,trade_type varchar2(24) -- 交易类别，例如：协议支付，取值：TradeTypeEnum
    ,biz_type varchar2(24) -- 业务类型，例如：水电气缴费
    ,sign_no varchar2(64) -- 渠道协议签约号
    ,route_type varchar2(6) -- 交易路由方式，默认：自动，取值：RouteType
    ,priority varchar2(2) -- 交易时效，默认：R-实时，取值：PriorityEnum
    ,work_date varchar2(8) -- 工作日期
    ,batch_no varchar2(64) -- 交易批次号
    ,amount number(20,2) -- 交易金额，默认：零元-0.00，单位：元
    ,currency varchar2(4) -- 交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
    ,payer_acct_no varchar2(40) -- 付款方账号
    ,payer_acct_name nvarchar2(64) -- 付款方账户户名
    ,payer_acct_type varchar2(30) -- 付款方账号类别，取值：AcctTypeEnum
    ,payer_host_type varchar2(30) -- 
    ,payer_phone varchar2(24) -- 付款方手机号
    ,payer_valid_date varchar2(8) -- 付款方贷记卡有效期
    ,payer_cvn2 varchar2(4) -- 付款方贷记卡安全码
    ,payer_bank_code varchar2(24) -- 付款行清算行行号
    ,payee_acct_no varchar2(40) -- 收款方账号
    ,payee_acct_name nvarchar2(64) -- 收款方账户户名
    ,payee_acct_type varchar2(30) -- 收款方账号类别，取值：AcctTypeEnum
    ,payee_host_type varchar2(30) -- 
    ,payee_phone varchar2(24) -- 收款方手机号
    ,payee_valid_date varchar2(8) -- 收款方贷记卡有效期
    ,payee_cvn2 varchar2(4) -- 收款方贷记卡安全码
    ,payee_bank_code varchar2(24) -- 收款行清算行行号
    ,action_type varchar2(24) -- 请求的业务接口类型，取值：ActionType
    ,ret_code varchar2(64) -- 平台返回码
    ,ret_msg nvarchar2(512) -- 平台返回码描述
    ,host_status varchar2(30) -- 交易核心账务状态
    ,account_cnt number(10) -- 本次记账操作步骤总数
    ,host_code_list varchar2(120) -- 请求的核心系统编码，适用于多核心业务系统（DEBIT_HOST-EAS_HOST）
    ,host_no varchar2(64) -- 核心交易流水号
    ,reverse_no varchar2(64) -- 核心冲正流水号
    ,refunded varchar2(2) -- 是否已经退款，取值：BooleanEnum
    ,pmc_code varchar2(12) -- 通道系统编码
    ,pmc_no varchar2(64) -- 通道交易流水号
    ,pmc_status varchar2(12) -- 通道原始状态值
    ,pmc_ret_code varchar2(36) -- 通道的原始返回码
    ,pmc_ret_msg nvarchar2(512) -- 通道的原始返回码描述
    ,pmc_date varchar2(8) -- 通道交易日期，无法获取时，取平台交易日期
    ,pmc_time varchar2(6) -- 通道交易时间，无法获取时，取平台交易时间
    ,pmc_cost number(20,2) -- 通道成本费，单位：元
    ,mcht_fee number(20,2) -- 渠道交易手续费，单位：元
    ,fee_no varchar2(64) -- 渠道手续费记账流水号（核心流水）
    ,fee_status varchar2(12) -- 手续费计收状态，取值：FeeStatus
    ,charge_type varchar2(2) -- 计费类型，取值：ChargeTypeEnum
    ,check_date varchar2(8) -- 对账日期，亦是通道认为的交易时间
    ,checked varchar2(2) -- 对账处理标识，取值：CheckedEnum
    ,check_state varchar2(12) -- 对账状态，用于描述对账是对平或是具体差错类型
    ,is_charge varchar2(1) -- 是否收取手续费（Y-收取；N-不收取）
    ,fee_amount number(20,2) -- 客户手续费，一般与渠道交易手续费一致
    ,chl_checking_code varchar2(30) -- 渠道对账产品代码
    ,chl_check_date varchar2(8) -- 渠道对账日期
    ,auth_teller_no varchar2(30) -- 授权柜员号
    ,check_teller_no varchar2(30) -- 复核柜员号
    ,trans_org_no varchar2(30) -- 交易机构号
    ,summery_code varchar2(30) -- 交易摘要码
    ,consumer_id varchar2(30) -- 调用方系统ID
    ,is_notify varchar2(2) -- 
    ,notify_addr varchar2(100) -- 异步通知地址
    ,notify_service_name varchar2(60) -- 异步通知服务名称
    ,payer_ext_map_id varchar2(60) -- 
    ,payee_ext_map_id varchar2(60) -- 
    ,route_map_id varchar2(60) -- 
    ,host_desc varchar2(256) -- 核心对账处理描述信息
    ,channel_desc varchar2(256) -- 通道对账处理描述信息
    ,balance_desc varchar2(256) -- 平衡性检查处理描述信息
    ,check_time date -- 对账处理时间，格式：yyyy-MM-dd HH:mm:ss
    ,buiness_module varchar2(32) -- LOCAL-本行；CROSS：跨行
    ,advance_flag varchar2(2) -- 是否垫资00：不垫支 01：垫支
    ,init_mcht_no varchar2(64) -- 源发起渠道编号
    ,sys_comm_no varchar2(64) -- 业务流水号
    ,book_type varchar2(2) -- 00：渠道账 01：客户账
    ,pmc_ret_no varchar2(64) -- 通道响应流水号
    ,pmc_ret_date varchar2(8) -- 通道响应日期
    ,pmc_ret_time varchar2(20) -- 通道响应时间
    ,pmc_ret_status varchar2(20) -- 
    ,mcht_check_mode varchar2(32) -- FIXED：渠道自定义对账；DEFAULT：系统默认对账代码对账
    ,payer_bank_name varchar2(256) -- 付款行清算行行名
    ,payee_bank_name varchar2(256) -- 收款行清算行行名
    ,check_flag varchar2(30) -- 对账标识（BALANCE-视作对平；NOT_CHECK-暂无需对账；PROCESSED-已处理）
    ,host_date varchar2(8) -- 核心响应日期（会计日期）
    ,host_time varchar2(6) -- 核心响应时间（会计时间）
    ,acc_bean_json varchar2(3000) -- 记账请求的bean报文信息（以json串存储）
    ,payer_cert_type varchar2(50) -- 证件类型
    ,payer_cert_no varchar2(50) -- 证件号码
    ,clear_date varchar2(8) -- 交易清算日期，给商户清算的日期，对账日期+对应清算类型的周期
    ,cleared varchar2(2) -- 是否已经清算，取值：BooleanEnum
    ,clear_no varchar2(64) -- 清算流水号
    ,clear_type varchar2(2) -- 清算类型，取值：ClearTypeEnum
    ,clear_cycle number(11) -- 清算周期，实时清算时为0，周期清算时0~99
    ,purpose varchar2(384) -- 交易附言
    ,teller_no varchar2(64) -- 交易柜员号
    ,log_id varchar2(64) -- 交易日志文件ID
    ,server_id varchar2(64) -- 交易服务器ID
    ,sharding varchar2(64) -- 分库参考值专用字段，无业务含义
    ,remark nvarchar2(128) -- 备注信息
    ,create_time date -- 流水创建时间，格式：yyyy-MM-dd HH:mm:ss
    ,update_time date -- 流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
    ,trace_msg varchar2(256) -- 链路跟踪信息
    ,checking_code varchar2(256) -- 内部对账代码/核心对账代码
    ,real_payee_acct_no varchar2(30) -- 实际收款人账号
    ,real_payee_acct_name varchar2(128) -- 实际收款人名称
    ,real_payee_acct_type varchar2(30) -- 实际收款人账户类型
    ,real_payee_host_type varchar2(20) -- 实际收款人所属核心类型
    ,sch_id varchar2(30) -- 学校编号
    ,stud_name varchar2(50) -- 学生姓名
    ,one_card_solu_sch_num varchar2(60) -- 校园卡卡号
    ,sch_card_typ varchar2(1) -- 
    ,curr_pay_noti_sing_id varchar2(64) -- 缴费通知单id
    ,transaction_id varchar2(64) -- 订单号
    ,payee_cert_type varchar2(4) -- 收款人证件类型
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
grant select on ${iol_schema}.ppps_t_txn_debit to ${iml_schema};
grant select on ${iol_schema}.ppps_t_txn_debit to ${icl_schema};
grant select on ${iol_schema}.ppps_t_txn_debit to ${idl_schema};
grant select on ${iol_schema}.ppps_t_txn_debit to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_t_txn_debit is '平台借记类交易交互流水表';
comment on column ${iol_schema}.ppps_t_txn_debit.id is '自增主键';
comment on column ${iol_schema}.ppps_t_txn_debit.global_no is '全局流水号';
comment on column ${iol_schema}.ppps_t_txn_debit.txn_no is '平台流水号';
comment on column ${iol_schema}.ppps_t_txn_debit.txn_date is '平台交易日期，格式：yyyyMMdd';
comment on column ${iol_schema}.ppps_t_txn_debit.txn_time is '平台交易时间，格式：HHmmss';
comment on column ${iol_schema}.ppps_t_txn_debit.txn_type is '来往标识，往账-O，来账-I';
comment on column ${iol_schema}.ppps_t_txn_debit.corporate is '法人标识';
comment on column ${iol_schema}.ppps_t_txn_debit.mcht_no is '商户/支付机构编号';
comment on column ${iol_schema}.ppps_t_txn_debit.tran_no is '商户交易流水号 / 交易流水号';
comment on column ${iol_schema}.ppps_t_txn_debit.tran_date is '商户流水日期，格式：yyyyMMdd';
comment on column ${iol_schema}.ppps_t_txn_debit.tran_time is '商户流水时间，格式：HHmmss';
comment on column ${iol_schema}.ppps_t_txn_debit.product_no is '产品编号';
comment on column ${iol_schema}.ppps_t_txn_debit.status is '交易处理状态，取值：StatusEnum';
comment on column ${iol_schema}.ppps_t_txn_debit.biz_status is '';
comment on column ${iol_schema}.ppps_t_txn_debit.trade_type is '交易类别，例如：协议支付，取值：TradeTypeEnum';
comment on column ${iol_schema}.ppps_t_txn_debit.biz_type is '业务类型，例如：水电气缴费';
comment on column ${iol_schema}.ppps_t_txn_debit.sign_no is '渠道协议签约号';
comment on column ${iol_schema}.ppps_t_txn_debit.route_type is '交易路由方式，默认：自动，取值：RouteType';
comment on column ${iol_schema}.ppps_t_txn_debit.priority is '交易时效，默认：R-实时，取值：PriorityEnum';
comment on column ${iol_schema}.ppps_t_txn_debit.work_date is '工作日期';
comment on column ${iol_schema}.ppps_t_txn_debit.batch_no is '交易批次号';
comment on column ${iol_schema}.ppps_t_txn_debit.amount is '交易金额，默认：零元-0.00，单位：元';
comment on column ${iol_schema}.ppps_t_txn_debit.currency is '交易币种标识，默认：CNY-人民币，取值：CurrencyEnum';
comment on column ${iol_schema}.ppps_t_txn_debit.payer_acct_no is '付款方账号';
comment on column ${iol_schema}.ppps_t_txn_debit.payer_acct_name is '付款方账户户名';
comment on column ${iol_schema}.ppps_t_txn_debit.payer_acct_type is '付款方账号类别，取值：AcctTypeEnum';
comment on column ${iol_schema}.ppps_t_txn_debit.payer_host_type is '';
comment on column ${iol_schema}.ppps_t_txn_debit.payer_phone is '付款方手机号';
comment on column ${iol_schema}.ppps_t_txn_debit.payer_valid_date is '付款方贷记卡有效期';
comment on column ${iol_schema}.ppps_t_txn_debit.payer_cvn2 is '付款方贷记卡安全码';
comment on column ${iol_schema}.ppps_t_txn_debit.payer_bank_code is '付款行清算行行号';
comment on column ${iol_schema}.ppps_t_txn_debit.payee_acct_no is '收款方账号';
comment on column ${iol_schema}.ppps_t_txn_debit.payee_acct_name is '收款方账户户名';
comment on column ${iol_schema}.ppps_t_txn_debit.payee_acct_type is '收款方账号类别，取值：AcctTypeEnum';
comment on column ${iol_schema}.ppps_t_txn_debit.payee_host_type is '';
comment on column ${iol_schema}.ppps_t_txn_debit.payee_phone is '收款方手机号';
comment on column ${iol_schema}.ppps_t_txn_debit.payee_valid_date is '收款方贷记卡有效期';
comment on column ${iol_schema}.ppps_t_txn_debit.payee_cvn2 is '收款方贷记卡安全码';
comment on column ${iol_schema}.ppps_t_txn_debit.payee_bank_code is '收款行清算行行号';
comment on column ${iol_schema}.ppps_t_txn_debit.action_type is '请求的业务接口类型，取值：ActionType';
comment on column ${iol_schema}.ppps_t_txn_debit.ret_code is '平台返回码';
comment on column ${iol_schema}.ppps_t_txn_debit.ret_msg is '平台返回码描述';
comment on column ${iol_schema}.ppps_t_txn_debit.host_status is '交易核心账务状态';
comment on column ${iol_schema}.ppps_t_txn_debit.account_cnt is '本次记账操作步骤总数';
comment on column ${iol_schema}.ppps_t_txn_debit.host_code_list is '请求的核心系统编码，适用于多核心业务系统（DEBIT_HOST-EAS_HOST）';
comment on column ${iol_schema}.ppps_t_txn_debit.host_no is '核心交易流水号';
comment on column ${iol_schema}.ppps_t_txn_debit.reverse_no is '核心冲正流水号';
comment on column ${iol_schema}.ppps_t_txn_debit.refunded is '是否已经退款，取值：BooleanEnum';
comment on column ${iol_schema}.ppps_t_txn_debit.pmc_code is '通道系统编码';
comment on column ${iol_schema}.ppps_t_txn_debit.pmc_no is '通道交易流水号';
comment on column ${iol_schema}.ppps_t_txn_debit.pmc_status is '通道原始状态值';
comment on column ${iol_schema}.ppps_t_txn_debit.pmc_ret_code is '通道的原始返回码';
comment on column ${iol_schema}.ppps_t_txn_debit.pmc_ret_msg is '通道的原始返回码描述';
comment on column ${iol_schema}.ppps_t_txn_debit.pmc_date is '通道交易日期，无法获取时，取平台交易日期';
comment on column ${iol_schema}.ppps_t_txn_debit.pmc_time is '通道交易时间，无法获取时，取平台交易时间';
comment on column ${iol_schema}.ppps_t_txn_debit.pmc_cost is '通道成本费，单位：元';
comment on column ${iol_schema}.ppps_t_txn_debit.mcht_fee is '渠道交易手续费，单位：元';
comment on column ${iol_schema}.ppps_t_txn_debit.fee_no is '渠道手续费记账流水号（核心流水）';
comment on column ${iol_schema}.ppps_t_txn_debit.fee_status is '手续费计收状态，取值：FeeStatus';
comment on column ${iol_schema}.ppps_t_txn_debit.charge_type is '计费类型，取值：ChargeTypeEnum';
comment on column ${iol_schema}.ppps_t_txn_debit.check_date is '对账日期，亦是通道认为的交易时间';
comment on column ${iol_schema}.ppps_t_txn_debit.checked is '对账处理标识，取值：CheckedEnum';
comment on column ${iol_schema}.ppps_t_txn_debit.check_state is '对账状态，用于描述对账是对平或是具体差错类型';
comment on column ${iol_schema}.ppps_t_txn_debit.is_charge is '是否收取手续费（Y-收取；N-不收取）';
comment on column ${iol_schema}.ppps_t_txn_debit.fee_amount is '客户手续费，一般与渠道交易手续费一致';
comment on column ${iol_schema}.ppps_t_txn_debit.chl_checking_code is '渠道对账产品代码';
comment on column ${iol_schema}.ppps_t_txn_debit.chl_check_date is '渠道对账日期';
comment on column ${iol_schema}.ppps_t_txn_debit.auth_teller_no is '授权柜员号';
comment on column ${iol_schema}.ppps_t_txn_debit.check_teller_no is '复核柜员号';
comment on column ${iol_schema}.ppps_t_txn_debit.trans_org_no is '交易机构号';
comment on column ${iol_schema}.ppps_t_txn_debit.summery_code is '交易摘要码';
comment on column ${iol_schema}.ppps_t_txn_debit.consumer_id is '调用方系统ID';
comment on column ${iol_schema}.ppps_t_txn_debit.is_notify is '';
comment on column ${iol_schema}.ppps_t_txn_debit.notify_addr is '异步通知地址';
comment on column ${iol_schema}.ppps_t_txn_debit.notify_service_name is '异步通知服务名称';
comment on column ${iol_schema}.ppps_t_txn_debit.payer_ext_map_id is '';
comment on column ${iol_schema}.ppps_t_txn_debit.payee_ext_map_id is '';
comment on column ${iol_schema}.ppps_t_txn_debit.route_map_id is '';
comment on column ${iol_schema}.ppps_t_txn_debit.host_desc is '核心对账处理描述信息';
comment on column ${iol_schema}.ppps_t_txn_debit.channel_desc is '通道对账处理描述信息';
comment on column ${iol_schema}.ppps_t_txn_debit.balance_desc is '平衡性检查处理描述信息';
comment on column ${iol_schema}.ppps_t_txn_debit.check_time is '对账处理时间，格式：yyyy-MM-dd HH:mm:ss';
comment on column ${iol_schema}.ppps_t_txn_debit.buiness_module is 'LOCAL-本行；CROSS：跨行';
comment on column ${iol_schema}.ppps_t_txn_debit.advance_flag is '是否垫资00：不垫支 01：垫支';
comment on column ${iol_schema}.ppps_t_txn_debit.init_mcht_no is '源发起渠道编号';
comment on column ${iol_schema}.ppps_t_txn_debit.sys_comm_no is '业务流水号';
comment on column ${iol_schema}.ppps_t_txn_debit.book_type is '00：渠道账 01：客户账';
comment on column ${iol_schema}.ppps_t_txn_debit.pmc_ret_no is '通道响应流水号';
comment on column ${iol_schema}.ppps_t_txn_debit.pmc_ret_date is '通道响应日期';
comment on column ${iol_schema}.ppps_t_txn_debit.pmc_ret_time is '通道响应时间';
comment on column ${iol_schema}.ppps_t_txn_debit.pmc_ret_status is '';
comment on column ${iol_schema}.ppps_t_txn_debit.mcht_check_mode is 'FIXED：渠道自定义对账；DEFAULT：系统默认对账代码对账';
comment on column ${iol_schema}.ppps_t_txn_debit.payer_bank_name is '付款行清算行行名';
comment on column ${iol_schema}.ppps_t_txn_debit.payee_bank_name is '收款行清算行行名';
comment on column ${iol_schema}.ppps_t_txn_debit.check_flag is '对账标识（BALANCE-视作对平；NOT_CHECK-暂无需对账；PROCESSED-已处理）';
comment on column ${iol_schema}.ppps_t_txn_debit.host_date is '核心响应日期（会计日期）';
comment on column ${iol_schema}.ppps_t_txn_debit.host_time is '核心响应时间（会计时间）';
comment on column ${iol_schema}.ppps_t_txn_debit.acc_bean_json is '记账请求的bean报文信息（以json串存储）';
comment on column ${iol_schema}.ppps_t_txn_debit.payer_cert_type is '证件类型';
comment on column ${iol_schema}.ppps_t_txn_debit.payer_cert_no is '证件号码';
comment on column ${iol_schema}.ppps_t_txn_debit.clear_date is '交易清算日期，给商户清算的日期，对账日期+对应清算类型的周期';
comment on column ${iol_schema}.ppps_t_txn_debit.cleared is '是否已经清算，取值：BooleanEnum';
comment on column ${iol_schema}.ppps_t_txn_debit.clear_no is '清算流水号';
comment on column ${iol_schema}.ppps_t_txn_debit.clear_type is '清算类型，取值：ClearTypeEnum';
comment on column ${iol_schema}.ppps_t_txn_debit.clear_cycle is '清算周期，实时清算时为0，周期清算时0~99';
comment on column ${iol_schema}.ppps_t_txn_debit.purpose is '交易附言';
comment on column ${iol_schema}.ppps_t_txn_debit.teller_no is '交易柜员号';
comment on column ${iol_schema}.ppps_t_txn_debit.log_id is '交易日志文件ID';
comment on column ${iol_schema}.ppps_t_txn_debit.server_id is '交易服务器ID';
comment on column ${iol_schema}.ppps_t_txn_debit.sharding is '分库参考值专用字段，无业务含义';
comment on column ${iol_schema}.ppps_t_txn_debit.remark is '备注信息';
comment on column ${iol_schema}.ppps_t_txn_debit.create_time is '流水创建时间，格式：yyyy-MM-dd HH:mm:ss';
comment on column ${iol_schema}.ppps_t_txn_debit.update_time is '流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss';
comment on column ${iol_schema}.ppps_t_txn_debit.trace_msg is '链路跟踪信息';
comment on column ${iol_schema}.ppps_t_txn_debit.checking_code is '内部对账代码/核心对账代码';
comment on column ${iol_schema}.ppps_t_txn_debit.real_payee_acct_no is '实际收款人账号';
comment on column ${iol_schema}.ppps_t_txn_debit.real_payee_acct_name is '实际收款人名称';
comment on column ${iol_schema}.ppps_t_txn_debit.real_payee_acct_type is '实际收款人账户类型';
comment on column ${iol_schema}.ppps_t_txn_debit.real_payee_host_type is '实际收款人所属核心类型';
comment on column ${iol_schema}.ppps_t_txn_debit.sch_id is '学校编号';
comment on column ${iol_schema}.ppps_t_txn_debit.stud_name is '学生姓名';
comment on column ${iol_schema}.ppps_t_txn_debit.one_card_solu_sch_num is '校园卡卡号';
comment on column ${iol_schema}.ppps_t_txn_debit.sch_card_typ is '';
comment on column ${iol_schema}.ppps_t_txn_debit.curr_pay_noti_sing_id is '缴费通知单id';
comment on column ${iol_schema}.ppps_t_txn_debit.transaction_id is '订单号';
comment on column ${iol_schema}.ppps_t_txn_debit.payee_cert_type is '收款人证件类型';
comment on column ${iol_schema}.ppps_t_txn_debit.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ppps_t_txn_debit.etl_timestamp is 'ETL处理时间戳';
