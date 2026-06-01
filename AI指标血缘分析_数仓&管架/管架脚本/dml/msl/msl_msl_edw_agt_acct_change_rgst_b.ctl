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
infile '${data_path}/agt_acct_change_rgst_b.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_agt_acct_change_rgst_b
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,AGT_ID char(4000) nullif AGT_ID=blanks 
    ,LP_ID char(4000) nullif LP_ID=blanks 
    ,OLD_ACCT_ID char(4000) nullif OLD_ACCT_ID=blanks 
    ,NEW_ACCT_ID char(4000) nullif NEW_ACCT_ID=blanks 
    ,TRAN_DT date "yyyy-mm-dd hh24:mi:ss" nullif TRAN_DT=blanks 
    ,TRAN_FLOW_NUM char(4000) nullif TRAN_FLOW_NUM=blanks 
    ,ADVISED_MIDGROD_FLG char(4000) nullif ADVISED_MIDGROD_FLG=blanks 
    ,TRAN_ORG_ID char(4000) nullif TRAN_ORG_ID=blanks 
    ,TRAN_TELLER_ID char(4000) nullif TRAN_TELLER_ID=blanks 
    ,JOB_CD char(4000) nullif JOB_CD=blanks 

)
