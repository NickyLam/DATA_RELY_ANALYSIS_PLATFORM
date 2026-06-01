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
infile '${data_path}/hgls_operate_channel_type.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_hgls_operate_channel_type
fields terminated by x'1b' 
trailing nullcols
(
    ID char(4000) nullif ID=blanks 
    ,CHANNEL_NAME char(4000) nullif CHANNEL_NAME=blanks 
    ,CHANNEL_TYPE char(4000) nullif CHANNEL_TYPE=blanks 
    ,CHANNEL_CODE char(4000) nullif CHANNEL_CODE=blanks 
    ,MERCHANT_CODE char(4000) nullif MERCHANT_CODE=blanks 
    ,CHANNEL_INDEX char(4000) nullif CHANNEL_INDEX=blanks 
    ,CREATE_TIME timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif CREATE_TIME=blanks 
    ,UPDATE_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif UPDATE_DATE=blanks 
    ,ISDEL char(4000) nullif ISDEL=blanks 
    ,ENTERPRISE_CODE char(4000) nullif ENTERPRISE_CODE=blanks 
    ,CODE char(4000) nullif CODE=blanks 
    ,EMAIL char(4000) nullif EMAIL=blanks 
    ,TELEPHONE char(4000) nullif TELEPHONE=blanks 
    ,CREATE_USER_CODE char(4000) nullif CREATE_USER_CODE=blanks 
    ,CREATE_INSTITUTION char(4000) nullif CREATE_INSTITUTION=blanks 
    ,OWNER_INSTITUTION char(4000) nullif OWNER_INSTITUTION=blanks 
    ,ORG_NUM char(4000) nullif ORG_NUM=blanks 
)