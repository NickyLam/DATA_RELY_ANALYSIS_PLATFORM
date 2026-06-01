: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_epcs_upbs_biz_trans_f
CreateDate: 20180529
FileName:   ${iel_data_path}/epcs_upbs_biz_trans.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.biz_trans_id,chr(13),''),chr(10),'') as biz_trans_id
,replace(replace(t.biz_type,chr(13),''),chr(10),'') as biz_type
,replace(replace(t.biz_trans_date,chr(13),''),chr(10),'') as biz_trans_date
,replace(replace(t.tran_seq_no,chr(13),''),chr(10),'') as tran_seq_no
,replace(replace(t.global_seq_no,chr(13),''),chr(10),'') as global_seq_no
,replace(replace(t.consumer_id,chr(13),''),chr(10),'') as consumer_id
,replace(replace(t.source_sys_id,chr(13),''),chr(10),'') as source_sys_id
,replace(replace(t.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t.branch_id,chr(13),''),chr(10),'') as branch_id
,replace(replace(t.tran_teller_no,chr(13),''),chr(10),'') as tran_teller_no
,replace(replace(t.trans_time,chr(13),''),chr(10),'') as trans_time
,replace(replace(t.authr_teller_no,chr(13),''),chr(10),'') as authr_teller_no
,replace(replace(t.currency_uom_id,chr(13),''),chr(10),'') as currency_uom_id
,replace(replace(t.amount,chr(13),''),chr(10),'') as amount
,replace(replace(t.payment_method_type_id,chr(13),''),chr(10),'') as payment_method_type_id
,replace(replace(t.account_number,chr(13),''),chr(10),'') as account_number
,replace(replace(t.account_name,chr(13),''),chr(10),'') as account_name
,replace(replace(t.opp_payment_method_type_id,chr(13),''),chr(10),'') as opp_payment_method_type_id
,replace(replace(t.opp_account_number,chr(13),''),chr(10),'') as opp_account_number
,replace(replace(t.opp_account_name,chr(13),''),chr(10),'') as opp_account_name
,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t.mobile_phone,chr(13),''),chr(10),'') as mobile_phone
,replace(replace(t.agreement_id,chr(13),''),chr(10),'') as agreement_id
,replace(replace(t.payment_order_id,chr(13),''),chr(10),'') as payment_order_id
,replace(replace(t.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t.ret_code,chr(13),''),chr(10),'') as ret_code
,replace(replace(t.ret_message,chr(13),''),chr(10),'') as ret_message
,replace(replace(t.trx_id,chr(13),''),chr(10),'') as trx_id
,replace(replace(t.r_p_flg,chr(13),''),chr(10),'') as r_p_flg
,replace(replace(t.msg_tp,chr(13),''),chr(10),'') as msg_tp
,replace(replace(t.ori_trx_id,chr(13),''),chr(10),'') as ori_trx_id
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,replace(replace(t.pyer_acct_issr_id,chr(13),''),chr(10),'') as pyer_acct_issr_id
,replace(replace(t.pyee_acct_issr_id,chr(13),''),chr(10),'') as pyee_acct_issr_id
,replace(replace(t.left_refund_amout,chr(13),''),chr(10),'') as left_refund_amout
,replace(replace(t.host_date,chr(13),''),chr(10),'') as host_date
,replace(replace(t.host_seq_no,chr(13),''),chr(10),'') as host_seq_no
,replace(replace(t.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t.payment_seq_no,chr(13),''),chr(10),'') as payment_seq_no
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.epcs_upbs_biz_trans t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/epcs_upbs_biz_trans.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes