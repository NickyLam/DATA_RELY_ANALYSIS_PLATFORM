/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_buy_contract
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
create table ${iol_schema}.bdms_bms_buy_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_buy_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_buy_contract_op purge;
drop table ${iol_schema}.bdms_bms_buy_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_buy_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_buy_contract where 0=1;

create table ${iol_schema}.bdms_bms_buy_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_buy_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_buy_contract_cl(
            id -- ID
            ,protocol_no -- 贴现协议号
            ,credit_no -- 信贷合同号
            ,credit_flow_no -- 信贷流水号
            ,busi_branch_no -- 业务机构号
            ,acct_branch_no -- 账务机构号
            ,store_branch_no -- 库存机构号
            ,manager_no -- 客户经理编号
            ,department_no -- 所属部门编号
            ,product_no -- 产品类型编码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,cust_no -- 交易客户编号
            ,cust_name -- 交易客户名称
            ,cust_account -- 交易帐号
            ,cust_bank_no -- 贴出人开户行行号
            ,cust_bank_name -- 贴出人开户行名称
            ,apply_date -- 贴现申请日
            ,rate_type -- 利率期限单位：1 年息% 2 月息‰ 3 日息(万分率)
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
            ,rpd_mk -- （转）贴现种类： RM00 买断 RM01 回购
            ,sttlm_mk -- 清算方式： SM00 线上清算 SM01 线下清算
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
            ,contract_status -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
            ,account_status -- 记账状态：00 无效01 未提交记账02 记账中03 记账完成04 记账失败05 记账异常06 已抹账10 计息复核通过 11 计息复核不通过  07信贷出账中 08 信贷出账成功 09信贷出账失败 12信贷已抹账
            ,sell_contract_id -- 卖出协议ID
            ,task_type -- 任务类型
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,busi_type -- 贴现类型： 020 直贴 021 回购式贴现 022 代理直贴
            ,end_smt_flag -- 是否转入： 0 否 1 是
            ,trans_branch_no -- 交易机构号
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,top_branch_no -- 总行机构号
            ,all_credit_exp -- 已批准使用授信敞口
            ,batch_no -- 批次号
            ,cert_id -- 证件ID
            ,cert_type -- 证件类型1001	组织机构代码1002	中征码1003	机构信用代码2001	工商注册号2002	机关和事业单位登记号2003	社会团体登记号2004	民办非企业单位登记号2005	基金会登记号2006	宗教活动场所登记号2007	统一社会信用代码2008	商事与非商事登记证号2099	其他
            ,freeze_total_sum -- 客户冻结额度
            ,is_internal_settle -- 是否内部结算
            ,total_ck_sum -- 客户已使用敞口
            ,total_sum -- 客户总额度
            ,total_use_credit_exp -- 根词放款后累计使用敞口
            ,trans_amount -- 信贷有效金额
            ,used_total_ck_sum -- 客户已使用敞口
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,e_contract_no -- 电子合同号
            ,e_img_no -- 电子合同影响流水号
            ,i9_type -- 
            ,add_last_date -- 后补截止日期
            ,applock -- 锁状态：00-未加锁 01-加锁
            ,contract_date -- 信贷协议到期日
            ,credit_aggreement -- 额度合同号
            ,discount_flag -- 票交所贴现登记状态0-否 1-是
            ,ebank_seria_no -- 交易门户推送的在线进件的唯一标识
            ,flag -- 是否在线贴现标志0-否 1-是
            ,internal_account -- 内部结算户
            ,is_related -- 是否关联方查询 y-是我行关联方 n-未在我行关联方信息库中找出完全匹配信息 p-关联方是自然人，须同时输入姓名和证件号进行查询 m-通过输入信息查询出多个关联方,请输入更详细的信息进行查询 l-名称非常接近，请做进一步核实
            ,is_zhuanrang -- 是否转让标志
            ,report_url -- 征信报告url
            ,main_assure_type -- 主要担保方式
            ,sum_use_contract -- 合同已使用金额
            ,sum_contract -- 合同总额金额
            ,used_total_sum -- 合同已用总额
            ,file_name -- 走文件方式文件名
            ,credit_protocol_no -- 信贷合同号
            ,central_bankflg -- 转贴现或再贴现0-贴现 1-转贴现 2-再贴现
            ,calc_status -- 
            ,authstatus -- 
            ,bussiness_type -- 业务细类
            ,postpone_type -- 利息计算顺延方式
            ,acct_status -- 
            ,send_file_status -- 
            ,reserve4 -- 
            ,business_belong_branchno -- 业务所属分行
            ,link_rate -- 联动利率
            ,risk_scale -- 
            ,fnlrvwtm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_buy_contract_op(
            id -- ID
            ,protocol_no -- 贴现协议号
            ,credit_no -- 信贷合同号
            ,credit_flow_no -- 信贷流水号
            ,busi_branch_no -- 业务机构号
            ,acct_branch_no -- 账务机构号
            ,store_branch_no -- 库存机构号
            ,manager_no -- 客户经理编号
            ,department_no -- 所属部门编号
            ,product_no -- 产品类型编码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,cust_no -- 交易客户编号
            ,cust_name -- 交易客户名称
            ,cust_account -- 交易帐号
            ,cust_bank_no -- 贴出人开户行行号
            ,cust_bank_name -- 贴出人开户行名称
            ,apply_date -- 贴现申请日
            ,rate_type -- 利率期限单位：1 年息% 2 月息‰ 3 日息(万分率)
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
            ,rpd_mk -- （转）贴现种类： RM00 买断 RM01 回购
            ,sttlm_mk -- 清算方式： SM00 线上清算 SM01 线下清算
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
            ,contract_status -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
            ,account_status -- 记账状态：00 无效01 未提交记账02 记账中03 记账完成04 记账失败05 记账异常06 已抹账10 计息复核通过 11 计息复核不通过  07信贷出账中 08 信贷出账成功 09信贷出账失败 12信贷已抹账
            ,sell_contract_id -- 卖出协议ID
            ,task_type -- 任务类型
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,busi_type -- 贴现类型： 020 直贴 021 回购式贴现 022 代理直贴
            ,end_smt_flag -- 是否转入： 0 否 1 是
            ,trans_branch_no -- 交易机构号
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,top_branch_no -- 总行机构号
            ,all_credit_exp -- 已批准使用授信敞口
            ,batch_no -- 批次号
            ,cert_id -- 证件ID
            ,cert_type -- 证件类型1001	组织机构代码1002	中征码1003	机构信用代码2001	工商注册号2002	机关和事业单位登记号2003	社会团体登记号2004	民办非企业单位登记号2005	基金会登记号2006	宗教活动场所登记号2007	统一社会信用代码2008	商事与非商事登记证号2099	其他
            ,freeze_total_sum -- 客户冻结额度
            ,is_internal_settle -- 是否内部结算
            ,total_ck_sum -- 客户已使用敞口
            ,total_sum -- 客户总额度
            ,total_use_credit_exp -- 根词放款后累计使用敞口
            ,trans_amount -- 信贷有效金额
            ,used_total_ck_sum -- 客户已使用敞口
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,e_contract_no -- 电子合同号
            ,e_img_no -- 电子合同影响流水号
            ,i9_type -- 
            ,add_last_date -- 后补截止日期
            ,applock -- 锁状态：00-未加锁 01-加锁
            ,contract_date -- 信贷协议到期日
            ,credit_aggreement -- 额度合同号
            ,discount_flag -- 票交所贴现登记状态0-否 1-是
            ,ebank_seria_no -- 交易门户推送的在线进件的唯一标识
            ,flag -- 是否在线贴现标志0-否 1-是
            ,internal_account -- 内部结算户
            ,is_related -- 是否关联方查询 y-是我行关联方 n-未在我行关联方信息库中找出完全匹配信息 p-关联方是自然人，须同时输入姓名和证件号进行查询 m-通过输入信息查询出多个关联方,请输入更详细的信息进行查询 l-名称非常接近，请做进一步核实
            ,is_zhuanrang -- 是否转让标志
            ,report_url -- 征信报告url
            ,main_assure_type -- 主要担保方式
            ,sum_use_contract -- 合同已使用金额
            ,sum_contract -- 合同总额金额
            ,used_total_sum -- 合同已用总额
            ,file_name -- 走文件方式文件名
            ,credit_protocol_no -- 信贷合同号
            ,central_bankflg -- 转贴现或再贴现0-贴现 1-转贴现 2-再贴现
            ,calc_status -- 
            ,authstatus -- 
            ,bussiness_type -- 业务细类
            ,postpone_type -- 利息计算顺延方式
            ,acct_status -- 
            ,send_file_status -- 
            ,reserve4 -- 
            ,business_belong_branchno -- 业务所属分行
            ,link_rate -- 联动利率
            ,risk_scale -- 
            ,fnlrvwtm -- 
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
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 业务机构号
    ,nvl(n.acct_branch_no, o.acct_branch_no) as acct_branch_no -- 账务机构号
    ,nvl(n.store_branch_no, o.store_branch_no) as store_branch_no -- 库存机构号
    ,nvl(n.manager_no, o.manager_no) as manager_no -- 客户经理编号
    ,nvl(n.department_no, o.department_no) as department_no -- 所属部门编号
    ,nvl(n.product_no, o.product_no) as product_no -- 产品类型编码
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据属性： 1 纸票 2 电票
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： 1 银票 2 商票
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 交易客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 交易客户名称
    ,nvl(n.cust_account, o.cust_account) as cust_account -- 交易帐号
    ,nvl(n.cust_bank_no, o.cust_bank_no) as cust_bank_no -- 贴出人开户行行号
    ,nvl(n.cust_bank_name, o.cust_bank_name) as cust_bank_name -- 贴出人开户行名称
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 贴现申请日
    ,nvl(n.rate_type, o.rate_type) as rate_type -- 利率期限单位：1 年息% 2 月息‰ 3 日息(万分率)
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
    ,nvl(n.rpd_mk, o.rpd_mk) as rpd_mk -- （转）贴现种类： RM00 买断 RM01 回购
    ,nvl(n.sttlm_mk, o.sttlm_mk) as sttlm_mk -- 清算方式： SM00 线上清算 SM01 线下清算
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
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态：00 无效01 未提交记账02 记账中03 记账完成04 记账失败05 记账异常06 已抹账10 计息复核通过 11 计息复核不通过  07信贷出账中 08 信贷出账成功 09信贷出账失败 12信贷已抹账
    ,nvl(n.sell_contract_id, o.sell_contract_id) as sell_contract_id -- 卖出协议ID
    ,nvl(n.task_type, o.task_type) as task_type -- 任务类型
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备注1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备注2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备注3
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 贴现类型： 020 直贴 021 回购式贴现 022 代理直贴
    ,nvl(n.end_smt_flag, o.end_smt_flag) as end_smt_flag -- 是否转入： 0 否 1 是
    ,nvl(n.trans_branch_no, o.trans_branch_no) as trans_branch_no -- 交易机构号
    ,nvl(n.credit_check_status, o.credit_check_status) as credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.all_credit_exp, o.all_credit_exp) as all_credit_exp -- 已批准使用授信敞口
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.cert_id, o.cert_id) as cert_id -- 证件ID
    ,nvl(n.cert_type, o.cert_type) as cert_type -- 证件类型1001	组织机构代码1002	中征码1003	机构信用代码2001	工商注册号2002	机关和事业单位登记号2003	社会团体登记号2004	民办非企业单位登记号2005	基金会登记号2006	宗教活动场所登记号2007	统一社会信用代码2008	商事与非商事登记证号2099	其他
    ,nvl(n.freeze_total_sum, o.freeze_total_sum) as freeze_total_sum -- 客户冻结额度
    ,nvl(n.is_internal_settle, o.is_internal_settle) as is_internal_settle -- 是否内部结算
    ,nvl(n.total_ck_sum, o.total_ck_sum) as total_ck_sum -- 客户已使用敞口
    ,nvl(n.total_sum, o.total_sum) as total_sum -- 客户总额度
    ,nvl(n.total_use_credit_exp, o.total_use_credit_exp) as total_use_credit_exp -- 根词放款后累计使用敞口
    ,nvl(n.trans_amount, o.trans_amount) as trans_amount -- 信贷有效金额
    ,nvl(n.used_total_ck_sum, o.used_total_ck_sum) as used_total_ck_sum -- 客户已使用敞口
    ,nvl(n.unique_seq_num, o.unique_seq_num) as unique_seq_num -- 业务流水号(交易订单号)
    ,nvl(n.e_contract_no, o.e_contract_no) as e_contract_no -- 电子合同号
    ,nvl(n.e_img_no, o.e_img_no) as e_img_no -- 电子合同影响流水号
    ,nvl(n.i9_type, o.i9_type) as i9_type -- 
    ,nvl(n.add_last_date, o.add_last_date) as add_last_date -- 后补截止日期
    ,nvl(n.applock, o.applock) as applock -- 锁状态：00-未加锁 01-加锁
    ,nvl(n.contract_date, o.contract_date) as contract_date -- 信贷协议到期日
    ,nvl(n.credit_aggreement, o.credit_aggreement) as credit_aggreement -- 额度合同号
    ,nvl(n.discount_flag, o.discount_flag) as discount_flag -- 票交所贴现登记状态0-否 1-是
    ,nvl(n.ebank_seria_no, o.ebank_seria_no) as ebank_seria_no -- 交易门户推送的在线进件的唯一标识
    ,nvl(n.flag, o.flag) as flag -- 是否在线贴现标志0-否 1-是
    ,nvl(n.internal_account, o.internal_account) as internal_account -- 内部结算户
    ,nvl(n.is_related, o.is_related) as is_related -- 是否关联方查询 y-是我行关联方 n-未在我行关联方信息库中找出完全匹配信息 p-关联方是自然人，须同时输入姓名和证件号进行查询 m-通过输入信息查询出多个关联方,请输入更详细的信息进行查询 l-名称非常接近，请做进一步核实
    ,nvl(n.is_zhuanrang, o.is_zhuanrang) as is_zhuanrang -- 是否转让标志
    ,nvl(n.report_url, o.report_url) as report_url -- 征信报告url
    ,nvl(n.main_assure_type, o.main_assure_type) as main_assure_type -- 主要担保方式
    ,nvl(n.sum_use_contract, o.sum_use_contract) as sum_use_contract -- 合同已使用金额
    ,nvl(n.sum_contract, o.sum_contract) as sum_contract -- 合同总额金额
    ,nvl(n.used_total_sum, o.used_total_sum) as used_total_sum -- 合同已用总额
    ,nvl(n.file_name, o.file_name) as file_name -- 走文件方式文件名
    ,nvl(n.credit_protocol_no, o.credit_protocol_no) as credit_protocol_no -- 信贷合同号
    ,nvl(n.central_bankflg, o.central_bankflg) as central_bankflg -- 转贴现或再贴现0-贴现 1-转贴现 2-再贴现
    ,nvl(n.calc_status, o.calc_status) as calc_status -- 
    ,nvl(n.authstatus, o.authstatus) as authstatus -- 
    ,nvl(n.bussiness_type, o.bussiness_type) as bussiness_type -- 业务细类
    ,nvl(n.postpone_type, o.postpone_type) as postpone_type -- 利息计算顺延方式
    ,nvl(n.acct_status, o.acct_status) as acct_status -- 
    ,nvl(n.send_file_status, o.send_file_status) as send_file_status -- 
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 
    ,nvl(n.business_belong_branchno, o.business_belong_branchno) as business_belong_branchno -- 业务所属分行
    ,nvl(n.link_rate, o.link_rate) as link_rate -- 联动利率
    ,nvl(n.risk_scale, o.risk_scale) as risk_scale -- 
    ,nvl(n.fnlrvwtm, o.fnlrvwtm) as fnlrvwtm -- 
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
from (select * from ${iol_schema}.bdms_bms_buy_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_buy_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.sttlm_mk <> n.sttlm_mk
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
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.busi_type <> n.busi_type
        or o.end_smt_flag <> n.end_smt_flag
        or o.trans_branch_no <> n.trans_branch_no
        or o.credit_check_status <> n.credit_check_status
        or o.top_branch_no <> n.top_branch_no
        or o.all_credit_exp <> n.all_credit_exp
        or o.batch_no <> n.batch_no
        or o.cert_id <> n.cert_id
        or o.cert_type <> n.cert_type
        or o.freeze_total_sum <> n.freeze_total_sum
        or o.is_internal_settle <> n.is_internal_settle
        or o.total_ck_sum <> n.total_ck_sum
        or o.total_sum <> n.total_sum
        or o.total_use_credit_exp <> n.total_use_credit_exp
        or o.trans_amount <> n.trans_amount
        or o.used_total_ck_sum <> n.used_total_ck_sum
        or o.unique_seq_num <> n.unique_seq_num
        or o.e_contract_no <> n.e_contract_no
        or o.e_img_no <> n.e_img_no
        or o.i9_type <> n.i9_type
        or o.add_last_date <> n.add_last_date
        or o.applock <> n.applock
        or o.contract_date <> n.contract_date
        or o.credit_aggreement <> n.credit_aggreement
        or o.discount_flag <> n.discount_flag
        or o.ebank_seria_no <> n.ebank_seria_no
        or o.flag <> n.flag
        or o.internal_account <> n.internal_account
        or o.is_related <> n.is_related
        or o.is_zhuanrang <> n.is_zhuanrang
        or o.report_url <> n.report_url
        or o.main_assure_type <> n.main_assure_type
        or o.sum_use_contract <> n.sum_use_contract
        or o.sum_contract <> n.sum_contract
        or o.used_total_sum <> n.used_total_sum
        or o.file_name <> n.file_name
        or o.credit_protocol_no <> n.credit_protocol_no
        or o.central_bankflg <> n.central_bankflg
        or o.calc_status <> n.calc_status
        or o.authstatus <> n.authstatus
        or o.bussiness_type <> n.bussiness_type
        or o.postpone_type <> n.postpone_type
        or o.acct_status <> n.acct_status
        or o.send_file_status <> n.send_file_status
        or o.reserve4 <> n.reserve4
        or o.business_belong_branchno <> n.business_belong_branchno
        or o.link_rate <> n.link_rate
        or o.risk_scale <> n.risk_scale
        or o.fnlrvwtm <> n.fnlrvwtm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_buy_contract_cl(
            id -- ID
            ,protocol_no -- 贴现协议号
            ,credit_no -- 信贷合同号
            ,credit_flow_no -- 信贷流水号
            ,busi_branch_no -- 业务机构号
            ,acct_branch_no -- 账务机构号
            ,store_branch_no -- 库存机构号
            ,manager_no -- 客户经理编号
            ,department_no -- 所属部门编号
            ,product_no -- 产品类型编码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,cust_no -- 交易客户编号
            ,cust_name -- 交易客户名称
            ,cust_account -- 交易帐号
            ,cust_bank_no -- 贴出人开户行行号
            ,cust_bank_name -- 贴出人开户行名称
            ,apply_date -- 贴现申请日
            ,rate_type -- 利率期限单位：1 年息% 2 月息‰ 3 日息(万分率)
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
            ,rpd_mk -- （转）贴现种类： RM00 买断 RM01 回购
            ,sttlm_mk -- 清算方式： SM00 线上清算 SM01 线下清算
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
            ,contract_status -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
            ,account_status -- 记账状态：00 无效01 未提交记账02 记账中03 记账完成04 记账失败05 记账异常06 已抹账10 计息复核通过 11 计息复核不通过  07信贷出账中 08 信贷出账成功 09信贷出账失败 12信贷已抹账
            ,sell_contract_id -- 卖出协议ID
            ,task_type -- 任务类型
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,busi_type -- 贴现类型： 020 直贴 021 回购式贴现 022 代理直贴
            ,end_smt_flag -- 是否转入： 0 否 1 是
            ,trans_branch_no -- 交易机构号
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,top_branch_no -- 总行机构号
            ,all_credit_exp -- 已批准使用授信敞口
            ,batch_no -- 批次号
            ,cert_id -- 证件ID
            ,cert_type -- 证件类型1001	组织机构代码1002	中征码1003	机构信用代码2001	工商注册号2002	机关和事业单位登记号2003	社会团体登记号2004	民办非企业单位登记号2005	基金会登记号2006	宗教活动场所登记号2007	统一社会信用代码2008	商事与非商事登记证号2099	其他
            ,freeze_total_sum -- 客户冻结额度
            ,is_internal_settle -- 是否内部结算
            ,total_ck_sum -- 客户已使用敞口
            ,total_sum -- 客户总额度
            ,total_use_credit_exp -- 根词放款后累计使用敞口
            ,trans_amount -- 信贷有效金额
            ,used_total_ck_sum -- 客户已使用敞口
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,e_contract_no -- 电子合同号
            ,e_img_no -- 电子合同影响流水号
            ,i9_type -- 
            ,add_last_date -- 后补截止日期
            ,applock -- 锁状态：00-未加锁 01-加锁
            ,contract_date -- 信贷协议到期日
            ,credit_aggreement -- 额度合同号
            ,discount_flag -- 票交所贴现登记状态0-否 1-是
            ,ebank_seria_no -- 交易门户推送的在线进件的唯一标识
            ,flag -- 是否在线贴现标志0-否 1-是
            ,internal_account -- 内部结算户
            ,is_related -- 是否关联方查询 y-是我行关联方 n-未在我行关联方信息库中找出完全匹配信息 p-关联方是自然人，须同时输入姓名和证件号进行查询 m-通过输入信息查询出多个关联方,请输入更详细的信息进行查询 l-名称非常接近，请做进一步核实
            ,is_zhuanrang -- 是否转让标志
            ,report_url -- 征信报告url
            ,main_assure_type -- 主要担保方式
            ,sum_use_contract -- 合同已使用金额
            ,sum_contract -- 合同总额金额
            ,used_total_sum -- 合同已用总额
            ,file_name -- 走文件方式文件名
            ,credit_protocol_no -- 信贷合同号
            ,central_bankflg -- 转贴现或再贴现0-贴现 1-转贴现 2-再贴现
            ,calc_status -- 
            ,authstatus -- 
            ,bussiness_type -- 业务细类
            ,postpone_type -- 利息计算顺延方式
            ,acct_status -- 
            ,send_file_status -- 
            ,reserve4 -- 
            ,business_belong_branchno -- 业务所属分行
            ,link_rate -- 联动利率
            ,risk_scale -- 
            ,fnlrvwtm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_buy_contract_op(
            id -- ID
            ,protocol_no -- 贴现协议号
            ,credit_no -- 信贷合同号
            ,credit_flow_no -- 信贷流水号
            ,busi_branch_no -- 业务机构号
            ,acct_branch_no -- 账务机构号
            ,store_branch_no -- 库存机构号
            ,manager_no -- 客户经理编号
            ,department_no -- 所属部门编号
            ,product_no -- 产品类型编码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,cust_no -- 交易客户编号
            ,cust_name -- 交易客户名称
            ,cust_account -- 交易帐号
            ,cust_bank_no -- 贴出人开户行行号
            ,cust_bank_name -- 贴出人开户行名称
            ,apply_date -- 贴现申请日
            ,rate_type -- 利率期限单位：1 年息% 2 月息‰ 3 日息(万分率)
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
            ,rpd_mk -- （转）贴现种类： RM00 买断 RM01 回购
            ,sttlm_mk -- 清算方式： SM00 线上清算 SM01 线下清算
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
            ,contract_status -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
            ,account_status -- 记账状态：00 无效01 未提交记账02 记账中03 记账完成04 记账失败05 记账异常06 已抹账10 计息复核通过 11 计息复核不通过  07信贷出账中 08 信贷出账成功 09信贷出账失败 12信贷已抹账
            ,sell_contract_id -- 卖出协议ID
            ,task_type -- 任务类型
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,busi_type -- 贴现类型： 020 直贴 021 回购式贴现 022 代理直贴
            ,end_smt_flag -- 是否转入： 0 否 1 是
            ,trans_branch_no -- 交易机构号
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,top_branch_no -- 总行机构号
            ,all_credit_exp -- 已批准使用授信敞口
            ,batch_no -- 批次号
            ,cert_id -- 证件ID
            ,cert_type -- 证件类型1001	组织机构代码1002	中征码1003	机构信用代码2001	工商注册号2002	机关和事业单位登记号2003	社会团体登记号2004	民办非企业单位登记号2005	基金会登记号2006	宗教活动场所登记号2007	统一社会信用代码2008	商事与非商事登记证号2099	其他
            ,freeze_total_sum -- 客户冻结额度
            ,is_internal_settle -- 是否内部结算
            ,total_ck_sum -- 客户已使用敞口
            ,total_sum -- 客户总额度
            ,total_use_credit_exp -- 根词放款后累计使用敞口
            ,trans_amount -- 信贷有效金额
            ,used_total_ck_sum -- 客户已使用敞口
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,e_contract_no -- 电子合同号
            ,e_img_no -- 电子合同影响流水号
            ,i9_type -- 
            ,add_last_date -- 后补截止日期
            ,applock -- 锁状态：00-未加锁 01-加锁
            ,contract_date -- 信贷协议到期日
            ,credit_aggreement -- 额度合同号
            ,discount_flag -- 票交所贴现登记状态0-否 1-是
            ,ebank_seria_no -- 交易门户推送的在线进件的唯一标识
            ,flag -- 是否在线贴现标志0-否 1-是
            ,internal_account -- 内部结算户
            ,is_related -- 是否关联方查询 y-是我行关联方 n-未在我行关联方信息库中找出完全匹配信息 p-关联方是自然人，须同时输入姓名和证件号进行查询 m-通过输入信息查询出多个关联方,请输入更详细的信息进行查询 l-名称非常接近，请做进一步核实
            ,is_zhuanrang -- 是否转让标志
            ,report_url -- 征信报告url
            ,main_assure_type -- 主要担保方式
            ,sum_use_contract -- 合同已使用金额
            ,sum_contract -- 合同总额金额
            ,used_total_sum -- 合同已用总额
            ,file_name -- 走文件方式文件名
            ,credit_protocol_no -- 信贷合同号
            ,central_bankflg -- 转贴现或再贴现0-贴现 1-转贴现 2-再贴现
            ,calc_status -- 
            ,authstatus -- 
            ,bussiness_type -- 业务细类
            ,postpone_type -- 利息计算顺延方式
            ,acct_status -- 
            ,send_file_status -- 
            ,reserve4 -- 
            ,business_belong_branchno -- 业务所属分行
            ,link_rate -- 联动利率
            ,risk_scale -- 
            ,fnlrvwtm -- 
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
    ,o.busi_branch_no -- 业务机构号
    ,o.acct_branch_no -- 账务机构号
    ,o.store_branch_no -- 库存机构号
    ,o.manager_no -- 客户经理编号
    ,o.department_no -- 所属部门编号
    ,o.product_no -- 产品类型编码
    ,o.draft_attr -- 票据属性： 1 纸票 2 电票
    ,o.draft_type -- 票据类型： 1 银票 2 商票
    ,o.cust_no -- 交易客户编号
    ,o.cust_name -- 交易客户名称
    ,o.cust_account -- 交易帐号
    ,o.cust_bank_no -- 贴出人开户行行号
    ,o.cust_bank_name -- 贴出人开户行名称
    ,o.apply_date -- 贴现申请日
    ,o.rate_type -- 利率期限单位：1 年息% 2 月息‰ 3 日息(万分率)
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
    ,o.rpd_mk -- （转）贴现种类： RM00 买断 RM01 回购
    ,o.sttlm_mk -- 清算方式： SM00 线上清算 SM01 线下清算
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
    ,o.contract_status -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
    ,o.account_status -- 记账状态：00 无效01 未提交记账02 记账中03 记账完成04 记账失败05 记账异常06 已抹账10 计息复核通过 11 计息复核不通过  07信贷出账中 08 信贷出账成功 09信贷出账失败 12信贷已抹账
    ,o.sell_contract_id -- 卖出协议ID
    ,o.task_type -- 任务类型
    ,o.reserve1 -- 备注1
    ,o.reserve2 -- 备注2
    ,o.reserve3 -- 备注3
    ,o.busi_type -- 贴现类型： 020 直贴 021 回购式贴现 022 代理直贴
    ,o.end_smt_flag -- 是否转入： 0 否 1 是
    ,o.trans_branch_no -- 交易机构号
    ,o.credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
    ,o.top_branch_no -- 总行机构号
    ,o.all_credit_exp -- 已批准使用授信敞口
    ,o.batch_no -- 批次号
    ,o.cert_id -- 证件ID
    ,o.cert_type -- 证件类型1001	组织机构代码1002	中征码1003	机构信用代码2001	工商注册号2002	机关和事业单位登记号2003	社会团体登记号2004	民办非企业单位登记号2005	基金会登记号2006	宗教活动场所登记号2007	统一社会信用代码2008	商事与非商事登记证号2099	其他
    ,o.freeze_total_sum -- 客户冻结额度
    ,o.is_internal_settle -- 是否内部结算
    ,o.total_ck_sum -- 客户已使用敞口
    ,o.total_sum -- 客户总额度
    ,o.total_use_credit_exp -- 根词放款后累计使用敞口
    ,o.trans_amount -- 信贷有效金额
    ,o.used_total_ck_sum -- 客户已使用敞口
    ,o.unique_seq_num -- 业务流水号(交易订单号)
    ,o.e_contract_no -- 电子合同号
    ,o.e_img_no -- 电子合同影响流水号
    ,o.i9_type -- 
    ,o.add_last_date -- 后补截止日期
    ,o.applock -- 锁状态：00-未加锁 01-加锁
    ,o.contract_date -- 信贷协议到期日
    ,o.credit_aggreement -- 额度合同号
    ,o.discount_flag -- 票交所贴现登记状态0-否 1-是
    ,o.ebank_seria_no -- 交易门户推送的在线进件的唯一标识
    ,o.flag -- 是否在线贴现标志0-否 1-是
    ,o.internal_account -- 内部结算户
    ,o.is_related -- 是否关联方查询 y-是我行关联方 n-未在我行关联方信息库中找出完全匹配信息 p-关联方是自然人，须同时输入姓名和证件号进行查询 m-通过输入信息查询出多个关联方,请输入更详细的信息进行查询 l-名称非常接近，请做进一步核实
    ,o.is_zhuanrang -- 是否转让标志
    ,o.report_url -- 征信报告url
    ,o.main_assure_type -- 主要担保方式
    ,o.sum_use_contract -- 合同已使用金额
    ,o.sum_contract -- 合同总额金额
    ,o.used_total_sum -- 合同已用总额
    ,o.file_name -- 走文件方式文件名
    ,o.credit_protocol_no -- 信贷合同号
    ,o.central_bankflg -- 转贴现或再贴现0-贴现 1-转贴现 2-再贴现
    ,o.calc_status -- 
    ,o.authstatus -- 
    ,o.bussiness_type -- 业务细类
    ,o.postpone_type -- 利息计算顺延方式
    ,o.acct_status -- 
    ,o.send_file_status -- 
    ,o.reserve4 -- 
    ,o.business_belong_branchno -- 业务所属分行
    ,o.link_rate -- 联动利率
    ,o.risk_scale -- 
    ,o.fnlrvwtm -- 
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
from ${iol_schema}.bdms_bms_buy_contract_bk o
    left join ${iol_schema}.bdms_bms_buy_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_buy_contract_cl d
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
--truncate table ${iol_schema}.bdms_bms_buy_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_buy_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_buy_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_buy_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_buy_contract exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_buy_contract_cl;
alter table ${iol_schema}.bdms_bms_buy_contract exchange partition p_20991231 with table ${iol_schema}.bdms_bms_buy_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_buy_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_buy_contract_op purge;
drop table ${iol_schema}.bdms_bms_buy_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_buy_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_buy_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
