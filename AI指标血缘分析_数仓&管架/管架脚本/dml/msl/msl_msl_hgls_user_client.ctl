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
infile '${data_path}/hgls_user_client.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_hgls_user_client
fields terminated by x'1b' 
trailing nullcols
(
    CLIENT_ID char(4000) nullif CLIENT_ID=blanks 
    ,ENTERPRISE_CODE char(4000) nullif ENTERPRISE_CODE=blanks 
    ,USER_NAME char(4000) nullif USER_NAME=blanks 
    ,NAME char(4000) nullif NAME=blanks 
    ,SEX char(4000) nullif SEX=blanks 
    ,TELEPHONE char(4000) nullif TELEPHONE=blanks 
    ,PASSWORD char(4000) nullif PASSWORD=blanks 
    ,EMAIL char(4000) nullif EMAIL=blanks 
    ,ACCOUNT char(4000) nullif ACCOUNT=blanks 
    ,STATUS char(4000) nullif STATUS=blanks 
    ,AVAILABLE char(4000) nullif AVAILABLE=blanks 
    ,BRANCH_CODE char(4000) nullif BRANCH_CODE=blanks 
    ,SYSTEM_TYPE char(4000) nullif SYSTEM_TYPE=blanks 
    ,ISDEL char(4000) nullif ISDEL=blanks 
    ,CREATE_USER char(4000) nullif CREATE_USER=blanks 
    ,CREATE_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif CREATE_DATE=blanks 
    ,UPDATE_USER char(4000) nullif UPDATE_USER=blanks 
    ,UPDATE_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif UPDATE_DATE=blanks 
    ,CODE char(4000) nullif CODE=blanks 
    ,MANAGER_ID char(4000) nullif MANAGER_ID=blanks 
)