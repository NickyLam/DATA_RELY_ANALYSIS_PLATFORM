: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_heps_hep_house_detail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/heps_hep_house_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.flow_id,chr(13),''),chr(10),'') as flow_id
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,t.question_id as question_id
,replace(replace(t.question,chr(13),''),chr(10),'') as question
,replace(replace(t.answer,chr(13),''),chr(10),'') as answer
,t.customer_manager_id as customer_manager_id
from iol.heps_hep_house_detail t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/heps_hep_house_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes