: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_crmwdescription_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_crmwdescription_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(object_id,chr(10),''),chr(13),'') as object_id
,replace(replace(b_info_windcode,chr(10),''),chr(13),'') as b_info_windcode
,replace(replace(b_create_fullname,chr(10),''),chr(13),'') as b_create_fullname
,replace(replace(b_create_name,chr(10),''),chr(13),'') as b_create_name
,replace(replace(b_create_nameid,chr(10),''),chr(13),'') as b_create_nameid
,replace(replace(filenum,chr(10),''),chr(13),'') as filenum
,replace(replace(b_create_ann_date,chr(10),''),chr(13),'') as b_create_ann_date
,replace(replace(b_create_object,chr(10),''),chr(13),'') as b_create_object
,replace(replace(b_create_price,chr(10),''),chr(13),'') as b_create_price
,replace(replace(b_create_amountplan,chr(10),''),chr(13),'') as b_create_amountplan
,replace(replace(b_create_amountact,chr(10),''),chr(13),'') as b_create_amountact
,replace(replace(b_create_firstissue,chr(10),''),chr(13),'') as b_create_firstissue
,replace(replace(b_registration_date,chr(10),''),chr(13),'') as b_registration_date
,replace(replace(b_create_start_day,chr(10),''),chr(13),'') as b_create_start_day
,replace(replace(b_create_end_day,chr(10),''),chr(13),'') as b_create_end_day
,replace(replace(b_create_term_day,chr(10),''),chr(13),'') as b_create_term_day
,replace(replace(b_create_payment_code,chr(10),''),chr(13),'') as b_create_payment_code
,replace(replace(b_cgross_principal_amount,chr(10),''),chr(13),'') as b_cgross_principal_amount
,replace(replace(is_guarantee,chr(10),''),chr(13),'') as is_guarantee
,replace(replace(b_cgross_settlement_code,chr(10),''),chr(13),'') as b_cgross_settlement_code
,replace(replace(b_voucher_code,chr(10),''),chr(13),'') as b_voucher_code
,replace(replace(b_security_code,chr(10),''),chr(13),'') as b_security_code
,replace(replace(b_unit_nominal_capital,chr(10),''),chr(13),'') as b_unit_nominal_capital
,replace(replace(b_create_cancellation_day,chr(10),''),chr(13),'') as b_create_cancellation_day
,replace(replace(b_info_compcode,chr(10),''),chr(13),'') as b_info_compcode
,replace(replace(b_create_debt_type,chr(10),''),chr(13),'') as b_create_debt_type
,replace(replace(b_create_debt_features,chr(10),''),chr(13),'') as b_create_debt_features
,replace(replace(b_info_code,chr(10),''),chr(13),'') as b_info_code
,start_dt
,end_dt
,id_mark
,etl_timestamp
from  ${iol_schema}.wind_crmwdescription
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_crmwdescription_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes