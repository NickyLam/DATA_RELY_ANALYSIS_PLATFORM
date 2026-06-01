: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_noas_oa_form_data_attachment_f
CreateDate: 20180529
FileName:   ${iel_data_path}/noas_oa_form_data_attachment.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.attachment_id,chr(13),''),chr(10),'') as attachment_id
,replace(replace(t.attach_name,chr(13),''),chr(10),'') as attach_name
,replace(replace(t.attach_path,chr(13),''),chr(10),'') as attach_path
,replace(replace(t.attach_order,chr(13),''),chr(10),'') as attach_order
,replace(replace(t.show_attach_name,chr(13),''),chr(10),'') as show_attach_name
,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t.attachment_type,chr(13),''),chr(10),'') as attachment_type
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,replace(replace(t.content_type_id,chr(13),''),chr(10),'') as content_type_id
,replace(replace(t.is_cheack_stlye,chr(13),''),chr(10),'') as is_cheack_stlye
,replace(replace(t.upper_level_id,chr(13),''),chr(10),'') as upper_level_id
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.noas_oa_form_data_attachment t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/noas_oa_form_data_attachment.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes