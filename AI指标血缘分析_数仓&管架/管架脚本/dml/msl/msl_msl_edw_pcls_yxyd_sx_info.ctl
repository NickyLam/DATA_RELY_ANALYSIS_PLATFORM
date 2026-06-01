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
infile '${data_path}/pcls_yxyd_sx_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pcls_yxyd_sx_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,appl_dt char(4000) nullif appl_dt=blanks 
    ,appl_cnt char(4000) nullif appl_cnt=blanks 
    ,final_pass_cnt char(4000) nullif final_pass_cnt=blanks 
    ,final_pass_percent char(4000) nullif final_pass_percent=blanks 
    ,final_pass_credit char(4000) nullif final_pass_credit=blanks 
    ,final_pass_repay char(4000) nullif final_pass_repay=blanks 
    ,appl_pass_cnt char(4000) nullif appl_pass_cnt=blanks 
    ,appl_pass_percent char(4000) nullif appl_pass_percent=blanks 
    ,tele_pass_cnt char(4000) nullif tele_pass_cnt=blanks 
    ,tele_pass_percent char(4000) nullif tele_pass_percent=blanks 
    ,face_pass_cnt char(4000) nullif face_pass_cnt=blanks 
    ,face_pass_percent char(4000) nullif face_pass_percent=blanks 
)