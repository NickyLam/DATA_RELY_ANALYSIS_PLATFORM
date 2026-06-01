: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_trd_trade_fee_detail_f
CreateDate: 20240613
FileName:   ${iel_data_path}/fams_trd_trade_fee_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.trade_id,chr(13),''),chr(10),'') as trade_id
,replace(replace(t1.fee_type,chr(13),''),chr(10),'') as fee_type
,replace(replace(t1.is_pay_with_trade,chr(13),''),chr(10),'') as is_pay_with_trade
,fee_amt
,replace(replace(t1.chl_finprod_id,chr(13),''),chr(10),'') as chl_finprod_id
,replace(replace(t1.fee_id,chr(13),''),chr(10),'') as fee_id
,fee_rate
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.is_prepaid,chr(13),''),chr(10),'') as is_prepaid

from ${iol_schema}.fams_trd_trade_fee_detail t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_trd_trade_fee_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
