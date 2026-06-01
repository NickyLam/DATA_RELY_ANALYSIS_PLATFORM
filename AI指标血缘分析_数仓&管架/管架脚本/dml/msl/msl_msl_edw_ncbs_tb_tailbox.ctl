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
infile '${data_path}/ncbs_tb_tailbox.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_ncbs_tb_tailbox
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,eod_voucher_equal char(4000) nullif eod_voucher_equal=blanks 
    ,branch char(4000) nullif branch=blanks 
    ,user_id char(4000) nullif user_id=blanks 
    ,company char(4000) nullif company=blanks 
    ,tailbox_id char(4000) nullif tailbox_id=blanks 
    ,tailbox_property char(4000) nullif tailbox_property=blanks 
    ,tailbox_status char(4000) nullif tailbox_status=blanks 
    ,tailbox_type char(4000) nullif tailbox_type=blanks 
    ,create_date date "yyyy-mm-dd hh24:mi:ss" nullif create_date=blanks 
    ,tran_timestamp char(4000) nullif tran_timestamp=blanks 
    ,update_date date "yyyy-mm-dd hh24:mi:ss" nullif update_date=blanks 
    ,assign_user_id char(4000) nullif assign_user_id=blanks 
    ,last_user_id char(4000) nullif last_user_id=blanks 
    ,sod_cash_equal char(4000) nullif sod_cash_equal=blanks 
    ,sod_voucher_equal char(4000) nullif sod_voucher_equal=blanks 
    ,eod_cash_equal char(4000) nullif eod_cash_equal=blanks 
    ,teller_bind_type char(4000) nullif teller_bind_type=blanks 
    ,voucher_equal_timestamp char(4000) nullif voucher_equal_timestamp=blanks 
    ,cash_equal_timestamp char(4000) nullif cash_equal_timestamp=blanks 
    ,tailbox_sub_type char(4000) nullif tailbox_sub_type=blanks 
    ,start_dt date "yyyy-mm-dd hh24:mi:ss" nullif start_dt=blanks 
    ,end_dt date "yyyy-mm-dd hh24:mi:ss" nullif end_dt=blanks 
    ,id_mark char(4000) nullif id_mark=blanks 
)