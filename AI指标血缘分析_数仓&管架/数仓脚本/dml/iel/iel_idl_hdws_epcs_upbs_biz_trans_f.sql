: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_epcs_upbs_biz_trans_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_epcs_upbs_biz_trans.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.biz_trans_id
,t1.biz_type
,t1.biz_trans_date
,t1.tran_seq_no
,t1.global_seq_no
,t1.consumer_id
,t1.source_sys_id
,t1.channel
,t1.branch_id
,t1.tran_teller_no
,t1.trans_time
,t1.authr_teller_no
,t1.currency_uom_id
,t1.amount
,t1.payment_method_type_id
,t1.account_number
,t1.account_name
,t1.opp_payment_method_type_id
,t1.opp_account_number
,t1.opp_account_name
,t1.cert_type
,t1.cert_no
,t1.mobile_phone
,t1.agreement_id
,t1.payment_order_id
,t1.status_id
,t1.ret_code
,t1.ret_message
,t1.trx_id
,t1.r_p_flg
,t1.msg_tp
,t1.ori_trx_id
,t1.last_updated_stamp
,t1.last_updated_tx_stamp
,t1.created_stamp
,t1.created_tx_stamp
,t1.pyer_acct_issr_id
,t1.pyee_acct_issr_id
,t1.left_refund_amout
,t1.host_date
,t1.host_seq_no
,t1.batch_id
,t1.payment_seq_no
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_epcs_upbs_biz_trans t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_epcs_upbs_biz_trans.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes