: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_glms_gl_account_hierarchies_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/glms_gl_account_hierarchies_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(ledger_id,chr(10),''),chr(13),'') as ledger_id
,replace(replace(summary_code_combination_id,chr(10),''),chr(13),'') as summary_code_combination_id
,replace(replace(detail_code_combination_id,chr(10),''),chr(13),'') as detail_code_combination_id
,replace(replace(template_id,chr(10),''),chr(13),'') as template_id
,replace(replace(last_updated_by,chr(10),''),chr(13),'') as last_updated_by
,replace(replace(last_update_date,chr(10),''),chr(13),'') as last_update_date
,replace(replace(ordering_value,chr(10),''),chr(13),'') as ordering_value
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.glms_gl_account_hierarchies
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/glms_gl_account_hierarchies_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes