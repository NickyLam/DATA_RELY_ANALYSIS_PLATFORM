: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icrw_t_sys_user_f
CreateDate: 20251009
FileName:   ${iel_data_path}/icrw_t_sys_user.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.user_name,chr(13),''),chr(10),'') as user_name
,replace(replace(t1.login_name,chr(13),''),chr(10),'') as login_name
,replace(replace(t1.tel,chr(13),''),chr(10),'') as tel
,replace(replace(t1.landline,chr(13),''),chr(10),'') as landline
,replace(replace(t1.password,chr(13),''),chr(10),'') as password
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.role_id,chr(13),''),chr(10),'') as role_id
,replace(replace(t1.role_ids,chr(13),''),chr(10),'') as role_ids
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,sort_no
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,ver
,replace(replace(t1.law_org_id,chr(13),''),chr(10),'') as law_org_id
,replace(replace(t1.id_card_no,chr(13),''),chr(10),'') as id_card_no
,replace(replace(t1.addr,chr(13),''),chr(10),'') as addr
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.teller_no,chr(13),''),chr(10),'') as teller_no
,working_years
,replace(replace(t1.wechat_no,chr(13),''),chr(10),'') as wechat_no
,replace(replace(t1.org_addr,chr(13),''),chr(10),'') as org_addr
,replace(replace(t1.is_sta_login,chr(13),''),chr(10),'') as is_sta_login

from ${iol_schema}.icrw_t_sys_user t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrw_t_sys_user.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
