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
infile '${data_path}/ncts_ab_auth_taskpooldata.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,AUTHDATE char(4000) nullif AUTHDATE=blanks 
    ,AUTHSERNO char(4000) nullif AUTHSERNO=blanks 
    ,AUTHORGNO char(4000) nullif AUTHORGNO=blanks 
    ,TASKPOOLID char(4000) nullif TASKPOOLID=blanks 
    ,AUTHLEVEL char(4000) nullif AUTHLEVEL=blanks 
    ,ENTRYTIME char(4000) nullif ENTRYTIME=blanks 
    ,OUTTIME char(4000) nullif OUTTIME=blanks 
    ,WAITTIME char(4000) nullif WAITTIME=blanks 
    ,STATUS char(4000) nullif STATUS=blanks 
    ,AUTHTELLERNO char(4000) nullif AUTHTELLERNO=blanks 
    ,WEIGHT char(4000) nullif WEIGHT=blanks 
    ,ABOID char(4000) nullif ABOID=blanks 
    ,TRADEID char(4000) nullif TRADEID=blanks 
    ,TRADESERNO char(4000) nullif TRADESERNO=blanks 
    ,FLAG char(4000) nullif FLAG=blanks 
    ,QUEUENUM char(4000) nullif QUEUENUM=blanks 
    ,TRADEMODE char(4000) nullif TRADEMODE=blanks 
    ,CARTORDER char(4000) nullif CARTORDER=blanks 
    ,MAKEUPSN char(4000) nullif MAKEUPSN=blanks 
    ,TIMES char(4000) nullif TIMES=blanks 
    ,REPLENISH_STATUS char(4000) nullif REPLENISH_STATUS=blanks 
    ,BJ_TELLERNO char(4000) nullif BJ_TELLERNO=blanks 
    ,FQBJ_TELLERNO char(4000) nullif FQBJ_TELLERNO=blanks 
    ,BJ_AUTHTELLERNO char(4000) nullif BJ_AUTHTELLERNO=blanks 
    ,FQBJ_DATE char(4000) nullif FQBJ_DATE=blanks 
    ,FQBJ_TIME char(4000) nullif FQBJ_TIME=blanks 
    ,BJ_AUTHDATE char(4000) nullif BJ_AUTHDATE=blanks 
    ,BJ_AUTHTIME char(4000) nullif BJ_AUTHTIME=blanks 
    ,BJ_SUCCESSTIME char(4000) nullif BJ_SUCCESSTIME=blanks 
    ,BJ_LASTOPTDATE char(4000) nullif BJ_LASTOPTDATE=blanks 
    ,REPLENISHFLAG char(4000) nullif REPLENISHFLAG=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)