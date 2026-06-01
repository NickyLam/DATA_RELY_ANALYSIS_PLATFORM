: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_sz_wfwzxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_sz_wfwzxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.shxydm,chr(13),''),chr(10),'') as shxydm
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.djrq,chr(13),''),chr(10),'') as djrq
,replace(replace(t.wfss,chr(13),''),chr(10),'') as wfss
,replace(replace(t.sswfsdmc,chr(13),''),chr(10),'') as sswfsdmc
,replace(replace(t.sswflxmc,chr(13),''),chr(10),'') as sswflxmc
,replace(replace(t.sswfxwclztmc,chr(13),''),chr(10),'') as sswfxwclztmc
,replace(replace(t.ssqjq_1,chr(13),''),chr(10),'') as ssqjq_1
,replace(replace(t.ssqjz_1,chr(13),''),chr(10),'') as ssqjz_1
,replace(replace(t.wfxwmc,chr(13),''),chr(10),'') as wfxwmc
,replace(replace(t.ajly,chr(13),''),chr(10),'') as ajly
,replace(replace(t.jcajbz,chr(13),''),chr(10),'') as jcajbz
,replace(replace(t.sfsbfwf,chr(13),''),chr(10),'') as sfsbfwf
,t.create_time as create_time
,t.update_time as update_time
from iol.ilss_ghb_sz_wfwzxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_sz_wfwzxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes