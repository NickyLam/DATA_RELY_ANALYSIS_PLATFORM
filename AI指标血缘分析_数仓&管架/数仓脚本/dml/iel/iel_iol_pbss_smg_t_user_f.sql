: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pbss_smg_t_user_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pbss_smg_t_user.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.id,chr(13),''),chr(10),'') as id 
,replace(replace(t1.user_code,chr(13),''),chr(10),'') as user_code 
,replace(replace(t1.user_hxyh_code,chr(13),''),chr(10),'') as user_hxyh_code 
,replace(replace(t1.user_name,chr(13),''),chr(10),'') as user_name 
,replace(replace(t1.br_code,chr(13),''),chr(10),'') as br_code 
,replace(replace(t1.user_pass,chr(13),''),chr(10),'') as user_pass 
,replace(replace(t1.encrypt_para,chr(13),''),chr(10),'') as encrypt_para 
,replace(replace(t1.identity_no,chr(13),''),chr(10),'') as identity_no 
,replace(replace(t1.sso_user_name,chr(13),''),chr(10),'') as sso_user_name 
,replace(replace(t1.notes_mail,chr(13),''),chr(10),'') as notes_mail 
,replace(replace(t1.email,chr(13),''),chr(10),'') as email 
,replace(replace(t1.telephone1,chr(13),''),chr(10),'') as telephone1 
,replace(replace(t1.telephone2,chr(13),''),chr(10),'') as telephone2 
,replace(replace(t1.address1,chr(13),''),chr(10),'') as address1 
,replace(replace(t1.address2,chr(13),''),chr(10),'') as address2 
,replace(replace(t1.user_stat,chr(13),''),chr(10),'') as user_stat 
,replace(replace(t1.login_stat,chr(13),''),chr(10),'') as login_stat 
,t1.create_time as create_time 
,replace(replace(t1.creator_id,chr(13),''),chr(10),'') as creator_id 
,t1.del_time as del_time 
,replace(replace(t1.dele_id,chr(13),''),chr(10),'') as dele_id 
,t1.modify_time as modify_time 
,replace(replace(t1.modi_id,chr(13),''),chr(10),'') as modi_id 
,t1.last_pass_time as last_pass_time 
,replace(replace(t1.auth_method,chr(13),''),chr(10),'') as auth_method 
from ${iol_schema}.pbss_smg_t_user t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pbss_smg_t_user.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes