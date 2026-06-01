: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_noas_oa_form_item_data_f
CreateDate: 20230131
FileName:   ${iel_data_path}/noas_oa_form_item_data.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
        to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.form_item_data_id,chr(13),''),chr(10),'') as form_item_data_id
,replace(replace(t1.process_ins_id,chr(13),''),chr(10),'') as process_ins_id
,replace(replace(t1.item_key,chr(13),''),chr(10),'') as item_key
,replace(replace(t1.item_value,chr(13),''),chr(10),'') as item_value
,replace(replace(t1.form_def_id,chr(13),''),chr(10),'') as form_def_id
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
,replace(replace(t1.process_status,chr(13),''),chr(10),'') as process_status
,replace(replace(t1.data_year,chr(13),''),chr(10),'') as data_year
,start_dt
,end_dt

from ${iol_schema}.noas_oa_form_item_data t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/noas_oa_form_item_data.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
