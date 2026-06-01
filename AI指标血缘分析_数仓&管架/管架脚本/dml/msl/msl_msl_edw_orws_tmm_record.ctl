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
infile '${data_path}/orws_tmm_record.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_orws_tmm_record
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,ID char(4000) nullif ID=blanks 
    ,MODEL_ID char(4000) nullif MODEL_ID=blanks 
    ,BIZ_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif BIZ_DATE=blanks 
    ,EXEC_STATUS char(4000) nullif EXEC_STATUS=blanks 
    ,CREATE_TIME timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif CREATE_TIME=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)