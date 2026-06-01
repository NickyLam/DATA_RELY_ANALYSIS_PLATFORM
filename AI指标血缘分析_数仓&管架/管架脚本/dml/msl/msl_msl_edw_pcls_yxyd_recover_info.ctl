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
infile '${data_path}/pcls_yxyd_recover_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pcls_yxyd_recover_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,month_loan char(4000) nullif month_loan=blanks 
    ,loan_amt char(4000) nullif loan_amt=blanks 
    ,m1_amt char(4000) nullif m1_amt=blanks 
    ,m2_amt char(4000) nullif m2_amt=blanks 
    ,m3_amt char(4000) nullif m3_amt=blanks 
    ,m3plus_amt char(4000) nullif m3plus_amt=blanks 
    ,m1_recover_amt char(4000) nullif m1_recover_amt=blanks 
    ,m2_recover_amt char(4000) nullif m2_recover_amt=blanks 
    ,m3_recover_amt char(4000) nullif m3_recover_amt=blanks 
    ,m3plus_recover_amt char(4000) nullif m3plus_recover_amt=blanks 
    ,m1_recover_percent char(4000) nullif m1_recover_percent=blanks 
    ,m2_recover_percent char(4000) nullif m2_recover_percent=blanks 
    ,m3_recover_percent char(4000) nullif m3_recover_percent=blanks 
    ,m3plus_recover_percent char(4000) nullif m3plus_recover_percent=blanks 
)