: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_eass_v_latest_payment_sleep_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_eass_v_latest_payment_sleep_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.e_account_no,chr(13),''),chr(10),'') as e_account_no
,replace(replace(t1.account_no,chr(13),''),chr(10),'') as account_no
,replace(replace(t1.fin_account_id,chr(13),''),chr(10),'') as fin_account_id
,replace(replace(t1.max_pay_stamp,chr(13),''),chr(10),'') as max_pay_stamp
from ${iol_schema}.eass_v_latest_payment_sleep_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_eass_v_latest_payment_sleep_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes