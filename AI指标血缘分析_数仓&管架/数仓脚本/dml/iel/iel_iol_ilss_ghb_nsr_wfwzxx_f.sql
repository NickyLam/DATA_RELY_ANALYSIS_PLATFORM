: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_nsr_wfwzxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_nsr_wfwzxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.sswfxwdjuuid,chr(13),''),chr(10),'') as sswfxwdjuuid
,replace(replace(t.djxh,chr(13),''),chr(10),'') as djxh
,replace(replace(t.djrq,chr(13),''),chr(10),'') as djrq
,replace(replace(t.wfwzsd_dm,chr(13),''),chr(10),'') as wfwzsd_dm
,replace(replace(t.wfwzsd_mc,chr(13),''),chr(10),'') as wfwzsd_mc
,replace(replace(t.wfwzlx_dm,chr(13),''),chr(10),'') as wfwzlx_dm
,replace(replace(t.wfwzlx_mc,chr(13),''),chr(10),'') as wfwzlx_mc
,replace(replace(t.wfwzzt_dm,chr(13),''),chr(10),'') as wfwzzt_dm
,replace(replace(t.wfwzzt_mc,chr(13),''),chr(10),'') as wfwzzt_mc
,replace(replace(t.sssqq,chr(13),''),chr(10),'') as sssqq
,replace(replace(t.sssqz,chr(13),''),chr(10),'') as sssqz
,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t.auth_uuid,chr(13),''),chr(10),'') as auth_uuid
,t.data_syn_time as data_syn_time
,replace(replace(t.wfwzss,chr(13),''),chr(10),'') as wfwzss
from iol.ilss_ghb_nsr_wfwzxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_nsr_wfwzxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes