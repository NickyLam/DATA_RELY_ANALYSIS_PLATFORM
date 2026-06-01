: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_upps_t_txn_credit_i
CreateDate: 20180529
FileName:   ${iel_data_path}/upps_t_txn_credit.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') etl_dt 
,id 
,global_no 
,txn_no 
,txn_date 
,txn_time 
,txn_type 
,corporate 
,mcht_no 
,product_no 
,tran_no 
,tran_date 
,tran_time 
,status 
,biz_status 
,trade_type 
,route_type 
,priority 
,work_date 
,amount 
,currency 
,payee_acct_no 
,payee_acct_name 
,payee_acct_type 
,payee_host_type 
,payee_bank_code 
,payer_acct_no 
,payer_acct_name 
,payer_acct_type 
,payer_host_type 
,payer_phone 
,payer_valid_date 
,payer_cvn2 
,payer_bank_code 
,real_payer_acct_no 
,real_payer_acct_name 
,real_payer_acct_type 
,real_payer_host_type 
,ret_code 
,ret_msg 
,is_limited 
,action_type 
,host_status 
,account_cnt 
,host_code_list 
,host_no 
,reverse_no 
,refunded 
,pmc_code 
,pmc_no 
,pmc_status 
,pmc_ret_code 
,pmc_ret_msg 
,pmc_date 
,pmc_time 
,pmc_cost 
,mcht_fee 
,fee_no 
,fee_status 
,charge_type 
,check_date 
,checked 
,check_state 
,is_charge 
,is_delay 
,delay_time 
,fee_amount 
,chl_checking_code 
,chl_check_date 
,auth_teller_no 
,check_teller_no 
,trans_org_no 
,summery_code 
,consumer_id 
,is_notify 
,notify_addr 
,notify_service_name 
,payer_ext_map_id 
,payee_ext_map_id 
,route_map_id 
,host_desc 
,channel_desc 
,balance_desc 
,check_time 
,buiness_module 
,init_mcht_no 
,sys_comm_no 
,pmc_ret_no 
,pmc_ret_date 
,pmc_ret_time 
,pmc_ret_status 
,mcht_check_mode 
,payer_bank_name 
,payee_bank_name 
,check_flag 
,host_date 
,host_time 
,acc_bean_json 
,clear_date 
,cleared 
,clear_no 
,clear_type 
,clear_cycle 
,teller_no 
,payee_phone 
,payee_valid_date 
,payee_cvn2 
,biz_type 
,sign_no 
,batch_no 
,purpose 
,log_id 
,server_id 
,sharding 
,remark 
,create_time 
,update_time 
,trace_msg 
,checking_code 
,advance_flag 
,biz_sys_code 
from ${idl_schema}.upps_t_txn_credit t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/upps_t_txn_credit.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes