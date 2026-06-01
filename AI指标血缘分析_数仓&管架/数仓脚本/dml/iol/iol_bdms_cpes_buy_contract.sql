/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_buy_contract
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
create table ${iol_schema}.bdms_cpes_buy_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_buy_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_buy_contract_op purge;
drop table ${iol_schema}.bdms_cpes_buy_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_buy_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_buy_contract where 0=1;

create table ${iol_schema}.bdms_cpes_buy_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_buy_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_buy_contract_cl(
            id -- ID
            ,protocol_no -- 贴现协议号
            ,credit_no -- 信贷合同号
            ,credit_flow_no -- 信贷流水号
            ,busi_branch_no -- 交易机构编号
            ,acct_branch_no -- 账务机构号
            ,store_branch_no -- 库存机构号
            ,manager_no -- 客户经理编号
            ,department_no -- 所属部门编号
            ,product_no -- 产品类型编码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,cust_no -- 贴出人客户号
            ,cust_name -- 贴出人全称
            ,cust_account -- 贴出人帐号
            ,cust_bank_no -- 贴出人开户行行号
            ,cust_bank_name -- 贴出人开户行名称
            ,apply_date -- 贴现申请日
            ,rate_type -- 利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
            ,rate -- 利率
            ,pay_type -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
            ,payer_scale -- 买方付息比例
            ,payer_name -- 买方全称
            ,payer_account -- 买方帐号
            ,agent_name -- 代理人全称
            ,agent_account -- 代理人帐号
            ,agent_bank_no -- 代理人开户行行号
            ,agent_bank_name -- 代理人开户行名称
            ,mend_flag -- 是否资料后补： 0 否 1 是
            ,agent_flag -- 是否代理贴现： 0 否 1 是
            ,discount_first_flag -- 是否先贴后查： 0 否 1 是
            ,actually_industy -- 实际投向行业
            ,rpd_mk -- 贴现种类： RM00 买断 RM01 回购
            ,inner_flag -- 是否系统内买入： 0 否 1 是
            ,storage_flag -- 是否代保管： 0 否 1 是
            ,repurchase_rate_type -- 赎回利率类型
            ,repurchase_rate -- 赎回利率
            ,repurchase_begin_date -- 赎回开放日
            ,repurchase_end_date -- 赎回截止日
            ,payer_bank_no -- 买方开户行行号
            ,payer_bank_name -- 买方开户行名称
            ,operator_no -- 业务发起人编号
            ,txn_date -- 业务发起日期
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,check_status -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,contract_status -- 批次状态： 00 无效 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 10 报文处理中 11 报文处理完成 13 部分散票审核退回 20 到期处理中 21 到期处理完成
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,sell_contract_id -- 卖出协议ID
            ,task_type -- 任务类型
            ,busi_type -- 贴现类型： 507 直贴 508 回购式贴现 509 代理直贴 517 供应链直贴 518 供应链回购式贴现 519 供应链代理直贴
            ,end_smt_flag -- 是否转入： 0 否 1 是
            ,trans_branch_no -- 交易机构号
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,top_branch_no -- 总行机构号
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,clear_type -- 清算类型:CT01 全额清算;CT02 净额清算
            ,settle_date -- 结算日期
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,e_contract_no -- 电子合同号
            ,e_img_no -- 电子合同影响流水号
            ,is_related -- 是否关联方查询
            ,file_name -- 
            ,cert_type -- 
            ,total_ck_sum -- 客户已使用敞口
            ,used_total_ck_sum -- 客户已使用敞口
            ,contract_date -- 信贷协议到期日
            ,internal_account -- 内部结算户
            ,i9_type -- 
            ,cert_id -- 
            ,freeze_total_sum -- 
            ,credit_aggreement -- 额度合同号
            ,report_url -- 
            ,used_total_sum -- 合同已用总额
            ,sum_contract -- 
            ,add_last_date -- 后补截止日期
            ,batch_no -- 证件ID
            ,total_sum -- 客户总额度
            ,is_zhuanrang -- 
            ,sum_use_contract -- 合同已使用金额
            ,trans_amount -- 信贷有效金额
            ,all_credit_exp -- 已批准使用授信敞口
            ,total_use_credit_exp -- 
            ,bussiness_type -- 业务细类
            ,sttlm_mk -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,acct_status -- 
            ,send_file_status -- 
            ,business_belong_branchno -- 业务所属分行
            ,link_rate -- 联动利率
            ,ebank_seria_no -- 
            ,risk_scale -- 
            ,fnlrvwtm -- 
            ,scf_flag -- 
            ,scf_prod -- 
            ,scf_risk_control_result -- 
            ,ato_sell_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_buy_contract_op(
            id -- ID
            ,protocol_no -- 贴现协议号
            ,credit_no -- 信贷合同号
            ,credit_flow_no -- 信贷流水号
            ,busi_branch_no -- 交易机构编号
            ,acct_branch_no -- 账务机构号
            ,store_branch_no -- 库存机构号
            ,manager_no -- 客户经理编号
            ,department_no -- 所属部门编号
            ,product_no -- 产品类型编码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,cust_no -- 贴出人客户号
            ,cust_name -- 贴出人全称
            ,cust_account -- 贴出人帐号
            ,cust_bank_no -- 贴出人开户行行号
            ,cust_bank_name -- 贴出人开户行名称
            ,apply_date -- 贴现申请日
            ,rate_type -- 利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
            ,rate -- 利率
            ,pay_type -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
            ,payer_scale -- 买方付息比例
            ,payer_name -- 买方全称
            ,payer_account -- 买方帐号
            ,agent_name -- 代理人全称
            ,agent_account -- 代理人帐号
            ,agent_bank_no -- 代理人开户行行号
            ,agent_bank_name -- 代理人开户行名称
            ,mend_flag -- 是否资料后补： 0 否 1 是
            ,agent_flag -- 是否代理贴现： 0 否 1 是
            ,discount_first_flag -- 是否先贴后查： 0 否 1 是
            ,actually_industy -- 实际投向行业
            ,rpd_mk -- 贴现种类： RM00 买断 RM01 回购
            ,inner_flag -- 是否系统内买入： 0 否 1 是
            ,storage_flag -- 是否代保管： 0 否 1 是
            ,repurchase_rate_type -- 赎回利率类型
            ,repurchase_rate -- 赎回利率
            ,repurchase_begin_date -- 赎回开放日
            ,repurchase_end_date -- 赎回截止日
            ,payer_bank_no -- 买方开户行行号
            ,payer_bank_name -- 买方开户行名称
            ,operator_no -- 业务发起人编号
            ,txn_date -- 业务发起日期
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,check_status -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,contract_status -- 批次状态： 00 无效 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 10 报文处理中 11 报文处理完成 13 部分散票审核退回 20 到期处理中 21 到期处理完成
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,sell_contract_id -- 卖出协议ID
            ,task_type -- 任务类型
            ,busi_type -- 贴现类型： 507 直贴 508 回购式贴现 509 代理直贴 517 供应链直贴 518 供应链回购式贴现 519 供应链代理直贴
            ,end_smt_flag -- 是否转入： 0 否 1 是
            ,trans_branch_no -- 交易机构号
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,top_branch_no -- 总行机构号
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,clear_type -- 清算类型:CT01 全额清算;CT02 净额清算
            ,settle_date -- 结算日期
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,e_contract_no -- 电子合同号
            ,e_img_no -- 电子合同影响流水号
            ,is_related -- 是否关联方查询
            ,file_name -- 
            ,cert_type -- 
            ,total_ck_sum -- 客户已使用敞口
            ,used_total_ck_sum -- 客户已使用敞口
            ,contract_date -- 信贷协议到期日
            ,internal_account -- 内部结算户
            ,i9_type -- 
            ,cert_id -- 
            ,freeze_total_sum -- 
            ,credit_aggreement -- 额度合同号
            ,report_url -- 
            ,used_total_sum -- 合同已用总额
            ,sum_contract -- 
            ,add_last_date -- 后补截止日期
            ,batch_no -- 证件ID
            ,total_sum -- 客户总额度
            ,is_zhuanrang -- 
            ,sum_use_contract -- 合同已使用金额
            ,trans_amount -- 信贷有效金额
            ,all_credit_exp -- 已批准使用授信敞口
            ,total_use_credit_exp -- 
            ,bussiness_type -- 业务细类
            ,sttlm_mk -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,acct_status -- 
            ,send_file_status -- 
            ,business_belong_branchno -- 业务所属分行
            ,link_rate -- 联动利率
            ,ebank_seria_no -- 
            ,risk_scale -- 
            ,fnlrvwtm -- 
            ,scf_flag -- 
            ,scf_prod -- 
            ,scf_risk_control_result -- 
            ,ato_sell_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.protocol_no, o.protocol_no) as protocol_no -- 贴现协议号
    ,nvl(n.credit_no, o.credit_no) as credit_no -- 信贷合同号
    ,nvl(n.credit_flow_no, o.credit_flow_no) as credit_flow_no -- 信贷流水号
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 交易机构编号
    ,nvl(n.acct_branch_no, o.acct_branch_no) as acct_branch_no -- 账务机构号
    ,nvl(n.store_branch_no, o.store_branch_no) as store_branch_no -- 库存机构号
    ,nvl(n.manager_no, o.manager_no) as manager_no -- 客户经理编号
    ,nvl(n.department_no, o.department_no) as department_no -- 所属部门编号
    ,nvl(n.product_no, o.product_no) as product_no -- 产品类型编码
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据属性： 1 纸票 2 电票
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： 1 银票 2 商票
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 贴出人客户号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 贴出人全称
    ,nvl(n.cust_account, o.cust_account) as cust_account -- 贴出人帐号
    ,nvl(n.cust_bank_no, o.cust_bank_no) as cust_bank_no -- 贴出人开户行行号
    ,nvl(n.cust_bank_name, o.cust_bank_name) as cust_bank_name -- 贴出人开户行名称
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 贴现申请日
    ,nvl(n.rate_type, o.rate_type) as rate_type -- 利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
    ,nvl(n.rate, o.rate) as rate -- 利率
    ,nvl(n.pay_type, o.pay_type) as pay_type -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
    ,nvl(n.payer_scale, o.payer_scale) as payer_scale -- 买方付息比例
    ,nvl(n.payer_name, o.payer_name) as payer_name -- 买方全称
    ,nvl(n.payer_account, o.payer_account) as payer_account -- 买方帐号
    ,nvl(n.agent_name, o.agent_name) as agent_name -- 代理人全称
    ,nvl(n.agent_account, o.agent_account) as agent_account -- 代理人帐号
    ,nvl(n.agent_bank_no, o.agent_bank_no) as agent_bank_no -- 代理人开户行行号
    ,nvl(n.agent_bank_name, o.agent_bank_name) as agent_bank_name -- 代理人开户行名称
    ,nvl(n.mend_flag, o.mend_flag) as mend_flag -- 是否资料后补： 0 否 1 是
    ,nvl(n.agent_flag, o.agent_flag) as agent_flag -- 是否代理贴现： 0 否 1 是
    ,nvl(n.discount_first_flag, o.discount_first_flag) as discount_first_flag -- 是否先贴后查： 0 否 1 是
    ,nvl(n.actually_industy, o.actually_industy) as actually_industy -- 实际投向行业
    ,nvl(n.rpd_mk, o.rpd_mk) as rpd_mk -- 贴现种类： RM00 买断 RM01 回购
    ,nvl(n.inner_flag, o.inner_flag) as inner_flag -- 是否系统内买入： 0 否 1 是
    ,nvl(n.storage_flag, o.storage_flag) as storage_flag -- 是否代保管： 0 否 1 是
    ,nvl(n.repurchase_rate_type, o.repurchase_rate_type) as repurchase_rate_type -- 赎回利率类型
    ,nvl(n.repurchase_rate, o.repurchase_rate) as repurchase_rate -- 赎回利率
    ,nvl(n.repurchase_begin_date, o.repurchase_begin_date) as repurchase_begin_date -- 赎回开放日
    ,nvl(n.repurchase_end_date, o.repurchase_end_date) as repurchase_end_date -- 赎回截止日
    ,nvl(n.payer_bank_no, o.payer_bank_no) as payer_bank_no -- 买方开户行行号
    ,nvl(n.payer_bank_name, o.payer_bank_name) as payer_bank_name -- 买方开户行名称
    ,nvl(n.operator_no, o.operator_no) as operator_no -- 业务发起人编号
    ,nvl(n.txn_date, o.txn_date) as txn_date -- 业务发起日期
    ,nvl(n.last_operator_no, o.last_operator_no) as last_operator_no -- 最后操作员编号
    ,nvl(n.last_txn_date, o.last_txn_date) as last_txn_date -- 最后操作日期
    ,nvl(n.check_status, o.check_status) as check_status -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 批次状态： 00 无效 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 10 报文处理中 11 报文处理完成 13 部分散票审核退回 20 到期处理中 21 到期处理完成
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
    ,nvl(n.sell_contract_id, o.sell_contract_id) as sell_contract_id -- 卖出协议ID
    ,nvl(n.task_type, o.task_type) as task_type -- 任务类型
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 贴现类型： 507 直贴 508 回购式贴现 509 代理直贴 517 供应链直贴 518 供应链回购式贴现 519 供应链代理直贴
    ,nvl(n.end_smt_flag, o.end_smt_flag) as end_smt_flag -- 是否转入： 0 否 1 是
    ,nvl(n.trans_branch_no, o.trans_branch_no) as trans_branch_no -- 交易机构号
    ,nvl(n.credit_check_status, o.credit_check_status) as credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备注1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备注2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备注3
    ,nvl(n.settle_type, o.settle_type) as settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
    ,nvl(n.clear_type, o.clear_type) as clear_type -- 清算类型:CT01 全额清算;CT02 净额清算
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 结算日期
    ,nvl(n.unique_seq_num, o.unique_seq_num) as unique_seq_num -- 业务流水号(交易订单号)
    ,nvl(n.e_contract_no, o.e_contract_no) as e_contract_no -- 电子合同号
    ,nvl(n.e_img_no, o.e_img_no) as e_img_no -- 电子合同影响流水号
    ,nvl(n.is_related, o.is_related) as is_related -- 是否关联方查询
    ,nvl(n.file_name, o.file_name) as file_name -- 
    ,nvl(n.cert_type, o.cert_type) as cert_type -- 
    ,nvl(n.total_ck_sum, o.total_ck_sum) as total_ck_sum -- 客户已使用敞口
    ,nvl(n.used_total_ck_sum, o.used_total_ck_sum) as used_total_ck_sum -- 客户已使用敞口
    ,nvl(n.contract_date, o.contract_date) as contract_date -- 信贷协议到期日
    ,nvl(n.internal_account, o.internal_account) as internal_account -- 内部结算户
    ,nvl(n.i9_type, o.i9_type) as i9_type -- 
    ,nvl(n.cert_id, o.cert_id) as cert_id -- 
    ,nvl(n.freeze_total_sum, o.freeze_total_sum) as freeze_total_sum -- 
    ,nvl(n.credit_aggreement, o.credit_aggreement) as credit_aggreement -- 额度合同号
    ,nvl(n.report_url, o.report_url) as report_url -- 
    ,nvl(n.used_total_sum, o.used_total_sum) as used_total_sum -- 合同已用总额
    ,nvl(n.sum_contract, o.sum_contract) as sum_contract -- 
    ,nvl(n.add_last_date, o.add_last_date) as add_last_date -- 后补截止日期
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 证件ID
    ,nvl(n.total_sum, o.total_sum) as total_sum -- 客户总额度
    ,nvl(n.is_zhuanrang, o.is_zhuanrang) as is_zhuanrang -- 
    ,nvl(n.sum_use_contract, o.sum_use_contract) as sum_use_contract -- 合同已使用金额
    ,nvl(n.trans_amount, o.trans_amount) as trans_amount -- 信贷有效金额
    ,nvl(n.all_credit_exp, o.all_credit_exp) as all_credit_exp -- 已批准使用授信敞口
    ,nvl(n.total_use_credit_exp, o.total_use_credit_exp) as total_use_credit_exp -- 
    ,nvl(n.bussiness_type, o.bussiness_type) as bussiness_type -- 业务细类
    ,nvl(n.sttlm_mk, o.sttlm_mk) as sttlm_mk -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
    ,nvl(n.acct_status, o.acct_status) as acct_status -- 
    ,nvl(n.send_file_status, o.send_file_status) as send_file_status -- 
    ,nvl(n.business_belong_branchno, o.business_belong_branchno) as business_belong_branchno -- 业务所属分行
    ,nvl(n.link_rate, o.link_rate) as link_rate -- 联动利率
    ,nvl(n.ebank_seria_no, o.ebank_seria_no) as ebank_seria_no -- 
    ,nvl(n.risk_scale, o.risk_scale) as risk_scale -- 
    ,nvl(n.fnlrvwtm, o.fnlrvwtm) as fnlrvwtm -- 
    ,nvl(n.scf_flag, o.scf_flag) as scf_flag -- 
    ,nvl(n.scf_prod, o.scf_prod) as scf_prod -- 
    ,nvl(n.scf_risk_control_result, o.scf_risk_control_result) as scf_risk_control_result -- 
    ,nvl(n.ato_sell_flag, o.ato_sell_flag) as ato_sell_flag -- 
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
from (select * from ${iol_schema}.bdms_cpes_buy_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_buy_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.credit_flow_no <> n.credit_flow_no
        or o.busi_branch_no <> n.busi_branch_no
        or o.acct_branch_no <> n.acct_branch_no
        or o.store_branch_no <> n.store_branch_no
        or o.manager_no <> n.manager_no
        or o.department_no <> n.department_no
        or o.product_no <> n.product_no
        or o.draft_attr <> n.draft_attr
        or o.draft_type <> n.draft_type
        or o.cust_no <> n.cust_no
        or o.cust_name <> n.cust_name
        or o.cust_account <> n.cust_account
        or o.cust_bank_no <> n.cust_bank_no
        or o.cust_bank_name <> n.cust_bank_name
        or o.apply_date <> n.apply_date
        or o.rate_type <> n.rate_type
        or o.rate <> n.rate
        or o.pay_type <> n.pay_type
        or o.payer_scale <> n.payer_scale
        or o.payer_name <> n.payer_name
        or o.payer_account <> n.payer_account
        or o.agent_name <> n.agent_name
        or o.agent_account <> n.agent_account
        or o.agent_bank_no <> n.agent_bank_no
        or o.agent_bank_name <> n.agent_bank_name
        or o.mend_flag <> n.mend_flag
        or o.agent_flag <> n.agent_flag
        or o.discount_first_flag <> n.discount_first_flag
        or o.actually_industy <> n.actually_industy
        or o.rpd_mk <> n.rpd_mk
        or o.inner_flag <> n.inner_flag
        or o.storage_flag <> n.storage_flag
        or o.repurchase_rate_type <> n.repurchase_rate_type
        or o.repurchase_rate <> n.repurchase_rate
        or o.repurchase_begin_date <> n.repurchase_begin_date
        or o.repurchase_end_date <> n.repurchase_end_date
        or o.payer_bank_no <> n.payer_bank_no
        or o.payer_bank_name <> n.payer_bank_name
        or o.operator_no <> n.operator_no
        or o.txn_date <> n.txn_date
        or o.last_operator_no <> n.last_operator_no
        or o.last_txn_date <> n.last_txn_date
        or o.check_status <> n.check_status
        or o.contract_status <> n.contract_status
        or o.account_status <> n.account_status
        or o.sell_contract_id <> n.sell_contract_id
        or o.task_type <> n.task_type
        or o.busi_type <> n.busi_type
        or o.end_smt_flag <> n.end_smt_flag
        or o.trans_branch_no <> n.trans_branch_no
        or o.credit_check_status <> n.credit_check_status
        or o.top_branch_no <> n.top_branch_no
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.settle_type <> n.settle_type
        or o.clear_type <> n.clear_type
        or o.settle_date <> n.settle_date
        or o.unique_seq_num <> n.unique_seq_num
        or o.e_contract_no <> n.e_contract_no
        or o.e_img_no <> n.e_img_no
        or o.is_related <> n.is_related
        or o.file_name <> n.file_name
        or o.cert_type <> n.cert_type
        or o.total_ck_sum <> n.total_ck_sum
        or o.used_total_ck_sum <> n.used_total_ck_sum
        or o.contract_date <> n.contract_date
        or o.internal_account <> n.internal_account
        or o.i9_type <> n.i9_type
        or o.cert_id <> n.cert_id
        or o.freeze_total_sum <> n.freeze_total_sum
        or o.credit_aggreement <> n.credit_aggreement
        or o.report_url <> n.report_url
        or o.used_total_sum <> n.used_total_sum
        or o.sum_contract <> n.sum_contract
        or o.add_last_date <> n.add_last_date
        or o.batch_no <> n.batch_no
        or o.total_sum <> n.total_sum
        or o.is_zhuanrang <> n.is_zhuanrang
        or o.sum_use_contract <> n.sum_use_contract
        or o.trans_amount <> n.trans_amount
        or o.all_credit_exp <> n.all_credit_exp
        or o.total_use_credit_exp <> n.total_use_credit_exp
        or o.bussiness_type <> n.bussiness_type
        or o.sttlm_mk <> n.sttlm_mk
        or o.acct_status <> n.acct_status
        or o.send_file_status <> n.send_file_status
        or o.business_belong_branchno <> n.business_belong_branchno
        or o.link_rate <> n.link_rate
        or o.ebank_seria_no <> n.ebank_seria_no
        or o.risk_scale <> n.risk_scale
        or o.fnlrvwtm <> n.fnlrvwtm
        or o.scf_flag <> n.scf_flag
        or o.scf_prod <> n.scf_prod
        or o.scf_risk_control_result <> n.scf_risk_control_result
        or o.ato_sell_flag <> n.ato_sell_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_buy_contract_cl(
            id -- ID
            ,protocol_no -- 贴现协议号
            ,credit_no -- 信贷合同号
            ,credit_flow_no -- 信贷流水号
            ,busi_branch_no -- 交易机构编号
            ,acct_branch_no -- 账务机构号
            ,store_branch_no -- 库存机构号
            ,manager_no -- 客户经理编号
            ,department_no -- 所属部门编号
            ,product_no -- 产品类型编码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,cust_no -- 贴出人客户号
            ,cust_name -- 贴出人全称
            ,cust_account -- 贴出人帐号
            ,cust_bank_no -- 贴出人开户行行号
            ,cust_bank_name -- 贴出人开户行名称
            ,apply_date -- 贴现申请日
            ,rate_type -- 利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
            ,rate -- 利率
            ,pay_type -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
            ,payer_scale -- 买方付息比例
            ,payer_name -- 买方全称
            ,payer_account -- 买方帐号
            ,agent_name -- 代理人全称
            ,agent_account -- 代理人帐号
            ,agent_bank_no -- 代理人开户行行号
            ,agent_bank_name -- 代理人开户行名称
            ,mend_flag -- 是否资料后补： 0 否 1 是
            ,agent_flag -- 是否代理贴现： 0 否 1 是
            ,discount_first_flag -- 是否先贴后查： 0 否 1 是
            ,actually_industy -- 实际投向行业
            ,rpd_mk -- 贴现种类： RM00 买断 RM01 回购
            ,inner_flag -- 是否系统内买入： 0 否 1 是
            ,storage_flag -- 是否代保管： 0 否 1 是
            ,repurchase_rate_type -- 赎回利率类型
            ,repurchase_rate -- 赎回利率
            ,repurchase_begin_date -- 赎回开放日
            ,repurchase_end_date -- 赎回截止日
            ,payer_bank_no -- 买方开户行行号
            ,payer_bank_name -- 买方开户行名称
            ,operator_no -- 业务发起人编号
            ,txn_date -- 业务发起日期
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,check_status -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,contract_status -- 批次状态： 00 无效 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 10 报文处理中 11 报文处理完成 13 部分散票审核退回 20 到期处理中 21 到期处理完成
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,sell_contract_id -- 卖出协议ID
            ,task_type -- 任务类型
            ,busi_type -- 贴现类型： 507 直贴 508 回购式贴现 509 代理直贴 517 供应链直贴 518 供应链回购式贴现 519 供应链代理直贴
            ,end_smt_flag -- 是否转入： 0 否 1 是
            ,trans_branch_no -- 交易机构号
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,top_branch_no -- 总行机构号
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,clear_type -- 清算类型:CT01 全额清算;CT02 净额清算
            ,settle_date -- 结算日期
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,e_contract_no -- 电子合同号
            ,e_img_no -- 电子合同影响流水号
            ,is_related -- 是否关联方查询
            ,file_name -- 
            ,cert_type -- 
            ,total_ck_sum -- 客户已使用敞口
            ,used_total_ck_sum -- 客户已使用敞口
            ,contract_date -- 信贷协议到期日
            ,internal_account -- 内部结算户
            ,i9_type -- 
            ,cert_id -- 
            ,freeze_total_sum -- 
            ,credit_aggreement -- 额度合同号
            ,report_url -- 
            ,used_total_sum -- 合同已用总额
            ,sum_contract -- 
            ,add_last_date -- 后补截止日期
            ,batch_no -- 证件ID
            ,total_sum -- 客户总额度
            ,is_zhuanrang -- 
            ,sum_use_contract -- 合同已使用金额
            ,trans_amount -- 信贷有效金额
            ,all_credit_exp -- 已批准使用授信敞口
            ,total_use_credit_exp -- 
            ,bussiness_type -- 业务细类
            ,sttlm_mk -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,acct_status -- 
            ,send_file_status -- 
            ,business_belong_branchno -- 业务所属分行
            ,link_rate -- 联动利率
            ,ebank_seria_no -- 
            ,risk_scale -- 
            ,fnlrvwtm -- 
            ,scf_flag -- 
            ,scf_prod -- 
            ,scf_risk_control_result -- 
            ,ato_sell_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_buy_contract_op(
            id -- ID
            ,protocol_no -- 贴现协议号
            ,credit_no -- 信贷合同号
            ,credit_flow_no -- 信贷流水号
            ,busi_branch_no -- 交易机构编号
            ,acct_branch_no -- 账务机构号
            ,store_branch_no -- 库存机构号
            ,manager_no -- 客户经理编号
            ,department_no -- 所属部门编号
            ,product_no -- 产品类型编码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,cust_no -- 贴出人客户号
            ,cust_name -- 贴出人全称
            ,cust_account -- 贴出人帐号
            ,cust_bank_no -- 贴出人开户行行号
            ,cust_bank_name -- 贴出人开户行名称
            ,apply_date -- 贴现申请日
            ,rate_type -- 利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
            ,rate -- 利率
            ,pay_type -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
            ,payer_scale -- 买方付息比例
            ,payer_name -- 买方全称
            ,payer_account -- 买方帐号
            ,agent_name -- 代理人全称
            ,agent_account -- 代理人帐号
            ,agent_bank_no -- 代理人开户行行号
            ,agent_bank_name -- 代理人开户行名称
            ,mend_flag -- 是否资料后补： 0 否 1 是
            ,agent_flag -- 是否代理贴现： 0 否 1 是
            ,discount_first_flag -- 是否先贴后查： 0 否 1 是
            ,actually_industy -- 实际投向行业
            ,rpd_mk -- 贴现种类： RM00 买断 RM01 回购
            ,inner_flag -- 是否系统内买入： 0 否 1 是
            ,storage_flag -- 是否代保管： 0 否 1 是
            ,repurchase_rate_type -- 赎回利率类型
            ,repurchase_rate -- 赎回利率
            ,repurchase_begin_date -- 赎回开放日
            ,repurchase_end_date -- 赎回截止日
            ,payer_bank_no -- 买方开户行行号
            ,payer_bank_name -- 买方开户行名称
            ,operator_no -- 业务发起人编号
            ,txn_date -- 业务发起日期
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,check_status -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,contract_status -- 批次状态： 00 无效 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 10 报文处理中 11 报文处理完成 13 部分散票审核退回 20 到期处理中 21 到期处理完成
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,sell_contract_id -- 卖出协议ID
            ,task_type -- 任务类型
            ,busi_type -- 贴现类型： 507 直贴 508 回购式贴现 509 代理直贴 517 供应链直贴 518 供应链回购式贴现 519 供应链代理直贴
            ,end_smt_flag -- 是否转入： 0 否 1 是
            ,trans_branch_no -- 交易机构号
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,top_branch_no -- 总行机构号
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,clear_type -- 清算类型:CT01 全额清算;CT02 净额清算
            ,settle_date -- 结算日期
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,e_contract_no -- 电子合同号
            ,e_img_no -- 电子合同影响流水号
            ,is_related -- 是否关联方查询
            ,file_name -- 
            ,cert_type -- 
            ,total_ck_sum -- 客户已使用敞口
            ,used_total_ck_sum -- 客户已使用敞口
            ,contract_date -- 信贷协议到期日
            ,internal_account -- 内部结算户
            ,i9_type -- 
            ,cert_id -- 
            ,freeze_total_sum -- 
            ,credit_aggreement -- 额度合同号
            ,report_url -- 
            ,used_total_sum -- 合同已用总额
            ,sum_contract -- 
            ,add_last_date -- 后补截止日期
            ,batch_no -- 证件ID
            ,total_sum -- 客户总额度
            ,is_zhuanrang -- 
            ,sum_use_contract -- 合同已使用金额
            ,trans_amount -- 信贷有效金额
            ,all_credit_exp -- 已批准使用授信敞口
            ,total_use_credit_exp -- 
            ,bussiness_type -- 业务细类
            ,sttlm_mk -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,acct_status -- 
            ,send_file_status -- 
            ,business_belong_branchno -- 业务所属分行
            ,link_rate -- 联动利率
            ,ebank_seria_no -- 
            ,risk_scale -- 
            ,fnlrvwtm -- 
            ,scf_flag -- 
            ,scf_prod -- 
            ,scf_risk_control_result -- 
            ,ato_sell_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.protocol_no -- 贴现协议号
    ,o.credit_no -- 信贷合同号
    ,o.credit_flow_no -- 信贷流水号
    ,o.busi_branch_no -- 交易机构编号
    ,o.acct_branch_no -- 账务机构号
    ,o.store_branch_no -- 库存机构号
    ,o.manager_no -- 客户经理编号
    ,o.department_no -- 所属部门编号
    ,o.product_no -- 产品类型编码
    ,o.draft_attr -- 票据属性： 1 纸票 2 电票
    ,o.draft_type -- 票据类型： 1 银票 2 商票
    ,o.cust_no -- 贴出人客户号
    ,o.cust_name -- 贴出人全称
    ,o.cust_account -- 贴出人帐号
    ,o.cust_bank_no -- 贴出人开户行行号
    ,o.cust_bank_name -- 贴出人开户行名称
    ,o.apply_date -- 贴现申请日
    ,o.rate_type -- 利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
    ,o.rate -- 利率
    ,o.pay_type -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
    ,o.payer_scale -- 买方付息比例
    ,o.payer_name -- 买方全称
    ,o.payer_account -- 买方帐号
    ,o.agent_name -- 代理人全称
    ,o.agent_account -- 代理人帐号
    ,o.agent_bank_no -- 代理人开户行行号
    ,o.agent_bank_name -- 代理人开户行名称
    ,o.mend_flag -- 是否资料后补： 0 否 1 是
    ,o.agent_flag -- 是否代理贴现： 0 否 1 是
    ,o.discount_first_flag -- 是否先贴后查： 0 否 1 是
    ,o.actually_industy -- 实际投向行业
    ,o.rpd_mk -- 贴现种类： RM00 买断 RM01 回购
    ,o.inner_flag -- 是否系统内买入： 0 否 1 是
    ,o.storage_flag -- 是否代保管： 0 否 1 是
    ,o.repurchase_rate_type -- 赎回利率类型
    ,o.repurchase_rate -- 赎回利率
    ,o.repurchase_begin_date -- 赎回开放日
    ,o.repurchase_end_date -- 赎回截止日
    ,o.payer_bank_no -- 买方开户行行号
    ,o.payer_bank_name -- 买方开户行名称
    ,o.operator_no -- 业务发起人编号
    ,o.txn_date -- 业务发起日期
    ,o.last_operator_no -- 最后操作员编号
    ,o.last_txn_date -- 最后操作日期
    ,o.check_status -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
    ,o.contract_status -- 批次状态： 00 无效 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 10 报文处理中 11 报文处理完成 13 部分散票审核退回 20 到期处理中 21 到期处理完成
    ,o.account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
    ,o.sell_contract_id -- 卖出协议ID
    ,o.task_type -- 任务类型
    ,o.busi_type -- 贴现类型： 507 直贴 508 回购式贴现 509 代理直贴 517 供应链直贴 518 供应链回购式贴现 519 供应链代理直贴
    ,o.end_smt_flag -- 是否转入： 0 否 1 是
    ,o.trans_branch_no -- 交易机构号
    ,o.credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
    ,o.top_branch_no -- 总行机构号
    ,o.reserve1 -- 备注1
    ,o.reserve2 -- 备注2
    ,o.reserve3 -- 备注3
    ,o.settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
    ,o.clear_type -- 清算类型:CT01 全额清算;CT02 净额清算
    ,o.settle_date -- 结算日期
    ,o.unique_seq_num -- 业务流水号(交易订单号)
    ,o.e_contract_no -- 电子合同号
    ,o.e_img_no -- 电子合同影响流水号
    ,o.is_related -- 是否关联方查询
    ,o.file_name -- 
    ,o.cert_type -- 
    ,o.total_ck_sum -- 客户已使用敞口
    ,o.used_total_ck_sum -- 客户已使用敞口
    ,o.contract_date -- 信贷协议到期日
    ,o.internal_account -- 内部结算户
    ,o.i9_type -- 
    ,o.cert_id -- 
    ,o.freeze_total_sum -- 
    ,o.credit_aggreement -- 额度合同号
    ,o.report_url -- 
    ,o.used_total_sum -- 合同已用总额
    ,o.sum_contract -- 
    ,o.add_last_date -- 后补截止日期
    ,o.batch_no -- 证件ID
    ,o.total_sum -- 客户总额度
    ,o.is_zhuanrang -- 
    ,o.sum_use_contract -- 合同已使用金额
    ,o.trans_amount -- 信贷有效金额
    ,o.all_credit_exp -- 已批准使用授信敞口
    ,o.total_use_credit_exp -- 
    ,o.bussiness_type -- 业务细类
    ,o.sttlm_mk -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
    ,o.acct_status -- 
    ,o.send_file_status -- 
    ,o.business_belong_branchno -- 业务所属分行
    ,o.link_rate -- 联动利率
    ,o.ebank_seria_no -- 
    ,o.risk_scale -- 
    ,o.fnlrvwtm -- 
    ,o.scf_flag -- 
    ,o.scf_prod -- 
    ,o.scf_risk_control_result -- 
    ,o.ato_sell_flag -- 
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
from ${iol_schema}.bdms_cpes_buy_contract_bk o
    left join ${iol_schema}.bdms_cpes_buy_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_buy_contract_cl d
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
--truncate table ${iol_schema}.bdms_cpes_buy_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_buy_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_buy_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_buy_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_buy_contract exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_buy_contract_cl;
alter table ${iol_schema}.bdms_cpes_buy_contract exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_buy_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_buy_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_buy_contract_op purge;
drop table ${iol_schema}.bdms_cpes_buy_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_buy_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_buy_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
