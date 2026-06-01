: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_crmwdescription_i
CreateDate: 20230423
FileName:   ${iel_data_path}/wind_crmwdescription.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.b_info_windcode,chr(13),''),chr(10),'') as b_info_windcode
,replace(replace(t1.b_create_fullname,chr(13),''),chr(10),'') as b_create_fullname
,replace(replace(t1.b_create_name,chr(13),''),chr(10),'') as b_create_name
,replace(replace(t1.b_create_nameid,chr(13),''),chr(10),'') as b_create_nameid
,replace(replace(t1.filenum,chr(13),''),chr(10),'') as filenum
,replace(replace(t1.b_create_ann_date,chr(13),''),chr(10),'') as b_create_ann_date
,b_create_object
,b_create_price
,b_create_amountplan
,b_create_amountact
,replace(replace(t1.b_create_firstissue,chr(13),''),chr(10),'') as b_create_firstissue
,replace(replace(t1.b_registration_date,chr(13),''),chr(10),'') as b_registration_date
,replace(replace(t1.b_create_start_day,chr(13),''),chr(10),'') as b_create_start_day
,replace(replace(t1.b_create_end_day,chr(13),''),chr(10),'') as b_create_end_day
,b_create_term_day
,b_create_payment_code
,b_cgross_principal_amount
,is_guarantee
,b_cgross_settlement_code
,b_voucher_code
,b_security_code
,b_unit_nominal_capital
,replace(replace(t1.b_create_cancellation_day,chr(13),''),chr(10),'') as b_create_cancellation_day
,replace(replace(t1.b_info_compcode,chr(13),''),chr(10),'') as b_info_compcode
,replace(replace(t1.b_create_debt_type,chr(13),''),chr(10),'') as b_create_debt_type
,replace(replace(t1.b_create_debt_features,chr(13),''),chr(10),'') as b_create_debt_features
,replace(replace(t1.b_info_code,chr(13),''),chr(10),'') as b_info_code
,start_dt
,end_dt

from ${iol_schema}.wind_crmwdescription t1
where start_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_crmwdescription.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
