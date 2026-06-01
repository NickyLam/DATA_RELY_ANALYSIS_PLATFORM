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
infile '${data_path}/pams_khdx_zb.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pams_khdx_zb
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,zbdh char(4000) nullif zbdh=blanks 
    ,zbmc char(4000) nullif zbmc=blanks 
    ,zbdw char(4000) nullif zbdw=blanks 
    ,zbjb char(4000) nullif zbjb=blanks 
    ,whfs char(4000) nullif whfs=blanks 
    ,sfxs char(4000) nullif sfxs=blanks 
    ,ddsx char(4000) nullif ddsx=blanks 
    ,zbpx char(4000) nullif zbpx=blanks 
    ,zbcc char(4000) nullif zbcc=blanks 
    ,ddlb char(4000) nullif ddlb=blanks 
    ,jspl char(4000) nullif jspl=blanks 
    ,sjzb char(4000) nullif sjzb=blanks 
    ,zbzt char(4000) nullif zbzt=blanks 
    ,dlbz char(4000) nullif dlbz=blanks 
    ,xszbdh char(4000) nullif xszbdh=blanks 
    ,kzlx char(4000) nullif kzlx=blanks 
    ,start_dt date "yyyy-mm-dd hh24:mi:ss" nullif start_dt=blanks 
    ,end_dt date "yyyy-mm-dd hh24:mi:ss" nullif end_dt=blanks 
    ,id_mark char(4000) nullif id_mark=blanks 
)