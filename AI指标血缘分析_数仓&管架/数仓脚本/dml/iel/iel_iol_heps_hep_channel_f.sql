: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_heps_hep_channel_f
CreateDate: 20180529
FileName:   ${iel_data_path}/heps_hep_channel.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.channel_id,chr(13),''),chr(10),'') as channel_id
,replace(replace(t.channel_name,chr(13),''),chr(10),'') as channel_name
,replace(replace(t.channel_phone,chr(13),''),chr(10),'') as channel_phone
,replace(replace(t.channel_status,chr(13),''),chr(10),'') as channel_status
,t.create_time as create_time
,t.update_time as update_time
,replace(replace(t.src,chr(13),''),chr(10),'') as src
,replace(replace(t.isinit,chr(13),''),chr(10),'') as isinit
,replace(replace(t.url,chr(13),''),chr(10),'') as url
from iol.heps_hep_channel t
where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/heps_hep_channel.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes