: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tbms_t_att_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tbms_t_att_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.attid as attid 
,t1.uaid as uaid 
,t1.companyid as companyid 
,t1.attdate as attdate 
,t1.opttime as opttime 
,t1.opttype as opttype 
,replace(replace(t1.macaddr,chr(13),''),chr(10),'') as macaddr 
,replace(replace(t1.wifiname,chr(13),''),chr(10),'') as wifiname 
,replace(replace(t1.longitude,chr(13),''),chr(10),'') as longitude 
,replace(replace(t1.latitude,chr(13),''),chr(10),'') as latitude 
,replace(replace(t1.reginname,chr(13),''),chr(10),'') as reginname 
,t1.status as status 
,t1.outsign as outsign 
,replace(replace(t1.mark,chr(13),''),chr(10),'') as mark 
,t1.sys_ctime as sys_ctime 
,t1.sys_utime as sys_utime 
,t1.sys_valid as sys_valid 
,replace(replace(t1.clientinfo,chr(13),''),chr(10),'') as clientinfo 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.tbms_t_att_flow t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tbms_t_att_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes