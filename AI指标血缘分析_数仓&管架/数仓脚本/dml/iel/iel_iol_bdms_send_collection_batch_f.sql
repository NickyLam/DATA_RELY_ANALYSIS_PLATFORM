: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_send_collection_batch_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_send_collection_batch.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.branch_id as branch_id
,replace(replace(t.draft_attr,chr(13),''),chr(10),'') as draft_attr
,replace(replace(t.draft_type,chr(13),''),chr(10),'') as draft_type
,replace(replace(t.collection_date,chr(13),''),chr(10),'') as collection_date
,t.ubank_id as ubank_id
,replace(replace(t.ems_no,chr(13),''),chr(10),'') as ems_no
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.sttlm_mk,chr(13),''),chr(10),'') as sttlm_mk
,replace(replace(t.account_status,chr(13),''),chr(10),'') as account_status
,replace(replace(t.audit_status,chr(13),''),chr(10),'') as audit_status
,replace(replace(t.appno,chr(13),''),chr(10),'') as appno
,t.operator_id as operator_id
,replace(replace(t.txn_date,chr(13),''),chr(10),'') as txn_date
,t.last_upd_oper_id as last_upd_oper_id
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.src_type,chr(13),''),chr(10),'') as src_type
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_send_collection_batch t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_send_collection_batch.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes