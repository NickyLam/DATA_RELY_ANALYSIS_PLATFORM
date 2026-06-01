: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_decision_ghb_nsr_tzfxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_decision_ghb_nsr_tzfxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.id as id 
,replace(replace(t1.nsrsbh,chr(13),''),chr(10),'') as nsrsbh 
,replace(replace(t1.uuid,chr(13),''),chr(10),'') as uuid 
,replace(replace(t1.djxh,chr(13),''),chr(10),'') as djxh 
,replace(replace(t1.tzfhhhrzjzl_dm,chr(13),''),chr(10),'') as tzfhhhrzjzl_dm 
,replace(replace(t1.tzfhhhrzjzlmc,chr(13),''),chr(10),'') as tzfhhhrzjzlmc 
,replace(replace(t1.tzfhhhrzjhm,chr(13),''),chr(10),'') as tzfhhhrzjhm 
,replace(replace(t1.tzfhhhrmc,chr(13),''),chr(10),'') as tzfhhhrmc 
,replace(replace(t1.tzfjjxz_dm,chr(13),''),chr(10),'') as tzfjjxz_dm 
,replace(replace(t1.tzbl,chr(13),''),chr(10),'') as tzbl 
,replace(replace(t1.gjhdqsz_dm,chr(13),''),chr(10),'') as gjhdqsz_dm 
,replace(replace(t1.gjhdqszmc,chr(13),''),chr(10),'') as gjhdqszmc 
,replace(replace(t1.dz,chr(13),''),chr(10),'') as dz 
,replace(replace(t1.yxqq,chr(13),''),chr(10),'') as yxqq 
,t1.tzje as tzje 
,replace(replace(t1.yxqz,chr(13),''),chr(10),'') as yxqz 
,replace(replace(t1.fpbl,chr(13),''),chr(10),'') as fpbl 
,replace(replace(t1.tzfhhrdjxh,chr(13),''),chr(10),'') as tzfhhrdjxh 
,replace(replace(t1.tzfjjxzmc,chr(13),''),chr(10),'') as tzfjjxzmc 
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time 
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time 
,replace(replace(t1.auth_uuid,chr(13),''),chr(10),'') as auth_uuid 
,t1.data_syn_time as data_syn_time 
from ${iol_schema}.ilss_decision_ghb_nsr_tzfxx t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_decision_ghb_nsr_tzfxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes