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
infile '${data_path}/agt_indv_e_prod_acct_rela_h.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_agt_indv_e_prod_acct_rela_h
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,ACCT_RELA_ID char(4000) nullif ACCT_RELA_ID=blanks 
    ,PROD_ACCT_ID char(4000) nullif PROD_ACCT_ID=blanks 
    ,PARTY_ID char(4000) nullif PARTY_ID=blanks 
    ,AGT_ID char(4000) nullif AGT_ID=blanks 
    ,E_ACCT_ID char(4000) nullif E_ACCT_ID=blanks 
    ,ACCT_SUB_SEQ_NUM char(4000) nullif ACCT_SUB_SEQ_NUM=blanks 
    ,LP_ID char(4000) nullif LP_ID=blanks 
    ,ACCT_ID char(4000) nullif ACCT_ID=blanks 
    ,MERCHT_ID char(4000) nullif MERCHT_ID=blanks 
    ,FEA_NAME_CD char(4000) nullif FEA_NAME_CD=blanks 
    ,PROD_ID char(4000) nullif PROD_ID=blanks 
    ,EFFECT_TM timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif EFFECT_TM=blanks 
    ,INVALID_TM timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif INVALID_TM=blanks 
    ,MED_TYPE_CD char(4000) nullif MED_TYPE_CD=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)