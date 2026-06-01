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
infile '${data_path}/evt_super_olbk_tran_evt.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_evt_super_olbk_tran_evt
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,evt_id char(4000) nullif evt_id=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,evt_dt date "yyyy-mm-dd hh24:mi:ss" nullif evt_dt=blanks 
    ,front_flow_num char(4000) nullif front_flow_num=blanks 
    ,host_tran_code char(4000) nullif host_tran_code=blanks 
    ,front_tran_code char(4000) nullif front_tran_code=blanks 
    ,pbc_tran_code char(4000) nullif pbc_tran_code=blanks 
    ,bank_int_bus_seq_num char(4000) nullif bank_int_bus_seq_num=blanks 
    ,bus_seq_num char(4000) nullif bus_seq_num=blanks 
    ,num_site char(4000) nullif num_site=blanks 
    ,comm_fee char(4000) nullif comm_fee=blanks 
    ,postage char(4000) nullif postage=blanks 
    ,trdpty_org_comm_fee_amt char(4000) nullif trdpty_org_comm_fee_amt=blanks 
    ,stl_amt char(4000) nullif stl_amt=blanks 
    ,tran_amt char(4000) nullif tran_amt=blanks 
    ,curr_cd char(4000) nullif curr_cd=blanks 
    ,host_rest_cd char(4000) nullif host_rest_cd=blanks 
    ,pbc_bus_status_cd char(4000) nullif pbc_bus_status_cd=blanks 
    ,refuse_rs_cd char(4000) nullif refuse_rs_cd=blanks 
    ,pbc_bus_type_cd char(4000) nullif pbc_bus_type_cd=blanks 
    ,pbc_bus_kind_cd char(4000) nullif pbc_bus_kind_cd=blanks 
    ,host_check_entry_status_cd char(4000) nullif host_check_entry_status_cd=blanks 
    ,pbc_check_entry_status_cd char(4000) nullif pbc_check_entry_status_cd=blanks 
    ,host_flow_num char(4000) nullif host_flow_num=blanks 
    ,sumos_id char(4000) nullif sumos_id=blanks 
    ,tran_brac_id char(4000) nullif tran_brac_id=blanks 
    ,operr_id char(4000) nullif operr_id=blanks 
    ,brac_print_flg char(4000) nullif brac_print_flg=blanks 
    ,temp_print_flg char(4000) nullif temp_print_flg=blanks 
    ,print_cnt char(4000) nullif print_cnt=blanks 
    ,subj_id char(4000) nullif subj_id=blanks 
    ,fac_val_recd_dt date "yyyy-mm-dd hh24:mi:ss" nullif fac_val_recd_dt=blanks 
    ,present_wdraw_dt date "yyyy-mm-dd hh24:mi:ss" nullif present_wdraw_dt=blanks 
    ,entry_dt date "yyyy-mm-dd hh24:mi:ss" nullif entry_dt=blanks 
    ,send_bank_dt date "yyyy-mm-dd hh24:mi:ss" nullif send_bank_dt=blanks 
    ,pbc_proc_dt date "yyyy-mm-dd hh24:mi:ss" nullif pbc_proc_dt=blanks 
    ,bank_int_sys_proc_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif bank_int_sys_proc_tm=blanks 
    ,bus_init_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif bus_init_tm=blanks 
    ,submit_prior_level char(4000) nullif submit_prior_level=blanks 
    ,present_wdraw_flg char(4000) nullif present_wdraw_flg=blanks 
    ,realtm_onl_flg char(4000) nullif realtm_onl_flg=blanks 
    ,charge_flg char(4000) nullif charge_flg=blanks 
    ,debit_crdt_cd char(4000) nullif debit_crdt_cd=blanks 
    ,recv_bank_no char(4000) nullif recv_bank_no=blanks 
    ,recv_bank_name char(4000) nullif recv_bank_name=blanks 
    ,recver_acct_num char(4000) nullif recver_acct_num=blanks 
    ,recver_name char(4000) nullif recver_name=blanks 
    ,recver_acct_type char(4000) nullif recver_acct_type=blanks 
    ,pay_bank_no char(4000) nullif pay_bank_no=blanks 
    ,pay_bank_name char(4000) nullif pay_bank_name=blanks 
    ,payer_acct_num char(4000) nullif payer_acct_num=blanks 
    ,payer_name char(4000) nullif payer_name=blanks 
    ,payer_acct_type_cd char(4000) nullif payer_acct_type_cd=blanks 
    ,send_msg_bank_no char(4000) nullif send_msg_bank_no=blanks 
    ,recv_msg_bank_no char(4000) nullif recv_msg_bank_no=blanks 
    ,tran_status_cd char(4000) nullif tran_status_cd=blanks 
    ,tran_status_rest_cd char(4000) nullif tran_status_rest_cd=blanks 
    ,chn_cd char(4000) nullif chn_cd=blanks 
    ,refuse_bus_org_bank_no char(4000) nullif refuse_bus_org_bank_no=blanks 
    ,pay_clear_bk_no char(4000) nullif pay_clear_bk_no=blanks 
    ,recvbl_clear_bk_no char(4000) nullif recvbl_clear_bk_no=blanks 
    ,payer_open_bank_no char(4000) nullif payer_open_bank_no=blanks 
    ,recver_open_bank_no char(4000) nullif recver_open_bank_no=blanks 
    ,payer_bank_belong_city_cd char(4000) nullif payer_bank_belong_city_cd=blanks 
    ,recver_bank_belong_city_cd char(4000) nullif recver_bank_belong_city_cd=blanks 
    ,web_tran_odd_no char(4000) nullif web_tran_odd_no=blanks 
    ,cert_way_cd char(4000) nullif cert_way_cd=blanks 
    ,cert_info char(4000) nullif cert_info=blanks 
    ,pre_auth_id char(4000) nullif pre_auth_id=blanks 
    ,mercht_id char(4000) nullif mercht_id=blanks 
    ,mercht_name char(4000) nullif mercht_name=blanks 
    ,coll_comm_fee_org_id char(4000) nullif coll_comm_fee_org_id=blanks 
    ,web_tran_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif web_tran_tm=blanks 
    ,open_acct_brac_id char(4000) nullif open_acct_brac_id=blanks 
    ,check_entry_dt date "yyyy-mm-dd hh24:mi:ss" nullif check_entry_dt=blanks 
    ,check_entry_proc_flg char(4000) nullif check_entry_proc_flg=blanks 
    ,tran_index_num char(4000) nullif tran_index_num=blanks 
    ,e_acct_cd char(4000) nullif e_acct_cd=blanks 
    ,e_acct_entry_req_flow_num char(4000) nullif e_acct_entry_req_flow_num=blanks 
    ,next_day_arrive_flg char(4000) nullif next_day_arrive_flg=blanks 
    ,supv_acct char(4000) nullif supv_acct=blanks 
    ,supv_acct_num char(4000) nullif supv_acct_num=blanks 
    ,supv_acct_num_acct_name char(4000) nullif supv_acct_num_acct_name=blanks 
    ,supv_acct_num_open_org_id char(4000) nullif supv_acct_num_open_org_id=blanks 
    ,acct_type_cd char(4000) nullif acct_type_cd=blanks 
    ,sign_type_cd char(4000) nullif sign_type_cd=blanks 
    ,refund_flg char(4000) nullif refund_flg=blanks 
    ,init_msg_idf_id char(4000) nullif init_msg_idf_id=blanks 
    ,init_prtcpt_org_bank_no char(4000) nullif init_prtcpt_org_bank_no=blanks 
    ,acct_ety_code char(4000) nullif acct_ety_code=blanks 
    ,acct_cate_cd char(4000) nullif acct_cate_cd=blanks 
    ,resv_bd_flg char(4000) nullif resv_bd_flg=blanks 
    ,cust_id char(4000) nullif cust_id=blanks 
    ,st_msg_check_ser_num char(4000) nullif st_msg_check_ser_num=blanks 
    ,mobile_no char(4000) nullif mobile_no=blanks 
    ,cert_no char(4000) nullif cert_no=blanks 
    ,super_olbk_entry_rela_seq_num char(4000) nullif super_olbk_entry_rela_seq_num=blanks 
    ,lmt_order_no char(4000) nullif lmt_order_no=blanks 
    ,bind_flg char(4000) nullif bind_flg=blanks 
    ,ova_flow_num char(4000) nullif ova_flow_num=blanks 
    ,esb_intfc_return_code char(4000) nullif esb_intfc_return_code=blanks 
    ,esb_intfc_return_info char(4000) nullif esb_intfc_return_info=blanks 
    ,esb_intfc_tran_flow_num char(4000) nullif esb_intfc_tran_flow_num=blanks 
)