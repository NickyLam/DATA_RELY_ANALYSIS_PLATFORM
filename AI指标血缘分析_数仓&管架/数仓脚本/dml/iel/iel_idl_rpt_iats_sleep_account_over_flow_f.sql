: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_iats_sleep_account_over_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_iats_sleep_account_over_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.flow_id,chr(13),''),chr(10),'') as flow_id
,replace(replace(t1.billing_account_id,chr(13),''),chr(10),'') as billing_account_id
,replace(replace(t1.id_no,chr(13),''),chr(10),'') as id_no
,replace(replace(t1.id_type,chr(13),''),chr(10),'') as id_type
,replace(replace(t1.account_name,chr(13),''),chr(10),'') as account_name
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.mobile_phone_no,chr(13),''),chr(10),'') as mobile_phone_no
,replace(replace(t1.e_account_no,chr(13),''),chr(10),'') as e_account_no
,t1.from_date as from_date
,t1.balance as balance
,replace(replace(t1.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t1.sleep_status,chr(13),''),chr(10),'') as sleep_status
,t1.sleep_from_date as sleep_from_date
,t1.sleep_from_end_date as sleep_from_end_date
,replace(replace(t1.reload_type,chr(13),''),chr(10),'') as reload_type
,replace(replace(t1.deduction_type,chr(13),''),chr(10),'') as deduction_type
,replace(replace(t1.over_status,chr(13),''),chr(10),'') as over_status
,t1.over_balance as over_balance
,t1.over_date as over_date
,replace(replace(t1.thru_status,chr(13),''),chr(10),'') as thru_status
,t1.thru_date as thru_date
,t1.thru_balance as thru_balance
,t1.last_updated_stamp as last_updated_stamp
,t1.last_updated_tx_stamp as last_updated_tx_stamp
,t1.created_stamp as created_stamp
,t1.created_tx_stamp as created_tx_stamp
,replace(replace(t1.account_branch_id,chr(13),''),chr(10),'') as account_branch_id
,replace(replace(t1.tran_status,chr(13),''),chr(10),'') as tran_status
,t1.tran_balance as tran_balance
,t1.tran_date as tran_date
,replace(replace(t1.reload_org_no,chr(13),''),chr(10),'') as reload_org_no
,replace(replace(t1.reload_teller_no,chr(13),''),chr(10),'') as reload_teller_no
,replace(replace(t1.reload_channel,chr(13),''),chr(10),'') as reload_channel
,t1.return_date as return_date
,replace(replace(t1.return_type,chr(13),''),chr(10),'') as return_type
,replace(replace(t1.return_tran_seq,chr(13),''),chr(10),'') as return_tran_seq
,replace(replace(t1.return_status,chr(13),''),chr(10),'') as return_status
 from iol.iats_sleep_account_over_flow T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_iats_sleep_account_over_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes