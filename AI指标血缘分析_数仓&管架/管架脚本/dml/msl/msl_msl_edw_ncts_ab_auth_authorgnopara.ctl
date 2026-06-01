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
infile '${data_path}/ncts_ab_auth_authorgnopara.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,AUTHORGNO char(4000) nullif AUTHORGNO=blanks 
    ,AUTHORGNAME char(4000) nullif AUTHORGNAME=blanks 
    ,ORAGLEV char(4000) nullif ORAGLEV=blanks 
    ,TASKMODE char(4000) nullif TASKMODE=blanks 
    ,DELETEFLAG char(4000) nullif DELETEFLAG=blanks 
    ,USINGFLAG char(4000) nullif USINGFLAG=blanks 
    ,AUTHORGTYPE char(4000) nullif AUTHORGTYPE=blanks 
    ,CRTDATE date "yyyy-mm-dd hh24:mi:ss" nullif CRTDATE=blanks 
    ,CRTTELLERNO char(4000) nullif CRTTELLERNO=blanks 
    ,UPDDATE date "yyyy-mm-dd hh24:mi:ss" nullif UPDDATE=blanks 
    ,UPTELLERNO char(4000) nullif UPTELLERNO=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)