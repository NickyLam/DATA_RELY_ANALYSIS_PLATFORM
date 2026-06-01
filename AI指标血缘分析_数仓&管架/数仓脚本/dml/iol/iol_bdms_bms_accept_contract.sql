/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_accept_contract
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
create table ${iol_schema}.bdms_bms_accept_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_accept_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_accept_contract_op purge;
drop table ${iol_schema}.bdms_bms_accept_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_accept_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_accept_contract where 0=1;

create table ${iol_schema}.bdms_bms_accept_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_accept_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_accept_contract_cl(
            id -- ID
            ,protocol_no -- 承兑协议号
            ,credit_no -- 信贷合同号
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,prod_no -- 产品类型编码
            ,actually_industy -- 行业
            ,apply_accept_amount -- 申请承兑金额
            ,apply_remit_date -- 申请出票日
            ,maturity_date -- 到期日
            ,trans_amount -- 交易金额
            ,credit_contract_amount -- 信贷合同金额
            ,credit_flow_no -- 信贷流水号
            ,apply_no -- 申请编号
            ,audit_status -- 审核状态： 0 未审核 1 已提交审核 2 审核中 3 审核成功 4 审核失败 5 回退 6 审批中(单笔退回)
            ,bail_ratio -- 保证金比例
            ,remitter_name -- 出票人
            ,remitter_account -- 出票人账号
            ,remitter_brch_no -- 出票人开户机构
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行行名
            ,drawee_bank_no -- 付款行号
            ,drawee_bank_name -- 付款行名
            ,remitter_cust_no -- 出票人客户号
            ,top_branch_no -- 总行机构号
            ,busi_branch_no -- 业务发起机构号
            ,trans_branch_no -- 交易机构号(记账机构)
            ,acct_branch_no -- 账务机构号
            ,guarantee_type -- 担保方式： 1 大额存单 2 抵制压物
            ,pledge_no -- 抵质押编号
            ,pledge_amount -- 抵质押价值
            ,charge_ratio -- 手续费比例
            ,impawn_percent -- 质押比例
            ,protocol_status -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,credit_fee_ratio -- 额度管理费比例
            ,source_type -- 数据来源类型： 1 手工录入 2 网银获得
            ,department_no -- 部门号
            ,manager_no -- 客户经理号
            ,draft_pool_ratio -- 额度池占用比例
            ,mend_flag -- 跟单资料后补标志： 0 否 1 是
            ,operator_no -- 操作员号
            ,operator_date -- 操作日期
            ,task_type -- 任务类型
            ,issuing_mode -- 签发模式
            ,agency_bank_name -- 被代理行全称
            ,agency_bank_no -- 被代理行行号
            ,entrust_cust_no -- 委托行客户号
            ,exposure_mgn_ratio -- 敞口费比例
            ,assurance_ratio -- 协议保证金比例
            ,assurance_amount -- 协议保证金金额
            ,add_last_date -- 资料后补日期
            ,apply_reason -- 申请原因和用途
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注13
            ,agency_name -- 被代理人全称
            ,agency_account -- 被代理人帐号
            ,guarantee_state -- 担保类型： 1 一对多 2 一对一
            ,last_txn_date -- 最后修改时间
            ,last_operator_no -- 最后修改操作员
            ,credit_status -- 风险检查状态： 0 无效 1 检查通过 2 检查通过，存在风险 3 检查不通过
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,bail_rate -- 保证金利率
            ,drawee_address -- 付款行地址
            ,webbank_contract_id -- 网银承兑协议ID
            ,repayment_acct -- 还款账号
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,credit_fee_scale -- 额度管理费比例
            ,logic_check_status -- 业务逻辑检查状态1-业务逻辑未检查2-业务逻辑检查成功3-业务逻辑检查失败
            ,misc -- 信息域
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
            ,pdrifd -- 保证金利率浮动类型
            ,pdrifm -- 保证金利率浮动方式
            ,pdrifv -- 保证金浮动值
            ,business_exp -- 业务合同占用敞口金额
            ,low_risk -- 是否低风险业务
            ,credit_protocol_no -- 信贷业务合同号
            ,contract_status -- 批次状态
            ,first_repayment_acct -- 第一还款账号
            ,acct_status -- 
            ,send_file_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_accept_contract_op(
            id -- ID
            ,protocol_no -- 承兑协议号
            ,credit_no -- 信贷合同号
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,prod_no -- 产品类型编码
            ,actually_industy -- 行业
            ,apply_accept_amount -- 申请承兑金额
            ,apply_remit_date -- 申请出票日
            ,maturity_date -- 到期日
            ,trans_amount -- 交易金额
            ,credit_contract_amount -- 信贷合同金额
            ,credit_flow_no -- 信贷流水号
            ,apply_no -- 申请编号
            ,audit_status -- 审核状态： 0 未审核 1 已提交审核 2 审核中 3 审核成功 4 审核失败 5 回退 6 审批中(单笔退回)
            ,bail_ratio -- 保证金比例
            ,remitter_name -- 出票人
            ,remitter_account -- 出票人账号
            ,remitter_brch_no -- 出票人开户机构
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行行名
            ,drawee_bank_no -- 付款行号
            ,drawee_bank_name -- 付款行名
            ,remitter_cust_no -- 出票人客户号
            ,top_branch_no -- 总行机构号
            ,busi_branch_no -- 业务发起机构号
            ,trans_branch_no -- 交易机构号(记账机构)
            ,acct_branch_no -- 账务机构号
            ,guarantee_type -- 担保方式： 1 大额存单 2 抵制压物
            ,pledge_no -- 抵质押编号
            ,pledge_amount -- 抵质押价值
            ,charge_ratio -- 手续费比例
            ,impawn_percent -- 质押比例
            ,protocol_status -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,credit_fee_ratio -- 额度管理费比例
            ,source_type -- 数据来源类型： 1 手工录入 2 网银获得
            ,department_no -- 部门号
            ,manager_no -- 客户经理号
            ,draft_pool_ratio -- 额度池占用比例
            ,mend_flag -- 跟单资料后补标志： 0 否 1 是
            ,operator_no -- 操作员号
            ,operator_date -- 操作日期
            ,task_type -- 任务类型
            ,issuing_mode -- 签发模式
            ,agency_bank_name -- 被代理行全称
            ,agency_bank_no -- 被代理行行号
            ,entrust_cust_no -- 委托行客户号
            ,exposure_mgn_ratio -- 敞口费比例
            ,assurance_ratio -- 协议保证金比例
            ,assurance_amount -- 协议保证金金额
            ,add_last_date -- 资料后补日期
            ,apply_reason -- 申请原因和用途
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注13
            ,agency_name -- 被代理人全称
            ,agency_account -- 被代理人帐号
            ,guarantee_state -- 担保类型： 1 一对多 2 一对一
            ,last_txn_date -- 最后修改时间
            ,last_operator_no -- 最后修改操作员
            ,credit_status -- 风险检查状态： 0 无效 1 检查通过 2 检查通过，存在风险 3 检查不通过
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,bail_rate -- 保证金利率
            ,drawee_address -- 付款行地址
            ,webbank_contract_id -- 网银承兑协议ID
            ,repayment_acct -- 还款账号
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,credit_fee_scale -- 额度管理费比例
            ,logic_check_status -- 业务逻辑检查状态1-业务逻辑未检查2-业务逻辑检查成功3-业务逻辑检查失败
            ,misc -- 信息域
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
            ,pdrifd -- 保证金利率浮动类型
            ,pdrifm -- 保证金利率浮动方式
            ,pdrifv -- 保证金浮动值
            ,business_exp -- 业务合同占用敞口金额
            ,low_risk -- 是否低风险业务
            ,credit_protocol_no -- 信贷业务合同号
            ,contract_status -- 批次状态
            ,first_repayment_acct -- 第一还款账号
            ,acct_status -- 
            ,send_file_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.protocol_no, o.protocol_no) as protocol_no -- 承兑协议号
    ,nvl(n.credit_no, o.credit_no) as credit_no -- 信贷合同号
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据属性： 1 纸票 2 电票
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： 1 银票 2 商票
    ,nvl(n.prod_no, o.prod_no) as prod_no -- 产品类型编码
    ,nvl(n.actually_industy, o.actually_industy) as actually_industy -- 行业
    ,nvl(n.apply_accept_amount, o.apply_accept_amount) as apply_accept_amount -- 申请承兑金额
    ,nvl(n.apply_remit_date, o.apply_remit_date) as apply_remit_date -- 申请出票日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日
    ,nvl(n.trans_amount, o.trans_amount) as trans_amount -- 交易金额
    ,nvl(n.credit_contract_amount, o.credit_contract_amount) as credit_contract_amount -- 信贷合同金额
    ,nvl(n.credit_flow_no, o.credit_flow_no) as credit_flow_no -- 信贷流水号
    ,nvl(n.apply_no, o.apply_no) as apply_no -- 申请编号
    ,nvl(n.audit_status, o.audit_status) as audit_status -- 审核状态： 0 未审核 1 已提交审核 2 审核中 3 审核成功 4 审核失败 5 回退 6 审批中(单笔退回)
    ,nvl(n.bail_ratio, o.bail_ratio) as bail_ratio -- 保证金比例
    ,nvl(n.remitter_name, o.remitter_name) as remitter_name -- 出票人
    ,nvl(n.remitter_account, o.remitter_account) as remitter_account -- 出票人账号
    ,nvl(n.remitter_brch_no, o.remitter_brch_no) as remitter_brch_no -- 出票人开户机构
    ,nvl(n.remitter_bank_no, o.remitter_bank_no) as remitter_bank_no -- 出票人开户行行号
    ,nvl(n.remitter_bank_name, o.remitter_bank_name) as remitter_bank_name -- 出票人开户行行名
    ,nvl(n.drawee_bank_no, o.drawee_bank_no) as drawee_bank_no -- 付款行号
    ,nvl(n.drawee_bank_name, o.drawee_bank_name) as drawee_bank_name -- 付款行名
    ,nvl(n.remitter_cust_no, o.remitter_cust_no) as remitter_cust_no -- 出票人客户号
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 业务发起机构号
    ,nvl(n.trans_branch_no, o.trans_branch_no) as trans_branch_no -- 交易机构号(记账机构)
    ,nvl(n.acct_branch_no, o.acct_branch_no) as acct_branch_no -- 账务机构号
    ,nvl(n.guarantee_type, o.guarantee_type) as guarantee_type -- 担保方式： 1 大额存单 2 抵制压物
    ,nvl(n.pledge_no, o.pledge_no) as pledge_no -- 抵质押编号
    ,nvl(n.pledge_amount, o.pledge_amount) as pledge_amount -- 抵质押价值
    ,nvl(n.charge_ratio, o.charge_ratio) as charge_ratio -- 手续费比例
    ,nvl(n.impawn_percent, o.impawn_percent) as impawn_percent -- 质押比例
    ,nvl(n.protocol_status, o.protocol_status) as protocol_status -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
    ,nvl(n.credit_check_status, o.credit_check_status) as credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
    ,nvl(n.credit_fee_ratio, o.credit_fee_ratio) as credit_fee_ratio -- 额度管理费比例
    ,nvl(n.source_type, o.source_type) as source_type -- 数据来源类型： 1 手工录入 2 网银获得
    ,nvl(n.department_no, o.department_no) as department_no -- 部门号
    ,nvl(n.manager_no, o.manager_no) as manager_no -- 客户经理号
    ,nvl(n.draft_pool_ratio, o.draft_pool_ratio) as draft_pool_ratio -- 额度池占用比例
    ,nvl(n.mend_flag, o.mend_flag) as mend_flag -- 跟单资料后补标志： 0 否 1 是
    ,nvl(n.operator_no, o.operator_no) as operator_no -- 操作员号
    ,nvl(n.operator_date, o.operator_date) as operator_date -- 操作日期
    ,nvl(n.task_type, o.task_type) as task_type -- 任务类型
    ,nvl(n.issuing_mode, o.issuing_mode) as issuing_mode -- 签发模式
    ,nvl(n.agency_bank_name, o.agency_bank_name) as agency_bank_name -- 被代理行全称
    ,nvl(n.agency_bank_no, o.agency_bank_no) as agency_bank_no -- 被代理行行号
    ,nvl(n.entrust_cust_no, o.entrust_cust_no) as entrust_cust_no -- 委托行客户号
    ,nvl(n.exposure_mgn_ratio, o.exposure_mgn_ratio) as exposure_mgn_ratio -- 敞口费比例
    ,nvl(n.assurance_ratio, o.assurance_ratio) as assurance_ratio -- 协议保证金比例
    ,nvl(n.assurance_amount, o.assurance_amount) as assurance_amount -- 协议保证金金额
    ,nvl(n.add_last_date, o.add_last_date) as add_last_date -- 资料后补日期
    ,nvl(n.apply_reason, o.apply_reason) as apply_reason -- 申请原因和用途
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备注1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备注2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备注13
    ,nvl(n.agency_name, o.agency_name) as agency_name -- 被代理人全称
    ,nvl(n.agency_account, o.agency_account) as agency_account -- 被代理人帐号
    ,nvl(n.guarantee_state, o.guarantee_state) as guarantee_state -- 担保类型： 1 一对多 2 一对一
    ,nvl(n.last_txn_date, o.last_txn_date) as last_txn_date -- 最后修改时间
    ,nvl(n.last_operator_no, o.last_operator_no) as last_operator_no -- 最后修改操作员
    ,nvl(n.credit_status, o.credit_status) as credit_status -- 风险检查状态： 0 无效 1 检查通过 2 检查通过，存在风险 3 检查不通过
    ,nvl(n.acceptor_ratg_agcy, o.acceptor_ratg_agcy) as acceptor_ratg_agcy -- 承兑人评级主体
    ,nvl(n.acceptor_ratg_duedt, o.acceptor_ratg_duedt) as acceptor_ratg_duedt -- 承兑人评级到期日
    ,nvl(n.acceptor_credit_ratgs, o.acceptor_credit_ratgs) as acceptor_credit_ratgs -- 承兑人信用等级
    ,nvl(n.bail_rate, o.bail_rate) as bail_rate -- 保证金利率
    ,nvl(n.drawee_address, o.drawee_address) as drawee_address -- 付款行地址
    ,nvl(n.webbank_contract_id, o.webbank_contract_id) as webbank_contract_id -- 网银承兑协议ID
    ,nvl(n.repayment_acct, o.repayment_acct) as repayment_acct -- 还款账号
    ,nvl(n.unique_seq_num, o.unique_seq_num) as unique_seq_num -- 业务流水号(交易订单号)
    ,nvl(n.credit_fee_scale, o.credit_fee_scale) as credit_fee_scale -- 额度管理费比例
    ,nvl(n.logic_check_status, o.logic_check_status) as logic_check_status -- 业务逻辑检查状态1-业务逻辑未检查2-业务逻辑检查成功3-业务逻辑检查失败
    ,nvl(n.misc, o.misc) as misc -- 信息域
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
    ,nvl(n.pdrifd, o.pdrifd) as pdrifd -- 保证金利率浮动类型
    ,nvl(n.pdrifm, o.pdrifm) as pdrifm -- 保证金利率浮动方式
    ,nvl(n.pdrifv, o.pdrifv) as pdrifv -- 保证金浮动值
    ,nvl(n.business_exp, o.business_exp) as business_exp -- 业务合同占用敞口金额
    ,nvl(n.low_risk, o.low_risk) as low_risk -- 是否低风险业务
    ,nvl(n.credit_protocol_no, o.credit_protocol_no) as credit_protocol_no -- 信贷业务合同号
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 批次状态
    ,nvl(n.first_repayment_acct, o.first_repayment_acct) as first_repayment_acct -- 第一还款账号
    ,nvl(n.acct_status, o.acct_status) as acct_status -- 
    ,nvl(n.send_file_status, o.send_file_status) as send_file_status -- 
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
from (select * from ${iol_schema}.bdms_bms_accept_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_accept_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.protocol_no <> n.protocol_no
        or o.credit_no <> n.credit_no
        or o.draft_attr <> n.draft_attr
        or o.draft_type <> n.draft_type
        or o.prod_no <> n.prod_no
        or o.actually_industy <> n.actually_industy
        or o.apply_accept_amount <> n.apply_accept_amount
        or o.apply_remit_date <> n.apply_remit_date
        or o.maturity_date <> n.maturity_date
        or o.trans_amount <> n.trans_amount
        or o.credit_contract_amount <> n.credit_contract_amount
        or o.credit_flow_no <> n.credit_flow_no
        or o.apply_no <> n.apply_no
        or o.audit_status <> n.audit_status
        or o.bail_ratio <> n.bail_ratio
        or o.remitter_name <> n.remitter_name
        or o.remitter_account <> n.remitter_account
        or o.remitter_brch_no <> n.remitter_brch_no
        or o.remitter_bank_no <> n.remitter_bank_no
        or o.remitter_bank_name <> n.remitter_bank_name
        or o.drawee_bank_no <> n.drawee_bank_no
        or o.drawee_bank_name <> n.drawee_bank_name
        or o.remitter_cust_no <> n.remitter_cust_no
        or o.top_branch_no <> n.top_branch_no
        or o.busi_branch_no <> n.busi_branch_no
        or o.trans_branch_no <> n.trans_branch_no
        or o.acct_branch_no <> n.acct_branch_no
        or o.guarantee_type <> n.guarantee_type
        or o.pledge_no <> n.pledge_no
        or o.pledge_amount <> n.pledge_amount
        or o.charge_ratio <> n.charge_ratio
        or o.impawn_percent <> n.impawn_percent
        or o.protocol_status <> n.protocol_status
        or o.credit_check_status <> n.credit_check_status
        or o.credit_fee_ratio <> n.credit_fee_ratio
        or o.source_type <> n.source_type
        or o.department_no <> n.department_no
        or o.manager_no <> n.manager_no
        or o.draft_pool_ratio <> n.draft_pool_ratio
        or o.mend_flag <> n.mend_flag
        or o.operator_no <> n.operator_no
        or o.operator_date <> n.operator_date
        or o.task_type <> n.task_type
        or o.issuing_mode <> n.issuing_mode
        or o.agency_bank_name <> n.agency_bank_name
        or o.agency_bank_no <> n.agency_bank_no
        or o.entrust_cust_no <> n.entrust_cust_no
        or o.exposure_mgn_ratio <> n.exposure_mgn_ratio
        or o.assurance_ratio <> n.assurance_ratio
        or o.assurance_amount <> n.assurance_amount
        or o.add_last_date <> n.add_last_date
        or o.apply_reason <> n.apply_reason
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.agency_name <> n.agency_name
        or o.agency_account <> n.agency_account
        or o.guarantee_state <> n.guarantee_state
        or o.last_txn_date <> n.last_txn_date
        or o.last_operator_no <> n.last_operator_no
        or o.credit_status <> n.credit_status
        or o.acceptor_ratg_agcy <> n.acceptor_ratg_agcy
        or o.acceptor_ratg_duedt <> n.acceptor_ratg_duedt
        or o.acceptor_credit_ratgs <> n.acceptor_credit_ratgs
        or o.bail_rate <> n.bail_rate
        or o.drawee_address <> n.drawee_address
        or o.webbank_contract_id <> n.webbank_contract_id
        or o.repayment_acct <> n.repayment_acct
        or o.unique_seq_num <> n.unique_seq_num
        or o.credit_fee_scale <> n.credit_fee_scale
        or o.logic_check_status <> n.logic_check_status
        or o.misc <> n.misc
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
        or o.pdrifd <> n.pdrifd
        or o.pdrifm <> n.pdrifm
        or o.pdrifv <> n.pdrifv
        or o.business_exp <> n.business_exp
        or o.low_risk <> n.low_risk
        or o.credit_protocol_no <> n.credit_protocol_no
        or o.contract_status <> n.contract_status
        or o.first_repayment_acct <> n.first_repayment_acct
        or o.acct_status <> n.acct_status
        or o.send_file_status <> n.send_file_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_accept_contract_cl(
            id -- ID
            ,protocol_no -- 承兑协议号
            ,credit_no -- 信贷合同号
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,prod_no -- 产品类型编码
            ,actually_industy -- 行业
            ,apply_accept_amount -- 申请承兑金额
            ,apply_remit_date -- 申请出票日
            ,maturity_date -- 到期日
            ,trans_amount -- 交易金额
            ,credit_contract_amount -- 信贷合同金额
            ,credit_flow_no -- 信贷流水号
            ,apply_no -- 申请编号
            ,audit_status -- 审核状态： 0 未审核 1 已提交审核 2 审核中 3 审核成功 4 审核失败 5 回退 6 审批中(单笔退回)
            ,bail_ratio -- 保证金比例
            ,remitter_name -- 出票人
            ,remitter_account -- 出票人账号
            ,remitter_brch_no -- 出票人开户机构
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行行名
            ,drawee_bank_no -- 付款行号
            ,drawee_bank_name -- 付款行名
            ,remitter_cust_no -- 出票人客户号
            ,top_branch_no -- 总行机构号
            ,busi_branch_no -- 业务发起机构号
            ,trans_branch_no -- 交易机构号(记账机构)
            ,acct_branch_no -- 账务机构号
            ,guarantee_type -- 担保方式： 1 大额存单 2 抵制压物
            ,pledge_no -- 抵质押编号
            ,pledge_amount -- 抵质押价值
            ,charge_ratio -- 手续费比例
            ,impawn_percent -- 质押比例
            ,protocol_status -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,credit_fee_ratio -- 额度管理费比例
            ,source_type -- 数据来源类型： 1 手工录入 2 网银获得
            ,department_no -- 部门号
            ,manager_no -- 客户经理号
            ,draft_pool_ratio -- 额度池占用比例
            ,mend_flag -- 跟单资料后补标志： 0 否 1 是
            ,operator_no -- 操作员号
            ,operator_date -- 操作日期
            ,task_type -- 任务类型
            ,issuing_mode -- 签发模式
            ,agency_bank_name -- 被代理行全称
            ,agency_bank_no -- 被代理行行号
            ,entrust_cust_no -- 委托行客户号
            ,exposure_mgn_ratio -- 敞口费比例
            ,assurance_ratio -- 协议保证金比例
            ,assurance_amount -- 协议保证金金额
            ,add_last_date -- 资料后补日期
            ,apply_reason -- 申请原因和用途
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注13
            ,agency_name -- 被代理人全称
            ,agency_account -- 被代理人帐号
            ,guarantee_state -- 担保类型： 1 一对多 2 一对一
            ,last_txn_date -- 最后修改时间
            ,last_operator_no -- 最后修改操作员
            ,credit_status -- 风险检查状态： 0 无效 1 检查通过 2 检查通过，存在风险 3 检查不通过
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,bail_rate -- 保证金利率
            ,drawee_address -- 付款行地址
            ,webbank_contract_id -- 网银承兑协议ID
            ,repayment_acct -- 还款账号
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,credit_fee_scale -- 额度管理费比例
            ,logic_check_status -- 业务逻辑检查状态1-业务逻辑未检查2-业务逻辑检查成功3-业务逻辑检查失败
            ,misc -- 信息域
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
            ,pdrifd -- 保证金利率浮动类型
            ,pdrifm -- 保证金利率浮动方式
            ,pdrifv -- 保证金浮动值
            ,business_exp -- 业务合同占用敞口金额
            ,low_risk -- 是否低风险业务
            ,credit_protocol_no -- 信贷业务合同号
            ,contract_status -- 批次状态
            ,first_repayment_acct -- 第一还款账号
            ,acct_status -- 
            ,send_file_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_accept_contract_op(
            id -- ID
            ,protocol_no -- 承兑协议号
            ,credit_no -- 信贷合同号
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,prod_no -- 产品类型编码
            ,actually_industy -- 行业
            ,apply_accept_amount -- 申请承兑金额
            ,apply_remit_date -- 申请出票日
            ,maturity_date -- 到期日
            ,trans_amount -- 交易金额
            ,credit_contract_amount -- 信贷合同金额
            ,credit_flow_no -- 信贷流水号
            ,apply_no -- 申请编号
            ,audit_status -- 审核状态： 0 未审核 1 已提交审核 2 审核中 3 审核成功 4 审核失败 5 回退 6 审批中(单笔退回)
            ,bail_ratio -- 保证金比例
            ,remitter_name -- 出票人
            ,remitter_account -- 出票人账号
            ,remitter_brch_no -- 出票人开户机构
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行行名
            ,drawee_bank_no -- 付款行号
            ,drawee_bank_name -- 付款行名
            ,remitter_cust_no -- 出票人客户号
            ,top_branch_no -- 总行机构号
            ,busi_branch_no -- 业务发起机构号
            ,trans_branch_no -- 交易机构号(记账机构)
            ,acct_branch_no -- 账务机构号
            ,guarantee_type -- 担保方式： 1 大额存单 2 抵制压物
            ,pledge_no -- 抵质押编号
            ,pledge_amount -- 抵质押价值
            ,charge_ratio -- 手续费比例
            ,impawn_percent -- 质押比例
            ,protocol_status -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,credit_fee_ratio -- 额度管理费比例
            ,source_type -- 数据来源类型： 1 手工录入 2 网银获得
            ,department_no -- 部门号
            ,manager_no -- 客户经理号
            ,draft_pool_ratio -- 额度池占用比例
            ,mend_flag -- 跟单资料后补标志： 0 否 1 是
            ,operator_no -- 操作员号
            ,operator_date -- 操作日期
            ,task_type -- 任务类型
            ,issuing_mode -- 签发模式
            ,agency_bank_name -- 被代理行全称
            ,agency_bank_no -- 被代理行行号
            ,entrust_cust_no -- 委托行客户号
            ,exposure_mgn_ratio -- 敞口费比例
            ,assurance_ratio -- 协议保证金比例
            ,assurance_amount -- 协议保证金金额
            ,add_last_date -- 资料后补日期
            ,apply_reason -- 申请原因和用途
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注13
            ,agency_name -- 被代理人全称
            ,agency_account -- 被代理人帐号
            ,guarantee_state -- 担保类型： 1 一对多 2 一对一
            ,last_txn_date -- 最后修改时间
            ,last_operator_no -- 最后修改操作员
            ,credit_status -- 风险检查状态： 0 无效 1 检查通过 2 检查通过，存在风险 3 检查不通过
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,bail_rate -- 保证金利率
            ,drawee_address -- 付款行地址
            ,webbank_contract_id -- 网银承兑协议ID
            ,repayment_acct -- 还款账号
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,credit_fee_scale -- 额度管理费比例
            ,logic_check_status -- 业务逻辑检查状态1-业务逻辑未检查2-业务逻辑检查成功3-业务逻辑检查失败
            ,misc -- 信息域
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
            ,pdrifd -- 保证金利率浮动类型
            ,pdrifm -- 保证金利率浮动方式
            ,pdrifv -- 保证金浮动值
            ,business_exp -- 业务合同占用敞口金额
            ,low_risk -- 是否低风险业务
            ,credit_protocol_no -- 信贷业务合同号
            ,contract_status -- 批次状态
            ,first_repayment_acct -- 第一还款账号
            ,acct_status -- 
            ,send_file_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.protocol_no -- 承兑协议号
    ,o.credit_no -- 信贷合同号
    ,o.draft_attr -- 票据属性： 1 纸票 2 电票
    ,o.draft_type -- 票据类型： 1 银票 2 商票
    ,o.prod_no -- 产品类型编码
    ,o.actually_industy -- 行业
    ,o.apply_accept_amount -- 申请承兑金额
    ,o.apply_remit_date -- 申请出票日
    ,o.maturity_date -- 到期日
    ,o.trans_amount -- 交易金额
    ,o.credit_contract_amount -- 信贷合同金额
    ,o.credit_flow_no -- 信贷流水号
    ,o.apply_no -- 申请编号
    ,o.audit_status -- 审核状态： 0 未审核 1 已提交审核 2 审核中 3 审核成功 4 审核失败 5 回退 6 审批中(单笔退回)
    ,o.bail_ratio -- 保证金比例
    ,o.remitter_name -- 出票人
    ,o.remitter_account -- 出票人账号
    ,o.remitter_brch_no -- 出票人开户机构
    ,o.remitter_bank_no -- 出票人开户行行号
    ,o.remitter_bank_name -- 出票人开户行行名
    ,o.drawee_bank_no -- 付款行号
    ,o.drawee_bank_name -- 付款行名
    ,o.remitter_cust_no -- 出票人客户号
    ,o.top_branch_no -- 总行机构号
    ,o.busi_branch_no -- 业务发起机构号
    ,o.trans_branch_no -- 交易机构号(记账机构)
    ,o.acct_branch_no -- 账务机构号
    ,o.guarantee_type -- 担保方式： 1 大额存单 2 抵制压物
    ,o.pledge_no -- 抵质押编号
    ,o.pledge_amount -- 抵质押价值
    ,o.charge_ratio -- 手续费比例
    ,o.impawn_percent -- 质押比例
    ,o.protocol_status -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
    ,o.credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
    ,o.credit_fee_ratio -- 额度管理费比例
    ,o.source_type -- 数据来源类型： 1 手工录入 2 网银获得
    ,o.department_no -- 部门号
    ,o.manager_no -- 客户经理号
    ,o.draft_pool_ratio -- 额度池占用比例
    ,o.mend_flag -- 跟单资料后补标志： 0 否 1 是
    ,o.operator_no -- 操作员号
    ,o.operator_date -- 操作日期
    ,o.task_type -- 任务类型
    ,o.issuing_mode -- 签发模式
    ,o.agency_bank_name -- 被代理行全称
    ,o.agency_bank_no -- 被代理行行号
    ,o.entrust_cust_no -- 委托行客户号
    ,o.exposure_mgn_ratio -- 敞口费比例
    ,o.assurance_ratio -- 协议保证金比例
    ,o.assurance_amount -- 协议保证金金额
    ,o.add_last_date -- 资料后补日期
    ,o.apply_reason -- 申请原因和用途
    ,o.reserve1 -- 备注1
    ,o.reserve2 -- 备注2
    ,o.reserve3 -- 备注13
    ,o.agency_name -- 被代理人全称
    ,o.agency_account -- 被代理人帐号
    ,o.guarantee_state -- 担保类型： 1 一对多 2 一对一
    ,o.last_txn_date -- 最后修改时间
    ,o.last_operator_no -- 最后修改操作员
    ,o.credit_status -- 风险检查状态： 0 无效 1 检查通过 2 检查通过，存在风险 3 检查不通过
    ,o.acceptor_ratg_agcy -- 承兑人评级主体
    ,o.acceptor_ratg_duedt -- 承兑人评级到期日
    ,o.acceptor_credit_ratgs -- 承兑人信用等级
    ,o.bail_rate -- 保证金利率
    ,o.drawee_address -- 付款行地址
    ,o.webbank_contract_id -- 网银承兑协议ID
    ,o.repayment_acct -- 还款账号
    ,o.unique_seq_num -- 业务流水号(交易订单号)
    ,o.credit_fee_scale -- 额度管理费比例
    ,o.logic_check_status -- 业务逻辑检查状态1-业务逻辑未检查2-业务逻辑检查成功3-业务逻辑检查失败
    ,o.misc -- 信息域
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
    ,o.pdrifd -- 保证金利率浮动类型
    ,o.pdrifm -- 保证金利率浮动方式
    ,o.pdrifv -- 保证金浮动值
    ,o.business_exp -- 业务合同占用敞口金额
    ,o.low_risk -- 是否低风险业务
    ,o.credit_protocol_no -- 信贷业务合同号
    ,o.contract_status -- 批次状态
    ,o.first_repayment_acct -- 第一还款账号
    ,o.acct_status -- 
    ,o.send_file_status -- 
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
from ${iol_schema}.bdms_bms_accept_contract_bk o
    left join ${iol_schema}.bdms_bms_accept_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_accept_contract_cl d
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
--truncate table ${iol_schema}.bdms_bms_accept_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_accept_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_accept_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_accept_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_accept_contract exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_accept_contract_cl;
alter table ${iol_schema}.bdms_bms_accept_contract exchange partition p_20991231 with table ${iol_schema}.bdms_bms_accept_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_accept_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_accept_contract_op purge;
drop table ${iol_schema}.bdms_bms_accept_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_accept_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_accept_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
