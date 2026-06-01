: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tbms_t_meet_minfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tbms_t_meet_minfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.mid as mid 
,t1.groupid as groupid 
,t1.companyid as companyid 
,t1.convener as convener 
,t1.mctime as mctime 
,replace(replace(t1.mtitle,chr(13),''),chr(10),'') as mtitle 
,t1.mtime as mtime 
,replace(replace(t1.msite,chr(13),''),chr(10),'') as msite 
,t1.begintime as begintime 
,t1.status as status 
,replace(replace(t1.mark,chr(13),''),chr(10),'') as mark 
,t1.mutid as mutid 
,t1.jobid as jobid 
,t1.versions as versions 
,t1.sys_ctime as sys_ctime 
,t1.sys_utime as sys_utime 
,t1.sys_valid as sys_valid 
,replace(replace(t1.clientinfo,chr(13),''),chr(10),'') as clientinfo 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.tbms_t_meet_minfo t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tbms_t_meet_minfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes