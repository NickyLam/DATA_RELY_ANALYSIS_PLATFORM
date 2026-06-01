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
infile '${data_path}/pams_khfa_fapz.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pams_khfa_fapz
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,fabh char(4000) nullif fabh=blanks 
    ,famc char(4000) nullif famc=blanks 
    ,khnf char(4000) nullif khnf=blanks 
    ,khdx char(4000) nullif khdx=blanks 
    ,pzms char(4000) nullif pzms=blanks 
    ,jglb char(4000) nullif jglb=blanks 
    ,hylb char(4000) nullif hylb=blanks 
    ,khzq char(4000) nullif khzq=blanks 
    ,khqs char(4000) nullif khqs=blanks 
    ,yyzlbh char(4000) nullif yyzlbh=blanks 
    ,yybzz char(4000) nullif yybzz=blanks 
    ,yysx char(4000) nullif yysx=blanks 
    ,yyxx char(4000) nullif yyxx=blanks 
    ,zt char(4000) nullif zt=blanks 
    ,czr char(4000) nullif czr=blanks 
    ,czsj timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif czsj=blanks 
)