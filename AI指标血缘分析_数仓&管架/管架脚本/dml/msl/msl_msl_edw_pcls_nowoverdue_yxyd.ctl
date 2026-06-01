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
infile '${data_path}/pcls_nowoverdue_yxyd.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pcls_nowoverdue_yxyd
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,datecreated char(4000) nullif datecreated=blanks 
    ,loan_bal char(4000) nullif loan_bal=blanks 
    ,loan_cnt char(4000) nullif loan_cnt=blanks 
    ,dpd3plus_cnt char(4000) nullif dpd3plus_cnt=blanks 
    ,dpd3plus_amt char(4000) nullif dpd3plus_amt=blanks 
    ,dpd3plus_amt_percent char(4000) nullif dpd3plus_amt_percent=blanks 
    ,dpd7plus_cnt char(4000) nullif dpd7plus_cnt=blanks 
    ,dpd7plus_amt char(4000) nullif dpd7plus_amt=blanks 
    ,dpd7plus_amt_percent char(4000) nullif dpd7plus_amt_percent=blanks 
    ,dpd30plus_cnt char(4000) nullif dpd30plus_cnt=blanks 
    ,dpd30plus_amt char(4000) nullif dpd30plus_amt=blanks 
    ,dpd30plus_amt_percent char(4000) nullif dpd30plus_amt_percent=blanks 
    ,dpd90plus_cnt char(4000) nullif dpd90plus_cnt=blanks 
    ,dpd90plus_amt char(4000) nullif dpd90plus_amt=blanks 
    ,dpd90plus_amt_percent char(4000) nullif dpd90plus_amt_percent=blanks 
)