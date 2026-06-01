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
infile '${data_path}/evt_scps_corp_bus_flow.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_evt_scps_corp_bus_flow
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,evt_id char(4000) nullif evt_id=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,task_no char(4000) nullif task_no=blanks 
    ,ova_flow_num char(4000) nullif ova_flow_num=blanks 
    ,cust_open_acct_dt date "yyyy-mm-dd hh24:mi:ss" nullif cust_open_acct_dt=blanks 
    ,org_id char(4000) nullif org_id=blanks 
    ,teller_id char(4000) nullif teller_id=blanks 
    ,open_acct_status_cd char(4000) nullif open_acct_status_cd=blanks 
    ,temp_acct_valid_dt date "yyyy-mm-dd hh24:mi:ss" nullif temp_acct_valid_dt=blanks 
    ,super_corp_name char(4000) nullif super_corp_name=blanks 
    ,super_director_cert_type_cd char(4000) nullif super_director_cert_type_cd=blanks 
    ,super_director_cert_no char(4000) nullif super_director_cert_no=blanks 
    ,depositr_name char(4000) nullif depositr_name=blanks 
    ,pre_proc_id char(4000) nullif pre_proc_id=blanks 
    ,fst_proof_doc_type_cd char(4000) nullif fst_proof_doc_type_cd=blanks 
    ,fst_proof_doc_id char(4000) nullif fst_proof_doc_id=blanks 
    ,fst_proof_doc_exp_dt date "yyyy-mm-dd hh24:mi:ss" nullif fst_proof_doc_exp_dt=blanks 
    ,fst_cert_type_cd char(4000) nullif fst_cert_type_cd=blanks 
    ,bus_flow_set char(4000) nullif bus_flow_set=blanks 
    ,sign_mobile_no char(4000) nullif sign_mobile_no=blanks 
    ,bkcp_seal_way_cd char(4000) nullif bkcp_seal_way_cd=blanks 
    ,post_addr_desc char(4000) nullif post_addr_desc=blanks 
    ,bkcp_zip_cd char(4000) nullif bkcp_zip_cd=blanks 
    ,bkcp_cotas char(4000) nullif bkcp_cotas=blanks 
    ,bkcp_phone_num char(4000) nullif bkcp_phone_num=blanks 
    ,bkcp_check_entry_way_cd char(4000) nullif bkcp_check_entry_way_cd=blanks 
    ,bkcp_check_entry_ped_cd char(4000) nullif bkcp_check_entry_ped_cd=blanks 
    ,y_acm_lmt char(4000) nullif y_acm_lmt=blanks 
    ,daily_accum_lmt char(4000) nullif daily_accum_lmt=blanks 
    ,daily_accum_cnt char(4000) nullif daily_accum_cnt=blanks 
    ,basic_serv_appl_type_cd char(4000) nullif basic_serv_appl_type_cd=blanks 
    ,verify_type_cd char(4000) nullif verify_type_cd=blanks 
    ,checker_seq_num char(4000) nullif checker_seq_num=blanks 
    ,cap_verify_teller_id char(4000) nullif cap_verify_teller_id=blanks 
    ,legal_rep_mobile_no char(4000) nullif legal_rep_mobile_no=blanks 
    ,legal_rep_fixline_tel_num char(4000) nullif legal_rep_fixline_tel_num=blanks 
    ,fin_princ_name char(4000) nullif fin_princ_name=blanks 
    ,fin_princ_mobile_no char(4000) nullif fin_princ_mobile_no=blanks 
    ,fin_princ_fixline_tel_num char(4000) nullif fin_princ_fixline_tel_num=blanks 
    ,org_name char(4000) nullif org_name=blanks 
    ,org_addr char(4000) nullif org_addr=blanks 
    ,legal_rep_name char(4000) nullif legal_rep_name=blanks 
    ,main_acct_id char(4000) nullif main_acct_id=blanks 
    ,corp_stop_pay_status_cd char(4000) nullif corp_stop_pay_status_cd=blanks 
    ,acct_id char(4000) nullif acct_id=blanks 
    ,cust_id char(4000) nullif cust_id=blanks 
    ,cust_name char(4000) nullif cust_name=blanks 
    ,corp_acct_char_cd char(4000) nullif corp_acct_char_cd=blanks 
    ,visit_serv_flg char(4000) nullif visit_serv_flg=blanks 
    ,apprv_way_cd char(4000) nullif apprv_way_cd=blanks 
    ,acct_actv_idf_cd char(4000) nullif acct_actv_idf_cd=blanks 
    ,corp_bus_type_cd char(4000) nullif corp_bus_type_cd=blanks 
    ,share_seal_flg char(4000) nullif share_seal_flg=blanks 
    ,back_check_flg char(4000) nullif back_check_flg=blanks 
    ,agent_flg char(4000) nullif agent_flg=blanks 
    ,agent_name char(4000) nullif agent_name=blanks 
    ,agent_cert_type char(4000) nullif agent_cert_type=blanks 
    ,agent_cert_no char(4000) nullif agent_cert_no=blanks 
    ,agent_tel_num char(4000) nullif agent_tel_num=blanks 
    ,agent_cert_vp date "yyyy-mm-dd hh24:mi:ss" nullif agent_cert_vp=blanks 
    ,corp_proc_status_cd char(4000) nullif corp_proc_status_cd=blanks 
    ,cust_clos_acct_dt date "yyyy-mm-dd hh24:mi:ss" nullif cust_clos_acct_dt=blanks 
    ,double_remote_flg char(4000) nullif double_remote_flg=blanks 
    ,open_acct_chn_id char(4000) nullif open_acct_chn_id=blanks 
    ,check_teller_id char(4000) nullif check_teller_id=blanks 
    ,blip_batch_no char(4000) nullif blip_batch_no=blanks 
    ,apprv_flg char(4000) nullif apprv_flg=blanks 
    ,rg_cd char(4000) nullif rg_cd=blanks 
    ,rgst_cap_curr_cd char(4000) nullif rgst_cap_curr_cd=blanks 
    ,super_lp_org_cd char(4000) nullif super_lp_org_cd=blanks 
    ,super_director_corp_post_type_cd char(4000) nullif super_director_corp_post_type_cd=blanks 
    ,recd_type_cd char(4000) nullif recd_type_cd=blanks 
    ,backup_cmplt_flg char(4000) nullif backup_cmplt_flg=blanks 
    ,pass_rapvrfction_flg char(4000) nullif pass_rapvrfction_flg=blanks 
    ,bus_lics_found_dt date "yyyy-mm-dd hh24:mi:ss" nullif bus_lics_found_dt=blanks 
    ,acct_name char(4000) nullif acct_name=blanks 
    ,rgst_addr char(4000) nullif rgst_addr=blanks 
    ,work_addr char(4000) nullif work_addr=blanks 
    ,mang_range_descb char(4000) nullif mang_range_descb=blanks 
    ,dist_cd char(4000) nullif dist_cd=blanks 
    ,rgst_cap char(4000) nullif rgst_cap=blanks 
    ,legal_rep_cert_no char(4000) nullif legal_rep_cert_no=blanks 
    ,legal_rep_cert_type_cd char(4000) nullif legal_rep_cert_type_cd=blanks 
    ,acct_open_acct_lics_apprv_num char(4000) nullif acct_open_acct_lics_apprv_num=blanks 
    ,depositr_cate_cd char(4000) nullif depositr_cate_cd=blanks 
    ,cust_mgr_teller_id char(4000) nullif cust_mgr_teller_id=blanks 
)