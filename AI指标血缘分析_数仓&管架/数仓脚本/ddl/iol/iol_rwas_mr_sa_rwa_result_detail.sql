/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_mr_sa_rwa_result_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_mr_sa_rwa_result_detail
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_mr_sa_rwa_result_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_mr_sa_rwa_result_detail(
    data_date date -- 数据日期
    ,version_no varchar2(30) -- 计量版本号
    ,loan_ref_crm_split_seq number(22) -- 缓释拆分序号
    ,scenario_no varchar2(30) -- 业务情景编号 10-标准法 20-资产证券化 30-证券融资 40-场外衍生品 50-资管产品
    ,sa_calculate_id varchar2(30) -- 标准法计量方法标识
    ,sa_calculate_name varchar2(60) -- 标准法计量方法名称
    ,corporation varchar2(30) -- 法人实体编号
    ,bank_level varchar2(30) -- 银行档次
    ,consol_corporation varchar2(30) -- 并表集团机构编号
    ,consol_bank_level varchar2(30) -- 并表银行档次
    ,loan_ref_no varchar2(150) -- 债项编号
    ,loan_ref_desc varchar2(600) -- 债项描述
    ,contract_no varchar2(150) -- 合同编号
    ,main_grnt_mth_cd varchar2(15) -- 主要担保方式代码
    ,adt_grnt_mth_ind varchar2(15) -- 附加担保方式
    ,due_id varchar2(150) -- 债项号
    ,src_system_id varchar2(30) -- 来源系统标识
    ,org_partent_no varchar2(30) -- 分行管户机构
    ,org_partent_name varchar2(383) -- 分行机构名称
    ,org_no varchar2(30) -- 管户机构
    ,org_name varchar2(383) -- 机构名称
    ,org_order_no number -- 机构排序号
    ,accorg_partent_no varchar2(30) -- 分行账务机构
    ,accorg_partent_name varchar2(383) -- 分行账务机构名称
    ,accorg_no varchar2(30) -- 账务机构
    ,accorg_name varchar2(383) -- 账务机构名称
    ,bank_region_cd varchar2(30) -- 银行地域代码
    ,bis_region_cd varchar2(30) -- 监管区域代码
    ,bis_region_name varchar2(300) -- 监管区域名称
    ,loan_ref_inv_indu_cd varchar2(30) -- 投向行业代码
    ,cust_industry_cd varchar2(60) -- 客户所属行业代码
    ,bis_industry_cd varchar2(30) -- 计量行业代码
    ,bis_industry_name varchar2(150) -- 计量行业名称
    ,five_class_cd varchar2(30) -- 五级分类代码
    ,five_class_name varchar2(30) -- 五级分类名称
    ,product_cd varchar2(60) -- 产品代码
    ,product_name varchar2(600) -- 产品名称
    ,bis_product_type_cd varchar2(120) -- 监管产品类型代码
    ,bis_product_type_name varchar2(300) -- 监管产品类型名称
    ,bis_product_btype_cd varchar2(60) -- 监管产品大类代码
    ,bis_product_btype_name varchar2(300) -- 监管产品大类名称
    ,sa_exp_class_cd varchar2(60) -- 标准法风险暴露分类
    ,sa_exp_class_name varchar2(384) -- 标准法风险暴露分类名称
    ,sa_exp_sub_class_cd varchar2(60) -- 标准法风险暴露大类
    ,sa_exp_sub_class_name varchar2(384) -- 标准法风险暴露大类名称
    ,item_off_ccf_btype_cd varchar2(30) -- 表外CCF项目大类代码
    ,item_off_ccf_btype_name varchar2(300) -- 表外CCF项目大类名称
    ,item_off_ccf_type_cd varchar2(60) -- 表外CCF项目类型代码
    ,item_off_ccf_type_name varchar2(300) -- 表外CCF项目类型名称
    ,business_line_cd varchar2(60) -- 业务条线代码
    ,business_line_name varchar2(150) -- 业务条线名称
    ,buss_type_cd varchar2(75) -- 业务类型
    ,buss_type_name varchar2(300) -- 业务名称
    ,start_date date -- 开始日期
    ,due_date date -- 到期日期
    ,orig_maturity number(18,2) -- 原始期限
    ,rema_maturity number(18,2) -- 剩余期限
    ,overdue_days number(22) -- 逾期天数
    ,std_default_flag varchar2(2) -- 权重法违约标志
    ,on_off_id varchar2(15) -- 表内外资产标志
    ,on_off_name varchar2(30) -- 表内外资产名称
    ,seniority_id varchar2(15) -- 优先债权标识
    ,seniority_name varchar2(30) -- 优先标识名称
    ,book_type_id varchar2(15) -- 账簿类型
    ,book_type_name varchar2(30) -- 账簿名称
    ,bank_ccy_cd varchar2(15) -- 银行币种代码
    ,bis_ccy_cd varchar2(15) -- 计量币种代码
    ,bis_ccy_name varchar2(96) -- 计量币种名称
    ,bookkeep_cny_flag varchar2(2) -- 记账本位币计价标志
    ,ccy_mismatch_flag varchar2(2) -- 币种错配标志
    ,exchange_rate number(18,8) -- 汇率
    ,subject_cd varchar2(24) -- 本金科目代码
    ,subject_name varchar2(300) -- 本金科目名称
    ,asset_balance number(18,2) -- 资产余额
    ,accrued_subject_cd varchar2(24) -- 应计利息科目
    ,accrued_subject_name varchar2(300) -- 应计利息科目名称
    ,accrued_int number(18,2) -- 应计利息
    ,receivable_subject_cd varchar2(24) -- 应收利息科目
    ,receivable_subject_name varchar2(300) -- 应收利息科目名称
    ,receivable_int number(18,2) -- 应收利息
    ,intadj_subject_cd varchar2(24) -- 利息调整科目
    ,intadj_subject_name varchar2(300) -- 利息调整科目名称
    ,int_adj number(18,2) -- 利息调整
    ,fairchange_subject_cd varchar2(24) -- 公允价值变动科目
    ,fairchange_subject_name varchar2(300) -- 公允价值变动科目名称
    ,fairvalue_changes number(18,2) -- 公允价值变动
    ,depreamor_subject_cd varchar2(24) -- 折旧科目
    ,depreamor_subject_name varchar2(300) -- 折旧科目名称
    ,depre_amortizat number(18,2) -- 折旧金额
    ,other_subject_cd varchar2(24) -- 其他科目
    ,other_subject_name varchar2(300) -- 其他科目名称
    ,other_amt number(18,2) -- 其他金额
    ,provision_subject_cd varchar2(24) -- 准备金科目代码
    ,provision_subject_name varchar2(300) -- 准备金科目名称
    ,provision number(18,2) -- 准备金
    ,provesion_ratio number(18,6) -- 准备金计提比例
    ,loan_flag varchar2(2) -- 贷款标志
    ,mcr_flag varchar2(2) -- 信用风险计量标志
    ,cross_border_trade_flag varchar2(2) -- 因跨境货物贸易标志
    ,accept_credit_self_flag varchar2(2) -- 自开信用证标志
    ,real_estate_type_cd varchar2(30) -- 房地产风险暴露类型代码
    ,ltv number(18,6) -- LTV规则
    ,accept_discount_self_flag varchar2(2) -- 自承自贴标志
    ,spe_lending_flag varchar2(2) -- 专业贷款标志
    ,spe_lending_type varchar2(6) -- 专业贷款分类
    ,operation_pf_flag varchar2(2) -- 项目融资运营阶段标识
    ,bond_for_acquir_non_perf_flag varchar2(2) -- 为收购国有银行不良贷款而定向发行的债券
    ,bond_pay_attr_id varchar2(15) -- 地方债偿还属性标志
    ,guaranteed_bond_flag varchar2(2) -- 合格担保债券标志
    ,sec_sp_rating_cd varchar2(30) -- 债券标普评级
    ,account_classification varchar2(15) -- 金融资产分类
    ,cancel_flag varchar2(2) -- 随时可撤销标志
    ,off_asset_unmeasured_flag varchar2(2) -- 表外资产不计量标志
    ,unused_prl_tmeet_flag varchar2(2) -- 符合标准的未使用额度标志
    ,equity_invest_attr_identi varchar2(15) -- 股权投资属性
    ,capital_type_cd varchar2(15) -- 金融机构股权投资类别 10-并表 20-大额少数 30-小额少数
    ,core_one_capital_deduction number(18,2) -- 核心一级资本扣除金额
    ,oth_one_capital_deduction number(18,2) -- 其他核心一级资本扣除金额
    ,two_capital_deduction number(18,2) -- 二级资本扣除金额
    ,core_one_capital number(18,2) -- 股权投资余额，其中核心一级资本
    ,oth_one_capital number(18,2) -- 股权投资余额，其中其他核心一级资本
    ,two_capital number(18,2) -- 股权投资余额，其中二级资本
    ,bus_real_property_type_cd varchar2(30) -- 抵债资产类别
    ,deal_trade_days number(10) -- 自合约结算日起延迟交易的交易日数
    ,cust_mcr_flag varchar2(2) -- 交易对手信用风险计量标志
    ,ownership_transfer_flag varchar2(2) -- 所有权发生转移标志
    ,derivatives_type_id varchar2(3) -- 衍生工具类型标识
    ,over_derivatives_flag varchar2(2) -- 场外衍生工具标志
    ,underlying_asset_qlf_flag varchar2(2) -- 信用衍生品标的合格标志
    ,add_on number(18,6) -- 潜在风险暴露的附加因子
    ,certificate varchar2(60) -- 零售客户证件号
    ,retail_cust_income_ccy_cd varchar2(15) -- 零售客户主要收入币种代码
    ,cust_no varchar2(150) -- 客户号
    ,cust_name varchar2(384) -- 客户名称
    ,ccp_type_cd varchar2(60) -- 交易对手类型代码
    ,ccp_type_name varchar2(300) -- 交易对手类型名称
    ,ccp_btype_cd varchar2(60) -- 交易对手大类代码
    ,ccp_btype_name varchar2(150) -- 交易对手大类名称
    ,bank_country_cd varchar2(30) -- 银行注册国
    ,bis_country_cd varchar2(30) -- 计量注册国家代码
    ,bis_country_name varchar2(300) -- 注册国名称
    ,sov_sp_lt_rating_cd varchar2(30) -- 注册国标普评级代码
    ,cust_sp_lt_rating_cd varchar2(30) -- 客户标普评级
    ,scra_rating varchar2(15) -- SCRA评级
    ,int_trade_flag varchar2(2) -- 内部交易标志
    ,solo_int_trade_flag varchar2(2) -- 法人内部交易标志
    ,sec_flag varchar2(2) -- 资产证券化标志
    ,sec_item_no varchar2(150) -- 资产证券化项目标志
    ,sec_role_id varchar2(3) -- 证券化角色标识 1:发起机构自持 2:投资机构 3：其他从事资产证券化参与机构
    ,sec_category_id varchar2(3) -- 证券化类别标识
    ,sec_exposure_type_id varchar2(3) -- 证券化暴露类型标识
    ,asset_sec_cr_transfer_flag varchar2(2) -- 证券化售出资产是否实现信用风险转移标志
    ,anew_asset_sec_flag varchar2(2) -- 再资产证券化标志
    ,npl_sec_flag varchar2(2) -- 不良资产证券化标志
    ,sec_priority_rating_flag varchar2(2) -- 证券化优先档次标志
    ,sec_prudent_mng_flag varchar2(2) -- 证券化审慎管理标志
    ,sec_pool_risk_type_cd varchar2(15) -- 基础资产风险类型 1-合格不良资产证券化 2-不合格不良资产证券化 0-正常资产
    ,sec_stc_flag varchar2(2) -- 资产证券化简单透明可比标志
    ,sec_off_exposure_id varchar2(3) -- 证券化表外暴露标识
    ,sec_pool_rwa number(25,2) -- 基础资产池RWA
    ,cash_overdraw_cancel_flag varchar2(2) -- 现金透支便利无条件可撤销标志
    ,sec_items_issue_no varchar2(150) -- 资产证券化发行编号
    ,fm_hold_ratio number(18,6) -- 资管产品持有比例
    ,fm_fin_product_amt number(18,2) -- 资管产品所有者权益总额
    ,fm_lvg number(18,6) -- 资管产品杠杆率
    ,fm_rwa_ccp number(18,2) -- 资管产品CCP风险加权资产
    ,fm_rwa_cva number(18,2) -- 资管产品CVA
    ,fm_link_get_way varchar2(15) -- 资管产品基础资产获取方式
    ,fm_flag varchar2(2) -- 资管产品标志
    ,fm_product_type varchar2(150) -- 资管产品类别
    ,ead_orig number(18,2) -- 原始风险暴露
    ,ccf number(18,6) -- 表外信用风险转换系数
    ,ead_afterccf number(18,2) -- 转换后的风险暴露
    ,ead_afterpro number(18,2) -- 扣减准备金后的风险暴露
    ,rw number(18,6) -- 权重
    ,net_settlement_id varchar2(3) -- 净额结算标识
    ,net_settlement_no varchar2(120) -- 净额结算合约编号
    ,crm_no varchar2(150) -- 缓释物编号
    ,crm_name varchar2(150) -- 缓释物名称
    ,bank_crm_type_cd varchar2(60) -- 银行缓释工具类型代码
    ,bank_crm_type_name varchar2(300) -- 银行缓释工具类型名称
    ,bis_crm_btype_name varchar2(192) -- 监管缓释工具大类名称
    ,bis_crm_type_name varchar2(300) -- 监管缓释工具类型名称
    ,bis_crm_btype_cd varchar2(60) -- 监管缓释工具大类代码
    ,bis_crm_type_cd varchar2(60) -- 监管缓释工具类型代码
    ,crm_ccy_cd varchar2(15) -- 缓释币种代码
    ,crm_bis_ccy_cd varchar2(15) -- 缓释物计量币种代码
    ,crm_amt number(18,2) -- 缓释金额
    ,crm_amt_rmb number(18,2) -- 缓释金额折本币
    ,crm_orig_maturity number(18,2) -- 缓释原始期限
    ,crm_rema_maturity number(18,2) -- 缓释剩余期限
    ,crm_cust_no varchar2(150) -- 缓释客户编号
    ,crm_cust_name varchar2(384) -- 缓释客户名称
    ,crm_ccp_type_cd varchar2(60) -- 缓释交易对手类型代码
    ,crm_sp_rating_cd varchar2(30) -- 缓释交易对手评级
    ,crm_scra_rating varchar2(15) -- 缓释交易对手SCRA评级
    ,crm_reg_country varchar2(30) -- 缓释注册国
    ,crm_sov_sp_rating_cd varchar2(30) -- 缓释注册国标普评级代码
    ,crm_bond_pay_attr_id varchar2(30) -- 地方债属性标识
    ,crm_amt_split number(18,2) -- 缓释金额拆分
    ,crm_ccy_mis_coeff number(18,6) -- 缓释币种错配折扣系数
    ,crm_mat_mis_coeff number(18,6) -- 缓释期限错配系数
    ,crm_floor_mis_coeff number(18,6) -- 底线折扣系数
    ,crm_rw number(18,6) -- 缓释权重
    ,after_crmrw number(18,6) -- 缓释后风险权重
    ,after_crmead number(18,2) -- 缓释后风险暴露
    ,after_miti_rwa number(18,2) -- 缓释后的风险加权资产
    ,report_no varchar2(30) -- 报表编号
    ,report_line_no varchar2(60) -- 报表栏位号
    ,load_date varchar2(30) -- 加载日期
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rwas_mr_sa_rwa_result_detail to ${iml_schema};
grant select on ${iol_schema}.rwas_mr_sa_rwa_result_detail to ${icl_schema};
grant select on ${iol_schema}.rwas_mr_sa_rwa_result_detail to ${idl_schema};
grant select on ${iol_schema}.rwas_mr_sa_rwa_result_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_mr_sa_rwa_result_detail is '计量_RWA计量明细结果表';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.data_date is '数据日期';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.version_no is '计量版本号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.loan_ref_crm_split_seq is '缓释拆分序号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.scenario_no is '业务情景编号 10-标准法 20-资产证券化 30-证券融资 40-场外衍生品 50-资管产品';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sa_calculate_id is '标准法计量方法标识';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sa_calculate_name is '标准法计量方法名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.corporation is '法人实体编号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bank_level is '银行档次';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.consol_corporation is '并表集团机构编号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.consol_bank_level is '并表银行档次';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.loan_ref_no is '债项编号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.loan_ref_desc is '债项描述';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.contract_no is '合同编号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.main_grnt_mth_cd is '主要担保方式代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.adt_grnt_mth_ind is '附加担保方式';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.due_id is '债项号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.src_system_id is '来源系统标识';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.org_partent_no is '分行管户机构';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.org_partent_name is '分行机构名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.org_no is '管户机构';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.org_name is '机构名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.org_order_no is '机构排序号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.accorg_partent_no is '分行账务机构';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.accorg_partent_name is '分行账务机构名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.accorg_no is '账务机构';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.accorg_name is '账务机构名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bank_region_cd is '银行地域代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_region_cd is '监管区域代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_region_name is '监管区域名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.loan_ref_inv_indu_cd is '投向行业代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.cust_industry_cd is '客户所属行业代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_industry_cd is '计量行业代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_industry_name is '计量行业名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.five_class_cd is '五级分类代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.five_class_name is '五级分类名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.product_cd is '产品代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.product_name is '产品名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_product_type_cd is '监管产品类型代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_product_type_name is '监管产品类型名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_product_btype_cd is '监管产品大类代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_product_btype_name is '监管产品大类名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sa_exp_class_cd is '标准法风险暴露分类';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sa_exp_class_name is '标准法风险暴露分类名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sa_exp_sub_class_cd is '标准法风险暴露大类';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sa_exp_sub_class_name is '标准法风险暴露大类名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.item_off_ccf_btype_cd is '表外CCF项目大类代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.item_off_ccf_btype_name is '表外CCF项目大类名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.item_off_ccf_type_cd is '表外CCF项目类型代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.item_off_ccf_type_name is '表外CCF项目类型名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.business_line_cd is '业务条线代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.business_line_name is '业务条线名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.buss_type_cd is '业务类型';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.buss_type_name is '业务名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.start_date is '开始日期';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.due_date is '到期日期';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.orig_maturity is '原始期限';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.rema_maturity is '剩余期限';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.overdue_days is '逾期天数';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.std_default_flag is '权重法违约标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.on_off_id is '表内外资产标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.on_off_name is '表内外资产名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.seniority_id is '优先债权标识';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.seniority_name is '优先标识名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.book_type_id is '账簿类型';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.book_type_name is '账簿名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bank_ccy_cd is '银行币种代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_ccy_cd is '计量币种代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_ccy_name is '计量币种名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bookkeep_cny_flag is '记账本位币计价标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.ccy_mismatch_flag is '币种错配标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.exchange_rate is '汇率';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.subject_cd is '本金科目代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.subject_name is '本金科目名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.asset_balance is '资产余额';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.accrued_subject_cd is '应计利息科目';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.accrued_subject_name is '应计利息科目名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.accrued_int is '应计利息';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.receivable_subject_cd is '应收利息科目';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.receivable_subject_name is '应收利息科目名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.receivable_int is '应收利息';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.intadj_subject_cd is '利息调整科目';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.intadj_subject_name is '利息调整科目名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.int_adj is '利息调整';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.fairchange_subject_cd is '公允价值变动科目';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.fairchange_subject_name is '公允价值变动科目名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.fairvalue_changes is '公允价值变动';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.depreamor_subject_cd is '折旧科目';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.depreamor_subject_name is '折旧科目名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.depre_amortizat is '折旧金额';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.other_subject_cd is '其他科目';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.other_subject_name is '其他科目名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.other_amt is '其他金额';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.provision_subject_cd is '准备金科目代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.provision_subject_name is '准备金科目名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.provision is '准备金';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.provesion_ratio is '准备金计提比例';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.loan_flag is '贷款标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.mcr_flag is '信用风险计量标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.cross_border_trade_flag is '因跨境货物贸易标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.accept_credit_self_flag is '自开信用证标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.real_estate_type_cd is '房地产风险暴露类型代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.ltv is 'LTV规则';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.accept_discount_self_flag is '自承自贴标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.spe_lending_flag is '专业贷款标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.spe_lending_type is '专业贷款分类';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.operation_pf_flag is '项目融资运营阶段标识';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bond_for_acquir_non_perf_flag is '为收购国有银行不良贷款而定向发行的债券';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bond_pay_attr_id is '地方债偿还属性标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.guaranteed_bond_flag is '合格担保债券标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sec_sp_rating_cd is '债券标普评级';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.account_classification is '金融资产分类';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.cancel_flag is '随时可撤销标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.off_asset_unmeasured_flag is '表外资产不计量标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.unused_prl_tmeet_flag is '符合标准的未使用额度标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.equity_invest_attr_identi is '股权投资属性';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.capital_type_cd is '金融机构股权投资类别 10-并表 20-大额少数 30-小额少数';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.core_one_capital_deduction is '核心一级资本扣除金额';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.oth_one_capital_deduction is '其他核心一级资本扣除金额';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.two_capital_deduction is '二级资本扣除金额';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.core_one_capital is '股权投资余额，其中核心一级资本';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.oth_one_capital is '股权投资余额，其中其他核心一级资本';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.two_capital is '股权投资余额，其中二级资本';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bus_real_property_type_cd is '抵债资产类别';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.deal_trade_days is '自合约结算日起延迟交易的交易日数';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.cust_mcr_flag is '交易对手信用风险计量标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.ownership_transfer_flag is '所有权发生转移标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.derivatives_type_id is '衍生工具类型标识';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.over_derivatives_flag is '场外衍生工具标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.underlying_asset_qlf_flag is '信用衍生品标的合格标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.add_on is '潜在风险暴露的附加因子';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.certificate is '零售客户证件号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.retail_cust_income_ccy_cd is '零售客户主要收入币种代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.cust_no is '客户号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.cust_name is '客户名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.ccp_type_cd is '交易对手类型代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.ccp_type_name is '交易对手类型名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.ccp_btype_cd is '交易对手大类代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.ccp_btype_name is '交易对手大类名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bank_country_cd is '银行注册国';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_country_cd is '计量注册国家代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_country_name is '注册国名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sov_sp_lt_rating_cd is '注册国标普评级代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.cust_sp_lt_rating_cd is '客户标普评级';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.scra_rating is 'SCRA评级';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.int_trade_flag is '内部交易标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.solo_int_trade_flag is '法人内部交易标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sec_flag is '资产证券化标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sec_item_no is '资产证券化项目标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sec_role_id is '证券化角色标识 1:发起机构自持 2:投资机构 3：其他从事资产证券化参与机构';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sec_category_id is '证券化类别标识';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sec_exposure_type_id is '证券化暴露类型标识';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.asset_sec_cr_transfer_flag is '证券化售出资产是否实现信用风险转移标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.anew_asset_sec_flag is '再资产证券化标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.npl_sec_flag is '不良资产证券化标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sec_priority_rating_flag is '证券化优先档次标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sec_prudent_mng_flag is '证券化审慎管理标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sec_pool_risk_type_cd is '基础资产风险类型 1-合格不良资产证券化 2-不合格不良资产证券化 0-正常资产';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sec_stc_flag is '资产证券化简单透明可比标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sec_off_exposure_id is '证券化表外暴露标识';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sec_pool_rwa is '基础资产池RWA';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.cash_overdraw_cancel_flag is '现金透支便利无条件可撤销标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.sec_items_issue_no is '资产证券化发行编号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.fm_hold_ratio is '资管产品持有比例';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.fm_fin_product_amt is '资管产品所有者权益总额';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.fm_lvg is '资管产品杠杆率';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.fm_rwa_ccp is '资管产品CCP风险加权资产';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.fm_rwa_cva is '资管产品CVA';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.fm_link_get_way is '资管产品基础资产获取方式';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.fm_flag is '资管产品标志';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.fm_product_type is '资管产品类别';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.ead_orig is '原始风险暴露';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.ccf is '表外信用风险转换系数';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.ead_afterccf is '转换后的风险暴露';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.ead_afterpro is '扣减准备金后的风险暴露';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.rw is '权重';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.net_settlement_id is '净额结算标识';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.net_settlement_no is '净额结算合约编号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_no is '缓释物编号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_name is '缓释物名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bank_crm_type_cd is '银行缓释工具类型代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bank_crm_type_name is '银行缓释工具类型名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_crm_btype_name is '监管缓释工具大类名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_crm_type_name is '监管缓释工具类型名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_crm_btype_cd is '监管缓释工具大类代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.bis_crm_type_cd is '监管缓释工具类型代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_ccy_cd is '缓释币种代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_bis_ccy_cd is '缓释物计量币种代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_amt is '缓释金额';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_amt_rmb is '缓释金额折本币';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_orig_maturity is '缓释原始期限';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_rema_maturity is '缓释剩余期限';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_cust_no is '缓释客户编号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_cust_name is '缓释客户名称';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_ccp_type_cd is '缓释交易对手类型代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_sp_rating_cd is '缓释交易对手评级';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_scra_rating is '缓释交易对手SCRA评级';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_reg_country is '缓释注册国';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_sov_sp_rating_cd is '缓释注册国标普评级代码';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_bond_pay_attr_id is '地方债属性标识';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_amt_split is '缓释金额拆分';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_ccy_mis_coeff is '缓释币种错配折扣系数';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_mat_mis_coeff is '缓释期限错配系数';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_floor_mis_coeff is '底线折扣系数';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.crm_rw is '缓释权重';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.after_crmrw is '缓释后风险权重';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.after_crmead is '缓释后风险暴露';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.after_miti_rwa is '缓释后的风险加权资产';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.report_no is '报表编号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.report_line_no is '报表栏位号';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.load_date is '加载日期';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rwas_mr_sa_rwa_result_detail.etl_timestamp is 'ETL处理时间戳';
