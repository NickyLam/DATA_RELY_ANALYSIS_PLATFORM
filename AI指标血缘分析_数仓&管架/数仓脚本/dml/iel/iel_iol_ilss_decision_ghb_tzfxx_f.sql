: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_decision_ghb_tzfxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_decision_ghb_tzfxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.id as id 
,replace(replace(t1.nsrsbh,chr(13),''),chr(10),'') as nsrsbh 
,t1.jcxx_id as jcxx_id 
,replace(replace(t1.tzfmc,chr(13),''),chr(10),'') as tzfmc 
,replace(replace(t1.tzfjjxz_mc,chr(13),''),chr(10),'') as tzfjjxz_mc 
,t1.tzbl as tzbl 
,replace(replace(t1.zj_mc,chr(13),''),chr(10),'') as zj_mc 
,replace(replace(t1.zjhm,chr(13),''),chr(10),'') as zjhm 
,replace(replace(t1.yxqq,chr(13),''),chr(10),'') as yxqq 
,t1.tzje as tzje 
,replace(replace(t1.yxqz,chr(13),''),chr(10),'') as yxqz 
,t1.fpbl as fpbl 
from ${iol_schema}.ilss_decision_ghb_tzfxx t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_decision_ghb_tzfxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes