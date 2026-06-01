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
infile '${data_path}/pams_khfa_khzb_jg.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pams_khfa_khzb_jg
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,khzbdh char(4000) nullif khzbdh=blanks 
    ,khzbmc char(4000) nullif khzbmc=blanks 
    ,zbdh char(4000) nullif zbdh=blanks 
    ,sdbs char(4000) nullif sdbs=blanks 
    ,bz char(4000) nullif bz=blanks 
    ,tjkj char(4000) nullif tjkj=blanks 
    ,zbpx char(4000) nullif zbpx=blanks 
    ,ydsfzs char(4000) nullif ydsfzs=blanks 
    ,ydbm char(4000) nullif ydbm=blanks 
    ,start_dt date "yyyy-mm-dd hh24:mi:ss" nullif start_dt=blanks 
    ,end_dt date "yyyy-mm-dd hh24:mi:ss" nullif end_dt=blanks 
    ,id_mark char(4000) nullif id_mark=blanks 
)