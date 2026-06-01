: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_csrs_reps_ivr_out_info_i
CreateDate: 20220819
FileName:   ${iel_data_path}/csrs_reps_ivr_out_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select    
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.call_date as call_date
    ,replace(replace(t.start_time,chr(13),''),chr(10),'') as start_time
    ,replace(replace(t.end_time,chr(13),''),chr(10),'') as end_time
    ,t.duration as duration
    ,t.time_wait_answer as time_wait_answer
    ,replace(replace(t.caller_id_number,chr(13),''),chr(10),'') as caller_id_number
    ,replace(replace(t.outgateway,chr(13),''),chr(10),'') as outgateway
    ,replace(replace(t.uuid,chr(13),''),chr(10),'') as uuid
    ,replace(replace(t.ivr_route_point,chr(13),''),chr(10),'') as ivr_route_point
    ,replace(replace(t.outbound_result,chr(13),''),chr(10),'') as outbound_result
    ,replace(replace(t.domain,chr(13),''),chr(10),'') as domain
    ,replace(replace(t.vdn_id,chr(13),''),chr(10),'') as vdn_id
from iol.csrs_reps_ivr_out_info t
where to_char(call_date,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/csrs_reps_ivr_out_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes