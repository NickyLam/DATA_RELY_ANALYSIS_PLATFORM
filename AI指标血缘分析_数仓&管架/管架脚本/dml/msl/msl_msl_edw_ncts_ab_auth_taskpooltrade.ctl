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
infile '${data_path}/ncts_ab_auth_taskpooltrade.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_ncts_ab_auth_taskpooltrade
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,AUTHORGNO char(4000) nullif AUTHORGNO=blanks 
    ,TASKPOOLID char(4000) nullif TASKPOOLID=blanks 
    ,CHANNELCODE char(4000) nullif CHANNELCODE=blanks 
    ,TRADECODE char(4000) nullif TRADECODE=blanks 
)