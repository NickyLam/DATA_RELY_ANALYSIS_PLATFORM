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
infile '${data_path}/mcs_new_happ_non_dtl.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_rdw_rdw_mcs_new_happ_non_dtl
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,belong_brch char(4000) nullif belong_brch=blanks 
    ,asset_cate char(4000) nullif asset_cate=blanks 
    ,cust_name char(4000) nullif cust_name=blanks 
    ,belong_group char(4000) nullif belong_group=blanks 
    ,bus_breed char(4000) nullif bus_breed=blanks 
    ,bus_bal char(4000) nullif bus_bal=blanks 
    ,level5_cls char(4000) nullif level5_cls=blanks 
    ,next_non_tm date "yyyy-mm-dd hh24:mi:ss" nullif next_non_tm=blanks 
)