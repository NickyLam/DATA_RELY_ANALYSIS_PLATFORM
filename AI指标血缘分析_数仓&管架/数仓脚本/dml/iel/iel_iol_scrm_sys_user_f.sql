: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_scrm_sys_user_f
CreateDate: 20230804
FileName:   ${iel_data_path}/scrm_sys_user.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.qw_user_id,chr(13),''),chr(10),'') as qw_user_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.user_name,chr(13),''),chr(10),'') as user_name
,replace(replace(t1.user_alias,chr(13),''),chr(10),'') as user_alias
,replace(replace(t1.user_type,chr(13),''),chr(10),'') as user_type
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.gender,chr(13),''),chr(10),'') as gender
,replace(replace(t1.avatar,chr(13),''),chr(10),'') as avatar
,replace(replace(t1.join_date,chr(13),''),chr(10),'') as join_date
,replace(replace(t1.id_card,chr(13),''),chr(10),'') as id_card
,replace(replace(t1.qrcode,chr(13),''),chr(10),'') as qrcode
,replace(replace(t1.wx_account,chr(13),''),chr(10),'') as wx_account
,replace(replace(t1.qq_account,chr(13),''),chr(10),'') as qq_account
,replace(replace(t1.telephone,chr(13),''),chr(10),'') as telephone
,replace(replace(t1.addr,chr(13),''),chr(10),'') as addr
,replace(replace(t1.dimission_date,chr(13),''),chr(10),'') as dimission_date
,replace(replace(t1.birthday,chr(13),''),chr(10),'') as birthday
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,is_allocate
,isopenchat
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,status
,qw_status
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.last_modi_by,chr(13),''),chr(10),'') as last_modi_by
,replace(replace(t1.last_modi_time,chr(13),''),chr(10),'') as last_modi_time
,replace(replace(t1.user_no,chr(13),''),chr(10),'') as user_no
,shop_status
,auth_flag
,replace(replace(t1.sop_flag,chr(13),''),chr(10),'') as sop_flag
,replace(replace(t1.config_id,chr(13),''),chr(10),'') as config_id
,is_dept_leader
,replace(replace(t1.direct_leader,chr(13),''),chr(10),'') as direct_leader
,replace(replace(t1.post_name,chr(13),''),chr(10),'') as post_name
,dist_line
,replace(replace(t1.user_ticket,chr(13),''),chr(10),'') as user_ticket

from ${iol_schema}.scrm_sys_user t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/scrm_sys_user.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
