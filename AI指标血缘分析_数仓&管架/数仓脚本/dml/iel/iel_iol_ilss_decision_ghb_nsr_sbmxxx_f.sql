: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_decision_ghb_nsr_sbmxxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_decision_ghb_nsr_sbmxxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.id as id 
,replace(replace(t1.nsrsbh,chr(13),''),chr(10),'') as nsrsbh 
,replace(replace(t1.spuuid,chr(13),''),chr(10),'') as spuuid 
,replace(replace(t1.djxh,chr(13),''),chr(10),'') as djxh 
,replace(replace(t1.dzsphm,chr(13),''),chr(10),'') as dzsphm 
,replace(replace(t1.skssqq,chr(13),''),chr(10),'') as skssqq 
,replace(replace(t1.skssqz,chr(13),''),chr(10),'') as skssqz 
,replace(replace(t1.zsxm_dm,chr(13),''),chr(10),'') as zsxm_dm 
,replace(replace(t1.zsxmmc,chr(13),''),chr(10),'') as zsxmmc 
,replace(replace(t1.zspm_dm,chr(13),''),chr(10),'') as zspm_dm 
,replace(replace(t1.zspmmc,chr(13),''),chr(10),'') as zspmmc 
,replace(replace(t1.skzl_dm,chr(13),''),chr(10),'') as skzl_dm 
,replace(replace(t1.skzlmc,chr(13),''),chr(10),'') as skzlmc 
,replace(replace(t1.pzhm,chr(13),''),chr(10),'') as pzhm 
,t1.sjje as sjje 
,replace(replace(t1.jkrq,chr(13),''),chr(10),'') as jkrq 
,replace(replace(t1.rkrq,chr(13),''),chr(10),'') as rkrq 
,replace(replace(t1.jkqx,chr(13),''),chr(10),'') as jkqx 
,replace(replace(t1.jsyj,chr(13),''),chr(10),'') as jsyj 
,replace(replace(t1.sl_1,chr(13),''),chr(10),'') as sl_1 
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time 
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time 
,replace(replace(t1.auth_uuid,chr(13),''),chr(10),'') as auth_uuid 
,t1.data_syn_time as data_syn_time 
from ${iol_schema}.ilss_decision_ghb_nsr_sbmxxx t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_decision_ghb_nsr_sbmxxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes