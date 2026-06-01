: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_bdps_bail_account_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_bdps_bail_account.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.id
,t1.bail_account
,t1.cust_id
,t1.bail_sub_no
,t1.bail_amount
,t1.manager_id
,t1.depart_id
,t1.brch_id
,t1.cust_account_start_dt
,t1.cust_account_mature_dt
,t1.cust_account_rate
,t1.deposit_type
,t1.last_upd_oper_id
,t1.last_upd_time
,t1.valid_flag
,t1.lock_flag
,t1.lock_type
,t1.lock_id
,t1.if_default
,t1.avaibl
,t1.pool_type
,t1.bank_no
,t1.bank_name
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_bdps_bail_account t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_bdps_bail_account.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes