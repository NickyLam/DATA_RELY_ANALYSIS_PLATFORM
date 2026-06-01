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
infile '${data_path}/pbss_smg_t_user.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pbss_smg_t_user
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,ID char(4000) nullif ID=blanks 
    ,USER_CODE char(4000) nullif USER_CODE=blanks 
    ,USER_HXYH_CODE char(4000) nullif USER_HXYH_CODE=blanks 
    ,USER_NAME char(4000) nullif USER_NAME=blanks 
    ,BR_CODE char(4000) nullif BR_CODE=blanks 
    ,USER_PASS char(4000) nullif USER_PASS=blanks 
    ,ENCRYPT_PARA char(4000) nullif ENCRYPT_PARA=blanks 
    ,IDENTITY_NO char(4000) nullif IDENTITY_NO=blanks 
    ,SSO_USER_NAME char(4000) nullif SSO_USER_NAME=blanks 
    ,NOTES_MAIL char(4000) nullif NOTES_MAIL=blanks 
    ,EMAIL char(4000) nullif EMAIL=blanks 
    ,TELEPHONE1 char(4000) nullif TELEPHONE1=blanks 
    ,TELEPHONE2 char(4000) nullif TELEPHONE2=blanks 
    ,ADDRESS1 char(4000) nullif ADDRESS1=blanks 
    ,ADDRESS2 char(4000) nullif ADDRESS2=blanks 
    ,USER_STAT char(4000) nullif USER_STAT=blanks 
    ,LOGIN_STAT char(4000) nullif LOGIN_STAT=blanks 
    ,CREATE_TIME date "yyyy-mm-dd hh24:mi:ss" nullif CREATE_TIME=blanks 
    ,CREATOR_ID char(4000) nullif CREATOR_ID=blanks 
    ,DEL_TIME date "yyyy-mm-dd hh24:mi:ss" nullif DEL_TIME=blanks 
    ,DELE_ID char(4000) nullif DELE_ID=blanks 
    ,MODIFY_TIME timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif MODIFY_TIME=blanks 
    ,MODI_ID char(4000) nullif MODI_ID=blanks 
    ,LAST_PASS_TIME date "yyyy-mm-dd hh24:mi:ss" nullif LAST_PASS_TIME=blanks 
    ,AUTH_METHOD char(4000) nullif AUTH_METHOD=blanks 
)