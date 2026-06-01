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
infile '${data_path}/pams_khdx_jg.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pams_khdx_jg
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,khdxdh char(4000) nullif khdxdh=blanks 
    ,jgdh char(4000) nullif jgdh=blanks 
    ,jgmc char(4000) nullif jgmc=blanks 
    ,jyjgbz char(4000) nullif jyjgbz=blanks 
    ,pxbz char(4000) nullif pxbz=blanks 
    ,zxzt char(4000) nullif zxzt=blanks 
    ,zxrq char(4000) nullif zxrq=blanks 
    ,fhdh char(4000) nullif fhdh=blanks 
    ,fhbz char(4000) nullif fhbz=blanks 
    ,jgdj char(4000) nullif jgdj=blanks 
    ,jgqc char(4000) nullif jgqc=blanks 
    ,start_dt date "yyyy-mm-dd hh24:mi:ss" nullif start_dt=blanks 
    ,end_dt date "yyyy-mm-dd hh24:mi:ss" nullif end_dt=blanks 
    ,id_mark char(4000) nullif id_mark=blanks 
)