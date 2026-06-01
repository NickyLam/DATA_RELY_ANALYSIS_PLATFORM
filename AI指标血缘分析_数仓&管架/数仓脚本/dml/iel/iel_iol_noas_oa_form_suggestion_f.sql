: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_noas_oa_form_suggestion_f
CreateDate: 20240802
FileName:   ${iel_data_path}/noas_oa_form_suggestion.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.suggestion_id,chr(13),''),chr(10),'') as suggestion_id
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.node_id,chr(13),''),chr(10),'') as node_id
,replace(replace(t1.organ_code,chr(13),''),chr(10),'') as organ_code
,replace(replace(t1.process_ins_id,chr(13),''),chr(10),'') as process_ins_id
,suggestion_time
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
,replace(replace(t1.party_id_dummy,chr(13),''),chr(10),'') as party_id_dummy
,replace(replace(t1.organ_code_dummy,chr(13),''),chr(10),'') as organ_code_dummy
,replace(replace(t1.assignee_role_id,chr(13),''),chr(10),'') as assignee_role_id
,replace(replace(t1.suggestion,chr(13),''),chr(10),'') as suggestion
,replace(replace(t1.act_ru_task_id,chr(13),''),chr(10),'') as act_ru_task_id

from ${iol_schema}.noas_oa_form_suggestion t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/noas_oa_form_suggestion.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
