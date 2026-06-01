: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_nsr_fxfkxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_nsr_fxfkxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.sfydkye,chr(13),''),chr(10),'') as sfydkye
,t.dkyhsl as dkyhsl
,t.cxxh as cxxh
,replace(replace(t.cxsj,chr(13),''),chr(10),'') as cxsj
,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t.auth_uuid,chr(13),''),chr(10),'') as auth_uuid
from iol.ilss_ghb_nsr_fxfkxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_nsr_fxfkxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes