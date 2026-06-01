: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_decision_ghb_nsr_xypjxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_decision_ghb_nsr_xypjxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.id as id 
,replace(replace(t1.nsrdzdah,chr(13),''),chr(10),'') as nsrdzdah 
,replace(replace(t1.nsrsbh,chr(13),''),chr(10),'') as nsrsbh 
,replace(replace(t1.pjsj,chr(13),''),chr(10),'') as pjsj 
,replace(replace(t1.xydj,chr(13),''),chr(10),'') as xydj 
,replace(replace(t1.rtncode,chr(13),''),chr(10),'') as rtncode 
,replace(replace(t1.message,chr(13),''),chr(10),'') as message 
,replace(replace(t1.code,chr(13),''),chr(10),'') as code 
,replace(replace(t1.reason,chr(13),''),chr(10),'') as reason 
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time 
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time 
,replace(replace(t1.auth_uuid,chr(13),''),chr(10),'') as auth_uuid 
,t1.data_syn_time as data_syn_time 
from ${iol_schema}.ilss_decision_ghb_nsr_xypjxx t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_decision_ghb_nsr_xypjxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes