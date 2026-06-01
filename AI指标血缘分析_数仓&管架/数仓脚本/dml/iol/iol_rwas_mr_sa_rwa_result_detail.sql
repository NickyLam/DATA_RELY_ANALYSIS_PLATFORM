/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rwas_mr_sa_rwa_result_detail
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rwas_mr_sa_rwa_result_detail_ex purge;
alter table ${iol_schema}.rwas_mr_sa_rwa_result_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rwas_mr_sa_rwa_result_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rwas_mr_sa_rwa_result_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_mr_sa_rwa_result_detail where 0=1;

insert /*+ append */ into ${iol_schema}.rwas_mr_sa_rwa_result_detail_ex(
    data_date -- 数据日期
    ,version_no -- 计量版本号
    ,loan_ref_crm_split_seq -- 缓释拆分序号
    ,scenario_no -- 业务情景编号 10-标准法 20-资产证券化 30-证券融资 40-场外衍生品 50-资管产品
    ,sa_calculate_id -- 标准法计量方法标识
    ,sa_calculate_name -- 标准法计量方法名称
    ,corporation -- 法人实体编号
    ,bank_level -- 银行档次
    ,consol_corporation -- 并表集团机构编号
    ,consol_bank_level -- 并表银行档次
    ,loan_ref_no -- 债项编号
    ,loan_ref_desc -- 债项描述
    ,contract_no -- 合同编号
    ,main_grnt_mth_cd -- 主要担保方式代码
    ,adt_grnt_mth_ind -- 附加担保方式
    ,due_id -- 债项号
    ,src_system_id -- 来源系统标识
    ,org_partent_no -- 分行管户机构
    ,org_partent_name -- 分行机构名称
    ,org_no -- 管户机构
    ,org_name -- 机构名称
    ,org_order_no -- 机构排序号
    ,accorg_partent_no -- 分行账务机构
    ,accorg_partent_name -- 分行账务机构名称
    ,accorg_no -- 账务机构
    ,accorg_name -- 账务机构名称
    ,bank_region_cd -- 银行地域代码
    ,bis_region_cd -- 监管区域代码
    ,bis_region_name -- 监管区域名称
    ,loan_ref_inv_indu_cd -- 投向行业代码
    ,cust_industry_cd -- 客户所属行业代码
    ,bis_industry_cd -- 计量行业代码
    ,bis_industry_name -- 计量行业名称
    ,five_class_cd -- 五级分类代码
    ,five_class_name -- 五级分类名称
    ,product_cd -- 产品代码
    ,product_name -- 产品名称
    ,bis_product_type_cd -- 监管产品类型代码
    ,bis_product_type_name -- 监管产品类型名称
    ,bis_product_btype_cd -- 监管产品大类代码
    ,bis_product_btype_name -- 监管产品大类名称
    ,sa_exp_class_cd -- 标准法风险暴露分类
    ,sa_exp_class_name -- 标准法风险暴露分类名称
    ,sa_exp_sub_class_cd -- 标准法风险暴露大类
    ,sa_exp_sub_class_name -- 标准法风险暴露大类名称
    ,item_off_ccf_btype_cd -- 表外CCF项目大类代码
    ,item_off_ccf_btype_name -- 表外CCF项目大类名称
    ,item_off_ccf_type_cd -- 表外CCF项目类型代码
    ,item_off_ccf_type_name -- 表外CCF项目类型名称
    ,business_line_cd -- 业务条线代码
    ,business_line_name -- 业务条线名称
    ,buss_type_cd -- 业务类型
    ,buss_type_name -- 业务名称
    ,start_date -- 开始日期
    ,due_date -- 到期日期
    ,orig_maturity -- 原始期限
    ,rema_maturity -- 剩余期限
    ,overdue_days -- 逾期天数
    ,std_default_flag -- 权重法违约标志
    ,on_off_id -- 表内外资产标志
    ,on_off_name -- 表内外资产名称
    ,seniority_id -- 优先债权标识
    ,seniority_name -- 优先标识名称
    ,book_type_id -- 账簿类型
    ,book_type_name -- 账簿名称
    ,bank_ccy_cd -- 银行币种代码
    ,bis_ccy_cd -- 计量币种代码
    ,bis_ccy_name -- 计量币种名称
    ,bookkeep_cny_flag -- 记账本位币计价标志
    ,ccy_mismatch_flag -- 币种错配标志
    ,exchange_rate -- 汇率
    ,subject_cd -- 本金科目代码
    ,subject_name -- 本金科目名称
    ,asset_balance -- 资产余额
    ,accrued_subject_cd -- 应计利息科目
    ,accrued_subject_name -- 应计利息科目名称
    ,accrued_int -- 应计利息
    ,receivable_subject_cd -- 应收利息科目
    ,receivable_subject_name -- 应收利息科目名称
    ,receivable_int -- 应收利息
    ,intadj_subject_cd -- 利息调整科目
    ,intadj_subject_name -- 利息调整科目名称
    ,int_adj -- 利息调整
    ,fairchange_subject_cd -- 公允价值变动科目
    ,fairchange_subject_name -- 公允价值变动科目名称
    ,fairvalue_changes -- 公允价值变动
    ,depreamor_subject_cd -- 折旧科目
    ,depreamor_subject_name -- 折旧科目名称
    ,depre_amortizat -- 折旧金额
    ,other_subject_cd -- 其他科目
    ,other_subject_name -- 其他科目名称
    ,other_amt -- 其他金额
    ,provision_subject_cd -- 准备金科目代码
    ,provision_subject_name -- 准备金科目名称
    ,provision -- 准备金
    ,provesion_ratio -- 准备金计提比例
    ,loan_flag -- 贷款标志
    ,mcr_flag -- 信用风险计量标志
    ,cross_border_trade_flag -- 因跨境货物贸易标志
    ,accept_credit_self_flag -- 自开信用证标志
    ,real_estate_type_cd -- 房地产风险暴露类型代码
    ,ltv -- LTV规则
    ,accept_discount_self_flag -- 自承自贴标志
    ,spe_lending_flag -- 专业贷款标志
    ,spe_lending_type -- 专业贷款分类
    ,operation_pf_flag -- 项目融资运营阶段标识
    ,bond_for_acquir_non_perf_flag -- 为收购国有银行不良贷款而定向发行的债券
    ,bond_pay_attr_id -- 地方债偿还属性标志
    ,guaranteed_bond_flag -- 合格担保债券标志
    ,sec_sp_rating_cd -- 债券标普评级
    ,account_classification -- 金融资产分类
    ,cancel_flag -- 随时可撤销标志
    ,off_asset_unmeasured_flag -- 表外资产不计量标志
    ,unused_prl_tmeet_flag -- 符合标准的未使用额度标志
    ,equity_invest_attr_identi -- 股权投资属性
    ,capital_type_cd -- 金融机构股权投资类别 10-并表 20-大额少数 30-小额少数
    ,core_one_capital_deduction -- 核心一级资本扣除金额
    ,oth_one_capital_deduction -- 其他核心一级资本扣除金额
    ,two_capital_deduction -- 二级资本扣除金额
    ,core_one_capital -- 股权投资余额，其中核心一级资本
    ,oth_one_capital -- 股权投资余额，其中其他核心一级资本
    ,two_capital -- 股权投资余额，其中二级资本
    ,bus_real_property_type_cd -- 抵债资产类别
    ,deal_trade_days -- 自合约结算日起延迟交易的交易日数
    ,cust_mcr_flag -- 交易对手信用风险计量标志
    ,ownership_transfer_flag -- 所有权发生转移标志
    ,derivatives_type_id -- 衍生工具类型标识
    ,over_derivatives_flag -- 场外衍生工具标志
    ,underlying_asset_qlf_flag -- 信用衍生品标的合格标志
    ,add_on -- 潜在风险暴露的附加因子
    ,certificate -- 零售客户证件号
    ,retail_cust_income_ccy_cd -- 零售客户主要收入币种代码
    ,cust_no -- 客户号
    ,cust_name -- 客户名称
    ,ccp_type_cd -- 交易对手类型代码
    ,ccp_type_name -- 交易对手类型名称
    ,ccp_btype_cd -- 交易对手大类代码
    ,ccp_btype_name -- 交易对手大类名称
    ,bank_country_cd -- 银行注册国
    ,bis_country_cd -- 计量注册国家代码
    ,bis_country_name -- 注册国名称
    ,sov_sp_lt_rating_cd -- 注册国标普评级代码
    ,cust_sp_lt_rating_cd -- 客户标普评级
    ,scra_rating -- SCRA评级
    ,int_trade_flag -- 内部交易标志
    ,solo_int_trade_flag -- 法人内部交易标志
    ,sec_flag -- 资产证券化标志
    ,sec_item_no -- 资产证券化项目标志
    ,sec_role_id -- 证券化角色标识 1:发起机构自持 2:投资机构 3：其他从事资产证券化参与机构
    ,sec_category_id -- 证券化类别标识
    ,sec_exposure_type_id -- 证券化暴露类型标识
    ,asset_sec_cr_transfer_flag -- 证券化售出资产是否实现信用风险转移标志
    ,anew_asset_sec_flag -- 再资产证券化标志
    ,npl_sec_flag -- 不良资产证券化标志
    ,sec_priority_rating_flag -- 证券化优先档次标志
    ,sec_prudent_mng_flag -- 证券化审慎管理标志
    ,sec_pool_risk_type_cd -- 基础资产风险类型 1-合格不良资产证券化 2-不合格不良资产证券化 0-正常资产
    ,sec_stc_flag -- 资产证券化简单透明可比标志
    ,sec_off_exposure_id -- 证券化表外暴露标识
    ,sec_pool_rwa -- 基础资产池RWA
    ,cash_overdraw_cancel_flag -- 现金透支便利无条件可撤销标志
    ,sec_items_issue_no -- 资产证券化发行编号
    ,fm_hold_ratio -- 资管产品持有比例
    ,fm_fin_product_amt -- 资管产品所有者权益总额
    ,fm_lvg -- 资管产品杠杆率
    ,fm_rwa_ccp -- 资管产品CCP风险加权资产
    ,fm_rwa_cva -- 资管产品CVA
    ,fm_link_get_way -- 资管产品基础资产获取方式
    ,fm_flag -- 资管产品标志
    ,fm_product_type -- 资管产品类别
    ,ead_orig -- 原始风险暴露
    ,ccf -- 表外信用风险转换系数
    ,ead_afterccf -- 转换后的风险暴露
    ,ead_afterpro -- 扣减准备金后的风险暴露
    ,rw -- 权重
    ,net_settlement_id -- 净额结算标识
    ,net_settlement_no -- 净额结算合约编号
    ,crm_no -- 缓释物编号
    ,crm_name -- 缓释物名称
    ,bank_crm_type_cd -- 银行缓释工具类型代码
    ,bank_crm_type_name -- 银行缓释工具类型名称
    ,bis_crm_btype_name -- 监管缓释工具大类名称
    ,bis_crm_type_name -- 监管缓释工具类型名称
    ,bis_crm_btype_cd -- 监管缓释工具大类代码
    ,bis_crm_type_cd -- 监管缓释工具类型代码
    ,crm_ccy_cd -- 缓释币种代码
    ,crm_bis_ccy_cd -- 缓释物计量币种代码
    ,crm_amt -- 缓释金额
    ,crm_amt_rmb -- 缓释金额折本币
    ,crm_orig_maturity -- 缓释原始期限
    ,crm_rema_maturity -- 缓释剩余期限
    ,crm_cust_no -- 缓释客户编号
    ,crm_cust_name -- 缓释客户名称
    ,crm_ccp_type_cd -- 缓释交易对手类型代码
    ,crm_sp_rating_cd -- 缓释交易对手评级
    ,crm_scra_rating -- 缓释交易对手SCRA评级
    ,crm_reg_country -- 缓释注册国
    ,crm_sov_sp_rating_cd -- 缓释注册国标普评级代码
    ,crm_bond_pay_attr_id -- 地方债属性标识
    ,crm_amt_split -- 缓释金额拆分
    ,crm_ccy_mis_coeff -- 缓释币种错配折扣系数
    ,crm_mat_mis_coeff -- 缓释期限错配系数
    ,crm_floor_mis_coeff -- 底线折扣系数
    ,crm_rw -- 缓释权重
    ,after_crmrw -- 缓释后风险权重
    ,after_crmead -- 缓释后风险暴露
    ,after_miti_rwa -- 缓释后的风险加权资产
    ,report_no -- 报表编号
    ,report_line_no -- 报表栏位号
    ,load_date -- 加载日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_date -- 数据日期
    ,version_no -- 计量版本号
    ,loan_ref_crm_split_seq -- 缓释拆分序号
    ,scenario_no -- 业务情景编号 10-标准法 20-资产证券化 30-证券融资 40-场外衍生品 50-资管产品
    ,sa_calculate_id -- 标准法计量方法标识
    ,sa_calculate_name -- 标准法计量方法名称
    ,corporation -- 法人实体编号
    ,bank_level -- 银行档次
    ,consol_corporation -- 并表集团机构编号
    ,consol_bank_level -- 并表银行档次
    ,loan_ref_no -- 债项编号
    ,loan_ref_desc -- 债项描述
    ,contract_no -- 合同编号
    ,main_grnt_mth_cd -- 主要担保方式代码
    ,adt_grnt_mth_ind -- 附加担保方式
    ,due_id -- 债项号
    ,src_system_id -- 来源系统标识
    ,org_partent_no -- 分行管户机构
    ,org_partent_name -- 分行机构名称
    ,org_no -- 管户机构
    ,org_name -- 机构名称
    ,org_order_no -- 机构排序号
    ,accorg_partent_no -- 分行账务机构
    ,accorg_partent_name -- 分行账务机构名称
    ,accorg_no -- 账务机构
    ,accorg_name -- 账务机构名称
    ,bank_region_cd -- 银行地域代码
    ,bis_region_cd -- 监管区域代码
    ,bis_region_name -- 监管区域名称
    ,loan_ref_inv_indu_cd -- 投向行业代码
    ,cust_industry_cd -- 客户所属行业代码
    ,bis_industry_cd -- 计量行业代码
    ,bis_industry_name -- 计量行业名称
    ,five_class_cd -- 五级分类代码
    ,five_class_name -- 五级分类名称
    ,product_cd -- 产品代码
    ,product_name -- 产品名称
    ,bis_product_type_cd -- 监管产品类型代码
    ,bis_product_type_name -- 监管产品类型名称
    ,bis_product_btype_cd -- 监管产品大类代码
    ,bis_product_btype_name -- 监管产品大类名称
    ,sa_exp_class_cd -- 标准法风险暴露分类
    ,sa_exp_class_name -- 标准法风险暴露分类名称
    ,sa_exp_sub_class_cd -- 标准法风险暴露大类
    ,sa_exp_sub_class_name -- 标准法风险暴露大类名称
    ,item_off_ccf_btype_cd -- 表外CCF项目大类代码
    ,item_off_ccf_btype_name -- 表外CCF项目大类名称
    ,item_off_ccf_type_cd -- 表外CCF项目类型代码
    ,item_off_ccf_type_name -- 表外CCF项目类型名称
    ,business_line_cd -- 业务条线代码
    ,business_line_name -- 业务条线名称
    ,buss_type_cd -- 业务类型
    ,buss_type_name -- 业务名称
    ,start_date -- 开始日期
    ,due_date -- 到期日期
    ,orig_maturity -- 原始期限
    ,rema_maturity -- 剩余期限
    ,overdue_days -- 逾期天数
    ,std_default_flag -- 权重法违约标志
    ,on_off_id -- 表内外资产标志
    ,on_off_name -- 表内外资产名称
    ,seniority_id -- 优先债权标识
    ,seniority_name -- 优先标识名称
    ,book_type_id -- 账簿类型
    ,book_type_name -- 账簿名称
    ,bank_ccy_cd -- 银行币种代码
    ,bis_ccy_cd -- 计量币种代码
    ,bis_ccy_name -- 计量币种名称
    ,bookkeep_cny_flag -- 记账本位币计价标志
    ,ccy_mismatch_flag -- 币种错配标志
    ,exchange_rate -- 汇率
    ,subject_cd -- 本金科目代码
    ,subject_name -- 本金科目名称
    ,asset_balance -- 资产余额
    ,accrued_subject_cd -- 应计利息科目
    ,accrued_subject_name -- 应计利息科目名称
    ,accrued_int -- 应计利息
    ,receivable_subject_cd -- 应收利息科目
    ,receivable_subject_name -- 应收利息科目名称
    ,receivable_int -- 应收利息
    ,intadj_subject_cd -- 利息调整科目
    ,intadj_subject_name -- 利息调整科目名称
    ,int_adj -- 利息调整
    ,fairchange_subject_cd -- 公允价值变动科目
    ,fairchange_subject_name -- 公允价值变动科目名称
    ,fairvalue_changes -- 公允价值变动
    ,depreamor_subject_cd -- 折旧科目
    ,depreamor_subject_name -- 折旧科目名称
    ,depre_amortizat -- 折旧金额
    ,other_subject_cd -- 其他科目
    ,other_subject_name -- 其他科目名称
    ,other_amt -- 其他金额
    ,provision_subject_cd -- 准备金科目代码
    ,provision_subject_name -- 准备金科目名称
    ,provision -- 准备金
    ,provesion_ratio -- 准备金计提比例
    ,loan_flag -- 贷款标志
    ,mcr_flag -- 信用风险计量标志
    ,cross_border_trade_flag -- 因跨境货物贸易标志
    ,accept_credit_self_flag -- 自开信用证标志
    ,real_estate_type_cd -- 房地产风险暴露类型代码
    ,ltv -- LTV规则
    ,accept_discount_self_flag -- 自承自贴标志
    ,spe_lending_flag -- 专业贷款标志
    ,spe_lending_type -- 专业贷款分类
    ,operation_pf_flag -- 项目融资运营阶段标识
    ,bond_for_acquir_non_perf_flag -- 为收购国有银行不良贷款而定向发行的债券
    ,bond_pay_attr_id -- 地方债偿还属性标志
    ,guaranteed_bond_flag -- 合格担保债券标志
    ,sec_sp_rating_cd -- 债券标普评级
    ,account_classification -- 金融资产分类
    ,cancel_flag -- 随时可撤销标志
    ,off_asset_unmeasured_flag -- 表外资产不计量标志
    ,unused_prl_tmeet_flag -- 符合标准的未使用额度标志
    ,equity_invest_attr_identi -- 股权投资属性
    ,capital_type_cd -- 金融机构股权投资类别 10-并表 20-大额少数 30-小额少数
    ,core_one_capital_deduction -- 核心一级资本扣除金额
    ,oth_one_capital_deduction -- 其他核心一级资本扣除金额
    ,two_capital_deduction -- 二级资本扣除金额
    ,core_one_capital -- 股权投资余额，其中核心一级资本
    ,oth_one_capital -- 股权投资余额，其中其他核心一级资本
    ,two_capital -- 股权投资余额，其中二级资本
    ,bus_real_property_type_cd -- 抵债资产类别
    ,deal_trade_days -- 自合约结算日起延迟交易的交易日数
    ,cust_mcr_flag -- 交易对手信用风险计量标志
    ,ownership_transfer_flag -- 所有权发生转移标志
    ,derivatives_type_id -- 衍生工具类型标识
    ,over_derivatives_flag -- 场外衍生工具标志
    ,underlying_asset_qlf_flag -- 信用衍生品标的合格标志
    ,add_on -- 潜在风险暴露的附加因子
    ,certificate -- 零售客户证件号
    ,retail_cust_income_ccy_cd -- 零售客户主要收入币种代码
    ,cust_no -- 客户号
    ,cust_name -- 客户名称
    ,ccp_type_cd -- 交易对手类型代码
    ,ccp_type_name -- 交易对手类型名称
    ,ccp_btype_cd -- 交易对手大类代码
    ,ccp_btype_name -- 交易对手大类名称
    ,bank_country_cd -- 银行注册国
    ,bis_country_cd -- 计量注册国家代码
    ,bis_country_name -- 注册国名称
    ,sov_sp_lt_rating_cd -- 注册国标普评级代码
    ,cust_sp_lt_rating_cd -- 客户标普评级
    ,scra_rating -- SCRA评级
    ,int_trade_flag -- 内部交易标志
    ,solo_int_trade_flag -- 法人内部交易标志
    ,sec_flag -- 资产证券化标志
    ,sec_item_no -- 资产证券化项目标志
    ,sec_role_id -- 证券化角色标识 1:发起机构自持 2:投资机构 3：其他从事资产证券化参与机构
    ,sec_category_id -- 证券化类别标识
    ,sec_exposure_type_id -- 证券化暴露类型标识
    ,asset_sec_cr_transfer_flag -- 证券化售出资产是否实现信用风险转移标志
    ,anew_asset_sec_flag -- 再资产证券化标志
    ,npl_sec_flag -- 不良资产证券化标志
    ,sec_priority_rating_flag -- 证券化优先档次标志
    ,sec_prudent_mng_flag -- 证券化审慎管理标志
    ,sec_pool_risk_type_cd -- 基础资产风险类型 1-合格不良资产证券化 2-不合格不良资产证券化 0-正常资产
    ,sec_stc_flag -- 资产证券化简单透明可比标志
    ,sec_off_exposure_id -- 证券化表外暴露标识
    ,sec_pool_rwa -- 基础资产池RWA
    ,cash_overdraw_cancel_flag -- 现金透支便利无条件可撤销标志
    ,sec_items_issue_no -- 资产证券化发行编号
    ,fm_hold_ratio -- 资管产品持有比例
    ,fm_fin_product_amt -- 资管产品所有者权益总额
    ,fm_lvg -- 资管产品杠杆率
    ,fm_rwa_ccp -- 资管产品CCP风险加权资产
    ,fm_rwa_cva -- 资管产品CVA
    ,fm_link_get_way -- 资管产品基础资产获取方式
    ,fm_flag -- 资管产品标志
    ,fm_product_type -- 资管产品类别
    ,ead_orig -- 原始风险暴露
    ,ccf -- 表外信用风险转换系数
    ,ead_afterccf -- 转换后的风险暴露
    ,ead_afterpro -- 扣减准备金后的风险暴露
    ,rw -- 权重
    ,net_settlement_id -- 净额结算标识
    ,net_settlement_no -- 净额结算合约编号
    ,crm_no -- 缓释物编号
    ,crm_name -- 缓释物名称
    ,bank_crm_type_cd -- 银行缓释工具类型代码
    ,bank_crm_type_name -- 银行缓释工具类型名称
    ,bis_crm_btype_name -- 监管缓释工具大类名称
    ,bis_crm_type_name -- 监管缓释工具类型名称
    ,bis_crm_btype_cd -- 监管缓释工具大类代码
    ,bis_crm_type_cd -- 监管缓释工具类型代码
    ,crm_ccy_cd -- 缓释币种代码
    ,crm_bis_ccy_cd -- 缓释物计量币种代码
    ,crm_amt -- 缓释金额
    ,crm_amt_rmb -- 缓释金额折本币
    ,crm_orig_maturity -- 缓释原始期限
    ,crm_rema_maturity -- 缓释剩余期限
    ,crm_cust_no -- 缓释客户编号
    ,crm_cust_name -- 缓释客户名称
    ,crm_ccp_type_cd -- 缓释交易对手类型代码
    ,crm_sp_rating_cd -- 缓释交易对手评级
    ,crm_scra_rating -- 缓释交易对手SCRA评级
    ,crm_reg_country -- 缓释注册国
    ,crm_sov_sp_rating_cd -- 缓释注册国标普评级代码
    ,crm_bond_pay_attr_id -- 地方债属性标识
    ,crm_amt_split -- 缓释金额拆分
    ,crm_ccy_mis_coeff -- 缓释币种错配折扣系数
    ,crm_mat_mis_coeff -- 缓释期限错配系数
    ,crm_floor_mis_coeff -- 底线折扣系数
    ,crm_rw -- 缓释权重
    ,after_crmrw -- 缓释后风险权重
    ,after_crmead -- 缓释后风险暴露
    ,after_miti_rwa -- 缓释后的风险加权资产
    ,report_no -- 报表编号
    ,report_line_no -- 报表栏位号
    ,load_date -- 加载日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rwas_mr_sa_rwa_result_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rwas_mr_sa_rwa_result_detail exchange partition p_${batch_date} with table ${iol_schema}.rwas_mr_sa_rwa_result_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rwas_mr_sa_rwa_result_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rwas_mr_sa_rwa_result_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rwas_mr_sa_rwa_result_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);