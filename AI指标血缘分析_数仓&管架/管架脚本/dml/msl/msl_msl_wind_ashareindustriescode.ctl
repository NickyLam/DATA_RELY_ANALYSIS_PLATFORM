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
infile '${data_path}/wind_ashareindustriescode.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_wind_ashareindustriescode
fields terminated by x'1b' 
trailing nullcols
(  
     ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks   
    ,OBJECT_ID char(4000) nullif  OBJECT_ID=blanks
    ,INDUSTRIESCODE char(4000) nullif INDUSTRIESCODE=blanks
    ,INDUSTRIESNAME char(4000) nullif INDUSTRIESNAME=blanks
    ,LEVELNUM char(4000) nullif LEVELNUM =blanks
    ,USED char(4000) nullif USED =blanks
    ,INDUSTRIESALIAS char(4000) nullif INDUSTRIESALIAS=blanks
    ,SEQUENCE1 char(4000) nullif SEQUENCE1=blanks
    ,MEMO char(4000) nullif MEMO=blanks
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks
    ,ID_MARK char(4000) nullif  ID_MARK =blanks  
)