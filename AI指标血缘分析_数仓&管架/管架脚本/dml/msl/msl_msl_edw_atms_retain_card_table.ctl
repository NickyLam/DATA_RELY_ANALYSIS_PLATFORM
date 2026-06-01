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
infile '${data_path}/atms_retain_card_table.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_atms_retain_card_table
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,logic_id char(4000) nullif logic_id=blanks 
    ,dev_no char(4000) nullif dev_no=blanks 
    ,retain_date char(4000) nullif retain_date=blanks 
    ,retain_time char(4000) nullif retain_time=blanks 
    ,account char(4000) nullif account=blanks 
    ,reason char(4000) nullif reason=blanks 
    ,period char(4000) nullif period=blanks 
    ,card_stuck_org char(4000) nullif card_stuck_org=blanks 
    ,card_handle_org char(4000) nullif card_handle_org=blanks 
    ,auto_flag char(4000) nullif auto_flag=blanks 
    ,check_op char(4000) nullif check_op=blanks 
    ,check_date char(4000) nullif check_date=blanks 
    ,check_time char(4000) nullif check_time=blanks 
    ,op_no char(4000) nullif op_no=blanks 
    ,op_date char(4000) nullif op_date=blanks 
    ,op_time char(4000) nullif op_time=blanks 
    ,op_address char(4000) nullif op_address=blanks 
    ,account_name char(4000) nullif account_name=blanks 
    ,account_id char(4000) nullif account_id=blanks 
    ,account_phome char(4000) nullif account_phome=blanks 
    ,cert_type char(4000) nullif cert_type=blanks 
    ,status char(4000) nullif status=blanks 
    ,start_dt date "yyyy-mm-dd hh24:mi:ss" nullif start_dt=blanks 
    ,end_dt date "yyyy-mm-dd hh24:mi:ss" nullif end_dt=blanks 
)