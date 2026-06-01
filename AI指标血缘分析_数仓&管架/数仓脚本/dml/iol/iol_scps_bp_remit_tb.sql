/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_bp_remit_tb
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
create table ${iol_schema}.scps_bp_remit_tb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scps_bp_remit_tb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_remit_tb_op purge;
drop table ${iol_schema}.scps_bp_remit_tb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_remit_tb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_remit_tb where 0=1;

create table ${iol_schema}.scps_bp_remit_tb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_remit_tb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_remit_tb_cl(
            task_id -- 任务号
            ,trans_date -- 交易日期（yyyyMMdd)
            ,trans_time -- 交易时间
            ,trans_state -- 处理状态[1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]
            ,trans_channel -- 业务渠道
            ,business_code -- 业务场景码
            ,user_id -- 交易柜员编号
            ,charge_id -- 授权柜员号
            ,branch_code -- 前台机构号
            ,business_kind -- 业务种类 1-对私业务、2-对公业务
            ,business_type -- 业务类型 1.普通汇兑（对公结算户） 2.普通汇兑（内部户） 3.公益性资金汇划 4.国库汇款
            ,voucher_code -- 凭证代码 786-结算业务委托书、780-支票、999-其他
            ,voucher_no -- 凭证号码
            ,cust_no -- 客户号 本行付款人时才有
            ,cust_name -- 客户名称
            ,transfer_type -- 现转标志0-现金、1-转账、2-其他（非资金类交易）
            ,currency_code -- 币种
            ,pay_channel -- 支付渠道(1-现代化支付系统大额系统、2-现代化支付系统小额系统)
            ,pay_type -- 支取方式 (空)-无 A-密码D-印鉴E-证件F-印密G-支付密码H-无限制I-印鉴加支付密码
            ,drawee_name -- 付款人名称
            ,drawee_acct_no -- 交易对手账号
            ,drawee_cert_type -- 交易对手证件类型
            ,drawee_cert_no -- 交易对手证件号码
            ,drawee_cert_date -- 付款人证件到期日 格式yyyyMMdd
            ,drawee_phone -- 付款人联系方式 可以是固话或手机
            ,payee_name -- 交易对手名称
            ,payee_acct_no -- 收款人账号
            ,trans_amount -- 交易金额 例如100.00
            ,trans_amount_ch -- 交易金额(大写)
            ,is_proxy -- 是否代理 0-不代理，1-代理
            ,proxy_name -- 代办人姓名
            ,proxy_cert_type -- 代办人证件类型
            ,proxy_cert_no -- 代办人证件号码
            ,proxy_cert_date -- 交易代办人证件到期日期
            ,fee_type -- 收费方式
            ,fee_amount -- 手续费
            ,remit_priority -- 汇兑优先级 1-普通2-加急3-次日
            ,city_priority -- 同城异地 1-同城、2-异地(保留)
            ,trans_method -- 交易方式 010106-信汇 010104-电汇 000001-银行承兑汇票 000003-本票 000151-其他
            ,purpose -- 用途（附言）
            ,transfer_reason -- 转账原因
            ,debt_flag -- 入账标志 0-未入帐1-已入帐
            ,drawee_bank_no -- 付款行名号
            ,drawee_bank_name -- 付款行名称
            ,payee_bank_no -- 收款行行号
            ,payee_bank_name -- 收款行名称
            ,bill_date -- 出票日期 格式yyyyMMdd
            ,return_reason -- 退票理由
            ,ticket_type -- 票据类型 1支票，2银行汇票3银行本票
            ,ticket_count -- 票据张数
            ,ticket_no -- 票据号码
            ,call_result -- 外呼结果 外呼结果(1-查证成功，2-查证失败，3-查证不通)
            ,call_person_num -- 外呼应呼人数
            ,call_timeout_flag -- 外呼强制超时 0-不强制超时1-强制超时
            ,call_timeout_user_id -- 外呼强制超时操作柜员
            ,call_timeout_charge_id -- 外呼强制超时授权柜员
            ,drawee_address -- 付款人地址
            ,payee_address -- 收款人地址
            ,post_fee -- 汇划费
            ,cost_fee -- 工本费
            ,remark -- 摘要码
            ,payee_corp_flag -- 收款人个人对公标志
            ,withhold_acct_no -- 实际扣帐账号 内部账户时必输
            ,withhold_acct_name -- 实际扣帐户名 内部账户时必输
            ,inside_acct_flag -- 内部账户标识 0非内部账户 1内部账户
            ,pay_send_seqno -- 发送支付系统报文流水号
            ,pay_host_seqno -- 支付系统响应的主机流水
            ,pay_business_no -- 支付系统业务序号
            ,pay_send_date -- 支付报文交易日期
            ,pay_host_date -- 支付主机交易日期
            ,drawee_core_tel -- 付款人核心联系方式
            ,tally_state -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
            ,tally_flow_no -- 记账报文流水号
            ,tally_host_no -- 记账核心交易流水
            ,tally_host_date -- 核心交易日期
            ,submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
            ,drawee_info_send_flag -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
            ,drawee_info_send_result -- 收款人信息处理结果 处理结果描述
            ,drawee_info_send_time -- 收款人信息处理时间  格式为yyyy-MM-dd
            ,pre_task_id -- 预受理任务编号
            ,pre_task_status -- 预受理任务状态 0-已受理，1-预审通过，2-预审不通过，3-已超期，4-作废
            ,pre_task_result -- 预审核结论
            ,pre_task_approve_user -- 预受理任务审核提交用户
            ,pre_task_approve_time -- 预受理任务审核时间（yyyy-MM-dd hh:mm:ss）
            ,endorser_num -- 背书人数
            ,endorsers -- 最后一手背书人
            ,unfreeze_flow_no -- 流水号-作为对账流水、解冻时的原流水号（UPP流水）
            ,passbook_voucher_no -- 存折凭证号码
            ,acct_level -- SECOND-ACCT:二类户；THIRD-ACCT:三类户
            ,delay_flag -- 是否延迟结算,1-是，2-否
            ,acct_nature -- 账户性质[JJSB-基金社保 CZCK-财政性存款 GJJ-公积金 QT-其他]
            ,regulator_flag -- 监管账户标识，0-无，1-监管账户
            ,transfer_flag -- 行内转账标识 1-行内转账 其他-行外
            ,payee_acct_level -- 收款方账户级别
            ,payee_cust_type -- 客户类型 1-个人客户 2-对公客户 3-同业客户 4-内部客户
            ,pay_acct_type -- 付款人账户类型
            ,doc_id -- 影像ID
            ,glob_seq_num -- 全局流水号
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,organ_no -- 机构号
            ,pay_name -- 付款人名称
            ,pay_acct_no -- 付款人账号
            ,vouch_group -- 业务场景凭证组合
            ,model_code -- 影像模型
            ,busi_start_date -- 影像上传时间
            ,over_amt -- 法透金额
            ,open_br_no -- 付款人开户机构
            ,budg_level -- 预算级次
            ,cnter_acct_date -- 柜面记账日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_remit_tb_op(
            task_id -- 任务号
            ,trans_date -- 交易日期（yyyyMMdd)
            ,trans_time -- 交易时间
            ,trans_state -- 处理状态[1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]
            ,trans_channel -- 业务渠道
            ,business_code -- 业务场景码
            ,user_id -- 交易柜员编号
            ,charge_id -- 授权柜员号
            ,branch_code -- 前台机构号
            ,business_kind -- 业务种类 1-对私业务、2-对公业务
            ,business_type -- 业务类型 1.普通汇兑（对公结算户） 2.普通汇兑（内部户） 3.公益性资金汇划 4.国库汇款
            ,voucher_code -- 凭证代码 786-结算业务委托书、780-支票、999-其他
            ,voucher_no -- 凭证号码
            ,cust_no -- 客户号 本行付款人时才有
            ,cust_name -- 客户名称
            ,transfer_type -- 现转标志0-现金、1-转账、2-其他（非资金类交易）
            ,currency_code -- 币种
            ,pay_channel -- 支付渠道(1-现代化支付系统大额系统、2-现代化支付系统小额系统)
            ,pay_type -- 支取方式 (空)-无 A-密码D-印鉴E-证件F-印密G-支付密码H-无限制I-印鉴加支付密码
            ,drawee_name -- 付款人名称
            ,drawee_acct_no -- 交易对手账号
            ,drawee_cert_type -- 交易对手证件类型
            ,drawee_cert_no -- 交易对手证件号码
            ,drawee_cert_date -- 付款人证件到期日 格式yyyyMMdd
            ,drawee_phone -- 付款人联系方式 可以是固话或手机
            ,payee_name -- 交易对手名称
            ,payee_acct_no -- 收款人账号
            ,trans_amount -- 交易金额 例如100.00
            ,trans_amount_ch -- 交易金额(大写)
            ,is_proxy -- 是否代理 0-不代理，1-代理
            ,proxy_name -- 代办人姓名
            ,proxy_cert_type -- 代办人证件类型
            ,proxy_cert_no -- 代办人证件号码
            ,proxy_cert_date -- 交易代办人证件到期日期
            ,fee_type -- 收费方式
            ,fee_amount -- 手续费
            ,remit_priority -- 汇兑优先级 1-普通2-加急3-次日
            ,city_priority -- 同城异地 1-同城、2-异地(保留)
            ,trans_method -- 交易方式 010106-信汇 010104-电汇 000001-银行承兑汇票 000003-本票 000151-其他
            ,purpose -- 用途（附言）
            ,transfer_reason -- 转账原因
            ,debt_flag -- 入账标志 0-未入帐1-已入帐
            ,drawee_bank_no -- 付款行名号
            ,drawee_bank_name -- 付款行名称
            ,payee_bank_no -- 收款行行号
            ,payee_bank_name -- 收款行名称
            ,bill_date -- 出票日期 格式yyyyMMdd
            ,return_reason -- 退票理由
            ,ticket_type -- 票据类型 1支票，2银行汇票3银行本票
            ,ticket_count -- 票据张数
            ,ticket_no -- 票据号码
            ,call_result -- 外呼结果 外呼结果(1-查证成功，2-查证失败，3-查证不通)
            ,call_person_num -- 外呼应呼人数
            ,call_timeout_flag -- 外呼强制超时 0-不强制超时1-强制超时
            ,call_timeout_user_id -- 外呼强制超时操作柜员
            ,call_timeout_charge_id -- 外呼强制超时授权柜员
            ,drawee_address -- 付款人地址
            ,payee_address -- 收款人地址
            ,post_fee -- 汇划费
            ,cost_fee -- 工本费
            ,remark -- 摘要码
            ,payee_corp_flag -- 收款人个人对公标志
            ,withhold_acct_no -- 实际扣帐账号 内部账户时必输
            ,withhold_acct_name -- 实际扣帐户名 内部账户时必输
            ,inside_acct_flag -- 内部账户标识 0非内部账户 1内部账户
            ,pay_send_seqno -- 发送支付系统报文流水号
            ,pay_host_seqno -- 支付系统响应的主机流水
            ,pay_business_no -- 支付系统业务序号
            ,pay_send_date -- 支付报文交易日期
            ,pay_host_date -- 支付主机交易日期
            ,drawee_core_tel -- 付款人核心联系方式
            ,tally_state -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
            ,tally_flow_no -- 记账报文流水号
            ,tally_host_no -- 记账核心交易流水
            ,tally_host_date -- 核心交易日期
            ,submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
            ,drawee_info_send_flag -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
            ,drawee_info_send_result -- 收款人信息处理结果 处理结果描述
            ,drawee_info_send_time -- 收款人信息处理时间  格式为yyyy-MM-dd
            ,pre_task_id -- 预受理任务编号
            ,pre_task_status -- 预受理任务状态 0-已受理，1-预审通过，2-预审不通过，3-已超期，4-作废
            ,pre_task_result -- 预审核结论
            ,pre_task_approve_user -- 预受理任务审核提交用户
            ,pre_task_approve_time -- 预受理任务审核时间（yyyy-MM-dd hh:mm:ss）
            ,endorser_num -- 背书人数
            ,endorsers -- 最后一手背书人
            ,unfreeze_flow_no -- 流水号-作为对账流水、解冻时的原流水号（UPP流水）
            ,passbook_voucher_no -- 存折凭证号码
            ,acct_level -- SECOND-ACCT:二类户；THIRD-ACCT:三类户
            ,delay_flag -- 是否延迟结算,1-是，2-否
            ,acct_nature -- 账户性质[JJSB-基金社保 CZCK-财政性存款 GJJ-公积金 QT-其他]
            ,regulator_flag -- 监管账户标识，0-无，1-监管账户
            ,transfer_flag -- 行内转账标识 1-行内转账 其他-行外
            ,payee_acct_level -- 收款方账户级别
            ,payee_cust_type -- 客户类型 1-个人客户 2-对公客户 3-同业客户 4-内部客户
            ,pay_acct_type -- 付款人账户类型
            ,doc_id -- 影像ID
            ,glob_seq_num -- 全局流水号
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,organ_no -- 机构号
            ,pay_name -- 付款人名称
            ,pay_acct_no -- 付款人账号
            ,vouch_group -- 业务场景凭证组合
            ,model_code -- 影像模型
            ,busi_start_date -- 影像上传时间
            ,over_amt -- 法透金额
            ,open_br_no -- 付款人开户机构
            ,budg_level -- 预算级次
            ,cnter_acct_date -- 柜面记账日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.task_id, o.task_id) as task_id -- 任务号
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 交易日期（yyyyMMdd)
    ,nvl(n.trans_time, o.trans_time) as trans_time -- 交易时间
    ,nvl(n.trans_state, o.trans_state) as trans_state -- 处理状态[1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]
    ,nvl(n.trans_channel, o.trans_channel) as trans_channel -- 业务渠道
    ,nvl(n.business_code, o.business_code) as business_code -- 业务场景码
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.charge_id, o.charge_id) as charge_id -- 授权柜员号
    ,nvl(n.branch_code, o.branch_code) as branch_code -- 前台机构号
    ,nvl(n.business_kind, o.business_kind) as business_kind -- 业务种类 1-对私业务、2-对公业务
    ,nvl(n.business_type, o.business_type) as business_type -- 业务类型 1.普通汇兑（对公结算户） 2.普通汇兑（内部户） 3.公益性资金汇划 4.国库汇款
    ,nvl(n.voucher_code, o.voucher_code) as voucher_code -- 凭证代码 786-结算业务委托书、780-支票、999-其他
    ,nvl(n.voucher_no, o.voucher_no) as voucher_no -- 凭证号码
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号 本行付款人时才有
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.transfer_type, o.transfer_type) as transfer_type -- 现转标志0-现金、1-转账、2-其他（非资金类交易）
    ,nvl(n.currency_code, o.currency_code) as currency_code -- 币种
    ,nvl(n.pay_channel, o.pay_channel) as pay_channel -- 支付渠道(1-现代化支付系统大额系统、2-现代化支付系统小额系统)
    ,nvl(n.pay_type, o.pay_type) as pay_type -- 支取方式 (空)-无 A-密码D-印鉴E-证件F-印密G-支付密码H-无限制I-印鉴加支付密码
    ,nvl(n.drawee_name, o.drawee_name) as drawee_name -- 付款人名称
    ,nvl(n.drawee_acct_no, o.drawee_acct_no) as drawee_acct_no -- 交易对手账号
    ,nvl(n.drawee_cert_type, o.drawee_cert_type) as drawee_cert_type -- 交易对手证件类型
    ,nvl(n.drawee_cert_no, o.drawee_cert_no) as drawee_cert_no -- 交易对手证件号码
    ,nvl(n.drawee_cert_date, o.drawee_cert_date) as drawee_cert_date -- 付款人证件到期日 格式yyyyMMdd
    ,nvl(n.drawee_phone, o.drawee_phone) as drawee_phone -- 付款人联系方式 可以是固话或手机
    ,nvl(n.payee_name, o.payee_name) as payee_name -- 交易对手名称
    ,nvl(n.payee_acct_no, o.payee_acct_no) as payee_acct_no -- 收款人账号
    ,nvl(n.trans_amount, o.trans_amount) as trans_amount -- 交易金额 例如100.00
    ,nvl(n.trans_amount_ch, o.trans_amount_ch) as trans_amount_ch -- 交易金额(大写)
    ,nvl(n.is_proxy, o.is_proxy) as is_proxy -- 是否代理 0-不代理，1-代理
    ,nvl(n.proxy_name, o.proxy_name) as proxy_name -- 代办人姓名
    ,nvl(n.proxy_cert_type, o.proxy_cert_type) as proxy_cert_type -- 代办人证件类型
    ,nvl(n.proxy_cert_no, o.proxy_cert_no) as proxy_cert_no -- 代办人证件号码
    ,nvl(n.proxy_cert_date, o.proxy_cert_date) as proxy_cert_date -- 交易代办人证件到期日期
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 收费方式
    ,nvl(n.fee_amount, o.fee_amount) as fee_amount -- 手续费
    ,nvl(n.remit_priority, o.remit_priority) as remit_priority -- 汇兑优先级 1-普通2-加急3-次日
    ,nvl(n.city_priority, o.city_priority) as city_priority -- 同城异地 1-同城、2-异地(保留)
    ,nvl(n.trans_method, o.trans_method) as trans_method -- 交易方式 010106-信汇 010104-电汇 000001-银行承兑汇票 000003-本票 000151-其他
    ,nvl(n.purpose, o.purpose) as purpose -- 用途（附言）
    ,nvl(n.transfer_reason, o.transfer_reason) as transfer_reason -- 转账原因
    ,nvl(n.debt_flag, o.debt_flag) as debt_flag -- 入账标志 0-未入帐1-已入帐
    ,nvl(n.drawee_bank_no, o.drawee_bank_no) as drawee_bank_no -- 付款行名号
    ,nvl(n.drawee_bank_name, o.drawee_bank_name) as drawee_bank_name -- 付款行名称
    ,nvl(n.payee_bank_no, o.payee_bank_no) as payee_bank_no -- 收款行行号
    ,nvl(n.payee_bank_name, o.payee_bank_name) as payee_bank_name -- 收款行名称
    ,nvl(n.bill_date, o.bill_date) as bill_date -- 出票日期 格式yyyyMMdd
    ,nvl(n.return_reason, o.return_reason) as return_reason -- 退票理由
    ,nvl(n.ticket_type, o.ticket_type) as ticket_type -- 票据类型 1支票，2银行汇票3银行本票
    ,nvl(n.ticket_count, o.ticket_count) as ticket_count -- 票据张数
    ,nvl(n.ticket_no, o.ticket_no) as ticket_no -- 票据号码
    ,nvl(n.call_result, o.call_result) as call_result -- 外呼结果 外呼结果(1-查证成功，2-查证失败，3-查证不通)
    ,nvl(n.call_person_num, o.call_person_num) as call_person_num -- 外呼应呼人数
    ,nvl(n.call_timeout_flag, o.call_timeout_flag) as call_timeout_flag -- 外呼强制超时 0-不强制超时1-强制超时
    ,nvl(n.call_timeout_user_id, o.call_timeout_user_id) as call_timeout_user_id -- 外呼强制超时操作柜员
    ,nvl(n.call_timeout_charge_id, o.call_timeout_charge_id) as call_timeout_charge_id -- 外呼强制超时授权柜员
    ,nvl(n.drawee_address, o.drawee_address) as drawee_address -- 付款人地址
    ,nvl(n.payee_address, o.payee_address) as payee_address -- 收款人地址
    ,nvl(n.post_fee, o.post_fee) as post_fee -- 汇划费
    ,nvl(n.cost_fee, o.cost_fee) as cost_fee -- 工本费
    ,nvl(n.remark, o.remark) as remark -- 摘要码
    ,nvl(n.payee_corp_flag, o.payee_corp_flag) as payee_corp_flag -- 收款人个人对公标志
    ,nvl(n.withhold_acct_no, o.withhold_acct_no) as withhold_acct_no -- 实际扣帐账号 内部账户时必输
    ,nvl(n.withhold_acct_name, o.withhold_acct_name) as withhold_acct_name -- 实际扣帐户名 内部账户时必输
    ,nvl(n.inside_acct_flag, o.inside_acct_flag) as inside_acct_flag -- 内部账户标识 0非内部账户 1内部账户
    ,nvl(n.pay_send_seqno, o.pay_send_seqno) as pay_send_seqno -- 发送支付系统报文流水号
    ,nvl(n.pay_host_seqno, o.pay_host_seqno) as pay_host_seqno -- 支付系统响应的主机流水
    ,nvl(n.pay_business_no, o.pay_business_no) as pay_business_no -- 支付系统业务序号
    ,nvl(n.pay_send_date, o.pay_send_date) as pay_send_date -- 支付报文交易日期
    ,nvl(n.pay_host_date, o.pay_host_date) as pay_host_date -- 支付主机交易日期
    ,nvl(n.drawee_core_tel, o.drawee_core_tel) as drawee_core_tel -- 付款人核心联系方式
    ,nvl(n.tally_state, o.tally_state) as tally_state -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
    ,nvl(n.tally_flow_no, o.tally_flow_no) as tally_flow_no -- 记账报文流水号
    ,nvl(n.tally_host_no, o.tally_host_no) as tally_host_no -- 记账核心交易流水
    ,nvl(n.tally_host_date, o.tally_host_date) as tally_host_date -- 核心交易日期
    ,nvl(n.submit_state, o.submit_state) as submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
    ,nvl(n.drawee_info_send_flag, o.drawee_info_send_flag) as drawee_info_send_flag -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
    ,nvl(n.drawee_info_send_result, o.drawee_info_send_result) as drawee_info_send_result -- 收款人信息处理结果 处理结果描述
    ,nvl(n.drawee_info_send_time, o.drawee_info_send_time) as drawee_info_send_time -- 收款人信息处理时间  格式为yyyy-MM-dd
    ,nvl(n.pre_task_id, o.pre_task_id) as pre_task_id -- 预受理任务编号
    ,nvl(n.pre_task_status, o.pre_task_status) as pre_task_status -- 预受理任务状态 0-已受理，1-预审通过，2-预审不通过，3-已超期，4-作废
    ,nvl(n.pre_task_result, o.pre_task_result) as pre_task_result -- 预审核结论
    ,nvl(n.pre_task_approve_user, o.pre_task_approve_user) as pre_task_approve_user -- 预受理任务审核提交用户
    ,nvl(n.pre_task_approve_time, o.pre_task_approve_time) as pre_task_approve_time -- 预受理任务审核时间（yyyy-MM-dd hh:mm:ss）
    ,nvl(n.endorser_num, o.endorser_num) as endorser_num -- 背书人数
    ,nvl(n.endorsers, o.endorsers) as endorsers -- 最后一手背书人
    ,nvl(n.unfreeze_flow_no, o.unfreeze_flow_no) as unfreeze_flow_no -- 流水号-作为对账流水、解冻时的原流水号（UPP流水）
    ,nvl(n.passbook_voucher_no, o.passbook_voucher_no) as passbook_voucher_no -- 存折凭证号码
    ,nvl(n.acct_level, o.acct_level) as acct_level -- SECOND-ACCT:二类户；THIRD-ACCT:三类户
    ,nvl(n.delay_flag, o.delay_flag) as delay_flag -- 是否延迟结算,1-是，2-否
    ,nvl(n.acct_nature, o.acct_nature) as acct_nature -- 账户性质[JJSB-基金社保 CZCK-财政性存款 GJJ-公积金 QT-其他]
    ,nvl(n.regulator_flag, o.regulator_flag) as regulator_flag -- 监管账户标识，0-无，1-监管账户
    ,nvl(n.transfer_flag, o.transfer_flag) as transfer_flag -- 行内转账标识 1-行内转账 其他-行外
    ,nvl(n.payee_acct_level, o.payee_acct_level) as payee_acct_level -- 收款方账户级别
    ,nvl(n.payee_cust_type, o.payee_cust_type) as payee_cust_type -- 客户类型 1-个人客户 2-对公客户 3-同业客户 4-内部客户
    ,nvl(n.pay_acct_type, o.pay_acct_type) as pay_acct_type -- 付款人账户类型
    ,nvl(n.doc_id, o.doc_id) as doc_id -- 影像ID
    ,nvl(n.glob_seq_num, o.glob_seq_num) as glob_seq_num -- 全局流水号
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行号
    ,nvl(n.system_no, o.system_no) as system_no -- 系统号
    ,nvl(n.organ_no, o.organ_no) as organ_no -- 机构号
    ,nvl(n.pay_name, o.pay_name) as pay_name -- 付款人名称
    ,nvl(n.pay_acct_no, o.pay_acct_no) as pay_acct_no -- 付款人账号
    ,nvl(n.vouch_group, o.vouch_group) as vouch_group -- 业务场景凭证组合
    ,nvl(n.model_code, o.model_code) as model_code -- 影像模型
    ,nvl(n.busi_start_date, o.busi_start_date) as busi_start_date -- 影像上传时间
    ,nvl(n.over_amt, o.over_amt) as over_amt -- 法透金额
    ,nvl(n.open_br_no, o.open_br_no) as open_br_no -- 付款人开户机构
    ,nvl(n.budg_level, o.budg_level) as budg_level -- 预算级次
    ,nvl(n.cnter_acct_date, o.cnter_acct_date) as cnter_acct_date -- 柜面记账日期
    ,case when
            n.task_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.task_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.task_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scps_bp_remit_tb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scps_bp_remit_tb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.task_id = n.task_id
where (
        o.task_id is null
    )
    or (
        n.task_id is null
    )
    or (
        o.trans_date <> n.trans_date
        or o.trans_time <> n.trans_time
        or o.trans_state <> n.trans_state
        or o.trans_channel <> n.trans_channel
        or o.business_code <> n.business_code
        or o.user_id <> n.user_id
        or o.charge_id <> n.charge_id
        or o.branch_code <> n.branch_code
        or o.business_kind <> n.business_kind
        or o.business_type <> n.business_type
        or o.voucher_code <> n.voucher_code
        or o.voucher_no <> n.voucher_no
        or o.cust_no <> n.cust_no
        or o.cust_name <> n.cust_name
        or o.transfer_type <> n.transfer_type
        or o.currency_code <> n.currency_code
        or o.pay_channel <> n.pay_channel
        or o.pay_type <> n.pay_type
        or o.drawee_name <> n.drawee_name
        or o.drawee_acct_no <> n.drawee_acct_no
        or o.drawee_cert_type <> n.drawee_cert_type
        or o.drawee_cert_no <> n.drawee_cert_no
        or o.drawee_cert_date <> n.drawee_cert_date
        or o.drawee_phone <> n.drawee_phone
        or o.payee_name <> n.payee_name
        or o.payee_acct_no <> n.payee_acct_no
        or o.trans_amount <> n.trans_amount
        or o.trans_amount_ch <> n.trans_amount_ch
        or o.is_proxy <> n.is_proxy
        or o.proxy_name <> n.proxy_name
        or o.proxy_cert_type <> n.proxy_cert_type
        or o.proxy_cert_no <> n.proxy_cert_no
        or o.proxy_cert_date <> n.proxy_cert_date
        or o.fee_type <> n.fee_type
        or o.fee_amount <> n.fee_amount
        or o.remit_priority <> n.remit_priority
        or o.city_priority <> n.city_priority
        or o.trans_method <> n.trans_method
        or o.purpose <> n.purpose
        or o.transfer_reason <> n.transfer_reason
        or o.debt_flag <> n.debt_flag
        or o.drawee_bank_no <> n.drawee_bank_no
        or o.drawee_bank_name <> n.drawee_bank_name
        or o.payee_bank_no <> n.payee_bank_no
        or o.payee_bank_name <> n.payee_bank_name
        or o.bill_date <> n.bill_date
        or o.return_reason <> n.return_reason
        or o.ticket_type <> n.ticket_type
        or o.ticket_count <> n.ticket_count
        or o.ticket_no <> n.ticket_no
        or o.call_result <> n.call_result
        or o.call_person_num <> n.call_person_num
        or o.call_timeout_flag <> n.call_timeout_flag
        or o.call_timeout_user_id <> n.call_timeout_user_id
        or o.call_timeout_charge_id <> n.call_timeout_charge_id
        or o.drawee_address <> n.drawee_address
        or o.payee_address <> n.payee_address
        or o.post_fee <> n.post_fee
        or o.cost_fee <> n.cost_fee
        or o.remark <> n.remark
        or o.payee_corp_flag <> n.payee_corp_flag
        or o.withhold_acct_no <> n.withhold_acct_no
        or o.withhold_acct_name <> n.withhold_acct_name
        or o.inside_acct_flag <> n.inside_acct_flag
        or o.pay_send_seqno <> n.pay_send_seqno
        or o.pay_host_seqno <> n.pay_host_seqno
        or o.pay_business_no <> n.pay_business_no
        or o.pay_send_date <> n.pay_send_date
        or o.pay_host_date <> n.pay_host_date
        or o.drawee_core_tel <> n.drawee_core_tel
        or o.tally_state <> n.tally_state
        or o.tally_flow_no <> n.tally_flow_no
        or o.tally_host_no <> n.tally_host_no
        or o.tally_host_date <> n.tally_host_date
        or o.submit_state <> n.submit_state
        or o.drawee_info_send_flag <> n.drawee_info_send_flag
        or o.drawee_info_send_result <> n.drawee_info_send_result
        or o.drawee_info_send_time <> n.drawee_info_send_time
        or o.pre_task_id <> n.pre_task_id
        or o.pre_task_status <> n.pre_task_status
        or o.pre_task_result <> n.pre_task_result
        or o.pre_task_approve_user <> n.pre_task_approve_user
        or o.pre_task_approve_time <> n.pre_task_approve_time
        or o.endorser_num <> n.endorser_num
        or o.endorsers <> n.endorsers
        or o.unfreeze_flow_no <> n.unfreeze_flow_no
        or o.passbook_voucher_no <> n.passbook_voucher_no
        or o.acct_level <> n.acct_level
        or o.delay_flag <> n.delay_flag
        or o.acct_nature <> n.acct_nature
        or o.regulator_flag <> n.regulator_flag
        or o.transfer_flag <> n.transfer_flag
        or o.payee_acct_level <> n.payee_acct_level
        or o.payee_cust_type <> n.payee_cust_type
        or o.pay_acct_type <> n.pay_acct_type
        or o.doc_id <> n.doc_id
        or o.glob_seq_num <> n.glob_seq_num
        or o.bank_no <> n.bank_no
        or o.system_no <> n.system_no
        or o.organ_no <> n.organ_no
        or o.pay_name <> n.pay_name
        or o.pay_acct_no <> n.pay_acct_no
        or o.vouch_group <> n.vouch_group
        or o.model_code <> n.model_code
        or o.busi_start_date <> n.busi_start_date
        or o.over_amt <> n.over_amt
        or o.open_br_no <> n.open_br_no
        or o.budg_level <> n.budg_level
        or o.cnter_acct_date <> n.cnter_acct_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_remit_tb_cl(
            task_id -- 任务号
            ,trans_date -- 交易日期（yyyyMMdd)
            ,trans_time -- 交易时间
            ,trans_state -- 处理状态[1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]
            ,trans_channel -- 业务渠道
            ,business_code -- 业务场景码
            ,user_id -- 交易柜员编号
            ,charge_id -- 授权柜员号
            ,branch_code -- 前台机构号
            ,business_kind -- 业务种类 1-对私业务、2-对公业务
            ,business_type -- 业务类型 1.普通汇兑（对公结算户） 2.普通汇兑（内部户） 3.公益性资金汇划 4.国库汇款
            ,voucher_code -- 凭证代码 786-结算业务委托书、780-支票、999-其他
            ,voucher_no -- 凭证号码
            ,cust_no -- 客户号 本行付款人时才有
            ,cust_name -- 客户名称
            ,transfer_type -- 现转标志0-现金、1-转账、2-其他（非资金类交易）
            ,currency_code -- 币种
            ,pay_channel -- 支付渠道(1-现代化支付系统大额系统、2-现代化支付系统小额系统)
            ,pay_type -- 支取方式 (空)-无 A-密码D-印鉴E-证件F-印密G-支付密码H-无限制I-印鉴加支付密码
            ,drawee_name -- 付款人名称
            ,drawee_acct_no -- 交易对手账号
            ,drawee_cert_type -- 交易对手证件类型
            ,drawee_cert_no -- 交易对手证件号码
            ,drawee_cert_date -- 付款人证件到期日 格式yyyyMMdd
            ,drawee_phone -- 付款人联系方式 可以是固话或手机
            ,payee_name -- 交易对手名称
            ,payee_acct_no -- 收款人账号
            ,trans_amount -- 交易金额 例如100.00
            ,trans_amount_ch -- 交易金额(大写)
            ,is_proxy -- 是否代理 0-不代理，1-代理
            ,proxy_name -- 代办人姓名
            ,proxy_cert_type -- 代办人证件类型
            ,proxy_cert_no -- 代办人证件号码
            ,proxy_cert_date -- 交易代办人证件到期日期
            ,fee_type -- 收费方式
            ,fee_amount -- 手续费
            ,remit_priority -- 汇兑优先级 1-普通2-加急3-次日
            ,city_priority -- 同城异地 1-同城、2-异地(保留)
            ,trans_method -- 交易方式 010106-信汇 010104-电汇 000001-银行承兑汇票 000003-本票 000151-其他
            ,purpose -- 用途（附言）
            ,transfer_reason -- 转账原因
            ,debt_flag -- 入账标志 0-未入帐1-已入帐
            ,drawee_bank_no -- 付款行名号
            ,drawee_bank_name -- 付款行名称
            ,payee_bank_no -- 收款行行号
            ,payee_bank_name -- 收款行名称
            ,bill_date -- 出票日期 格式yyyyMMdd
            ,return_reason -- 退票理由
            ,ticket_type -- 票据类型 1支票，2银行汇票3银行本票
            ,ticket_count -- 票据张数
            ,ticket_no -- 票据号码
            ,call_result -- 外呼结果 外呼结果(1-查证成功，2-查证失败，3-查证不通)
            ,call_person_num -- 外呼应呼人数
            ,call_timeout_flag -- 外呼强制超时 0-不强制超时1-强制超时
            ,call_timeout_user_id -- 外呼强制超时操作柜员
            ,call_timeout_charge_id -- 外呼强制超时授权柜员
            ,drawee_address -- 付款人地址
            ,payee_address -- 收款人地址
            ,post_fee -- 汇划费
            ,cost_fee -- 工本费
            ,remark -- 摘要码
            ,payee_corp_flag -- 收款人个人对公标志
            ,withhold_acct_no -- 实际扣帐账号 内部账户时必输
            ,withhold_acct_name -- 实际扣帐户名 内部账户时必输
            ,inside_acct_flag -- 内部账户标识 0非内部账户 1内部账户
            ,pay_send_seqno -- 发送支付系统报文流水号
            ,pay_host_seqno -- 支付系统响应的主机流水
            ,pay_business_no -- 支付系统业务序号
            ,pay_send_date -- 支付报文交易日期
            ,pay_host_date -- 支付主机交易日期
            ,drawee_core_tel -- 付款人核心联系方式
            ,tally_state -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
            ,tally_flow_no -- 记账报文流水号
            ,tally_host_no -- 记账核心交易流水
            ,tally_host_date -- 核心交易日期
            ,submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
            ,drawee_info_send_flag -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
            ,drawee_info_send_result -- 收款人信息处理结果 处理结果描述
            ,drawee_info_send_time -- 收款人信息处理时间  格式为yyyy-MM-dd
            ,pre_task_id -- 预受理任务编号
            ,pre_task_status -- 预受理任务状态 0-已受理，1-预审通过，2-预审不通过，3-已超期，4-作废
            ,pre_task_result -- 预审核结论
            ,pre_task_approve_user -- 预受理任务审核提交用户
            ,pre_task_approve_time -- 预受理任务审核时间（yyyy-MM-dd hh:mm:ss）
            ,endorser_num -- 背书人数
            ,endorsers -- 最后一手背书人
            ,unfreeze_flow_no -- 流水号-作为对账流水、解冻时的原流水号（UPP流水）
            ,passbook_voucher_no -- 存折凭证号码
            ,acct_level -- SECOND-ACCT:二类户；THIRD-ACCT:三类户
            ,delay_flag -- 是否延迟结算,1-是，2-否
            ,acct_nature -- 账户性质[JJSB-基金社保 CZCK-财政性存款 GJJ-公积金 QT-其他]
            ,regulator_flag -- 监管账户标识，0-无，1-监管账户
            ,transfer_flag -- 行内转账标识 1-行内转账 其他-行外
            ,payee_acct_level -- 收款方账户级别
            ,payee_cust_type -- 客户类型 1-个人客户 2-对公客户 3-同业客户 4-内部客户
            ,pay_acct_type -- 付款人账户类型
            ,doc_id -- 影像ID
            ,glob_seq_num -- 全局流水号
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,organ_no -- 机构号
            ,pay_name -- 付款人名称
            ,pay_acct_no -- 付款人账号
            ,vouch_group -- 业务场景凭证组合
            ,model_code -- 影像模型
            ,busi_start_date -- 影像上传时间
            ,over_amt -- 法透金额
            ,open_br_no -- 付款人开户机构
            ,budg_level -- 预算级次
            ,cnter_acct_date -- 柜面记账日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_remit_tb_op(
            task_id -- 任务号
            ,trans_date -- 交易日期（yyyyMMdd)
            ,trans_time -- 交易时间
            ,trans_state -- 处理状态[1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]
            ,trans_channel -- 业务渠道
            ,business_code -- 业务场景码
            ,user_id -- 交易柜员编号
            ,charge_id -- 授权柜员号
            ,branch_code -- 前台机构号
            ,business_kind -- 业务种类 1-对私业务、2-对公业务
            ,business_type -- 业务类型 1.普通汇兑（对公结算户） 2.普通汇兑（内部户） 3.公益性资金汇划 4.国库汇款
            ,voucher_code -- 凭证代码 786-结算业务委托书、780-支票、999-其他
            ,voucher_no -- 凭证号码
            ,cust_no -- 客户号 本行付款人时才有
            ,cust_name -- 客户名称
            ,transfer_type -- 现转标志0-现金、1-转账、2-其他（非资金类交易）
            ,currency_code -- 币种
            ,pay_channel -- 支付渠道(1-现代化支付系统大额系统、2-现代化支付系统小额系统)
            ,pay_type -- 支取方式 (空)-无 A-密码D-印鉴E-证件F-印密G-支付密码H-无限制I-印鉴加支付密码
            ,drawee_name -- 付款人名称
            ,drawee_acct_no -- 交易对手账号
            ,drawee_cert_type -- 交易对手证件类型
            ,drawee_cert_no -- 交易对手证件号码
            ,drawee_cert_date -- 付款人证件到期日 格式yyyyMMdd
            ,drawee_phone -- 付款人联系方式 可以是固话或手机
            ,payee_name -- 交易对手名称
            ,payee_acct_no -- 收款人账号
            ,trans_amount -- 交易金额 例如100.00
            ,trans_amount_ch -- 交易金额(大写)
            ,is_proxy -- 是否代理 0-不代理，1-代理
            ,proxy_name -- 代办人姓名
            ,proxy_cert_type -- 代办人证件类型
            ,proxy_cert_no -- 代办人证件号码
            ,proxy_cert_date -- 交易代办人证件到期日期
            ,fee_type -- 收费方式
            ,fee_amount -- 手续费
            ,remit_priority -- 汇兑优先级 1-普通2-加急3-次日
            ,city_priority -- 同城异地 1-同城、2-异地(保留)
            ,trans_method -- 交易方式 010106-信汇 010104-电汇 000001-银行承兑汇票 000003-本票 000151-其他
            ,purpose -- 用途（附言）
            ,transfer_reason -- 转账原因
            ,debt_flag -- 入账标志 0-未入帐1-已入帐
            ,drawee_bank_no -- 付款行名号
            ,drawee_bank_name -- 付款行名称
            ,payee_bank_no -- 收款行行号
            ,payee_bank_name -- 收款行名称
            ,bill_date -- 出票日期 格式yyyyMMdd
            ,return_reason -- 退票理由
            ,ticket_type -- 票据类型 1支票，2银行汇票3银行本票
            ,ticket_count -- 票据张数
            ,ticket_no -- 票据号码
            ,call_result -- 外呼结果 外呼结果(1-查证成功，2-查证失败，3-查证不通)
            ,call_person_num -- 外呼应呼人数
            ,call_timeout_flag -- 外呼强制超时 0-不强制超时1-强制超时
            ,call_timeout_user_id -- 外呼强制超时操作柜员
            ,call_timeout_charge_id -- 外呼强制超时授权柜员
            ,drawee_address -- 付款人地址
            ,payee_address -- 收款人地址
            ,post_fee -- 汇划费
            ,cost_fee -- 工本费
            ,remark -- 摘要码
            ,payee_corp_flag -- 收款人个人对公标志
            ,withhold_acct_no -- 实际扣帐账号 内部账户时必输
            ,withhold_acct_name -- 实际扣帐户名 内部账户时必输
            ,inside_acct_flag -- 内部账户标识 0非内部账户 1内部账户
            ,pay_send_seqno -- 发送支付系统报文流水号
            ,pay_host_seqno -- 支付系统响应的主机流水
            ,pay_business_no -- 支付系统业务序号
            ,pay_send_date -- 支付报文交易日期
            ,pay_host_date -- 支付主机交易日期
            ,drawee_core_tel -- 付款人核心联系方式
            ,tally_state -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
            ,tally_flow_no -- 记账报文流水号
            ,tally_host_no -- 记账核心交易流水
            ,tally_host_date -- 核心交易日期
            ,submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
            ,drawee_info_send_flag -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
            ,drawee_info_send_result -- 收款人信息处理结果 处理结果描述
            ,drawee_info_send_time -- 收款人信息处理时间  格式为yyyy-MM-dd
            ,pre_task_id -- 预受理任务编号
            ,pre_task_status -- 预受理任务状态 0-已受理，1-预审通过，2-预审不通过，3-已超期，4-作废
            ,pre_task_result -- 预审核结论
            ,pre_task_approve_user -- 预受理任务审核提交用户
            ,pre_task_approve_time -- 预受理任务审核时间（yyyy-MM-dd hh:mm:ss）
            ,endorser_num -- 背书人数
            ,endorsers -- 最后一手背书人
            ,unfreeze_flow_no -- 流水号-作为对账流水、解冻时的原流水号（UPP流水）
            ,passbook_voucher_no -- 存折凭证号码
            ,acct_level -- SECOND-ACCT:二类户；THIRD-ACCT:三类户
            ,delay_flag -- 是否延迟结算,1-是，2-否
            ,acct_nature -- 账户性质[JJSB-基金社保 CZCK-财政性存款 GJJ-公积金 QT-其他]
            ,regulator_flag -- 监管账户标识，0-无，1-监管账户
            ,transfer_flag -- 行内转账标识 1-行内转账 其他-行外
            ,payee_acct_level -- 收款方账户级别
            ,payee_cust_type -- 客户类型 1-个人客户 2-对公客户 3-同业客户 4-内部客户
            ,pay_acct_type -- 付款人账户类型
            ,doc_id -- 影像ID
            ,glob_seq_num -- 全局流水号
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,organ_no -- 机构号
            ,pay_name -- 付款人名称
            ,pay_acct_no -- 付款人账号
            ,vouch_group -- 业务场景凭证组合
            ,model_code -- 影像模型
            ,busi_start_date -- 影像上传时间
            ,over_amt -- 法透金额
            ,open_br_no -- 付款人开户机构
            ,budg_level -- 预算级次
            ,cnter_acct_date -- 柜面记账日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.task_id -- 任务号
    ,o.trans_date -- 交易日期（yyyyMMdd)
    ,o.trans_time -- 交易时间
    ,o.trans_state -- 处理状态[1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]
    ,o.trans_channel -- 业务渠道
    ,o.business_code -- 业务场景码
    ,o.user_id -- 交易柜员编号
    ,o.charge_id -- 授权柜员号
    ,o.branch_code -- 前台机构号
    ,o.business_kind -- 业务种类 1-对私业务、2-对公业务
    ,o.business_type -- 业务类型 1.普通汇兑（对公结算户） 2.普通汇兑（内部户） 3.公益性资金汇划 4.国库汇款
    ,o.voucher_code -- 凭证代码 786-结算业务委托书、780-支票、999-其他
    ,o.voucher_no -- 凭证号码
    ,o.cust_no -- 客户号 本行付款人时才有
    ,o.cust_name -- 客户名称
    ,o.transfer_type -- 现转标志0-现金、1-转账、2-其他（非资金类交易）
    ,o.currency_code -- 币种
    ,o.pay_channel -- 支付渠道(1-现代化支付系统大额系统、2-现代化支付系统小额系统)
    ,o.pay_type -- 支取方式 (空)-无 A-密码D-印鉴E-证件F-印密G-支付密码H-无限制I-印鉴加支付密码
    ,o.drawee_name -- 付款人名称
    ,o.drawee_acct_no -- 交易对手账号
    ,o.drawee_cert_type -- 交易对手证件类型
    ,o.drawee_cert_no -- 交易对手证件号码
    ,o.drawee_cert_date -- 付款人证件到期日 格式yyyyMMdd
    ,o.drawee_phone -- 付款人联系方式 可以是固话或手机
    ,o.payee_name -- 交易对手名称
    ,o.payee_acct_no -- 收款人账号
    ,o.trans_amount -- 交易金额 例如100.00
    ,o.trans_amount_ch -- 交易金额(大写)
    ,o.is_proxy -- 是否代理 0-不代理，1-代理
    ,o.proxy_name -- 代办人姓名
    ,o.proxy_cert_type -- 代办人证件类型
    ,o.proxy_cert_no -- 代办人证件号码
    ,o.proxy_cert_date -- 交易代办人证件到期日期
    ,o.fee_type -- 收费方式
    ,o.fee_amount -- 手续费
    ,o.remit_priority -- 汇兑优先级 1-普通2-加急3-次日
    ,o.city_priority -- 同城异地 1-同城、2-异地(保留)
    ,o.trans_method -- 交易方式 010106-信汇 010104-电汇 000001-银行承兑汇票 000003-本票 000151-其他
    ,o.purpose -- 用途（附言）
    ,o.transfer_reason -- 转账原因
    ,o.debt_flag -- 入账标志 0-未入帐1-已入帐
    ,o.drawee_bank_no -- 付款行名号
    ,o.drawee_bank_name -- 付款行名称
    ,o.payee_bank_no -- 收款行行号
    ,o.payee_bank_name -- 收款行名称
    ,o.bill_date -- 出票日期 格式yyyyMMdd
    ,o.return_reason -- 退票理由
    ,o.ticket_type -- 票据类型 1支票，2银行汇票3银行本票
    ,o.ticket_count -- 票据张数
    ,o.ticket_no -- 票据号码
    ,o.call_result -- 外呼结果 外呼结果(1-查证成功，2-查证失败，3-查证不通)
    ,o.call_person_num -- 外呼应呼人数
    ,o.call_timeout_flag -- 外呼强制超时 0-不强制超时1-强制超时
    ,o.call_timeout_user_id -- 外呼强制超时操作柜员
    ,o.call_timeout_charge_id -- 外呼强制超时授权柜员
    ,o.drawee_address -- 付款人地址
    ,o.payee_address -- 收款人地址
    ,o.post_fee -- 汇划费
    ,o.cost_fee -- 工本费
    ,o.remark -- 摘要码
    ,o.payee_corp_flag -- 收款人个人对公标志
    ,o.withhold_acct_no -- 实际扣帐账号 内部账户时必输
    ,o.withhold_acct_name -- 实际扣帐户名 内部账户时必输
    ,o.inside_acct_flag -- 内部账户标识 0非内部账户 1内部账户
    ,o.pay_send_seqno -- 发送支付系统报文流水号
    ,o.pay_host_seqno -- 支付系统响应的主机流水
    ,o.pay_business_no -- 支付系统业务序号
    ,o.pay_send_date -- 支付报文交易日期
    ,o.pay_host_date -- 支付主机交易日期
    ,o.drawee_core_tel -- 付款人核心联系方式
    ,o.tally_state -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
    ,o.tally_flow_no -- 记账报文流水号
    ,o.tally_host_no -- 记账核心交易流水
    ,o.tally_host_date -- 核心交易日期
    ,o.submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
    ,o.drawee_info_send_flag -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
    ,o.drawee_info_send_result -- 收款人信息处理结果 处理结果描述
    ,o.drawee_info_send_time -- 收款人信息处理时间  格式为yyyy-MM-dd
    ,o.pre_task_id -- 预受理任务编号
    ,o.pre_task_status -- 预受理任务状态 0-已受理，1-预审通过，2-预审不通过，3-已超期，4-作废
    ,o.pre_task_result -- 预审核结论
    ,o.pre_task_approve_user -- 预受理任务审核提交用户
    ,o.pre_task_approve_time -- 预受理任务审核时间（yyyy-MM-dd hh:mm:ss）
    ,o.endorser_num -- 背书人数
    ,o.endorsers -- 最后一手背书人
    ,o.unfreeze_flow_no -- 流水号-作为对账流水、解冻时的原流水号（UPP流水）
    ,o.passbook_voucher_no -- 存折凭证号码
    ,o.acct_level -- SECOND-ACCT:二类户；THIRD-ACCT:三类户
    ,o.delay_flag -- 是否延迟结算,1-是，2-否
    ,o.acct_nature -- 账户性质[JJSB-基金社保 CZCK-财政性存款 GJJ-公积金 QT-其他]
    ,o.regulator_flag -- 监管账户标识，0-无，1-监管账户
    ,o.transfer_flag -- 行内转账标识 1-行内转账 其他-行外
    ,o.payee_acct_level -- 收款方账户级别
    ,o.payee_cust_type -- 客户类型 1-个人客户 2-对公客户 3-同业客户 4-内部客户
    ,o.pay_acct_type -- 付款人账户类型
    ,o.doc_id -- 影像ID
    ,o.glob_seq_num -- 全局流水号
    ,o.bank_no -- 银行号
    ,o.system_no -- 系统号
    ,o.organ_no -- 机构号
    ,o.pay_name -- 付款人名称
    ,o.pay_acct_no -- 付款人账号
    ,o.vouch_group -- 业务场景凭证组合
    ,o.model_code -- 影像模型
    ,o.busi_start_date -- 影像上传时间
    ,o.over_amt -- 法透金额
    ,o.open_br_no -- 付款人开户机构
    ,o.budg_level -- 预算级次
    ,o.cnter_acct_date -- 柜面记账日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.scps_bp_remit_tb_bk o
    left join ${iol_schema}.scps_bp_remit_tb_op n
        on
            o.task_id = n.task_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scps_bp_remit_tb_cl d
        on
            o.task_id = d.task_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scps_bp_remit_tb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scps_bp_remit_tb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scps_bp_remit_tb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scps_bp_remit_tb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scps_bp_remit_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_bp_remit_tb_cl;
alter table ${iol_schema}.scps_bp_remit_tb exchange partition p_20991231 with table ${iol_schema}.scps_bp_remit_tb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_bp_remit_tb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_remit_tb_op purge;
drop table ${iol_schema}.scps_bp_remit_tb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scps_bp_remit_tb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_bp_remit_tb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
