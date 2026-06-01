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
infile '${data_path}/ncts_ab_auth_authorgteller.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,AUTHORGNO char(4000) nullif AUTHORGNO=blanks 
    ,AUTHTELLERNO char(4000) nullif AUTHTELLERNO=blanks 
    ,TELLEROID char(4000) nullif TELLEROID=blanks 
    ,TELLERONLINE char(4000) nullif TELLERONLINE=blanks 
    ,REALOCATIONFLAG char(4000) nullif REALOCATIONFLAG=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)