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
infile '${data_path}/atms_dev_cash_clear.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_atms_dev_cash_clear
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,dev_no char(4000) nullif dev_no=blanks 
    ,addcash_id char(4000) nullif addcash_id=blanks 
    ,addcash_datetime char(4000) nullif addcash_datetime=blanks 
    ,addcash_amount char(4000) nullif addcash_amount=blanks 
    ,addcash_type char(4000) nullif addcash_type=blanks 
    ,addcash_count char(4000) nullif addcash_count=blanks 
    ,clear_datetime char(4000) nullif clear_datetime=blanks 
    ,addcash_left char(4000) nullif addcash_left=blanks 
    ,addcash_lastamount char(4000) nullif addcash_lastamount=blanks 
    ,addcash_retractcount char(4000) nullif addcash_retractcount=blanks 
    ,deposit_count char(4000) nullif deposit_count=blanks 
    ,deposit_amount char(4000) nullif deposit_amount=blanks 
    ,withdraw_count char(4000) nullif withdraw_count=blanks 
    ,withdraw_amount char(4000) nullif withdraw_amount=blanks 
    ,clear_id char(4000) nullif clear_id=blanks 
    ,cashutil_amount char(4000) nullif cashutil_amount=blanks 
    ,cashby_handcount char(4000) nullif cashby_handcount=blanks 
    ,add_id char(4000) nullif add_id=blanks 
    ,start_dt date "yyyy-mm-dd hh24:mi:ss" nullif start_dt=blanks 
    ,end_dt date "yyyy-mm-dd hh24:mi:ss" nullif end_dt=blanks 
    ,id_mark char(4000) nullif id_mark=blanks 
)