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
infile '${data_path}/pams_v_yjzb_jg.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pams_v_yjzb_jg
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,tjrq char(4000) nullif tjrq=blanks 
    ,zbdh char(4000) nullif zbdh=blanks 
    ,sdbs char(4000) nullif sdbs=blanks 
    ,tjkj char(4000) nullif tjkj=blanks 
    ,bz char(4000) nullif bz=blanks 
    ,khdxdh char(4000) nullif khdxdh=blanks 
    ,zbz char(4000) nullif zbz=blanks 
)