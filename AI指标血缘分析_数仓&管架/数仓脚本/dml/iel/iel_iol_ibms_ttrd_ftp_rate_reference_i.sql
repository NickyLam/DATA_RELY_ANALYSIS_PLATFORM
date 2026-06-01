: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_ftp_rate_reference_i
CreateDate: 20250701
FileName:   ${iel_data_path}/ibms_ttrd_ftp_rate_reference.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.value_date,chr(13),''),chr(10),'') as value_date
,rate_1d
,rate_7d
,rate_14d
,rate_1m
,rate_3m
,rate_6m
,rate_9m
,rate_1y
,rate_avg
,rate_avg_d
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time

from ${iol_schema}.ibms_ttrd_ftp_rate_reference t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_ftp_rate_reference.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
