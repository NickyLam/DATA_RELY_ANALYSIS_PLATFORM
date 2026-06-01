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
infile '${data_path}/orws_tmm_result.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_orws_tmm_result
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,ID char(4000) nullif ID=blanks 
    ,COMMISSIONING_ID char(4000) nullif COMMISSIONING_ID=blanks 
    ,BIZ_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif BIZ_DATE=blanks 
    ,BIZ_ORGAN_ID char(4000) nullif BIZ_ORGAN_ID=blanks 
    ,BIZ_EMP_NO char(4000) nullif BIZ_EMP_NO=blanks 
    ,IMG_INFO char(4000) nullif IMG_INFO=blanks 
    ,FOUND_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif FOUND_DATE=blanks 
    ,HANDLE_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif HANDLE_DATE=blanks 
    ,HANDLE_USER_ID char(4000) nullif HANDLE_USER_ID=blanks 
    ,HANDLE_POSITION_ID char(4000) nullif HANDLE_POSITION_ID=blanks 
    ,HANDLE_ORGAN_ID char(4000) nullif HANDLE_ORGAN_ID=blanks 
    ,HANDLE_RESULT char(4000) nullif HANDLE_RESULT=blanks 
    ,BIZ_INFO char(4000) nullif BIZ_INFO=blanks 
    ,CANCEL_REASON char(4000) nullif CANCEL_REASON=blanks 
    ,PROBLEM_ID char(4000) nullif PROBLEM_ID=blanks 
    ,PROBLEM_STATE char(4000) nullif PROBLEM_STATE=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)