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
infile '${data_path}/cmm_dep_acct_attach_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_cmm_dep_acct_attach_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,acct_id char(4000) nullif acct_id=blanks 
    ,acct_name char(4000) nullif acct_name=blanks 
    ,cust_id char(4000) nullif cust_id=blanks 
    ,src_agt_id char(4000) nullif src_agt_id=blanks 
    ,fx_acct_char_cd char(4000) nullif fx_acct_char_cd=blanks 
    ,agt_dep_type_cd char(4000) nullif agt_dep_type_cd=blanks 
    ,acct_lics_num char(4000) nullif acct_lics_num=blanks 
    ,acct_lics_issue_dt date "yyyy-mm-dd hh24:mi:ss" nullif acct_lics_issue_dt=blanks 
    ,cap_char_cd char(4000) nullif cap_char_cd=blanks 
    ,acct_close_rs_descb char(4000) nullif acct_close_rs_descb=blanks 
    ,l_six_m_no_tran_flg char(4000) nullif l_six_m_no_tran_flg=blanks 
    ,supv_type_cd char(4000) nullif supv_type_cd=blanks 
    ,xhc_flg char(4000) nullif xhc_flg=blanks 
    ,long_hang_amt char(4000) nullif long_hang_amt=blanks 
    ,init_open_acct_dt date "yyyy-mm-dd hh24:mi:ss" nullif init_open_acct_dt=blanks 
    ,init_exp_dt date "yyyy-mm-dd hh24:mi:ss" nullif init_exp_dt=blanks 
    ,sub_acct_int_rat_float_ratio char(4000) nullif sub_acct_int_rat_float_ratio=blanks 
    ,sub_acct_int_rat_float_point char(4000) nullif sub_acct_int_rat_float_point=blanks 
    ,delay_pay_int_int_float_point char(4000) nullif delay_pay_int_int_float_point=blanks 
    ,txy_main_agt_files_int_rat char(4000) nullif txy_main_agt_files_int_rat=blanks 
    ,txy_sub_agt_agree_int_rat char(4000) nullif txy_sub_agt_agree_int_rat=blanks 
    ,cap_pool_agt_rat char(4000) nullif cap_pool_agt_rat=blanks 
    ,cert_print_flg char(4000) nullif cert_print_flg=blanks 
    ,precon_wdraw_flg char(4000) nullif precon_wdraw_flg=blanks 
    ,precon_wdraw_dt date "yyyy-mm-dd hh24:mi:ss" nullif precon_wdraw_dt=blanks 
    ,apot_tenor_start_dt date "yyyy-mm-dd hh24:mi:ss" nullif apot_tenor_start_dt=blanks 
    ,apot_tenor_end_dt date "yyyy-mm-dd hh24:mi:ss" nullif apot_tenor_end_dt=blanks 
    ,heat_insu_acct_flg char(4000) nullif heat_insu_acct_flg=blanks 
    ,travel_card_acct_flg char(4000) nullif travel_card_acct_flg=blanks 
    ,soci_secu_fin_acct_flg char(4000) nullif soci_secu_fin_acct_flg=blanks 
    ,supv_idf_set_dt date "yyyy-mm-dd hh24:mi:ss" nullif supv_idf_set_dt=blanks 
    ,supv_idf_cancel_dt date "yyyy-mm-dd hh24:mi:ss" nullif supv_idf_cancel_dt=blanks 
    ,int_rat_apv_form_odd_no char(4000) nullif int_rat_apv_form_odd_no=blanks 
)