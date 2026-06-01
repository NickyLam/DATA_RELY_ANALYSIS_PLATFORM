: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_rpt_adm_customer_detail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_rpt_adm_customer_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.data_dt as data_dt
,replace(replace(t.customer_no,chr(13),''),chr(10),'') as customer_no
,replace(replace(t.name,chr(13),''),chr(10),'') as name
,replace(replace(t.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t.id_type,chr(13),''),chr(10),'') as id_type
,replace(replace(t.id_no,chr(13),''),chr(10),'') as id_no
,replace(replace(t.mobile,chr(13),''),chr(10),'') as mobile
,t.age as age
,replace(replace(t.census_address,chr(13),''),chr(10),'') as census_address
,replace(replace(t.nation,chr(13),''),chr(10),'') as nation
,replace(replace(t.education,chr(13),''),chr(10),'') as education
,replace(replace(t.political_status,chr(13),''),chr(10),'') as political_status
,replace(replace(t.registered_residence,chr(13),''),chr(10),'') as registered_residence
,replace(replace(t.house_hold,chr(13),''),chr(10),'') as house_hold
,t.house_fee as house_fee
,replace(replace(t.is_country_registered,chr(13),''),chr(10),'') as is_country_registered
,t.years_work as years_work
,t.home_numbers as home_numbers
,replace(replace(t.marriage,chr(13),''),chr(10),'') as marriage
,replace(replace(t.children,chr(13),''),chr(10),'') as children
,t.homr_year_profit as homr_year_profit
,t.month_profit as month_profit
,replace(replace(t.drive_type,chr(13),''),chr(10),'') as drive_type
,replace(replace(t.company_name,chr(13),''),chr(10),'') as company_name
,replace(replace(t.company_type,chr(13),''),chr(10),'') as company_type
,replace(replace(t.company_scale,chr(13),''),chr(10),'') as company_scale
,replace(replace(t.company_industry,chr(13),''),chr(10),'') as company_industry
,replace(replace(t.company_address,chr(13),''),chr(10),'') as company_address
,replace(replace(t.company_phone,chr(13),''),chr(10),'') as company_phone
,t.company_work_years as company_work_years
,t.company_entry_date as company_entry_date
,replace(replace(t.company_position,chr(13),''),chr(10),'') as company_position
,replace(replace(t.company_level,chr(13),''),chr(10),'') as company_level
,replace(replace(t.company_depart,chr(13),''),chr(10),'') as company_depart
,replace(replace(t.occupation,chr(13),''),chr(10),'') as occupation
,replace(replace(t.person_title,chr(13),''),chr(10),'') as person_title
,t.person_year_profit as person_year_profit
,replace(replace(t.tax_code,chr(13),''),chr(10),'') as tax_code
,replace(replace(t.email,chr(13),''),chr(10),'') as email
,replace(replace(t.comm_address,chr(13),''),chr(10),'') as comm_address
,replace(replace(t.inner_card_no,chr(13),''),chr(10),'') as inner_card_no
,t.quota_height as quota_height
,t.quota_his as quota_his
,t.tuans_cnt as tuans_cnt
,t.tuans_amt_h as tuans_amt_h
,t.loan_balance as loan_balance
,t.pay_bal as pay_bal
,t.r_amt as r_amt
,t.over_date_int as over_date_int
,t.over_date_rece as over_date_rece
,t.dpd30 as dpd30
,replace(replace(t.home_address,chr(13),''),chr(10),'') as home_address
,t.quota_bal as quota_bal
,t.product_id as product_id
from iol.ilss_rpt_adm_customer_detail t
where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_rpt_adm_customer_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes