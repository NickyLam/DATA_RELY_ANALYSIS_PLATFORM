-- SQL* Unloader: Fast Oracle TetUnloader (Gzip),Release 3.0.1
-- (@) Copyright Lou Fangxin (AnySQL.net) 2004 -2010, all rigths reserved.
-- Purpose:    Sqlldr Control File
-- Author:     Sunline
-- CreateDate: 20190705
-- FileType:   Control-File
-- Logs:
--     luzd 2019-07-05 create template

options(bindsize=2097152,readsize=2097152,errors=0,rows=5000)
load data
infile '${data_path}/ppps_t_txn_credit.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_ppps_t_txn_credit
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,id char(4000) nullif id=blanks 
    ,global_no char(4000) nullif global_no=blanks 
    ,txn_no char(4000) nullif txn_no=blanks 
    ,txn_date char(4000) nullif txn_date=blanks 
    ,txn_time char(4000) nullif txn_time=blanks 
    ,txn_type char(4000) nullif txn_type=blanks 
    ,corporate char(4000) nullif corporate=blanks 
    ,mcht_no char(4000) nullif mcht_no=blanks 
    ,product_no char(4000) nullif product_no=blanks 
    ,tran_no char(4000) nullif tran_no=blanks 
    ,tran_date char(4000) nullif tran_date=blanks 
    ,tran_time char(4000) nullif tran_time=blanks 
    ,status char(4000) nullif status=blanks 
    ,biz_status char(4000) nullif biz_status=blanks 
    ,trade_type char(4000) nullif trade_type=blanks 
    ,route_type char(4000) nullif route_type=blanks 
    ,priority char(4000) nullif priority=blanks 
    ,work_date char(4000) nullif work_date=blanks 
    ,amount char(4000) nullif amount=blanks 
    ,currency char(4000) nullif currency=blanks 
    ,payee_acct_no char(4000) nullif payee_acct_no=blanks 
    ,payee_acct_name char(4000) nullif payee_acct_name=blanks 
    ,payee_acct_type char(4000) nullif payee_acct_type=blanks 
    ,payee_host_type char(4000) nullif payee_host_type=blanks 
    ,payee_bank_code char(4000) nullif payee_bank_code=blanks 
    ,payer_acct_no char(4000) nullif payer_acct_no=blanks 
    ,payer_acct_name char(4000) nullif payer_acct_name=blanks 
    ,payer_acct_type char(4000) nullif payer_acct_type=blanks 
    ,payer_host_type char(4000) nullif payer_host_type=blanks 
    ,payer_phone char(4000) nullif payer_phone=blanks 
    ,payer_valid_date char(4000) nullif payer_valid_date=blanks 
    ,payer_cvn2 char(4000) nullif payer_cvn2=blanks 
    ,payer_bank_code char(4000) nullif payer_bank_code=blanks 
    ,real_payer_acct_no char(4000) nullif real_payer_acct_no=blanks 
    ,real_payer_acct_name char(4000) nullif real_payer_acct_name=blanks 
    ,real_payer_acct_type char(4000) nullif real_payer_acct_type=blanks 
    ,real_payer_host_type char(4000) nullif real_payer_host_type=blanks 
    ,ret_code char(4000) nullif ret_code=blanks 
    ,ret_msg char(4000) nullif ret_msg=blanks 
    ,is_limited char(4000) nullif is_limited=blanks 
    ,action_type char(4000) nullif action_type=blanks 
    ,host_status char(4000) nullif host_status=blanks 
    ,account_cnt char(4000) nullif account_cnt=blanks 
    ,host_code_list char(4000) nullif host_code_list=blanks 
    ,host_no char(4000) nullif host_no=blanks 
    ,reverse_no char(4000) nullif reverse_no=blanks 
    ,refunded char(4000) nullif refunded=blanks 
    ,pmc_code char(4000) nullif pmc_code=blanks 
    ,pmc_no char(4000) nullif pmc_no=blanks 
    ,pmc_status char(4000) nullif pmc_status=blanks 
    ,pmc_ret_code char(4000) nullif pmc_ret_code=blanks 
    ,pmc_ret_msg char(4000) nullif pmc_ret_msg=blanks 
    ,pmc_date char(4000) nullif pmc_date=blanks 
    ,pmc_time char(4000) nullif pmc_time=blanks 
    ,pmc_cost char(4000) nullif pmc_cost=blanks 
    ,mcht_fee char(4000) nullif mcht_fee=blanks 
    ,fee_no char(4000) nullif fee_no=blanks 
    ,fee_status char(4000) nullif fee_status=blanks 
    ,charge_type char(4000) nullif charge_type=blanks 
    ,check_date char(4000) nullif check_date=blanks 
    ,checked char(4000) nullif checked=blanks 
    ,check_state char(4000) nullif check_state=blanks 
    ,is_charge char(4000) nullif is_charge=blanks 
    ,is_delay char(4000) nullif is_delay=blanks 
    ,delay_time char(4000) nullif delay_time=blanks 
    ,fee_amount char(4000) nullif fee_amount=blanks 
    ,chl_checking_code char(4000) nullif chl_checking_code=blanks 
    ,chl_check_date char(4000) nullif chl_check_date=blanks 
    ,auth_teller_no char(4000) nullif auth_teller_no=blanks 
    ,check_teller_no char(4000) nullif check_teller_no=blanks 
    ,trans_org_no char(4000) nullif trans_org_no=blanks 
    ,summery_code char(4000) nullif summery_code=blanks 
    ,consumer_id char(4000) nullif consumer_id=blanks 
    ,is_notify char(4000) nullif is_notify=blanks 
    ,notify_addr char(4000) nullif notify_addr=blanks 
    ,notify_service_name char(4000) nullif notify_service_name=blanks 
    ,payer_ext_map_id char(4000) nullif payer_ext_map_id=blanks 
    ,payee_ext_map_id char(4000) nullif payee_ext_map_id=blanks 
    ,route_map_id char(4000) nullif route_map_id=blanks 
    ,host_desc char(4000) nullif host_desc=blanks 
    ,channel_desc char(4000) nullif channel_desc=blanks 
    ,balance_desc char(4000) nullif balance_desc=blanks 
    ,check_time date "yyyy-mm-dd hh24:mi:ss" nullif check_time=blanks 
    ,buiness_module char(4000) nullif buiness_module=blanks 
    ,init_mcht_no char(4000) nullif init_mcht_no=blanks 
    ,sys_comm_no char(4000) nullif sys_comm_no=blanks 
    ,pmc_ret_no char(4000) nullif pmc_ret_no=blanks 
    ,pmc_ret_date char(4000) nullif pmc_ret_date=blanks 
    ,pmc_ret_time char(4000) nullif pmc_ret_time=blanks 
    ,pmc_ret_status char(4000) nullif pmc_ret_status=blanks 
    ,mcht_check_mode char(4000) nullif mcht_check_mode=blanks 
    ,payer_bank_name char(4000) nullif payer_bank_name=blanks 
    ,payee_bank_name char(4000) nullif payee_bank_name=blanks 
    ,check_flag char(4000) nullif check_flag=blanks 
    ,host_date char(4000) nullif host_date=blanks 
    ,host_time char(4000) nullif host_time=blanks 
    ,acc_bean_json char(4000) nullif acc_bean_json=blanks 
    ,clear_date char(4000) nullif clear_date=blanks 
    ,cleared char(4000) nullif cleared=blanks 
    ,clear_no char(4000) nullif clear_no=blanks 
    ,clear_type char(4000) nullif clear_type=blanks 
    ,clear_cycle char(4000) nullif clear_cycle=blanks 
    ,teller_no char(4000) nullif teller_no=blanks 
    ,payee_phone char(4000) nullif payee_phone=blanks 
    ,payee_valid_date char(4000) nullif payee_valid_date=blanks 
    ,payee_cvn2 char(4000) nullif payee_cvn2=blanks 
    ,biz_type char(4000) nullif biz_type=blanks 
    ,sign_no char(4000) nullif sign_no=blanks 
    ,batch_no char(4000) nullif batch_no=blanks 
    ,purpose char(4000) nullif purpose=blanks 
    ,log_id char(4000) nullif log_id=blanks 
    ,server_id char(4000) nullif server_id=blanks 
    ,sharding char(4000) nullif sharding=blanks 
    ,remark char(4000) nullif remark=blanks 
    ,create_time date "yyyy-mm-dd hh24:mi:ss" nullif create_time=blanks 
    ,update_time date "yyyy-mm-dd hh24:mi:ss" nullif update_time=blanks 
    ,trace_msg char(4000) nullif trace_msg=blanks 
    ,advance_flag char(4000) nullif advance_flag=blanks 
    ,biz_sys_code char(4000) nullif biz_sys_code=blanks 
    ,checking_code char(4000) nullif checking_code=blanks 
    ,business_code char(4000) nullif business_code=blanks 
    ,payee_cert_type char(4000) nullif payee_cert_type=blanks 
    ,payer_cert_type char(4000) nullif payer_cert_type=blanks 
)