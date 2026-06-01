: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_nsr_ybqykjzdfzxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_nsr_ybqykjzdfzxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.uuid,chr(13),''),chr(10),'') as uuid
,replace(replace(t.zlbscjuuid,chr(13),''),chr(10),'') as zlbscjuuid
,replace(replace(t.djxh,chr(13),''),chr(10),'') as djxh
,replace(replace(t.ewbhxh,chr(13),''),chr(10),'') as ewbhxh
,replace(replace(t.zcxmmc,chr(13),''),chr(10),'') as zcxmmc
,replace(replace(t.ssqq,chr(13),''),chr(10),'') as ssqq
,replace(replace(t.ssqz,chr(13),''),chr(10),'') as ssqz
,t.qms_zc as qms_zc
,t.ncs_zc as ncs_zc
,replace(replace(t.qyxmmc,chr(13),''),chr(10),'') as qyxmmc
,t.qms_qy as qms_qy
,t.ncs_qy as ncs_qy
,replace(replace(t.lrrq,chr(13),''),chr(10),'') as lrrq
,replace(replace(t.lrrq2,chr(13),''),chr(10),'') as lrrq2
,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t.auth_uuid,chr(13),''),chr(10),'') as auth_uuid
,t.data_syn_time as data_syn_time
from iol.ilss_ghb_nsr_ybqykjzdfzxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_nsr_ybqykjzdfzxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes