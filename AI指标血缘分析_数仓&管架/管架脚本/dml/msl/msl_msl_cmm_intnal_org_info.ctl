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
infile '${data_path}/cmm_intnal_org_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_cmm_intnal_org_info
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,LP_ID char(4000) nullif LP_ID=blanks 
    ,ORG_ID char(4000) nullif ORG_ID=blanks 
    ,ORG_NAME char(4000) nullif ORG_NAME=blanks 
    ,ORG_ABBR char(4000) nullif ORG_ABBR=blanks 
    ,PRINC_EMPLY_ID char(4000) nullif PRINC_EMPLY_ID=blanks 
    ,CBRC_FIN_INST_ID char(4000) nullif CBRC_FIN_INST_ID=blanks 
    ,UNIONPAY_FIN_INST_ID char(4000) nullif UNIONPAY_FIN_INST_ID=blanks 
    ,FIN_INST_IDF_CODE char(4000) nullif FIN_INST_IDF_CODE=blanks 
    ,BUS_LICS_NUM char(4000) nullif BUS_LICS_NUM=blanks 
    ,FIN_LICS_NUM char(4000) nullif FIN_LICS_NUM=blanks 
    ,PBC_PAY_BANK_NO char(4000) nullif PBC_PAY_BANK_NO=blanks 
    ,FIN_INST_CODE char(4000) nullif FIN_INST_CODE=blanks 
    ,HQ_ORG_ID char(4000) nullif HQ_ORG_ID=blanks 
    ,HQ_ORG_NAME char(4000) nullif HQ_ORG_NAME=blanks 
    ,BRCH_ID char(4000) nullif BRCH_ID=blanks 
    ,BRCH_NAME char(4000) nullif BRCH_NAME=blanks 
    ,SUBRCH_ID char(4000) nullif SUBRCH_ID=blanks 
    ,SUBRCH_NAME char(4000) nullif SUBRCH_NAME=blanks 
    ,ORG_TYPE_CD char(4000) nullif ORG_TYPE_CD=blanks 
    ,ORG_LEV_CD char(4000) nullif ORG_LEV_CD=blanks 
    ,ORG_STATUS_CD char(4000) nullif ORG_STATUS_CD=blanks 
    ,BUS_STATUS_CD char(4000) nullif BUS_STATUS_CD=blanks 
    ,BUS_ORG_FLG char(4000) nullif BUS_ORG_FLG=blanks 
    ,ENTY_ORG_FLG char(4000) nullif ENTY_ORG_FLG=blanks 
    ,ACCTI_ORG_FLG char(4000) nullif ACCTI_ORG_FLG=blanks 
    ,ADMIN_ORG_FLG char(4000) nullif ADMIN_ORG_FLG=blanks 
    ,ACCT_INSTIT_FLG char(4000) nullif ACCT_INSTIT_FLG=blanks 
    ,VTUAL_ACCTI_ORG_FLG char(4000) nullif VTUAL_ACCTI_ORG_FLG=blanks 
    ,ADMIN_SUPER_ORG_ID char(4000) nullif ADMIN_SUPER_ORG_ID=blanks 
    ,ACCT_SUPER_ORG_ID char(4000) nullif ACCT_SUPER_ORG_ID=blanks 
    ,ACCTI_SUPER_ORG_ID char(4000) nullif ACCTI_SUPER_ORG_ID=blanks 
    ,FUNC_ORG_ID char(4000) nullif FUNC_ORG_ID=blanks 
    ,FUNC_DEPT_ID char(4000) nullif FUNC_DEPT_ID=blanks 
    ,CTY_RG_CD char(4000) nullif CTY_RG_CD=blanks 
    ,PROV_CD char(4000) nullif PROV_CD=blanks 
    ,CITY_CD char(4000) nullif CITY_CD=blanks 
    ,COUNTY_CD char(4000) nullif COUNTY_CD=blanks 
    ,PHYS_ADDR char(4000) nullif PHYS_ADDR=blanks 
    ,DDD_AREA_CD char(4000) nullif DDD_AREA_CD=blanks 
    ,PHONE char(4000) nullif PHONE=blanks 
    ,ZIP_CD char(4000) nullif ZIP_CD=blanks 
    ,ORG_FOUND_DT date "yyyy-mm-dd hh24:mi:ss" nullif ORG_FOUND_DT=blanks 
    ,ORG_REVO_DT date "yyyy-mm-dd hh24:mi:ss" nullif ORG_REVO_DT=blanks 
    ,ORG_START_BUS_TM char(4000) nullif ORG_START_BUS_TM=blanks 
    ,ORG_END_BUS_TM char(4000) nullif ORG_END_BUS_TM=blanks 
)