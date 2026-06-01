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
infile '${data_path}/pcls_byte_sj_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pcls_byte_sj_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,reject_reason_big char(4000) nullif reject_reason_big=blanks 
    ,sx_reject_reason_tag char(4000) nullif sx_reject_reason_tag=blanks 
    ,reject_reason_small char(4000) nullif reject_reason_small=blanks 
    ,t_1_cnt char(4000) nullif t_1_cnt=blanks 
    ,t_2_cnt char(4000) nullif t_2_cnt=blanks 
    ,t_3_cnt char(4000) nullif t_3_cnt=blanks 
    ,t_4_cnt char(4000) nullif t_4_cnt=blanks 
    ,t_5_cnt char(4000) nullif t_5_cnt=blanks 
    ,t_6_cnt char(4000) nullif t_6_cnt=blanks 
    ,t_7_cnt char(4000) nullif t_7_cnt=blanks 
)