/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_rcrs_pvp_loan_app
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.rcrs_pvp_loan_app drop partition p_${last_date};
alter table ${idl_schema}.rcrs_pvp_loan_app drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.rcrs_pvp_loan_app add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.rcrs_pvp_loan_app (
    etl_dt  -- 数据日期
    ,serno  -- 业务流水号
    ,prd_pk  -- 产品主键
    ,biz_type  -- 产品编号
    ,prd_name  -- 产品名称
    ,prd_type  -- 产品类型
    ,app_form  -- 表单类型
    ,cont_no  -- 合同编号
    ,bill_no  -- 借据编号
    ,funds_src  -- 资金来源
    ,account_class  -- 科目号
    ,credit_class  -- 信用科目号
    ,assure_class  -- 保证科目号
    ,pledge_class  -- 抵押科目号
    ,impawn_class  -- 质押科目号
    ,cus_id  -- 客户号
    ,cus_name  -- 客户名称
    ,cur_type  -- 币种
    ,con_amount  -- 合同金额
    ,avail_amt  -- 合同可用余额
    ,loan_amount  -- 出账金额
    ,loan_start_date  -- 贷款起始日
    ,loan_end_date  -- 贷款终止日
    ,ruling_ir  -- 基准利率(月)
    ,floating_rate  -- 利率浮动值
    ,reality_ir_y  -- 执行利率(月)
    ,overdue_rate  -- 逾期利率浮动比例
    ,overdue_ir  -- 逾期加罚月利率
    ,default_rate  -- 挤占挪用利率浮动比例
    ,default_ir  -- 违约月利率
    ,ci_rate  -- 复利加罚率
    ,ci_ir  -- 复利月利率
    ,assure_means_main  -- 主担保方式
    ,assure_means2  -- 担保方式2
    ,assure_means3  -- 担保方式3
    ,enter_account  -- 入账账号
    ,enter_account_name  -- 入账账户名称
    ,repayment_account  -- 还款账号
    ,repayment_acc_name  -- 还款账户名称
    ,mortgage_flg  -- 按揭标识
    ,repayment_mode  -- 还款方式
    ,interest_acc_mode  -- 结息周期
    ,ir_adjust_mode  -- 利率调整方式
    ,delay_deduct_type  -- 扣款方式
    ,loan_direction  -- 贷款投向
    ,direction_name  -- 投向名称
    ,loan_form  -- 贷款形式
    ,loan_nature  -- 贷款性质
    ,loan_kind_ca  -- 贷款种类(征信)
    ,biz_type_sub  -- 业务品种
    ,loan_use_type  -- 借款用途类型
    ,loan_type_ext  -- 关联交易类型
    ,delay_days  -- 宽限天数
    ,discont_ind  -- 是否贴息
    ,discont_id  -- 贴息方编号
    ,discont_type  -- 贴息方式
    ,discont_acc  -- 贴息账号
    ,discont_acc_name  -- 贴息账户名称
    ,discount_rate  -- 贴息比率
    ,discount_amount  -- 贴息金额
    ,discont_acc2  -- 贴息账号2
    ,discont_acc_name2  -- 贴息账户名称2
    ,discount_rate2  -- 贴息比率2
    ,discount_amount2  -- 贴息金额2
    ,discont_acc3  -- 贴息账号3
    ,discont_acc_name3  -- 贴息账户名称3
    ,discount_rate3  -- 贴息比率3
    ,discount_amount3  -- 贴息金额3
    ,ass_acc  -- 担保方扣款账号(消费贷款)
    ,ass_acc_name  -- 担保方扣款账号户名(消费贷款)
    ,ass_sec_acc  -- 保证金账号
    ,ass_sec_acc_name  -- 保证金账号户名
    ,limit_ind  -- 授信额度使用标志
    ,pay_way  -- 支付方式
    ,benifit_acc  -- 受益人账号
    ,benifit_amount  -- 受益金额
    ,benifit_bank_id  -- 受益人开户行行号
    ,benifit_bank  -- 受益人开户行行名
    ,benifit_name  -- 受益人名称
    ,transfer_amount  -- 转账金额
    ,cash_amount  -- 自主支付金额
    ,proc_fee_amount  -- 手续费金额
    ,transfer_dec  -- 转账用途
    ,chargeoff_ind  -- 授信额度使用标志
    ,chargeoff_dec  -- 出账落实条件说明
    ,dd_workflow_id  -- 放款流程
    ,approve_status  -- 审批状态
    ,input_id  -- 登记(受理人)
    ,examinant_id  -- 审查人
    ,investigator_id  -- 调查人
    ,cus_manager  -- 客户经理
    ,apply_date  -- 申请日期
    ,input_date  -- 受理日期
    ,input_br_id  -- 受理机构
    ,investigator_br_id  -- 调查机构
    ,fina_br_id  -- 账务机构
    ,main_br_id  -- 主管机构
    ,own_system  -- 所属系统
    ,chargeoff_status  -- 出账状态
    ,src_account  -- 来源账号
    ,src_account_name  -- 来源账户名称
    ,biz_type_detail  -- 业务品种名称
    ,ir_exe_type  -- 利率变更生效方式
    ,int_rate_type  -- 利率类型
    ,int_rate_inc_opt  -- 利率增量选项
    ,int_rate_inc  -- 利率增量
    ,fixed_rate  -- 固定利率
    ,prd_userdf_name  -- 产品自定义名称
    ,prd_userdf_type  -- 产品自定义类别
    ,return_date  -- 还款日
    ,chargeoff_manage  -- 出帐负责人
    ,consign_fund_protocol_no  -- 资金协议编号
    ,ispaf  -- 是否住房公积金贷款
    ,distribution_day  -- 分配日
    ,money_origin_id  -- 分配方式
    ,overdue_type  -- 逾期利率浮动类型
    ,default_type  -- 挤占利率浮动类型
    ,ass_sec_acc_bal  -- 保证金账户余额
    ,ass_sec_amt  -- 本笔保证金金额
    ,ass_sec_dep_date  -- 本笔保证金存入日期
    ,repayment_account1  -- 还款账号1
    ,repayment_acc_name1  -- 还款账号1
    ,cus_area  -- 客户所属片区
    ,loan_card_ind  -- 使用农户贷款证标志
    ,agriculture_type  -- 涉农情况
    ,agriculture_use  -- 涉农用途
    ,minor_entrp_range  -- 小企业统计口径(银监)
    ,government_ind  -- 涉政类型
    ,government_org_attribute  -- 涉政机构属性
    ,government_platform  -- 是否为涉政平台
    ,ass_sec_ind  -- 是否需存入保证金
    ,guarantora_grp_ind  -- 联保贷款标志
    ,loan_fund_whither  -- 贷款款项去向
    ,interest_date  -- 结息日
    ,cn_cont_no  -- 主合同号
    ,syndicated_proxy_id  -- 代理社机构码
    ,sec_money_ac  -- 基础保证金账号
    ,sec_money_ac_name  -- 基础保证金账户名称
    ,sec_money_init  -- 基础保证金起存金额
    ,sec_money_rate  -- 业务保证金比例
    ,freeze_no  -- 冻结编号
    ,freeze_name  -- 冻结账户名称
    ,freeze_amt  -- 冻结止付金额
    ,farm_card_type  -- 贷款发放形式
    ,check_finger  -- 指纹检查状态
    ,loan_term  -- 贷款期限
    ,term_time_type  -- 贷款时间类型
    ,due_day  -- 还款日期
    ,pay_distance  -- 还款间隔
    ,old_bill_no  -- 原借据编号
    ,is_risk  -- 是否低风险（1-是，2-否）
    ,invst_concl  -- 调查人意见
    ,security_money_ind_zy  -- 是否录入保证金（专业担保公司）
    ,security_money_ac_no_zy  -- 保证金账号（专业担保公司）
    ,security_money_child_acc_no_zy  -- 保证金子账号（专业担保公司）
    ,security_money_amt_zy  -- 业务保证金金额（专业担保公司）
    ,security_money_ac_name_zy  -- 保证金账户名（专业担保公司）
    ,adv_rpay_flg  -- 是否允许提前还款
    ,made_rpay_plan  -- 是否定制还款计划
    ,enter_account_type  -- 入账账户支付工具类型
    ,repayment_account_type  -- 还款账户支付工具类型
    ,businum  -- 委托支付编号
    ,trade_serno  -- 贷款开户贷款产品流水号
    ,repayment_date_confirm  -- 还款日确定
    ,auth_review  -- 放款审核岗审批意见
    ,is_cl  -- 
    ,is_loan_anytime  -- 合同是否随借随还标识
    ,is_balloon  -- 是否选择气球贷
    ,last_term_amount  -- 最后一期保留金额
    ,last_term_percent  -- 最后一期还本金额比例
    ,tax_amount  -- 印花税
    ,tax_account  -- 印花税扣税账户
    ,tax_account_name  -- 印花税扣税账户名称
    ,tax_account_type  -- 印花税扣税账户支付工具类型
    ,is_record_tax  -- 是否录入印花税
    ,rate_type  -- 利率类型 1 基准利率 2 lpr
    ,loan_rel_date  -- 贷款实际发放日   
    ,start_dt  -- 开始时间
    ,end_dt  -- 结束时间
    ,id_mark  -- 增删标志
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.serno,chr(13),''),chr(10),'')  -- 业务流水号
    ,replace(replace(t1.prd_pk,chr(13),''),chr(10),'')  -- 产品主键
    ,replace(replace(t1.biz_type,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.prd_name,chr(13),''),chr(10),'')  -- 产品名称
    ,replace(replace(t1.prd_type,chr(13),''),chr(10),'')  -- 产品类型
    ,replace(replace(t1.app_form,chr(13),''),chr(10),'')  -- 表单类型
    ,replace(replace(t1.cont_no,chr(13),''),chr(10),'')  -- 合同编号
    ,replace(replace(t1.bill_no,chr(13),''),chr(10),'')  -- 借据编号
    ,replace(replace(t1.funds_src,chr(13),''),chr(10),'')  -- 资金来源
    ,replace(replace(t1.account_class,chr(13),''),chr(10),'')  -- 科目号
    ,replace(replace(t1.credit_class,chr(13),''),chr(10),'')  -- 信用科目号
    ,replace(replace(t1.assure_class,chr(13),''),chr(10),'')  -- 保证科目号
    ,replace(replace(t1.pledge_class,chr(13),''),chr(10),'')  -- 抵押科目号
    ,replace(replace(t1.impawn_class,chr(13),''),chr(10),'')  -- 质押科目号
    ,replace(replace(t1.cus_id,chr(13),''),chr(10),'')  -- 客户号
    ,replace(replace(t1.cus_name,chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(t1.cur_type,chr(13),''),chr(10),'')  -- 币种
    ,t1.con_amount  -- 合同金额
    ,t1.avail_amt  -- 合同可用余额
    ,t1.loan_amount  -- 出账金额
    ,replace(replace(t1.loan_start_date,chr(13),''),chr(10),'')  -- 贷款起始日
    ,replace(replace(t1.loan_end_date,chr(13),''),chr(10),'')  -- 贷款终止日
    ,t1.ruling_ir  -- 基准利率(月)
    ,t1.floating_rate  -- 利率浮动值
    ,t1.reality_ir_y  -- 执行利率(月)
    ,t1.overdue_rate  -- 逾期利率浮动比例
    ,t1.overdue_ir  -- 逾期加罚月利率
    ,t1.default_rate  -- 挤占挪用利率浮动比例
    ,t1.default_ir  -- 违约月利率
    ,t1.ci_rate  -- 复利加罚率
    ,t1.ci_ir  -- 复利月利率
    ,replace(replace(t1.assure_means_main,chr(13),''),chr(10),'')  -- 主担保方式
    ,replace(replace(t1.assure_means2,chr(13),''),chr(10),'')  -- 担保方式2
    ,replace(replace(t1.assure_means3,chr(13),''),chr(10),'')  -- 担保方式3
    ,replace(replace(t1.enter_account,chr(13),''),chr(10),'')  -- 入账账号
    ,replace(replace(t1.enter_account_name,chr(13),''),chr(10),'')  -- 入账账户名称
    ,replace(replace(t1.repayment_account,chr(13),''),chr(10),'')  -- 还款账号
    ,replace(replace(t1.repayment_acc_name,chr(13),''),chr(10),'')  -- 还款账户名称
    ,replace(replace(t1.mortgage_flg,chr(13),''),chr(10),'')  -- 按揭标识
    ,replace(replace(t1.repayment_mode,chr(13),''),chr(10),'')  -- 还款方式
    ,replace(replace(t1.interest_acc_mode,chr(13),''),chr(10),'')  -- 结息周期
    ,replace(replace(t1.ir_adjust_mode,chr(13),''),chr(10),'')  -- 利率调整方式
    ,replace(replace(t1.delay_deduct_type,chr(13),''),chr(10),'')  -- 扣款方式
    ,replace(replace(t1.loan_direction,chr(13),''),chr(10),'')  -- 贷款投向
    ,replace(replace(t1.direction_name,chr(13),''),chr(10),'')  -- 投向名称
    ,replace(replace(t1.loan_form,chr(13),''),chr(10),'')  -- 贷款形式
    ,replace(replace(t1.loan_nature,chr(13),''),chr(10),'')  -- 贷款性质
    ,replace(replace(t1.loan_kind_ca,chr(13),''),chr(10),'')  -- 贷款种类(征信)
    ,replace(replace(t1.biz_type_sub,chr(13),''),chr(10),'')  -- 业务品种
    ,replace(replace(t1.loan_use_type,chr(13),''),chr(10),'')  -- 借款用途类型
    ,replace(replace(t1.loan_type_ext,chr(13),''),chr(10),'')  -- 关联交易类型
    ,t1.delay_days  -- 宽限天数
    ,replace(replace(t1.discont_ind,chr(13),''),chr(10),'')  -- 是否贴息
    ,replace(replace(t1.discont_id,chr(13),''),chr(10),'')  -- 贴息方编号
    ,replace(replace(t1.discont_type,chr(13),''),chr(10),'')  -- 贴息方式
    ,replace(replace(t1.discont_acc,chr(13),''),chr(10),'')  -- 贴息账号
    ,replace(replace(t1.discont_acc_name,chr(13),''),chr(10),'')  -- 贴息账户名称
    ,t1.discount_rate  -- 贴息比率
    ,t1.discount_amount  -- 贴息金额
    ,replace(replace(t1.discont_acc2,chr(13),''),chr(10),'')  -- 贴息账号2
    ,replace(replace(t1.discont_acc_name2,chr(13),''),chr(10),'')  -- 贴息账户名称2
    ,t1.discount_rate2  -- 贴息比率2
    ,t1.discount_amount2  -- 贴息金额2
    ,replace(replace(t1.discont_acc3,chr(13),''),chr(10),'')  -- 贴息账号3
    ,replace(replace(t1.discont_acc_name3,chr(13),''),chr(10),'')  -- 贴息账户名称3
    ,t1.discount_rate3  -- 贴息比率3
    ,t1.discount_amount3  -- 贴息金额3
    ,replace(replace(t1.ass_acc,chr(13),''),chr(10),'')  -- 担保方扣款账号(消费贷款)
    ,replace(replace(t1.ass_acc_name,chr(13),''),chr(10),'')  -- 担保方扣款账号户名(消费贷款)
    ,replace(replace(t1.ass_sec_acc,chr(13),''),chr(10),'')  -- 保证金账号
    ,replace(replace(t1.ass_sec_acc_name,chr(13),''),chr(10),'')  -- 保证金账号户名
    ,replace(replace(t1.limit_ind,chr(13),''),chr(10),'')  -- 授信额度使用标志
    ,replace(replace(t1.pay_way,chr(13),''),chr(10),'')  -- 支付方式
    ,replace(replace(t1.benifit_acc,chr(13),''),chr(10),'')  -- 受益人账号
    ,t1.benifit_amount  -- 受益金额
    ,replace(replace(t1.benifit_bank_id,chr(13),''),chr(10),'')  -- 受益人开户行行号
    ,replace(replace(t1.benifit_bank,chr(13),''),chr(10),'')  -- 受益人开户行行名
    ,replace(replace(t1.benifit_name,chr(13),''),chr(10),'')  -- 受益人名称
    ,t1.transfer_amount  -- 转账金额
    ,t1.cash_amount  -- 自主支付金额
    ,t1.proc_fee_amount  -- 手续费金额
    ,replace(replace(t1.transfer_dec,chr(13),''),chr(10),'')  -- 转账用途
    ,replace(replace(t1.chargeoff_ind,chr(13),''),chr(10),'')  -- 授信额度使用标志
    ,replace(replace(t1.chargeoff_dec,chr(13),''),chr(10),'')  -- 出账落实条件说明
    ,replace(replace(t1.dd_workflow_id,chr(13),''),chr(10),'')  -- 放款流程
    ,replace(replace(t1.approve_status,chr(13),''),chr(10),'')  -- 审批状态
    ,replace(replace(t1.input_id,chr(13),''),chr(10),'')  -- 登记(受理人)
    ,replace(replace(t1.examinant_id,chr(13),''),chr(10),'')  -- 审查人
    ,replace(replace(t1.investigator_id,chr(13),''),chr(10),'')  -- 调查人
    ,replace(replace(t1.cus_manager,chr(13),''),chr(10),'')  -- 客户经理
    ,replace(replace(t1.apply_date,chr(13),''),chr(10),'')  -- 申请日期
    ,replace(replace(t1.input_date,chr(13),''),chr(10),'')  -- 受理日期
    ,replace(replace(t1.input_br_id,chr(13),''),chr(10),'')  -- 受理机构
    ,replace(replace(t1.investigator_br_id,chr(13),''),chr(10),'')  -- 调查机构
    ,replace(replace(t1.fina_br_id,chr(13),''),chr(10),'')  -- 账务机构
    ,replace(replace(t1.main_br_id,chr(13),''),chr(10),'')  -- 主管机构
    ,replace(replace(t1.own_system,chr(13),''),chr(10),'')  -- 所属系统
    ,replace(replace(t1.chargeoff_status,chr(13),''),chr(10),'')  -- 出账状态
    ,replace(replace(t1.src_account,chr(13),''),chr(10),'')  -- 来源账号
    ,replace(replace(t1.src_account_name,chr(13),''),chr(10),'')  -- 来源账户名称
    ,replace(replace(t1.biz_type_detail,chr(13),''),chr(10),'')  -- 业务品种名称
    ,replace(replace(t1.ir_exe_type,chr(13),''),chr(10),'')  -- 利率变更生效方式
    ,replace(replace(t1.int_rate_type,chr(13),''),chr(10),'')  -- 利率类型
    ,replace(replace(t1.int_rate_inc_opt,chr(13),''),chr(10),'')  -- 利率增量选项
    ,t1.int_rate_inc  -- 利率增量
    ,t1.fixed_rate  -- 固定利率
    ,replace(replace(t1.prd_userdf_name,chr(13),''),chr(10),'')  -- 产品自定义名称
    ,replace(replace(t1.prd_userdf_type,chr(13),''),chr(10),'')  -- 产品自定义类别
    ,replace(replace(t1.return_date,chr(13),''),chr(10),'')  -- 还款日
    ,replace(replace(t1.chargeoff_manage,chr(13),''),chr(10),'')  -- 出帐负责人
    ,replace(replace(t1.consign_fund_protocol_no,chr(13),''),chr(10),'')  -- 资金协议编号
    ,replace(replace(t1.ispaf,chr(13),''),chr(10),'')  -- 是否住房公积金贷款
    ,replace(replace(t1.distribution_day,chr(13),''),chr(10),'')  -- 分配日
    ,replace(replace(t1.money_origin_id,chr(13),''),chr(10),'')  -- 分配方式
    ,replace(replace(t1.overdue_type,chr(13),''),chr(10),'')  -- 逾期利率浮动类型
    ,replace(replace(t1.default_type,chr(13),''),chr(10),'')  -- 挤占利率浮动类型
    ,t1.ass_sec_acc_bal  -- 保证金账户余额
    ,t1.ass_sec_amt  -- 本笔保证金金额
    ,replace(replace(t1.ass_sec_dep_date,chr(13),''),chr(10),'')  -- 本笔保证金存入日期
    ,replace(replace(t1.repayment_account1,chr(13),''),chr(10),'')  -- 还款账号1
    ,replace(replace(t1.repayment_acc_name1,chr(13),''),chr(10),'')  -- 还款账号1
    ,replace(replace(t1.cus_area,chr(13),''),chr(10),'')  -- 客户所属片区
    ,replace(replace(t1.loan_card_ind,chr(13),''),chr(10),'')  -- 使用农户贷款证标志
    ,replace(replace(t1.agriculture_type,chr(13),''),chr(10),'')  -- 涉农情况
    ,replace(replace(t1.agriculture_use,chr(13),''),chr(10),'')  -- 涉农用途
    ,replace(replace(t1.minor_entrp_range,chr(13),''),chr(10),'')  -- 小企业统计口径(银监)
    ,replace(replace(t1.government_ind,chr(13),''),chr(10),'')  -- 涉政类型
    ,replace(replace(t1.government_org_attribute,chr(13),''),chr(10),'')  -- 涉政机构属性
    ,replace(replace(t1.government_platform,chr(13),''),chr(10),'')  -- 是否为涉政平台
    ,replace(replace(t1.ass_sec_ind,chr(13),''),chr(10),'')  -- 是否需存入保证金
    ,replace(replace(t1.guarantora_grp_ind,chr(13),''),chr(10),'')  -- 联保贷款标志
    ,replace(replace(t1.loan_fund_whither,chr(13),''),chr(10),'')  -- 贷款款项去向
    ,replace(replace(t1.interest_date,chr(13),''),chr(10),'')  -- 结息日
    ,replace(replace(t1.cn_cont_no,chr(13),''),chr(10),'')  -- 主合同号
    ,replace(replace(t1.syndicated_proxy_id,chr(13),''),chr(10),'')  -- 代理社机构码
    ,replace(replace(t1.sec_money_ac,chr(13),''),chr(10),'')  -- 基础保证金账号
    ,replace(replace(t1.sec_money_ac_name,chr(13),''),chr(10),'')  -- 基础保证金账户名称
    ,t1.sec_money_init  -- 基础保证金起存金额
    ,t1.sec_money_rate  -- 业务保证金比例
    ,replace(replace(t1.freeze_no,chr(13),''),chr(10),'')  -- 冻结编号
    ,replace(replace(t1.freeze_name,chr(13),''),chr(10),'')  -- 冻结账户名称
    ,t1.freeze_amt  -- 冻结止付金额
    ,replace(replace(t1.farm_card_type,chr(13),''),chr(10),'')  -- 贷款发放形式
    ,replace(replace(t1.check_finger,chr(13),''),chr(10),'')  -- 指纹检查状态
    ,t1.loan_term  -- 贷款期限
    ,replace(replace(t1.term_time_type,chr(13),''),chr(10),'')  -- 贷款时间类型
    ,replace(replace(t1.due_day,chr(13),''),chr(10),'')  -- 还款日期
    ,replace(replace(t1.pay_distance,chr(13),''),chr(10),'')  -- 还款间隔
    ,replace(replace(t1.old_bill_no,chr(13),''),chr(10),'')  -- 原借据编号
    ,replace(replace(t1.is_risk,chr(13),''),chr(10),'')  -- 是否低风险（1-是，2-否）
    ,replace(replace(t1.invst_concl,chr(13),''),chr(10),'')  -- 调查人意见
    ,replace(replace(t1.security_money_ind_zy,chr(13),''),chr(10),'')  -- 是否录入保证金（专业担保公司）
    ,replace(replace(t1.security_money_ac_no_zy,chr(13),''),chr(10),'')  -- 保证金账号（专业担保公司）
    ,replace(replace(t1.security_money_child_acc_no_zy,chr(13),''),chr(10),'')  -- 保证金子账号（专业担保公司）
    ,t1.security_money_amt_zy  -- 业务保证金金额（专业担保公司）
    ,replace(replace(t1.security_money_ac_name_zy,chr(13),''),chr(10),'')  -- 保证金账户名（专业担保公司）
    ,replace(replace(t1.adv_rpay_flg,chr(13),''),chr(10),'')  -- 是否允许提前还款
    ,replace(replace(t1.made_rpay_plan,chr(13),''),chr(10),'')  -- 是否定制还款计划
    ,replace(replace(t1.enter_account_type,chr(13),''),chr(10),'')  -- 入账账户支付工具类型
    ,replace(replace(t1.repayment_account_type,chr(13),''),chr(10),'')  -- 还款账户支付工具类型
    ,replace(replace(t1.businum,chr(13),''),chr(10),'')  -- 委托支付编号
    ,replace(replace(t1.trade_serno,chr(13),''),chr(10),'')  -- 贷款开户贷款产品流水号
    ,replace(replace(t1.repayment_date_confirm,chr(13),''),chr(10),'')  -- 还款日确定
    ,replace(replace(t1.auth_review,chr(13),''),chr(10),'')  -- 放款审核岗审批意见
    ,replace(replace(t1.is_cl,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.is_loan_anytime,chr(13),''),chr(10),'')  -- 合同是否随借随还标识
    ,replace(replace(t1.is_balloon,chr(13),''),chr(10),'')  -- 是否选择气球贷
    ,t1.last_term_amount  -- 最后一期保留金额
    ,t1.last_term_percent  -- 最后一期还本金额比例
    ,t1.tax_amount  -- 印花税
    ,replace(replace(t1.tax_account,chr(13),''),chr(10),'')  -- 印花税扣税账户
    ,replace(replace(t1.tax_account_name,chr(13),''),chr(10),'')  -- 印花税扣税账户名称
    ,replace(replace(t1.tax_account_type,chr(13),''),chr(10),'')  -- 印花税扣税账户支付工具类型
    ,replace(replace(t1.is_record_tax,chr(13),''),chr(10),'')  -- 是否录入印花税
    ,replace(replace(t1.rate_type,chr(13),''),chr(10),'')  -- 利率类型 1 基准利率 2 lpr
    ,replace(replace(t1.loan_rel_date,chr(13),''),chr(10),'')  -- 贷款实际发放日   
    ,t1.start_dt  -- 开始日期
    ,t1.end_dt  -- 结束日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.rcrs_pvp_loan_app t1    --出账申请信息表
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'rcrs_pvp_loan_app',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);