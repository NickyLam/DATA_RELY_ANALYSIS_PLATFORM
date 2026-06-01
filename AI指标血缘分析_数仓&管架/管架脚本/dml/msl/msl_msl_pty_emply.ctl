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
infile '${data_path}/pty_emply.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_pty_emply
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,EMPLY_ID char(4000) nullif EMPLY_ID=blanks 
    ,REGION_ACCT_NUM char(4000) nullif REGION_ACCT_NUM=blanks 
    ,FIRST_NAME char(4000) nullif FIRST_NAME=blanks 
    ,LAST_NAME char(4000) nullif LAST_NAME=blanks 
    ,CERT_TYPE_CD char(4000) nullif CERT_TYPE_CD=blanks 
    ,CERT_NO char(4000) nullif CERT_NO=blanks 
    ,GENDER_CD char(4000) nullif GENDER_CD=blanks 
    ,BIRTH_DT date "yyyy-mm-dd hh24:mi:ss" nullif BIRTH_DT=blanks 
    ,NATIONTY_CD char(4000) nullif NATIONTY_CD=blanks 
    ,POLITIC_STATUS_CD char(4000) nullif POLITIC_STATUS_CD=blanks 
    ,MARRIAGE_SITU_CD char(4000) nullif MARRIAGE_SITU_CD=blanks 
    ,EDU_CD char(4000) nullif EDU_CD=blanks 
    ,JOIN_WORK_DT date "yyyy-mm-dd hh24:mi:ss" nullif JOIN_WORK_DT=blanks 
    ,TELLER_PIC_NAME char(4000) nullif TELLER_PIC_NAME=blanks 
    ,EMPLY_TYPE_CD char(4000) nullif EMPLY_TYPE_CD=blanks 
    ,BELONG_DEPT_ID char(4000) nullif BELONG_DEPT_ID=blanks 
    ,POSTN_CD char(4000) nullif POSTN_CD=blanks 
    ,TELLER_BELONG_ORG_ID char(4000) nullif TELLER_BELONG_ORG_ID=blanks 
    ,EMPYT_DT date "yyyy-mm-dd hh24:mi:ss" nullif EMPYT_DT=blanks 
    ,DIMISSION_DT date "yyyy-mm-dd hh24:mi:ss" nullif DIMISSION_DT=blanks 
    ,EMPLY_STATUS_CD char(4000) nullif EMPLY_STATUS_CD=blanks 
    ,EMPLY_SYS_STATUS_CD char(4000) nullif EMPLY_SYS_STATUS_CD=blanks 
    ,FAX_DOM_AREA_CD char(4000) nullif FAX_DOM_AREA_CD=blanks 
    ,FAX_NUM char(4000) nullif FAX_NUM=blanks 
    ,WORK_TEL_DOM_AREA_CD char(4000) nullif WORK_TEL_DOM_AREA_CD=blanks 
    ,WORK_TEL_NUM char(4000) nullif WORK_TEL_NUM=blanks 
    ,MOBILE_PHONE_NUM char(4000) nullif MOBILE_PHONE_NUM=blanks 
    ,MOBILE_PHONE_NUM_2 char(4000) nullif MOBILE_PHONE_NUM_2=blanks 
    ,CTY_CD char(4000) nullif CTY_CD=blanks 
    ,RESD_ADDR char(4000) nullif RESD_ADDR=blanks 
    ,E_MAIL char(4000) nullif E_MAIL=blanks 
    ,SALARY_LEV_CD char(4000) nullif SALARY_LEV_CD=blanks 
    ,DSPLY_SEQ_NUM char(4000) nullif DSPLY_SEQ_NUM=blanks 
    ,VTUAL_ACCTI_DEPT_ID char(4000) nullif VTUAL_ACCTI_DEPT_ID=blanks 
    ,MODIF_DT date "yyyy-mm-dd hh24:mi:ss" nullif MODIF_DT=blanks 
    ,SUBSIDY_DISTR_DT date "yyyy-mm-dd hh24:mi:ss" nullif SUBSIDY_DISTR_DT=blanks 
    ,DING_TALK_USER_ID char(4000) nullif DING_TALK_USER_ID=blanks 
    ,POST_CD char(4000) nullif POST_CD=blanks 
    ,LP_ID char(4000) nullif LP_ID=blanks 
    ,MAIN_TELLER_ID char(4000) nullif MAIN_TELLER_ID=blanks 
    ,TITLE_CD char(4000) nullif TITLE_CD=blanks 
    ,PARTY_ID char(4000) nullif PARTY_ID=blanks 
    ,CREATE_DT date "yyyy-mm-dd hh24:mi:ss" nullif CREATE_DT=blanks 
    ,UPDATE_DT date "yyyy-mm-dd hh24:mi:ss" nullif UPDATE_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)