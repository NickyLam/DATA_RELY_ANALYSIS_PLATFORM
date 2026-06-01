: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ppps_t_txn_credit_i
CreateDate: 20240109
FileName:   ${iel_data_path}/ppps_t_txn_credit.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.id as id
,t1.global_no as global_no
,t1.txn_no as txn_no
,t1.txn_date as txn_date
,t1.txn_time as txn_time
,t1.txn_type as txn_type
,t1.corporate as corporate
,t1.mcht_no as mcht_no
,t1.product_no as product_no
,t1.tran_no as tran_no
,t1.tran_date as tran_date
,t1.tran_time as tran_time
,t1.status as status
,t1.biz_status as biz_status
,t1.trade_type as trade_type
,t1.route_type as route_type
,t1.priority as priority
,t1.work_date as work_date
,t1.amount as amount
,t1.currency as currency
,t1.payee_acct_no as payee_acct_no
,t1.payee_acct_name as payee_acct_name
,t1.payee_acct_type as payee_acct_type
,t1.payee_host_type as payee_host_type
,t1.payee_bank_code as payee_bank_code
,t1.payer_acct_no as payer_acct_no
,t1.payer_acct_name as payer_acct_name
,t1.payer_acct_type as payer_acct_type
,t1.payer_host_type as payer_host_type
,t1.payer_phone as payer_phone
,t1.payer_valid_date as payer_valid_date
,t1.payer_cvn2 as payer_cvn2
,t1.payer_bank_code as payer_bank_code
,t1.real_payer_acct_no as real_payer_acct_no
,t1.real_payer_acct_name as real_payer_acct_name
,t1.real_payer_acct_type as real_payer_acct_type
,t1.real_payer_host_type as real_payer_host_type
,t1.ret_code as ret_code
,t1.ret_msg as ret_msg
,t1.is_limited as is_limited
,t1.action_type as action_type
,t1.host_status as host_status
,t1.account_cnt as account_cnt
,t1.host_code_list as host_code_list
,t1.host_no as host_no
,t1.reverse_no as reverse_no
,t1.refunded as refunded
,t1.pmc_code as pmc_code
,t1.pmc_no as pmc_no
,t1.pmc_status as pmc_status
,t1.pmc_ret_code as pmc_ret_code
,t1.pmc_ret_msg as pmc_ret_msg
,t1.pmc_date as pmc_date
,t1.pmc_time as pmc_time
,t1.pmc_cost as pmc_cost
,t1.mcht_fee as mcht_fee
,t1.fee_no as fee_no
,t1.fee_status as fee_status
,t1.charge_type as charge_type
,t1.check_date as check_date
,t1.checked as checked
,t1.check_state as check_state
,t1.is_charge as is_charge
,t1.is_delay as is_delay
,t1.delay_time as delay_time
,t1.fee_amount as fee_amount
,t1.chl_checking_code as chl_checking_code
,t1.chl_check_date as chl_check_date
,t1.auth_teller_no as auth_teller_no
,t1.check_teller_no as check_teller_no
,t1.trans_org_no as trans_org_no
,t1.summery_code as summery_code
,t1.consumer_id as consumer_id
,t1.is_notify as is_notify
,t1.notify_addr as notify_addr
,t1.notify_service_name as notify_service_name
,t1.payer_ext_map_id as payer_ext_map_id
,t1.payee_ext_map_id as payee_ext_map_id
,t1.route_map_id as route_map_id
,t1.host_desc as host_desc
,t1.channel_desc as channel_desc
,t1.balance_desc as balance_desc
,t1.check_time as check_time
,t1.buiness_module as buiness_module
,t1.init_mcht_no as init_mcht_no
,t1.sys_comm_no as sys_comm_no
,t1.pmc_ret_no as pmc_ret_no
,t1.pmc_ret_date as pmc_ret_date
,t1.pmc_ret_time as pmc_ret_time
,t1.pmc_ret_status as pmc_ret_status
,t1.mcht_check_mode as mcht_check_mode
,t1.payer_bank_name as payer_bank_name
,t1.payee_bank_name as payee_bank_name
,t1.check_flag as check_flag
,t1.host_date as host_date
,t1.host_time as host_time
,t1.acc_bean_json as acc_bean_json
,t1.clear_date as clear_date
,t1.cleared as cleared
,t1.clear_no as clear_no
,t1.clear_type as clear_type
,t1.clear_cycle as clear_cycle
,t1.teller_no as teller_no
,t1.payee_phone as payee_phone
,t1.payee_valid_date as payee_valid_date
,t1.payee_cvn2 as payee_cvn2
,t1.biz_type as biz_type
,t1.sign_no as sign_no
,t1.batch_no as batch_no
,t1.purpose as purpose
,t1.log_id as log_id
,t1.server_id as server_id
,t1.sharding as sharding
,t1.remark as remark
,t1.create_time as create_time
,t1.update_time as update_time
,t1.trace_msg as trace_msg
,t1.advance_flag as advance_flag
,t1.biz_sys_code as biz_sys_code
,t1.checking_code as checking_code
,t1.business_code as business_code
,t1.payee_cert_type as payee_cert_type
,t1.payer_cert_type as payer_cert_type

from ${idl_schema}.ppps_t_txn_credit t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ppps_t_txn_credit.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
