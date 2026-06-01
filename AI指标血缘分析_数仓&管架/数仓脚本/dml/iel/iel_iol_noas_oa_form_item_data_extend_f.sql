: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_noas_oa_form_item_data_extend_f
CreateDate: 20240131
FileName:   ${iel_data_path}/noas_oa_form_item_data_extend.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.extend_id,chr(13),''),chr(10),'') as extend_id
,replace(replace(t1.item_content,chr(13),''),chr(10),'') as item_content
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.process_ins_id,chr(13),''),chr(10),'') as process_ins_id
,replace(replace(t1.flow_type_id,chr(13),''),chr(10),'') as flow_type_id
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
,replace(replace(t1.item_key,chr(13),''),chr(10),'') as item_key

from ${iol_schema}.noas_oa_form_item_data_extend t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/noas_oa_form_item_data_extend.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
