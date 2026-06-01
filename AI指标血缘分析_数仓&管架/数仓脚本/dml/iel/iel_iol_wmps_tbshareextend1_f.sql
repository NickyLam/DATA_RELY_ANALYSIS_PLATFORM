: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wmps_tbshareextend1_f
CreateDate: 20260323
FileName:   ${iel_data_path}/wmps_tbshareextend1.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,replace(replace(t1.in_client_no,chr(13),''),chr(10),'') as in_client_no
,replace(replace(t1.bank_no,chr(13),''),chr(10),'') as bank_no
,replace(replace(t1.seller_code,chr(13),''),chr(10),'') as seller_code
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.bank_acc,chr(13),''),chr(10),'') as bank_acc
,replace(replace(t1.ta_code,chr(13),''),chr(10),'') as ta_code
,replace(replace(t1.prd_code,chr(13),''),chr(10),'') as prd_code
,buy_amt_onway
,red_exp_amt
,red_income
,income_prev_date
,income_upd_date
,last_date
,replace(replace(t1.incomeonway_flag,chr(13),''),chr(10),'') as incomeonway_flag
,replace(replace(t1.redall_flag,chr(13),''),chr(10),'') as redall_flag
,redall_trans_date
,integer1
,integer2
,integer3
,amt1
,amt2
,amt3
,amt4
,amt5
,replace(replace(t1.reserve1,chr(13),''),chr(10),'') as reserve1
,replace(replace(t1.reserve2,chr(13),''),chr(10),'') as reserve2
,replace(replace(t1.reserve3,chr(13),''),chr(10),'') as reserve3
,replace(replace(t1.reserve4,chr(13),''),chr(10),'') as reserve4
,replace(replace(t1.reserve5,chr(13),''),chr(10),'') as reserve5

from ${iol_schema}.wmps_tbshareextend1 t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wmps_tbshareextend1.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
