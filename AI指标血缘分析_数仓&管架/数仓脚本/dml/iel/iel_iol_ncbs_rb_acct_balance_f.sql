: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_acct_balance_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncbs_rb_acct_balance.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,t1.internal_key as internal_key
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.dac_value,chr(13),''),chr(10),'') as dac_value
,t1.last_bal_upd_date as last_bal_upd_date
,t1.last_change_date as last_change_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,t1.dos_amount as dos_amount
,t1.finreg_amount as finreg_amount
,replace(replace(t1.last_change_user_id,chr(13),''),chr(10),'') as last_change_user_id
,t1.od_amount as od_amount
,t1.odd_amount as odd_amount
,t1.pld_amount as pld_amount
,t1.total_amount as total_amount
,t1.total_amount_prev as total_amount_prev
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ncbs_rb_acct_balance t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_acct_balance.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes