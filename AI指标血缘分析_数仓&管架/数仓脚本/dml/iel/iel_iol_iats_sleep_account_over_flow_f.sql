: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_iats_sleep_account_over_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/iats_sleep_account_over_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.flow_id,chr(13),''),chr(10),'') as flow_id
,replace(replace(t.billing_account_id,chr(13),''),chr(10),'') as billing_account_id
,replace(replace(t.id_no,chr(13),''),chr(10),'') as id_no
,replace(replace(t.account_name,chr(13),''),chr(10),'') as account_name
,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t.mobile_phone_no,chr(13),''),chr(10),'') as mobile_phone_no
,replace(replace(t.e_account_no,chr(13),''),chr(10),'') as e_account_no
,t.from_date as from_date
,t.balance as balance
,replace(replace(t.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t.sleep_status,chr(13),''),chr(10),'') as sleep_status
,t.sleep_from_date as sleep_from_date
,t.sleep_from_end_date as sleep_from_end_date
,replace(replace(t.reload_type,chr(13),''),chr(10),'') as reload_type
,replace(replace(t.deduction_type,chr(13),''),chr(10),'') as deduction_type
,replace(replace(t.over_status,chr(13),''),chr(10),'') as over_status
,t.over_balance as over_balance
,t.over_date as over_date
,replace(replace(t.thru_status,chr(13),''),chr(10),'') as thru_status
,t.thru_date as thru_date
,t.thru_balance as thru_balance
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,replace(replace(t.id_type,chr(13),''),chr(10),'') as id_type
,replace(replace(t.account_branch_id,chr(13),''),chr(10),'') as account_branch_id
,replace(replace(t.tran_status,chr(13),''),chr(10),'') as tran_status
,t.tran_balance as tran_balance
,t.tran_date as tran_date
,replace(replace(t.reload_org_no,chr(13),''),chr(10),'') as reload_org_no
,replace(replace(t.reload_teller_no,chr(13),''),chr(10),'') as reload_teller_no
,replace(replace(t.reload_channel,chr(13),''),chr(10),'') as reload_channel
,t.return_date as return_date
,replace(replace(t.return_type,chr(13),''),chr(10),'') as return_type
,replace(replace(t.return_tran_seq,chr(13),''),chr(10),'') as return_tran_seq
,replace(replace(t.return_status,chr(13),''),chr(10),'') as return_status
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.iats_sleep_account_over_flow t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iats_sleep_account_over_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes