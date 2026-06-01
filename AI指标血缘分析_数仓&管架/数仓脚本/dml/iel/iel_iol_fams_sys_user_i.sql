: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_sys_user_i
CreateDate: 20240606
FileName:   ${iel_data_path}/fams_sys_user.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.system_code,chr(13),''),chr(10),'') as system_code
,replace(replace(t1.user_name,chr(13),''),chr(10),'') as user_name
,replace(replace(t1.real_name,chr(13),''),chr(10),'') as real_name
,replace(replace(t1.mail_addr,chr(13),''),chr(10),'') as mail_addr
,replace(replace(t1.phone_num,chr(13),''),chr(10),'') as phone_num
,replace(replace(t1.password,chr(13),''),chr(10),'') as password
,replace(replace(t1.salt,chr(13),''),chr(10),'') as salt
,replace(replace(t1.dept_code,chr(13),''),chr(10),'') as dept_code
,replace(replace(t1.sso_user_id,chr(13),''),chr(10),'') as sso_user_id
,replace(replace(t1.mob_num,chr(13),''),chr(10),'') as mob_num
,replace(replace(t1.wechat_num,chr(13),''),chr(10),'') as wechat_num
,replace(replace(t1.admin_flag,chr(13),''),chr(10),'') as admin_flag
,last_pass_date
,replace(replace(t1.is_frozen,chr(13),''),chr(10),'') as is_frozen
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,start_dt
,end_dt

from ${iol_schema}.fams_sys_user t1
where start_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_sys_user.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
