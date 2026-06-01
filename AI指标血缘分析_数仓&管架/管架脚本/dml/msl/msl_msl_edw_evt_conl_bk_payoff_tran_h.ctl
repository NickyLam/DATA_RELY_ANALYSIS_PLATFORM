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
infile '${data_path}/evt_conl_bk_payoff_tran_h.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_evt_conl_bk_payoff_tran_h
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,evt_id char(4000) nullif evt_id=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,batch_id char(4000) nullif batch_id=blanks 
    ,seq_num char(4000) nullif seq_num=blanks 
    ,cust_id char(4000) nullif cust_id=blanks 
    ,recver_name char(4000) nullif recver_name=blanks 
    ,recver_acct_id char(4000) nullif recver_acct_id=blanks 
    ,payer_name char(4000) nullif payer_name=blanks 
    ,payer_acct_id char(4000) nullif payer_acct_id=blanks 
    ,tran_amt char(4000) nullif tran_amt=blanks 
    ,curr_cd char(4000) nullif curr_cd=blanks 
    ,tran_status_cd char(4000) nullif tran_status_cd=blanks 
    ,tran_dt date "yyyy-mm-dd hh24:mi:ss" nullif tran_dt=blanks 
    ,core_tran_dt date "yyyy-mm-dd hh24:mi:ss" nullif core_tran_dt=blanks 
    ,core_batch_id char(4000) nullif core_batch_id=blanks 
    ,core_flow_num char(4000) nullif core_flow_num=blanks 
    ,remark char(4000) nullif remark=blanks 
    ,recver_ibank_no char(4000) nullif recver_ibank_no=blanks 
    ,recver_open_brac_name char(4000) nullif recver_open_brac_name=blanks 
    ,mobile_no char(4000) nullif mobile_no=blanks 
    ,return_code char(4000) nullif return_code=blanks 
    ,return_info char(4000) nullif return_info=blanks 
    ,err_info char(4000) nullif err_info=blanks 
    ,bank_int_flg char(4000) nullif bank_int_flg=blanks 
    ,emply_id char(4000) nullif emply_id=blanks 
)