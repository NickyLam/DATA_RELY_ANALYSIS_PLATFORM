: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_atms_dev_cash_clear_f
CreateDate: 20180529
FileName:   ${iel_data_path}/atms_dev_cash_clear.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.dev_no,chr(13),''),chr(10),'') as dev_no
,replace(replace(t1.addcash_id,chr(13),''),chr(10),'') as addcash_id
,replace(replace(t1.addcash_datetime,chr(13),''),chr(10),'') as addcash_datetime
,t1.addcash_amount as addcash_amount
,replace(replace(t1.addcash_type,chr(13),''),chr(10),'') as addcash_type
,replace(replace(t1.addcash_count,chr(13),''),chr(10),'') as addcash_count
,replace(replace(t1.clear_datetime,chr(13),''),chr(10),'') as clear_datetime
,t1.addcash_left as addcash_left
,t1.addcash_lastamount as addcash_lastamount
,t1.addcash_retractcount as addcash_retractcount
,t1.deposit_count as deposit_count
,t1.deposit_amount as deposit_amount
,t1.withdraw_count as withdraw_count
,t1.withdraw_amount as withdraw_amount
,replace(replace(t1.clear_id,chr(13),''),chr(10),'') as clear_id
,replace(replace(t1.cashutil_amount,chr(13),''),chr(10),'') as cashutil_amount
,replace(replace(t1.cashby_handcount,chr(13),''),chr(10),'') as cashby_handcount
,replace(replace(t1.add_id,chr(13),''),chr(10),'') as add_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.atms_dev_cash_clear t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/atms_dev_cash_clear.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes