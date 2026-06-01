/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_heps_s_customer_detail
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
drop table ${iol_schema}.heps_s_customer_detail_ex purge;
alter table ${iol_schema}.heps_s_customer_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.heps_s_customer_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.heps_s_customer_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.heps_s_customer_detail where 0=1;

insert /*+ append */ into ${iol_schema}.heps_s_customer_detail_ex(
    cusdetail_id -- 主键id
    ,flow_id -- 	业务流水号
    ,loans_usage -- 贷款用途
    ,concrete_usage -- 具体用途
    ,paymentsource -- 还款来源
    ,work_nature -- 	工作性质
    ,manage_site_type -- 经营场所类型
    ,manage_age -- 经营年限
    ,merchant_name -- 商户名称
    ,manage_site -- 经营场所
    ,operator -- 经营者
    ,actual_control -- 实际控制人
    ,register_time -- 注册日期
    ,manage_scope -- 经营范围
    ,detail_address -- 详细居住地址
    ,children_num -- 子女数量
    ,qq -- QQ号
    ,wechat -- 微信号
    ,email -- 电子邮箱
    ,household_phone -- 家庭电话
    ,highest_education -- 最高学历
    ,work_unit -- 工作单位
    ,industry_one -- 所属行业（一级）
    ,industry_two -- 所属行业（二级）
    ,industry_three -- 所属行业（三级）
    ,industry_four -- 所属行业（四级）
    ,job -- 职业
    ,duty -- 职务
    ,unit_phone -- 单位联系电话
    ,income_year -- 个人年收入
    ,income_family -- 家庭年收入
    ,other_assets -- 其他资产证明
    ,status -- 状态
    ,input_time -- 录入时间
    ,loan_type -- 贷款类型
    ,enterprise_name -- 企业名称
    ,unifysocial_creditnum -- 统一社会信用编号
    ,enterprise_legal_personname -- 企业法人姓名
    ,enterprise_legal_personidno -- 企业法人身份证号
    ,regist_address -- 注册地址
    ,regist_assets -- 注册资本
    ,validite_date -- 有效期
    ,regist_date -- 注册日期
    ,bs_start_date -- 营业起始日
    ,bs_end_date -- 营业到期日
    ,pract_years -- 法人从业年限
    ,company_year -- 经营年限
    ,unit_property -- 单位性质
    ,enter_unit_time -- 进入本单位时间
    ,appraisal -- 职称
    ,manager_idcard -- 经营者身份证号码
    ,manager_license_number -- 营业执照号码
    ,rent_end_date -- 租赁到期日
    ,industry_involved -- 所属行业名称
    ,bussiness_scope -- 经营范围
    ,certification_type -- 证件类型
    ,certification_number -- 证件号码
    ,enterprise_size -- 企业规模
    ,property_ownership -- 所有制性质
    ,enterpriseholding_type -- 企业控股类型
    ,borrow_enterprise_relation -- 借款人与经营实体的关系
    ,job_number -- 职工人数
    ,enterprise_address -- 企业地址
    ,bussiness_income -- 营业收入(年)
    ,main_bussiness -- 主营业务
    ,individual_name -- 个体工商户名称
    ,actual_income -- 实收资本
    ,unit_address -- 单位地址
    ,indiv_comfld_type -- 所属行业编号
    ,cobo_invt_stk_perc -- 共借人持股比例
    ,invt_stk_perc -- 借款人持股比例
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cusdetail_id -- 主键id
    ,flow_id -- 	业务流水号
    ,loans_usage -- 贷款用途
    ,concrete_usage -- 具体用途
    ,paymentsource -- 还款来源
    ,work_nature -- 	工作性质
    ,manage_site_type -- 经营场所类型
    ,manage_age -- 经营年限
    ,merchant_name -- 商户名称
    ,manage_site -- 经营场所
    ,operator -- 经营者
    ,actual_control -- 实际控制人
    ,register_time -- 注册日期
    ,manage_scope -- 经营范围
    ,detail_address -- 详细居住地址
    ,children_num -- 子女数量
    ,qq -- QQ号
    ,wechat -- 微信号
    ,email -- 电子邮箱
    ,household_phone -- 家庭电话
    ,highest_education -- 最高学历
    ,work_unit -- 工作单位
    ,industry_one -- 所属行业（一级）
    ,industry_two -- 所属行业（二级）
    ,industry_three -- 所属行业（三级）
    ,industry_four -- 所属行业（四级）
    ,job -- 职业
    ,duty -- 职务
    ,unit_phone -- 单位联系电话
    ,income_year -- 个人年收入
    ,income_family -- 家庭年收入
    ,other_assets -- 其他资产证明
    ,status -- 状态
    ,input_time -- 录入时间
    ,loan_type -- 贷款类型
    ,enterprise_name -- 企业名称
    ,unifysocial_creditnum -- 统一社会信用编号
    ,enterprise_legal_personname -- 企业法人姓名
    ,enterprise_legal_personidno -- 企业法人身份证号
    ,regist_address -- 注册地址
    ,regist_assets -- 注册资本
    ,validite_date -- 有效期
    ,regist_date -- 注册日期
    ,bs_start_date -- 营业起始日
    ,bs_end_date -- 营业到期日
    ,pract_years -- 法人从业年限
    ,company_year -- 经营年限
    ,unit_property -- 单位性质
    ,enter_unit_time -- 进入本单位时间
    ,appraisal -- 职称
    ,manager_idcard -- 经营者身份证号码
    ,manager_license_number -- 营业执照号码
    ,rent_end_date -- 租赁到期日
    ,industry_involved -- 所属行业名称
    ,bussiness_scope -- 经营范围
    ,certification_type -- 证件类型
    ,certification_number -- 证件号码
    ,enterprise_size -- 企业规模
    ,property_ownership -- 所有制性质
    ,enterpriseholding_type -- 企业控股类型
    ,borrow_enterprise_relation -- 借款人与经营实体的关系
    ,job_number -- 职工人数
    ,enterprise_address -- 企业地址
    ,bussiness_income -- 营业收入(年)
    ,main_bussiness -- 主营业务
    ,individual_name -- 个体工商户名称
    ,actual_income -- 实收资本
    ,unit_address -- 单位地址
    ,indiv_comfld_type -- 所属行业编号
    ,cobo_invt_stk_perc -- 共借人持股比例
    ,invt_stk_perc -- 借款人持股比例
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.heps_s_customer_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.heps_s_customer_detail exchange partition p_${batch_date} with table ${iol_schema}.heps_s_customer_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.heps_s_customer_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.heps_s_customer_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'heps_s_customer_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);