/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_buy_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_buy_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_buy_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_buy_contract(
    id varchar2(60) -- ID
    ,protocol_no varchar2(60) -- 贴现协议号
    ,credit_no varchar2(45) -- 信贷合同号
    ,credit_flow_no varchar2(60) -- 信贷流水号
    ,busi_branch_no varchar2(30) -- 业务机构号
    ,acct_branch_no varchar2(30) -- 账务机构号
    ,store_branch_no varchar2(30) -- 库存机构号
    ,manager_no varchar2(30) -- 客户经理编号
    ,department_no varchar2(30) -- 所属部门编号
    ,product_no varchar2(12) -- 产品类型编码
    ,draft_attr varchar2(2) -- 票据属性： 1 纸票 2 电票
    ,draft_type varchar2(2) -- 票据类型： 1 银票 2 商票
    ,cust_no varchar2(24) -- 交易客户编号
    ,cust_name varchar2(150) -- 交易客户名称
    ,cust_account varchar2(100) -- 交易帐号
    ,cust_bank_no varchar2(18) -- 贴出人开户行行号
    ,cust_bank_name varchar2(300) -- 贴出人开户行名称
    ,apply_date varchar2(12) -- 贴现申请日
    ,rate_type varchar2(2) -- 利率期限单位：1 年息% 2 月息‰ 3 日息(万分率)
    ,rate number(9,6) -- 利率
    ,pay_type varchar2(2) -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
    ,payer_scale number(9,6) -- 买方付息比例
    ,payer_name varchar2(300) -- 买方全称
    ,payer_account varchar2(150) -- 买方帐号
    ,agent_name varchar2(300) -- 代理人全称
    ,agent_account varchar2(150) -- 代理人帐号
    ,agent_bank_no varchar2(18) -- 代理人开户行行号
    ,agent_bank_name varchar2(300) -- 代理人开户行名称
    ,mend_flag varchar2(2) -- 是否资料后补： 0 否 1 是
    ,agent_flag varchar2(2) -- 是否代理贴现： 0 否 1 是
    ,discount_first_flag varchar2(2) -- 是否先贴后查： 0 否 1 是
    ,actually_industy varchar2(15) -- 实际投向行业
    ,rpd_mk varchar2(6) -- （转）贴现种类： RM00 买断 RM01 回购
    ,sttlm_mk varchar2(6) -- 清算方式： SM00 线上清算 SM01 线下清算
    ,inner_flag varchar2(2) -- 是否系统内买入： 0 否 1 是
    ,storage_flag varchar2(2) -- 是否代保管： 0 否 1 是
    ,repurchase_rate_type varchar2(2) -- 赎回利率类型
    ,repurchase_rate number(9,6) -- 赎回利率
    ,repurchase_begin_date varchar2(12) -- 赎回开放日
    ,repurchase_end_date varchar2(12) -- 赎回截止日
    ,payer_bank_no varchar2(18) -- 买方开户行行号
    ,payer_bank_name varchar2(300) -- 买方开户行名称
    ,operator_no varchar2(45) -- 业务发起人编号
    ,txn_date varchar2(12) -- 业务发起日期
    ,last_operator_no varchar2(45) -- 最后操作员编号
    ,last_txn_date timestamp -- 最后操作日期
    ,check_status varchar2(3) -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
    ,contract_status varchar2(3) -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
    ,account_status varchar2(3) -- 记账状态：00 无效01 未提交记账02 记账中03 记账完成04 记账失败05 记账异常06 已抹账10 计息复核通过 11 计息复核不通过  07信贷出账中 08 信贷出账成功 09信贷出账失败 12信贷已抹账
    ,sell_contract_id varchar2(60) -- 卖出协议ID
    ,task_type varchar2(3) -- 任务类型
    ,reserve1 varchar2(375) -- 备注1
    ,reserve2 varchar2(375) -- 备注2
    ,reserve3 varchar2(375) -- 备注3
    ,busi_type varchar2(6) -- 贴现类型： 020 直贴 021 回购式贴现 022 代理直贴
    ,end_smt_flag varchar2(6) -- 是否转入： 0 否 1 是
    ,trans_branch_no varchar2(30) -- 交易机构号
    ,credit_check_status varchar2(3) -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
    ,top_branch_no varchar2(30) -- 总行机构号
    ,all_credit_exp number(20,2) -- 已批准使用授信敞口
    ,batch_no varchar2(30) -- 批次号
    ,cert_id varchar2(75) -- 证件ID
    ,cert_type varchar2(15) -- 证件类型1001	组织机构代码1002	中征码1003	机构信用代码2001	工商注册号2002	机关和事业单位登记号2003	社会团体登记号2004	民办非企业单位登记号2005	基金会登记号2006	宗教活动场所登记号2007	统一社会信用代码2008	商事与非商事登记证号2099	其他
    ,freeze_total_sum number(20,2) -- 客户冻结额度
    ,is_internal_settle varchar2(2) -- 是否内部结算
    ,total_ck_sum number(20,2) -- 客户已使用敞口
    ,total_sum number(20,2) -- 客户总额度
    ,total_use_credit_exp number(20,2) -- 根词放款后累计使用敞口
    ,trans_amount number(20,2) -- 信贷有效金额
    ,used_total_ck_sum number(20,2) -- 客户已使用敞口
    ,unique_seq_num varchar2(50) -- 业务流水号(交易订单号)
    ,e_contract_no varchar2(30) -- 电子合同号
    ,e_img_no varchar2(60) -- 电子合同影响流水号
    ,i9_type varchar2(8) -- 
    ,add_last_date varchar2(12) -- 后补截止日期
    ,applock varchar2(3) -- 锁状态：00-未加锁 01-加锁
    ,contract_date varchar2(12) -- 信贷协议到期日
    ,credit_aggreement varchar2(48) -- 额度合同号
    ,discount_flag varchar2(3) -- 票交所贴现登记状态0-否 1-是
    ,ebank_seria_no varchar2(192) -- 交易门户推送的在线进件的唯一标识
    ,flag varchar2(3) -- 是否在线贴现标志0-否 1-是
    ,internal_account varchar2(48) -- 内部结算户
    ,is_related varchar2(3) -- 是否关联方查询 y-是我行关联方 n-未在我行关联方信息库中找出完全匹配信息 p-关联方是自然人，须同时输入姓名和证件号进行查询 m-通过输入信息查询出多个关联方,请输入更详细的信息进行查询 l-名称非常接近，请做进一步核实
    ,is_zhuanrang varchar2(3) -- 是否转让标志
    ,report_url varchar2(375) -- 征信报告url
    ,main_assure_type varchar2(30) -- 主要担保方式
    ,sum_use_contract number(18,2) -- 合同已使用金额
    ,sum_contract number(18,2) -- 合同总额金额
    ,used_total_sum number(18,2) -- 合同已用总额
    ,file_name varchar2(150) -- 走文件方式文件名
    ,credit_protocol_no varchar2(75) -- 信贷合同号
    ,central_bankflg varchar2(2) -- 转贴现或再贴现0-贴现 1-转贴现 2-再贴现
    ,calc_status varchar2(3) -- 
    ,authstatus varchar2(3) -- 
    ,bussiness_type varchar2(12) -- 业务细类
    ,postpone_type varchar2(15) -- 利息计算顺延方式
    ,acct_status varchar2(3) -- 
    ,send_file_status varchar2(3) -- 
    ,reserve4 varchar2(15) -- 
    ,business_belong_branchno varchar2(12) -- 业务所属分行
    ,link_rate number(18,6) -- 联动利率
    ,risk_scale number(16,2) -- 
    ,fnlrvwtm varchar2(30) -- 
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
grant select on ${iol_schema}.bdms_bms_buy_contract to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_buy_contract to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_buy_contract to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_buy_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_buy_contract is '买入批次表';
comment on column ${iol_schema}.bdms_bms_buy_contract.id is 'ID';
comment on column ${iol_schema}.bdms_bms_buy_contract.protocol_no is '贴现协议号';
comment on column ${iol_schema}.bdms_bms_buy_contract.credit_no is '信贷合同号';
comment on column ${iol_schema}.bdms_bms_buy_contract.credit_flow_no is '信贷流水号';
comment on column ${iol_schema}.bdms_bms_buy_contract.busi_branch_no is '业务机构号';
comment on column ${iol_schema}.bdms_bms_buy_contract.acct_branch_no is '账务机构号';
comment on column ${iol_schema}.bdms_bms_buy_contract.store_branch_no is '库存机构号';
comment on column ${iol_schema}.bdms_bms_buy_contract.manager_no is '客户经理编号';
comment on column ${iol_schema}.bdms_bms_buy_contract.department_no is '所属部门编号';
comment on column ${iol_schema}.bdms_bms_buy_contract.product_no is '产品类型编码';
comment on column ${iol_schema}.bdms_bms_buy_contract.draft_attr is '票据属性： 1 纸票 2 电票';
comment on column ${iol_schema}.bdms_bms_buy_contract.draft_type is '票据类型： 1 银票 2 商票';
comment on column ${iol_schema}.bdms_bms_buy_contract.cust_no is '交易客户编号';
comment on column ${iol_schema}.bdms_bms_buy_contract.cust_name is '交易客户名称';
comment on column ${iol_schema}.bdms_bms_buy_contract.cust_account is '交易帐号';
comment on column ${iol_schema}.bdms_bms_buy_contract.cust_bank_no is '贴出人开户行行号';
comment on column ${iol_schema}.bdms_bms_buy_contract.cust_bank_name is '贴出人开户行名称';
comment on column ${iol_schema}.bdms_bms_buy_contract.apply_date is '贴现申请日';
comment on column ${iol_schema}.bdms_bms_buy_contract.rate_type is '利率期限单位：1 年息% 2 月息‰ 3 日息(万分率)';
comment on column ${iol_schema}.bdms_bms_buy_contract.rate is '利率';
comment on column ${iol_schema}.bdms_bms_buy_contract.pay_type is '付息方式： 1 买方付息 2 卖方付息 3 协议付息';
comment on column ${iol_schema}.bdms_bms_buy_contract.payer_scale is '买方付息比例';
comment on column ${iol_schema}.bdms_bms_buy_contract.payer_name is '买方全称';
comment on column ${iol_schema}.bdms_bms_buy_contract.payer_account is '买方帐号';
comment on column ${iol_schema}.bdms_bms_buy_contract.agent_name is '代理人全称';
comment on column ${iol_schema}.bdms_bms_buy_contract.agent_account is '代理人帐号';
comment on column ${iol_schema}.bdms_bms_buy_contract.agent_bank_no is '代理人开户行行号';
comment on column ${iol_schema}.bdms_bms_buy_contract.agent_bank_name is '代理人开户行名称';
comment on column ${iol_schema}.bdms_bms_buy_contract.mend_flag is '是否资料后补： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_buy_contract.agent_flag is '是否代理贴现： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_buy_contract.discount_first_flag is '是否先贴后查： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_buy_contract.actually_industy is '实际投向行业';
comment on column ${iol_schema}.bdms_bms_buy_contract.rpd_mk is '（转）贴现种类： RM00 买断 RM01 回购';
comment on column ${iol_schema}.bdms_bms_buy_contract.sttlm_mk is '清算方式： SM00 线上清算 SM01 线下清算';
comment on column ${iol_schema}.bdms_bms_buy_contract.inner_flag is '是否系统内买入： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_buy_contract.storage_flag is '是否代保管： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_buy_contract.repurchase_rate_type is '赎回利率类型';
comment on column ${iol_schema}.bdms_bms_buy_contract.repurchase_rate is '赎回利率';
comment on column ${iol_schema}.bdms_bms_buy_contract.repurchase_begin_date is '赎回开放日';
comment on column ${iol_schema}.bdms_bms_buy_contract.repurchase_end_date is '赎回截止日';
comment on column ${iol_schema}.bdms_bms_buy_contract.payer_bank_no is '买方开户行行号';
comment on column ${iol_schema}.bdms_bms_buy_contract.payer_bank_name is '买方开户行名称';
comment on column ${iol_schema}.bdms_bms_buy_contract.operator_no is '业务发起人编号';
comment on column ${iol_schema}.bdms_bms_buy_contract.txn_date is '业务发起日期';
comment on column ${iol_schema}.bdms_bms_buy_contract.last_operator_no is '最后操作员编号';
comment on column ${iol_schema}.bdms_bms_buy_contract.last_txn_date is '最后操作日期';
comment on column ${iol_schema}.bdms_bms_buy_contract.check_status is '业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过';
comment on column ${iol_schema}.bdms_bms_buy_contract.contract_status is '批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回';
comment on column ${iol_schema}.bdms_bms_buy_contract.account_status is '记账状态：00 无效01 未提交记账02 记账中03 记账完成04 记账失败05 记账异常06 已抹账10 计息复核通过 11 计息复核不通过  07信贷出账中 08 信贷出账成功 09信贷出账失败 12信贷已抹账';
comment on column ${iol_schema}.bdms_bms_buy_contract.sell_contract_id is '卖出协议ID';
comment on column ${iol_schema}.bdms_bms_buy_contract.task_type is '任务类型';
comment on column ${iol_schema}.bdms_bms_buy_contract.reserve1 is '备注1';
comment on column ${iol_schema}.bdms_bms_buy_contract.reserve2 is '备注2';
comment on column ${iol_schema}.bdms_bms_buy_contract.reserve3 is '备注3';
comment on column ${iol_schema}.bdms_bms_buy_contract.busi_type is '贴现类型： 020 直贴 021 回购式贴现 022 代理直贴';
comment on column ${iol_schema}.bdms_bms_buy_contract.end_smt_flag is '是否转入： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_buy_contract.trans_branch_no is '交易机构号';
comment on column ${iol_schema}.bdms_bms_buy_contract.credit_check_status is '授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过';
comment on column ${iol_schema}.bdms_bms_buy_contract.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_bms_buy_contract.all_credit_exp is '已批准使用授信敞口';
comment on column ${iol_schema}.bdms_bms_buy_contract.batch_no is '批次号';
comment on column ${iol_schema}.bdms_bms_buy_contract.cert_id is '证件ID';
comment on column ${iol_schema}.bdms_bms_buy_contract.cert_type is '证件类型1001	组织机构代码1002	中征码1003	机构信用代码2001	工商注册号2002	机关和事业单位登记号2003	社会团体登记号2004	民办非企业单位登记号2005	基金会登记号2006	宗教活动场所登记号2007	统一社会信用代码2008	商事与非商事登记证号2099	其他';
comment on column ${iol_schema}.bdms_bms_buy_contract.freeze_total_sum is '客户冻结额度';
comment on column ${iol_schema}.bdms_bms_buy_contract.is_internal_settle is '是否内部结算';
comment on column ${iol_schema}.bdms_bms_buy_contract.total_ck_sum is '客户已使用敞口';
comment on column ${iol_schema}.bdms_bms_buy_contract.total_sum is '客户总额度';
comment on column ${iol_schema}.bdms_bms_buy_contract.total_use_credit_exp is '根词放款后累计使用敞口';
comment on column ${iol_schema}.bdms_bms_buy_contract.trans_amount is '信贷有效金额';
comment on column ${iol_schema}.bdms_bms_buy_contract.used_total_ck_sum is '客户已使用敞口';
comment on column ${iol_schema}.bdms_bms_buy_contract.unique_seq_num is '业务流水号(交易订单号)';
comment on column ${iol_schema}.bdms_bms_buy_contract.e_contract_no is '电子合同号';
comment on column ${iol_schema}.bdms_bms_buy_contract.e_img_no is '电子合同影响流水号';
comment on column ${iol_schema}.bdms_bms_buy_contract.i9_type is '';
comment on column ${iol_schema}.bdms_bms_buy_contract.add_last_date is '后补截止日期';
comment on column ${iol_schema}.bdms_bms_buy_contract.applock is '锁状态：00-未加锁 01-加锁';
comment on column ${iol_schema}.bdms_bms_buy_contract.contract_date is '信贷协议到期日';
comment on column ${iol_schema}.bdms_bms_buy_contract.credit_aggreement is '额度合同号';
comment on column ${iol_schema}.bdms_bms_buy_contract.discount_flag is '票交所贴现登记状态0-否 1-是';
comment on column ${iol_schema}.bdms_bms_buy_contract.ebank_seria_no is '交易门户推送的在线进件的唯一标识';
comment on column ${iol_schema}.bdms_bms_buy_contract.flag is '是否在线贴现标志0-否 1-是';
comment on column ${iol_schema}.bdms_bms_buy_contract.internal_account is '内部结算户';
comment on column ${iol_schema}.bdms_bms_buy_contract.is_related is '是否关联方查询 y-是我行关联方 n-未在我行关联方信息库中找出完全匹配信息 p-关联方是自然人，须同时输入姓名和证件号进行查询 m-通过输入信息查询出多个关联方,请输入更详细的信息进行查询 l-名称非常接近，请做进一步核实';
comment on column ${iol_schema}.bdms_bms_buy_contract.is_zhuanrang is '是否转让标志';
comment on column ${iol_schema}.bdms_bms_buy_contract.report_url is '征信报告url';
comment on column ${iol_schema}.bdms_bms_buy_contract.main_assure_type is '主要担保方式';
comment on column ${iol_schema}.bdms_bms_buy_contract.sum_use_contract is '合同已使用金额';
comment on column ${iol_schema}.bdms_bms_buy_contract.sum_contract is '合同总额金额';
comment on column ${iol_schema}.bdms_bms_buy_contract.used_total_sum is '合同已用总额';
comment on column ${iol_schema}.bdms_bms_buy_contract.file_name is '走文件方式文件名';
comment on column ${iol_schema}.bdms_bms_buy_contract.credit_protocol_no is '信贷合同号';
comment on column ${iol_schema}.bdms_bms_buy_contract.central_bankflg is '转贴现或再贴现0-贴现 1-转贴现 2-再贴现';
comment on column ${iol_schema}.bdms_bms_buy_contract.calc_status is '';
comment on column ${iol_schema}.bdms_bms_buy_contract.authstatus is '';
comment on column ${iol_schema}.bdms_bms_buy_contract.bussiness_type is '业务细类';
comment on column ${iol_schema}.bdms_bms_buy_contract.postpone_type is '利息计算顺延方式';
comment on column ${iol_schema}.bdms_bms_buy_contract.acct_status is '';
comment on column ${iol_schema}.bdms_bms_buy_contract.send_file_status is '';
comment on column ${iol_schema}.bdms_bms_buy_contract.reserve4 is '';
comment on column ${iol_schema}.bdms_bms_buy_contract.business_belong_branchno is '业务所属分行';
comment on column ${iol_schema}.bdms_bms_buy_contract.link_rate is '联动利率';
comment on column ${iol_schema}.bdms_bms_buy_contract.risk_scale is '';
comment on column ${iol_schema}.bdms_bms_buy_contract.fnlrvwtm is '';
comment on column ${iol_schema}.bdms_bms_buy_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_buy_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_buy_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_buy_contract.etl_timestamp is 'ETL处理时间戳';
