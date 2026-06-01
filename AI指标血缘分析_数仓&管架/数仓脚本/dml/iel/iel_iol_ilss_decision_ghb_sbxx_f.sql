: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_decision_ghb_sbxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_decision_ghb_sbxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.id as id 
,t1.jcxx_id as jcxx_id 
,replace(replace(t1.nsrsbh,chr(13),''),chr(10),'') as nsrsbh 
,replace(replace(t1.sbrq,chr(13),''),chr(10),'') as sbrq 
,replace(replace(t1.sbqx,chr(13),''),chr(10),'') as sbqx 
,replace(replace(t1.zsxm,chr(13),''),chr(10),'') as zsxm 
,replace(replace(t1.sssqq,chr(13),''),chr(10),'') as sssqq 
,replace(replace(t1.sssqz,chr(13),''),chr(10),'') as sssqz 
,t1.qbxssr as qbxssr 
,t1.ysxssr as ysxssr 
,t1.ynse as ynse 
,t1.yjse as yjse 
,t1.ybtse as ybtse 
,t1.jmse as jmse 
from ${iol_schema}.ilss_decision_ghb_sbxx t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_decision_ghb_sbxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes