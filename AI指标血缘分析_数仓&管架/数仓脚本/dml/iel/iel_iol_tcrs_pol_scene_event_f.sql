: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tcrs_pol_scene_event_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tcrs_pol_scene_event.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.scene_code,chr(13),''),chr(10),'') as scene_code
,replace(replace(t.event_code,chr(13),''),chr(10),'') as event_code
from iol.tcrs_pol_scene_event t
 where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tcrs_pol_scene_event.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes