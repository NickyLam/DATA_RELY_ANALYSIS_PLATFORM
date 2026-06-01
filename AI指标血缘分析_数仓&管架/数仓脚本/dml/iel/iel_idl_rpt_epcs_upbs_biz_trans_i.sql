: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_epcs_upbs_biz_trans_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_epcs_upbs_biz_trans.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.biz_trans_id,chr(13),''),chr(10),'') as biz_trans_id
,replace(replace(t1.biz_type,chr(13),''),chr(10),'') as biz_type
,replace(replace(t1.biz_trans_date,chr(13),''),chr(10),'') as biz_trans_date
,replace(replace(t1.tran_seq_no,chr(13),''),chr(10),'') as tran_seq_no
,replace(replace(t1.global_seq_no,chr(13),''),chr(10),'') as global_seq_no
,replace(replace(t1.consumer_id,chr(13),''),chr(10),'') as consumer_id
,replace(replace(t1.source_sys_id,chr(13),''),chr(10),'') as source_sys_id
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t1.branch_id,chr(13),''),chr(10),'') as branch_id
,replace(replace(t1.tran_teller_no,chr(13),''),chr(10),'') as tran_teller_no
,replace(replace(t1.trans_time,chr(13),''),chr(10),'') as trans_time
,replace(replace(t1.authr_teller_no,chr(13),''),chr(10),'') as authr_teller_no
,replace(replace(t1.currency_uom_id,chr(13),''),chr(10),'') as currency_uom_id
,replace(replace(t1.amount,chr(13),''),chr(10),'') as amount
,replace(replace(t1.payment_method_type_id,chr(13),''),chr(10),'') as payment_method_type_id
,replace(replace(t1.account_number,chr(13),''),chr(10),'') as account_number
,replace(replace(t1.account_name,chr(13),''),chr(10),'') as account_name
,replace(replace(t1.opp_payment_method_type_id,chr(13),''),chr(10),'') as opp_payment_method_type_id
,replace(replace(t1.opp_account_number,chr(13),''),chr(10),'') as opp_account_number
,replace(replace(t1.opp_account_name,chr(13),''),chr(10),'') as opp_account_name
,replace(replace(t1.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.mobile_phone,chr(13),''),chr(10),'') as mobile_phone
,replace(replace(t1.agreement_id,chr(13),''),chr(10),'') as agreement_id
,replace(replace(t1.payment_order_id,chr(13),''),chr(10),'') as payment_order_id
,replace(replace(t1.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t1.ret_code,chr(13),''),chr(10),'') as ret_code
,replace(replace(t1.ret_message,chr(13),''),chr(10),'') as ret_message
,replace(replace(t1.trx_id,chr(13),''),chr(10),'') as trx_id
,replace(replace(t1.r_p_flg,chr(13),''),chr(10),'') as r_p_flg
,replace(replace(t1.msg_tp,chr(13),''),chr(10),'') as msg_tp
,replace(replace(t1.ori_trx_id,chr(13),''),chr(10),'') as ori_trx_id
,t1.last_updated_stamp as last_updated_stamp
,t1.last_updated_tx_stamp as last_updated_tx_stamp
,t1.created_stamp as created_stamp
,t1.created_tx_stamp as created_tx_stamp
,replace(replace(t1.pyer_acct_issr_id,chr(13),''),chr(10),'') as pyer_acct_issr_id
,replace(replace(t1.pyee_acct_issr_id,chr(13),''),chr(10),'') as pyee_acct_issr_id
,replace(replace(t1.left_refund_amout,chr(13),''),chr(10),'') as left_refund_amout
,replace(replace(t1.host_date,chr(13),''),chr(10),'') as host_date
,replace(replace(t1.host_seq_no,chr(13),''),chr(10),'') as host_seq_no
 from iol.epcs_upbs_biz_trans T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd') and biz_trans_date='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_epcs_upbs_biz_trans.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes