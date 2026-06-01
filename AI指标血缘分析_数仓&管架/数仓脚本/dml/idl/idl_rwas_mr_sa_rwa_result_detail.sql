/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_rwas_mr_sa_rwa_result_detail
CreateDate: 20240807
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.rwas_mr_sa_rwa_result_detail drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.rwas_mr_sa_rwa_result_detail add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.rwas_mr_sa_rwa_result_detail (
etl_dt  --数据日期
,data_date  --数据日期
,version_no  --计量版本号
,loan_ref_crm_split_seq  --缓释拆分序号
,scenario_no  --业务情景编号 10-标准法 20-资产证券化 30-证券融资 40-场外衍生品 50-资管产品
,sa_calculate_id  --标准法计量方法标识
,sa_calculate_name  --标准法计量方法名称
,corporation  --法人实体编号
,bank_level  --银行档次
,consol_corporation  --并表集团机构编号
,consol_bank_level  --并表银行档次
,loan_ref_no  --债项编号
,loan_ref_desc  --债项描述
,contract_no  --合同编号
,main_grnt_mth_cd  --主要担保方式代码
,adt_grnt_mth_ind  --附加担保方式
,due_id  --债项号
,src_system_id  --来源系统标识
,org_partent_no  --分行管户机构
,org_partent_name  --分行机构名称
,org_no  --管户机构
,org_name  --机构名称
,org_order_no  --机构排序号
,accorg_partent_no  --分行账务机构
,accorg_partent_name  --分行账务机构名称
,accorg_no  --账务机构
,accorg_name  --账务机构名称
,bank_region_cd  --银行地域代码
,bis_region_cd  --监管区域代码
,bis_region_name  --监管区域名称
,loan_ref_inv_indu_cd  --投向行业代码
,cust_industry_cd  --客户所属行业代码
,bis_industry_cd  --计量行业代码
,bis_industry_name  --计量行业名称
,five_class_cd  --五级分类代码
,five_class_name  --五级分类名称
,product_cd  --产品代码
,product_name  --产品名称
,bis_product_type_cd  --监管产品类型代码
,bis_product_type_name  --监管产品类型名称
,bis_product_btype_cd  --监管产品大类代码
,bis_product_btype_name  --监管产品大类名称
,sa_exp_class_cd  --标准法风险暴露分类
,sa_exp_class_name  --标准法风险暴露分类名称
,sa_exp_sub_class_cd  --标准法风险暴露大类
,sa_exp_sub_class_name  --标准法风险暴露大类名称
,item_off_ccf_btype_cd  --表外ccf项目大类代码
,item_off_ccf_btype_name  --表外ccf项目大类名称
,item_off_ccf_type_cd  --表外ccf项目类型代码
,item_off_ccf_type_name  --表外ccf项目类型名称
,business_line_cd  --业务条线代码
,business_line_name  --业务条线名称
,buss_type_cd  --业务类型
,buss_type_name  --业务名称
,start_date  --开始日期
,due_date  --到期日期
,orig_maturity  --原始期限
,rema_maturity  --剩余期限
,overdue_days  --逾期天数
,std_default_flag  --权重法违约标志
,on_off_id  --表内外资产标志
,on_off_name  --表内外资产名称
,seniority_id  --优先债权标识
,seniority_name  --优先标识名称
,book_type_id  --账簿类型
,book_type_name  --账簿名称
,bank_ccy_cd  --银行币种代码
,bis_ccy_cd  --计量币种代码
,bis_ccy_name  --计量币种名称
,bookkeep_cny_flag  --记账本位币计价标志
,ccy_mismatch_flag  --币种错配标志
,exchange_rate  --汇率
,subject_cd  --本金科目代码
,subject_name  --本金科目名称
,asset_balance  --资产余额
,accrued_subject_cd  --应计利息科目
,accrued_subject_name  --应计利息科目名称
,accrued_int  --应计利息
,receivable_subject_cd  --应收利息科目
,receivable_subject_name  --应收利息科目名称
,receivable_int  --应收利息
,intadj_subject_cd  --利息调整科目
,intadj_subject_name  --利息调整科目名称
,int_adj  --利息调整
,fairchange_subject_cd  --公允价值变动科目
,fairchange_subject_name  --公允价值变动科目名称
,fairvalue_changes  --公允价值变动
,depreamor_subject_cd  --折旧科目
,depreamor_subject_name  --折旧科目名称
,depre_amortizat  --折旧金额
,other_subject_cd  --其他科目
,other_subject_name  --其他科目名称
,other_amt  --其他金额
,provision_subject_cd  --准备金科目代码
,provision_subject_name  --准备金科目名称
,provision  --准备金
,provesion_ratio  --准备金计提比例
,loan_flag  --贷款标志
,mcr_flag  --信用风险计量标志
,cross_border_trade_flag  --因跨境货物贸易标志
,accept_credit_self_flag  --自开信用证标志
,real_estate_type_cd  --房地产风险暴露类型代码
,ltv  --ltv规则
,accept_discount_self_flag  --自承自贴标志
,spe_lending_flag  --专业贷款标志
,spe_lending_type  --专业贷款分类
,operation_pf_flag  --项目融资运营阶段标识
,bond_for_acquir_non_perf_flag  --为收购国有银行不良贷款而定向发行的债券
,bond_pay_attr_id  --地方债偿还属性标志
,guaranteed_bond_flag  --合格担保债券标志
,sec_sp_rating_cd  --债券标普评级
,account_classification  --金融资产分类
,cancel_flag  --随时可撤销标志
,off_asset_unmeasured_flag  --表外资产不计量标志
,unused_prl_tmeet_flag  --符合标准的未使用额度标志
,equity_invest_attr_identi  --股权投资属性
,capital_type_cd  --金融机构股权投资类别 10-并表 20-大额少数 30-小额少数
,core_one_capital_deduction  --核心一级资本扣除金额
,oth_one_capital_deduction  --其他核心一级资本扣除金额
,two_capital_deduction  --二级资本扣除金额
,core_one_capital  --股权投资余额，其中核心一级资本
,oth_one_capital  --股权投资余额，其中其他核心一级资本
,two_capital  --股权投资余额，其中二级资本
,bus_real_property_type_cd  --抵债资产类别
,deal_trade_days  --自合约结算日起延迟交易的交易日数
,cust_mcr_flag  --交易对手信用风险计量标志
,ownership_transfer_flag  --所有权发生转移标志
,derivatives_type_id  --衍生工具类型标识
,over_derivatives_flag  --场外衍生工具标志
,underlying_asset_qlf_flag  --信用衍生品标的合格标志
,add_on  --潜在风险暴露的附加因子
,certificate  --零售客户证件号
,retail_cust_income_ccy_cd  --零售客户主要收入币种代码
,cust_no  --客户号
,cust_name  --客户名称
,ccp_type_cd  --交易对手类型代码
,ccp_type_name  --交易对手类型名称
,ccp_btype_cd  --交易对手大类代码
,ccp_btype_name  --交易对手大类名称
,bank_country_cd  --银行注册国
,bis_country_cd  --计量注册国家代码
,bis_country_name  --注册国名称
,sov_sp_lt_rating_cd  --注册国标普评级代码
,cust_sp_lt_rating_cd  --客户标普评级
,scra_rating  --scra评级
,int_trade_flag  --内部交易标志
,solo_int_trade_flag  --法人内部交易标志
,sec_flag  --资产证券化标志
,sec_item_no  --资产证券化项目标志
,sec_role_id  --证券化角色标识 1:发起机构自持 2:投资机构 3：其他从事资产证券化参与机构
,sec_category_id  --证券化类别标识
,sec_exposure_type_id  --证券化暴露类型标识
,asset_sec_cr_transfer_flag  --证券化售出资产是否实现信用风险转移标志
,anew_asset_sec_flag  --再资产证券化标志
,npl_sec_flag  --不良资产证券化标志
,sec_priority_rating_flag  --证券化优先档次标志
,sec_prudent_mng_flag  --证券化审慎管理标志
,sec_pool_risk_type_cd  --基础资产风险类型 1-合格不良资产证券化 2-不合格不良资产证券化 0-正常资产
,sec_stc_flag  --资产证券化简单透明可比标志
,sec_off_exposure_id  --证券化表外暴露标识
,sec_pool_rwa  --基础资产池rwa
,cash_overdraw_cancel_flag  --现金透支便利无条件可撤销标志
,sec_items_issue_no  --资产证券化发行编号
,fm_hold_ratio  --资管产品持有比例
,fm_fin_product_amt  --资管产品所有者权益总额
,fm_lvg  --资管产品杠杆率
,fm_rwa_ccp  --资管产品ccp风险加权资产
,fm_rwa_cva  --资管产品cva
,fm_link_get_way  --资管产品基础资产获取方式
,fm_flag  --资管产品标志
,fm_product_type  --资管产品类别
,ead_orig  --原始风险暴露
,ccf  --表外信用风险转换系数
,ead_afterccf  --转换后的风险暴露
,ead_afterpro  --扣减准备金后的风险暴露
,rw  --权重
,net_settlement_id  --净额结算标识
,net_settlement_no  --净额结算合约编号
,crm_no  --缓释物编号
,crm_name  --缓释物名称
,bank_crm_type_cd  --银行缓释工具类型代码
,bank_crm_type_name  --银行缓释工具类型名称
,bis_crm_btype_name  --监管缓释工具大类名称
,bis_crm_type_name  --监管缓释工具类型名称
,bis_crm_btype_cd  --监管缓释工具大类代码
,bis_crm_type_cd  --监管缓释工具类型代码
,crm_ccy_cd  --缓释币种代码
,crm_bis_ccy_cd  --缓释物计量币种代码
,crm_amt  --缓释金额
,crm_amt_rmb  --缓释金额折本币
,crm_orig_maturity  --缓释原始期限
,crm_rema_maturity  --缓释剩余期限
,crm_cust_no  --缓释客户编号
,crm_cust_name  --缓释客户名称
,crm_ccp_type_cd  --缓释交易对手类型代码
,crm_sp_rating_cd  --缓释交易对手评级
,crm_scra_rating  --缓释交易对手scra评级
,crm_reg_country  --缓释注册国
,crm_sov_sp_rating_cd  --缓释注册国标普评级代码
,crm_bond_pay_attr_id  --地方债属性标识
,crm_amt_split  --缓释金额拆分
,crm_ccy_mis_coeff  --缓释币种错配折扣系数
,crm_mat_mis_coeff  --缓释期限错配系数
,crm_floor_mis_coeff  --底线折扣系数
,crm_rw  --缓释权重
,after_crmrw  --缓释后风险权重
,after_crmead  --缓释后风险暴露
,after_miti_rwa  --缓释后的风险加权资产
,report_no  --报表编号
,report_line_no  --报表栏位号
,load_date  --加载日期

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,t1.data_date as data_date --数据日期
,replace(replace(t1.version_no,chr(13),''),chr(10),'') as version_no --计量版本号
,t1.loan_ref_crm_split_seq as loan_ref_crm_split_seq --缓释拆分序号
,replace(replace(t1.scenario_no,chr(13),''),chr(10),'') as scenario_no --业务情景编号 10-标准法 20-资产证券化 30-证券融资 40-场外衍生品 50-资管产品
,replace(replace(t1.sa_calculate_id,chr(13),''),chr(10),'') as sa_calculate_id --标准法计量方法标识
,replace(replace(t1.sa_calculate_name,chr(13),''),chr(10),'') as sa_calculate_name --标准法计量方法名称
,replace(replace(t1.corporation,chr(13),''),chr(10),'') as corporation --法人实体编号
,replace(replace(t1.bank_level,chr(13),''),chr(10),'') as bank_level --银行档次
,replace(replace(t1.consol_corporation,chr(13),''),chr(10),'') as consol_corporation --并表集团机构编号
,replace(replace(t1.consol_bank_level,chr(13),''),chr(10),'') as consol_bank_level --并表银行档次
,replace(replace(t1.loan_ref_no,chr(13),''),chr(10),'') as loan_ref_no --债项编号
,replace(replace(t1.loan_ref_desc,chr(13),''),chr(10),'') as loan_ref_desc --债项描述
,replace(replace(t1.contract_no,chr(13),''),chr(10),'') as contract_no --合同编号
,replace(replace(t1.main_grnt_mth_cd,chr(13),''),chr(10),'') as main_grnt_mth_cd --主要担保方式代码
,replace(replace(t1.adt_grnt_mth_ind,chr(13),''),chr(10),'') as adt_grnt_mth_ind --附加担保方式
,replace(replace(t1.due_id,chr(13),''),chr(10),'') as due_id --债项号
,replace(replace(t1.src_system_id,chr(13),''),chr(10),'') as src_system_id --来源系统标识
,replace(replace(t1.org_partent_no,chr(13),''),chr(10),'') as org_partent_no --分行管户机构
,replace(replace(t1.org_partent_name,chr(13),''),chr(10),'') as org_partent_name --分行机构名称
,replace(replace(t1.org_no,chr(13),''),chr(10),'') as org_no --管户机构
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name --机构名称
,t1.org_order_no as org_order_no --机构排序号
,replace(replace(t1.accorg_partent_no,chr(13),''),chr(10),'') as accorg_partent_no --分行账务机构
,replace(replace(t1.accorg_partent_name,chr(13),''),chr(10),'') as accorg_partent_name --分行账务机构名称
,replace(replace(t1.accorg_no,chr(13),''),chr(10),'') as accorg_no --账务机构
,replace(replace(t1.accorg_name,chr(13),''),chr(10),'') as accorg_name --账务机构名称
,replace(replace(t1.bank_region_cd,chr(13),''),chr(10),'') as bank_region_cd --银行地域代码
,replace(replace(t1.bis_region_cd,chr(13),''),chr(10),'') as bis_region_cd --监管区域代码
,replace(replace(t1.bis_region_name,chr(13),''),chr(10),'') as bis_region_name --监管区域名称
,replace(replace(t1.loan_ref_inv_indu_cd,chr(13),''),chr(10),'') as loan_ref_inv_indu_cd --投向行业代码
,replace(replace(t1.cust_industry_cd,chr(13),''),chr(10),'') as cust_industry_cd --客户所属行业代码
,replace(replace(t1.bis_industry_cd,chr(13),''),chr(10),'') as bis_industry_cd --计量行业代码
,replace(replace(t1.bis_industry_name,chr(13),''),chr(10),'') as bis_industry_name --计量行业名称
,replace(replace(t1.five_class_cd,chr(13),''),chr(10),'') as five_class_cd --五级分类代码
,replace(replace(t1.five_class_name,chr(13),''),chr(10),'') as five_class_name --五级分类名称
,replace(replace(t1.product_cd,chr(13),''),chr(10),'') as product_cd --产品代码
,replace(replace(t1.product_name,chr(13),''),chr(10),'') as product_name --产品名称
,replace(replace(t1.bis_product_type_cd,chr(13),''),chr(10),'') as bis_product_type_cd --监管产品类型代码
,replace(replace(t1.bis_product_type_name,chr(13),''),chr(10),'') as bis_product_type_name --监管产品类型名称
,replace(replace(t1.bis_product_btype_cd,chr(13),''),chr(10),'') as bis_product_btype_cd --监管产品大类代码
,replace(replace(t1.bis_product_btype_name,chr(13),''),chr(10),'') as bis_product_btype_name --监管产品大类名称
,replace(replace(t1.sa_exp_class_cd,chr(13),''),chr(10),'') as sa_exp_class_cd --标准法风险暴露分类
,replace(replace(t1.sa_exp_class_name,chr(13),''),chr(10),'') as sa_exp_class_name --标准法风险暴露分类名称
,replace(replace(t1.sa_exp_sub_class_cd,chr(13),''),chr(10),'') as sa_exp_sub_class_cd --标准法风险暴露大类
,replace(replace(t1.sa_exp_sub_class_name,chr(13),''),chr(10),'') as sa_exp_sub_class_name --标准法风险暴露大类名称
,replace(replace(t1.item_off_ccf_btype_cd,chr(13),''),chr(10),'') as item_off_ccf_btype_cd --表外ccf项目大类代码
,replace(replace(t1.item_off_ccf_btype_name,chr(13),''),chr(10),'') as item_off_ccf_btype_name --表外ccf项目大类名称
,replace(replace(t1.item_off_ccf_type_cd,chr(13),''),chr(10),'') as item_off_ccf_type_cd --表外ccf项目类型代码
,replace(replace(t1.item_off_ccf_type_name,chr(13),''),chr(10),'') as item_off_ccf_type_name --表外ccf项目类型名称
,replace(replace(t1.business_line_cd,chr(13),''),chr(10),'') as business_line_cd --业务条线代码
,replace(replace(t1.business_line_name,chr(13),''),chr(10),'') as business_line_name --业务条线名称
,replace(replace(t1.buss_type_cd,chr(13),''),chr(10),'') as buss_type_cd --业务类型
,replace(replace(t1.buss_type_name,chr(13),''),chr(10),'') as buss_type_name --业务名称
,t1.start_date as start_date --开始日期
,t1.due_date as due_date --到期日期
,t1.orig_maturity as orig_maturity --原始期限
,t1.rema_maturity as rema_maturity --剩余期限
,t1.overdue_days as overdue_days --逾期天数
,replace(replace(t1.std_default_flag,chr(13),''),chr(10),'') as std_default_flag --权重法违约标志
,replace(replace(t1.on_off_id,chr(13),''),chr(10),'') as on_off_id --表内外资产标志
,replace(replace(t1.on_off_name,chr(13),''),chr(10),'') as on_off_name --表内外资产名称
,replace(replace(t1.seniority_id,chr(13),''),chr(10),'') as seniority_id --优先债权标识
,replace(replace(t1.seniority_name,chr(13),''),chr(10),'') as seniority_name --优先标识名称
,replace(replace(t1.book_type_id,chr(13),''),chr(10),'') as book_type_id --账簿类型
,replace(replace(t1.book_type_name,chr(13),''),chr(10),'') as book_type_name --账簿名称
,replace(replace(t1.bank_ccy_cd,chr(13),''),chr(10),'') as bank_ccy_cd --银行币种代码
,replace(replace(t1.bis_ccy_cd,chr(13),''),chr(10),'') as bis_ccy_cd --计量币种代码
,replace(replace(t1.bis_ccy_name,chr(13),''),chr(10),'') as bis_ccy_name --计量币种名称
,replace(replace(t1.bookkeep_cny_flag,chr(13),''),chr(10),'') as bookkeep_cny_flag --记账本位币计价标志
,replace(replace(t1.ccy_mismatch_flag,chr(13),''),chr(10),'') as ccy_mismatch_flag --币种错配标志
,t1.exchange_rate as exchange_rate --汇率
,replace(replace(t1.subject_cd,chr(13),''),chr(10),'') as subject_cd --本金科目代码
,replace(replace(t1.subject_name,chr(13),''),chr(10),'') as subject_name --本金科目名称
,t1.asset_balance as asset_balance --资产余额
,replace(replace(t1.accrued_subject_cd,chr(13),''),chr(10),'') as accrued_subject_cd --应计利息科目
,replace(replace(t1.accrued_subject_name,chr(13),''),chr(10),'') as accrued_subject_name --应计利息科目名称
,t1.accrued_int as accrued_int --应计利息
,replace(replace(t1.receivable_subject_cd,chr(13),''),chr(10),'') as receivable_subject_cd --应收利息科目
,replace(replace(t1.receivable_subject_name,chr(13),''),chr(10),'') as receivable_subject_name --应收利息科目名称
,t1.receivable_int as receivable_int --应收利息
,replace(replace(t1.intadj_subject_cd,chr(13),''),chr(10),'') as intadj_subject_cd --利息调整科目
,replace(replace(t1.intadj_subject_name,chr(13),''),chr(10),'') as intadj_subject_name --利息调整科目名称
,t1.int_adj as int_adj --利息调整
,replace(replace(t1.fairchange_subject_cd,chr(13),''),chr(10),'') as fairchange_subject_cd --公允价值变动科目
,replace(replace(t1.fairchange_subject_name,chr(13),''),chr(10),'') as fairchange_subject_name --公允价值变动科目名称
,t1.fairvalue_changes as fairvalue_changes --公允价值变动
,replace(replace(t1.depreamor_subject_cd,chr(13),''),chr(10),'') as depreamor_subject_cd --折旧科目
,replace(replace(t1.depreamor_subject_name,chr(13),''),chr(10),'') as depreamor_subject_name --折旧科目名称
,t1.depre_amortizat as depre_amortizat --折旧金额
,replace(replace(t1.other_subject_cd,chr(13),''),chr(10),'') as other_subject_cd --其他科目
,replace(replace(t1.other_subject_name,chr(13),''),chr(10),'') as other_subject_name --其他科目名称
,t1.other_amt as other_amt --其他金额
,replace(replace(t1.provision_subject_cd,chr(13),''),chr(10),'') as provision_subject_cd --准备金科目代码
,replace(replace(t1.provision_subject_name,chr(13),''),chr(10),'') as provision_subject_name --准备金科目名称
,t1.provision as provision --准备金
,t1.provesion_ratio as provesion_ratio --准备金计提比例
,replace(replace(t1.loan_flag,chr(13),''),chr(10),'') as loan_flag --贷款标志
,replace(replace(t1.mcr_flag,chr(13),''),chr(10),'') as mcr_flag --信用风险计量标志
,replace(replace(t1.cross_border_trade_flag,chr(13),''),chr(10),'') as cross_border_trade_flag --因跨境货物贸易标志
,replace(replace(t1.accept_credit_self_flag,chr(13),''),chr(10),'') as accept_credit_self_flag --自开信用证标志
,replace(replace(t1.real_estate_type_cd,chr(13),''),chr(10),'') as real_estate_type_cd --房地产风险暴露类型代码
,t1.ltv as ltv --ltv规则
,replace(replace(t1.accept_discount_self_flag,chr(13),''),chr(10),'') as accept_discount_self_flag --自承自贴标志
,replace(replace(t1.spe_lending_flag,chr(13),''),chr(10),'') as spe_lending_flag --专业贷款标志
,replace(replace(t1.spe_lending_type,chr(13),''),chr(10),'') as spe_lending_type --专业贷款分类
,replace(replace(t1.operation_pf_flag,chr(13),''),chr(10),'') as operation_pf_flag --项目融资运营阶段标识
,replace(replace(t1.bond_for_acquir_non_perf_flag,chr(13),''),chr(10),'') as bond_for_acquir_non_perf_flag --为收购国有银行不良贷款而定向发行的债券
,replace(replace(t1.bond_pay_attr_id,chr(13),''),chr(10),'') as bond_pay_attr_id --地方债偿还属性标志
,replace(replace(t1.guaranteed_bond_flag,chr(13),''),chr(10),'') as guaranteed_bond_flag --合格担保债券标志
,replace(replace(t1.sec_sp_rating_cd,chr(13),''),chr(10),'') as sec_sp_rating_cd --债券标普评级
,replace(replace(t1.account_classification,chr(13),''),chr(10),'') as account_classification --金融资产分类
,replace(replace(t1.cancel_flag,chr(13),''),chr(10),'') as cancel_flag --随时可撤销标志
,replace(replace(t1.off_asset_unmeasured_flag,chr(13),''),chr(10),'') as off_asset_unmeasured_flag --表外资产不计量标志
,replace(replace(t1.unused_prl_tmeet_flag,chr(13),''),chr(10),'') as unused_prl_tmeet_flag --符合标准的未使用额度标志
,replace(replace(t1.equity_invest_attr_identi,chr(13),''),chr(10),'') as equity_invest_attr_identi --股权投资属性
,replace(replace(t1.capital_type_cd,chr(13),''),chr(10),'') as capital_type_cd --金融机构股权投资类别 10-并表 20-大额少数 30-小额少数
,t1.core_one_capital_deduction as core_one_capital_deduction --核心一级资本扣除金额
,t1.oth_one_capital_deduction as oth_one_capital_deduction --其他核心一级资本扣除金额
,t1.two_capital_deduction as two_capital_deduction --二级资本扣除金额
,t1.core_one_capital as core_one_capital --股权投资余额，其中核心一级资本
,t1.oth_one_capital as oth_one_capital --股权投资余额，其中其他核心一级资本
,t1.two_capital as two_capital --股权投资余额，其中二级资本
,replace(replace(t1.bus_real_property_type_cd,chr(13),''),chr(10),'') as bus_real_property_type_cd --抵债资产类别
,t1.deal_trade_days as deal_trade_days --自合约结算日起延迟交易的交易日数
,replace(replace(t1.cust_mcr_flag,chr(13),''),chr(10),'') as cust_mcr_flag --交易对手信用风险计量标志
,replace(replace(t1.ownership_transfer_flag,chr(13),''),chr(10),'') as ownership_transfer_flag --所有权发生转移标志
,replace(replace(t1.derivatives_type_id,chr(13),''),chr(10),'') as derivatives_type_id --衍生工具类型标识
,replace(replace(t1.over_derivatives_flag,chr(13),''),chr(10),'') as over_derivatives_flag --场外衍生工具标志
,replace(replace(t1.underlying_asset_qlf_flag,chr(13),''),chr(10),'') as underlying_asset_qlf_flag --信用衍生品标的合格标志
,t1.add_on as add_on --潜在风险暴露的附加因子
,replace(replace(t1.certificate,chr(13),''),chr(10),'') as certificate --零售客户证件号
,replace(replace(t1.retail_cust_income_ccy_cd,chr(13),''),chr(10),'') as retail_cust_income_ccy_cd --零售客户主要收入币种代码
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no --客户号
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
,replace(replace(t1.ccp_type_cd,chr(13),''),chr(10),'') as ccp_type_cd --交易对手类型代码
,replace(replace(t1.ccp_type_name,chr(13),''),chr(10),'') as ccp_type_name --交易对手类型名称
,replace(replace(t1.ccp_btype_cd,chr(13),''),chr(10),'') as ccp_btype_cd --交易对手大类代码
,replace(replace(t1.ccp_btype_name,chr(13),''),chr(10),'') as ccp_btype_name --交易对手大类名称
,replace(replace(t1.bank_country_cd,chr(13),''),chr(10),'') as bank_country_cd --银行注册国
,replace(replace(t1.bis_country_cd,chr(13),''),chr(10),'') as bis_country_cd --计量注册国家代码
,replace(replace(t1.bis_country_name,chr(13),''),chr(10),'') as bis_country_name --注册国名称
,replace(replace(t1.sov_sp_lt_rating_cd,chr(13),''),chr(10),'') as sov_sp_lt_rating_cd --注册国标普评级代码
,replace(replace(t1.cust_sp_lt_rating_cd,chr(13),''),chr(10),'') as cust_sp_lt_rating_cd --客户标普评级
,replace(replace(t1.scra_rating,chr(13),''),chr(10),'') as scra_rating --scra评级
,replace(replace(t1.int_trade_flag,chr(13),''),chr(10),'') as int_trade_flag --内部交易标志
,replace(replace(t1.solo_int_trade_flag,chr(13),''),chr(10),'') as solo_int_trade_flag --法人内部交易标志
,replace(replace(t1.sec_flag,chr(13),''),chr(10),'') as sec_flag --资产证券化标志
,replace(replace(t1.sec_item_no,chr(13),''),chr(10),'') as sec_item_no --资产证券化项目标志
,replace(replace(t1.sec_role_id,chr(13),''),chr(10),'') as sec_role_id --证券化角色标识 1:发起机构自持 2:投资机构 3：其他从事资产证券化参与机构
,replace(replace(t1.sec_category_id,chr(13),''),chr(10),'') as sec_category_id --证券化类别标识
,replace(replace(t1.sec_exposure_type_id,chr(13),''),chr(10),'') as sec_exposure_type_id --证券化暴露类型标识
,replace(replace(t1.asset_sec_cr_transfer_flag,chr(13),''),chr(10),'') as asset_sec_cr_transfer_flag --证券化售出资产是否实现信用风险转移标志
,replace(replace(t1.anew_asset_sec_flag,chr(13),''),chr(10),'') as anew_asset_sec_flag --再资产证券化标志
,replace(replace(t1.npl_sec_flag,chr(13),''),chr(10),'') as npl_sec_flag --不良资产证券化标志
,replace(replace(t1.sec_priority_rating_flag,chr(13),''),chr(10),'') as sec_priority_rating_flag --证券化优先档次标志
,replace(replace(t1.sec_prudent_mng_flag,chr(13),''),chr(10),'') as sec_prudent_mng_flag --证券化审慎管理标志
,replace(replace(t1.sec_pool_risk_type_cd,chr(13),''),chr(10),'') as sec_pool_risk_type_cd --基础资产风险类型 1-合格不良资产证券化 2-不合格不良资产证券化 0-正常资产
,replace(replace(t1.sec_stc_flag,chr(13),''),chr(10),'') as sec_stc_flag --资产证券化简单透明可比标志
,replace(replace(t1.sec_off_exposure_id,chr(13),''),chr(10),'') as sec_off_exposure_id --证券化表外暴露标识
,t1.sec_pool_rwa as sec_pool_rwa --基础资产池rwa
,replace(replace(t1.cash_overdraw_cancel_flag,chr(13),''),chr(10),'') as cash_overdraw_cancel_flag --现金透支便利无条件可撤销标志
,replace(replace(t1.sec_items_issue_no,chr(13),''),chr(10),'') as sec_items_issue_no --资产证券化发行编号
,t1.fm_hold_ratio as fm_hold_ratio --资管产品持有比例
,t1.fm_fin_product_amt as fm_fin_product_amt --资管产品所有者权益总额
,t1.fm_lvg as fm_lvg --资管产品杠杆率
,t1.fm_rwa_ccp as fm_rwa_ccp --资管产品ccp风险加权资产
,t1.fm_rwa_cva as fm_rwa_cva --资管产品cva
,replace(replace(t1.fm_link_get_way,chr(13),''),chr(10),'') as fm_link_get_way --资管产品基础资产获取方式
,replace(replace(t1.fm_flag,chr(13),''),chr(10),'') as fm_flag --资管产品标志
,replace(replace(t1.fm_product_type,chr(13),''),chr(10),'') as fm_product_type --资管产品类别
,t1.ead_orig as ead_orig --原始风险暴露
,t1.ccf as ccf --表外信用风险转换系数
,t1.ead_afterccf as ead_afterccf --转换后的风险暴露
,t1.ead_afterpro as ead_afterpro --扣减准备金后的风险暴露
,t1.rw as rw --权重
,replace(replace(t1.net_settlement_id,chr(13),''),chr(10),'') as net_settlement_id --净额结算标识
,replace(replace(t1.net_settlement_no,chr(13),''),chr(10),'') as net_settlement_no --净额结算合约编号
,replace(replace(t1.crm_no,chr(13),''),chr(10),'') as crm_no --缓释物编号
,replace(replace(t1.crm_name,chr(13),''),chr(10),'') as crm_name --缓释物名称
,replace(replace(t1.bank_crm_type_cd,chr(13),''),chr(10),'') as bank_crm_type_cd --银行缓释工具类型代码
,replace(replace(t1.bank_crm_type_name,chr(13),''),chr(10),'') as bank_crm_type_name --银行缓释工具类型名称
,replace(replace(t1.bis_crm_btype_name,chr(13),''),chr(10),'') as bis_crm_btype_name --监管缓释工具大类名称
,replace(replace(t1.bis_crm_type_name,chr(13),''),chr(10),'') as bis_crm_type_name --监管缓释工具类型名称
,replace(replace(t1.bis_crm_btype_cd,chr(13),''),chr(10),'') as bis_crm_btype_cd --监管缓释工具大类代码
,replace(replace(t1.bis_crm_type_cd,chr(13),''),chr(10),'') as bis_crm_type_cd --监管缓释工具类型代码
,replace(replace(t1.crm_ccy_cd,chr(13),''),chr(10),'') as crm_ccy_cd --缓释币种代码
,replace(replace(t1.crm_bis_ccy_cd,chr(13),''),chr(10),'') as crm_bis_ccy_cd --缓释物计量币种代码
,t1.crm_amt as crm_amt --缓释金额
,t1.crm_amt_rmb as crm_amt_rmb --缓释金额折本币
,t1.crm_orig_maturity as crm_orig_maturity --缓释原始期限
,t1.crm_rema_maturity as crm_rema_maturity --缓释剩余期限
,replace(replace(t1.crm_cust_no,chr(13),''),chr(10),'') as crm_cust_no --缓释客户编号
,replace(replace(t1.crm_cust_name,chr(13),''),chr(10),'') as crm_cust_name --缓释客户名称
,replace(replace(t1.crm_ccp_type_cd,chr(13),''),chr(10),'') as crm_ccp_type_cd --缓释交易对手类型代码
,replace(replace(t1.crm_sp_rating_cd,chr(13),''),chr(10),'') as crm_sp_rating_cd --缓释交易对手评级
,replace(replace(t1.crm_scra_rating,chr(13),''),chr(10),'') as crm_scra_rating --缓释交易对手scra评级
,replace(replace(t1.crm_reg_country,chr(13),''),chr(10),'') as crm_reg_country --缓释注册国
,replace(replace(t1.crm_sov_sp_rating_cd,chr(13),''),chr(10),'') as crm_sov_sp_rating_cd --缓释注册国标普评级代码
,replace(replace(t1.crm_bond_pay_attr_id,chr(13),''),chr(10),'') as crm_bond_pay_attr_id --地方债属性标识
,t1.crm_amt_split as crm_amt_split --缓释金额拆分
,t1.crm_ccy_mis_coeff as crm_ccy_mis_coeff --缓释币种错配折扣系数
,t1.crm_mat_mis_coeff as crm_mat_mis_coeff --缓释期限错配系数
,t1.crm_floor_mis_coeff as crm_floor_mis_coeff --底线折扣系数
,t1.crm_rw as crm_rw --缓释权重
,t1.after_crmrw as after_crmrw --缓释后风险权重
,t1.after_crmead as after_crmead --缓释后风险暴露
,t1.after_miti_rwa as after_miti_rwa --缓释后的风险加权资产
,replace(replace(t1.report_no,chr(13),''),chr(10),'') as report_no --报表编号
,replace(replace(t1.report_line_no,chr(13),''),chr(10),'') as report_line_no --报表栏位号
,replace(replace(t1.load_date,chr(13),''),chr(10),'') as load_date --加载日期
from ${iol_schema}.rwas_mr_sa_rwa_result_detail t1    --计量_RWA计量明细结果表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') - 1;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'rwas_mr_sa_rwa_result_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
