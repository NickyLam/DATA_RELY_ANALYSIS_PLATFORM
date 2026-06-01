: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_umss_icc_msg_hdws_stat_f
CreateDate: 20241011
FileName:   ${iel_data_path}/umss_icc_msg_hdws_stat.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,id
,pack_id
,replace(replace(t1.batch_name,chr(13),''),chr(10),'') as batch_name
,replace(replace(t1.terminal_id,chr(13),''),chr(10),'') as terminal_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,state
,replace(replace(t1.origin_result,chr(13),''),chr(10),'') as origin_result
,result
,short_url
,click_url
,create_time

from ${iol_schema}.umss_icc_msg_hdws_stat t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/umss_icc_msg_hdws_stat.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
