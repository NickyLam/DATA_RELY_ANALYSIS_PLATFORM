: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_eg_interface_name_f
CreateDate: 20230302
FileName:   ${iel_data_path}/ncbs_eg_interface_name.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.online_message_code,chr(13),''),chr(10),'') as online_message_code
,replace(replace(t1.online_message_name,chr(13),''),chr(10),'') as online_message_name
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.company,chr(13),''),chr(10),'') as company

from ${iol_schema}.ncbs_eg_interface_name t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_eg_interface_name.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
