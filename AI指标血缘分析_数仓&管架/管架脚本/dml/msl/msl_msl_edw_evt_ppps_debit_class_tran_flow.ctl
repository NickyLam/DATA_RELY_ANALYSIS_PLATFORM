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
infile '${data_path}/evt_ppps_debit_class_tran_flow.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,evt_id char(4000) nullif evt_id=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,plat_flow_num char(4000) nullif plat_flow_num=blanks 
    ,plat_tran_dt date "yyyy-mm-dd hh24:mi:ss" nullif plat_tran_dt=blanks 
    ,plat_tran_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif plat_tran_tm=blanks 
    ,prod_id char(4000) nullif prod_id=blanks 
    ,adv_flg char(4000) nullif adv_flg=blanks 
    ,check_entry_idf_type_cd char(4000) nullif check_entry_idf_type_cd=blanks 
    ,check_entry_proc_flg char(4000) nullif check_entry_proc_flg=blanks 
    ,check_entry_proc_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif check_entry_proc_tm=blanks 
    ,check_entry_rest_descb char(4000) nullif check_entry_rest_descb=blanks 
    ,check_entry_dt date "yyyy-mm-dd hh24:mi:ss" nullif check_entry_dt=blanks 
    ,check_entry_status_cd char(4000) nullif check_entry_status_cd=blanks 
    ,payer_cust_acct_num char(4000) nullif payer_cust_acct_num=blanks 
    ,payer_mobile_no char(4000) nullif payer_mobile_no=blanks 
    ,payer_acct_num_cate_cd char(4000) nullif payer_acct_num_cate_cd=blanks 
    ,payer_acct_num_belong_core_type_cd char(4000) nullif payer_acct_num_belong_core_type_cd=blanks 
    ,payer_acct_name char(4000) nullif payer_acct_name=blanks 
    ,pay_bank_clear_bk_num char(4000) nullif pay_bank_clear_bk_num=blanks 
    ,pay_bank_clear_bk_name char(4000) nullif pay_bank_clear_bk_name=blanks 
    ,check_teller_id char(4000) nullif check_teller_id=blanks 
    ,core_revs_flow_num char(4000) nullif core_revs_flow_num=blanks 
    ,core_check_entry_rest_descb char(4000) nullif core_check_entry_rest_descb=blanks 
    ,core_tran_flow_num char(4000) nullif core_tran_flow_num=blanks 
    ,core_resp_dt date "yyyy-mm-dd hh24:mi:ss" nullif core_resp_dt=blanks 
    ,core_resp_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif core_resp_tm=blanks 
    ,fee_type_cd char(4000) nullif fee_type_cd=blanks 
    ,tran_remark char(4000) nullif tran_remark=blanks 
    ,tran_curr_cd char(4000) nullif tran_curr_cd=blanks 
    ,tran_proc_status_cd char(4000) nullif tran_proc_status_cd=blanks 
    ,tran_postsc char(4000) nullif tran_postsc=blanks 
    ,tran_teller_id char(4000) nullif tran_teller_id=blanks 
    ,tran_core_acct_status_cd char(4000) nullif tran_core_acct_status_cd=blanks 
    ,tran_org_id char(4000) nullif tran_org_id=blanks 
    ,tran_amt char(4000) nullif tran_amt=blanks 
    ,tran_cate_cd char(4000) nullif tran_cate_cd=blanks 
    ,tran_batch_id char(4000) nullif tran_batch_id=blanks 
    ,tran_clear_dt date "yyyy-mm-dd hh24:mi:ss" nullif tran_clear_dt=blanks 
    ,tran_aging_type_cd char(4000) nullif tran_aging_type_cd=blanks 
    ,cust_comm_fee char(4000) nullif cust_comm_fee=blanks 
    ,cross_bank_flg char(4000) nullif cross_bank_flg=blanks 
    ,free_comm_fee_flg char(4000) nullif free_comm_fee_flg=blanks 
    ,clear_type_cd char(4000) nullif clear_type_cd=blanks 
    ,clear_flow_num char(4000) nullif clear_flow_num=blanks 
    ,chn_id char(4000) nullif chn_id=blanks 
    ,chn_check_entry_prod_id char(4000) nullif chn_check_entry_prod_id=blanks 
    ,chn_check_entry_mode_cd char(4000) nullif chn_check_entry_mode_cd=blanks 
    ,chn_check_entry_dt date "yyyy-mm-dd hh24:mi:ss" nullif chn_check_entry_dt=blanks 
    ,chn_tran_flow_num char(4000) nullif chn_tran_flow_num=blanks 
    ,chn_tran_dt date "yyyy-mm-dd hh24:mi:ss" nullif chn_tran_dt=blanks 
    ,chn_tran_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif chn_tran_tm=blanks 
    ,chn_tran_comm_fee char(4000) nullif chn_tran_comm_fee=blanks 
    ,chn_comm_fee_entry_flow_num char(4000) nullif chn_comm_fee_entry_flow_num=blanks 
    ,ova_flow_num char(4000) nullif ova_flow_num=blanks 
    ,realtm_clear_flg char(4000) nullif realtm_clear_flg=blanks 
    ,recver_cust_acct_num char(4000) nullif recver_cust_acct_num=blanks 
    ,recver_mobile_no char(4000) nullif recver_mobile_no=blanks 
    ,recver_acct_num_cate_cd char(4000) nullif recver_acct_num_cate_cd=blanks 
    ,recver_acct_num_belong_core_type_cd char(4000) nullif recver_acct_num_belong_core_type_cd=blanks 
    ,recver_acct_name char(4000) nullif recver_acct_name=blanks 
    ,recv_bank_clear_bk_num char(4000) nullif recv_bank_clear_bk_num=blanks 
    ,recv_bank_clear_bk_name_name char(4000) nullif recv_bank_clear_bk_name_name=blanks 
    ,comm_fee_collect_status_cd char(4000) nullif comm_fee_collect_status_cd=blanks 
    ,auth_teller_id char(4000) nullif auth_teller_id=blanks 
    ,caller_sys_id char(4000) nullif caller_sys_id=blanks 
    ,pass_cost_fee char(4000) nullif pass_cost_fee=blanks 
    ,pass_check_entry_rest_descb char(4000) nullif pass_check_entry_rest_descb=blanks 
    ,pass_tran_flow_num char(4000) nullif pass_tran_flow_num=blanks 
    ,pass_tran_dt date "yyyy-mm-dd hh24:mi:ss" nullif pass_tran_dt=blanks 
    ,pass_tran_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif pass_tran_tm=blanks 
    ,pass_sys_code char(4000) nullif pass_sys_code=blanks 
    ,pass_resp_flow_num char(4000) nullif pass_resp_flow_num=blanks 
    ,pass_resp_dt date "yyyy-mm-dd hh24:mi:ss" nullif pass_resp_dt=blanks 
    ,pass_resp_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif pass_resp_tm=blanks 
    ,pass_resp_status_cd char(4000) nullif pass_resp_status_cd=blanks 
    ,nostro_cd char(4000) nullif nostro_cd=blanks 
    ,sys_comm_flow_num char(4000) nullif sys_comm_flow_num=blanks 
    ,bus_proc_status_cd char(4000) nullif bus_proc_status_cd=blanks 
    ,bus_type_cd char(4000) nullif bus_type_cd=blanks 
    ,aldy_clear_flg char(4000) nullif aldy_clear_flg=blanks 
    ,aldy_refund_flg char(4000) nullif aldy_refund_flg=blanks 
    ,final_update_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif final_update_tm=blanks 
)