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
infile '${data_path}/pbss_cfg_t_biz_code.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pbss_cfg_t_biz_code
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,id char(4000) nullif id=blanks 
    ,biz_code char(4000) nullif biz_code=blanks 
    ,biz_name char(4000) nullif biz_name=blanks 
    ,eft_date date "yyyy-mm-dd hh24:mi:ss" nullif eft_date=blanks 
    ,biz_property char(4000) nullif biz_property=blanks 
    ,is_auto_priority char(4000) nullif is_auto_priority=blanks 
    ,pre_setup_point char(4000) nullif pre_setup_point=blanks 
    ,pre_setup_priority char(4000) nullif pre_setup_priority=blanks 
    ,time_len char(4000) nullif time_len=blanks 
    ,timeout_priority char(4000) nullif timeout_priority=blanks 
    ,time_limit char(4000) nullif time_limit=blanks 
    ,timelimit_priority char(4000) nullif timelimit_priority=blanks 
    ,kind_code char(4000) nullif kind_code=blanks 
    ,order_no char(4000) nullif order_no=blanks 
    ,is_display char(4000) nullif is_display=blanks 
    ,start_dt date "yyyy-mm-dd hh24:mi:ss" nullif start_dt=blanks 
    ,end_dt date "yyyy-mm-dd hh24:mi:ss" nullif end_dt=blanks 
    ,id_mark char(4000) nullif id_mark=blanks 
)