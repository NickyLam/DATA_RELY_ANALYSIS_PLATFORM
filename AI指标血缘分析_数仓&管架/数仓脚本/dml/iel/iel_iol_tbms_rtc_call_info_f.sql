: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tbms_rtc_call_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tbms_rtc_call_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.callid,chr(13),''),chr(10),'') as callid 
,replace(replace(t1.callname,chr(13),''),chr(10),'') as callname 
,t1.appid as appid 
,t1.calltype as calltype 
,t1.caller as caller 
,t1.createtime as createtime 
,replace(replace(t1.extrainfo,chr(13),''),chr(10),'') as extrainfo 
,t1.mediamode as mediamode 
,t1.chairman as chairman 
,t1.status as status 
,t1.version as version 
,t1.starttime as starttime 
,t1.finishtime as finishtime 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.tbms_rtc_call_info t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tbms_rtc_call_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes