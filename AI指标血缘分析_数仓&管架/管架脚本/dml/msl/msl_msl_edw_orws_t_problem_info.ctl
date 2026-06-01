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
infile '${data_path}/orws_t_problem_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_orws_t_problem_info
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,ID char(4000) nullif ID=blanks 
    ,BIZTYPE char(4000) nullif BIZTYPE=blanks 
    ,NODE_NAME char(4000) nullif NODE_NAME=blanks 
    ,INST_NO char(4000) nullif INST_NO=blanks 
    ,CHKDEPT char(4000) nullif CHKDEPT=blanks 
    ,ORGANID char(4000) nullif ORGANID=blanks 
    ,TASK_ORGAN char(4000) nullif TASK_ORGAN=blanks 
    ,BIGTYPE_ID char(4000) nullif BIGTYPE_ID=blanks 
    ,SMALLTYPE_ID char(4000) nullif SMALLTYPE_ID=blanks 
    ,BIZ_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif BIZ_DATE=blanks 
    ,CHECK_TIME timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif CHECK_TIME=blanks 
    ,CHKTITLE char(4000) nullif CHKTITLE=blanks 
    ,CHKPERSON char(4000) nullif CHKPERSON=blanks 
    ,PROBLEMER char(4000) nullif PROBLEMER=blanks 
    ,PROBLEMSTATE char(4000) nullif PROBLEMSTATE=blanks 
    ,PROBLEM_DETAIL_ACTION char(4000) nullif PROBLEM_DETAIL_ACTION=blanks 
    ,PROBLEM_BIZ_ID char(4000) nullif PROBLEM_BIZ_ID=blanks 
    ,SERINUM char(4000) nullif SERINUM=blanks 
    ,RECTIFIED_SERINUM char(4000) nullif RECTIFIED_SERINUM=blanks 
    ,PRBINFO char(4000) nullif PRBINFO=blanks 
    ,REMARKS char(4000) nullif REMARKS=blanks 
    ,IS_EMP_RESP char(4000) nullif IS_EMP_RESP=blanks 
    ,IS_DEBIT_RESP char(4000) nullif IS_DEBIT_RESP=blanks 
    ,IS_CREDIT_RESP char(4000) nullif IS_CREDIT_RESP=blanks 
    ,APPROVE_TYPE char(4000) nullif APPROVE_TYPE=blanks 
    ,RECTIFY_DEADLINE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif RECTIFY_DEADLINE=blanks 
    ,PRB_ORG_FIRST_DESC char(4000) nullif PRB_ORG_FIRST_DESC=blanks 
    ,PRO_IDTF char(4000) nullif PRO_IDTF=blanks 
    ,ORG_RES_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif ORG_RES_DATE=blanks 
    ,CONFIRM_DESC char(4000) nullif CONFIRM_DESC=blanks 
    ,APPROVE_STATUS char(4000) nullif APPROVE_STATUS=blanks 
    ,RISK_LEVEL char(4000) nullif RISK_LEVEL=blanks 
    ,APPROVE_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif APPROVE_DATE=blanks 
    ,UPGRADE_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif UPGRADE_DATE=blanks 
    ,IS_OVERDUE char(4000) nullif IS_OVERDUE=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)