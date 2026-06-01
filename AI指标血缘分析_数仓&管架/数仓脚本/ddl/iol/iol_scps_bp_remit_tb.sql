/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_bp_remit_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_bp_remit_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_bp_remit_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_remit_tb(
    task_id varchar2(50) -- 任务号
    ,trans_date date -- 交易日期（yyyyMMdd)
    ,trans_time varchar2(8) -- 交易时间
    ,trans_state varchar2(10) -- 处理状态[1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]
    ,trans_channel varchar2(10) -- 业务渠道
    ,business_code varchar2(20) -- 业务场景码
    ,user_id varchar2(8) -- 交易柜员编号
    ,charge_id varchar2(10) -- 授权柜员号
    ,branch_code varchar2(9) -- 前台机构号
    ,business_kind varchar2(1) -- 业务种类 1-对私业务、2-对公业务
    ,business_type varchar2(1) -- 业务类型 1.普通汇兑（对公结算户） 2.普通汇兑（内部户） 3.公益性资金汇划 4.国库汇款
    ,voucher_code varchar2(50) -- 凭证代码 786-结算业务委托书、780-支票、999-其他
    ,voucher_no varchar2(48) -- 凭证号码
    ,cust_no varchar2(12) -- 客户号 本行付款人时才有
    ,cust_name varchar2(200) -- 客户名称
    ,transfer_type varchar2(1) -- 现转标志0-现金、1-转账、2-其他（非资金类交易）
    ,currency_code varchar2(3) -- 币种
    ,pay_channel varchar2(10) -- 支付渠道(1-现代化支付系统大额系统、2-现代化支付系统小额系统)
    ,pay_type varchar2(1) -- 支取方式 (空)-无 A-密码D-印鉴E-证件F-印密G-支付密码H-无限制I-印鉴加支付密码
    ,drawee_name varchar2(200) -- 付款人名称
    ,drawee_acct_no varchar2(50) -- 交易对手账号
    ,drawee_cert_type varchar2(4) -- 交易对手证件类型
    ,drawee_cert_no varchar2(60) -- 交易对手证件号码
    ,drawee_cert_date varchar2(8) -- 付款人证件到期日 格式yyyyMMdd
    ,drawee_phone varchar2(30) -- 付款人联系方式 可以是固话或手机
    ,payee_name varchar2(200) -- 交易对手名称
    ,payee_acct_no varchar2(40) -- 收款人账号
    ,trans_amount number(20,2) -- 交易金额 例如100.00
    ,trans_amount_ch varchar2(100) -- 交易金额(大写)
    ,is_proxy varchar2(1) -- 是否代理 0-不代理，1-代理
    ,proxy_name varchar2(200) -- 代办人姓名
    ,proxy_cert_type varchar2(4) -- 代办人证件类型
    ,proxy_cert_no varchar2(60) -- 代办人证件号码
    ,proxy_cert_date date -- 交易代办人证件到期日期
    ,fee_type varchar2(1) -- 收费方式
    ,fee_amount varchar2(32) -- 手续费
    ,remit_priority varchar2(1) -- 汇兑优先级 1-普通2-加急3-次日
    ,city_priority varchar2(1) -- 同城异地 1-同城、2-异地(保留)
    ,trans_method varchar2(6) -- 交易方式 010106-信汇 010104-电汇 000001-银行承兑汇票 000003-本票 000151-其他
    ,purpose varchar2(500) -- 用途（附言）
    ,transfer_reason varchar2(500) -- 转账原因
    ,debt_flag varchar2(1) -- 入账标志 0-未入帐1-已入帐
    ,drawee_bank_no varchar2(30) -- 付款行名号
    ,drawee_bank_name varchar2(100) -- 付款行名称
    ,payee_bank_no varchar2(30) -- 收款行行号
    ,payee_bank_name varchar2(200) -- 收款行名称
    ,bill_date varchar2(8) -- 出票日期 格式yyyyMMdd
    ,return_reason varchar2(1000) -- 退票理由
    ,ticket_type varchar2(1) -- 票据类型 1支票，2银行汇票3银行本票
    ,ticket_count number -- 票据张数
    ,ticket_no varchar2(30) -- 票据号码
    ,call_result varchar2(1) -- 外呼结果 外呼结果(1-查证成功，2-查证失败，3-查证不通)
    ,call_person_num varchar2(5) -- 外呼应呼人数
    ,call_timeout_flag varchar2(1) -- 外呼强制超时 0-不强制超时1-强制超时
    ,call_timeout_user_id varchar2(10) -- 外呼强制超时操作柜员
    ,call_timeout_charge_id varchar2(10) -- 外呼强制超时授权柜员
    ,drawee_address varchar2(500) -- 付款人地址
    ,payee_address varchar2(500) -- 收款人地址
    ,post_fee varchar2(13) -- 汇划费
    ,cost_fee varchar2(13) -- 工本费
    ,remark varchar2(10) -- 摘要码
    ,payee_corp_flag varchar2(1) -- 收款人个人对公标志
    ,withhold_acct_no varchar2(32) -- 实际扣帐账号 内部账户时必输
    ,withhold_acct_name varchar2(100) -- 实际扣帐户名 内部账户时必输
    ,inside_acct_flag varchar2(1) -- 内部账户标识 0非内部账户 1内部账户
    ,pay_send_seqno varchar2(64) -- 发送支付系统报文流水号
    ,pay_host_seqno varchar2(32) -- 支付系统响应的主机流水
    ,pay_business_no varchar2(64) -- 支付系统业务序号
    ,pay_send_date date -- 支付报文交易日期
    ,pay_host_date date -- 支付主机交易日期
    ,drawee_core_tel varchar2(30) -- 付款人核心联系方式
    ,tally_state varchar2(1) -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
    ,tally_flow_no varchar2(32) -- 记账报文流水号
    ,tally_host_no varchar2(32) -- 记账核心交易流水
    ,tally_host_date date -- 核心交易日期
    ,submit_state varchar2(1) -- 业务提交状态 0-未提交，1-处理中 2-提交成功
    ,drawee_info_send_flag varchar2(1) -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
    ,drawee_info_send_result varchar2(1000) -- 收款人信息处理结果 处理结果描述
    ,drawee_info_send_time varchar2(20) -- 收款人信息处理时间  格式为yyyy-MM-dd
    ,pre_task_id varchar2(20) -- 预受理任务编号
    ,pre_task_status varchar2(1) -- 预受理任务状态 0-已受理，1-预审通过，2-预审不通过，3-已超期，4-作废
    ,pre_task_result varchar2(1000) -- 预审核结论
    ,pre_task_approve_user varchar2(10) -- 预受理任务审核提交用户
    ,pre_task_approve_time varchar2(20) -- 预受理任务审核时间（yyyy-MM-dd hh:mm:ss）
    ,endorser_num varchar2(10) -- 背书人数
    ,endorsers varchar2(4000) -- 最后一手背书人
    ,unfreeze_flow_no varchar2(40) -- 流水号-作为对账流水、解冻时的原流水号（UPP流水）
    ,passbook_voucher_no varchar2(20) -- 存折凭证号码
    ,acct_level varchar2(20) -- SECOND-ACCT:二类户；THIRD-ACCT:三类户
    ,delay_flag varchar2(1) -- 是否延迟结算,1-是，2-否
    ,acct_nature varchar2(4) -- 账户性质[JJSB-基金社保 CZCK-财政性存款 GJJ-公积金 QT-其他]
    ,regulator_flag varchar2(1) -- 监管账户标识，0-无，1-监管账户
    ,transfer_flag varchar2(1) -- 行内转账标识 1-行内转账 其他-行外
    ,payee_acct_level varchar2(20) -- 收款方账户级别
    ,payee_cust_type varchar2(1) -- 客户类型 1-个人客户 2-对公客户 3-同业客户 4-内部客户
    ,pay_acct_type varchar2(4) -- 付款人账户类型
    ,doc_id varchar2(50) -- 影像ID
    ,glob_seq_num varchar2(33) -- 全局流水号
    ,bank_no varchar2(50) -- 银行号
    ,system_no varchar2(50) -- 系统号
    ,organ_no varchar2(20) -- 机构号
    ,pay_name varchar2(200) -- 付款人名称
    ,pay_acct_no varchar2(32) -- 付款人账号
    ,vouch_group varchar2(32) -- 业务场景凭证组合
    ,model_code varchar2(10) -- 影像模型
    ,busi_start_date varchar2(16) -- 影像上传时间
    ,over_amt number(20,2) -- 法透金额
    ,open_br_no varchar2(6) -- 付款人开户机构
    ,budg_level varchar2(1) -- 预算级次
    ,cnter_acct_date varchar2(8) -- 柜面记账日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.scps_bp_remit_tb to ${iml_schema};
grant select on ${iol_schema}.scps_bp_remit_tb to ${icl_schema};
grant select on ${iol_schema}.scps_bp_remit_tb to ${idl_schema};
grant select on ${iol_schema}.scps_bp_remit_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_bp_remit_tb is '汇兑业务表';
comment on column ${iol_schema}.scps_bp_remit_tb.task_id is '任务号';
comment on column ${iol_schema}.scps_bp_remit_tb.trans_date is '交易日期（yyyyMMdd)';
comment on column ${iol_schema}.scps_bp_remit_tb.trans_time is '交易时间';
comment on column ${iol_schema}.scps_bp_remit_tb.trans_state is '处理状态[1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]';
comment on column ${iol_schema}.scps_bp_remit_tb.trans_channel is '业务渠道';
comment on column ${iol_schema}.scps_bp_remit_tb.business_code is '业务场景码';
comment on column ${iol_schema}.scps_bp_remit_tb.user_id is '交易柜员编号';
comment on column ${iol_schema}.scps_bp_remit_tb.charge_id is '授权柜员号';
comment on column ${iol_schema}.scps_bp_remit_tb.branch_code is '前台机构号';
comment on column ${iol_schema}.scps_bp_remit_tb.business_kind is '业务种类 1-对私业务、2-对公业务';
comment on column ${iol_schema}.scps_bp_remit_tb.business_type is '业务类型 1.普通汇兑（对公结算户） 2.普通汇兑（内部户） 3.公益性资金汇划 4.国库汇款';
comment on column ${iol_schema}.scps_bp_remit_tb.voucher_code is '凭证代码 786-结算业务委托书、780-支票、999-其他';
comment on column ${iol_schema}.scps_bp_remit_tb.voucher_no is '凭证号码';
comment on column ${iol_schema}.scps_bp_remit_tb.cust_no is '客户号 本行付款人时才有';
comment on column ${iol_schema}.scps_bp_remit_tb.cust_name is '客户名称';
comment on column ${iol_schema}.scps_bp_remit_tb.transfer_type is '现转标志0-现金、1-转账、2-其他（非资金类交易）';
comment on column ${iol_schema}.scps_bp_remit_tb.currency_code is '币种';
comment on column ${iol_schema}.scps_bp_remit_tb.pay_channel is '支付渠道(1-现代化支付系统大额系统、2-现代化支付系统小额系统)';
comment on column ${iol_schema}.scps_bp_remit_tb.pay_type is '支取方式 (空)-无 A-密码D-印鉴E-证件F-印密G-支付密码H-无限制I-印鉴加支付密码';
comment on column ${iol_schema}.scps_bp_remit_tb.drawee_name is '付款人名称';
comment on column ${iol_schema}.scps_bp_remit_tb.drawee_acct_no is '交易对手账号';
comment on column ${iol_schema}.scps_bp_remit_tb.drawee_cert_type is '交易对手证件类型';
comment on column ${iol_schema}.scps_bp_remit_tb.drawee_cert_no is '交易对手证件号码';
comment on column ${iol_schema}.scps_bp_remit_tb.drawee_cert_date is '付款人证件到期日 格式yyyyMMdd';
comment on column ${iol_schema}.scps_bp_remit_tb.drawee_phone is '付款人联系方式 可以是固话或手机';
comment on column ${iol_schema}.scps_bp_remit_tb.payee_name is '交易对手名称';
comment on column ${iol_schema}.scps_bp_remit_tb.payee_acct_no is '收款人账号';
comment on column ${iol_schema}.scps_bp_remit_tb.trans_amount is '交易金额 例如100.00';
comment on column ${iol_schema}.scps_bp_remit_tb.trans_amount_ch is '交易金额(大写)';
comment on column ${iol_schema}.scps_bp_remit_tb.is_proxy is '是否代理 0-不代理，1-代理';
comment on column ${iol_schema}.scps_bp_remit_tb.proxy_name is '代办人姓名';
comment on column ${iol_schema}.scps_bp_remit_tb.proxy_cert_type is '代办人证件类型';
comment on column ${iol_schema}.scps_bp_remit_tb.proxy_cert_no is '代办人证件号码';
comment on column ${iol_schema}.scps_bp_remit_tb.proxy_cert_date is '交易代办人证件到期日期';
comment on column ${iol_schema}.scps_bp_remit_tb.fee_type is '收费方式';
comment on column ${iol_schema}.scps_bp_remit_tb.fee_amount is '手续费';
comment on column ${iol_schema}.scps_bp_remit_tb.remit_priority is '汇兑优先级 1-普通2-加急3-次日';
comment on column ${iol_schema}.scps_bp_remit_tb.city_priority is '同城异地 1-同城、2-异地(保留)';
comment on column ${iol_schema}.scps_bp_remit_tb.trans_method is '交易方式 010106-信汇 010104-电汇 000001-银行承兑汇票 000003-本票 000151-其他';
comment on column ${iol_schema}.scps_bp_remit_tb.purpose is '用途（附言）';
comment on column ${iol_schema}.scps_bp_remit_tb.transfer_reason is '转账原因';
comment on column ${iol_schema}.scps_bp_remit_tb.debt_flag is '入账标志 0-未入帐1-已入帐';
comment on column ${iol_schema}.scps_bp_remit_tb.drawee_bank_no is '付款行名号';
comment on column ${iol_schema}.scps_bp_remit_tb.drawee_bank_name is '付款行名称';
comment on column ${iol_schema}.scps_bp_remit_tb.payee_bank_no is '收款行行号';
comment on column ${iol_schema}.scps_bp_remit_tb.payee_bank_name is '收款行名称';
comment on column ${iol_schema}.scps_bp_remit_tb.bill_date is '出票日期 格式yyyyMMdd';
comment on column ${iol_schema}.scps_bp_remit_tb.return_reason is '退票理由';
comment on column ${iol_schema}.scps_bp_remit_tb.ticket_type is '票据类型 1支票，2银行汇票3银行本票';
comment on column ${iol_schema}.scps_bp_remit_tb.ticket_count is '票据张数';
comment on column ${iol_schema}.scps_bp_remit_tb.ticket_no is '票据号码';
comment on column ${iol_schema}.scps_bp_remit_tb.call_result is '外呼结果 外呼结果(1-查证成功，2-查证失败，3-查证不通)';
comment on column ${iol_schema}.scps_bp_remit_tb.call_person_num is '外呼应呼人数';
comment on column ${iol_schema}.scps_bp_remit_tb.call_timeout_flag is '外呼强制超时 0-不强制超时1-强制超时';
comment on column ${iol_schema}.scps_bp_remit_tb.call_timeout_user_id is '外呼强制超时操作柜员';
comment on column ${iol_schema}.scps_bp_remit_tb.call_timeout_charge_id is '外呼强制超时授权柜员';
comment on column ${iol_schema}.scps_bp_remit_tb.drawee_address is '付款人地址';
comment on column ${iol_schema}.scps_bp_remit_tb.payee_address is '收款人地址';
comment on column ${iol_schema}.scps_bp_remit_tb.post_fee is '汇划费';
comment on column ${iol_schema}.scps_bp_remit_tb.cost_fee is '工本费';
comment on column ${iol_schema}.scps_bp_remit_tb.remark is '摘要码';
comment on column ${iol_schema}.scps_bp_remit_tb.payee_corp_flag is '收款人个人对公标志';
comment on column ${iol_schema}.scps_bp_remit_tb.withhold_acct_no is '实际扣帐账号 内部账户时必输';
comment on column ${iol_schema}.scps_bp_remit_tb.withhold_acct_name is '实际扣帐户名 内部账户时必输';
comment on column ${iol_schema}.scps_bp_remit_tb.inside_acct_flag is '内部账户标识 0非内部账户 1内部账户';
comment on column ${iol_schema}.scps_bp_remit_tb.pay_send_seqno is '发送支付系统报文流水号';
comment on column ${iol_schema}.scps_bp_remit_tb.pay_host_seqno is '支付系统响应的主机流水';
comment on column ${iol_schema}.scps_bp_remit_tb.pay_business_no is '支付系统业务序号';
comment on column ${iol_schema}.scps_bp_remit_tb.pay_send_date is '支付报文交易日期';
comment on column ${iol_schema}.scps_bp_remit_tb.pay_host_date is '支付主机交易日期';
comment on column ${iol_schema}.scps_bp_remit_tb.drawee_core_tel is '付款人核心联系方式';
comment on column ${iol_schema}.scps_bp_remit_tb.tally_state is '记账状态 0 未记账 1 记账成功 2 退客户账成功';
comment on column ${iol_schema}.scps_bp_remit_tb.tally_flow_no is '记账报文流水号';
comment on column ${iol_schema}.scps_bp_remit_tb.tally_host_no is '记账核心交易流水';
comment on column ${iol_schema}.scps_bp_remit_tb.tally_host_date is '核心交易日期';
comment on column ${iol_schema}.scps_bp_remit_tb.submit_state is '业务提交状态 0-未提交，1-处理中 2-提交成功';
comment on column ${iol_schema}.scps_bp_remit_tb.drawee_info_send_flag is '收款人信息处理标志 0-未处理 1-处理中 2-处理成功';
comment on column ${iol_schema}.scps_bp_remit_tb.drawee_info_send_result is '收款人信息处理结果 处理结果描述';
comment on column ${iol_schema}.scps_bp_remit_tb.drawee_info_send_time is '收款人信息处理时间  格式为yyyy-MM-dd';
comment on column ${iol_schema}.scps_bp_remit_tb.pre_task_id is '预受理任务编号';
comment on column ${iol_schema}.scps_bp_remit_tb.pre_task_status is '预受理任务状态 0-已受理，1-预审通过，2-预审不通过，3-已超期，4-作废';
comment on column ${iol_schema}.scps_bp_remit_tb.pre_task_result is '预审核结论';
comment on column ${iol_schema}.scps_bp_remit_tb.pre_task_approve_user is '预受理任务审核提交用户';
comment on column ${iol_schema}.scps_bp_remit_tb.pre_task_approve_time is '预受理任务审核时间（yyyy-MM-dd hh:mm:ss）';
comment on column ${iol_schema}.scps_bp_remit_tb.endorser_num is '背书人数';
comment on column ${iol_schema}.scps_bp_remit_tb.endorsers is '最后一手背书人';
comment on column ${iol_schema}.scps_bp_remit_tb.unfreeze_flow_no is '流水号-作为对账流水、解冻时的原流水号（UPP流水）';
comment on column ${iol_schema}.scps_bp_remit_tb.passbook_voucher_no is '存折凭证号码';
comment on column ${iol_schema}.scps_bp_remit_tb.acct_level is 'SECOND-ACCT:二类户；THIRD-ACCT:三类户';
comment on column ${iol_schema}.scps_bp_remit_tb.delay_flag is '是否延迟结算,1-是，2-否';
comment on column ${iol_schema}.scps_bp_remit_tb.acct_nature is '账户性质[JJSB-基金社保 CZCK-财政性存款 GJJ-公积金 QT-其他]';
comment on column ${iol_schema}.scps_bp_remit_tb.regulator_flag is '监管账户标识，0-无，1-监管账户';
comment on column ${iol_schema}.scps_bp_remit_tb.transfer_flag is '行内转账标识 1-行内转账 其他-行外';
comment on column ${iol_schema}.scps_bp_remit_tb.payee_acct_level is '收款方账户级别';
comment on column ${iol_schema}.scps_bp_remit_tb.payee_cust_type is '客户类型 1-个人客户 2-对公客户 3-同业客户 4-内部客户';
comment on column ${iol_schema}.scps_bp_remit_tb.pay_acct_type is '付款人账户类型';
comment on column ${iol_schema}.scps_bp_remit_tb.doc_id is '影像ID';
comment on column ${iol_schema}.scps_bp_remit_tb.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.scps_bp_remit_tb.bank_no is '银行号';
comment on column ${iol_schema}.scps_bp_remit_tb.system_no is '系统号';
comment on column ${iol_schema}.scps_bp_remit_tb.organ_no is '机构号';
comment on column ${iol_schema}.scps_bp_remit_tb.pay_name is '付款人名称';
comment on column ${iol_schema}.scps_bp_remit_tb.pay_acct_no is '付款人账号';
comment on column ${iol_schema}.scps_bp_remit_tb.vouch_group is '业务场景凭证组合';
comment on column ${iol_schema}.scps_bp_remit_tb.model_code is '影像模型';
comment on column ${iol_schema}.scps_bp_remit_tb.busi_start_date is '影像上传时间';
comment on column ${iol_schema}.scps_bp_remit_tb.over_amt is '法透金额';
comment on column ${iol_schema}.scps_bp_remit_tb.open_br_no is '付款人开户机构';
comment on column ${iol_schema}.scps_bp_remit_tb.budg_level is '预算级次';
comment on column ${iol_schema}.scps_bp_remit_tb.cnter_acct_date is '柜面记账日期';
comment on column ${iol_schema}.scps_bp_remit_tb.start_dt is '开始时间';
comment on column ${iol_schema}.scps_bp_remit_tb.end_dt is '结束时间';
comment on column ${iol_schema}.scps_bp_remit_tb.id_mark is '增删标志';
comment on column ${iol_schema}.scps_bp_remit_tb.etl_timestamp is 'ETL处理时间戳';
