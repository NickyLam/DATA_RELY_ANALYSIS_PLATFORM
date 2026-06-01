/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_hgls_loan_micro_entity
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
create table ${iol_schema}.hgls_loan_micro_entity_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.hgls_loan_micro_entity
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_loan_micro_entity_op purge;
drop table ${iol_schema}.hgls_loan_micro_entity_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_loan_micro_entity_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_loan_micro_entity where 0=1;

create table ${iol_schema}.hgls_loan_micro_entity_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_loan_micro_entity where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_loan_micro_entity_cl(
            entity_id -- 经营主体信息主键ID
            ,code -- 业务code
            ,loan_id -- 进件id
            ,entloan_apply_id -- 企业申请信息表id
            ,name -- 企业名称
            ,legal_person -- 法定代表人姓名
            ,scope -- 企业所属行业
            ,ownership_info -- 企业权属情况
            ,ownership_rate -- 企业股权占比情况
            ,ownership_change -- 企业法人/股东变更情况
            ,legal_form -- 企业类型
            ,is_main_business -- 申请企业是否为主营业务
            ,space_ownership -- 经营场所权属情况
            ,space_address -- 经营场所地址
            ,profit_model -- 盈利模式
            ,province_region -- 家庭住址的省市区,多级斜杠隔开
            ,space_stability -- 企业地域稳定情况
            ,space_area -- 经营场所面积
            ,business_time -- 经营时长（单位：月）
            ,is_repenish_data -- 是否需要补充信息
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,credit_score -- 企业信用分
            ,reg_num -- 注册编码
            ,regist_time -- 注册时间
            ,regist_capital -- 注册资金
            ,business_ownership -- 生意权属
            ,customer_type -- 客户类型，1正常用户，2征信白户
            ,risk_point_num -- 风险点个数
            ,customer_stock_rights -- 主借款人股权
            ,spouse_stock_rights -- 配偶股权
            ,relevance_enterpr -- 关联企业
            ,credit_code -- 统一社会信用代码
            ,medium_signature_code -- 中征码
            ,business_scope -- 经营范围
            ,business_case -- 合法经营情况
            ,regist_adress -- 注册地址
            ,currency -- 币种
            ,has_relevance_enterpr -- 有无关联企业
            ,has_change_for_fg -- 历史法人/股东是否存在变更
            ,employees_num -- 企业员工数
            ,space_area_select -- 经营场所面积（选择）
            ,business_year -- 经营年限
            ,low_season_month -- 淡季月份
            ,peak_season_month -- 旺季月份
            ,flat_season_month -- 平季月份
            ,household_ratio -- 客户家庭股权占比
            ,tax_info -- 纳税情况
            ,industry_cycle -- 行业周期
            ,remarks -- 备注
            ,overseas_investment -- 对外股权投资情况
            ,main_business -- 主营业务描述
            ,real_estate_qualifications -- 房地产资质情况
            ,import_and_export_trade -- 进出口贸易情况
            ,situation_of_franchising_industry -- 特许经营行业情况
            ,related_authentication -- 相关认证信息
            ,discharge_permit -- 排污许可信息
            ,customer_litigation -- 客户涉诉信息
            ,customer_events -- 客户大事记
            ,customer_situation -- 客户情况分析
            ,paid_in_capital -- 实收资本
            ,electricity_total -- 电费总计
            ,can_reconsider -- 是否可以复议：true 可以 fals 不可以
            ,entity_access_model -- 企业准入模型是否通过：不通过，通过
            ,reject_reason -- 拒绝原因
            ,consider_status -- 复议状态
            ,to_time -- 营业期限止（到期时间）
            ,core_cust_no -- 核心客户号
            ,business_license_type -- yezzlx营业执照类型:1个体工商户、2企业、3无营业执照
            ,relationship_of_enterprise -- jkryqygx借款人与企业关系
            ,scale_judgment -- 企业规模：1大型、2中型、3小型、4微型、5其它
            ,share_ratio -- 主借人&配偶所占股份比例，0-100%，必填。
            ,share_change -- 主借人&配偶所占股份比例，0-100%，必填。
            ,legal_person_cert_no -- 企业法人身份证号
            ,enterprise_classification -- 企业划型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_loan_micro_entity_op(
            entity_id -- 经营主体信息主键ID
            ,code -- 业务code
            ,loan_id -- 进件id
            ,entloan_apply_id -- 企业申请信息表id
            ,name -- 企业名称
            ,legal_person -- 法定代表人姓名
            ,scope -- 企业所属行业
            ,ownership_info -- 企业权属情况
            ,ownership_rate -- 企业股权占比情况
            ,ownership_change -- 企业法人/股东变更情况
            ,legal_form -- 企业类型
            ,is_main_business -- 申请企业是否为主营业务
            ,space_ownership -- 经营场所权属情况
            ,space_address -- 经营场所地址
            ,profit_model -- 盈利模式
            ,province_region -- 家庭住址的省市区,多级斜杠隔开
            ,space_stability -- 企业地域稳定情况
            ,space_area -- 经营场所面积
            ,business_time -- 经营时长（单位：月）
            ,is_repenish_data -- 是否需要补充信息
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,credit_score -- 企业信用分
            ,reg_num -- 注册编码
            ,regist_time -- 注册时间
            ,regist_capital -- 注册资金
            ,business_ownership -- 生意权属
            ,customer_type -- 客户类型，1正常用户，2征信白户
            ,risk_point_num -- 风险点个数
            ,customer_stock_rights -- 主借款人股权
            ,spouse_stock_rights -- 配偶股权
            ,relevance_enterpr -- 关联企业
            ,credit_code -- 统一社会信用代码
            ,medium_signature_code -- 中征码
            ,business_scope -- 经营范围
            ,business_case -- 合法经营情况
            ,regist_adress -- 注册地址
            ,currency -- 币种
            ,has_relevance_enterpr -- 有无关联企业
            ,has_change_for_fg -- 历史法人/股东是否存在变更
            ,employees_num -- 企业员工数
            ,space_area_select -- 经营场所面积（选择）
            ,business_year -- 经营年限
            ,low_season_month -- 淡季月份
            ,peak_season_month -- 旺季月份
            ,flat_season_month -- 平季月份
            ,household_ratio -- 客户家庭股权占比
            ,tax_info -- 纳税情况
            ,industry_cycle -- 行业周期
            ,remarks -- 备注
            ,overseas_investment -- 对外股权投资情况
            ,main_business -- 主营业务描述
            ,real_estate_qualifications -- 房地产资质情况
            ,import_and_export_trade -- 进出口贸易情况
            ,situation_of_franchising_industry -- 特许经营行业情况
            ,related_authentication -- 相关认证信息
            ,discharge_permit -- 排污许可信息
            ,customer_litigation -- 客户涉诉信息
            ,customer_events -- 客户大事记
            ,customer_situation -- 客户情况分析
            ,paid_in_capital -- 实收资本
            ,electricity_total -- 电费总计
            ,can_reconsider -- 是否可以复议：true 可以 fals 不可以
            ,entity_access_model -- 企业准入模型是否通过：不通过，通过
            ,reject_reason -- 拒绝原因
            ,consider_status -- 复议状态
            ,to_time -- 营业期限止（到期时间）
            ,core_cust_no -- 核心客户号
            ,business_license_type -- yezzlx营业执照类型:1个体工商户、2企业、3无营业执照
            ,relationship_of_enterprise -- jkryqygx借款人与企业关系
            ,scale_judgment -- 企业规模：1大型、2中型、3小型、4微型、5其它
            ,share_ratio -- 主借人&配偶所占股份比例，0-100%，必填。
            ,share_change -- 主借人&配偶所占股份比例，0-100%，必填。
            ,legal_person_cert_no -- 企业法人身份证号
            ,enterprise_classification -- 企业划型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.entity_id, o.entity_id) as entity_id -- 经营主体信息主键ID
    ,nvl(n.code, o.code) as code -- 业务code
    ,nvl(n.loan_id, o.loan_id) as loan_id -- 进件id
    ,nvl(n.entloan_apply_id, o.entloan_apply_id) as entloan_apply_id -- 企业申请信息表id
    ,nvl(n.name, o.name) as name -- 企业名称
    ,nvl(n.legal_person, o.legal_person) as legal_person -- 法定代表人姓名
    ,nvl(n.scope, o.scope) as scope -- 企业所属行业
    ,nvl(n.ownership_info, o.ownership_info) as ownership_info -- 企业权属情况
    ,nvl(n.ownership_rate, o.ownership_rate) as ownership_rate -- 企业股权占比情况
    ,nvl(n.ownership_change, o.ownership_change) as ownership_change -- 企业法人/股东变更情况
    ,nvl(n.legal_form, o.legal_form) as legal_form -- 企业类型
    ,nvl(n.is_main_business, o.is_main_business) as is_main_business -- 申请企业是否为主营业务
    ,nvl(n.space_ownership, o.space_ownership) as space_ownership -- 经营场所权属情况
    ,nvl(n.space_address, o.space_address) as space_address -- 经营场所地址
    ,nvl(n.profit_model, o.profit_model) as profit_model -- 盈利模式
    ,nvl(n.province_region, o.province_region) as province_region -- 家庭住址的省市区,多级斜杠隔开
    ,nvl(n.space_stability, o.space_stability) as space_stability -- 企业地域稳定情况
    ,nvl(n.space_area, o.space_area) as space_area -- 经营场所面积
    ,nvl(n.business_time, o.business_time) as business_time -- 经营时长（单位：月）
    ,nvl(n.is_repenish_data, o.is_repenish_data) as is_repenish_data -- 是否需要补充信息
    ,nvl(n.create_date, o.create_date) as create_date -- 申请日期
    ,nvl(n.update_date, o.update_date) as update_date -- 更新时间
    ,nvl(n.credit_score, o.credit_score) as credit_score -- 企业信用分
    ,nvl(n.reg_num, o.reg_num) as reg_num -- 注册编码
    ,nvl(n.regist_time, o.regist_time) as regist_time -- 注册时间
    ,nvl(n.regist_capital, o.regist_capital) as regist_capital -- 注册资金
    ,nvl(n.business_ownership, o.business_ownership) as business_ownership -- 生意权属
    ,nvl(n.customer_type, o.customer_type) as customer_type -- 客户类型，1正常用户，2征信白户
    ,nvl(n.risk_point_num, o.risk_point_num) as risk_point_num -- 风险点个数
    ,nvl(n.customer_stock_rights, o.customer_stock_rights) as customer_stock_rights -- 主借款人股权
    ,nvl(n.spouse_stock_rights, o.spouse_stock_rights) as spouse_stock_rights -- 配偶股权
    ,nvl(n.relevance_enterpr, o.relevance_enterpr) as relevance_enterpr -- 关联企业
    ,nvl(n.credit_code, o.credit_code) as credit_code -- 统一社会信用代码
    ,nvl(n.medium_signature_code, o.medium_signature_code) as medium_signature_code -- 中征码
    ,nvl(n.business_scope, o.business_scope) as business_scope -- 经营范围
    ,nvl(n.business_case, o.business_case) as business_case -- 合法经营情况
    ,nvl(n.regist_adress, o.regist_adress) as regist_adress -- 注册地址
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.has_relevance_enterpr, o.has_relevance_enterpr) as has_relevance_enterpr -- 有无关联企业
    ,nvl(n.has_change_for_fg, o.has_change_for_fg) as has_change_for_fg -- 历史法人/股东是否存在变更
    ,nvl(n.employees_num, o.employees_num) as employees_num -- 企业员工数
    ,nvl(n.space_area_select, o.space_area_select) as space_area_select -- 经营场所面积（选择）
    ,nvl(n.business_year, o.business_year) as business_year -- 经营年限
    ,nvl(n.low_season_month, o.low_season_month) as low_season_month -- 淡季月份
    ,nvl(n.peak_season_month, o.peak_season_month) as peak_season_month -- 旺季月份
    ,nvl(n.flat_season_month, o.flat_season_month) as flat_season_month -- 平季月份
    ,nvl(n.household_ratio, o.household_ratio) as household_ratio -- 客户家庭股权占比
    ,nvl(n.tax_info, o.tax_info) as tax_info -- 纳税情况
    ,nvl(n.industry_cycle, o.industry_cycle) as industry_cycle -- 行业周期
    ,nvl(n.remarks, o.remarks) as remarks -- 备注
    ,nvl(n.overseas_investment, o.overseas_investment) as overseas_investment -- 对外股权投资情况
    ,nvl(n.main_business, o.main_business) as main_business -- 主营业务描述
    ,nvl(n.real_estate_qualifications, o.real_estate_qualifications) as real_estate_qualifications -- 房地产资质情况
    ,nvl(n.import_and_export_trade, o.import_and_export_trade) as import_and_export_trade -- 进出口贸易情况
    ,nvl(n.situation_of_franchising_industry, o.situation_of_franchising_industry) as situation_of_franchising_industry -- 特许经营行业情况
    ,nvl(n.related_authentication, o.related_authentication) as related_authentication -- 相关认证信息
    ,nvl(n.discharge_permit, o.discharge_permit) as discharge_permit -- 排污许可信息
    ,nvl(n.customer_litigation, o.customer_litigation) as customer_litigation -- 客户涉诉信息
    ,nvl(n.customer_events, o.customer_events) as customer_events -- 客户大事记
    ,nvl(n.customer_situation, o.customer_situation) as customer_situation -- 客户情况分析
    ,nvl(n.paid_in_capital, o.paid_in_capital) as paid_in_capital -- 实收资本
    ,nvl(n.electricity_total, o.electricity_total) as electricity_total -- 电费总计
    ,nvl(n.can_reconsider, o.can_reconsider) as can_reconsider -- 是否可以复议：true 可以 fals 不可以
    ,nvl(n.entity_access_model, o.entity_access_model) as entity_access_model -- 企业准入模型是否通过：不通过，通过
    ,nvl(n.reject_reason, o.reject_reason) as reject_reason -- 拒绝原因
    ,nvl(n.consider_status, o.consider_status) as consider_status -- 复议状态
    ,nvl(n.to_time, o.to_time) as to_time -- 营业期限止（到期时间）
    ,nvl(n.core_cust_no, o.core_cust_no) as core_cust_no -- 核心客户号
    ,nvl(n.business_license_type, o.business_license_type) as business_license_type -- yezzlx营业执照类型:1个体工商户、2企业、3无营业执照
    ,nvl(n.relationship_of_enterprise, o.relationship_of_enterprise) as relationship_of_enterprise -- jkryqygx借款人与企业关系
    ,nvl(n.scale_judgment, o.scale_judgment) as scale_judgment -- 企业规模：1大型、2中型、3小型、4微型、5其它
    ,nvl(n.share_ratio, o.share_ratio) as share_ratio -- 主借人&配偶所占股份比例，0-100%，必填。
    ,nvl(n.share_change, o.share_change) as share_change -- 主借人&配偶所占股份比例，0-100%，必填。
    ,nvl(n.legal_person_cert_no, o.legal_person_cert_no) as legal_person_cert_no -- 企业法人身份证号
    ,nvl(n.enterprise_classification, o.enterprise_classification) as enterprise_classification -- 企业划型
    ,case when
            n.entity_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.entity_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.entity_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.hgls_loan_micro_entity_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.hgls_loan_micro_entity where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.entity_id = n.entity_id
where (
        o.entity_id is null
    )
    or (
        n.entity_id is null
    )
    or (
        o.code <> n.code
        or o.loan_id <> n.loan_id
        or o.entloan_apply_id <> n.entloan_apply_id
        or o.name <> n.name
        or o.legal_person <> n.legal_person
        or o.scope <> n.scope
        or o.ownership_info <> n.ownership_info
        or o.ownership_rate <> n.ownership_rate
        or o.ownership_change <> n.ownership_change
        or o.legal_form <> n.legal_form
        or o.is_main_business <> n.is_main_business
        or o.space_ownership <> n.space_ownership
        or o.space_address <> n.space_address
        or o.profit_model <> n.profit_model
        or o.province_region <> n.province_region
        or o.space_stability <> n.space_stability
        or o.space_area <> n.space_area
        or o.business_time <> n.business_time
        or o.is_repenish_data <> n.is_repenish_data
        or o.create_date <> n.create_date
        or o.update_date <> n.update_date
        or o.credit_score <> n.credit_score
        or o.reg_num <> n.reg_num
        or o.regist_time <> n.regist_time
        or o.regist_capital <> n.regist_capital
        or o.business_ownership <> n.business_ownership
        or o.customer_type <> n.customer_type
        or o.risk_point_num <> n.risk_point_num
        or o.customer_stock_rights <> n.customer_stock_rights
        or o.spouse_stock_rights <> n.spouse_stock_rights
        or o.relevance_enterpr <> n.relevance_enterpr
        or o.credit_code <> n.credit_code
        or o.medium_signature_code <> n.medium_signature_code
        or o.business_scope <> n.business_scope
        or o.business_case <> n.business_case
        or o.regist_adress <> n.regist_adress
        or o.currency <> n.currency
        or o.has_relevance_enterpr <> n.has_relevance_enterpr
        or o.has_change_for_fg <> n.has_change_for_fg
        or o.employees_num <> n.employees_num
        or o.space_area_select <> n.space_area_select
        or o.business_year <> n.business_year
        or o.low_season_month <> n.low_season_month
        or o.peak_season_month <> n.peak_season_month
        or o.flat_season_month <> n.flat_season_month
        or o.household_ratio <> n.household_ratio
        or o.tax_info <> n.tax_info
        or o.industry_cycle <> n.industry_cycle
        or o.remarks <> n.remarks
        or o.overseas_investment <> n.overseas_investment
        or o.main_business <> n.main_business
        or o.real_estate_qualifications <> n.real_estate_qualifications
        or o.import_and_export_trade <> n.import_and_export_trade
        or o.situation_of_franchising_industry <> n.situation_of_franchising_industry
        or o.related_authentication <> n.related_authentication
        or o.discharge_permit <> n.discharge_permit
        or o.customer_litigation <> n.customer_litigation
        or o.customer_events <> n.customer_events
        or o.customer_situation <> n.customer_situation
        or o.paid_in_capital <> n.paid_in_capital
        or o.electricity_total <> n.electricity_total
        or o.can_reconsider <> n.can_reconsider
        or o.entity_access_model <> n.entity_access_model
        or o.reject_reason <> n.reject_reason
        or o.consider_status <> n.consider_status
        or o.to_time <> n.to_time
        or o.core_cust_no <> n.core_cust_no
        or o.business_license_type <> n.business_license_type
        or o.relationship_of_enterprise <> n.relationship_of_enterprise
        or o.scale_judgment <> n.scale_judgment
        or o.share_ratio <> n.share_ratio
        or o.share_change <> n.share_change
        or o.legal_person_cert_no <> n.legal_person_cert_no
        or o.enterprise_classification <> n.enterprise_classification
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_loan_micro_entity_cl(
            entity_id -- 经营主体信息主键ID
            ,code -- 业务code
            ,loan_id -- 进件id
            ,entloan_apply_id -- 企业申请信息表id
            ,name -- 企业名称
            ,legal_person -- 法定代表人姓名
            ,scope -- 企业所属行业
            ,ownership_info -- 企业权属情况
            ,ownership_rate -- 企业股权占比情况
            ,ownership_change -- 企业法人/股东变更情况
            ,legal_form -- 企业类型
            ,is_main_business -- 申请企业是否为主营业务
            ,space_ownership -- 经营场所权属情况
            ,space_address -- 经营场所地址
            ,profit_model -- 盈利模式
            ,province_region -- 家庭住址的省市区,多级斜杠隔开
            ,space_stability -- 企业地域稳定情况
            ,space_area -- 经营场所面积
            ,business_time -- 经营时长（单位：月）
            ,is_repenish_data -- 是否需要补充信息
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,credit_score -- 企业信用分
            ,reg_num -- 注册编码
            ,regist_time -- 注册时间
            ,regist_capital -- 注册资金
            ,business_ownership -- 生意权属
            ,customer_type -- 客户类型，1正常用户，2征信白户
            ,risk_point_num -- 风险点个数
            ,customer_stock_rights -- 主借款人股权
            ,spouse_stock_rights -- 配偶股权
            ,relevance_enterpr -- 关联企业
            ,credit_code -- 统一社会信用代码
            ,medium_signature_code -- 中征码
            ,business_scope -- 经营范围
            ,business_case -- 合法经营情况
            ,regist_adress -- 注册地址
            ,currency -- 币种
            ,has_relevance_enterpr -- 有无关联企业
            ,has_change_for_fg -- 历史法人/股东是否存在变更
            ,employees_num -- 企业员工数
            ,space_area_select -- 经营场所面积（选择）
            ,business_year -- 经营年限
            ,low_season_month -- 淡季月份
            ,peak_season_month -- 旺季月份
            ,flat_season_month -- 平季月份
            ,household_ratio -- 客户家庭股权占比
            ,tax_info -- 纳税情况
            ,industry_cycle -- 行业周期
            ,remarks -- 备注
            ,overseas_investment -- 对外股权投资情况
            ,main_business -- 主营业务描述
            ,real_estate_qualifications -- 房地产资质情况
            ,import_and_export_trade -- 进出口贸易情况
            ,situation_of_franchising_industry -- 特许经营行业情况
            ,related_authentication -- 相关认证信息
            ,discharge_permit -- 排污许可信息
            ,customer_litigation -- 客户涉诉信息
            ,customer_events -- 客户大事记
            ,customer_situation -- 客户情况分析
            ,paid_in_capital -- 实收资本
            ,electricity_total -- 电费总计
            ,can_reconsider -- 是否可以复议：true 可以 fals 不可以
            ,entity_access_model -- 企业准入模型是否通过：不通过，通过
            ,reject_reason -- 拒绝原因
            ,consider_status -- 复议状态
            ,to_time -- 营业期限止（到期时间）
            ,core_cust_no -- 核心客户号
            ,business_license_type -- yezzlx营业执照类型:1个体工商户、2企业、3无营业执照
            ,relationship_of_enterprise -- jkryqygx借款人与企业关系
            ,scale_judgment -- 企业规模：1大型、2中型、3小型、4微型、5其它
            ,share_ratio -- 主借人&配偶所占股份比例，0-100%，必填。
            ,share_change -- 主借人&配偶所占股份比例，0-100%，必填。
            ,legal_person_cert_no -- 企业法人身份证号
            ,enterprise_classification -- 企业划型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_loan_micro_entity_op(
            entity_id -- 经营主体信息主键ID
            ,code -- 业务code
            ,loan_id -- 进件id
            ,entloan_apply_id -- 企业申请信息表id
            ,name -- 企业名称
            ,legal_person -- 法定代表人姓名
            ,scope -- 企业所属行业
            ,ownership_info -- 企业权属情况
            ,ownership_rate -- 企业股权占比情况
            ,ownership_change -- 企业法人/股东变更情况
            ,legal_form -- 企业类型
            ,is_main_business -- 申请企业是否为主营业务
            ,space_ownership -- 经营场所权属情况
            ,space_address -- 经营场所地址
            ,profit_model -- 盈利模式
            ,province_region -- 家庭住址的省市区,多级斜杠隔开
            ,space_stability -- 企业地域稳定情况
            ,space_area -- 经营场所面积
            ,business_time -- 经营时长（单位：月）
            ,is_repenish_data -- 是否需要补充信息
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,credit_score -- 企业信用分
            ,reg_num -- 注册编码
            ,regist_time -- 注册时间
            ,regist_capital -- 注册资金
            ,business_ownership -- 生意权属
            ,customer_type -- 客户类型，1正常用户，2征信白户
            ,risk_point_num -- 风险点个数
            ,customer_stock_rights -- 主借款人股权
            ,spouse_stock_rights -- 配偶股权
            ,relevance_enterpr -- 关联企业
            ,credit_code -- 统一社会信用代码
            ,medium_signature_code -- 中征码
            ,business_scope -- 经营范围
            ,business_case -- 合法经营情况
            ,regist_adress -- 注册地址
            ,currency -- 币种
            ,has_relevance_enterpr -- 有无关联企业
            ,has_change_for_fg -- 历史法人/股东是否存在变更
            ,employees_num -- 企业员工数
            ,space_area_select -- 经营场所面积（选择）
            ,business_year -- 经营年限
            ,low_season_month -- 淡季月份
            ,peak_season_month -- 旺季月份
            ,flat_season_month -- 平季月份
            ,household_ratio -- 客户家庭股权占比
            ,tax_info -- 纳税情况
            ,industry_cycle -- 行业周期
            ,remarks -- 备注
            ,overseas_investment -- 对外股权投资情况
            ,main_business -- 主营业务描述
            ,real_estate_qualifications -- 房地产资质情况
            ,import_and_export_trade -- 进出口贸易情况
            ,situation_of_franchising_industry -- 特许经营行业情况
            ,related_authentication -- 相关认证信息
            ,discharge_permit -- 排污许可信息
            ,customer_litigation -- 客户涉诉信息
            ,customer_events -- 客户大事记
            ,customer_situation -- 客户情况分析
            ,paid_in_capital -- 实收资本
            ,electricity_total -- 电费总计
            ,can_reconsider -- 是否可以复议：true 可以 fals 不可以
            ,entity_access_model -- 企业准入模型是否通过：不通过，通过
            ,reject_reason -- 拒绝原因
            ,consider_status -- 复议状态
            ,to_time -- 营业期限止（到期时间）
            ,core_cust_no -- 核心客户号
            ,business_license_type -- yezzlx营业执照类型:1个体工商户、2企业、3无营业执照
            ,relationship_of_enterprise -- jkryqygx借款人与企业关系
            ,scale_judgment -- 企业规模：1大型、2中型、3小型、4微型、5其它
            ,share_ratio -- 主借人&配偶所占股份比例，0-100%，必填。
            ,share_change -- 主借人&配偶所占股份比例，0-100%，必填。
            ,legal_person_cert_no -- 企业法人身份证号
            ,enterprise_classification -- 企业划型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.entity_id -- 经营主体信息主键ID
    ,o.code -- 业务code
    ,o.loan_id -- 进件id
    ,o.entloan_apply_id -- 企业申请信息表id
    ,o.name -- 企业名称
    ,o.legal_person -- 法定代表人姓名
    ,o.scope -- 企业所属行业
    ,o.ownership_info -- 企业权属情况
    ,o.ownership_rate -- 企业股权占比情况
    ,o.ownership_change -- 企业法人/股东变更情况
    ,o.legal_form -- 企业类型
    ,o.is_main_business -- 申请企业是否为主营业务
    ,o.space_ownership -- 经营场所权属情况
    ,o.space_address -- 经营场所地址
    ,o.profit_model -- 盈利模式
    ,o.province_region -- 家庭住址的省市区,多级斜杠隔开
    ,o.space_stability -- 企业地域稳定情况
    ,o.space_area -- 经营场所面积
    ,o.business_time -- 经营时长（单位：月）
    ,o.is_repenish_data -- 是否需要补充信息
    ,o.create_date -- 申请日期
    ,o.update_date -- 更新时间
    ,o.credit_score -- 企业信用分
    ,o.reg_num -- 注册编码
    ,o.regist_time -- 注册时间
    ,o.regist_capital -- 注册资金
    ,o.business_ownership -- 生意权属
    ,o.customer_type -- 客户类型，1正常用户，2征信白户
    ,o.risk_point_num -- 风险点个数
    ,o.customer_stock_rights -- 主借款人股权
    ,o.spouse_stock_rights -- 配偶股权
    ,o.relevance_enterpr -- 关联企业
    ,o.credit_code -- 统一社会信用代码
    ,o.medium_signature_code -- 中征码
    ,o.business_scope -- 经营范围
    ,o.business_case -- 合法经营情况
    ,o.regist_adress -- 注册地址
    ,o.currency -- 币种
    ,o.has_relevance_enterpr -- 有无关联企业
    ,o.has_change_for_fg -- 历史法人/股东是否存在变更
    ,o.employees_num -- 企业员工数
    ,o.space_area_select -- 经营场所面积（选择）
    ,o.business_year -- 经营年限
    ,o.low_season_month -- 淡季月份
    ,o.peak_season_month -- 旺季月份
    ,o.flat_season_month -- 平季月份
    ,o.household_ratio -- 客户家庭股权占比
    ,o.tax_info -- 纳税情况
    ,o.industry_cycle -- 行业周期
    ,o.remarks -- 备注
    ,o.overseas_investment -- 对外股权投资情况
    ,o.main_business -- 主营业务描述
    ,o.real_estate_qualifications -- 房地产资质情况
    ,o.import_and_export_trade -- 进出口贸易情况
    ,o.situation_of_franchising_industry -- 特许经营行业情况
    ,o.related_authentication -- 相关认证信息
    ,o.discharge_permit -- 排污许可信息
    ,o.customer_litigation -- 客户涉诉信息
    ,o.customer_events -- 客户大事记
    ,o.customer_situation -- 客户情况分析
    ,o.paid_in_capital -- 实收资本
    ,o.electricity_total -- 电费总计
    ,o.can_reconsider -- 是否可以复议：true 可以 fals 不可以
    ,o.entity_access_model -- 企业准入模型是否通过：不通过，通过
    ,o.reject_reason -- 拒绝原因
    ,o.consider_status -- 复议状态
    ,o.to_time -- 营业期限止（到期时间）
    ,o.core_cust_no -- 核心客户号
    ,o.business_license_type -- yezzlx营业执照类型:1个体工商户、2企业、3无营业执照
    ,o.relationship_of_enterprise -- jkryqygx借款人与企业关系
    ,o.scale_judgment -- 企业规模：1大型、2中型、3小型、4微型、5其它
    ,o.share_ratio -- 主借人&配偶所占股份比例，0-100%，必填。
    ,o.share_change -- 主借人&配偶所占股份比例，0-100%，必填。
    ,o.legal_person_cert_no -- 企业法人身份证号
    ,o.enterprise_classification -- 企业划型
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
from ${iol_schema}.hgls_loan_micro_entity_bk o
    left join ${iol_schema}.hgls_loan_micro_entity_op n
        on
            o.entity_id = n.entity_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.hgls_loan_micro_entity_cl d
        on
            o.entity_id = d.entity_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.hgls_loan_micro_entity;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('hgls_loan_micro_entity') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.hgls_loan_micro_entity drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.hgls_loan_micro_entity add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.hgls_loan_micro_entity exchange partition p_${batch_date} with table ${iol_schema}.hgls_loan_micro_entity_cl;
alter table ${iol_schema}.hgls_loan_micro_entity exchange partition p_20991231 with table ${iol_schema}.hgls_loan_micro_entity_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.hgls_loan_micro_entity to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_loan_micro_entity_op purge;
drop table ${iol_schema}.hgls_loan_micro_entity_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.hgls_loan_micro_entity_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'hgls_loan_micro_entity',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
