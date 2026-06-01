: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_flw_t_remit_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_flw_t_remit_info_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,process_inst_id
,main_flow_id
,scan_seq_no
,tr_date
,accept_no
,user_id
,charge_id
,br_code
,biz_class
,biz_code
,voucher_code
,voucher_no
,accept_time
,cust_no
,biz_type
,transfer_type
,curr_code
,pay_channel
,pay_type
,drawee_name
,drawee_acct_no
,drawee_tp
,drawee_no
,drawee_dt
,drawee_tel
,payee_name
,payee_acct_no
,trn_amt
,trn_amt_ch
,is_proxy
,proxy_name
,proxy_tp
,proxy_no
,proxy_dt
,fee_type
,fee_amt
,remit_priority
,city_priority
,tr_state
,tx_mthd
,purpose
,reason
,upg_flag
,drawee_bk_no
,drawee_bk_name
,payee_bk_no
,payee_bk_name
,bill_date
,ret_reason
,ticket_type
,ticket_count
,ticket_no
,call_result
,call_person_num
,call_tout_flag
,call_iout_user_id
,call_tout_charge_id
,cust_name
,tr_state_msg
,drawee_addr
,payee_addr
,post_fee
,cost_fee
,memocd
,acceptpcflag
,inacct
,inname
,inac_flag
,pay_send_seqno
,pay_host_seqno
,businesstrace
,pay_send_date
,pay_host_date
,drawee_core_tel
,root_accept_no
,tally_state
,send_flwno
,host_nbr
,host_date
,submit_state
,drawee_info_send_flag
,drawee_info_send_result
,drawee_info_send_time
from ${idl_schema}.odss_flw_t_remit_info
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_flw_t_remit_info_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes