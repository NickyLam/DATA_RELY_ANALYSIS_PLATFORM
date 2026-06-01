/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_accept_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_accept_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_accept_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_accept_contract(
    id varchar2(60) -- ID
    ,contract_no varchar2(45) -- 批次协议号
    ,draft_attr varchar2(6) -- 票据介质： 1 纸票 2 电票
    ,product_no varchar2(12) -- 产品号
    ,product_attr varchar2(5) -- 产品属性
    ,remitter_name varchar2(270) -- 出票人名称
    ,remitter_acct varchar2(75) -- 出票人账号
    ,remitter_bank_no varchar2(18) -- 出票人开户行行号
    ,remitter_bank_name varchar2(270) -- 出票人开户行名称
    ,remitter_cust_no varchar2(30) -- 出票人客户号
    ,remitter_soc_code varchar2(27) -- 出票人社会信用代码
    ,remitter_type varchar2(6) -- 出票人类型
    ,remitter_brh_no varchar2(14) -- 出票人开户机构代码
    ,payer_bank_no varchar2(18) -- 付款行行号
    ,payer_bank_name varchar2(270) -- 付款行名称
    ,acceptor_bank_no varchar2(18) -- 承兑人行号
    ,acceptor_bank_name varchar2(270) -- 承兑人名称
    ,acceptor_brh_no varchar2(14) -- 承兑人机构代码
    ,deposit_type varchar2(2) -- 保证金类型： 1 一对一 2 一对多
    ,deposit_ratio number(18,8) -- 保证金比例（%）
    ,pledge_no varchar2(45) -- 抵质押编号
    ,pledge_amt number(18,2) -- 抵质押价值
    ,pledge_type varchar2(2) -- 担保方式：
    ,contract_status varchar2(3) -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,sign_status varchar2(3) -- 签收状态： 00 未签收 01 部分签收 02 已签收
    ,credit_status varchar2(3) -- 授信状态： 00 额度未占用 01 额度占用成功 02 额度占用失败
    ,risk_status varchar2(3) -- 风险检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
    ,accept_status varchar2(3) -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
    ,acceptor_ratg_agcy varchar2(300) -- 承兑人信用主体
    ,acceptor_ratg_duedt varchar2(12) -- 承兑人评级到期日
    ,acceptor_credit_ratgs varchar2(5) -- 承兑人信用等级
    ,credit_no varchar2(45) -- 信贷合同编号
    ,credit_contract_amt number(18,2) -- 信贷合同金额
    ,credit_flowno varchar2(60) -- 信贷流水号
    ,department_no varchar2(30) -- 部门编号
    ,department_name varchar2(270) -- 部门名称
    ,manager_no varchar2(30) -- 客户经理编号
    ,manager_name varchar2(270) -- 客户经理名称
    ,agency_name varchar2(270) -- 被代理人名称
    ,agency_account varchar2(75) -- 被代理人账号
    ,agency_bank_name varchar2(270) -- 被代理行全称
    ,agency_bank_no varchar2(18) -- 被代理行行号
    ,entrust_cust_no varchar2(30) -- 委托客户号
    ,actually_industy varchar2(15) -- 实际投向行业
    ,busi_branch_no varchar2(18) -- 交易机构编号
    ,account_branch_no varchar2(30) -- 账务机构号
    ,top_branch_no varchar2(30) -- 总机构号
    ,create_operator varchar2(45) -- 创建操作员
    ,create_time varchar2(21) -- 创建时间
    ,last_operator varchar2(45) -- 最后修改操作员
    ,last_update_time varchar2(21) -- 最后修改时间
    ,reserve1 varchar2(384) -- 备用字段1
    ,reserve2 varchar2(384) -- 备用字段2
    ,reserve3 varchar2(384) -- 备用字段3
    ,busi_date varchar2(12) -- 承兑签发日期
    ,task_type varchar2(3) -- 来源
    ,webbank_contract_id number(22,0) -- 网银承兑协议ID
    ,draft_type varchar2(2) -- 票据类型：1 银票2 商票
    ,apply_accept_amount number(20,2) -- 申请承兑金额
    ,apply_remit_date varchar2(12) -- 申请出票日
    ,maturity_date varchar2(12) -- 到期日
    ,apply_reason varchar2(300) -- 申请原因和用途
    ,first_repayment_acct varchar2(75) -- 第一还款账号
    ,charge_scale number(8,8) -- 手续费比例
    ,trans_amount number(29,2) -- 交易金额
    ,credit_check_status varchar2(2) -- 授信检查0-未检查1-检查成功2-检查失败
    ,data_source_type varchar2(2) -- 数据来源类型1、系统手工录入2、接收网银数据
    ,misc varchar2(150) -- 信息域
    ,main_assure_type varchar2(90) -- 主要担保方式
    ,manage_fee number(20,2) -- 管理费
    ,accept_fee number(20,2) -- 承兑费
    ,contract_date varchar2(30) -- 信贷返回的协议到期日
    ,acct_amount number(20,2) -- 结算账号余额
    ,all_credit_exp number(20,2) -- 已批准使用授信敞口
    ,total_use_credit_exp number(20,2) -- 本次放款后累计使用敞口
    ,cert_type varchar2(15) -- 证件类型
    ,cert_id varchar2(75) -- 证件ID
    ,report_url varchar2(375) -- 征信报告URL
    ,core_enterprise varchar2(120) -- 核心企业名称
    ,core_enterprise_cmoncd varchar2(48) -- 核心企业组织机构代码
    ,batch_no varchar2(30) -- 网银批量号码
    ,file_name varchar2(150) -- 走文件方式文件名
    ,is_related varchar2(3) -- 是否关联方查询 Y-是我行关联方N-未在我行关联方信息库中找出完全匹配信息P-关联方是自然人，须同时输入姓名和证件号进行查询M-通过输入信息查询出多个关联方,请输入更详细的信息进行查询L-名称非常接近，请做进一步核实
    ,bail_term varchar2(6) -- 保证金期限 000 活期203 三个月206 六个月301 一年302 两年303 三年305 五年
    ,bail_account varchar2(75) -- 保证金账号
    ,bail_type varchar2(6) -- 保证金类型 PG01 定期PG02 活期AC99 协议
    ,rates_type varchar2(6) -- 利率类型  0 我行挂牌利率1 协议利率2 浮动利率
    ,bail_rate number(9,6) -- 保证金利率
    ,pdrifd varchar2(75) -- 保证金利率浮动类型
    ,pdrifm varchar2(75) -- 保证金利率浮动方式
    ,pdrifv number(20,2) -- 保证金浮动值
    ,business_exp number(20,2) -- 业务合同占用敞口金额
    ,low_risk varchar2(2) -- 是否低风险业务
    ,ratio_exp number(8,5) -- 敞口比例
    ,credit_protocol_no varchar2(75) -- 信贷业务合同号
    ,unique_seq_num varchar2(50) -- 业务流水号(交易订单号)
    ,drawee_bank_no number(22,0) -- 付款行号
    ,charge_ratio number(8,5) -- 手续费比例（%）
    ,credit_fee_ratio number(8,5) -- 额度管理费比例（%）
    ,acct_status varchar2(3) -- 
    ,send_file_status varchar2(3) -- 
    ,exposure_type varchar2(3) -- 敞口类型 0-低风险 1-类低风险 2-敞口
    ,exposure_amount number(18,2) -- 敞口金额
    ,is_adjust_deposit varchar2(1) -- 是否调整存款收益 0-否 1-是
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
grant select on ${iol_schema}.bdms_cpes_accept_contract to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_accept_contract to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_accept_contract to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_accept_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_accept_contract is '承兑批次表';
comment on column ${iol_schema}.bdms_cpes_accept_contract.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_accept_contract.contract_no is '批次协议号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.draft_attr is '票据介质： 1 纸票 2 电票';
comment on column ${iol_schema}.bdms_cpes_accept_contract.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.product_attr is '产品属性';
comment on column ${iol_schema}.bdms_cpes_accept_contract.remitter_name is '出票人名称';
comment on column ${iol_schema}.bdms_cpes_accept_contract.remitter_acct is '出票人账号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.remitter_bank_no is '出票人开户行行号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.remitter_bank_name is '出票人开户行名称';
comment on column ${iol_schema}.bdms_cpes_accept_contract.remitter_cust_no is '出票人客户号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.remitter_soc_code is '出票人社会信用代码';
comment on column ${iol_schema}.bdms_cpes_accept_contract.remitter_type is '出票人类型';
comment on column ${iol_schema}.bdms_cpes_accept_contract.remitter_brh_no is '出票人开户机构代码';
comment on column ${iol_schema}.bdms_cpes_accept_contract.payer_bank_no is '付款行行号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.payer_bank_name is '付款行名称';
comment on column ${iol_schema}.bdms_cpes_accept_contract.acceptor_bank_no is '承兑人行号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.acceptor_bank_name is '承兑人名称';
comment on column ${iol_schema}.bdms_cpes_accept_contract.acceptor_brh_no is '承兑人机构代码';
comment on column ${iol_schema}.bdms_cpes_accept_contract.deposit_type is '保证金类型： 1 一对一 2 一对多';
comment on column ${iol_schema}.bdms_cpes_accept_contract.deposit_ratio is '保证金比例（%）';
comment on column ${iol_schema}.bdms_cpes_accept_contract.pledge_no is '抵质押编号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.pledge_amt is '抵质押价值';
comment on column ${iol_schema}.bdms_cpes_accept_contract.pledge_type is '担保方式：';
comment on column ${iol_schema}.bdms_cpes_accept_contract.contract_status is '审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝';
comment on column ${iol_schema}.bdms_cpes_accept_contract.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_accept_contract.sign_status is '签收状态： 00 未签收 01 部分签收 02 已签收';
comment on column ${iol_schema}.bdms_cpes_accept_contract.credit_status is '授信状态： 00 额度未占用 01 额度占用成功 02 额度占用失败';
comment on column ${iol_schema}.bdms_cpes_accept_contract.risk_status is '风险检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过';
comment on column ${iol_schema}.bdms_cpes_accept_contract.accept_status is '协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)';
comment on column ${iol_schema}.bdms_cpes_accept_contract.acceptor_ratg_agcy is '承兑人信用主体';
comment on column ${iol_schema}.bdms_cpes_accept_contract.acceptor_ratg_duedt is '承兑人评级到期日';
comment on column ${iol_schema}.bdms_cpes_accept_contract.acceptor_credit_ratgs is '承兑人信用等级';
comment on column ${iol_schema}.bdms_cpes_accept_contract.credit_no is '信贷合同编号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.credit_contract_amt is '信贷合同金额';
comment on column ${iol_schema}.bdms_cpes_accept_contract.credit_flowno is '信贷流水号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.department_no is '部门编号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.department_name is '部门名称';
comment on column ${iol_schema}.bdms_cpes_accept_contract.manager_no is '客户经理编号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.manager_name is '客户经理名称';
comment on column ${iol_schema}.bdms_cpes_accept_contract.agency_name is '被代理人名称';
comment on column ${iol_schema}.bdms_cpes_accept_contract.agency_account is '被代理人账号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.agency_bank_name is '被代理行全称';
comment on column ${iol_schema}.bdms_cpes_accept_contract.agency_bank_no is '被代理行行号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.entrust_cust_no is '委托客户号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.actually_industy is '实际投向行业';
comment on column ${iol_schema}.bdms_cpes_accept_contract.busi_branch_no is '交易机构编号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.account_branch_no is '账务机构号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.top_branch_no is '总机构号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.create_operator is '创建操作员';
comment on column ${iol_schema}.bdms_cpes_accept_contract.create_time is '创建时间';
comment on column ${iol_schema}.bdms_cpes_accept_contract.last_operator is '最后修改操作员';
comment on column ${iol_schema}.bdms_cpes_accept_contract.last_update_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_accept_contract.reserve1 is '备用字段1';
comment on column ${iol_schema}.bdms_cpes_accept_contract.reserve2 is '备用字段2';
comment on column ${iol_schema}.bdms_cpes_accept_contract.reserve3 is '备用字段3';
comment on column ${iol_schema}.bdms_cpes_accept_contract.busi_date is '承兑签发日期';
comment on column ${iol_schema}.bdms_cpes_accept_contract.task_type is '来源';
comment on column ${iol_schema}.bdms_cpes_accept_contract.webbank_contract_id is '网银承兑协议ID';
comment on column ${iol_schema}.bdms_cpes_accept_contract.draft_type is '票据类型：1 银票2 商票';
comment on column ${iol_schema}.bdms_cpes_accept_contract.apply_accept_amount is '申请承兑金额';
comment on column ${iol_schema}.bdms_cpes_accept_contract.apply_remit_date is '申请出票日';
comment on column ${iol_schema}.bdms_cpes_accept_contract.maturity_date is '到期日';
comment on column ${iol_schema}.bdms_cpes_accept_contract.apply_reason is '申请原因和用途';
comment on column ${iol_schema}.bdms_cpes_accept_contract.first_repayment_acct is '第一还款账号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.charge_scale is '手续费比例';
comment on column ${iol_schema}.bdms_cpes_accept_contract.trans_amount is '交易金额';
comment on column ${iol_schema}.bdms_cpes_accept_contract.credit_check_status is '授信检查0-未检查1-检查成功2-检查失败';
comment on column ${iol_schema}.bdms_cpes_accept_contract.data_source_type is '数据来源类型1、系统手工录入2、接收网银数据';
comment on column ${iol_schema}.bdms_cpes_accept_contract.misc is '信息域';
comment on column ${iol_schema}.bdms_cpes_accept_contract.main_assure_type is '主要担保方式';
comment on column ${iol_schema}.bdms_cpes_accept_contract.manage_fee is '管理费';
comment on column ${iol_schema}.bdms_cpes_accept_contract.accept_fee is '承兑费';
comment on column ${iol_schema}.bdms_cpes_accept_contract.contract_date is '信贷返回的协议到期日';
comment on column ${iol_schema}.bdms_cpes_accept_contract.acct_amount is '结算账号余额';
comment on column ${iol_schema}.bdms_cpes_accept_contract.all_credit_exp is '已批准使用授信敞口';
comment on column ${iol_schema}.bdms_cpes_accept_contract.total_use_credit_exp is '本次放款后累计使用敞口';
comment on column ${iol_schema}.bdms_cpes_accept_contract.cert_type is '证件类型';
comment on column ${iol_schema}.bdms_cpes_accept_contract.cert_id is '证件ID';
comment on column ${iol_schema}.bdms_cpes_accept_contract.report_url is '征信报告URL';
comment on column ${iol_schema}.bdms_cpes_accept_contract.core_enterprise is '核心企业名称';
comment on column ${iol_schema}.bdms_cpes_accept_contract.core_enterprise_cmoncd is '核心企业组织机构代码';
comment on column ${iol_schema}.bdms_cpes_accept_contract.batch_no is '网银批量号码';
comment on column ${iol_schema}.bdms_cpes_accept_contract.file_name is '走文件方式文件名';
comment on column ${iol_schema}.bdms_cpes_accept_contract.is_related is '是否关联方查询 Y-是我行关联方N-未在我行关联方信息库中找出完全匹配信息P-关联方是自然人，须同时输入姓名和证件号进行查询M-通过输入信息查询出多个关联方,请输入更详细的信息进行查询L-名称非常接近，请做进一步核实';
comment on column ${iol_schema}.bdms_cpes_accept_contract.bail_term is '保证金期限 000 活期203 三个月206 六个月301 一年302 两年303 三年305 五年';
comment on column ${iol_schema}.bdms_cpes_accept_contract.bail_account is '保证金账号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.bail_type is '保证金类型 PG01 定期PG02 活期AC99 协议';
comment on column ${iol_schema}.bdms_cpes_accept_contract.rates_type is '利率类型  0 我行挂牌利率1 协议利率2 浮动利率';
comment on column ${iol_schema}.bdms_cpes_accept_contract.bail_rate is '保证金利率';
comment on column ${iol_schema}.bdms_cpes_accept_contract.pdrifd is '保证金利率浮动类型';
comment on column ${iol_schema}.bdms_cpes_accept_contract.pdrifm is '保证金利率浮动方式';
comment on column ${iol_schema}.bdms_cpes_accept_contract.pdrifv is '保证金浮动值';
comment on column ${iol_schema}.bdms_cpes_accept_contract.business_exp is '业务合同占用敞口金额';
comment on column ${iol_schema}.bdms_cpes_accept_contract.low_risk is '是否低风险业务';
comment on column ${iol_schema}.bdms_cpes_accept_contract.ratio_exp is '敞口比例';
comment on column ${iol_schema}.bdms_cpes_accept_contract.credit_protocol_no is '信贷业务合同号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.unique_seq_num is '业务流水号(交易订单号)';
comment on column ${iol_schema}.bdms_cpes_accept_contract.drawee_bank_no is '付款行号';
comment on column ${iol_schema}.bdms_cpes_accept_contract.charge_ratio is '手续费比例（%）';
comment on column ${iol_schema}.bdms_cpes_accept_contract.credit_fee_ratio is '额度管理费比例（%）';
comment on column ${iol_schema}.bdms_cpes_accept_contract.acct_status is '';
comment on column ${iol_schema}.bdms_cpes_accept_contract.send_file_status is '';
comment on column ${iol_schema}.bdms_cpes_accept_contract.exposure_type is '敞口类型 0-低风险 1-类低风险 2-敞口';
comment on column ${iol_schema}.bdms_cpes_accept_contract.exposure_amount is '敞口金额';
comment on column ${iol_schema}.bdms_cpes_accept_contract.is_adjust_deposit is '是否调整存款收益 0-否 1-是';
comment on column ${iol_schema}.bdms_cpes_accept_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_accept_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_accept_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_accept_contract.etl_timestamp is 'ETL处理时间戳';
