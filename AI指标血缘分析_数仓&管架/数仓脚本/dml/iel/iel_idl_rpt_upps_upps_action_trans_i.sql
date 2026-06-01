: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_upps_upps_action_trans_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_upps_upps_action_trans.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.action_trans_id,chr(13),''),chr(10),'') as action_trans_id
,replace(replace(t1.payment_method_type_id,chr(13),''),chr(10),'') as payment_method_type_id
,replace(replace(t1.payment_action,chr(13),''),chr(10),'') as payment_action
,replace(replace(t1.tran_seq_no,chr(13),''),chr(10),'') as tran_seq_no
,replace(replace(t1.global_seq_no,chr(13),''),chr(10),'') as global_seq_no
,replace(replace(t1.consumer_id,chr(13),''),chr(10),'') as consumer_id
,replace(replace(t1.source_sys_id,chr(13),''),chr(10),'') as source_sys_id
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t1.branch_id,chr(13),''),chr(10),'') as branch_id
,replace(replace(t1.tran_date,chr(13),''),chr(10),'') as tran_date
,replace(replace(t1.tran_teller_no,chr(13),''),chr(10),'') as tran_teller_no
,replace(replace(t1.authr_teller_no,chr(13),''),chr(10),'') as authr_teller_no
,replace(replace(t1.medium_date,chr(13),''),chr(10),'') as medium_date
,replace(replace(t1.checking_code,chr(13),''),chr(10),'') as checking_code
,replace(replace(t1.currency_uom_id,chr(13),''),chr(10),'') as currency_uom_id
,replace(replace(t1.amount,chr(13),''),chr(10),'') as amount
,replace(replace(t1.account_number,chr(13),''),chr(10),'') as account_number
,replace(replace(t1.account_name,chr(13),''),chr(10),'') as account_name
,replace(replace(t1.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t1.opp_account_number,chr(13),''),chr(10),'') as opp_account_number
,replace(replace(t1.opp_account_name,chr(13),''),chr(10),'') as opp_account_name
,replace(replace(t1.trans_code,chr(13),''),chr(10),'') as trans_code
,replace(replace(t1.public_note,chr(13),''),chr(10),'') as public_note
,replace(replace(t1.ret_code,chr(13),''),chr(10),'') as ret_code
,replace(replace(t1.ret_message,chr(13),''),chr(10),'') as ret_message
,replace(replace(t1.orig_action_trans_id,chr(13),''),chr(10),'') as orig_action_trans_id
,replace(replace(t1.need_sync,chr(13),''),chr(10),'') as need_sync
,replace(replace(t1.need_rollback,chr(13),''),chr(10),'') as need_rollback
,replace(replace(t1.need_posting,chr(13),''),chr(10),'') as need_posting
,replace(replace(t1.is_async,chr(13),''),chr(10),'') as is_async
,replace(replace(t1.payment_date,chr(13),''),chr(10),'') as payment_date
,replace(replace(t1.back_seq_no,chr(13),''),chr(10),'') as back_seq_no
,replace(replace(t1.back_date,chr(13),''),chr(10),'') as back_date
,t1.seq_no as seq_no
,replace(replace(t1.payment_order_id,chr(13),''),chr(10),'') as payment_order_id
,replace(replace(t1.batch_order_id,chr(13),''),chr(10),'') as batch_order_id
,replace(replace(t1.rollback_order_id,chr(13),''),chr(10),'') as rollback_order_id
,replace(replace(t1.row_no,chr(13),''),chr(10),'') as row_no
,replace(replace(t1.callback_service,chr(13),''),chr(10),'') as callback_service
,t1.last_updated_stamp as last_updated_stamp
,t1.last_updated_tx_stamp as last_updated_tx_stamp
,t1.created_stamp as created_stamp
,t1.created_tx_stamp as created_tx_stamp
,'' as EXTERNAL_ID
,replace(replace(t1.timeout_flag,chr(13),''),chr(10),'') as timeout_flag
,replace(replace(t1.settle_account_number,chr(13),''),chr(10),'') as settle_account_number
,replace(replace(t1.settle_account_name,chr(13),''),chr(10),'') as settle_account_name
,replace(replace(t1.batch_order_item_id,chr(13),''),chr(10),'') as batch_order_item_id
,replace(replace(t1.depend_row_no,chr(13),''),chr(10),'') as depend_row_no
from ${iol_schema}.upps_upps_action_trans t1
where to_char(created_tx_stamp,'yyyymmdd')='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_upps_upps_action_trans.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes