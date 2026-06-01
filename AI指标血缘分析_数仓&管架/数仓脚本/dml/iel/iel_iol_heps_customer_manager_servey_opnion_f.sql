: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_heps_customer_manager_servey_opnion_f
CreateDate: 20180529
FileName:   ${iel_data_path}/heps_customer_manager_servey_opnion.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.customer_id as customer_id
,replace(replace(t.flow_id,chr(13),''),chr(10),'') as flow_id
,t.status as status
,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
,t.customer_manager_id as customer_manager_id
,t.question_id as question_id
,replace(replace(t.question,chr(13),''),chr(10),'') as question
,replace(replace(t.result,chr(13),''),chr(10),'') as result
from iol.heps_customer_manager_servey_opnion t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/heps_customer_manager_servey_opnion.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes