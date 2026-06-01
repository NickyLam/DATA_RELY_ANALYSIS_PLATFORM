: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_bdps_bail_account_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_bdps_bail_account.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 t1.id as id
,replace(replace(t1.bail_account,chr(13),''),chr(10),'') as bail_account
,t1.cust_id as cust_id
,replace(replace(t1.bail_sub_no,chr(13),''),chr(10),'') as bail_sub_no
,t1.bail_amount as bail_amount
,t1.manager_id as manager_id
,t1.depart_id as depart_id
,replace(replace(t1.brch_id,chr(13),''),chr(10),'') as brch_id
,replace(replace(t1.cust_account_start_dt,chr(13),''),chr(10),'') as cust_account_start_dt
,replace(replace(t1.cust_account_mature_dt,chr(13),''),chr(10),'') as cust_account_mature_dt
,t1.cust_account_rate as cust_account_rate
,t1.deposit_type as deposit_type
,t1.last_upd_oper_id as last_upd_oper_id
,replace(replace(t1.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t1.valid_flag,chr(13),''),chr(10),'') as valid_flag
,replace(replace(t1.lock_flag,chr(13),''),chr(10),'') as lock_flag
,replace(replace(t1.lock_type,chr(13),''),chr(10),'') as lock_type
,t1.lock_id as lock_id
,replace(replace(t1.if_default,chr(13),''),chr(10),'') as if_default
,t1.avaibl as avaibl
,replace(replace(t1.pool_type,chr(13),''),chr(10),'') as pool_type
 from iol.bdps_bail_account T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_bdps_bail_account.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes