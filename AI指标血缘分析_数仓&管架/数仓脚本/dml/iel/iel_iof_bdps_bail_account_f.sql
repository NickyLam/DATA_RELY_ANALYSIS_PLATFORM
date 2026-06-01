: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_bdps_bail_account_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdps_bail_account.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.bail_account,chr(13),''),chr(10),'') as bail_account
,t.cust_id as cust_id
,replace(replace(t.bail_sub_no,chr(13),''),chr(10),'') as bail_sub_no
,t.bail_amount as bail_amount
,t.manager_id as manager_id
,t.depart_id as depart_id
,replace(replace(t.brch_id,chr(13),''),chr(10),'') as brch_id
,replace(replace(t.cust_account_start_dt,chr(13),''),chr(10),'') as cust_account_start_dt
,replace(replace(t.cust_account_mature_dt,chr(13),''),chr(10),'') as cust_account_mature_dt
,t.cust_account_rate as cust_account_rate
,t.deposit_type as deposit_type
,t.last_upd_oper_id as last_upd_oper_id
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.valid_flag,chr(13),''),chr(10),'') as valid_flag
,replace(replace(t.lock_flag,chr(13),''),chr(10),'') as lock_flag
,replace(replace(t.lock_type,chr(13),''),chr(10),'') as lock_type
,t.lock_id as lock_id
,replace(replace(t.if_default,chr(13),''),chr(10),'') as if_default
,t.avaibl as avaibl
,replace(replace(t.pool_type,chr(13),''),chr(10),'') as pool_type
,replace(replace(t.bank_no,chr(13),''),chr(10),'') as bank_no
,replace(replace(t.bank_name,chr(13),''),chr(10),'') as bank_name
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdps_bail_account t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdps_bail_account.f.${batch_date}.dat" \
        charset=utf8
        safe=yes