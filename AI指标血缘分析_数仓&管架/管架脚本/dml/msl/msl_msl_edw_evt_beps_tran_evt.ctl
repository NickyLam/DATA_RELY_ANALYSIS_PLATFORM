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
infile '${data_path}/evt_beps_tran_evt.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_evt_beps_tran_evt
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,evt_id char(4000) nullif evt_id=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,pay_decl_form_id char(4000) nullif pay_decl_form_id=blanks 
    ,out_line_pay_tran_seq_num char(4000) nullif out_line_pay_tran_seq_num=blanks 
    ,bank_int_bus_seq_num char(4000) nullif bank_int_bus_seq_num=blanks 
    ,bus_type_cd char(4000) nullif bus_type_cd=blanks 
    ,bus_kind_cd char(4000) nullif bus_kind_cd=blanks 
    ,pkg_seq_num char(4000) nullif pkg_seq_num=blanks 
    ,pkg_entr_dt date "yyyy-mm-dd hh24:mi:ss" nullif pkg_entr_dt=blanks 
    ,pkg_type char(4000) nullif pkg_type=blanks 
    ,host_tran_code char(4000) nullif host_tran_code=blanks 
    ,midgrod_tran_code char(4000) nullif midgrod_tran_code=blanks 
    ,tran_dt date "yyyy-mm-dd hh24:mi:ss" nullif tran_dt=blanks 
    ,entr_dt date "yyyy-mm-dd hh24:mi:ss" nullif entr_dt=blanks 
    ,host_dt date "yyyy-mm-dd hh24:mi:ss" nullif host_dt=blanks 
    ,host_flow_num char(4000) nullif host_flow_num=blanks 
    ,curr_cd char(4000) nullif curr_cd=blanks 
    ,tran_amt char(4000) nullif tran_amt=blanks 
    ,payer_open_bank_dept_id char(4000) nullif payer_open_bank_dept_id=blanks 
    ,payer_open_bank_no char(4000) nullif payer_open_bank_no=blanks 
    ,payer_acct_num char(4000) nullif payer_acct_num=blanks 
    ,payer_name char(4000) nullif payer_name=blanks 
    ,payer_addr char(4000) nullif payer_addr=blanks 
    ,recver_open_bank_no char(4000) nullif recver_open_bank_no=blanks 
    ,recver_acct_num char(4000) nullif recver_acct_num=blanks 
    ,recver_name char(4000) nullif recver_name=blanks 
    ,recver_addr char(4000) nullif recver_addr=blanks 
    ,send_msg_center_cd char(4000) nullif send_msg_center_cd=blanks 
    ,init_clear_bk_no char(4000) nullif init_clear_bk_no=blanks 
    ,origi_bank_no char(4000) nullif origi_bank_no=blanks 
    ,recv_msg_center_cd char(4000) nullif recv_msg_center_cd=blanks 
    ,recv_clear_bk_no char(4000) nullif recv_clear_bk_no=blanks 
    ,recv_bank_no char(4000) nullif recv_bank_no=blanks 
    ,init_entr_dt date "yyyy-mm-dd hh24:mi:ss" nullif init_entr_dt=blanks 
    ,init_pay_tran_seq_num char(4000) nullif init_pay_tran_seq_num=blanks 
    ,init_bus_type_cd char(4000) nullif init_bus_type_cd=blanks 
    ,bill_num char(4000) nullif bill_num=blanks 
    ,offs_bal_node_type_cd char(4000) nullif offs_bal_node_type_cd=blanks 
    ,offs_bal_num_site char(4000) nullif offs_bal_num_site=blanks 
    ,offs_bal_dt_or_fs_dt date "yyyy-mm-dd hh24:mi:ss" nullif offs_bal_dt_or_fs_dt=blanks 
    ,refund_rs_cd char(4000) nullif refund_rs_cd=blanks 
    ,proc_status_cd char(4000) nullif proc_status_cd=blanks 
    ,status_rest_cd char(4000) nullif status_rest_cd=blanks 
    ,pbc_bus_status_cd char(4000) nullif pbc_bus_status_cd=blanks 
    ,rtn_rcpt_code char(4000) nullif rtn_rcpt_code=blanks 
    ,proc_cd char(4000) nullif proc_cd=blanks 
    ,sys_type_cd char(4000) nullif sys_type_cd=blanks 
    ,node_type_cd char(4000) nullif node_type_cd=blanks 
    ,rest_cd char(4000) nullif rest_cd=blanks 
    ,check_revs_flow_num char(4000) nullif check_revs_flow_num=blanks 
    ,rtn_rcpt_tenor_cd char(4000) nullif rtn_rcpt_tenor_cd=blanks 
    ,rtn_rcpt_dt date "yyyy-mm-dd hh24:mi:ss" nullif rtn_rcpt_dt=blanks 
    ,send_revs_flow_num char(4000) nullif send_revs_flow_num=blanks 
    ,clear_dt date "yyyy-mm-dd hh24:mi:ss" nullif clear_dt=blanks 
    ,err_code char(4000) nullif err_code=blanks 
    ,err_info char(4000) nullif err_info=blanks 
    ,prior_level char(4000) nullif prior_level=blanks 
    ,input_teller_id char(4000) nullif input_teller_id=blanks 
    ,check_teller_id char(4000) nullif check_teller_id=blanks 
    ,auth_teller_id char(4000) nullif auth_teller_id=blanks 
    ,input_check_teller_dept_id char(4000) nullif input_check_teller_dept_id=blanks 
    ,auth_teller_dept_id char(4000) nullif auth_teller_dept_id=blanks 
    ,check_entry_status_cd char(4000) nullif check_entry_status_cd=blanks 
    ,print_cnt char(4000) nullif print_cnt=blanks 
    ,revid_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif revid_tm=blanks 
    ,send_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif send_tm=blanks 
    ,sugst_pay_dt date "yyyy-mm-dd hh24:mi:ss" nullif sugst_pay_dt=blanks 
    ,nostro_flg char(4000) nullif nostro_flg=blanks 
    ,charge_flg char(4000) nullif charge_flg=blanks 
    ,debit_crdt_cd char(4000) nullif debit_crdt_cd=blanks 
    ,bank_int_out_line_flg char(4000) nullif bank_int_out_line_flg=blanks 
    ,draft_appl_form_num char(4000) nullif draft_appl_form_num=blanks 
    ,matn_enter_acct_num char(4000) nullif matn_enter_acct_num=blanks 
    ,reg_main_name char(4000) nullif reg_main_name=blanks 
    ,matn_enter_acct_dt date "yyyy-mm-dd hh24:mi:ss" nullif matn_enter_acct_dt=blanks 
    ,matn_enter_acct_teller_id char(4000) nullif matn_enter_acct_teller_id=blanks 
    ,matn_enter_acct_dept_id char(4000) nullif matn_enter_acct_dept_id=blanks 
    ,agent_flg char(4000) nullif agent_flg=blanks 
    ,jnl_flow_num char(4000) nullif jnl_flow_num=blanks 
    ,send_jnl_flow_num char(4000) nullif send_jnl_flow_num=blanks 
    ,vouch_type_cd char(4000) nullif vouch_type_cd=blanks 
    ,entr_vouch_dt date "yyyy-mm-dd hh24:mi:ss" nullif entr_vouch_dt=blanks 
    ,entr_vouch_num char(4000) nullif entr_vouch_num=blanks 
    ,cert_kind_cd char(4000) nullif cert_kind_cd=blanks 
    ,cert_no char(4000) nullif cert_no=blanks 
    ,tran_lmt char(4000) nullif tran_lmt=blanks 
    ,tran_flow_num char(4000) nullif tran_flow_num=blanks 
    ,send_tran_flow_num char(4000) nullif send_tran_flow_num=blanks 
    ,mode_pay_cd char(4000) nullif mode_pay_cd=blanks 
    ,exch_bus_cors_tran_chn_cd char(4000) nullif exch_bus_cors_tran_chn_cd=blanks 
    ,recnt_modif_dt date "yyyy-mm-dd hh24:mi:ss" nullif recnt_modif_dt=blanks 
    ,bus_flow_num char(4000) nullif bus_flow_num=blanks 
    ,comm_fee char(4000) nullif comm_fee=blanks 
    ,remit_tran_fee char(4000) nullif remit_tran_fee=blanks 
    ,todos char(4000) nullif todos=blanks 
    ,init_amt char(4000) nullif init_amt=blanks 
    ,pay_amt char(4000) nullif pay_amt=blanks 
    ,multi_pay_amt char(4000) nullif multi_pay_amt=blanks 
    ,mpr_host_flow_num char(4000) nullif mpr_host_flow_num=blanks 
    ,mpr_host_dt date "yyyy-mm-dd hh24:mi:ss" nullif mpr_host_dt=blanks 
    ,mpr_teller_id char(4000) nullif mpr_teller_id=blanks 
    ,recnt_modif_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif recnt_modif_tm=blanks 
    ,proc_org_id char(4000) nullif proc_org_id=blanks 
    ,rec_update_edit_num char(4000) nullif rec_update_edit_num=blanks 
    ,rec_status_cd char(4000) nullif rec_status_cd=blanks 
    ,init_pkg_type char(4000) nullif init_pkg_type=blanks 
    ,init_pkg_init_clear_bk_num char(4000) nullif init_pkg_init_clear_bk_num=blanks 
    ,init_pkg_entr_dt date "yyyy-mm-dd hh24:mi:ss" nullif init_pkg_entr_dt=blanks 
    ,init_pkg_seq_num char(4000) nullif init_pkg_seq_num=blanks 
    ,prod_cd char(4000) nullif prod_cd=blanks 
    ,intnal_acct_flg char(4000) nullif intnal_acct_flg=blanks 
    ,actl_deduct_acct_num char(4000) nullif actl_deduct_acct_num=blanks 
    ,actl_deduct_acct_name char(4000) nullif actl_deduct_acct_name=blanks 
    ,bank_int_sys_edit_num char(4000) nullif bank_int_sys_edit_num=blanks 
    ,cntpty_sys_edit_num char(4000) nullif cntpty_sys_edit_num=blanks 
    ,ground_proc_status_cd char(4000) nullif ground_proc_status_cd=blanks 
    ,verify_proc_status_cd char(4000) nullif verify_proc_status_cd=blanks 
    ,rgst_addit_data_name char(4000) nullif rgst_addit_data_name=blanks 
    ,rgst_addit_data_dtl_name char(4000) nullif rgst_addit_data_dtl_name=blanks 
    ,on_acct_rs_cd char(4000) nullif on_acct_rs_cd=blanks 
    ,pkg_bank_int_seq_num char(4000) nullif pkg_bank_int_seq_num=blanks 
    ,scd_gener_msg_type_id char(4000) nullif scd_gener_msg_type_id=blanks 
    ,scd_gener_bus_type_cd char(4000) nullif scd_gener_bus_type_cd=blanks 
    ,scd_gener_bus_kind_cd char(4000) nullif scd_gener_bus_kind_cd=blanks 
    ,payer_open_bank_name char(4000) nullif payer_open_bank_name=blanks 
    ,recver_open_bank_name char(4000) nullif recver_open_bank_name=blanks 
    ,charge_way_cd char(4000) nullif charge_way_cd=blanks 
    ,e_acct_cd char(4000) nullif e_acct_cd=blanks 
    ,next_day_tran_flg char(4000) nullif next_day_tran_flg=blanks 
    ,auto_refund_flg char(4000) nullif auto_refund_flg=blanks 
    ,auto_refund_cnt char(4000) nullif auto_refund_cnt=blanks 
    ,vtual_acct_bind_acct char(4000) nullif vtual_acct_bind_acct=blanks 
    ,vtual_acct_bind_acct_name char(4000) nullif vtual_acct_bind_acct_name=blanks 
    ,acct_type_cd char(4000) nullif acct_type_cd=blanks 
    ,vtual_open_acct_org_id char(4000) nullif vtual_open_acct_org_id=blanks 
    ,last_debit_rtn_rcpt_status_cd char(4000) nullif last_debit_rtn_rcpt_status_cd=blanks 
    ,last_tran_status_cd char(4000) nullif last_tran_status_cd=blanks 
    ,acct_gen_cd char(4000) nullif acct_gen_cd=blanks 
    ,lmt_order_no char(4000) nullif lmt_order_no=blanks 
    ,bind_flg char(4000) nullif bind_flg=blanks 
    ,ova_flow_num char(4000) nullif ova_flow_num=blanks 
    ,esb_intfc_return_code char(4000) nullif esb_intfc_return_code=blanks 
    ,esb_intfc_return_info char(4000) nullif esb_intfc_return_info=blanks 
    ,esb_intfc_tran_flow_num char(4000) nullif esb_intfc_tran_flow_num=blanks 
    ,send_pbc_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif send_pbc_tm=blanks 
    ,src_table_name char(4000) nullif src_table_name=blanks 
)