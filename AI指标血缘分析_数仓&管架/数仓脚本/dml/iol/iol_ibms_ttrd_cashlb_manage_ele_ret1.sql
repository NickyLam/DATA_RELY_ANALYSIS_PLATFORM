/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_cashlb_manage_ele
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM ibms_ttrd_cashlb_manage_ele_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ibms_ttrd_cashlb_manage_ele');
  
  if v_var <> 0 then 
    execute immediate 'alter table ibms_ttrd_cashlb_manage_ele drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ibms_ttrd_cashlb_manage_ele add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ibms_ttrd_cashlb_manage_ele(
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
			,' ' as first_option_type -- 
            ,' ' as second_option_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ibms_ttrd_cashlb_manage_ele_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
