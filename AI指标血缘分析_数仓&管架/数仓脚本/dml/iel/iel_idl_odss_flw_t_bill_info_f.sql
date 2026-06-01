: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_flw_t_bill_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_flw_t_bill_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,process_inst_id
,main_flow_id
,accept_no
,root_accept_no
,scan_seq_no
,tr_date
,accept_time
,user_id
,charge_id
,br_code
,biz_code
,change_channel
,change_no
,biz_type
,voucher_code
,voucher_no
,bill_date
,cust_no
,custname
,curr_code
,drawee_name
,drawee_acct_no
,drawee_bk_no
,drawee_bk_name
,drawee_addr
,inac_flag
,payee_name
,payee_acct_no
,payee_bk_no
,payee_bk_name
,payee_addr
,trn_amt
,purpose
,memocd
,tally_state
,tr_state
,tr_state_msg
,submit_state
,tally_send_seqno
,tally_host_seqno
,tally_host_date
,pay_send_seqno
,pay_send_date
,pay_host_seqno
,pay_host_date
,pay_businesstrace
,drawee_info_send_result
,drawee_info_send_time
,drawee_info_send_flag
,batch_count
,batch_is_sync_ete
,split_count
,trn_amt_ch
,ticket_count
,endorser_num
,endorsers
,pay_date
,pay_password
,tax_bill_flag
,clear_date
,confirm_batch_no
,auto_seal_batch_no
,ret_type
,acct_query_msg
,acct_br_code
,acct_stat
,acct_amt_stat
,bill_seq_no
,bill_flag
,ret_scan_seq_no
,clear_change_no
,inacct_state
,inacct_submit_state
,inacct_send_seqno
,inacct_host_seqno
,inacct_host_date
,reversed_user_id
,reversed_time
,reversed_submit_state
,reversed_send_seqno
,reversed_host_seqno
,reversed_host_date
,reversed_reason
,inacct_user_id
,out_confirm_userid
,out_confirm_chargeid
,out_confirm_time
,check_user_id
,check_time
,reversed_charge_id
,return_reason
,proxy_drawee_bk_no
,inacct_charge_id
,inacct_time
,delay_inacct_user_id
,delay_inacct_charge_id
,delay_inacct_time
,cancel_delay_user_id
,cancel_delay_charge_id
,cancel_delay_time
,trade_date
,micr
,ref_batch_accept_no
,ref_batch_scan_seq_no
,in_bk_no
,in_bk_name
,out_bk_no
,out_bk_name
,txcd
,billnd
,trade_round
,bill_in_order
,acct_do_type
,suspend_acct_acctpno
,start_way
from ${idl_schema}.odss_flw_t_bill_info
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_flw_t_bill_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes