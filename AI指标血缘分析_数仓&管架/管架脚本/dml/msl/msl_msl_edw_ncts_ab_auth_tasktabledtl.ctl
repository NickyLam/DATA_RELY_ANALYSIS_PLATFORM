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
infile '${data_path}/ncts_ab_auth_tasktabledtl.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,TXDATE date "yyyy-mm-dd hh24:mi:ss" nullif TXDATE=blanks 
    ,TXTIME char(4000) nullif TXTIME=blanks 
    ,TRADESERNO char(4000) nullif TRADESERNO=blanks 
    ,AUTHSERNO char(4000) nullif AUTHSERNO=blanks 
    ,CRTDATE char(4000) nullif CRTDATE=blanks 
    ,TXORGNO char(4000) nullif TXORGNO=blanks 
    ,TXTELLERNO char(4000) nullif TXTELLERNO=blanks 
    ,AUTHORGNO char(4000) nullif AUTHORGNO=blanks 
    ,AUTHTELLERNO char(4000) nullif AUTHTELLERNO=blanks 
    ,AUDITORGNO char(4000) nullif AUDITORGNO=blanks 
    ,AUDITTELLERNO char(4000) nullif AUDITTELLERNO=blanks 
    ,AUTHSTATUS char(4000) nullif AUTHSTATUS=blanks 
    ,AUTHTASKNOTE char(4000) nullif AUTHTASKNOTE=blanks 
    ,AUTHREFUSENOTE char(4000) nullif AUTHREFUSENOTE=blanks 
    ,CRTTIME char(4000) nullif CRTTIME=blanks 
    ,WEIGHT char(4000) nullif WEIGHT=blanks 
    ,AUTHMODEL char(4000) nullif AUTHMODEL=blanks 
    ,ISAUTHFLAG char(4000) nullif ISAUTHFLAG=blanks 
    ,TXCODE char(4000) nullif TXCODE=blanks 
    ,REASONCODE char(4000) nullif REASONCODE=blanks 
    ,BARCODE char(4000) nullif BARCODE=blanks 
    ,AUTHLEVEL char(4000) nullif AUTHLEVEL=blanks 
    ,TRADESTATUS char(4000) nullif TRADESTATUS=blanks 
    ,TRADEMODE char(4000) nullif TRADEMODE=blanks 
    ,AUTHRETURNNOTE char(4000) nullif AUTHRETURNNOTE=blanks 
    ,AUTHCANCELNOTE char(4000) nullif AUTHCANCELNOTE=blanks 
    ,RETURNTYPE char(4000) nullif RETURNTYPE=blanks 
    ,OVERTIME char(4000) nullif OVERTIME=blanks 
    ,CARTORDER char(4000) nullif CARTORDER=blanks 
    ,MAKEUPSN char(4000) nullif MAKEUPSN=blanks 
    ,TIMES char(4000) nullif TIMES=blanks 
    ,AUTHNOTE_REPLENISH char(4000) nullif AUTHNOTE_REPLENISH=blanks 
    ,REPLENISH_STATUS char(4000) nullif REPLENISH_STATUS=blanks 
    ,AUTH_REPLENISH_TYPE char(4000) nullif AUTH_REPLENISH_TYPE=blanks 
    ,AUTH_REPLENISH_NOTE char(4000) nullif AUTH_REPLENISH_NOTE=blanks 
    ,BJ_TELLERNO char(4000) nullif BJ_TELLERNO=blanks 
    ,FQBJ_TELLERNO char(4000) nullif FQBJ_TELLERNO=blanks 
    ,SH_TELLERNO char(4000) nullif SH_TELLERNO=blanks 
    ,BJ_AUTHTELLERNO char(4000) nullif BJ_AUTHTELLERNO=blanks 
    ,REPLENISH_NOTE char(4000) nullif REPLENISH_NOTE=blanks 
    ,REPLENISHFLAG char(4000) nullif REPLENISHFLAG=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)