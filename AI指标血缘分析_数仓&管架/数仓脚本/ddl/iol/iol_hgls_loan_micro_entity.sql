/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol hgls_loan_micro_entity
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.hgls_loan_micro_entity
whenever sqlerror continue none;
drop table ${iol_schema}.hgls_loan_micro_entity purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_loan_micro_entity(
    entity_id number(22,0) -- 经营主体信息主键ID
    ,code varchar2(4000) -- 业务code
    ,loan_id number(22,0) -- 进件id
    ,entloan_apply_id number(22,0) -- 企业申请信息表id
    ,name varchar2(4000) -- 企业名称
    ,legal_person varchar2(4000) -- 法定代表人姓名
    ,scope varchar2(4000) -- 企业所属行业
    ,ownership_info varchar2(4000) -- 企业权属情况
    ,ownership_rate varchar2(4000) -- 企业股权占比情况
    ,ownership_change varchar2(4000) -- 企业法人/股东变更情况
    ,legal_form varchar2(4000) -- 企业类型
    ,is_main_business number(22,0) -- 申请企业是否为主营业务
    ,space_ownership varchar2(4000) -- 经营场所权属情况
    ,space_address varchar2(4000) -- 经营场所地址
    ,profit_model varchar2(4000) -- 盈利模式
    ,province_region varchar2(4000) -- 家庭住址的省市区,多级斜杠隔开
    ,space_stability varchar2(4000) -- 企业地域稳定情况
    ,space_area varchar2(4000) -- 经营场所面积
    ,business_time number(22,0) -- 经营时长（单位：月）
    ,is_repenish_data number(22,0) -- 是否需要补充信息
    ,create_date timestamp -- 申请日期
    ,update_date timestamp -- 更新时间
    ,credit_score number(22,0) -- 企业信用分
    ,reg_num varchar2(4000) -- 注册编码
    ,regist_time timestamp -- 注册时间
    ,regist_capital varchar2(4000) -- 注册资金
    ,business_ownership varchar2(4000) -- 生意权属
    ,customer_type number(22,0) -- 客户类型，1正常用户，2征信白户
    ,risk_point_num number(22,0) -- 风险点个数
    ,customer_stock_rights number(38,8) -- 主借款人股权
    ,spouse_stock_rights number(38,8) -- 配偶股权
    ,relevance_enterpr varchar2(4000) -- 关联企业
    ,credit_code varchar2(4000) -- 统一社会信用代码
    ,medium_signature_code varchar2(4000) -- 中征码
    ,business_scope varchar2(4000) -- 经营范围
    ,business_case varchar2(4000) -- 合法经营情况
    ,regist_adress varchar2(4000) -- 注册地址
    ,currency varchar2(4000) -- 币种
    ,has_relevance_enterpr number(22,0) -- 有无关联企业
    ,has_change_for_fg number(22,0) -- 历史法人/股东是否存在变更
    ,employees_num number(22,0) -- 企业员工数
    ,space_area_select varchar2(4000) -- 经营场所面积（选择）
    ,business_year varchar2(4000) -- 经营年限
    ,low_season_month varchar2(4000) -- 淡季月份
    ,peak_season_month varchar2(4000) -- 旺季月份
    ,flat_season_month varchar2(4000) -- 平季月份
    ,household_ratio varchar2(4000) -- 客户家庭股权占比
    ,tax_info varchar2(4000) -- 纳税情况
    ,industry_cycle varchar2(4000) -- 行业周期
    ,remarks varchar2(4000) -- 备注
    ,overseas_investment varchar2(4000) -- 对外股权投资情况
    ,main_business varchar2(4000) -- 主营业务描述
    ,real_estate_qualifications varchar2(4000) -- 房地产资质情况
    ,import_and_export_trade varchar2(4000) -- 进出口贸易情况
    ,situation_of_franchising_industry varchar2(4000) -- 特许经营行业情况
    ,related_authentication varchar2(4000) -- 相关认证信息
    ,discharge_permit varchar2(4000) -- 排污许可信息
    ,customer_litigation varchar2(4000) -- 客户涉诉信息
    ,customer_events varchar2(4000) -- 客户大事记
    ,customer_situation varchar2(4000) -- 客户情况分析
    ,paid_in_capital number(38,8) -- 实收资本
    ,electricity_total number(38,8) -- 电费总计
    ,can_reconsider number(22,0) -- 是否可以复议：true 可以 fals 不可以
    ,entity_access_model varchar2(4000) -- 企业准入模型是否通过：不通过，通过
    ,reject_reason varchar2(4000) -- 拒绝原因
    ,consider_status varchar2(4000) -- 复议状态
    ,to_time varchar2(4000) -- 营业期限止（到期时间）
    ,core_cust_no varchar2(4000) -- 核心客户号
    ,business_license_type varchar2(4000) -- yezzlx营业执照类型:1个体工商户、2企业、3无营业执照
    ,relationship_of_enterprise varchar2(4000) -- jkryqygx借款人与企业关系
    ,scale_judgment varchar2(4000) -- 企业规模：1大型、2中型、3小型、4微型、5其它
    ,share_ratio number(38,8) -- 主借人&配偶所占股份比例，0-100%，必填。
    ,share_change number(38,8) -- 主借人&配偶所占股份比例，0-100%，必填。
    ,legal_person_cert_no varchar2(4000) -- 企业法人身份证号
    ,enterprise_classification varchar2(4000) -- 企业划型
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
grant select on ${iol_schema}.hgls_loan_micro_entity to ${iml_schema};
grant select on ${iol_schema}.hgls_loan_micro_entity to ${icl_schema};
grant select on ${iol_schema}.hgls_loan_micro_entity to ${idl_schema};
grant select on ${iol_schema}.hgls_loan_micro_entity to ${iel_schema};

-- comment
comment on table ${iol_schema}.hgls_loan_micro_entity is '小微贷经营主体基本信息';
comment on column ${iol_schema}.hgls_loan_micro_entity.entity_id is '经营主体信息主键ID';
comment on column ${iol_schema}.hgls_loan_micro_entity.code is '业务code';
comment on column ${iol_schema}.hgls_loan_micro_entity.loan_id is '进件id';
comment on column ${iol_schema}.hgls_loan_micro_entity.entloan_apply_id is '企业申请信息表id';
comment on column ${iol_schema}.hgls_loan_micro_entity.name is '企业名称';
comment on column ${iol_schema}.hgls_loan_micro_entity.legal_person is '法定代表人姓名';
comment on column ${iol_schema}.hgls_loan_micro_entity.scope is '企业所属行业';
comment on column ${iol_schema}.hgls_loan_micro_entity.ownership_info is '企业权属情况';
comment on column ${iol_schema}.hgls_loan_micro_entity.ownership_rate is '企业股权占比情况';
comment on column ${iol_schema}.hgls_loan_micro_entity.ownership_change is '企业法人/股东变更情况';
comment on column ${iol_schema}.hgls_loan_micro_entity.legal_form is '企业类型';
comment on column ${iol_schema}.hgls_loan_micro_entity.is_main_business is '申请企业是否为主营业务';
comment on column ${iol_schema}.hgls_loan_micro_entity.space_ownership is '经营场所权属情况';
comment on column ${iol_schema}.hgls_loan_micro_entity.space_address is '经营场所地址';
comment on column ${iol_schema}.hgls_loan_micro_entity.profit_model is '盈利模式';
comment on column ${iol_schema}.hgls_loan_micro_entity.province_region is '家庭住址的省市区,多级斜杠隔开';
comment on column ${iol_schema}.hgls_loan_micro_entity.space_stability is '企业地域稳定情况';
comment on column ${iol_schema}.hgls_loan_micro_entity.space_area is '经营场所面积';
comment on column ${iol_schema}.hgls_loan_micro_entity.business_time is '经营时长（单位：月）';
comment on column ${iol_schema}.hgls_loan_micro_entity.is_repenish_data is '是否需要补充信息';
comment on column ${iol_schema}.hgls_loan_micro_entity.create_date is '申请日期';
comment on column ${iol_schema}.hgls_loan_micro_entity.update_date is '更新时间';
comment on column ${iol_schema}.hgls_loan_micro_entity.credit_score is '企业信用分';
comment on column ${iol_schema}.hgls_loan_micro_entity.reg_num is '注册编码';
comment on column ${iol_schema}.hgls_loan_micro_entity.regist_time is '注册时间';
comment on column ${iol_schema}.hgls_loan_micro_entity.regist_capital is '注册资金';
comment on column ${iol_schema}.hgls_loan_micro_entity.business_ownership is '生意权属';
comment on column ${iol_schema}.hgls_loan_micro_entity.customer_type is '客户类型，1正常用户，2征信白户';
comment on column ${iol_schema}.hgls_loan_micro_entity.risk_point_num is '风险点个数';
comment on column ${iol_schema}.hgls_loan_micro_entity.customer_stock_rights is '主借款人股权';
comment on column ${iol_schema}.hgls_loan_micro_entity.spouse_stock_rights is '配偶股权';
comment on column ${iol_schema}.hgls_loan_micro_entity.relevance_enterpr is '关联企业';
comment on column ${iol_schema}.hgls_loan_micro_entity.credit_code is '统一社会信用代码';
comment on column ${iol_schema}.hgls_loan_micro_entity.medium_signature_code is '中征码';
comment on column ${iol_schema}.hgls_loan_micro_entity.business_scope is '经营范围';
comment on column ${iol_schema}.hgls_loan_micro_entity.business_case is '合法经营情况';
comment on column ${iol_schema}.hgls_loan_micro_entity.regist_adress is '注册地址';
comment on column ${iol_schema}.hgls_loan_micro_entity.currency is '币种';
comment on column ${iol_schema}.hgls_loan_micro_entity.has_relevance_enterpr is '有无关联企业';
comment on column ${iol_schema}.hgls_loan_micro_entity.has_change_for_fg is '历史法人/股东是否存在变更';
comment on column ${iol_schema}.hgls_loan_micro_entity.employees_num is '企业员工数';
comment on column ${iol_schema}.hgls_loan_micro_entity.space_area_select is '经营场所面积（选择）';
comment on column ${iol_schema}.hgls_loan_micro_entity.business_year is '经营年限';
comment on column ${iol_schema}.hgls_loan_micro_entity.low_season_month is '淡季月份';
comment on column ${iol_schema}.hgls_loan_micro_entity.peak_season_month is '旺季月份';
comment on column ${iol_schema}.hgls_loan_micro_entity.flat_season_month is '平季月份';
comment on column ${iol_schema}.hgls_loan_micro_entity.household_ratio is '客户家庭股权占比';
comment on column ${iol_schema}.hgls_loan_micro_entity.tax_info is '纳税情况';
comment on column ${iol_schema}.hgls_loan_micro_entity.industry_cycle is '行业周期';
comment on column ${iol_schema}.hgls_loan_micro_entity.remarks is '备注';
comment on column ${iol_schema}.hgls_loan_micro_entity.overseas_investment is '对外股权投资情况';
comment on column ${iol_schema}.hgls_loan_micro_entity.main_business is '主营业务描述';
comment on column ${iol_schema}.hgls_loan_micro_entity.real_estate_qualifications is '房地产资质情况';
comment on column ${iol_schema}.hgls_loan_micro_entity.import_and_export_trade is '进出口贸易情况';
comment on column ${iol_schema}.hgls_loan_micro_entity.situation_of_franchising_industry is '特许经营行业情况';
comment on column ${iol_schema}.hgls_loan_micro_entity.related_authentication is '相关认证信息';
comment on column ${iol_schema}.hgls_loan_micro_entity.discharge_permit is '排污许可信息';
comment on column ${iol_schema}.hgls_loan_micro_entity.customer_litigation is '客户涉诉信息';
comment on column ${iol_schema}.hgls_loan_micro_entity.customer_events is '客户大事记';
comment on column ${iol_schema}.hgls_loan_micro_entity.customer_situation is '客户情况分析';
comment on column ${iol_schema}.hgls_loan_micro_entity.paid_in_capital is '实收资本';
comment on column ${iol_schema}.hgls_loan_micro_entity.electricity_total is '电费总计';
comment on column ${iol_schema}.hgls_loan_micro_entity.can_reconsider is '是否可以复议：true 可以 fals 不可以';
comment on column ${iol_schema}.hgls_loan_micro_entity.entity_access_model is '企业准入模型是否通过：不通过，通过';
comment on column ${iol_schema}.hgls_loan_micro_entity.reject_reason is '拒绝原因';
comment on column ${iol_schema}.hgls_loan_micro_entity.consider_status is '复议状态';
comment on column ${iol_schema}.hgls_loan_micro_entity.to_time is '营业期限止（到期时间）';
comment on column ${iol_schema}.hgls_loan_micro_entity.core_cust_no is '核心客户号';
comment on column ${iol_schema}.hgls_loan_micro_entity.business_license_type is 'yezzlx营业执照类型:1个体工商户、2企业、3无营业执照';
comment on column ${iol_schema}.hgls_loan_micro_entity.relationship_of_enterprise is 'jkryqygx借款人与企业关系';
comment on column ${iol_schema}.hgls_loan_micro_entity.scale_judgment is '企业规模：1大型、2中型、3小型、4微型、5其它';
comment on column ${iol_schema}.hgls_loan_micro_entity.share_ratio is '主借人&配偶所占股份比例，0-100%，必填。';
comment on column ${iol_schema}.hgls_loan_micro_entity.share_change is '主借人&配偶所占股份比例，0-100%，必填。';
comment on column ${iol_schema}.hgls_loan_micro_entity.legal_person_cert_no is '企业法人身份证号';
comment on column ${iol_schema}.hgls_loan_micro_entity.enterprise_classification is '企业划型';
comment on column ${iol_schema}.hgls_loan_micro_entity.start_dt is '开始时间';
comment on column ${iol_schema}.hgls_loan_micro_entity.end_dt is '结束时间';
comment on column ${iol_schema}.hgls_loan_micro_entity.id_mark is '增删标志';
comment on column ${iol_schema}.hgls_loan_micro_entity.etl_timestamp is 'ETL处理时间戳';
