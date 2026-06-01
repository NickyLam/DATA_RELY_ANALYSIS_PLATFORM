/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_accept_contract
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
create table ${iol_schema}.bdms_cpes_accept_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_accept_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_accept_contract_op purge;
drop table ${iol_schema}.bdms_cpes_accept_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_accept_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_accept_contract where 0=1;

create table ${iol_schema}.bdms_cpes_accept_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_accept_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_accept_contract_cl(
            id -- ID
            ,contract_no -- 批次协议号
            ,draft_attr -- 票据介质： 1 纸票 2 电票
            ,product_no -- 产品号
            ,product_attr -- 产品属性
            ,remitter_name -- 出票人名称
            ,remitter_acct -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_cust_no -- 出票人客户号
            ,remitter_soc_code -- 出票人社会信用代码
            ,remitter_type -- 出票人类型
            ,remitter_brh_no -- 出票人开户机构代码
            ,payer_bank_no -- 付款行行号
            ,payer_bank_name -- 付款行名称
            ,acceptor_bank_no -- 承兑人行号
            ,acceptor_bank_name -- 承兑人名称
            ,acceptor_brh_no -- 承兑人机构代码
            ,deposit_type -- 保证金类型： 1 一对一 2 一对多
            ,deposit_ratio -- 保证金比例（%）
            ,pledge_no -- 抵质押编号
            ,pledge_amt -- 抵质押价值
            ,pledge_type -- 担保方式：
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,sign_status -- 签收状态： 00 未签收 01 部分签收 02 已签收
            ,credit_status -- 授信状态： 00 额度未占用 01 额度占用成功 02 额度占用失败
            ,risk_status -- 风险检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,accept_status -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
            ,acceptor_ratg_agcy -- 承兑人信用主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,credit_no -- 信贷合同编号
            ,credit_contract_amt -- 信贷合同金额
            ,credit_flowno -- 信贷流水号
            ,department_no -- 部门编号
            ,department_name -- 部门名称
            ,manager_no -- 客户经理编号
            ,manager_name -- 客户经理名称
            ,agency_name -- 被代理人名称
            ,agency_account -- 被代理人账号
            ,agency_bank_name -- 被代理行全称
            ,agency_bank_no -- 被代理行行号
            ,entrust_cust_no -- 委托客户号
            ,actually_industy -- 实际投向行业
            ,busi_branch_no -- 交易机构编号
            ,account_branch_no -- 账务机构号
            ,top_branch_no -- 总机构号
            ,create_operator -- 创建操作员
            ,create_time -- 创建时间
            ,last_operator -- 最后修改操作员
            ,last_update_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,busi_date -- 承兑签发日期
            ,task_type -- 来源
            ,webbank_contract_id -- 网银承兑协议ID
            ,draft_type -- 票据类型：1 银票2 商票
            ,apply_accept_amount -- 申请承兑金额
            ,apply_remit_date -- 申请出票日
            ,maturity_date -- 到期日
            ,apply_reason -- 申请原因和用途
            ,first_repayment_acct -- 第一还款账号
            ,charge_scale -- 手续费比例
            ,trans_amount -- 交易金额
            ,credit_check_status -- 授信检查0-未检查1-检查成功2-检查失败
            ,data_source_type -- 数据来源类型1、系统手工录入2、接收网银数据
            ,misc -- 信息域
            ,main_assure_type -- 主要担保方式
            ,manage_fee -- 管理费
            ,accept_fee -- 承兑费
            ,contract_date -- 信贷返回的协议到期日
            ,acct_amount -- 结算账号余额
            ,all_credit_exp -- 已批准使用授信敞口
            ,total_use_credit_exp -- 本次放款后累计使用敞口
            ,cert_type -- 证件类型
            ,cert_id -- 证件ID
            ,report_url -- 征信报告URL
            ,core_enterprise -- 核心企业名称
            ,core_enterprise_cmoncd -- 核心企业组织机构代码
            ,batch_no -- 网银批量号码
            ,file_name -- 走文件方式文件名
            ,is_related -- 是否关联方查询 Y-是我行关联方N-未在我行关联方信息库中找出完全匹配信息P-关联方是自然人，须同时输入姓名和证件号进行查询M-通过输入信息查询出多个关联方,请输入更详细的信息进行查询L-名称非常接近，请做进一步核实
            ,bail_term -- 保证金期限 000 活期203 三个月206 六个月301 一年302 两年303 三年305 五年
            ,bail_account -- 保证金账号
            ,bail_type -- 保证金类型 PG01 定期PG02 活期AC99 协议
            ,rates_type -- 利率类型  0 我行挂牌利率1 协议利率2 浮动利率
            ,bail_rate -- 保证金利率
            ,pdrifd -- 保证金利率浮动类型
            ,pdrifm -- 保证金利率浮动方式
            ,pdrifv -- 保证金浮动值
            ,business_exp -- 业务合同占用敞口金额
            ,low_risk -- 是否低风险业务
            ,ratio_exp -- 敞口比例
            ,credit_protocol_no -- 信贷业务合同号
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,drawee_bank_no -- 付款行号
            ,charge_ratio -- 手续费比例（%）
            ,credit_fee_ratio -- 额度管理费比例（%）
            ,acct_status -- 
            ,send_file_status -- 
            ,exposure_type -- 敞口类型 0-低风险 1-类低风险 2-敞口
            ,exposure_amount -- 敞口金额
            ,is_adjust_deposit -- 是否调整存款收益 0-否 1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_accept_contract_op(
            id -- ID
            ,contract_no -- 批次协议号
            ,draft_attr -- 票据介质： 1 纸票 2 电票
            ,product_no -- 产品号
            ,product_attr -- 产品属性
            ,remitter_name -- 出票人名称
            ,remitter_acct -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_cust_no -- 出票人客户号
            ,remitter_soc_code -- 出票人社会信用代码
            ,remitter_type -- 出票人类型
            ,remitter_brh_no -- 出票人开户机构代码
            ,payer_bank_no -- 付款行行号
            ,payer_bank_name -- 付款行名称
            ,acceptor_bank_no -- 承兑人行号
            ,acceptor_bank_name -- 承兑人名称
            ,acceptor_brh_no -- 承兑人机构代码
            ,deposit_type -- 保证金类型： 1 一对一 2 一对多
            ,deposit_ratio -- 保证金比例（%）
            ,pledge_no -- 抵质押编号
            ,pledge_amt -- 抵质押价值
            ,pledge_type -- 担保方式：
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,sign_status -- 签收状态： 00 未签收 01 部分签收 02 已签收
            ,credit_status -- 授信状态： 00 额度未占用 01 额度占用成功 02 额度占用失败
            ,risk_status -- 风险检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,accept_status -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
            ,acceptor_ratg_agcy -- 承兑人信用主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,credit_no -- 信贷合同编号
            ,credit_contract_amt -- 信贷合同金额
            ,credit_flowno -- 信贷流水号
            ,department_no -- 部门编号
            ,department_name -- 部门名称
            ,manager_no -- 客户经理编号
            ,manager_name -- 客户经理名称
            ,agency_name -- 被代理人名称
            ,agency_account -- 被代理人账号
            ,agency_bank_name -- 被代理行全称
            ,agency_bank_no -- 被代理行行号
            ,entrust_cust_no -- 委托客户号
            ,actually_industy -- 实际投向行业
            ,busi_branch_no -- 交易机构编号
            ,account_branch_no -- 账务机构号
            ,top_branch_no -- 总机构号
            ,create_operator -- 创建操作员
            ,create_time -- 创建时间
            ,last_operator -- 最后修改操作员
            ,last_update_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,busi_date -- 承兑签发日期
            ,task_type -- 来源
            ,webbank_contract_id -- 网银承兑协议ID
            ,draft_type -- 票据类型：1 银票2 商票
            ,apply_accept_amount -- 申请承兑金额
            ,apply_remit_date -- 申请出票日
            ,maturity_date -- 到期日
            ,apply_reason -- 申请原因和用途
            ,first_repayment_acct -- 第一还款账号
            ,charge_scale -- 手续费比例
            ,trans_amount -- 交易金额
            ,credit_check_status -- 授信检查0-未检查1-检查成功2-检查失败
            ,data_source_type -- 数据来源类型1、系统手工录入2、接收网银数据
            ,misc -- 信息域
            ,main_assure_type -- 主要担保方式
            ,manage_fee -- 管理费
            ,accept_fee -- 承兑费
            ,contract_date -- 信贷返回的协议到期日
            ,acct_amount -- 结算账号余额
            ,all_credit_exp -- 已批准使用授信敞口
            ,total_use_credit_exp -- 本次放款后累计使用敞口
            ,cert_type -- 证件类型
            ,cert_id -- 证件ID
            ,report_url -- 征信报告URL
            ,core_enterprise -- 核心企业名称
            ,core_enterprise_cmoncd -- 核心企业组织机构代码
            ,batch_no -- 网银批量号码
            ,file_name -- 走文件方式文件名
            ,is_related -- 是否关联方查询 Y-是我行关联方N-未在我行关联方信息库中找出完全匹配信息P-关联方是自然人，须同时输入姓名和证件号进行查询M-通过输入信息查询出多个关联方,请输入更详细的信息进行查询L-名称非常接近，请做进一步核实
            ,bail_term -- 保证金期限 000 活期203 三个月206 六个月301 一年302 两年303 三年305 五年
            ,bail_account -- 保证金账号
            ,bail_type -- 保证金类型 PG01 定期PG02 活期AC99 协议
            ,rates_type -- 利率类型  0 我行挂牌利率1 协议利率2 浮动利率
            ,bail_rate -- 保证金利率
            ,pdrifd -- 保证金利率浮动类型
            ,pdrifm -- 保证金利率浮动方式
            ,pdrifv -- 保证金浮动值
            ,business_exp -- 业务合同占用敞口金额
            ,low_risk -- 是否低风险业务
            ,ratio_exp -- 敞口比例
            ,credit_protocol_no -- 信贷业务合同号
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,drawee_bank_no -- 付款行号
            ,charge_ratio -- 手续费比例（%）
            ,credit_fee_ratio -- 额度管理费比例（%）
            ,acct_status -- 
            ,send_file_status -- 
            ,exposure_type -- 敞口类型 0-低风险 1-类低风险 2-敞口
            ,exposure_amount -- 敞口金额
            ,is_adjust_deposit -- 是否调整存款收益 0-否 1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 批次协议号
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质： 1 纸票 2 电票
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.product_attr, o.product_attr) as product_attr -- 产品属性
    ,nvl(n.remitter_name, o.remitter_name) as remitter_name -- 出票人名称
    ,nvl(n.remitter_acct, o.remitter_acct) as remitter_acct -- 出票人账号
    ,nvl(n.remitter_bank_no, o.remitter_bank_no) as remitter_bank_no -- 出票人开户行行号
    ,nvl(n.remitter_bank_name, o.remitter_bank_name) as remitter_bank_name -- 出票人开户行名称
    ,nvl(n.remitter_cust_no, o.remitter_cust_no) as remitter_cust_no -- 出票人客户号
    ,nvl(n.remitter_soc_code, o.remitter_soc_code) as remitter_soc_code -- 出票人社会信用代码
    ,nvl(n.remitter_type, o.remitter_type) as remitter_type -- 出票人类型
    ,nvl(n.remitter_brh_no, o.remitter_brh_no) as remitter_brh_no -- 出票人开户机构代码
    ,nvl(n.payer_bank_no, o.payer_bank_no) as payer_bank_no -- 付款行行号
    ,nvl(n.payer_bank_name, o.payer_bank_name) as payer_bank_name -- 付款行名称
    ,nvl(n.acceptor_bank_no, o.acceptor_bank_no) as acceptor_bank_no -- 承兑人行号
    ,nvl(n.acceptor_bank_name, o.acceptor_bank_name) as acceptor_bank_name -- 承兑人名称
    ,nvl(n.acceptor_brh_no, o.acceptor_brh_no) as acceptor_brh_no -- 承兑人机构代码
    ,nvl(n.deposit_type, o.deposit_type) as deposit_type -- 保证金类型： 1 一对一 2 一对多
    ,nvl(n.deposit_ratio, o.deposit_ratio) as deposit_ratio -- 保证金比例（%）
    ,nvl(n.pledge_no, o.pledge_no) as pledge_no -- 抵质押编号
    ,nvl(n.pledge_amt, o.pledge_amt) as pledge_amt -- 抵质押价值
    ,nvl(n.pledge_type, o.pledge_type) as pledge_type -- 担保方式：
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.sign_status, o.sign_status) as sign_status -- 签收状态： 00 未签收 01 部分签收 02 已签收
    ,nvl(n.credit_status, o.credit_status) as credit_status -- 授信状态： 00 额度未占用 01 额度占用成功 02 额度占用失败
    ,nvl(n.risk_status, o.risk_status) as risk_status -- 风险检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
    ,nvl(n.accept_status, o.accept_status) as accept_status -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
    ,nvl(n.acceptor_ratg_agcy, o.acceptor_ratg_agcy) as acceptor_ratg_agcy -- 承兑人信用主体
    ,nvl(n.acceptor_ratg_duedt, o.acceptor_ratg_duedt) as acceptor_ratg_duedt -- 承兑人评级到期日
    ,nvl(n.acceptor_credit_ratgs, o.acceptor_credit_ratgs) as acceptor_credit_ratgs -- 承兑人信用等级
    ,nvl(n.credit_no, o.credit_no) as credit_no -- 信贷合同编号
    ,nvl(n.credit_contract_amt, o.credit_contract_amt) as credit_contract_amt -- 信贷合同金额
    ,nvl(n.credit_flowno, o.credit_flowno) as credit_flowno -- 信贷流水号
    ,nvl(n.department_no, o.department_no) as department_no -- 部门编号
    ,nvl(n.department_name, o.department_name) as department_name -- 部门名称
    ,nvl(n.manager_no, o.manager_no) as manager_no -- 客户经理编号
    ,nvl(n.manager_name, o.manager_name) as manager_name -- 客户经理名称
    ,nvl(n.agency_name, o.agency_name) as agency_name -- 被代理人名称
    ,nvl(n.agency_account, o.agency_account) as agency_account -- 被代理人账号
    ,nvl(n.agency_bank_name, o.agency_bank_name) as agency_bank_name -- 被代理行全称
    ,nvl(n.agency_bank_no, o.agency_bank_no) as agency_bank_no -- 被代理行行号
    ,nvl(n.entrust_cust_no, o.entrust_cust_no) as entrust_cust_no -- 委托客户号
    ,nvl(n.actually_industy, o.actually_industy) as actually_industy -- 实际投向行业
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 交易机构编号
    ,nvl(n.account_branch_no, o.account_branch_no) as account_branch_no -- 账务机构号
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总机构号
    ,nvl(n.create_operator, o.create_operator) as create_operator -- 创建操作员
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.last_operator, o.last_operator) as last_operator -- 最后修改操作员
    ,nvl(n.last_update_time, o.last_update_time) as last_update_time -- 最后修改时间
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用字段2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备用字段3
    ,nvl(n.busi_date, o.busi_date) as busi_date -- 承兑签发日期
    ,nvl(n.task_type, o.task_type) as task_type -- 来源
    ,nvl(n.webbank_contract_id, o.webbank_contract_id) as webbank_contract_id -- 网银承兑协议ID
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型：1 银票2 商票
    ,nvl(n.apply_accept_amount, o.apply_accept_amount) as apply_accept_amount -- 申请承兑金额
    ,nvl(n.apply_remit_date, o.apply_remit_date) as apply_remit_date -- 申请出票日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日
    ,nvl(n.apply_reason, o.apply_reason) as apply_reason -- 申请原因和用途
    ,nvl(n.first_repayment_acct, o.first_repayment_acct) as first_repayment_acct -- 第一还款账号
    ,nvl(n.charge_scale, o.charge_scale) as charge_scale -- 手续费比例
    ,nvl(n.trans_amount, o.trans_amount) as trans_amount -- 交易金额
    ,nvl(n.credit_check_status, o.credit_check_status) as credit_check_status -- 授信检查0-未检查1-检查成功2-检查失败
    ,nvl(n.data_source_type, o.data_source_type) as data_source_type -- 数据来源类型1、系统手工录入2、接收网银数据
    ,nvl(n.misc, o.misc) as misc -- 信息域
    ,nvl(n.main_assure_type, o.main_assure_type) as main_assure_type -- 主要担保方式
    ,nvl(n.manage_fee, o.manage_fee) as manage_fee -- 管理费
    ,nvl(n.accept_fee, o.accept_fee) as accept_fee -- 承兑费
    ,nvl(n.contract_date, o.contract_date) as contract_date -- 信贷返回的协议到期日
    ,nvl(n.acct_amount, o.acct_amount) as acct_amount -- 结算账号余额
    ,nvl(n.all_credit_exp, o.all_credit_exp) as all_credit_exp -- 已批准使用授信敞口
    ,nvl(n.total_use_credit_exp, o.total_use_credit_exp) as total_use_credit_exp -- 本次放款后累计使用敞口
    ,nvl(n.cert_type, o.cert_type) as cert_type -- 证件类型
    ,nvl(n.cert_id, o.cert_id) as cert_id -- 证件ID
    ,nvl(n.report_url, o.report_url) as report_url -- 征信报告URL
    ,nvl(n.core_enterprise, o.core_enterprise) as core_enterprise -- 核心企业名称
    ,nvl(n.core_enterprise_cmoncd, o.core_enterprise_cmoncd) as core_enterprise_cmoncd -- 核心企业组织机构代码
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 网银批量号码
    ,nvl(n.file_name, o.file_name) as file_name -- 走文件方式文件名
    ,nvl(n.is_related, o.is_related) as is_related -- 是否关联方查询 Y-是我行关联方N-未在我行关联方信息库中找出完全匹配信息P-关联方是自然人，须同时输入姓名和证件号进行查询M-通过输入信息查询出多个关联方,请输入更详细的信息进行查询L-名称非常接近，请做进一步核实
    ,nvl(n.bail_term, o.bail_term) as bail_term -- 保证金期限 000 活期203 三个月206 六个月301 一年302 两年303 三年305 五年
    ,nvl(n.bail_account, o.bail_account) as bail_account -- 保证金账号
    ,nvl(n.bail_type, o.bail_type) as bail_type -- 保证金类型 PG01 定期PG02 活期AC99 协议
    ,nvl(n.rates_type, o.rates_type) as rates_type -- 利率类型  0 我行挂牌利率1 协议利率2 浮动利率
    ,nvl(n.bail_rate, o.bail_rate) as bail_rate -- 保证金利率
    ,nvl(n.pdrifd, o.pdrifd) as pdrifd -- 保证金利率浮动类型
    ,nvl(n.pdrifm, o.pdrifm) as pdrifm -- 保证金利率浮动方式
    ,nvl(n.pdrifv, o.pdrifv) as pdrifv -- 保证金浮动值
    ,nvl(n.business_exp, o.business_exp) as business_exp -- 业务合同占用敞口金额
    ,nvl(n.low_risk, o.low_risk) as low_risk -- 是否低风险业务
    ,nvl(n.ratio_exp, o.ratio_exp) as ratio_exp -- 敞口比例
    ,nvl(n.credit_protocol_no, o.credit_protocol_no) as credit_protocol_no -- 信贷业务合同号
    ,nvl(n.unique_seq_num, o.unique_seq_num) as unique_seq_num -- 业务流水号(交易订单号)
    ,nvl(n.drawee_bank_no, o.drawee_bank_no) as drawee_bank_no -- 付款行号
    ,nvl(n.charge_ratio, o.charge_ratio) as charge_ratio -- 手续费比例（%）
    ,nvl(n.credit_fee_ratio, o.credit_fee_ratio) as credit_fee_ratio -- 额度管理费比例（%）
    ,nvl(n.acct_status, o.acct_status) as acct_status -- 
    ,nvl(n.send_file_status, o.send_file_status) as send_file_status -- 
    ,nvl(n.exposure_type, o.exposure_type) as exposure_type -- 敞口类型 0-低风险 1-类低风险 2-敞口
    ,nvl(n.exposure_amount, o.exposure_amount) as exposure_amount -- 敞口金额
    ,nvl(n.is_adjust_deposit, o.is_adjust_deposit) as is_adjust_deposit -- 是否调整存款收益 0-否 1-是
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_cpes_accept_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_accept_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.contract_no <> n.contract_no
        or o.draft_attr <> n.draft_attr
        or o.product_no <> n.product_no
        or o.product_attr <> n.product_attr
        or o.remitter_name <> n.remitter_name
        or o.remitter_acct <> n.remitter_acct
        or o.remitter_bank_no <> n.remitter_bank_no
        or o.remitter_bank_name <> n.remitter_bank_name
        or o.remitter_cust_no <> n.remitter_cust_no
        or o.remitter_soc_code <> n.remitter_soc_code
        or o.remitter_type <> n.remitter_type
        or o.remitter_brh_no <> n.remitter_brh_no
        or o.payer_bank_no <> n.payer_bank_no
        or o.payer_bank_name <> n.payer_bank_name
        or o.acceptor_bank_no <> n.acceptor_bank_no
        or o.acceptor_bank_name <> n.acceptor_bank_name
        or o.acceptor_brh_no <> n.acceptor_brh_no
        or o.deposit_type <> n.deposit_type
        or o.deposit_ratio <> n.deposit_ratio
        or o.pledge_no <> n.pledge_no
        or o.pledge_amt <> n.pledge_amt
        or o.pledge_type <> n.pledge_type
        or o.contract_status <> n.contract_status
        or o.account_status <> n.account_status
        or o.sign_status <> n.sign_status
        or o.credit_status <> n.credit_status
        or o.risk_status <> n.risk_status
        or o.accept_status <> n.accept_status
        or o.acceptor_ratg_agcy <> n.acceptor_ratg_agcy
        or o.acceptor_ratg_duedt <> n.acceptor_ratg_duedt
        or o.acceptor_credit_ratgs <> n.acceptor_credit_ratgs
        or o.credit_no <> n.credit_no
        or o.credit_contract_amt <> n.credit_contract_amt
        or o.credit_flowno <> n.credit_flowno
        or o.department_no <> n.department_no
        or o.department_name <> n.department_name
        or o.manager_no <> n.manager_no
        or o.manager_name <> n.manager_name
        or o.agency_name <> n.agency_name
        or o.agency_account <> n.agency_account
        or o.agency_bank_name <> n.agency_bank_name
        or o.agency_bank_no <> n.agency_bank_no
        or o.entrust_cust_no <> n.entrust_cust_no
        or o.actually_industy <> n.actually_industy
        or o.busi_branch_no <> n.busi_branch_no
        or o.account_branch_no <> n.account_branch_no
        or o.top_branch_no <> n.top_branch_no
        or o.create_operator <> n.create_operator
        or o.create_time <> n.create_time
        or o.last_operator <> n.last_operator
        or o.last_update_time <> n.last_update_time
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.busi_date <> n.busi_date
        or o.task_type <> n.task_type
        or o.webbank_contract_id <> n.webbank_contract_id
        or o.draft_type <> n.draft_type
        or o.apply_accept_amount <> n.apply_accept_amount
        or o.apply_remit_date <> n.apply_remit_date
        or o.maturity_date <> n.maturity_date
        or o.apply_reason <> n.apply_reason
        or o.first_repayment_acct <> n.first_repayment_acct
        or o.charge_scale <> n.charge_scale
        or o.trans_amount <> n.trans_amount
        or o.credit_check_status <> n.credit_check_status
        or o.data_source_type <> n.data_source_type
        or o.misc <> n.misc
        or o.main_assure_type <> n.main_assure_type
        or o.manage_fee <> n.manage_fee
        or o.accept_fee <> n.accept_fee
        or o.contract_date <> n.contract_date
        or o.acct_amount <> n.acct_amount
        or o.all_credit_exp <> n.all_credit_exp
        or o.total_use_credit_exp <> n.total_use_credit_exp
        or o.cert_type <> n.cert_type
        or o.cert_id <> n.cert_id
        or o.report_url <> n.report_url
        or o.core_enterprise <> n.core_enterprise
        or o.core_enterprise_cmoncd <> n.core_enterprise_cmoncd
        or o.batch_no <> n.batch_no
        or o.file_name <> n.file_name
        or o.is_related <> n.is_related
        or o.bail_term <> n.bail_term
        or o.bail_account <> n.bail_account
        or o.bail_type <> n.bail_type
        or o.rates_type <> n.rates_type
        or o.bail_rate <> n.bail_rate
        or o.pdrifd <> n.pdrifd
        or o.pdrifm <> n.pdrifm
        or o.pdrifv <> n.pdrifv
        or o.business_exp <> n.business_exp
        or o.low_risk <> n.low_risk
        or o.ratio_exp <> n.ratio_exp
        or o.credit_protocol_no <> n.credit_protocol_no
        or o.unique_seq_num <> n.unique_seq_num
        or o.drawee_bank_no <> n.drawee_bank_no
        or o.charge_ratio <> n.charge_ratio
        or o.credit_fee_ratio <> n.credit_fee_ratio
        or o.acct_status <> n.acct_status
        or o.send_file_status <> n.send_file_status
        or o.exposure_type <> n.exposure_type
        or o.exposure_amount <> n.exposure_amount
        or o.is_adjust_deposit <> n.is_adjust_deposit
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_accept_contract_cl(
            id -- ID
            ,contract_no -- 批次协议号
            ,draft_attr -- 票据介质： 1 纸票 2 电票
            ,product_no -- 产品号
            ,product_attr -- 产品属性
            ,remitter_name -- 出票人名称
            ,remitter_acct -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_cust_no -- 出票人客户号
            ,remitter_soc_code -- 出票人社会信用代码
            ,remitter_type -- 出票人类型
            ,remitter_brh_no -- 出票人开户机构代码
            ,payer_bank_no -- 付款行行号
            ,payer_bank_name -- 付款行名称
            ,acceptor_bank_no -- 承兑人行号
            ,acceptor_bank_name -- 承兑人名称
            ,acceptor_brh_no -- 承兑人机构代码
            ,deposit_type -- 保证金类型： 1 一对一 2 一对多
            ,deposit_ratio -- 保证金比例（%）
            ,pledge_no -- 抵质押编号
            ,pledge_amt -- 抵质押价值
            ,pledge_type -- 担保方式：
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,sign_status -- 签收状态： 00 未签收 01 部分签收 02 已签收
            ,credit_status -- 授信状态： 00 额度未占用 01 额度占用成功 02 额度占用失败
            ,risk_status -- 风险检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,accept_status -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
            ,acceptor_ratg_agcy -- 承兑人信用主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,credit_no -- 信贷合同编号
            ,credit_contract_amt -- 信贷合同金额
            ,credit_flowno -- 信贷流水号
            ,department_no -- 部门编号
            ,department_name -- 部门名称
            ,manager_no -- 客户经理编号
            ,manager_name -- 客户经理名称
            ,agency_name -- 被代理人名称
            ,agency_account -- 被代理人账号
            ,agency_bank_name -- 被代理行全称
            ,agency_bank_no -- 被代理行行号
            ,entrust_cust_no -- 委托客户号
            ,actually_industy -- 实际投向行业
            ,busi_branch_no -- 交易机构编号
            ,account_branch_no -- 账务机构号
            ,top_branch_no -- 总机构号
            ,create_operator -- 创建操作员
            ,create_time -- 创建时间
            ,last_operator -- 最后修改操作员
            ,last_update_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,busi_date -- 承兑签发日期
            ,task_type -- 来源
            ,webbank_contract_id -- 网银承兑协议ID
            ,draft_type -- 票据类型：1 银票2 商票
            ,apply_accept_amount -- 申请承兑金额
            ,apply_remit_date -- 申请出票日
            ,maturity_date -- 到期日
            ,apply_reason -- 申请原因和用途
            ,first_repayment_acct -- 第一还款账号
            ,charge_scale -- 手续费比例
            ,trans_amount -- 交易金额
            ,credit_check_status -- 授信检查0-未检查1-检查成功2-检查失败
            ,data_source_type -- 数据来源类型1、系统手工录入2、接收网银数据
            ,misc -- 信息域
            ,main_assure_type -- 主要担保方式
            ,manage_fee -- 管理费
            ,accept_fee -- 承兑费
            ,contract_date -- 信贷返回的协议到期日
            ,acct_amount -- 结算账号余额
            ,all_credit_exp -- 已批准使用授信敞口
            ,total_use_credit_exp -- 本次放款后累计使用敞口
            ,cert_type -- 证件类型
            ,cert_id -- 证件ID
            ,report_url -- 征信报告URL
            ,core_enterprise -- 核心企业名称
            ,core_enterprise_cmoncd -- 核心企业组织机构代码
            ,batch_no -- 网银批量号码
            ,file_name -- 走文件方式文件名
            ,is_related -- 是否关联方查询 Y-是我行关联方N-未在我行关联方信息库中找出完全匹配信息P-关联方是自然人，须同时输入姓名和证件号进行查询M-通过输入信息查询出多个关联方,请输入更详细的信息进行查询L-名称非常接近，请做进一步核实
            ,bail_term -- 保证金期限 000 活期203 三个月206 六个月301 一年302 两年303 三年305 五年
            ,bail_account -- 保证金账号
            ,bail_type -- 保证金类型 PG01 定期PG02 活期AC99 协议
            ,rates_type -- 利率类型  0 我行挂牌利率1 协议利率2 浮动利率
            ,bail_rate -- 保证金利率
            ,pdrifd -- 保证金利率浮动类型
            ,pdrifm -- 保证金利率浮动方式
            ,pdrifv -- 保证金浮动值
            ,business_exp -- 业务合同占用敞口金额
            ,low_risk -- 是否低风险业务
            ,ratio_exp -- 敞口比例
            ,credit_protocol_no -- 信贷业务合同号
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,drawee_bank_no -- 付款行号
            ,charge_ratio -- 手续费比例（%）
            ,credit_fee_ratio -- 额度管理费比例（%）
            ,acct_status -- 
            ,send_file_status -- 
            ,exposure_type -- 敞口类型 0-低风险 1-类低风险 2-敞口
            ,exposure_amount -- 敞口金额
            ,is_adjust_deposit -- 是否调整存款收益 0-否 1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_accept_contract_op(
            id -- ID
            ,contract_no -- 批次协议号
            ,draft_attr -- 票据介质： 1 纸票 2 电票
            ,product_no -- 产品号
            ,product_attr -- 产品属性
            ,remitter_name -- 出票人名称
            ,remitter_acct -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_cust_no -- 出票人客户号
            ,remitter_soc_code -- 出票人社会信用代码
            ,remitter_type -- 出票人类型
            ,remitter_brh_no -- 出票人开户机构代码
            ,payer_bank_no -- 付款行行号
            ,payer_bank_name -- 付款行名称
            ,acceptor_bank_no -- 承兑人行号
            ,acceptor_bank_name -- 承兑人名称
            ,acceptor_brh_no -- 承兑人机构代码
            ,deposit_type -- 保证金类型： 1 一对一 2 一对多
            ,deposit_ratio -- 保证金比例（%）
            ,pledge_no -- 抵质押编号
            ,pledge_amt -- 抵质押价值
            ,pledge_type -- 担保方式：
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,sign_status -- 签收状态： 00 未签收 01 部分签收 02 已签收
            ,credit_status -- 授信状态： 00 额度未占用 01 额度占用成功 02 额度占用失败
            ,risk_status -- 风险检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,accept_status -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
            ,acceptor_ratg_agcy -- 承兑人信用主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,credit_no -- 信贷合同编号
            ,credit_contract_amt -- 信贷合同金额
            ,credit_flowno -- 信贷流水号
            ,department_no -- 部门编号
            ,department_name -- 部门名称
            ,manager_no -- 客户经理编号
            ,manager_name -- 客户经理名称
            ,agency_name -- 被代理人名称
            ,agency_account -- 被代理人账号
            ,agency_bank_name -- 被代理行全称
            ,agency_bank_no -- 被代理行行号
            ,entrust_cust_no -- 委托客户号
            ,actually_industy -- 实际投向行业
            ,busi_branch_no -- 交易机构编号
            ,account_branch_no -- 账务机构号
            ,top_branch_no -- 总机构号
            ,create_operator -- 创建操作员
            ,create_time -- 创建时间
            ,last_operator -- 最后修改操作员
            ,last_update_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,busi_date -- 承兑签发日期
            ,task_type -- 来源
            ,webbank_contract_id -- 网银承兑协议ID
            ,draft_type -- 票据类型：1 银票2 商票
            ,apply_accept_amount -- 申请承兑金额
            ,apply_remit_date -- 申请出票日
            ,maturity_date -- 到期日
            ,apply_reason -- 申请原因和用途
            ,first_repayment_acct -- 第一还款账号
            ,charge_scale -- 手续费比例
            ,trans_amount -- 交易金额
            ,credit_check_status -- 授信检查0-未检查1-检查成功2-检查失败
            ,data_source_type -- 数据来源类型1、系统手工录入2、接收网银数据
            ,misc -- 信息域
            ,main_assure_type -- 主要担保方式
            ,manage_fee -- 管理费
            ,accept_fee -- 承兑费
            ,contract_date -- 信贷返回的协议到期日
            ,acct_amount -- 结算账号余额
            ,all_credit_exp -- 已批准使用授信敞口
            ,total_use_credit_exp -- 本次放款后累计使用敞口
            ,cert_type -- 证件类型
            ,cert_id -- 证件ID
            ,report_url -- 征信报告URL
            ,core_enterprise -- 核心企业名称
            ,core_enterprise_cmoncd -- 核心企业组织机构代码
            ,batch_no -- 网银批量号码
            ,file_name -- 走文件方式文件名
            ,is_related -- 是否关联方查询 Y-是我行关联方N-未在我行关联方信息库中找出完全匹配信息P-关联方是自然人，须同时输入姓名和证件号进行查询M-通过输入信息查询出多个关联方,请输入更详细的信息进行查询L-名称非常接近，请做进一步核实
            ,bail_term -- 保证金期限 000 活期203 三个月206 六个月301 一年302 两年303 三年305 五年
            ,bail_account -- 保证金账号
            ,bail_type -- 保证金类型 PG01 定期PG02 活期AC99 协议
            ,rates_type -- 利率类型  0 我行挂牌利率1 协议利率2 浮动利率
            ,bail_rate -- 保证金利率
            ,pdrifd -- 保证金利率浮动类型
            ,pdrifm -- 保证金利率浮动方式
            ,pdrifv -- 保证金浮动值
            ,business_exp -- 业务合同占用敞口金额
            ,low_risk -- 是否低风险业务
            ,ratio_exp -- 敞口比例
            ,credit_protocol_no -- 信贷业务合同号
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,drawee_bank_no -- 付款行号
            ,charge_ratio -- 手续费比例（%）
            ,credit_fee_ratio -- 额度管理费比例（%）
            ,acct_status -- 
            ,send_file_status -- 
            ,exposure_type -- 敞口类型 0-低风险 1-类低风险 2-敞口
            ,exposure_amount -- 敞口金额
            ,is_adjust_deposit -- 是否调整存款收益 0-否 1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.contract_no -- 批次协议号
    ,o.draft_attr -- 票据介质： 1 纸票 2 电票
    ,o.product_no -- 产品号
    ,o.product_attr -- 产品属性
    ,o.remitter_name -- 出票人名称
    ,o.remitter_acct -- 出票人账号
    ,o.remitter_bank_no -- 出票人开户行行号
    ,o.remitter_bank_name -- 出票人开户行名称
    ,o.remitter_cust_no -- 出票人客户号
    ,o.remitter_soc_code -- 出票人社会信用代码
    ,o.remitter_type -- 出票人类型
    ,o.remitter_brh_no -- 出票人开户机构代码
    ,o.payer_bank_no -- 付款行行号
    ,o.payer_bank_name -- 付款行名称
    ,o.acceptor_bank_no -- 承兑人行号
    ,o.acceptor_bank_name -- 承兑人名称
    ,o.acceptor_brh_no -- 承兑人机构代码
    ,o.deposit_type -- 保证金类型： 1 一对一 2 一对多
    ,o.deposit_ratio -- 保证金比例（%）
    ,o.pledge_no -- 抵质押编号
    ,o.pledge_amt -- 抵质押价值
    ,o.pledge_type -- 担保方式：
    ,o.contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.sign_status -- 签收状态： 00 未签收 01 部分签收 02 已签收
    ,o.credit_status -- 授信状态： 00 额度未占用 01 额度占用成功 02 额度占用失败
    ,o.risk_status -- 风险检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
    ,o.accept_status -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
    ,o.acceptor_ratg_agcy -- 承兑人信用主体
    ,o.acceptor_ratg_duedt -- 承兑人评级到期日
    ,o.acceptor_credit_ratgs -- 承兑人信用等级
    ,o.credit_no -- 信贷合同编号
    ,o.credit_contract_amt -- 信贷合同金额
    ,o.credit_flowno -- 信贷流水号
    ,o.department_no -- 部门编号
    ,o.department_name -- 部门名称
    ,o.manager_no -- 客户经理编号
    ,o.manager_name -- 客户经理名称
    ,o.agency_name -- 被代理人名称
    ,o.agency_account -- 被代理人账号
    ,o.agency_bank_name -- 被代理行全称
    ,o.agency_bank_no -- 被代理行行号
    ,o.entrust_cust_no -- 委托客户号
    ,o.actually_industy -- 实际投向行业
    ,o.busi_branch_no -- 交易机构编号
    ,o.account_branch_no -- 账务机构号
    ,o.top_branch_no -- 总机构号
    ,o.create_operator -- 创建操作员
    ,o.create_time -- 创建时间
    ,o.last_operator -- 最后修改操作员
    ,o.last_update_time -- 最后修改时间
    ,o.reserve1 -- 备用字段1
    ,o.reserve2 -- 备用字段2
    ,o.reserve3 -- 备用字段3
    ,o.busi_date -- 承兑签发日期
    ,o.task_type -- 来源
    ,o.webbank_contract_id -- 网银承兑协议ID
    ,o.draft_type -- 票据类型：1 银票2 商票
    ,o.apply_accept_amount -- 申请承兑金额
    ,o.apply_remit_date -- 申请出票日
    ,o.maturity_date -- 到期日
    ,o.apply_reason -- 申请原因和用途
    ,o.first_repayment_acct -- 第一还款账号
    ,o.charge_scale -- 手续费比例
    ,o.trans_amount -- 交易金额
    ,o.credit_check_status -- 授信检查0-未检查1-检查成功2-检查失败
    ,o.data_source_type -- 数据来源类型1、系统手工录入2、接收网银数据
    ,o.misc -- 信息域
    ,o.main_assure_type -- 主要担保方式
    ,o.manage_fee -- 管理费
    ,o.accept_fee -- 承兑费
    ,o.contract_date -- 信贷返回的协议到期日
    ,o.acct_amount -- 结算账号余额
    ,o.all_credit_exp -- 已批准使用授信敞口
    ,o.total_use_credit_exp -- 本次放款后累计使用敞口
    ,o.cert_type -- 证件类型
    ,o.cert_id -- 证件ID
    ,o.report_url -- 征信报告URL
    ,o.core_enterprise -- 核心企业名称
    ,o.core_enterprise_cmoncd -- 核心企业组织机构代码
    ,o.batch_no -- 网银批量号码
    ,o.file_name -- 走文件方式文件名
    ,o.is_related -- 是否关联方查询 Y-是我行关联方N-未在我行关联方信息库中找出完全匹配信息P-关联方是自然人，须同时输入姓名和证件号进行查询M-通过输入信息查询出多个关联方,请输入更详细的信息进行查询L-名称非常接近，请做进一步核实
    ,o.bail_term -- 保证金期限 000 活期203 三个月206 六个月301 一年302 两年303 三年305 五年
    ,o.bail_account -- 保证金账号
    ,o.bail_type -- 保证金类型 PG01 定期PG02 活期AC99 协议
    ,o.rates_type -- 利率类型  0 我行挂牌利率1 协议利率2 浮动利率
    ,o.bail_rate -- 保证金利率
    ,o.pdrifd -- 保证金利率浮动类型
    ,o.pdrifm -- 保证金利率浮动方式
    ,o.pdrifv -- 保证金浮动值
    ,o.business_exp -- 业务合同占用敞口金额
    ,o.low_risk -- 是否低风险业务
    ,o.ratio_exp -- 敞口比例
    ,o.credit_protocol_no -- 信贷业务合同号
    ,o.unique_seq_num -- 业务流水号(交易订单号)
    ,o.drawee_bank_no -- 付款行号
    ,o.charge_ratio -- 手续费比例（%）
    ,o.credit_fee_ratio -- 额度管理费比例（%）
    ,o.acct_status -- 
    ,o.send_file_status -- 
    ,o.exposure_type -- 敞口类型 0-低风险 1-类低风险 2-敞口
    ,o.exposure_amount -- 敞口金额
    ,o.is_adjust_deposit -- 是否调整存款收益 0-否 1-是
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
from ${iol_schema}.bdms_cpes_accept_contract_bk o
    left join ${iol_schema}.bdms_cpes_accept_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_accept_contract_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_cpes_accept_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_accept_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_accept_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_accept_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_accept_contract exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_accept_contract_cl;
alter table ${iol_schema}.bdms_cpes_accept_contract exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_accept_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_accept_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_accept_contract_op purge;
drop table ${iol_schema}.bdms_cpes_accept_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_accept_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_accept_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
