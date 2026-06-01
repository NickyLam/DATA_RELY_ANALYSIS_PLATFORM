/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_cashlb_manage_ele
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
create table ${iol_schema}.ibms_ttrd_cashlb_manage_ele_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_cashlb_manage_ele
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_cashlb_manage_ele_op purge;
drop table ${iol_schema}.ibms_ttrd_cashlb_manage_ele_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_cashlb_manage_ele_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_cashlb_manage_ele where 0=1;

create table ${iol_schema}.ibms_ttrd_cashlb_manage_ele_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_cashlb_manage_ele where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_cashlb_manage_ele_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,coupon -- 合同利率
            ,final_use_comp -- 最终用款企业
            ,business_category -- 行业归属
            ,is_two_high_one_left -- 是否“两高一剩”，1是，0否
            ,is_government_platform -- 是否政府融资平台，1是，0否
            ,is_industry_fund -- 是否产业基金，1是，0否
            ,out_grade -- 外部评级
            ,in_grade -- 内部评级
            ,in_grade_mtr_date -- 内部评级到期日
            ,comp_area_province -- 用款企业所属区域（省）
            ,comp_area_city -- 用款企业所属区域（市）
            ,is_convert_debt_pro -- 是否投向市场化债转股相关产品
            ,und_asset_type_opt -- 底层资产类型
            ,management_mode -- 管理模式
            ,is_entrusted_loan -- 是否委托贷款
            ,num_of_carries -- spv载体个数
            ,approval_id -- 批复号
            ,total_goods_amount -- 产品总金额
            ,approval_amount -- 批复金额
            ,risk_weight -- 风险权重
            ,is_multi_financier -- 是否多融资人
            ,actual_financier_id -- 实际融资人客户号
            ,financier_nature -- 实际融资人客户性质
            ,parent_group -- 实际融资人所属集团
            ,is_asset_base_securities -- 是否资产证券化产品
            ,is_credit_item -- 是否信贷类项目
            ,investment_type -- 按投资产品类型划分
            ,raise_way -- 募集方式
            ,risk_assets_weight -- 风险资产权重（%）
            ,risky_assets_classify -- 风险资产分类
            ,g31_classify -- g31产品分类
            ,final_use_comp_relevance_info -- 最终用款企业关联方信息(华兴需求)
            ,business_category_min -- 行业细类
            ,mitigation_freq -- 缓释频率
            ,not_undasset_type -- 非底层资产分类
            ,not_undasset_type_two -- 非底层资产分类2
            ,invest_fund_part -- 投向产业基金的部分
            ,invest_market_part -- 投向市场化债转股相关产品的部分
            ,invest_finance_formanagepart -- 投向金融资产投资公司发行的私募资产管理产品
            ,invest_finance_forcapitalpart -- 投向金融资产投资公司或其附属机构发行的私募股权投资基金
            ,is_undasset_loan -- 底层资产是否为投放贷款
            ,middle_class -- 业务种类
            ,is_equity_product -- 是否为净值型产品
            ,special_purpose_vehicle_type -- 特定目的载体类型
            ,asset_product_statistics_code -- 资管产品统计编码
            ,issuer_region_code -- 发行人地区代码
            ,excute_mode -- 运行方式
            ,special_purpose_vehicle_code -- 特定目的载体代码
            ,issuer_code -- 发行人代码
            ,ensure_codes -- 
            ,is_nonstandard -- 
            ,is_publicoffer -- 
            ,fund_use -- 资金用途
            ,is_decide_openbusiness -- 是否定开业务
            ,openbusiness_begdate -- 开放周期
            ,excute_mode_hx -- 运行方式（华兴）
            ,special_purpose_vehicle_hx -- 特定目的载体代码（华兴）
            ,product_manager -- 产品管理方
            ,guarantee_description -- 担保描述
            ,investment_direction_max -- 资金投向大类
            ,investment_direction_min -- 资金投向小类
            ,under_debt_class -- 底层债分类
            ,under_debt_rating -- 底层债债项评级
            ,is_goverment_invest_fund -- 是否政府投资基金
            ,is_pioneer_invest_fund -- 是否创业投资基金
            ,is_remote_business -- 是否异地业务
            ,is_local_gover_invest_platform -- 是否地方政府融资平台
            ,add_credit_way -- 增信方式
            ,add_credit_subject_name -- 增信主体名称
            ,update_time -- 更新时间
            ,scale -- 企业规模
            ,pay_mode -- 还本付息方式
            ,industry_fund_amount -- 投向产业基金部分金额
            ,trade_platform -- 交易平台
            ,is_over_capacity -- 是否产能过剩行业
            ,is_shareholder -- 是否本行股东及其关联方
            ,structure_type -- 产品结构类型
            ,product_size -- 产品总规模
            ,senior_size -- 劣后规模
            ,investment_share_type -- 我行投资份额属于优先还是夹层
            ,private_fund_amount -- 投向金融资产投资公司或其附属机构发行的私募股权投资基金金额
            ,private_product_amount -- 投向金融资产投资公司发行的私募资产管理产品金额
            ,business_category_mid -- 投向行业中类
            ,through_type -- 穿透类型
            ,is_invest_debt -- 是否投向市场化债转股
            ,is_consumer_service -- 是否为消费服务类融资
            ,business_category_small -- 投向行业细类
            ,is_asset_secu -- 是否资产支持证券(1:是 0:否）
            ,is_no_grade_secu -- 是否无评级资产证券化(1:是 0:否）
            ,current_period_net -- 基金当前报告期净值
            ,fund_current_asset -- 基金当期总资产
            ,fund_sum_share -- 基金总份额
            ,has_third_report -- 是否有独立第三方报告
            ,information_source -- 信息来源
            ,lever_ratio -- 杠杆率
            ,report_date -- 报告日期
            ,report_period -- 报告期次
            ,risk_weight_trail -- 试算(基础资产权重录入)
            ,is_realty_loan -- 是否房地产开发贷款
            ,project_sum_invest -- 项目总投资
            ,capital_fund -- 资本金
            ,is_commer_housing -- 是否居住用房
            ,is_green_finance -- 是否属于绿色融资
            ,first_option_type -- 
            ,second_option_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_cashlb_manage_ele_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,coupon -- 合同利率
            ,final_use_comp -- 最终用款企业
            ,business_category -- 行业归属
            ,is_two_high_one_left -- 是否“两高一剩”，1是，0否
            ,is_government_platform -- 是否政府融资平台，1是，0否
            ,is_industry_fund -- 是否产业基金，1是，0否
            ,out_grade -- 外部评级
            ,in_grade -- 内部评级
            ,in_grade_mtr_date -- 内部评级到期日
            ,comp_area_province -- 用款企业所属区域（省）
            ,comp_area_city -- 用款企业所属区域（市）
            ,is_convert_debt_pro -- 是否投向市场化债转股相关产品
            ,und_asset_type_opt -- 底层资产类型
            ,management_mode -- 管理模式
            ,is_entrusted_loan -- 是否委托贷款
            ,num_of_carries -- spv载体个数
            ,approval_id -- 批复号
            ,total_goods_amount -- 产品总金额
            ,approval_amount -- 批复金额
            ,risk_weight -- 风险权重
            ,is_multi_financier -- 是否多融资人
            ,actual_financier_id -- 实际融资人客户号
            ,financier_nature -- 实际融资人客户性质
            ,parent_group -- 实际融资人所属集团
            ,is_asset_base_securities -- 是否资产证券化产品
            ,is_credit_item -- 是否信贷类项目
            ,investment_type -- 按投资产品类型划分
            ,raise_way -- 募集方式
            ,risk_assets_weight -- 风险资产权重（%）
            ,risky_assets_classify -- 风险资产分类
            ,g31_classify -- g31产品分类
            ,final_use_comp_relevance_info -- 最终用款企业关联方信息(华兴需求)
            ,business_category_min -- 行业细类
            ,mitigation_freq -- 缓释频率
            ,not_undasset_type -- 非底层资产分类
            ,not_undasset_type_two -- 非底层资产分类2
            ,invest_fund_part -- 投向产业基金的部分
            ,invest_market_part -- 投向市场化债转股相关产品的部分
            ,invest_finance_formanagepart -- 投向金融资产投资公司发行的私募资产管理产品
            ,invest_finance_forcapitalpart -- 投向金融资产投资公司或其附属机构发行的私募股权投资基金
            ,is_undasset_loan -- 底层资产是否为投放贷款
            ,middle_class -- 业务种类
            ,is_equity_product -- 是否为净值型产品
            ,special_purpose_vehicle_type -- 特定目的载体类型
            ,asset_product_statistics_code -- 资管产品统计编码
            ,issuer_region_code -- 发行人地区代码
            ,excute_mode -- 运行方式
            ,special_purpose_vehicle_code -- 特定目的载体代码
            ,issuer_code -- 发行人代码
            ,ensure_codes -- 
            ,is_nonstandard -- 
            ,is_publicoffer -- 
            ,fund_use -- 资金用途
            ,is_decide_openbusiness -- 是否定开业务
            ,openbusiness_begdate -- 开放周期
            ,excute_mode_hx -- 运行方式（华兴）
            ,special_purpose_vehicle_hx -- 特定目的载体代码（华兴）
            ,product_manager -- 产品管理方
            ,guarantee_description -- 担保描述
            ,investment_direction_max -- 资金投向大类
            ,investment_direction_min -- 资金投向小类
            ,under_debt_class -- 底层债分类
            ,under_debt_rating -- 底层债债项评级
            ,is_goverment_invest_fund -- 是否政府投资基金
            ,is_pioneer_invest_fund -- 是否创业投资基金
            ,is_remote_business -- 是否异地业务
            ,is_local_gover_invest_platform -- 是否地方政府融资平台
            ,add_credit_way -- 增信方式
            ,add_credit_subject_name -- 增信主体名称
            ,update_time -- 更新时间
            ,scale -- 企业规模
            ,pay_mode -- 还本付息方式
            ,industry_fund_amount -- 投向产业基金部分金额
            ,trade_platform -- 交易平台
            ,is_over_capacity -- 是否产能过剩行业
            ,is_shareholder -- 是否本行股东及其关联方
            ,structure_type -- 产品结构类型
            ,product_size -- 产品总规模
            ,senior_size -- 劣后规模
            ,investment_share_type -- 我行投资份额属于优先还是夹层
            ,private_fund_amount -- 投向金融资产投资公司或其附属机构发行的私募股权投资基金金额
            ,private_product_amount -- 投向金融资产投资公司发行的私募资产管理产品金额
            ,business_category_mid -- 投向行业中类
            ,through_type -- 穿透类型
            ,is_invest_debt -- 是否投向市场化债转股
            ,is_consumer_service -- 是否为消费服务类融资
            ,business_category_small -- 投向行业细类
            ,is_asset_secu -- 是否资产支持证券(1:是 0:否）
            ,is_no_grade_secu -- 是否无评级资产证券化(1:是 0:否）
            ,current_period_net -- 基金当前报告期净值
            ,fund_current_asset -- 基金当期总资产
            ,fund_sum_share -- 基金总份额
            ,has_third_report -- 是否有独立第三方报告
            ,information_source -- 信息来源
            ,lever_ratio -- 杠杆率
            ,report_date -- 报告日期
            ,report_period -- 报告期次
            ,risk_weight_trail -- 试算(基础资产权重录入)
            ,is_realty_loan -- 是否房地产开发贷款
            ,project_sum_invest -- 项目总投资
            ,capital_fund -- 资本金
            ,is_commer_housing -- 是否居住用房
            ,is_green_finance -- 是否属于绿色融资
            ,first_option_type -- 
            ,second_option_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.coupon, o.coupon) as coupon -- 合同利率
    ,nvl(n.final_use_comp, o.final_use_comp) as final_use_comp -- 最终用款企业
    ,nvl(n.business_category, o.business_category) as business_category -- 行业归属
    ,nvl(n.is_two_high_one_left, o.is_two_high_one_left) as is_two_high_one_left -- 是否“两高一剩”，1是，0否
    ,nvl(n.is_government_platform, o.is_government_platform) as is_government_platform -- 是否政府融资平台，1是，0否
    ,nvl(n.is_industry_fund, o.is_industry_fund) as is_industry_fund -- 是否产业基金，1是，0否
    ,nvl(n.out_grade, o.out_grade) as out_grade -- 外部评级
    ,nvl(n.in_grade, o.in_grade) as in_grade -- 内部评级
    ,nvl(n.in_grade_mtr_date, o.in_grade_mtr_date) as in_grade_mtr_date -- 内部评级到期日
    ,nvl(n.comp_area_province, o.comp_area_province) as comp_area_province -- 用款企业所属区域（省）
    ,nvl(n.comp_area_city, o.comp_area_city) as comp_area_city -- 用款企业所属区域（市）
    ,nvl(n.is_convert_debt_pro, o.is_convert_debt_pro) as is_convert_debt_pro -- 是否投向市场化债转股相关产品
    ,nvl(n.und_asset_type_opt, o.und_asset_type_opt) as und_asset_type_opt -- 底层资产类型
    ,nvl(n.management_mode, o.management_mode) as management_mode -- 管理模式
    ,nvl(n.is_entrusted_loan, o.is_entrusted_loan) as is_entrusted_loan -- 是否委托贷款
    ,nvl(n.num_of_carries, o.num_of_carries) as num_of_carries -- spv载体个数
    ,nvl(n.approval_id, o.approval_id) as approval_id -- 批复号
    ,nvl(n.total_goods_amount, o.total_goods_amount) as total_goods_amount -- 产品总金额
    ,nvl(n.approval_amount, o.approval_amount) as approval_amount -- 批复金额
    ,nvl(n.risk_weight, o.risk_weight) as risk_weight -- 风险权重
    ,nvl(n.is_multi_financier, o.is_multi_financier) as is_multi_financier -- 是否多融资人
    ,nvl(n.actual_financier_id, o.actual_financier_id) as actual_financier_id -- 实际融资人客户号
    ,nvl(n.financier_nature, o.financier_nature) as financier_nature -- 实际融资人客户性质
    ,nvl(n.parent_group, o.parent_group) as parent_group -- 实际融资人所属集团
    ,nvl(n.is_asset_base_securities, o.is_asset_base_securities) as is_asset_base_securities -- 是否资产证券化产品
    ,nvl(n.is_credit_item, o.is_credit_item) as is_credit_item -- 是否信贷类项目
    ,nvl(n.investment_type, o.investment_type) as investment_type -- 按投资产品类型划分
    ,nvl(n.raise_way, o.raise_way) as raise_way -- 募集方式
    ,nvl(n.risk_assets_weight, o.risk_assets_weight) as risk_assets_weight -- 风险资产权重（%）
    ,nvl(n.risky_assets_classify, o.risky_assets_classify) as risky_assets_classify -- 风险资产分类
    ,nvl(n.g31_classify, o.g31_classify) as g31_classify -- g31产品分类
    ,nvl(n.final_use_comp_relevance_info, o.final_use_comp_relevance_info) as final_use_comp_relevance_info -- 最终用款企业关联方信息(华兴需求)
    ,nvl(n.business_category_min, o.business_category_min) as business_category_min -- 行业细类
    ,nvl(n.mitigation_freq, o.mitigation_freq) as mitigation_freq -- 缓释频率
    ,nvl(n.not_undasset_type, o.not_undasset_type) as not_undasset_type -- 非底层资产分类
    ,nvl(n.not_undasset_type_two, o.not_undasset_type_two) as not_undasset_type_two -- 非底层资产分类2
    ,nvl(n.invest_fund_part, o.invest_fund_part) as invest_fund_part -- 投向产业基金的部分
    ,nvl(n.invest_market_part, o.invest_market_part) as invest_market_part -- 投向市场化债转股相关产品的部分
    ,nvl(n.invest_finance_formanagepart, o.invest_finance_formanagepart) as invest_finance_formanagepart -- 投向金融资产投资公司发行的私募资产管理产品
    ,nvl(n.invest_finance_forcapitalpart, o.invest_finance_forcapitalpart) as invest_finance_forcapitalpart -- 投向金融资产投资公司或其附属机构发行的私募股权投资基金
    ,nvl(n.is_undasset_loan, o.is_undasset_loan) as is_undasset_loan -- 底层资产是否为投放贷款
    ,nvl(n.middle_class, o.middle_class) as middle_class -- 业务种类
    ,nvl(n.is_equity_product, o.is_equity_product) as is_equity_product -- 是否为净值型产品
    ,nvl(n.special_purpose_vehicle_type, o.special_purpose_vehicle_type) as special_purpose_vehicle_type -- 特定目的载体类型
    ,nvl(n.asset_product_statistics_code, o.asset_product_statistics_code) as asset_product_statistics_code -- 资管产品统计编码
    ,nvl(n.issuer_region_code, o.issuer_region_code) as issuer_region_code -- 发行人地区代码
    ,nvl(n.excute_mode, o.excute_mode) as excute_mode -- 运行方式
    ,nvl(n.special_purpose_vehicle_code, o.special_purpose_vehicle_code) as special_purpose_vehicle_code -- 特定目的载体代码
    ,nvl(n.issuer_code, o.issuer_code) as issuer_code -- 发行人代码
    ,nvl(n.ensure_codes, o.ensure_codes) as ensure_codes -- 
    ,nvl(n.is_nonstandard, o.is_nonstandard) as is_nonstandard -- 
    ,nvl(n.is_publicoffer, o.is_publicoffer) as is_publicoffer -- 
    ,nvl(n.fund_use, o.fund_use) as fund_use -- 资金用途
    ,nvl(n.is_decide_openbusiness, o.is_decide_openbusiness) as is_decide_openbusiness -- 是否定开业务
    ,nvl(n.openbusiness_begdate, o.openbusiness_begdate) as openbusiness_begdate -- 开放周期
    ,nvl(n.excute_mode_hx, o.excute_mode_hx) as excute_mode_hx -- 运行方式（华兴）
    ,nvl(n.special_purpose_vehicle_hx, o.special_purpose_vehicle_hx) as special_purpose_vehicle_hx -- 特定目的载体代码（华兴）
    ,nvl(n.product_manager, o.product_manager) as product_manager -- 产品管理方
    ,nvl(n.guarantee_description, o.guarantee_description) as guarantee_description -- 担保描述
    ,nvl(n.investment_direction_max, o.investment_direction_max) as investment_direction_max -- 资金投向大类
    ,nvl(n.investment_direction_min, o.investment_direction_min) as investment_direction_min -- 资金投向小类
    ,nvl(n.under_debt_class, o.under_debt_class) as under_debt_class -- 底层债分类
    ,nvl(n.under_debt_rating, o.under_debt_rating) as under_debt_rating -- 底层债债项评级
    ,nvl(n.is_goverment_invest_fund, o.is_goverment_invest_fund) as is_goverment_invest_fund -- 是否政府投资基金
    ,nvl(n.is_pioneer_invest_fund, o.is_pioneer_invest_fund) as is_pioneer_invest_fund -- 是否创业投资基金
    ,nvl(n.is_remote_business, o.is_remote_business) as is_remote_business -- 是否异地业务
    ,nvl(n.is_local_gover_invest_platform, o.is_local_gover_invest_platform) as is_local_gover_invest_platform -- 是否地方政府融资平台
    ,nvl(n.add_credit_way, o.add_credit_way) as add_credit_way -- 增信方式
    ,nvl(n.add_credit_subject_name, o.add_credit_subject_name) as add_credit_subject_name -- 增信主体名称
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.scale, o.scale) as scale -- 企业规模
    ,nvl(n.pay_mode, o.pay_mode) as pay_mode -- 还本付息方式
    ,nvl(n.industry_fund_amount, o.industry_fund_amount) as industry_fund_amount -- 投向产业基金部分金额
    ,nvl(n.trade_platform, o.trade_platform) as trade_platform -- 交易平台
    ,nvl(n.is_over_capacity, o.is_over_capacity) as is_over_capacity -- 是否产能过剩行业
    ,nvl(n.is_shareholder, o.is_shareholder) as is_shareholder -- 是否本行股东及其关联方
    ,nvl(n.structure_type, o.structure_type) as structure_type -- 产品结构类型
    ,nvl(n.product_size, o.product_size) as product_size -- 产品总规模
    ,nvl(n.senior_size, o.senior_size) as senior_size -- 劣后规模
    ,nvl(n.investment_share_type, o.investment_share_type) as investment_share_type -- 我行投资份额属于优先还是夹层
    ,nvl(n.private_fund_amount, o.private_fund_amount) as private_fund_amount -- 投向金融资产投资公司或其附属机构发行的私募股权投资基金金额
    ,nvl(n.private_product_amount, o.private_product_amount) as private_product_amount -- 投向金融资产投资公司发行的私募资产管理产品金额
    ,nvl(n.business_category_mid, o.business_category_mid) as business_category_mid -- 投向行业中类
    ,nvl(n.through_type, o.through_type) as through_type -- 穿透类型
    ,nvl(n.is_invest_debt, o.is_invest_debt) as is_invest_debt -- 是否投向市场化债转股
    ,nvl(n.is_consumer_service, o.is_consumer_service) as is_consumer_service -- 是否为消费服务类融资
    ,nvl(n.business_category_small, o.business_category_small) as business_category_small -- 投向行业细类
    ,nvl(n.is_asset_secu, o.is_asset_secu) as is_asset_secu -- 是否资产支持证券(1:是 0:否）
    ,nvl(n.is_no_grade_secu, o.is_no_grade_secu) as is_no_grade_secu -- 是否无评级资产证券化(1:是 0:否）
    ,nvl(n.current_period_net, o.current_period_net) as current_period_net -- 基金当前报告期净值
    ,nvl(n.fund_current_asset, o.fund_current_asset) as fund_current_asset -- 基金当期总资产
    ,nvl(n.fund_sum_share, o.fund_sum_share) as fund_sum_share -- 基金总份额
    ,nvl(n.has_third_report, o.has_third_report) as has_third_report -- 是否有独立第三方报告
    ,nvl(n.information_source, o.information_source) as information_source -- 信息来源
    ,nvl(n.lever_ratio, o.lever_ratio) as lever_ratio -- 杠杆率
    ,nvl(n.report_date, o.report_date) as report_date -- 报告日期
    ,nvl(n.report_period, o.report_period) as report_period -- 报告期次
    ,nvl(n.risk_weight_trail, o.risk_weight_trail) as risk_weight_trail -- 试算(基础资产权重录入)
    ,nvl(n.is_realty_loan, o.is_realty_loan) as is_realty_loan -- 是否房地产开发贷款
    ,nvl(n.project_sum_invest, o.project_sum_invest) as project_sum_invest -- 项目总投资
    ,nvl(n.capital_fund, o.capital_fund) as capital_fund -- 资本金
    ,nvl(n.is_commer_housing, o.is_commer_housing) as is_commer_housing -- 是否居住用房
    ,nvl(n.is_green_finance, o.is_green_finance) as is_green_finance -- 是否属于绿色融资
    ,nvl(n.first_option_type, o.first_option_type) as first_option_type -- 
    ,nvl(n.second_option_type, o.second_option_type) as second_option_type -- 
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_cashlb_manage_ele_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_cashlb_manage_ele where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
where (
        o.i_code is null
        and o.a_type is null
        and o.m_type is null
    )
    or (
        n.i_code is null
        and n.a_type is null
        and n.m_type is null
    )
    or (
        o.coupon <> n.coupon
        or o.final_use_comp <> n.final_use_comp
        or o.business_category <> n.business_category
        or o.is_two_high_one_left <> n.is_two_high_one_left
        or o.is_government_platform <> n.is_government_platform
        or o.is_industry_fund <> n.is_industry_fund
        or o.out_grade <> n.out_grade
        or o.in_grade <> n.in_grade
        or o.in_grade_mtr_date <> n.in_grade_mtr_date
        or o.comp_area_province <> n.comp_area_province
        or o.comp_area_city <> n.comp_area_city
        or o.is_convert_debt_pro <> n.is_convert_debt_pro
        or o.und_asset_type_opt <> n.und_asset_type_opt
        or o.management_mode <> n.management_mode
        or o.is_entrusted_loan <> n.is_entrusted_loan
        or o.num_of_carries <> n.num_of_carries
        or o.approval_id <> n.approval_id
        or o.total_goods_amount <> n.total_goods_amount
        or o.approval_amount <> n.approval_amount
        or o.risk_weight <> n.risk_weight
        or o.is_multi_financier <> n.is_multi_financier
        or o.actual_financier_id <> n.actual_financier_id
        or o.financier_nature <> n.financier_nature
        or o.parent_group <> n.parent_group
        or o.is_asset_base_securities <> n.is_asset_base_securities
        or o.is_credit_item <> n.is_credit_item
        or o.investment_type <> n.investment_type
        or o.raise_way <> n.raise_way
        or o.risk_assets_weight <> n.risk_assets_weight
        or o.risky_assets_classify <> n.risky_assets_classify
        or o.g31_classify <> n.g31_classify
        or o.final_use_comp_relevance_info <> n.final_use_comp_relevance_info
        or o.business_category_min <> n.business_category_min
        or o.mitigation_freq <> n.mitigation_freq
        or o.not_undasset_type <> n.not_undasset_type
        or o.not_undasset_type_two <> n.not_undasset_type_two
        or o.invest_fund_part <> n.invest_fund_part
        or o.invest_market_part <> n.invest_market_part
        or o.invest_finance_formanagepart <> n.invest_finance_formanagepart
        or o.invest_finance_forcapitalpart <> n.invest_finance_forcapitalpart
        or o.is_undasset_loan <> n.is_undasset_loan
        or o.middle_class <> n.middle_class
        or o.is_equity_product <> n.is_equity_product
        or o.special_purpose_vehicle_type <> n.special_purpose_vehicle_type
        or o.asset_product_statistics_code <> n.asset_product_statistics_code
        or o.issuer_region_code <> n.issuer_region_code
        or o.excute_mode <> n.excute_mode
        or o.special_purpose_vehicle_code <> n.special_purpose_vehicle_code
        or o.issuer_code <> n.issuer_code
        or o.ensure_codes <> n.ensure_codes
        or o.is_nonstandard <> n.is_nonstandard
        or o.is_publicoffer <> n.is_publicoffer
        or o.fund_use <> n.fund_use
        or o.is_decide_openbusiness <> n.is_decide_openbusiness
        or o.openbusiness_begdate <> n.openbusiness_begdate
        or o.excute_mode_hx <> n.excute_mode_hx
        or o.special_purpose_vehicle_hx <> n.special_purpose_vehicle_hx
        or o.product_manager <> n.product_manager
        or o.guarantee_description <> n.guarantee_description
        or o.investment_direction_max <> n.investment_direction_max
        or o.investment_direction_min <> n.investment_direction_min
        or o.under_debt_class <> n.under_debt_class
        or o.under_debt_rating <> n.under_debt_rating
        or o.is_goverment_invest_fund <> n.is_goverment_invest_fund
        or o.is_pioneer_invest_fund <> n.is_pioneer_invest_fund
        or o.is_remote_business <> n.is_remote_business
        or o.is_local_gover_invest_platform <> n.is_local_gover_invest_platform
        or o.add_credit_way <> n.add_credit_way
        or o.add_credit_subject_name <> n.add_credit_subject_name
        or o.update_time <> n.update_time
        or o.scale <> n.scale
        or o.pay_mode <> n.pay_mode
        or o.industry_fund_amount <> n.industry_fund_amount
        or o.trade_platform <> n.trade_platform
        or o.is_over_capacity <> n.is_over_capacity
        or o.is_shareholder <> n.is_shareholder
        or o.structure_type <> n.structure_type
        or o.product_size <> n.product_size
        or o.senior_size <> n.senior_size
        or o.investment_share_type <> n.investment_share_type
        or o.private_fund_amount <> n.private_fund_amount
        or o.private_product_amount <> n.private_product_amount
        or o.business_category_mid <> n.business_category_mid
        or o.through_type <> n.through_type
        or o.is_invest_debt <> n.is_invest_debt
        or o.is_consumer_service <> n.is_consumer_service
        or o.business_category_small <> n.business_category_small
        or o.is_asset_secu <> n.is_asset_secu
        or o.is_no_grade_secu <> n.is_no_grade_secu
        or o.current_period_net <> n.current_period_net
        or o.fund_current_asset <> n.fund_current_asset
        or o.fund_sum_share <> n.fund_sum_share
        or o.has_third_report <> n.has_third_report
        or o.information_source <> n.information_source
        or o.lever_ratio <> n.lever_ratio
        or o.report_date <> n.report_date
        or o.report_period <> n.report_period
        or o.risk_weight_trail <> n.risk_weight_trail
        or o.is_realty_loan <> n.is_realty_loan
        or o.project_sum_invest <> n.project_sum_invest
        or o.capital_fund <> n.capital_fund
        or o.is_commer_housing <> n.is_commer_housing
        or o.is_green_finance <> n.is_green_finance
        or o.first_option_type <> n.first_option_type
        or o.second_option_type <> n.second_option_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_cashlb_manage_ele_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,coupon -- 合同利率
            ,final_use_comp -- 最终用款企业
            ,business_category -- 行业归属
            ,is_two_high_one_left -- 是否“两高一剩”，1是，0否
            ,is_government_platform -- 是否政府融资平台，1是，0否
            ,is_industry_fund -- 是否产业基金，1是，0否
            ,out_grade -- 外部评级
            ,in_grade -- 内部评级
            ,in_grade_mtr_date -- 内部评级到期日
            ,comp_area_province -- 用款企业所属区域（省）
            ,comp_area_city -- 用款企业所属区域（市）
            ,is_convert_debt_pro -- 是否投向市场化债转股相关产品
            ,und_asset_type_opt -- 底层资产类型
            ,management_mode -- 管理模式
            ,is_entrusted_loan -- 是否委托贷款
            ,num_of_carries -- spv载体个数
            ,approval_id -- 批复号
            ,total_goods_amount -- 产品总金额
            ,approval_amount -- 批复金额
            ,risk_weight -- 风险权重
            ,is_multi_financier -- 是否多融资人
            ,actual_financier_id -- 实际融资人客户号
            ,financier_nature -- 实际融资人客户性质
            ,parent_group -- 实际融资人所属集团
            ,is_asset_base_securities -- 是否资产证券化产品
            ,is_credit_item -- 是否信贷类项目
            ,investment_type -- 按投资产品类型划分
            ,raise_way -- 募集方式
            ,risk_assets_weight -- 风险资产权重（%）
            ,risky_assets_classify -- 风险资产分类
            ,g31_classify -- g31产品分类
            ,final_use_comp_relevance_info -- 最终用款企业关联方信息(华兴需求)
            ,business_category_min -- 行业细类
            ,mitigation_freq -- 缓释频率
            ,not_undasset_type -- 非底层资产分类
            ,not_undasset_type_two -- 非底层资产分类2
            ,invest_fund_part -- 投向产业基金的部分
            ,invest_market_part -- 投向市场化债转股相关产品的部分
            ,invest_finance_formanagepart -- 投向金融资产投资公司发行的私募资产管理产品
            ,invest_finance_forcapitalpart -- 投向金融资产投资公司或其附属机构发行的私募股权投资基金
            ,is_undasset_loan -- 底层资产是否为投放贷款
            ,middle_class -- 业务种类
            ,is_equity_product -- 是否为净值型产品
            ,special_purpose_vehicle_type -- 特定目的载体类型
            ,asset_product_statistics_code -- 资管产品统计编码
            ,issuer_region_code -- 发行人地区代码
            ,excute_mode -- 运行方式
            ,special_purpose_vehicle_code -- 特定目的载体代码
            ,issuer_code -- 发行人代码
            ,ensure_codes -- 
            ,is_nonstandard -- 
            ,is_publicoffer -- 
            ,fund_use -- 资金用途
            ,is_decide_openbusiness -- 是否定开业务
            ,openbusiness_begdate -- 开放周期
            ,excute_mode_hx -- 运行方式（华兴）
            ,special_purpose_vehicle_hx -- 特定目的载体代码（华兴）
            ,product_manager -- 产品管理方
            ,guarantee_description -- 担保描述
            ,investment_direction_max -- 资金投向大类
            ,investment_direction_min -- 资金投向小类
            ,under_debt_class -- 底层债分类
            ,under_debt_rating -- 底层债债项评级
            ,is_goverment_invest_fund -- 是否政府投资基金
            ,is_pioneer_invest_fund -- 是否创业投资基金
            ,is_remote_business -- 是否异地业务
            ,is_local_gover_invest_platform -- 是否地方政府融资平台
            ,add_credit_way -- 增信方式
            ,add_credit_subject_name -- 增信主体名称
            ,update_time -- 更新时间
            ,scale -- 企业规模
            ,pay_mode -- 还本付息方式
            ,industry_fund_amount -- 投向产业基金部分金额
            ,trade_platform -- 交易平台
            ,is_over_capacity -- 是否产能过剩行业
            ,is_shareholder -- 是否本行股东及其关联方
            ,structure_type -- 产品结构类型
            ,product_size -- 产品总规模
            ,senior_size -- 劣后规模
            ,investment_share_type -- 我行投资份额属于优先还是夹层
            ,private_fund_amount -- 投向金融资产投资公司或其附属机构发行的私募股权投资基金金额
            ,private_product_amount -- 投向金融资产投资公司发行的私募资产管理产品金额
            ,business_category_mid -- 投向行业中类
            ,through_type -- 穿透类型
            ,is_invest_debt -- 是否投向市场化债转股
            ,is_consumer_service -- 是否为消费服务类融资
            ,business_category_small -- 投向行业细类
            ,is_asset_secu -- 是否资产支持证券(1:是 0:否）
            ,is_no_grade_secu -- 是否无评级资产证券化(1:是 0:否）
            ,current_period_net -- 基金当前报告期净值
            ,fund_current_asset -- 基金当期总资产
            ,fund_sum_share -- 基金总份额
            ,has_third_report -- 是否有独立第三方报告
            ,information_source -- 信息来源
            ,lever_ratio -- 杠杆率
            ,report_date -- 报告日期
            ,report_period -- 报告期次
            ,risk_weight_trail -- 试算(基础资产权重录入)
            ,is_realty_loan -- 是否房地产开发贷款
            ,project_sum_invest -- 项目总投资
            ,capital_fund -- 资本金
            ,is_commer_housing -- 是否居住用房
            ,is_green_finance -- 是否属于绿色融资
            ,first_option_type -- 
            ,second_option_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_cashlb_manage_ele_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,coupon -- 合同利率
            ,final_use_comp -- 最终用款企业
            ,business_category -- 行业归属
            ,is_two_high_one_left -- 是否“两高一剩”，1是，0否
            ,is_government_platform -- 是否政府融资平台，1是，0否
            ,is_industry_fund -- 是否产业基金，1是，0否
            ,out_grade -- 外部评级
            ,in_grade -- 内部评级
            ,in_grade_mtr_date -- 内部评级到期日
            ,comp_area_province -- 用款企业所属区域（省）
            ,comp_area_city -- 用款企业所属区域（市）
            ,is_convert_debt_pro -- 是否投向市场化债转股相关产品
            ,und_asset_type_opt -- 底层资产类型
            ,management_mode -- 管理模式
            ,is_entrusted_loan -- 是否委托贷款
            ,num_of_carries -- spv载体个数
            ,approval_id -- 批复号
            ,total_goods_amount -- 产品总金额
            ,approval_amount -- 批复金额
            ,risk_weight -- 风险权重
            ,is_multi_financier -- 是否多融资人
            ,actual_financier_id -- 实际融资人客户号
            ,financier_nature -- 实际融资人客户性质
            ,parent_group -- 实际融资人所属集团
            ,is_asset_base_securities -- 是否资产证券化产品
            ,is_credit_item -- 是否信贷类项目
            ,investment_type -- 按投资产品类型划分
            ,raise_way -- 募集方式
            ,risk_assets_weight -- 风险资产权重（%）
            ,risky_assets_classify -- 风险资产分类
            ,g31_classify -- g31产品分类
            ,final_use_comp_relevance_info -- 最终用款企业关联方信息(华兴需求)
            ,business_category_min -- 行业细类
            ,mitigation_freq -- 缓释频率
            ,not_undasset_type -- 非底层资产分类
            ,not_undasset_type_two -- 非底层资产分类2
            ,invest_fund_part -- 投向产业基金的部分
            ,invest_market_part -- 投向市场化债转股相关产品的部分
            ,invest_finance_formanagepart -- 投向金融资产投资公司发行的私募资产管理产品
            ,invest_finance_forcapitalpart -- 投向金融资产投资公司或其附属机构发行的私募股权投资基金
            ,is_undasset_loan -- 底层资产是否为投放贷款
            ,middle_class -- 业务种类
            ,is_equity_product -- 是否为净值型产品
            ,special_purpose_vehicle_type -- 特定目的载体类型
            ,asset_product_statistics_code -- 资管产品统计编码
            ,issuer_region_code -- 发行人地区代码
            ,excute_mode -- 运行方式
            ,special_purpose_vehicle_code -- 特定目的载体代码
            ,issuer_code -- 发行人代码
            ,ensure_codes -- 
            ,is_nonstandard -- 
            ,is_publicoffer -- 
            ,fund_use -- 资金用途
            ,is_decide_openbusiness -- 是否定开业务
            ,openbusiness_begdate -- 开放周期
            ,excute_mode_hx -- 运行方式（华兴）
            ,special_purpose_vehicle_hx -- 特定目的载体代码（华兴）
            ,product_manager -- 产品管理方
            ,guarantee_description -- 担保描述
            ,investment_direction_max -- 资金投向大类
            ,investment_direction_min -- 资金投向小类
            ,under_debt_class -- 底层债分类
            ,under_debt_rating -- 底层债债项评级
            ,is_goverment_invest_fund -- 是否政府投资基金
            ,is_pioneer_invest_fund -- 是否创业投资基金
            ,is_remote_business -- 是否异地业务
            ,is_local_gover_invest_platform -- 是否地方政府融资平台
            ,add_credit_way -- 增信方式
            ,add_credit_subject_name -- 增信主体名称
            ,update_time -- 更新时间
            ,scale -- 企业规模
            ,pay_mode -- 还本付息方式
            ,industry_fund_amount -- 投向产业基金部分金额
            ,trade_platform -- 交易平台
            ,is_over_capacity -- 是否产能过剩行业
            ,is_shareholder -- 是否本行股东及其关联方
            ,structure_type -- 产品结构类型
            ,product_size -- 产品总规模
            ,senior_size -- 劣后规模
            ,investment_share_type -- 我行投资份额属于优先还是夹层
            ,private_fund_amount -- 投向金融资产投资公司或其附属机构发行的私募股权投资基金金额
            ,private_product_amount -- 投向金融资产投资公司发行的私募资产管理产品金额
            ,business_category_mid -- 投向行业中类
            ,through_type -- 穿透类型
            ,is_invest_debt -- 是否投向市场化债转股
            ,is_consumer_service -- 是否为消费服务类融资
            ,business_category_small -- 投向行业细类
            ,is_asset_secu -- 是否资产支持证券(1:是 0:否）
            ,is_no_grade_secu -- 是否无评级资产证券化(1:是 0:否）
            ,current_period_net -- 基金当前报告期净值
            ,fund_current_asset -- 基金当期总资产
            ,fund_sum_share -- 基金总份额
            ,has_third_report -- 是否有独立第三方报告
            ,information_source -- 信息来源
            ,lever_ratio -- 杠杆率
            ,report_date -- 报告日期
            ,report_period -- 报告期次
            ,risk_weight_trail -- 试算(基础资产权重录入)
            ,is_realty_loan -- 是否房地产开发贷款
            ,project_sum_invest -- 项目总投资
            ,capital_fund -- 资本金
            ,is_commer_housing -- 是否居住用房
            ,is_green_finance -- 是否属于绿色融资
            ,first_option_type -- 
            ,second_option_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 金融工具代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.coupon -- 合同利率
    ,o.final_use_comp -- 最终用款企业
    ,o.business_category -- 行业归属
    ,o.is_two_high_one_left -- 是否“两高一剩”，1是，0否
    ,o.is_government_platform -- 是否政府融资平台，1是，0否
    ,o.is_industry_fund -- 是否产业基金，1是，0否
    ,o.out_grade -- 外部评级
    ,o.in_grade -- 内部评级
    ,o.in_grade_mtr_date -- 内部评级到期日
    ,o.comp_area_province -- 用款企业所属区域（省）
    ,o.comp_area_city -- 用款企业所属区域（市）
    ,o.is_convert_debt_pro -- 是否投向市场化债转股相关产品
    ,o.und_asset_type_opt -- 底层资产类型
    ,o.management_mode -- 管理模式
    ,o.is_entrusted_loan -- 是否委托贷款
    ,o.num_of_carries -- spv载体个数
    ,o.approval_id -- 批复号
    ,o.total_goods_amount -- 产品总金额
    ,o.approval_amount -- 批复金额
    ,o.risk_weight -- 风险权重
    ,o.is_multi_financier -- 是否多融资人
    ,o.actual_financier_id -- 实际融资人客户号
    ,o.financier_nature -- 实际融资人客户性质
    ,o.parent_group -- 实际融资人所属集团
    ,o.is_asset_base_securities -- 是否资产证券化产品
    ,o.is_credit_item -- 是否信贷类项目
    ,o.investment_type -- 按投资产品类型划分
    ,o.raise_way -- 募集方式
    ,o.risk_assets_weight -- 风险资产权重（%）
    ,o.risky_assets_classify -- 风险资产分类
    ,o.g31_classify -- g31产品分类
    ,o.final_use_comp_relevance_info -- 最终用款企业关联方信息(华兴需求)
    ,o.business_category_min -- 行业细类
    ,o.mitigation_freq -- 缓释频率
    ,o.not_undasset_type -- 非底层资产分类
    ,o.not_undasset_type_two -- 非底层资产分类2
    ,o.invest_fund_part -- 投向产业基金的部分
    ,o.invest_market_part -- 投向市场化债转股相关产品的部分
    ,o.invest_finance_formanagepart -- 投向金融资产投资公司发行的私募资产管理产品
    ,o.invest_finance_forcapitalpart -- 投向金融资产投资公司或其附属机构发行的私募股权投资基金
    ,o.is_undasset_loan -- 底层资产是否为投放贷款
    ,o.middle_class -- 业务种类
    ,o.is_equity_product -- 是否为净值型产品
    ,o.special_purpose_vehicle_type -- 特定目的载体类型
    ,o.asset_product_statistics_code -- 资管产品统计编码
    ,o.issuer_region_code -- 发行人地区代码
    ,o.excute_mode -- 运行方式
    ,o.special_purpose_vehicle_code -- 特定目的载体代码
    ,o.issuer_code -- 发行人代码
    ,o.ensure_codes -- 
    ,o.is_nonstandard -- 
    ,o.is_publicoffer -- 
    ,o.fund_use -- 资金用途
    ,o.is_decide_openbusiness -- 是否定开业务
    ,o.openbusiness_begdate -- 开放周期
    ,o.excute_mode_hx -- 运行方式（华兴）
    ,o.special_purpose_vehicle_hx -- 特定目的载体代码（华兴）
    ,o.product_manager -- 产品管理方
    ,o.guarantee_description -- 担保描述
    ,o.investment_direction_max -- 资金投向大类
    ,o.investment_direction_min -- 资金投向小类
    ,o.under_debt_class -- 底层债分类
    ,o.under_debt_rating -- 底层债债项评级
    ,o.is_goverment_invest_fund -- 是否政府投资基金
    ,o.is_pioneer_invest_fund -- 是否创业投资基金
    ,o.is_remote_business -- 是否异地业务
    ,o.is_local_gover_invest_platform -- 是否地方政府融资平台
    ,o.add_credit_way -- 增信方式
    ,o.add_credit_subject_name -- 增信主体名称
    ,o.update_time -- 更新时间
    ,o.scale -- 企业规模
    ,o.pay_mode -- 还本付息方式
    ,o.industry_fund_amount -- 投向产业基金部分金额
    ,o.trade_platform -- 交易平台
    ,o.is_over_capacity -- 是否产能过剩行业
    ,o.is_shareholder -- 是否本行股东及其关联方
    ,o.structure_type -- 产品结构类型
    ,o.product_size -- 产品总规模
    ,o.senior_size -- 劣后规模
    ,o.investment_share_type -- 我行投资份额属于优先还是夹层
    ,o.private_fund_amount -- 投向金融资产投资公司或其附属机构发行的私募股权投资基金金额
    ,o.private_product_amount -- 投向金融资产投资公司发行的私募资产管理产品金额
    ,o.business_category_mid -- 投向行业中类
    ,o.through_type -- 穿透类型
    ,o.is_invest_debt -- 是否投向市场化债转股
    ,o.is_consumer_service -- 是否为消费服务类融资
    ,o.business_category_small -- 投向行业细类
    ,o.is_asset_secu -- 是否资产支持证券(1:是 0:否）
    ,o.is_no_grade_secu -- 是否无评级资产证券化(1:是 0:否）
    ,o.current_period_net -- 基金当前报告期净值
    ,o.fund_current_asset -- 基金当期总资产
    ,o.fund_sum_share -- 基金总份额
    ,o.has_third_report -- 是否有独立第三方报告
    ,o.information_source -- 信息来源
    ,o.lever_ratio -- 杠杆率
    ,o.report_date -- 报告日期
    ,o.report_period -- 报告期次
    ,o.risk_weight_trail -- 试算(基础资产权重录入)
    ,o.is_realty_loan -- 是否房地产开发贷款
    ,o.project_sum_invest -- 项目总投资
    ,o.capital_fund -- 资本金
    ,o.is_commer_housing -- 是否居住用房
    ,o.is_green_finance -- 是否属于绿色融资
    ,o.first_option_type -- 
    ,o.second_option_type -- 
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
from ${iol_schema}.ibms_ttrd_cashlb_manage_ele_bk o
    left join ${iol_schema}.ibms_ttrd_cashlb_manage_ele_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_cashlb_manage_ele_cl d
        on
            o.i_code = d.i_code
            and o.a_type = d.a_type
            and o.m_type = d.m_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_cashlb_manage_ele;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_cashlb_manage_ele') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_cashlb_manage_ele drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_cashlb_manage_ele add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_cashlb_manage_ele exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_cashlb_manage_ele_cl;
alter table ${iol_schema}.ibms_ttrd_cashlb_manage_ele exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_cashlb_manage_ele_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_cashlb_manage_ele to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_cashlb_manage_ele_op purge;
drop table ${iol_schema}.ibms_ttrd_cashlb_manage_ele_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_cashlb_manage_ele_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_cashlb_manage_ele',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
