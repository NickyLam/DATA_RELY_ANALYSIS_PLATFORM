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
infile '${data_path}/pcls_byte_dz_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pcls_byte_dz_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,draw_dt char(4000) nullif draw_dt=blanks 
    ,draw_cnt char(4000) nullif draw_cnt=blanks 
    ,draw_pass_cnt char(4000) nullif draw_pass_cnt=blanks 
    ,draw_pass_percent char(4000) nullif draw_pass_percent=blanks 
    ,loan_amt char(4000) nullif loan_amt=blanks 
    ,loan_amt_avg char(4000) nullif loan_amt_avg=blanks 
    ,loan_bal char(4000) nullif loan_bal=blanks 
)