: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_eifs_t01_corp_cust_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/eifs_t01_corp_cust_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.is_same_trade_cust,chr(13),''),chr(10),'') as is_same_trade_cust
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.org_type_cd,chr(13),''),chr(10),'') as org_type_cd
,replace(replace(t1.rgst_type_cd,chr(13),''),chr(10),'') as rgst_type_cd
,replace(replace(t1.reg_area_code,chr(13),''),chr(10),'') as reg_area_code
,t1.rgst_cap as rgst_cap
,replace(replace(t1.reg_capital_currency,chr(13),''),chr(10),'') as reg_capital_currency
,t1.actl_recv_cap as actl_recv_cap
,replace(replace(t1.paidcapital_currency,chr(13),''),chr(10),'') as paidcapital_currency
,replace(replace(t1.work_region,chr(13),''),chr(10),'') as work_region
,replace(replace(t1.corp_found_dt,chr(13),''),chr(10),'') as corp_found_dt
,replace(replace(t1.tax_register_flag,chr(13),''),chr(10),'') as tax_register_flag
,replace(replace(t1.tax_org_certificate,chr(13),''),chr(10),'') as tax_org_certificate
,replace(replace(t1.national_tax_no,chr(13),''),chr(10),'') as national_tax_no
,replace(replace(t1.land_tax_no,chr(13),''),chr(10),'') as land_tax_no
,replace(replace(t1.busi_or_not_reg_cer,chr(13),''),chr(10),'') as busi_or_not_reg_cer
,replace(replace(t1.licence_for_open_acct,chr(13),''),chr(10),'') as licence_for_open_acct
,replace(replace(t1.date_of_approval,chr(13),''),chr(10),'') as date_of_approval
,replace(replace(t1.org_credit_code_cert_num,chr(13),''),chr(10),'') as org_credit_code_cert_num
,replace(replace(t1.depositor_type_cd,chr(13),''),chr(10),'') as depositor_type_cd
,replace(replace(t1.belong_indus_cd,chr(13),''),chr(10),'') as belong_indus_cd
,replace(replace(t1.belong_indus_acct,chr(13),''),chr(10),'') as belong_indus_acct
,replace(replace(t1.economic_org_form,chr(13),''),chr(10),'') as economic_org_form
,t1.corp_totl_asset as corp_totl_asset
,t1.corp_net_asset as corp_net_asset
,t1.corp_year_in as corp_year_in
,t1.corp_emply_person_cnt as corp_emply_person_cnt
,replace(replace(t1.salmon,chr(13),''),chr(10),'') as salmon
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd
,replace(replace(t1.nation_eco_dept_cd,chr(13),''),chr(10),'') as nation_eco_dept_cd
,replace(replace(t1.oper_biz,chr(13),''),chr(10),'') as oper_biz
,replace(replace(t1.survival_status,chr(13),''),chr(10),'') as survival_status
,replace(replace(t1.bank_cd,chr(13),''),chr(10),'') as bank_cd
,replace(replace(t1.bank_level,chr(13),''),chr(10),'') as bank_level
,replace(replace(t1.basic_acct_open_bank_name,chr(13),''),chr(10),'') as basic_acct_open_bank_name
,replace(replace(t1.basic_acct_open_bank_code,chr(13),''),chr(10),'') as basic_acct_open_bank_code
,replace(replace(t1.basic_acct_num,chr(13),''),chr(10),'') as basic_acct_num
,replace(replace(t1.basic_open_acct_dt,chr(13),''),chr(10),'') as basic_open_acct_dt
,replace(replace(t1.create_te,chr(13),''),chr(10),'') as create_te
,replace(replace(t1.create_org,chr(13),''),chr(10),'') as create_org
,replace(replace(t1.init_system_id,chr(13),''),chr(10),'') as init_system_id
,t1.init_created_ts as init_created_ts
,t1.created_ts as created_ts
,t1.updated_ts as updated_ts
,replace(replace(t1.last_updated_te,chr(13),''),chr(10),'') as last_updated_te
,replace(replace(t1.last_updated_org,chr(13),''),chr(10),'') as last_updated_org
,replace(replace(t1.last_system_id,chr(13),''),chr(10),'') as last_system_id
,t1.last_updated_ts as last_updated_ts
,replace(replace(t1.org_type,chr(13),''),chr(10),'') as org_type
,replace(replace(t1.oper_place_area,chr(13),''),chr(10),'') as oper_place_area
,replace(replace(t1.oper_place_prop_cd,chr(13),''),chr(10),'') as oper_place_prop_cd
,replace(replace(t1.industry_class_id,chr(13),''),chr(10),'') as industry_class_id
,replace(replace(t1.enterprise_type,chr(13),''),chr(10),'') as enterprise_type
,replace(replace(t1.party_role,chr(13),''),chr(10),'') as party_role
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.cntrpty,chr(13),''),chr(10),'') as cntrpty
,replace(replace(t1.src_sys_num,chr(13),''),chr(10),'') as src_sys_num
,replace(replace(t1.last_updated_src_sys_num,chr(13),''),chr(10),'') as last_updated_src_sys_num
from ${iol_schema}.eifs_t01_corp_cust_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eifs_t01_corp_cust_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes