: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_decision_ghb_nsr_sbzhxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_decision_ghb_nsr_sbzhxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.id as id 
,replace(replace(t1.nsrsbh,chr(13),''),chr(10),'') as nsrsbh 
,replace(replace(t1.sbxxuuid,chr(13),''),chr(10),'') as sbxxuuid 
,replace(replace(t1.djxh,chr(13),''),chr(10),'') as djxh 
,replace(replace(t1.sbrq,chr(13),''),chr(10),'') as sbrq 
,replace(replace(t1.sbqx,chr(13),''),chr(10),'') as sbqx 
,replace(replace(t1.sssqq,chr(13),''),chr(10),'') as sssqq 
,replace(replace(t1.sssqz,chr(13),''),chr(10),'') as sssqz 
,replace(replace(t1.zsxm_dm,chr(13),''),chr(10),'') as zsxm_dm 
,replace(replace(t1.zsxmmc,chr(13),''),chr(10),'') as zsxmmc 
,replace(replace(t1.zspm_dm,chr(13),''),chr(10),'') as zspm_dm 
,replace(replace(t1.zspmmc,chr(13),''),chr(10),'') as zspmmc 
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time 
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time 
,replace(replace(t1.auth_uuid,chr(13),''),chr(10),'') as auth_uuid 
,t1.data_syn_time as data_syn_time 
,t1.qbxssr as qbxssr 
,t1.ysxssr as ysxssr 
,t1.ynse as ynse 
,t1.yjse as yjse 
,t1.ybtse as ybtse 
from ${iol_schema}.ilss_decision_ghb_nsr_sbzhxx t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_decision_ghb_nsr_sbzhxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes