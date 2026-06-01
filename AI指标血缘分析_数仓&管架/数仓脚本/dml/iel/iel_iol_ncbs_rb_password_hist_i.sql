: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_password_hist_i
CreateDate: 20230804
FileName:   ${iel_data_path}/ncbs_rb_password_hist.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.pwd_key,chr(13),''),chr(10),'') as pwd_key
,replace(replace(t1.pwd_type,chr(13),''),chr(10),'') as pwd_type
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.password_new,chr(13),''),chr(10),'') as password_new
,replace(replace(t1.password_old,chr(13),''),chr(10),'') as password_old
,tran_date
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.modify_password_type,chr(13),''),chr(10),'') as modify_password_type
,replace(replace(t1.modify_reason,chr(13),''),chr(10),'') as modify_reason
,replace(replace(t1.password_status,chr(13),''),chr(10),'') as password_status
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.company,chr(13),''),chr(10),'') as company

from ${iol_schema}.ncbs_rb_password_hist t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_password_hist.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
