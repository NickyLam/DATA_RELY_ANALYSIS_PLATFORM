: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tbps_cpr_transcode_inf_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tbps_cpr_transcode_inf.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.cti_transcode,chr(13),''),chr(10),'') as cti_transcode
    ,replace(replace(t.cti_transname,chr(13),''),chr(10),'') as cti_transname
    ,replace(replace(t.cti_transflag,chr(13),''),chr(10),'') as cti_transflag
    ,replace(replace(t.cti_menuid,chr(13),''),chr(10),'') as cti_menuid
    ,replace(replace(t.cti_channel,chr(13),''),chr(10),'') as cti_channel
    ,replace(replace(t.cti_menuname,chr(13),''),chr(10),'') as cti_menuname
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.tbps_cpr_transcode_inf t
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tbps_cpr_transcode_inf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes