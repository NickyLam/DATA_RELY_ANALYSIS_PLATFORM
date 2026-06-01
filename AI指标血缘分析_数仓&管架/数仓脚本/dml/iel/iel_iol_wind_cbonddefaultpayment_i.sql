: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbonddefaultpayment_i
CreateDate: 20230423
FileName:   ${iel_data_path}/wind_cbonddefaultpayment.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.b_info_windcode,chr(13),''),chr(10),'') as b_info_windcode
,replace(replace(t1.b_announcementdate,chr(13),''),chr(10),'') as b_announcementdate
,replace(replace(t1.b_actual_payment,chr(13),''),chr(10),'') as b_actual_payment
,b_payment_code
,b_payment_front_balance
,b_payment_amount
,b_principal_amount
,b_principal_interest_amount
,b_principal_amount_tot
,b_principal_int_amount_tot
,b_resale_payment_tot
,b_resale_payment_tot1
,b_payment_after_balance

from ${iol_schema}.wind_cbonddefaultpayment t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbonddefaultpayment.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
