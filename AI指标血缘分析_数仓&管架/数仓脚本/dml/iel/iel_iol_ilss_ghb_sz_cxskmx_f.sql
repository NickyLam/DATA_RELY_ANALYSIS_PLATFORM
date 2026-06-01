: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_sz_cxskmx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_sz_cxskmx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.skze_id as skze_id
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,t.skje as skje
,replace(replace(t.szdm,chr(13),''),chr(10),'') as szdm
,t.create_time as create_time
,t.update_time as update_time
from iol.ilss_ghb_sz_cxskmx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_sz_cxskmx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes