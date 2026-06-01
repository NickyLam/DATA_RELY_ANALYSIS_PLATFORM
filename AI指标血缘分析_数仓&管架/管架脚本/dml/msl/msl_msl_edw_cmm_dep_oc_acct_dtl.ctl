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
infile '${data_path}/cmm_dep_oc_acct_dtl.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,oc_acct_flow_num char(4000) nullif oc_acct_flow_num=blanks 
    ,ova_chn_flow_num char(4000) nullif ova_chn_flow_num=blanks 
    ,tran_flow_num char(4000) nullif tran_flow_num=blanks 
    ,tran_dt date "yyyy-mm-dd hh24:mi:ss" nullif tran_dt=blanks 
    ,acct_id char(4000) nullif acct_id=blanks 
    ,acct_name char(4000) nullif acct_name=blanks 
    ,open_vouch_id char(4000) nullif open_vouch_id=blanks 
    ,dep_prod_acct_id char(4000) nullif dep_prod_acct_id=blanks 
    ,belong_org_id char(4000) nullif belong_org_id=blanks 
    ,tran_org_id char(4000) nullif tran_org_id=blanks 
    ,sav_type_cd char(4000) nullif sav_type_cd=blanks 
    ,dep_term_cd char(4000) nullif dep_term_cd=blanks 
    ,open_vouch_type_cd char(4000) nullif open_vouch_type_cd=blanks 
    ,proc_status_cd char(4000) nullif proc_status_cd=blanks 
    ,chn_cd char(4000) nullif chn_cd=blanks 
    ,curr_cd char(4000) nullif curr_cd=blanks 
    ,operr_cert_type_cd char(4000) nullif operr_cert_type_cd=blanks 
    ,operr_cert_no char(4000) nullif operr_cert_no=blanks 
    ,operr_mobile_no char(4000) nullif operr_mobile_no=blanks 
    ,operr_info_invalid_dt date "yyyy-mm-dd hh24:mi:ss" nullif operr_info_invalid_dt=blanks 
    ,ec_flg char(4000) nullif ec_flg=blanks 
    ,oc_acct_flg char(4000) nullif oc_acct_flg=blanks 
    ,strk_bal_flg char(4000) nullif strk_bal_flg=blanks 
    ,tran_amt char(4000) nullif tran_amt=blanks 
    ,sub_acct_id char(4000) nullif sub_acct_id=blanks 
    ,agent_idf_cd char(4000) nullif agent_idf_cd=blanks 
    ,agent_name char(4000) nullif agent_name=blanks 
    ,agent_cert_type_cd char(4000) nullif agent_cert_type_cd=blanks 
    ,agent_cert_no char(4000) nullif agent_cert_no=blanks 
    ,agent_cert_start_dt date "yyyy-mm-dd hh24:mi:ss" nullif agent_cert_start_dt=blanks 
    ,agent_cert_exp_dt date "yyyy-mm-dd hh24:mi:ss" nullif agent_cert_exp_dt=blanks 
    ,old_sub_acct_id char(4000) nullif old_sub_acct_id=blanks 
    ,old_dep_prod_acct_id char(4000) nullif old_dep_prod_acct_id=blanks 
    ,tran_teller_id char(4000) nullif tran_teller_id=blanks 
    ,dep_term_tenor_type_cd char(4000) nullif dep_term_tenor_type_cd=blanks 
    ,agent_phone char(4000) nullif agent_phone=blanks 
    ,agent_licen_issue_autho_site char(4000) nullif agent_licen_issue_autho_site=blanks 
)