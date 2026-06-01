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
infile '${data_path}/rrps_rpt_report_result_archive_data.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_rrps_rpt_report_result_archive_data
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,archive_type char(4000) nullif archive_type=blanks 
    ,index_no char(4000) nullif index_no=blanks 
    ,data_date char(4000) nullif data_date=blanks 
    ,org_no char(4000) nullif org_no=blanks 
    ,currency char(4000) nullif currency=blanks 
    ,index_val char(4000) nullif index_val=blanks 
    ,template_id char(4000) nullif template_id=blanks 
    ,sys_time char(4000) nullif sys_time=blanks 
    ,sys_ind char(4000) nullif sys_ind=blanks 
)