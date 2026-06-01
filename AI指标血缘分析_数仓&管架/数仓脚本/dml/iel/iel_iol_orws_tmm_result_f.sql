: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orws_tmm_result_f
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_tmm_result.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.id as id 
,t1.commissioning_id as commissioning_id 
,t1.biz_date as biz_date 
,t1.biz_organ_id as biz_organ_id 
,replace(replace(t1.biz_emp_no,chr(13),''),chr(10),'') as biz_emp_no 
,replace(replace(t1.img_info,chr(13),''),chr(10),'') as img_info 
,t1.found_date as found_date 
,t1.handle_date as handle_date 
,t1.handle_user_id as handle_user_id 
,t1.handle_position_id as handle_position_id 
,t1.handle_organ_id as handle_organ_id 
,t1.handle_result as handle_result 
,replace(replace(t1.biz_info,chr(13),''),chr(10),'') as biz_info 
,replace(replace(t1.cancel_reason,chr(13),''),chr(10),'') as cancel_reason 
,t1.problem_id as problem_id 
,t1.problem_state as problem_state 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.orws_tmm_result t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_tmm_result.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes