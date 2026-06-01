: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_upps_upps_action_trans_i
CreateDate: 20180529
FileName:   ${iel_data_path}/upps_upps_action_trans.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.action_trans_id,chr(13),''),chr(10),'') as action_trans_id
,replace(replace(t.payment_method_type_id,chr(13),''),chr(10),'') as payment_method_type_id
,replace(replace(t.payment_action,chr(13),''),chr(10),'') as payment_action
,replace(replace(t.tran_seq_no,chr(13),''),chr(10),'') as tran_seq_no
,replace(replace(t.global_seq_no,chr(13),''),chr(10),'') as global_seq_no
,replace(replace(t.consumer_id,chr(13),''),chr(10),'') as consumer_id
,replace(replace(t.source_sys_id,chr(13),''),chr(10),'') as source_sys_id
,replace(replace(t.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t.branch_id,chr(13),''),chr(10),'') as branch_id
,replace(replace(t.tran_date,chr(13),''),chr(10),'') as tran_date
,replace(replace(t.tran_teller_no,chr(13),''),chr(10),'') as tran_teller_no
,replace(replace(t.authr_teller_no,chr(13),''),chr(10),'') as authr_teller_no
,replace(replace(t.medium_date,chr(13),''),chr(10),'') as medium_date
,replace(replace(t.checking_code,chr(13),''),chr(10),'') as checking_code
,replace(replace(t.currency_uom_id,chr(13),''),chr(10),'') as currency_uom_id
,replace(replace(t.amount,chr(13),''),chr(10),'') as amount
,replace(replace(t.account_number,chr(13),''),chr(10),'') as account_number
,replace(replace(t.account_name,chr(13),''),chr(10),'') as account_name
,replace(replace(t.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t.opp_account_number,chr(13),''),chr(10),'') as opp_account_number
,replace(replace(t.opp_account_name,chr(13),''),chr(10),'') as opp_account_name
,replace(replace(t.trans_code,chr(13),''),chr(10),'') as trans_code
,replace(replace(t.public_note,chr(13),''),chr(10),'') as public_note
,replace(replace(t.ret_code,chr(13),''),chr(10),'') as ret_code
,replace(replace(t.ret_message,chr(13),''),chr(10),'') as ret_message
,t.req_ext_map as req_ext_map
,t.rsp_ext_map as rsp_ext_map
,replace(replace(t.orig_action_trans_id,chr(13),''),chr(10),'') as orig_action_trans_id
,replace(replace(t.need_sync,chr(13),''),chr(10),'') as need_sync
,replace(replace(t.need_rollback,chr(13),''),chr(10),'') as need_rollback
,replace(replace(t.need_posting,chr(13),''),chr(10),'') as need_posting
,replace(replace(t.is_async,chr(13),''),chr(10),'') as is_async
,replace(replace(t.payment_date,chr(13),''),chr(10),'') as payment_date
,replace(replace(t.back_seq_no,chr(13),''),chr(10),'') as back_seq_no
,replace(replace(t.back_date,chr(13),''),chr(10),'') as back_date
,t.seq_no as seq_no
,replace(replace(t.payment_order_id,chr(13),''),chr(10),'') as payment_order_id
,replace(replace(t.batch_order_id,chr(13),''),chr(10),'') as batch_order_id
,replace(replace(t.rollback_order_id,chr(13),''),chr(10),'') as rollback_order_id
,replace(replace(t.row_no,chr(13),''),chr(10),'') as row_no
,replace(replace(t.callback_service,chr(13),''),chr(10),'') as callback_service
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,replace(replace(t.timeout_flag,chr(13),''),chr(10),'') as timeout_flag
,replace(replace(t.depend_row_no,chr(13),''),chr(10),'') as depend_row_no
,replace(replace(t.settle_account_number,chr(13),''),chr(10),'') as settle_account_number
,replace(replace(t.settle_account_name,chr(13),''),chr(10),'') as settle_account_name
,replace(replace(t.batch_order_item_id,chr(13),''),chr(10),'') as batch_order_item_id
from iol.upps_upps_action_trans t
where to_char(created_tx_stamp,'yyyymmdd')='${batch_date}';
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/upps_upps_action_trans.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes