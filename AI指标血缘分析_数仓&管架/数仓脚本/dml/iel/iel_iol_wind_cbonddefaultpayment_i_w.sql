: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbonddefaultpayment_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_cbonddefaultpayment_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(object_id,chr(10),''),chr(13),'') as object_id
,replace(replace(b_info_windcode,chr(10),''),chr(13),'') as b_info_windcode
,replace(replace(b_announcementdate,chr(10),''),chr(13),'') as b_announcementdate
,replace(replace(b_actual_payment,chr(10),''),chr(13),'') as b_actual_payment
,replace(replace(b_payment_code,chr(10),''),chr(13),'') as b_payment_code
,replace(replace(b_payment_front_balance,chr(10),''),chr(13),'') as b_payment_front_balance
,replace(replace(b_payment_amount,chr(10),''),chr(13),'') as b_payment_amount
,replace(replace(b_principal_amount,chr(10),''),chr(13),'') as b_principal_amount
,replace(replace(b_principal_interest_amount,chr(10),''),chr(13),'') as b_principal_interest_amount
,replace(replace(b_principal_amount_tot,chr(10),''),chr(13),'') as b_principal_amount_tot
,replace(replace(b_principal_int_amount_tot,chr(10),''),chr(13),'') as b_principal_int_amount_tot
,replace(replace(b_resale_payment_tot,chr(10),''),chr(13),'') as b_resale_payment_tot
,replace(replace(b_resale_payment_tot1,chr(10),''),chr(13),'') as b_resale_payment_tot1
,replace(replace(b_payment_after_balance,chr(10),''),chr(13),'') as b_payment_after_balance
,etl_dt
,etl_timestamp
from ${iol_schema}.wind_cbonddefaultpayment
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbonddefaultpayment_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes