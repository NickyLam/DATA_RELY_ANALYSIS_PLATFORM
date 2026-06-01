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
infile '${data_path}/pams_khfa_level_manage.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pams_khfa_level_manage
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,khnf char(4000) nullif khnf=blanks 
    ,fabh char(4000) nullif fabh=blanks 
    ,jg char(4000) nullif jg=blanks 
    ,lx char(4000) nullif lx=blanks 
    ,khzbbh char(4000) nullif khzbbh=blanks 
    ,khpl char(4000) nullif khpl=blanks 
    ,dfly char(4000) nullif dfly=blanks 
    ,xh char(4000) nullif xh=blanks 
    ,czr char(4000) nullif czr=blanks 
    ,czsj date "yyyy-mm-dd hh24:mi:ss" nullif czsj=blanks 
)