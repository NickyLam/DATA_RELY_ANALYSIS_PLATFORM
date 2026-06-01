: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iats_sleep_account_over_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iats_sleep_account_over_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.flow_id
,t1.billing_account_id
,t1.id_no
,t1.id_type
,t1.account_name
,t1.party_id
,t1.mobile_phone_no
,t1.e_account_no
,t1.from_date
,t1.balance
,t1.status_id
,t1.sleep_status
,t1.sleep_from_date
,t1.sleep_from_end_date
,t1.reload_type
,t1.deduction_type
,t1.over_status
,t1.over_balance
,t1.over_date
,t1.thru_status
,t1.thru_date
,t1.thru_balance
,t1.last_updated_stamp
,t1.last_updated_tx_stamp
,t1.created_stamp
,t1.created_tx_stamp
,t1.account_branch_id
,t1.tran_status
,t1.tran_balance
,t1.tran_date
,t1.reload_org_no
,t1.reload_teller_no
,t1.reload_channel
,t1.return_date
,t1.return_type
,t1.return_tran_seq
,t1.return_status
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_iats_sleep_account_over_flow t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iats_sleep_account_over_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes