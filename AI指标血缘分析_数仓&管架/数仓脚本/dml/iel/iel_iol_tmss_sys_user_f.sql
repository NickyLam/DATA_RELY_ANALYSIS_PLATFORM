: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tmss_sys_user_f
CreateDate: 20260410
FileName:   ${iel_data_path}/tmss_sys_user.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,begin_use_time
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,is_admin
,replace(replace(t1.login_name,chr(13),''),chr(10),'') as login_name
,replace(replace(t1.password,chr(13),''),chr(10),'') as password
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.salt,chr(13),''),chr(10),'') as salt
,sex
,status
,replace(replace(t1.username,chr(13),''),chr(10),'') as username
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.user_cadn,chr(13),''),chr(10),'') as user_cadn
,login_type
,create_time
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,update_time
,replace(replace(t1.update_by,chr(13),''),chr(10),'') as update_by
,show_report
,replace(replace(t1.sys_skin,chr(13),''),chr(10),'') as sys_skin
,replace(replace(t1.tenant_id,chr(13),''),chr(10),'') as tenant_id
,replace(replace(t1.hx_wy_user_id,chr(13),''),chr(10),'') as hx_wy_user_id
,replace(replace(t1.cert_code,chr(13),''),chr(10),'') as cert_code

from ${iol_schema}.tmss_sys_user t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tmss_sys_user.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
