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
infile '${data_path}/cmm_teller_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_cmm_teller_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,teller_id char(4000) nullif teller_id=blanks 
    ,teller_name char(4000) nullif teller_name=blanks 
    ,teller_type_cd char(4000) nullif teller_type_cd=blanks 
    ,teller_status_cd char(4000) nullif teller_status_cd=blanks 
    ,teller_user_lev_cd char(4000) nullif teller_user_lev_cd=blanks 
    ,teller_prvlg_lev_cd char(4000) nullif teller_prvlg_lev_cd=blanks 
    ,belong_org_id char(4000) nullif belong_org_id=blanks 
    ,jobs_cd char(4000) nullif jobs_cd=blanks 
    ,jobs_cate char(4000) nullif jobs_cate=blanks 
    ,jobs_name char(4000) nullif jobs_name=blanks 
    ,empyt_dt date "yyyy-mm-dd hh24:mi:ss" nullif empyt_dt=blanks 
    ,cust_mgr_flg char(4000) nullif cust_mgr_flg=blanks 
    ,enty_teller_flg char(4000) nullif enty_teller_flg=blanks 
    ,syn_teller_flg char(4000) nullif syn_teller_flg=blanks 
    ,super_teller_flg char(4000) nullif super_teller_flg=blanks 
    ,acct_teller_flg char(4000) nullif acct_teller_flg=blanks 
    ,prvlg_mgmt_flg char(4000) nullif prvlg_mgmt_flg=blanks 
    ,director_mgmt_flg char(4000) nullif director_mgmt_flg=blanks 
    ,crdt_cust_mgr_flg char(4000) nullif crdt_cust_mgr_flg=blanks 
    ,wah_kepr_flg char(4000) nullif wah_kepr_flg=blanks 
    ,auth_flg char(4000) nullif auth_flg=blanks 
    ,auth_range char(4000) nullif auth_range=blanks 
    ,cors_moy_box_id char(4000) nullif cors_moy_box_id=blanks 
    ,teller_type_subclass_cd char(4000) nullif teller_type_subclass_cd=blanks 
)