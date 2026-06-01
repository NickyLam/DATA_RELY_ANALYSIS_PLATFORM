/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_cashlb_manage_ele
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_cashlb_manage_ele
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_cashlb_manage_ele purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_cashlb_manage_ele(
    i_code varchar2(75) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,coupon number(14,8) -- 合同利率
    ,final_use_comp varchar2(383) -- 最终用款企业
    ,business_category varchar2(3) -- 行业归属
    ,is_two_high_one_left varchar2(2) -- 是否“两高一剩”，1是，0否
    ,is_government_platform varchar2(2) -- 是否政府融资平台，1是，0否
    ,is_industry_fund varchar2(2) -- 是否产业基金，1是，0否
    ,out_grade varchar2(15) -- 外部评级
    ,in_grade varchar2(15) -- 内部评级
    ,in_grade_mtr_date varchar2(15) -- 内部评级到期日
    ,comp_area_province varchar2(150) -- 用款企业所属区域（省）
    ,comp_area_city varchar2(150) -- 用款企业所属区域（市）
    ,is_convert_debt_pro varchar2(2) -- 是否投向市场化债转股相关产品
    ,und_asset_type_opt varchar2(12) -- 底层资产类型
    ,management_mode varchar2(12) -- 管理模式
    ,is_entrusted_loan varchar2(2) -- 是否委托贷款
    ,num_of_carries varchar2(12) -- spv载体个数
    ,approval_id varchar2(90) -- 批复号
    ,total_goods_amount number(31,4) -- 产品总金额
    ,approval_amount number(31,4) -- 批复金额
    ,risk_weight varchar2(30) -- 风险权重
    ,is_multi_financier varchar2(2) -- 是否多融资人
    ,actual_financier_id varchar2(90) -- 实际融资人客户号
    ,financier_nature varchar2(150) -- 实际融资人客户性质
    ,parent_group varchar2(383) -- 实际融资人所属集团
    ,is_asset_base_securities varchar2(2) -- 是否资产证券化产品
    ,is_credit_item varchar2(2) -- 是否信贷类项目
    ,investment_type varchar2(6) -- 按投资产品类型划分
    ,raise_way varchar2(75) -- 募集方式
    ,risk_assets_weight varchar2(75) -- 风险资产权重（%）
    ,risky_assets_classify varchar2(75) -- 风险资产分类
    ,g31_classify varchar2(75) -- g31产品分类
    ,final_use_comp_relevance_info varchar2(3000) -- 最终用款企业关联方信息(华兴需求)
    ,business_category_min varchar2(75) -- 行业细类
    ,mitigation_freq varchar2(15) -- 缓释频率
    ,not_undasset_type varchar2(15) -- 非底层资产分类
    ,not_undasset_type_two varchar2(15) -- 非底层资产分类2
    ,invest_fund_part number(33,8) -- 投向产业基金的部分
    ,invest_market_part number(33,8) -- 投向市场化债转股相关产品的部分
    ,invest_finance_formanagepart number(33,8) -- 投向金融资产投资公司发行的私募资产管理产品
    ,invest_finance_forcapitalpart number(33,8) -- 投向金融资产投资公司或其附属机构发行的私募股权投资基金
    ,is_undasset_loan varchar2(2) -- 底层资产是否为投放贷款
    ,middle_class varchar2(75) -- 业务种类
    ,is_equity_product varchar2(2) -- 是否为净值型产品
    ,special_purpose_vehicle_type varchar2(75) -- 特定目的载体类型
    ,asset_product_statistics_code varchar2(75) -- 资管产品统计编码
    ,issuer_region_code varchar2(75) -- 发行人地区代码
    ,excute_mode varchar2(75) -- 运行方式
    ,special_purpose_vehicle_code varchar2(75) -- 特定目的载体代码
    ,issuer_code varchar2(75) -- 发行人代码
    ,ensure_codes varchar2(1500) -- 
    ,is_nonstandard varchar2(2) -- 
    ,is_publicoffer varchar2(2) -- 
    ,fund_use varchar2(150) -- 资金用途
    ,is_decide_openbusiness varchar2(2) -- 是否定开业务
    ,openbusiness_begdate varchar2(30) -- 开放周期
    ,excute_mode_hx varchar2(75) -- 运行方式（华兴）
    ,special_purpose_vehicle_hx varchar2(383) -- 特定目的载体代码（华兴）
    ,product_manager varchar2(383) -- 产品管理方
    ,guarantee_description varchar2(383) -- 担保描述
    ,investment_direction_max varchar2(75) -- 资金投向大类
    ,investment_direction_min varchar2(75) -- 资金投向小类
    ,under_debt_class varchar2(75) -- 底层债分类
    ,under_debt_rating varchar2(383) -- 底层债债项评级
    ,is_goverment_invest_fund varchar2(2) -- 是否政府投资基金
    ,is_pioneer_invest_fund varchar2(2) -- 是否创业投资基金
    ,is_remote_business varchar2(2) -- 是否异地业务
    ,is_local_gover_invest_platform varchar2(2) -- 是否地方政府融资平台
    ,add_credit_way varchar2(75) -- 增信方式
    ,add_credit_subject_name varchar2(383) -- 增信主体名称
    ,update_time varchar2(29) -- 更新时间
    ,scale varchar2(6) -- 企业规模
    ,pay_mode varchar2(2) -- 还本付息方式
    ,industry_fund_amount number(31,4) -- 投向产业基金部分金额
    ,trade_platform varchar2(2) -- 交易平台
    ,is_over_capacity varchar2(2) -- 是否产能过剩行业
    ,is_shareholder varchar2(2) -- 是否本行股东及其关联方
    ,structure_type varchar2(75) -- 产品结构类型
    ,product_size number(31,4) -- 产品总规模
    ,senior_size number(31,4) -- 劣后规模
    ,investment_share_type varchar2(2) -- 我行投资份额属于优先还是夹层
    ,private_fund_amount number(31,4) -- 投向金融资产投资公司或其附属机构发行的私募股权投资基金金额
    ,private_product_amount number(31,4) -- 投向金融资产投资公司发行的私募资产管理产品金额
    ,business_category_mid varchar2(75) -- 投向行业中类
    ,through_type varchar2(45) -- 穿透类型
    ,is_invest_debt varchar2(2) -- 是否投向市场化债转股
    ,is_consumer_service varchar2(2) -- 是否为消费服务类融资
    ,business_category_small varchar2(75) -- 投向行业细类
    ,is_asset_secu varchar2(2) -- 是否资产支持证券(1:是 0:否）
    ,is_no_grade_secu varchar2(2) -- 是否无评级资产证券化(1:是 0:否）
    ,current_period_net number(18,6) -- 基金当前报告期净值
    ,fund_current_asset number(14,2) -- 基金当期总资产
    ,fund_sum_share number(14,2) -- 基金总份额
    ,has_third_report varchar2(5) -- 是否有独立第三方报告
    ,information_source varchar2(5) -- 信息来源
    ,lever_ratio number(16,4) -- 杠杆率
    ,report_date varchar2(15) -- 报告日期
    ,report_period varchar2(48) -- 报告期次
    ,risk_weight_trail number(16,4) -- 试算(基础资产权重录入)
    ,is_realty_loan varchar2(2) -- 是否房地产开发贷款
    ,project_sum_invest number(31,4) -- 项目总投资
    ,capital_fund number(31,4) -- 资本金
    ,is_commer_housing varchar2(2) -- 是否居住用房
    ,is_green_finance varchar2(2) -- 是否属于绿色融资
    ,first_option_type varchar2(6) -- 
    ,second_option_type varchar2(15) -- 
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
grant select on ${iol_schema}.ibms_ttrd_cashlb_manage_ele to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_cashlb_manage_ele to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_cashlb_manage_ele to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_cashlb_manage_ele to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_cashlb_manage_ele is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.coupon is '合同利率';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.final_use_comp is '最终用款企业';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.business_category is '行业归属';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_two_high_one_left is '是否“两高一剩”，1是，0否';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_government_platform is '是否政府融资平台，1是，0否';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_industry_fund is '是否产业基金，1是，0否';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.out_grade is '外部评级';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.in_grade is '内部评级';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.in_grade_mtr_date is '内部评级到期日';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.comp_area_province is '用款企业所属区域（省）';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.comp_area_city is '用款企业所属区域（市）';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_convert_debt_pro is '是否投向市场化债转股相关产品';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.und_asset_type_opt is '底层资产类型';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.management_mode is '管理模式';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_entrusted_loan is '是否委托贷款';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.num_of_carries is 'spv载体个数';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.approval_id is '批复号';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.total_goods_amount is '产品总金额';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.approval_amount is '批复金额';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.risk_weight is '风险权重';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_multi_financier is '是否多融资人';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.actual_financier_id is '实际融资人客户号';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.financier_nature is '实际融资人客户性质';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.parent_group is '实际融资人所属集团';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_asset_base_securities is '是否资产证券化产品';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_credit_item is '是否信贷类项目';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.investment_type is '按投资产品类型划分';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.raise_way is '募集方式';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.risk_assets_weight is '风险资产权重（%）';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.risky_assets_classify is '风险资产分类';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.g31_classify is 'g31产品分类';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.final_use_comp_relevance_info is '最终用款企业关联方信息(华兴需求)';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.business_category_min is '行业细类';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.mitigation_freq is '缓释频率';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.not_undasset_type is '非底层资产分类';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.not_undasset_type_two is '非底层资产分类2';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.invest_fund_part is '投向产业基金的部分';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.invest_market_part is '投向市场化债转股相关产品的部分';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.invest_finance_formanagepart is '投向金融资产投资公司发行的私募资产管理产品';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.invest_finance_forcapitalpart is '投向金融资产投资公司或其附属机构发行的私募股权投资基金';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_undasset_loan is '底层资产是否为投放贷款';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.middle_class is '业务种类';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_equity_product is '是否为净值型产品';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.special_purpose_vehicle_type is '特定目的载体类型';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.asset_product_statistics_code is '资管产品统计编码';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.issuer_region_code is '发行人地区代码';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.excute_mode is '运行方式';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.special_purpose_vehicle_code is '特定目的载体代码';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.issuer_code is '发行人代码';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.ensure_codes is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_nonstandard is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_publicoffer is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.fund_use is '资金用途';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_decide_openbusiness is '是否定开业务';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.openbusiness_begdate is '开放周期';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.excute_mode_hx is '运行方式（华兴）';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.special_purpose_vehicle_hx is '特定目的载体代码（华兴）';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.product_manager is '产品管理方';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.guarantee_description is '担保描述';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.investment_direction_max is '资金投向大类';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.investment_direction_min is '资金投向小类';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.under_debt_class is '底层债分类';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.under_debt_rating is '底层债债项评级';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_goverment_invest_fund is '是否政府投资基金';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_pioneer_invest_fund is '是否创业投资基金';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_remote_business is '是否异地业务';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_local_gover_invest_platform is '是否地方政府融资平台';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.add_credit_way is '增信方式';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.add_credit_subject_name is '增信主体名称';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.scale is '企业规模';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.pay_mode is '还本付息方式';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.industry_fund_amount is '投向产业基金部分金额';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.trade_platform is '交易平台';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_over_capacity is '是否产能过剩行业';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_shareholder is '是否本行股东及其关联方';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.structure_type is '产品结构类型';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.product_size is '产品总规模';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.senior_size is '劣后规模';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.investment_share_type is '我行投资份额属于优先还是夹层';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.private_fund_amount is '投向金融资产投资公司或其附属机构发行的私募股权投资基金金额';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.private_product_amount is '投向金融资产投资公司发行的私募资产管理产品金额';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.business_category_mid is '投向行业中类';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.through_type is '穿透类型';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_invest_debt is '是否投向市场化债转股';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_consumer_service is '是否为消费服务类融资';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.business_category_small is '投向行业细类';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_asset_secu is '是否资产支持证券(1:是 0:否）';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_no_grade_secu is '是否无评级资产证券化(1:是 0:否）';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.current_period_net is '基金当前报告期净值';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.fund_current_asset is '基金当期总资产';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.fund_sum_share is '基金总份额';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.has_third_report is '是否有独立第三方报告';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.information_source is '信息来源';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.lever_ratio is '杠杆率';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.report_date is '报告日期';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.report_period is '报告期次';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.risk_weight_trail is '试算(基础资产权重录入)';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_realty_loan is '是否房地产开发贷款';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.project_sum_invest is '项目总投资';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.capital_fund is '资本金';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_commer_housing is '是否居住用房';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.is_green_finance is '是否属于绿色融资';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.first_option_type is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.second_option_type is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_cashlb_manage_ele.etl_timestamp is 'ETL处理时间戳';
