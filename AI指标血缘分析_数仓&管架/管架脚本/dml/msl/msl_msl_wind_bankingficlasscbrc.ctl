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
infile '${data_path}/wind_bankingficlasscbrc.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_wind_bankingficlasscbrc
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,OBJECT_ID char(4000) nullif OBJECT_ID=blanks 
    ,S_INFO_COMPCODE char(4000) nullif S_INFO_COMPCODE=blanks 
    ,S_INFO_COMPNAME char(4000) nullif S_INFO_COMPNAME=blanks 
    ,S_INFO_TYPECODE char(4000) nullif S_INFO_TYPECODE=blanks 
    ,ENTRY_DT char(4000) nullif ENTRY_DT=blanks 
    ,REMOVE_DT char(4000) nullif REMOVE_DT=blanks 
    ,CUR_SIGN char(4000) nullif CUR_SIGN=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)