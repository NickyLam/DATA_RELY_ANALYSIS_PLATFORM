: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fdps_balance_change_f
CreateDate: 20240829
FileName:   ${iel_data_path}/fdps_balance_change.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.balance_change_id,chr(13),''),chr(10),'') as balance_change_id
,replace(replace(t1.transaction_id,chr(13),''),chr(10),'') as transaction_id
,replace(replace(t1.order_id,chr(13),''),chr(10),'') as order_id
,order_time
,replace(replace(t1.parent_merchant_id,chr(13),''),chr(10),'') as parent_merchant_id
,replace(replace(t1.merchant_id,chr(13),''),chr(10),'') as merchant_id
,replace(replace(t1.customer_name,chr(13),''),chr(10),'') as customer_name
,replace(replace(t1.account_no,chr(13),''),chr(10),'') as account_no
,replace(replace(t1.vir_acc_type,chr(13),''),chr(10),'') as vir_acc_type
,replace(replace(t1.trans_mode,chr(13),''),chr(10),'') as trans_mode
,replace(replace(t1.tran_status,chr(13),''),chr(10),'') as tran_status
,replace(replace(t1.old_req_seq_no,chr(13),''),chr(10),'') as old_req_seq_no
,replace(replace(t1.old_req_account,chr(13),''),chr(10),'') as old_req_account
,replace(replace(t1.org_order_id,chr(13),''),chr(10),'') as org_order_id
,replace(replace(t1.payer_merchant_id,chr(13),''),chr(10),'') as payer_merchant_id
,replace(replace(t1.payer_account_no,chr(13),''),chr(10),'') as payer_account_no
,replace(replace(t1.payer_ac_name,chr(13),''),chr(10),'') as payer_ac_name
,replace(replace(t1.payer_ac_no,chr(13),''),chr(10),'') as payer_ac_no
,replace(replace(t1.payer_bank_name,chr(13),''),chr(10),'') as payer_bank_name
,replace(replace(t1.payer_bank_no,chr(13),''),chr(10),'') as payer_bank_no
,replace(replace(t1.other_bank_flag,chr(13),''),chr(10),'') as other_bank_flag
,replace(replace(t1.payee_merchant_id,chr(13),''),chr(10),'') as payee_merchant_id
,replace(replace(t1.payee_account_no,chr(13),''),chr(10),'') as payee_account_no
,replace(replace(t1.payee_ac_name,chr(13),''),chr(10),'') as payee_ac_name
,replace(replace(t1.payee_ac_no,chr(13),''),chr(10),'') as payee_ac_no
,replace(replace(t1.payee_bank_name,chr(13),''),chr(10),'') as payee_bank_name
,load_amount
,guarant_amount
,replace(replace(t1.settle_balance,chr(13),''),chr(10),'') as settle_balance
,replace(replace(t1.payee_bank_no,chr(13),''),chr(10),'') as payee_bank_no
,replace(replace(t1.pay_type,chr(13),''),chr(10),'') as pay_type
,replace(replace(t1.retreat_sign,chr(13),''),chr(10),'') as retreat_sign
,replace(replace(t1.retreat_seq_no,chr(13),''),chr(10),'') as retreat_seq_no
,replace(replace(t1.payer_channel,chr(13),''),chr(10),'') as payer_channel
,replace(replace(t1.payer_tool,chr(13),''),chr(10),'') as payer_tool
,fee_amount
,amount
,actual_balance
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.validate_code,chr(13),''),chr(10),'') as validate_code
,available_balance
,replace(replace(t1.resp_code,chr(13),''),chr(10),'') as resp_code
,replace(replace(t1.resp_msg,chr(13),''),chr(10),'') as resp_msg
,replace(replace(t1.clear_date,chr(13),''),chr(10),'') as clear_date
,replace(replace(t1.host_seq_no,chr(13),''),chr(10),'') as host_seq_no
,replace(replace(t1.host_date,chr(13),''),chr(10),'') as host_date
,replace(replace(t1.third_batch_id,chr(13),''),chr(10),'') as third_batch_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.note,chr(13),''),chr(10),'') as note
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.summary,chr(13),''),chr(10),'') as summary
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
,replace(replace(t1.receipt_num,chr(13),''),chr(10),'') as receipt_num

from ${iol_schema}.fdps_balance_change t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fdps_balance_change.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
