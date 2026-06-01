: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_wl_customer_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_wl_customer.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.name,chr(13),''),chr(10),'') as name
,replace(replace(t.customer_no,chr(13),''),chr(10),'') as customer_no
,replace(replace(t.id_type,chr(13),''),chr(10),'') as id_type
,replace(replace(t.id_no,chr(13),''),chr(10),'') as id_no
,t.id_eff_start as id_eff_start
,t.id_eff_end as id_eff_end
,replace(replace(t.id_agency,chr(13),''),chr(10),'') as id_agency
,replace(replace(t.census_address,chr(13),''),chr(10),'') as census_address
,replace(replace(t.sex,chr(13),''),chr(10),'') as sex
,t.age as age
,replace(replace(t.birth,chr(13),''),chr(10),'') as birth
,replace(replace(t.nation,chr(13),''),chr(10),'') as nation
,replace(replace(t.education,chr(13),''),chr(10),'') as education
,replace(replace(t.political_status,chr(13),''),chr(10),'') as political_status
,replace(replace(t.registered_residence,chr(13),''),chr(10),'') as registered_residence
,replace(replace(t.house_hold,chr(13),''),chr(10),'') as house_hold
,t.house_fee as house_fee
,replace(replace(t.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t.is_country_registered,chr(13),''),chr(10),'') as is_country_registered
,t.years_work as years_work
,t.home_numbers as home_numbers
,replace(replace(t.marriage,chr(13),''),chr(10),'') as marriage
,replace(replace(t.children,chr(13),''),chr(10),'') as children
,t.homr_year_profit as homr_year_profit
,t.month_profit as month_profit
,replace(replace(t.home_desc,chr(13),''),chr(10),'') as home_desc
,replace(replace(t.car_no,chr(13),''),chr(10),'') as car_no
,t.drive_age as drive_age
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
,replace(replace(t.salary_type,chr(13),''),chr(10),'') as salary_type
,t.salary_month as salary_month
,t.create_user as create_user
,t.create_time as create_time
,t.update_user as update_user
,t.update_time as update_time
,replace(replace(t.occupation,chr(13),''),chr(10),'') as occupation
,replace(replace(t.company_zipcode,chr(13),''),chr(10),'') as company_zipcode
,replace(replace(t.person_title,chr(13),''),chr(10),'') as person_title
,t.person_year_profit as person_year_profit
,replace(replace(t.salary_account,chr(13),''),chr(10),'') as salary_account
,replace(replace(t.account_bank,chr(13),''),chr(10),'') as account_bank
,replace(replace(t.tax_code,chr(13),''),chr(10),'') as tax_code
,replace(replace(t.email,chr(13),''),chr(10),'') as email
,replace(replace(t.comm_address,chr(13),''),chr(10),'') as comm_address
,replace(replace(t.comm_zipcode,chr(13),''),chr(10),'') as comm_zipcode
,replace(replace(t.inner_card_no,chr(13),''),chr(10),'') as inner_card_no
,replace(replace(t.checkresult,chr(13),''),chr(10),'') as checkresult
,replace(replace(t.checkchnl,chr(13),''),chr(10),'') as checkchnl
,replace(replace(t.degree,chr(13),''),chr(10),'') as degree
,replace(replace(t.src_channel,chr(13),''),chr(10),'') as src_channel
,replace(replace(t.src_prod,chr(13),''),chr(10),'') as src_prod
,replace(replace(t.src_prod_cate,chr(13),''),chr(10),'') as src_prod_cate
,replace(replace(t.src_project,chr(13),''),chr(10),'') as src_project
,replace(replace(t.src_merchant,chr(13),''),chr(10),'') as src_merchant
,replace(replace(t.region_cd,chr(13),''),chr(10),'') as region_cd
,replace(replace(t.work_status,chr(13),''),chr(10),'') as work_status
,replace(replace(t.etpr_loc_region,chr(13),''),chr(10),'') as etpr_loc_region
,t.tax_year_in as tax_year_in
,replace(replace(t.cert_rela_valid_flg,chr(13),''),chr(10),'') as cert_rela_valid_flg
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ilss_wl_customer t
where start_dt <= to_date('${batch_date}','yyyymmdd')
  and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_wl_customer.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes