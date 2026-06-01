: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_bdms_bms_accept_unused_restitution_f
CreateDate: 20240103
FileName:   ${iel_data_path}/bdms_bms_accept_unused_restitution.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.accept_id,chr(13),''),chr(10),'') as accept_id
,replace(replace(t1.draft_id,chr(13),''),chr(10),'') as draft_id
,replace(replace(t1.branch_no,chr(13),''),chr(10),'') as branch_no
,replace(replace(t1.withdraw_reason,chr(13),''),chr(10),'') as withdraw_reason
,replace(replace(t1.withdraw_date,chr(13),''),chr(10),'') as withdraw_date
,replace(replace(t1.operator_no,chr(13),''),chr(10),'') as operator_no
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.account_status,chr(13),''),chr(10),'') as account_status
,replace(replace(t1.reserve1,chr(13),''),chr(10),'') as reserve1
,replace(replace(t1.reserve2,chr(13),''),chr(10),'') as reserve2
,replace(replace(t1.last_operator_no,chr(13),''),chr(10),'') as last_operator_no
,last_txn_date
,replace(replace(t1.txn_date,chr(13),''),chr(10),'') as txn_date

from ${iol_schema}.bdms_bms_accept_unused_restitution t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_bms_accept_unused_restitution.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
