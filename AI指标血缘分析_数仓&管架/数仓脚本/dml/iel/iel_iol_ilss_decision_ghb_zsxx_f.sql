: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_decision_ghb_zsxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_decision_ghb_zsxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.id as id 
,t1.jcxx_id as jcxx_id 
,replace(replace(t1.sssq_q,chr(13),''),chr(10),'') as sssq_q 
,replace(replace(t1.sssq_z,chr(13),''),chr(10),'') as sssq_z 
,replace(replace(t1.jkqx,chr(13),''),chr(10),'') as jkqx 
,replace(replace(t1.jkfsrq,chr(13),''),chr(10),'') as jkfsrq 
,replace(replace(t1.skzt,chr(13),''),chr(10),'') as skzt 
,replace(replace(t1.zsxm,chr(13),''),chr(10),'') as zsxm 
,replace(replace(t1.skzl,chr(13),''),chr(10),'') as skzl 
,t1.xssr as xssr 
,t1.sl as sl 
,t1.se as se 
,replace(replace(t1.nsrsbh,chr(13),''),chr(10),'') as nsrsbh 
from ${iol_schema}.ilss_decision_ghb_zsxx t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_decision_ghb_zsxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes