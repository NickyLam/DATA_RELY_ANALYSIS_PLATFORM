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
infile '${data_path}/ncbs_tb_voucher_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_ncbs_tb_voucher_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,branch char(4000) nullif branch=blanks 
    ,ccy char(4000) nullif ccy=blanks 
    ,doc_type char(4000) nullif doc_type=blanks 
    ,remark char(4000) nullif remark=blanks 
    ,voucher_status char(4000) nullif voucher_status=blanks 
    ,company char(4000) nullif company=blanks 
    ,prefix char(4000) nullif prefix=blanks 
    ,tailbox_id char(4000) nullif tailbox_id=blanks 
    ,voucher_id char(4000) nullif voucher_id=blanks 
    ,voucher_sum char(4000) nullif voucher_sum=blanks 
    ,tran_timestamp char(4000) nullif tran_timestamp=blanks 
    ,update_date date "yyyy-mm-dd hh24:mi:ss" nullif update_date=blanks 
    ,last_user_id char(4000) nullif last_user_id=blanks 
    ,tran_amt char(4000) nullif tran_amt=blanks 
    ,voucher_end_no char(4000) nullif voucher_end_no=blanks 
    ,voucher_start_no char(4000) nullif voucher_start_no=blanks 
    ,start_dt date "yyyy-mm-dd hh24:mi:ss" nullif start_dt=blanks 
    ,end_dt date "yyyy-mm-dd hh24:mi:ss" nullif end_dt=blanks 
    ,id_mark char(4000) nullif id_mark=blanks 
)