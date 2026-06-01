: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_uxds_f_mbvg0004v2_f
CreateDate: 20250701
FileName:   ${iel_data_path}/uxds_f_mbvg0004v2.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,gendate
,replace(replace(t1.serialnumber,chr(13),''),chr(10),'') as serialnumber
,replace(replace(t1.sequenceid,chr(13),''),chr(10),'') as sequenceid
,replace(replace(t1.response_mobilestatus,chr(13),''),chr(10),'') as response_mobilestatus
,replace(replace(t1.response_operator,chr(13),''),chr(10),'') as response_operator
,replace(replace(t1.genmonth,chr(13),''),chr(10),'') as genmonth

from ${iol_schema}.uxds_f_mbvg0004v2 t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_f_mbvg0004v2.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
