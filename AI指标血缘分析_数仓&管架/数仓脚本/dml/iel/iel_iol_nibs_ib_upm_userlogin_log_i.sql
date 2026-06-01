: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nibs_ib_upm_userlogin_log_i
CreateDate: 20180529
FileName:   ${iel_data_path}/nibs_ib_upm_userlogin_log.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.username,chr(13),''),chr(10),'') as username
,replace(replace(t1.note3,chr(13),''),chr(10),'') as note3
,replace(replace(t1.datereg,chr(13),''),chr(10),'') as datereg
,replace(replace(t1.regtype,chr(13),''),chr(10),'') as regtype
,replace(replace(t1.deviceoid,chr(13),''),chr(10),'') as deviceoid
,replace(replace(t1.branchnum,chr(13),''),chr(10),'') as branchnum
,replace(replace(t1.loginstate,chr(13),''),chr(10),'') as loginstate
,replace(replace(t1.causefailure,chr(13),''),chr(10),'') as causefailure
,replace(replace(t1.sessionid,chr(13),''),chr(10),'') as sessionid
,replace(replace(t1.loginip,chr(13),''),chr(10),'') as loginip
,replace(replace(t1.usernum,chr(13),''),chr(10),'') as usernum
,replace(replace(t1.note4,chr(13),''),chr(10),'') as note4
,replace(replace(t1.note5,chr(13),''),chr(10),'') as note5
,replace(replace(t1.appnum,chr(13),''),chr(10),'') as appnum
,replace(replace(t1.note1,chr(13),''),chr(10),'') as note1
,replace(replace(t1.note2,chr(13),''),chr(10),'') as note2
,replace(replace(t1.hostname,chr(13),''),chr(10),'') as hostname
,replace(replace(t1.regtime,chr(13),''),chr(10),'') as regtime
,replace(replace(t1.outflag,chr(13),''),chr(10),'') as outflag
from ${iol_schema}.nibs_ib_upm_userlogin_log t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nibs_ib_upm_userlogin_log.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes