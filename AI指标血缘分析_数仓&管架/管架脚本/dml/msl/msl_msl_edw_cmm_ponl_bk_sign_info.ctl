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
infile '${data_path}/cmm_ponl_bk_sign_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,cust_id char(4000) nullif cust_id=blanks 
    ,user_id char(4000) nullif user_id=blanks 
    ,onl_bank_cust_status_cd char(4000) nullif onl_bank_cust_status_cd=blanks 
    ,open_acct_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif open_acct_tm=blanks 
    ,clos_acct_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif clos_acct_tm=blanks 
    ,ghb_emply_flg char(4000) nullif ghb_emply_flg=blanks 
    ,cust_cn_name char(4000) nullif cust_cn_name=blanks 
    ,cust_en_name char(4000) nullif cust_en_name=blanks 
    ,cert_type_cd char(4000) nullif cert_type_cd=blanks 
    ,cert_no char(4000) nullif cert_no=blanks 
    ,cont_addr char(4000) nullif cont_addr=blanks 
    ,phone char(4000) nullif phone=blanks 
    ,zip_cd char(4000) nullif zip_cd=blanks 
    ,mobile_no char(4000) nullif mobile_no=blanks 
    ,gender_cd char(4000) nullif gender_cd=blanks 
    ,work_unit_tel char(4000) nullif work_unit_tel=blanks 
    ,open_bank_id char(4000) nullif open_bank_id=blanks 
    ,open_bank_name char(4000) nullif open_bank_name=blanks 
    ,open_acct_brch_id char(4000) nullif open_acct_brch_id=blanks 
    ,open_acct_brch_name char(4000) nullif open_acct_brch_name=blanks 
    ,open_acct_org_id char(4000) nullif open_acct_org_id=blanks 
    ,open_acct_org_name char(4000) nullif open_acct_org_name=blanks 
    ,cty char(4000) nullif cty=blanks 
)