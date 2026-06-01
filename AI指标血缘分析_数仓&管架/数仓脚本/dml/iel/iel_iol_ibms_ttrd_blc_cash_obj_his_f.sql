: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_blc_cash_obj_his_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_blc_cash_obj_his.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.tsk_id,chr(13),''),chr(10),'') as tsk_id
,replace(replace(t1.beg_date,chr(13),''),chr(10),'') as beg_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.set_date,chr(13),''),chr(10),'') as set_date
,replace(replace(t1.ext_cash_acct_id,chr(13),''),chr(10),'') as ext_cash_acct_id
,replace(replace(t1.cash_acct_id,chr(13),''),chr(10),'') as cash_acct_id
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,t1.blc_type as blc_type
,t1.amount as amount
,t1.freeze_amount as freeze_amount
,t1.usable_amount as usable_amount
,replace(replace(t1.open_time,chr(13),''),chr(10),'') as open_time
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.etl_timestamp as etl_timestamp
from iol.ibms_ttrd_blc_cash_obj_his t1
where t1.etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_blc_cash_obj_his.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes