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
infile '${data_path}/wind_asharedescription.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_wind_asharedescription
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,OBJECT_ID char(4000) nullif OBJECT_ID=blanks 
    ,S_INFO_WINDCODE char(4000) nullif S_INFO_WINDCODE=blanks 
    ,S_INFO_CODE char(4000) nullif S_INFO_CODE=blanks 
    ,S_INFO_NAME char(4000) nullif S_INFO_NAME=blanks 
    ,S_INFO_COMPNAME char(4000) nullif S_INFO_COMPNAME=blanks 
    ,S_INFO_COMPNAMEENG char(4000) nullif S_INFO_COMPNAMEENG=blanks 
    ,S_INFO_ISINCODE char(4000) nullif S_INFO_ISINCODE=blanks 
    ,S_INFO_EXCHMARKET char(4000) nullif S_INFO_EXCHMARKET=blanks 
    ,S_INFO_LISTBOARD char(4000) nullif S_INFO_LISTBOARD=blanks 
    ,S_INFO_LISTDATE char(4000) nullif S_INFO_LISTDATE=blanks 
    ,S_INFO_DELISTDATE char(4000) nullif S_INFO_DELISTDATE=blanks 
    ,S_INFO_SEDOLCODE char(4000) nullif S_INFO_SEDOLCODE=blanks 
    ,CRNCY_CODE char(4000) nullif CRNCY_CODE=blanks 
    ,S_INFO_PINYIN char(4000) nullif S_INFO_PINYIN=blanks 
    ,S_INFO_LISTBOARDNAME char(4000) nullif S_INFO_LISTBOARDNAME=blanks 
    ,IS_SHSC char(4000) nullif IS_SHSC=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)