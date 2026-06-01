: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_noas_oa_form_attach_proc_party_refe_f
CreateDate: 20180529
FileName:   ${iel_data_path}/noas_oa_form_attach_proc_party_refe.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.reference_id,chr(13),''),chr(10),'') as reference_id
,replace(replace(t.attachment_id,chr(13),''),chr(10),'') as attachment_id
,replace(replace(t.process_ins_id,chr(13),''),chr(10),'') as process_ins_id
,replace(replace(t.form_def_id,chr(13),''),chr(10),'') as form_def_id
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.noas_oa_form_attach_proc_party_refe t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/noas_oa_form_attach_proc_party_refe.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes