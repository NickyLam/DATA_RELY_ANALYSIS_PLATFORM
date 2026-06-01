: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_credit_offline_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_credit_offline.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.credit_no,chr(13),''),chr(10),'') as credit_no
,replace(replace(t.product_no,chr(13),''),chr(10),'') as product_no
,replace(replace(t.customer_no,chr(13),''),chr(10),'') as customer_no
,replace(replace(t.id_type,chr(13),''),chr(10),'') as id_type
,replace(replace(t.id_no,chr(13),''),chr(10),'') as id_no
,replace(replace(t.tax_no,chr(13),''),chr(10),'') as tax_no
,replace(replace(t.tax_name,chr(13),''),chr(10),'') as tax_name
,replace(replace(t.org_no,chr(13),''),chr(10),'') as org_no
,replace(replace(t.reg_no,chr(13),''),chr(10),'') as reg_no
,replace(replace(t.lepr_id_type,chr(13),''),chr(10),'') as lepr_id_type
,replace(replace(t.lepr_id_no,chr(13),''),chr(10),'') as lepr_id_no
,replace(replace(t.channel_code,chr(13),''),chr(10),'') as channel_code
,t.quota as quota
,t.loan_rate as loan_rate
,replace(replace(t.cash_type,chr(13),''),chr(10),'') as cash_type
,t.final_quota as final_quota
,replace(replace(t.loan_period_type,chr(13),''),chr(10),'') as loan_period_type
,t.loan_period as loan_period
,t.apply_time as apply_time
,t.state as state
,replace(replace(t.auth_info,chr(13),''),chr(10),'') as auth_info
,t.begin_day as begin_day
,t.end_day as end_day
,replace(replace(t.project_no,chr(13),''),chr(10),'') as project_no
,replace(replace(t.merchant_no,chr(13),''),chr(10),'') as merchant_no
,replace(replace(t.tax_office_code,chr(13),''),chr(10),'') as tax_office_code
,replace(replace(t.area_code,chr(13),''),chr(10),'') as area_code
,replace(replace(t.customer_manager,chr(13),''),chr(10),'') as customer_manager
,t.create_time as create_time
,t.update_time as update_time
from iol.ilss_ghb_credit_offline t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_credit_offline.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes