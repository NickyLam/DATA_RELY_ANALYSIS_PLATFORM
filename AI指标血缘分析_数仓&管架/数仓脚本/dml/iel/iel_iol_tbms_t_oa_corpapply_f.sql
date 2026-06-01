: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tbms_t_oa_corpapply_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tbms_t_oa_corpapply.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.flowid as flowid 
,replace(replace(t1.flowname,chr(13),''),chr(10),'') as flowname 
,t1.cpytempletid as cpytempletid 
,t1.companyid as companyid 
,t1.uaid as uaid 
,t1.applyuaid as applyuaid 
,t1.status as status 
,replace(replace(t1.content,chr(13),''),chr(10),'') as content 
,replace(replace(t1.summary,chr(13),''),chr(10),'') as summary 
,t1.sys_ctime as sys_ctime 
,t1.sys_utime as sys_utime 
,t1.sys_valid as sys_valid 
,t1.lockstatus as lockstatus 
,t1.printcount as printcount 
,t1.appletuaid as appletuaid 
,t1.flowsourcetype as flowsourcetype 
,t1.pid as pid 
,replace(replace(t1.clientinfo,chr(13),''),chr(10),'') as clientinfo 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.tbms_t_oa_corpapply t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tbms_t_oa_corpapply.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes