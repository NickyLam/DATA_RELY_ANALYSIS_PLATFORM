: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tbms_t_corp_userlist_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tbms_t_corp_userlist.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.companyid as companyid 
,t1.uaid as uaid 
,replace(replace(t1.username,chr(13),''),chr(10),'') as username 
,replace(replace(t1.userphone,chr(13),''),chr(10),'') as userphone 
,t1.sex as sex 
,t1.birthdate as birthdate 
,replace(replace(t1.workphone,chr(13),''),chr(10),'') as workphone 
,replace(replace(t1.workextension,chr(13),''),chr(10),'') as workextension 
,replace(replace(t1.workemail,chr(13),''),chr(10),'') as workemail 
,replace(replace(t1.workno,chr(13),''),chr(10),'') as workno 
,t1.status as status 
,t1.iconid as iconid 
,replace(replace(t1.usercustom,chr(13),''),chr(10),'') as usercustom 
,t1.relationstatus as relationstatus 
,t1.friendstatus as friendstatus 
,t1.usertype as usertype 
,t1.certificatetype as certificatetype 
,replace(replace(t1.certificatenum,chr(13),''),chr(10),'') as certificatenum 
,t1.versions as versions 
,t1.sys_ctime as sys_ctime 
,t1.sys_utime as sys_utime 
,t1.sys_valid as sys_valid 
,t1.applystate as applystate 
,replace(replace(t1.applyreason,chr(13),''),chr(10),'') as applyreason 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.tbms_t_corp_userlist t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tbms_t_corp_userlist.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes