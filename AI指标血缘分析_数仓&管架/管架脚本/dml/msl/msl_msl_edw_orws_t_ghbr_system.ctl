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
infile '${data_path}/orws_t_ghbr_system.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_orws_t_ghbr_system
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,ID char(4000) nullif ID=blanks 
    ,SYSTEM_CODE char(4000) nullif SYSTEM_CODE=blanks 
    ,SYSTEM_NAME char(4000) nullif SYSTEM_NAME=blanks 
    ,SERIAL_NUMBER char(4000) nullif SERIAL_NUMBER=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)