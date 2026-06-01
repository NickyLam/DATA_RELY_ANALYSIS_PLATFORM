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
infile '${data_path}/pcls_byte_repay_bucket.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pcls_byte_repay_bucket
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,repay_area char(4000) nullif repay_area=blanks 
    ,datecreated1 char(4000) nullif datecreated1=blanks 
    ,appl_cnt char(4000) nullif appl_cnt=blanks 
    ,appl_pass_cnt char(4000) nullif appl_pass_cnt=blanks 
    ,appl_pass_percent char(4000) nullif appl_pass_percent=blanks 
)