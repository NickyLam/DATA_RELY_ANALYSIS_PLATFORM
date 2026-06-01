: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_mb_ccy_rate_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncbs_mb_ccy_rate.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.branch,chr(13),''),chr(10),'') as branch
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.effect_time,chr(13),''),chr(10),'') as effect_time
,replace(replace(t1.quote_type,chr(13),''),chr(10),'') as quote_type
,replace(replace(t1.rate_type,chr(13),''),chr(10),'') as rate_type
,t1.effect_date as effect_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,t1.central_bank_rate as central_bank_rate
,t1.exch_buy_rate as exch_buy_rate
,t1.exch_sell_rate as exch_sell_rate
,t1.max_float_rate as max_float_rate
,t1.middle_rate as middle_rate
,t1.notes_buy_rate as notes_buy_rate
,t1.notes_sell_rate as notes_sell_rate
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ncbs_mb_ccy_rate t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_mb_ccy_rate.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes