: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_heps_s_customer_detail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/heps_s_customer_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.cusdetail_id as cusdetail_id
,replace(replace(t.flow_id,chr(13),''),chr(10),'') as flow_id
,replace(replace(t.loans_usage,chr(13),''),chr(10),'') as loans_usage
,replace(replace(t.concrete_usage,chr(13),''),chr(10),'') as concrete_usage
,replace(replace(t.paymentsource,chr(13),''),chr(10),'') as paymentsource
,replace(replace(t.work_nature,chr(13),''),chr(10),'') as work_nature
,replace(replace(t.manage_site_type,chr(13),''),chr(10),'') as manage_site_type
,replace(replace(t.manage_age,chr(13),''),chr(10),'') as manage_age
,replace(replace(t.merchant_name,chr(13),''),chr(10),'') as merchant_name
,replace(replace(t.manage_site,chr(13),''),chr(10),'') as manage_site
,replace(replace(t.operator,chr(13),''),chr(10),'') as operator
,replace(replace(t.actual_control,chr(13),''),chr(10),'') as actual_control
,replace(replace(t.register_time,chr(13),''),chr(10),'') as register_time
,replace(replace(t.manage_scope,chr(13),''),chr(10),'') as manage_scope
,replace(replace(t.detail_address,chr(13),''),chr(10),'') as detail_address
,replace(replace(t.children_num,chr(13),''),chr(10),'') as children_num
,replace(replace(t.qq,chr(13),''),chr(10),'') as qq
,replace(replace(t.wechat,chr(13),''),chr(10),'') as wechat
,replace(replace(t.email,chr(13),''),chr(10),'') as email
,replace(replace(t.household_phone,chr(13),''),chr(10),'') as household_phone
,replace(replace(t.highest_education,chr(13),''),chr(10),'') as highest_education
,replace(replace(t.work_unit,chr(13),''),chr(10),'') as work_unit
,replace(replace(t.industry_one,chr(13),''),chr(10),'') as industry_one
,replace(replace(t.industry_two,chr(13),''),chr(10),'') as industry_two
,replace(replace(t.industry_three,chr(13),''),chr(10),'') as industry_three
,replace(replace(t.industry_four,chr(13),''),chr(10),'') as industry_four
,replace(replace(t.job,chr(13),''),chr(10),'') as job
,replace(replace(t.duty,chr(13),''),chr(10),'') as duty
,replace(replace(t.unit_phone,chr(13),''),chr(10),'') as unit_phone
,replace(replace(t.income_year,chr(13),''),chr(10),'') as income_year
,replace(replace(t.income_family,chr(13),''),chr(10),'') as income_family
,replace(replace(t.other_assets,chr(13),''),chr(10),'') as other_assets
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,t.input_time as input_time
,replace(replace(t.loan_type,chr(13),''),chr(10),'') as loan_type
,replace(replace(t.enterprise_name,chr(13),''),chr(10),'') as enterprise_name
,replace(replace(t.unifysocial_creditnum,chr(13),''),chr(10),'') as unifysocial_creditnum
,replace(replace(t.enterprise_legal_personname,chr(13),''),chr(10),'') as enterprise_legal_personname
,replace(replace(t.enterprise_legal_personidno,chr(13),''),chr(10),'') as enterprise_legal_personidno
,replace(replace(t.regist_address,chr(13),''),chr(10),'') as regist_address
,t.regist_assets as regist_assets
,replace(replace(t.validite_date,chr(13),''),chr(10),'') as validite_date
,replace(replace(t.regist_date,chr(13),''),chr(10),'') as regist_date
,replace(replace(t.bs_start_date,chr(13),''),chr(10),'') as bs_start_date
,replace(replace(t.bs_end_date,chr(13),''),chr(10),'') as bs_end_date
,replace(replace(t.pract_years,chr(13),''),chr(10),'') as pract_years
,t.company_year as company_year
,replace(replace(t.unit_property,chr(13),''),chr(10),'') as unit_property
,replace(replace(t.enter_unit_time,chr(13),''),chr(10),'') as enter_unit_time
,replace(replace(t.appraisal,chr(13),''),chr(10),'') as appraisal
,replace(replace(t.manager_idcard,chr(13),''),chr(10),'') as manager_idcard
,replace(replace(t.manager_license_number,chr(13),''),chr(10),'') as manager_license_number
,replace(replace(t.rent_end_date,chr(13),''),chr(10),'') as rent_end_date
,replace(replace(t.industry_involved,chr(13),''),chr(10),'') as industry_involved
,replace(replace(t.bussiness_scope,chr(13),''),chr(10),'') as bussiness_scope
,replace(replace(t.certification_type,chr(13),''),chr(10),'') as certification_type
,replace(replace(t.certification_number,chr(13),''),chr(10),'') as certification_number
,replace(replace(t.enterprise_size,chr(13),''),chr(10),'') as enterprise_size
,replace(replace(t.property_ownership,chr(13),''),chr(10),'') as property_ownership
,replace(replace(t.enterpriseholding_type,chr(13),''),chr(10),'') as enterpriseholding_type
,replace(replace(t.borrow_enterprise_relation,chr(13),''),chr(10),'') as borrow_enterprise_relation
,t.job_number as job_number
,replace(replace(t.enterprise_address,chr(13),''),chr(10),'') as enterprise_address
,t.bussiness_income as bussiness_income
,replace(replace(t.main_bussiness,chr(13),''),chr(10),'') as main_bussiness
,replace(replace(t.individual_name,chr(13),''),chr(10),'') as individual_name
,t.actual_income as actual_income
,replace(replace(t.unit_address,chr(13),''),chr(10),'') as unit_address
,replace(replace(t.indiv_comfld_type,chr(13),''),chr(10),'') as indiv_comfld_type
from iol.heps_s_customer_detail t
where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/heps_s_customer_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes