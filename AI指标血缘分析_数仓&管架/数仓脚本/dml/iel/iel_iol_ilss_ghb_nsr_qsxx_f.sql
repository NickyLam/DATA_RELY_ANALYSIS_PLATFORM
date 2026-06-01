: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_nsr_qsxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_nsr_qsxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.zsuuid,chr(13),''),chr(10),'') as zsuuid
,replace(replace(t.djxh,chr(13),''),chr(10),'') as djxh
,replace(replace(t.zsxm_dm,chr(13),''),chr(10),'') as zsxm_dm
,replace(replace(t.zsxmmc,chr(13),''),chr(10),'') as zsxmmc
,replace(replace(t.skssqq,chr(13),''),chr(10),'') as skssqq
,replace(replace(t.skssqz,chr(13),''),chr(10),'') as skssqz
,replace(replace(t.zspm_dm,chr(13),''),chr(10),'') as zspm_dm
,replace(replace(t.zspmmc,chr(13),''),chr(10),'') as zspmmc
,replace(replace(t.jkqx,chr(13),''),chr(10),'') as jkqx
,replace(replace(t.jmse,chr(13),''),chr(10),'') as jmse
,replace(replace(t.jsyj,chr(13),''),chr(10),'') as jsyj
,replace(replace(t.ynse,chr(13),''),chr(10),'') as ynse
,replace(replace(t.rkrq,chr(13),''),chr(10),'') as rkrq
,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t.auth_uuid,chr(13),''),chr(10),'') as auth_uuid
,t.data_syn_time as data_syn_time
from iol.ilss_ghb_nsr_qsxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_nsr_qsxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes