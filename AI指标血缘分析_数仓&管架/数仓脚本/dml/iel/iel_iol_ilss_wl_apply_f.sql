: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_wl_apply_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_wl_apply.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.apply_no,chr(13),''),chr(10),'') as apply_no
,t.customer_id as customer_id
,t.apply_time as apply_time
,t.org_id as org_id
,t.product_id as product_id
,t.category_id as category_id
,replace(replace(t.loan_foward,chr(13),''),chr(10),'') as loan_foward
,replace(replace(t.channel_code,chr(13),''),chr(10),'') as channel_code
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,t.apply_limit as apply_limit
,t.loan_term as loan_term
,t.annual_rate as annual_rate
,replace(replace(t.repay_day,chr(13),''),chr(10),'') as repay_day
,t.inst_fee_rate as inst_fee_rate
,replace(replace(t.cash_type,chr(13),''),chr(10),'') as cash_type
,t.required_delay_days as required_delay_days
,t.service_fee as service_fee
,replace(replace(t.is_get_delay_fee,chr(13),''),chr(10),'') as is_get_delay_fee
,replace(replace(t.repay_method,chr(13),''),chr(10),'') as repay_method
,replace(replace(t.bank_name,chr(13),''),chr(10),'') as bank_name
,replace(replace(t.bank_card_no,chr(13),''),chr(10),'') as bank_card_no
,replace(replace(t.bank_card_client,chr(13),''),chr(10),'') as bank_card_client
,replace(replace(t.bank_bind_phone,chr(13),''),chr(10),'') as bank_bind_phone
,t.loan_term_day as loan_term_day
,t.flg as flg
,t.status as status
,t.create_user as create_user
,t.create_time as create_time
,t.update_user as update_user
,t.update_time as update_time
,replace(replace(t.credit_score,chr(13),''),chr(10),'') as credit_score
,t.is_submit as is_submit
,replace(replace(t.merchant_no,chr(13),''),chr(10),'') as merchant_no
,replace(replace(t.tax_no,chr(13),''),chr(10),'') as tax_no
,replace(replace(t.serial_no,chr(13),''),chr(10),'') as serial_no
,replace(replace(t.credit_no,chr(13),''),chr(10),'') as credit_no
,replace(replace(t.account_no,chr(13),''),chr(10),'') as account_no
,t.group_id as group_id
,replace(replace(t.project_no,chr(13),''),chr(10),'') as project_no
,replace(replace(t.agency_no,chr(13),''),chr(10),'') as agency_no
,replace(replace(t.customer_no,chr(13),''),chr(10),'') as customer_no
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ilss_wl_apply t
where start_dt <= to_date('${batch_date}','yyyymmdd')
  and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_wl_apply.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes