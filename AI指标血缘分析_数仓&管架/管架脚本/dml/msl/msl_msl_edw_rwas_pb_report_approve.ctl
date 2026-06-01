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
infile '${data_path}/rwas_pb_report_approve.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_rwas_pb_report_approve
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,item_cd char(4000) nullif item_cd=blanks 
    ,item_name char(4000) nullif item_name=blanks 
    ,data_date char(4000) nullif data_date=blanks 
    ,solo_no char(4000) nullif solo_no=blanks 
    ,org_cd char(4000) nullif org_cd=blanks 
    ,ccy_cd char(4000) nullif ccy_cd=blanks 
    ,version char(4000) nullif version=blanks 
    ,version_status char(4000) nullif version_status=blanks 
    ,operate_dt char(4000) nullif operate_dt=blanks 
    ,operate_id char(4000) nullif operate_id=blanks 
    ,operate_name char(4000) nullif operate_name=blanks 
    ,flow_starter_id char(4000) nullif flow_starter_id=blanks 
    ,flow_starter_name char(4000) nullif flow_starter_name=blanks 
    ,approve_remark char(4000) nullif approve_remark=blanks 
    ,catalog_id char(4000) nullif catalog_id=blanks 
)