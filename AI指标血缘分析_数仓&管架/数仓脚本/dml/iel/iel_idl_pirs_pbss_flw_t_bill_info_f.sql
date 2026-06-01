: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_pbss_flw_t_bill_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_pbss_flw_t_bill_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.id as id
,t1.process_inst_id as process_inst_id
,t1.main_flow_id as main_flow_id
,t1.accept_no as accept_no
,t1.root_accept_no as root_accept_no
,t1.scan_seq_no as scan_seq_no
,t1.tr_date as tr_date
,t1.accept_time as accept_time
,t1.user_id as user_id
,t1.charge_id as charge_id
,t1.br_code as br_code
,t1.biz_code as biz_code
,t1.change_channel as change_channel
,t1.change_no as change_no
,t1.biz_type as biz_type
,t1.voucher_code as voucher_code
,t1.voucher_no as voucher_no
,t1.bill_date as bill_date
,t1.cust_no as cust_no
,t1.custname as custname
,t1.curr_code as curr_code
,t1.drawee_name as drawee_name
,t1.drawee_acct_no as drawee_acct_no
,t1.drawee_bk_no as drawee_bk_no
,t1.drawee_bk_name as drawee_bk_name
,t1.drawee_addr as drawee_addr
,t1.inac_flag as inac_flag
,t1.payee_name as payee_name
,t1.payee_acct_no as payee_acct_no
,t1.payee_bk_no as payee_bk_no
,t1.payee_bk_name as payee_bk_name
,t1.payee_addr as payee_addr
,t1.trn_amt as trn_amt
,t1.purpose as purpose
,t1.memocd as memocd
,t1.tally_state as tally_state
,t1.tr_state as tr_state
,t1.tr_state_msg as tr_state_msg
,t1.submit_state as submit_state
,t1.tally_send_seqno as tally_send_seqno
,t1.tally_host_seqno as tally_host_seqno
,t1.tally_host_date as tally_host_date
,t1.pay_send_seqno as pay_send_seqno
,t1.pay_send_date as pay_send_date
,t1.pay_host_seqno as pay_host_seqno
,t1.pay_host_date as pay_host_date
,t1.pay_businesstrace as pay_businesstrace
,t1.drawee_info_send_result as drawee_info_send_result
,t1.drawee_info_send_time as drawee_info_send_time
,t1.drawee_info_send_flag as drawee_info_send_flag
,t1.batch_count as batch_count
,t1.batch_is_sync_ete as batch_is_sync_ete
,t1.split_count as split_count
,t1.trn_amt_ch as trn_amt_ch
,t1.ticket_count as ticket_count
,t1.endorser_num as endorser_num
,t1.endorsers as endorsers
,t1.pay_date as pay_date
,t1.pay_password as pay_password
,t1.tax_bill_flag as tax_bill_flag
,t1.auto_seal_batch_no as auto_seal_batch_no
,t1.ret_type as ret_type
,t1.confirm_batch_no as confirm_batch_no
,t1.clear_date as clear_date
,t1.bill_seq_no as bill_seq_no
,t1.acct_query_msg as acct_query_msg
,t1.acct_br_code as acct_br_code
,t1.acct_stat as acct_stat
,t1.acct_amt_stat as acct_amt_stat
,t1.bill_flag as bill_flag
,t1.ret_scan_seq_no as ret_scan_seq_no
,t1.clear_change_no as clear_change_no
,t1.inacct_state as inacct_state
,t1.inacct_submit_state as inacct_submit_state
,t1.inacct_send_seqno as inacct_send_seqno
,t1.inacct_host_seqno as inacct_host_seqno
,t1.inacct_host_date as inacct_host_date
,t1.reversed_user_id as reversed_user_id
,t1.reversed_time as reversed_time
,t1.reversed_submit_state as reversed_submit_state
,t1.reversed_send_seqno as reversed_send_seqno
,t1.reversed_host_seqno as reversed_host_seqno
,t1.reversed_host_date as reversed_host_date
,t1.reversed_reason as reversed_reason
,t1.inacct_user_id as inacct_user_id
,t1.out_confirm_userid as out_confirm_userid
,t1.out_confirm_chargeid as out_confirm_chargeid
,t1.out_confirm_time as out_confirm_time
,t1.check_user_id as check_user_id
,t1.check_time as check_time
,t1.reversed_charge_id as reversed_charge_id
,t1.return_reason as return_reason
,t1.proxy_drawee_bk_no as proxy_drawee_bk_no
,t1.inacct_charge_id as inacct_charge_id
,t1.inacct_time as inacct_time
,t1.delay_inacct_user_id as delay_inacct_user_id
,t1.delay_inacct_charge_id as delay_inacct_charge_id
,t1.delay_inacct_time as delay_inacct_time
,t1.cancel_delay_user_id as cancel_delay_user_id
,t1.cancel_delay_charge_id as cancel_delay_charge_id
,t1.cancel_delay_time as cancel_delay_time
,t1.micr as micr
,t1.trade_date as trade_date
,t1.ref_batch_accept_no as ref_batch_accept_no
,t1.ref_batch_scan_seq_no as ref_batch_scan_seq_no
,t1.in_bk_no as in_bk_no
,t1.in_bk_name as in_bk_name
,t1.out_bk_no as out_bk_no
,t1.out_bk_name as out_bk_name
,t1.trade_round as trade_round
,t1.bill_in_order as bill_in_order
,t1.txcd as txcd
,t1.billnd as billnd
,t1.acct_do_type as acct_do_type
,t1.suspend_acct_acctpno as suspend_acct_acctpno
,t1.start_way as start_way
,t1.return_reason_desc as return_reason_desc
from ${idl_schema}.pirs_pbss_flw_t_bill_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_pbss_flw_t_bill_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes