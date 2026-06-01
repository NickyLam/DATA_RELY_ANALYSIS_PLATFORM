: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_sz_bgxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_sz_bgxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.shxydm,chr(13),''),chr(10),'') as shxydm
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.nsrmc,chr(13),''),chr(10),'') as nsrmc
,replace(replace(t.bgrq,chr(13),''),chr(10),'') as bgrq
,replace(replace(t.bgxmmc,chr(13),''),chr(10),'') as bgxmmc
,replace(replace(t.bgqnr,chr(13),''),chr(10),'') as bgqnr
,replace(replace(t.bgqnrmc,chr(13),''),chr(10),'') as bgqnrmc
,replace(replace(t.bghnr,chr(13),''),chr(10),'') as bghnr
,replace(replace(t.bghnrmc,chr(13),''),chr(10),'') as bghnrmc
,t.create_time as create_time
,t.update_time as update_time
from iol.ilss_ghb_sz_bgxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_sz_bgxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes