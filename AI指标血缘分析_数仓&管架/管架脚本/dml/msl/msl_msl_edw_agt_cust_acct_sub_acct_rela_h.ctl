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
infile '${data_path}/agt_cust_acct_sub_acct_rela_h.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,AGT_ID char(4000) nullif AGT_ID=blanks 
    ,LP_ID char(4000) nullif LP_ID=blanks 
    ,AGT_RELA_TYPE_CD char(4000) nullif AGT_RELA_TYPE_CD=blanks 
    ,SEQ_NUM char(4000) nullif SEQ_NUM=blanks 
    ,RELA_AGT_ID char(4000) nullif RELA_AGT_ID=blanks 
    ,ACCT_ID char(4000) nullif ACCT_ID=blanks 
    ,ACCT_SUB_ACCT_ID char(4000) nullif ACCT_SUB_ACCT_ID=blanks 
    ,STAND_B_TYPE_CD char(4000) nullif STAND_B_TYPE_CD=blanks 
    ,DEP_BASIC_ACCT_FLG char(4000) nullif DEP_BASIC_ACCT_FLG=blanks 
    ,CURR_CD char(4000) nullif CURR_CD=blanks 
    ,EC_FLG char(4000) nullif EC_FLG=blanks 
    ,EXT_PROD_ID char(4000) nullif EXT_PROD_ID=blanks 
    ,INTNAL_PROD_ID char(4000) nullif INTNAL_PROD_ID=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
    ,JOB_CD char(4000) nullif JOB_CD=blanks 

)

