: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crms_t_cust_blng_pty_mgr_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_t_cust_blng_pty_mgr.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.flag,chr(13),''),chr(10),'') as flag
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.user_name,chr(13),''),chr(10),'') as user_name
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.upd_flg,chr(13),''),chr(10),'') as upd_flg
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,t1.create_date as create_date
,replace(replace(t1.field1,chr(13),''),chr(10),'') as field1
,replace(replace(t1.field2,chr(13),''),chr(10),'') as field2
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.crms_t_cust_blng_pty_mgr t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crms_t_cust_blng_pty_mgr.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes