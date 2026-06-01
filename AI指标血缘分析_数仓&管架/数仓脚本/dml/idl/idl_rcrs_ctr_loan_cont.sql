/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_rcrs_ctr_loan_cont
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
alter table ${idl_schema}.rcrs_ctr_loan_cont drop partition p_${last_date};
alter table ${idl_schema}.rcrs_ctr_loan_cont drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.rcrs_ctr_loan_cont add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.rcrs_ctr_loan_cont (
    etl_dt  -- 数据日期
    ,cont_no  -- 合同编号
    ,serno  -- 业务流水号
    ,cont_type  -- 合同类型
    ,prd_pk  -- 产品主键
    ,biz_type  -- 业务品种
    ,prd_name  -- 产品名称
    ,app_form  -- 表单类型
    ,cust_no  -- 客户编号
    ,cust_name  -- 客户名称
    ,biz_type_sub  -- 业务品种细分
    ,biz_type_detail  -- 业务品种分类名称
    ,loan_form  -- 贷款形式
    ,loan_nature  -- 贷款性质
    ,loan_kind_ca  -- 企业贷款种类
    ,loan_type_ext  -- 关联交易类型
    ,loan_type_ext2  -- 关联交易描述
    ,currency_type  -- 币种
    ,approval_amt  -- 审批金额
    ,cont_amt  -- 合同金额
    ,total_issue_amt  -- 累计发放金额
    ,total_recyle_amt  -- 累计回收金额
    ,avail_amt  -- 合同可用余额
    ,term_time_type  -- 期限时间类型
    ,loan_term  -- 贷款期限
    ,loan_start_date  -- 贷款起始日期
    ,loan_end_date  -- 贷款终止日期
    ,ruling_ir  -- 基准利率
    ,cal_floating_rate  -- 利率浮动比
    ,reality_ir_y  -- 执行利率（年）
    ,overdue_rate  -- 逾期利率浮动比例
    ,overdue_ir  -- 逾期月利率
    ,default_rate  -- 逾期利率浮动比例
    ,default_ir  -- 挤占挪用利率浮动比例
    ,ci_rate  -- 复利加罚率
    ,ci_ir  -- 复利月利率
    ,ir_adjust_mode  -- 利率调整方式
    ,interest_acc_mode  -- 结息方式
    ,chargeoff_ind  -- 出帐方式
    ,discont_ind  -- 是否贴息
    ,discount_id  -- 贴息方编号
    ,mortgage_flg  -- 按揭标识
    ,repayment_mode  -- 还款方式
    ,repayment_period  -- 还款频率
    ,assure_means_main  -- 主担保方式
    ,assure_means2  -- 主担保方式2
    ,assure_means3  -- 主担保方式3
    ,loan_direction  -- 贷款投向
    ,direction_name  -- 投向名称
    ,agriculture_type  -- 涉农情况
    ,agriculture_use  -- 涉农用途
    ,minor_entrp_range  -- 小企业统计口径(银监)
    ,loan_use_type  -- 借款用途类型
    ,use_dec  -- 用途说明
    ,repayment_src_dec  -- 还款来源
    ,limit_ind  -- 授信额度使用标志
    ,guarantora_grp_ind  -- 联保贷款标志
    ,copartner_ind  -- 市场合作方标志
    ,loan_card_ind  -- 使用农户贷款证标志
    ,entrust_ind  -- 委托方贷款标识
    ,loan_type1  -- 借款分类1
    ,loan_type2  -- 借款分类2
    ,loan_type3  -- 借款分类3
    ,loan_type4  -- 借款分类4
    ,loan_type5  -- 借款分类5
    ,loan_type6  -- 借款分类6
    ,final_endorse_br_id  -- 最终审批机构
    ,final_endorse_date  -- 最终审批日期
    ,final_endorse_id  -- 最终审批人
    ,sign_date  -- 合同签订日期
    ,change_date  -- 合同变更日期
    ,cont_state  -- 合同状态
    ,input_id  -- 托管人（申请人）
    ,cust_mgr  -- 客户经理
    ,input_br_id  -- 受理机构
    ,main_br_id  -- 主管机构
    ,fina_br_id  -- 账务机构
    ,old_bill_no  -- 原借据号
    ,cla_result  -- 风险分类初分结果
    ,cla_suggestion  -- 风险分类初分意见
    ,ir_exe_type  -- 利率变更生效方式
    ,responsible_man  -- 责任人
    ,government_ind  -- 涉政类型
    ,government_org_attribute  -- 政机构属性
    ,government_platform  -- 是否为涉政平台
    ,int_rate_type  -- 利率类型
    ,int_rate_inc_opt  -- 率增量选项
    ,int_rate_inc  -- 利率增量
    ,fixed_rate  -- 固定利率
    ,prd_userdf_type  -- 产品自定义类型
    ,prd_userdf_name  -- 产品自定义名称
    ,consign_loan_bgl_acct_no  -- 委托贷款BGL帐号
    ,funds_src  -- 资金来源
    ,chargeoff_manage  -- 出帐负责人
    ,enter_account  -- 入账账号
    ,enter_account_name  -- 入账账户名称
    ,repayment_account  -- 还款账号
    ,repayment_acc_name  -- 还款账户名称
    ,prd_type  -- 产品类别
    ,ispaf  -- 是否住房公积金贷款
    ,cosurety_cont_no  -- 联保协议编号
    ,lead_arranger_ind  -- 牵头行标志
    ,cn_cont_no  -- 中文合同编号
    ,fldvalue01  -- 备注1
    ,fldvalue02  -- 备注2
    ,disaster_type  -- 救灾类型
    ,carve_out_type  -- 创业贷款
    ,farm_card_type  -- 农户发放形式
    ,overdue_type  -- 逾期利率浮动类型
    ,default_type  -- 挤占利率浮动类型
    ,spe_loan_type2  -- 特色贷款类型
    ,repay_interest_mode  -- 提前还款部分本金的利息计收方式
    ,repay_principal_rate  -- 提前还款本金的比例
    ,add_interest_date  -- 加收利息时间（月）
    ,cus_area  -- 客户所属片区
    ,syndicated_ind  -- 银/社团标识
    ,syndicated_type  -- 银/社团类型
    ,join_role  -- 参与角色
    ,syndicated_proxy_id  -- 代理行机构号
    ,government_financing  -- 是否政府融资平台
    ,gover_fina_su_relat  -- 政府融资平台隶属关系
    ,gover_fina_attribute  -- 政府融资平台属性
    ,gover_fina_type  -- 政府融资平台类型
    ,gover_fina_direction  -- 政府融资平台投向
    ,gover_fina_repay_src_dec  -- 政府融资平台还款来源
    ,domain_policy_type  -- 产业政策类型
    ,old_cont_state  -- 
    ,cap_overdue_date  -- 本金最早逾期日期
    ,int_overdue_date  -- 利息最早逾期日期
    ,if_gw  -- 是否绿色通道
    ,check_finger  -- 指纹检查状态
    ,tourism_flag  -- 旅游业贷款
    ,biz_type_ext  -- 业务类型
    ,biz_type_ext2  -- 贷款科目
    ,proj_type  -- 项目类型
    ,syndicated_amt  -- 银团总金额
    ,lmt_serno  -- 授信协议编号
    ,item_id  -- 授信台帐编号
    ,is_risk  -- 是否低风险（1-是，2-否）
    ,print_cont_no  -- 打印合同号
    ,last_upd_date  -- 
    ,loan_mode  -- 发放方式 一次发放,多次发放
    ,is_loan_anytime  -- 是否随借随还
    ,rate_select_type  -- 利率选取日期种类 1-按起息日  2-按合同签订日
    ,is_stage_repay  -- 是否允许阶段性还款
    ,int_cal_type  -- 利息计算基础 1-贷款金额  2-贷款余额
    ,pay_type  -- 贷款资金支付方式 1-贷款人受托支付 2-借款人自主支付
    ,is_prj_cooperate  -- 是否使用合作商额度
    ,prj_cooperate_serno  -- 合作商协议编号
    ,repayment_interval  -- 还款间隔
    ,repayment_date_confirm  -- 还款日确定
    ,is_bank_rel  -- 是否与贵行存在关联关系
    ,input_date  -- 贷款申请日期
    ,intent_cop  -- 意向类合作商
    ,is_intent_cop  -- 是否引入意向类合作商
    ,enter_account_type  -- 入账账户支付工具类型
    ,repayment_account_type  -- 还款账户支付工具类型
    ,old_loan_amount  -- 原借据金额
    ,old_loan_balance  -- 原借据余额
    ,return_date  -- 还款日
    ,creation_date  -- 合同生成日期
    ,is_pub_com  -- 是否引入公职贷单位
    ,pub_com  -- 公职贷单位编号
    ,is_cl  -- 
    ,pf_serno  -- 批复流水号
    ,cop_acc_no  -- 合作商台账编号
    ,cop_prj_type  -- 合作商项目类型
    ,cop_cus_type  -- 合作商类型
    ,opt_type  -- 随借随还状态
    ,is_balloon  -- 是否选择气球贷
    ,last_term_percent  -- 最后一期还本金额比例
    ,avg_mortagage_rate  -- 平均抵质押率(%)
    ,total_max_mortagage_amt  -- 抵质押担保总额(元)
    ,remove_avail_amt  -- 押品抽取的金额
    ,is_sign  -- 抽取标志
    ,amt_use_type  -- 额度透支类型（0-优先使用账户余额,1-优先使用额度）
    ,trigg_amt  -- 透支触发阀值
    ,basic_ccr_amt  -- 基础评分卡授信额度
    ,bill_term  -- 单笔放款期限（3-3个月,6-6个月,9-9个月,12-12个月）
    ,reality_ir_d  -- 执行日利率
    ,cont_amt_chg_limit  -- 调整额度上限
    ,relate_no  -- 关联业务编号,组合贷时使用（申请流水号或借款合同号）
    ,cancel_time  -- 合同注销时间
    ,floor_num  -- 住房套数
    ,is_jg_account  -- 是否在我行开立监管账户
    ,rate_type  -- 
    ,sld_seq_num  --    
    ,cltrl_contr_link_loc --    
    ,cltrl_contr_sign_dt  --  
    ,start_dt  -- 开始日期
    ,end_dt  -- 结束日期
    ,id_mark  -- 删除标识
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.cont_no,chr(13),''),chr(10),'')  -- 合同编号
    ,replace(replace(t1.serno,chr(13),''),chr(10),'')  -- 业务流水号
    ,replace(replace(t1.cont_type,chr(13),''),chr(10),'')  -- 合同类型
    ,replace(replace(t1.prd_pk,chr(13),''),chr(10),'')  -- 产品主键
    ,replace(replace(t1.biz_type,chr(13),''),chr(10),'')  -- 业务品种
    ,replace(replace(t1.prd_name,chr(13),''),chr(10),'')  -- 产品名称
    ,replace(replace(t1.app_form,chr(13),''),chr(10),'')  -- 表单类型
    ,replace(replace(t1.cust_no,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.cust_name,chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(t1.biz_type_sub,chr(13),''),chr(10),'')  -- 业务品种细分
    ,replace(replace(t1.biz_type_detail,chr(13),''),chr(10),'')  -- 业务品种分类名称
    ,replace(replace(t1.loan_form,chr(13),''),chr(10),'')  -- 贷款形式
    ,replace(replace(t1.loan_nature,chr(13),''),chr(10),'')  -- 贷款性质
    ,replace(replace(t1.loan_kind_ca,chr(13),''),chr(10),'')  -- 企业贷款种类
    ,replace(replace(t1.loan_type_ext,chr(13),''),chr(10),'')  -- 关联交易类型
    ,replace(replace(t1.loan_type_ext2,chr(13),''),chr(10),'')  -- 关联交易描述
    ,replace(replace(t1.currency_type,chr(13),''),chr(10),'')  -- 币种
    ,t1.approval_amt  -- 审批金额
    ,t1.cont_amt  -- 合同金额
    ,t1.total_issue_amt  -- 累计发放金额
    ,t1.total_recyle_amt  -- 累计回收金额
    ,t1.avail_amt  -- 合同可用余额
    ,replace(replace(t1.term_time_type,chr(13),''),chr(10),'')  -- 期限时间类型
    ,t1.loan_term  -- 贷款期限
    ,replace(replace(t1.loan_start_date,chr(13),''),chr(10),'')  -- 贷款起始日期
    ,replace(replace(t1.loan_end_date,chr(13),''),chr(10),'')  -- 贷款终止日期
    ,t1.ruling_ir  -- 基准利率
    ,t1.cal_floating_rate  -- 利率浮动比
    ,t1.reality_ir_y  -- 执行利率（年）
    ,t1.overdue_rate  -- 逾期利率浮动比例
    ,t1.overdue_ir  -- 逾期月利率
    ,t1.default_rate  -- 逾期利率浮动比例
    ,t1.default_ir  -- 挤占挪用利率浮动比例
    ,t1.ci_rate  -- 复利加罚率
    ,t1.ci_ir  -- 复利月利率
    ,replace(replace(t1.ir_adjust_mode,chr(13),''),chr(10),'')  -- 利率调整方式
    ,replace(replace(t1.interest_acc_mode,chr(13),''),chr(10),'')  -- 结息方式
    ,replace(replace(t1.chargeoff_ind,chr(13),''),chr(10),'')  -- 出帐方式
    ,replace(replace(t1.discont_ind,chr(13),''),chr(10),'')  -- 是否贴息
    ,replace(replace(t1.discount_id,chr(13),''),chr(10),'')  -- 贴息方编号
    ,replace(replace(t1.mortgage_flg,chr(13),''),chr(10),'')  -- 按揭标识
    ,replace(replace(t1.repayment_mode,chr(13),''),chr(10),'')  -- 还款方式
    ,replace(replace(t1.repayment_period,chr(13),''),chr(10),'')  -- 还款频率
    ,replace(replace(t1.assure_means_main,chr(13),''),chr(10),'')  -- 主担保方式
    ,replace(replace(t1.assure_means2,chr(13),''),chr(10),'')  -- 主担保方式2
    ,replace(replace(t1.assure_means3,chr(13),''),chr(10),'')  -- 主担保方式3
    ,replace(replace(t1.loan_direction,chr(13),''),chr(10),'')  -- 贷款投向
    ,replace(replace(t1.direction_name,chr(13),''),chr(10),'')  -- 投向名称
    ,replace(replace(t1.agriculture_type,chr(13),''),chr(10),'')  -- 涉农情况
    ,replace(replace(t1.agriculture_use,chr(13),''),chr(10),'')  -- 涉农用途
    ,replace(replace(t1.minor_entrp_range,chr(13),''),chr(10),'')  -- 小企业统计口径(银监)
    ,replace(replace(t1.loan_use_type,chr(13),''),chr(10),'')  -- 借款用途类型
    ,replace(replace(t1.use_dec,chr(13),''),chr(10),'')  -- 用途说明
    ,replace(replace(t1.repayment_src_dec,chr(13),''),chr(10),'')  -- 还款来源
    ,replace(replace(t1.limit_ind,chr(13),''),chr(10),'')  -- 授信额度使用标志
    ,replace(replace(t1.guarantora_grp_ind,chr(13),''),chr(10),'')  -- 联保贷款标志
    ,replace(replace(t1.copartner_ind,chr(13),''),chr(10),'')  -- 市场合作方标志
    ,replace(replace(t1.loan_card_ind,chr(13),''),chr(10),'')  -- 使用农户贷款证标志
    ,replace(replace(t1.entrust_ind,chr(13),''),chr(10),'')  -- 委托方贷款标识
    ,replace(replace(t1.loan_type1,chr(13),''),chr(10),'')  -- 借款分类1
    ,replace(replace(t1.loan_type2,chr(13),''),chr(10),'')  -- 借款分类2
    ,replace(replace(t1.loan_type3,chr(13),''),chr(10),'')  -- 借款分类3
    ,replace(replace(t1.loan_type4,chr(13),''),chr(10),'')  -- 借款分类4
    ,replace(replace(t1.loan_type5,chr(13),''),chr(10),'')  -- 借款分类5
    ,replace(replace(t1.loan_type6,chr(13),''),chr(10),'')  -- 借款分类6
    ,replace(replace(t1.final_endorse_br_id,chr(13),''),chr(10),'')  -- 最终审批机构
    ,replace(replace(t1.final_endorse_date,chr(13),''),chr(10),'')  -- 最终审批日期
    ,replace(replace(t1.final_endorse_id,chr(13),''),chr(10),'')  -- 最终审批人
    ,replace(replace(t1.sign_date,chr(13),''),chr(10),'')  -- 合同签订日期
    ,replace(replace(t1.change_date,chr(13),''),chr(10),'')  -- 合同变更日期
    ,replace(replace(t1.cont_state,chr(13),''),chr(10),'')  -- 合同状态
    ,replace(replace(t1.input_id,chr(13),''),chr(10),'')  -- 托管人（申请人）
    ,replace(replace(t1.cust_mgr,chr(13),''),chr(10),'')  -- 客户经理
    ,replace(replace(t1.input_br_id,chr(13),''),chr(10),'')  -- 受理机构
    ,replace(replace(t1.main_br_id,chr(13),''),chr(10),'')  -- 主管机构
    ,replace(replace(t1.fina_br_id,chr(13),''),chr(10),'')  -- 账务机构
    ,replace(replace(t1.old_bill_no,chr(13),''),chr(10),'')  -- 原借据号
    ,replace(replace(t1.cla_result,chr(13),''),chr(10),'')  -- 风险分类初分结果
    ,replace(replace(t1.cla_suggestion,chr(13),''),chr(10),'')  -- 风险分类初分意见
    ,replace(replace(t1.ir_exe_type,chr(13),''),chr(10),'')  -- 利率变更生效方式
    ,replace(replace(t1.responsible_man,chr(13),''),chr(10),'')  -- 责任人
    ,replace(replace(t1.government_ind,chr(13),''),chr(10),'')  -- 涉政类型
    ,replace(replace(t1.government_org_attribute,chr(13),''),chr(10),'')  -- 政机构属性
    ,replace(replace(t1.government_platform,chr(13),''),chr(10),'')  -- 是否为涉政平台
    ,replace(replace(t1.int_rate_type,chr(13),''),chr(10),'')  -- 利率类型
    ,replace(replace(t1.int_rate_inc_opt,chr(13),''),chr(10),'')  -- 率增量选项
    ,t1.int_rate_inc  -- 利率增量
    ,t1.fixed_rate  -- 固定利率
    ,replace(replace(t1.prd_userdf_type,chr(13),''),chr(10),'')  -- 产品自定义类型
    ,replace(replace(t1.prd_userdf_name,chr(13),''),chr(10),'')  -- 产品自定义名称
    ,replace(replace(t1.consign_loan_bgl_acct_no,chr(13),''),chr(10),'')  -- 委托贷款BGL帐号
    ,replace(replace(t1.funds_src,chr(13),''),chr(10),'')  -- 资金来源
    ,replace(replace(t1.chargeoff_manage,chr(13),''),chr(10),'')  -- 出帐负责人
    ,replace(replace(t1.enter_account,chr(13),''),chr(10),'')  -- 入账账号
    ,replace(replace(t1.enter_account_name,chr(13),''),chr(10),'')  -- 入账账户名称
    ,replace(replace(t1.repayment_account,chr(13),''),chr(10),'')  -- 还款账号
    ,replace(replace(t1.repayment_acc_name,chr(13),''),chr(10),'')  -- 还款账户名称
    ,replace(replace(t1.prd_type,chr(13),''),chr(10),'')  -- 产品类别
    ,replace(replace(t1.ispaf,chr(13),''),chr(10),'')  -- 是否住房公积金贷款
    ,replace(replace(t1.cosurety_cont_no,chr(13),''),chr(10),'')  -- 联保协议编号
    ,replace(replace(t1.lead_arranger_ind,chr(13),''),chr(10),'')  -- 牵头行标志
    ,replace(replace(t1.cn_cont_no,chr(13),''),chr(10),'')  -- 中文合同编号
    ,replace(replace(t1.fldvalue01,chr(13),''),chr(10),'')  -- 备注1
    ,replace(replace(t1.fldvalue02,chr(13),''),chr(10),'')  -- 备注2
    ,replace(replace(t1.disaster_type,chr(13),''),chr(10),'')  -- 救灾类型
    ,replace(replace(t1.carve_out_type,chr(13),''),chr(10),'')  -- 创业贷款
    ,replace(replace(t1.farm_card_type,chr(13),''),chr(10),'')  -- 农户发放形式
    ,replace(replace(t1.overdue_type,chr(13),''),chr(10),'')  -- 逾期利率浮动类型
    ,replace(replace(t1.default_type,chr(13),''),chr(10),'')  -- 挤占利率浮动类型
    ,replace(replace(t1.spe_loan_type2,chr(13),''),chr(10),'')  -- 特色贷款类型
    ,replace(replace(t1.repay_interest_mode,chr(13),''),chr(10),'')  -- 提前还款部分本金的利息计收方式
    ,t1.repay_principal_rate  -- 提前还款本金的比例
    ,t1.add_interest_date  -- 加收利息时间（月）
    ,replace(replace(t1.cus_area,chr(13),''),chr(10),'')  -- 客户所属片区
    ,replace(replace(t1.syndicated_ind,chr(13),''),chr(10),'')  -- 银/社团标识
    ,replace(replace(t1.syndicated_type,chr(13),''),chr(10),'')  -- 银/社团类型
    ,replace(replace(t1.join_role,chr(13),''),chr(10),'')  -- 参与角色
    ,replace(replace(t1.syndicated_proxy_id,chr(13),''),chr(10),'')  -- 代理行机构号
    ,replace(replace(t1.government_financing,chr(13),''),chr(10),'')  -- 是否政府融资平台
    ,replace(replace(t1.gover_fina_su_relat,chr(13),''),chr(10),'')  -- 政府融资平台隶属关系
    ,replace(replace(t1.gover_fina_attribute,chr(13),''),chr(10),'')  -- 政府融资平台属性
    ,replace(replace(t1.gover_fina_type,chr(13),''),chr(10),'')  -- 政府融资平台类型
    ,replace(replace(t1.gover_fina_direction,chr(13),''),chr(10),'')  -- 政府融资平台投向
    ,replace(replace(t1.gover_fina_repay_src_dec,chr(13),''),chr(10),'')  -- 政府融资平台还款来源
    ,replace(replace(t1.domain_policy_type,chr(13),''),chr(10),'')  -- 产业政策类型
    ,replace(replace(t1.old_cont_state,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cap_overdue_date,chr(13),''),chr(10),'')  -- 本金最早逾期日期
    ,replace(replace(t1.int_overdue_date,chr(13),''),chr(10),'')  -- 利息最早逾期日期
    ,replace(replace(t1.if_gw,chr(13),''),chr(10),'')  -- 是否绿色通道
    ,replace(replace(t1.check_finger,chr(13),''),chr(10),'')  -- 指纹检查状态
    ,replace(replace(t1.tourism_flag,chr(13),''),chr(10),'')  -- 旅游业贷款
    ,replace(replace(t1.biz_type_ext,chr(13),''),chr(10),'')  -- 业务类型
    ,replace(replace(t1.biz_type_ext2,chr(13),''),chr(10),'')  -- 贷款科目
    ,replace(replace(t1.proj_type,chr(13),''),chr(10),'')  -- 项目类型
    ,t1.syndicated_amt  -- 银团总金额
    ,replace(replace(t1.lmt_serno,chr(13),''),chr(10),'')  -- 授信协议编号
    ,replace(replace(t1.item_id,chr(13),''),chr(10),'')  -- 授信台帐编号
    ,replace(replace(t1.is_risk,chr(13),''),chr(10),'')  -- 是否低风险（1-是，2-否）
    ,replace(replace(t1.print_cont_no,chr(13),''),chr(10),'')  -- 打印合同号
    ,replace(replace(t1.last_upd_date,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loan_mode,chr(13),''),chr(10),'')  -- 发放方式 一次发放,多次发放
    ,replace(replace(t1.is_loan_anytime,chr(13),''),chr(10),'')  -- 是否随借随还
    ,replace(replace(t1.rate_select_type,chr(13),''),chr(10),'')  -- 利率选取日期种类 1-按起息日  2-按合同签订日
    ,replace(replace(t1.is_stage_repay,chr(13),''),chr(10),'')  -- 是否允许阶段性还款
    ,replace(replace(t1.int_cal_type,chr(13),''),chr(10),'')  -- 利息计算基础 1-贷款金额  2-贷款余额
    ,replace(replace(t1.pay_type,chr(13),''),chr(10),'')  -- 贷款资金支付方式 1-贷款人受托支付 2-借款人自主支付
    ,replace(replace(t1.is_prj_cooperate,chr(13),''),chr(10),'')  -- 是否使用合作商额度
    ,replace(replace(t1.prj_cooperate_serno,chr(13),''),chr(10),'')  -- 合作商协议编号
    ,replace(replace(t1.repayment_interval,chr(13),''),chr(10),'')  -- 还款间隔
    ,replace(replace(t1.repayment_date_confirm,chr(13),''),chr(10),'')  -- 还款日确定
    ,replace(replace(t1.is_bank_rel,chr(13),''),chr(10),'')  -- 是否与贵行存在关联关系
    ,replace(replace(t1.input_date,chr(13),''),chr(10),'')  -- 贷款申请日期
    ,replace(replace(t1.intent_cop,chr(13),''),chr(10),'')  -- 意向类合作商
    ,replace(replace(t1.is_intent_cop,chr(13),''),chr(10),'')  -- 是否引入意向类合作商
    ,replace(replace(t1.enter_account_type,chr(13),''),chr(10),'')  -- 入账账户支付工具类型
    ,replace(replace(t1.repayment_account_type,chr(13),''),chr(10),'')  -- 还款账户支付工具类型
    ,t1.old_loan_amount  -- 原借据金额
    ,t1.old_loan_balance  -- 原借据余额
    ,replace(replace(t1.return_date,chr(13),''),chr(10),'')  -- 还款日
    ,replace(replace(t1.creation_date,chr(13),''),chr(10),'')  -- 合同生成日期
    ,replace(replace(t1.is_pub_com,chr(13),''),chr(10),'')  -- 是否引入公职贷单位
    ,replace(replace(t1.pub_com,chr(13),''),chr(10),'')  -- 公职贷单位编号
    ,replace(replace(t1.is_cl,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pf_serno,chr(13),''),chr(10),'')  -- 批复流水号
    ,replace(replace(t1.cop_acc_no,chr(13),''),chr(10),'')  -- 合作商台账编号
    ,replace(replace(t1.cop_prj_type,chr(13),''),chr(10),'')  -- 合作商项目类型
    ,replace(replace(t1.cop_cus_type,chr(13),''),chr(10),'')  -- 合作商类型
    ,replace(replace(t1.opt_type,chr(13),''),chr(10),'')  -- 随借随还状态
    ,replace(replace(t1.is_balloon,chr(13),''),chr(10),'')  -- 是否选择气球贷
    ,t1.last_term_percent  -- 最后一期还本金额比例
    ,t1.avg_mortagage_rate  -- 平均抵质押率(%)
    ,t1.total_max_mortagage_amt  -- 抵质押担保总额(元)
    ,t1.remove_avail_amt  -- 押品抽取的金额
    ,replace(replace(t1.is_sign,chr(13),''),chr(10),'')  -- 抽取标志
    ,replace(replace(t1.amt_use_type,chr(13),''),chr(10),'')  -- 额度透支类型（0-优先使用账户余额,1-优先使用额度）
    ,t1.trigg_amt  -- 透支触发阀值
    ,t1.basic_ccr_amt  -- 基础评分卡授信额度
    ,replace(replace(t1.bill_term,chr(13),''),chr(10),'')  -- 单笔放款期限（3-3个月,6-6个月,9-9个月,12-12个月）
    ,t1.reality_ir_d  -- 执行日利率
    ,t1.cont_amt_chg_limit  -- 调整额度上限
    ,replace(replace(t1.relate_no,chr(13),''),chr(10),'')  -- 关联业务编号,组合贷时使用（申请流水号或借款合同号）
    ,replace(replace(t1.cancel_time,chr(13),''),chr(10),'')  -- 合同注销时间
    ,replace(replace(t1.floor_num,chr(13),''),chr(10),'')  -- 住房套数
    ,replace(replace(t1.is_jg_account,chr(13),''),chr(10),'')  -- 是否在我行开立监管账户
    ,replace(replace(t1.rate_type,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sld_seq_num,chr(13),''),chr(10),'') --    
    ,replace(replace(t1.cltrl_contr_link_loc,chr(13),''),chr(10),'') --    
    ,replace(replace(t1.cltrl_contr_sign_dt,chr(13),''),chr(10),'')  --      
    ,t1.start_dt  -- 开始日期
    ,t1.end_dt  -- 结束日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.rcrs_ctr_loan_cont t1    --贷款合同信息表
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'rcrs_ctr_loan_cont',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);