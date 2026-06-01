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
infile '${data_path}/pams_khfa_khzbpz.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pams_khfa_khzbpz
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,fabh char(4000) nullif fabh=blanks 
    ,khzbdh char(4000) nullif khzbdh=blanks 
    ,wdmc char(4000) nullif wdmc=blanks 
    ,wdqz char(4000) nullif wdqz=blanks 
    ,zbqz char(4000) nullif zbqz=blanks 
    ,jldw char(4000) nullif jldw=blanks 
    ,bdz char(4000) nullif bdz=blanks 
    ,fdz char(4000) nullif fdz=blanks 
    ,mbbh char(4000) nullif mbbh=blanks 
    ,qjlx char(4000) nullif qjlx=blanks 
    ,jsfs char(4000) nullif jsfs=blanks 
    ,xh char(4000) nullif xh=blanks 
    ,tlbl char(4000) nullif tlbl=blanks 
    ,tjcx char(4000) nullif tjcx=blanks 
    ,xmmc char(4000) nullif xmmc=blanks 
    ,zswdqz char(4000) nullif zswdqz=blanks 
    ,zszbqz char(4000) nullif zszbqz=blanks 
    ,pjbh char(4000) nullif pjbh=blanks 
    ,khnr char(4000) nullif khnr=blanks 
)