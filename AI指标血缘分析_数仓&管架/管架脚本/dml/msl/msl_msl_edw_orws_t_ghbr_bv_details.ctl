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
infile '${data_path}/orws_t_ghbr_bv_details.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_orws_t_ghbr_bv_details
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,TXN_DT timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif TXN_DT=blanks 
    ,TXN_TM char(4000) nullif TXN_TM=blanks 
    ,PARENT_ORG_ID char(4000) nullif PARENT_ORG_ID=blanks 
    ,BLNG_ORG_ID char(4000) nullif BLNG_ORG_ID=blanks 
    ,OPER_TELLER_ID char(4000) nullif OPER_TELLER_ID=blanks 
    ,OPER_TELLER_NAME char(4000) nullif OPER_TELLER_NAME=blanks 
    ,AUTH_TELLER_ID char(4000) nullif AUTH_TELLER_ID=blanks 
    ,AUTH_TELLER_NAME char(4000) nullif AUTH_TELLER_NAME=blanks 
    ,TXN_NUM char(4000) nullif TXN_NUM=blanks 
    ,TXN_DESC char(4000) nullif TXN_DESC=blanks 
    ,BIZ_SYS_EVT_ID char(4000) nullif BIZ_SYS_EVT_ID=blanks 
    ,BCS_EVT_ID char(4000) nullif BCS_EVT_ID=blanks 
    ,DATA_SRC_CD char(4000) nullif DATA_SRC_CD=blanks 
    ,PAY_AGT_ID char(4000) nullif PAY_AGT_ID=blanks 
    ,RCV_AGT_ID char(4000) nullif RCV_AGT_ID=blanks 
    ,TXN_AMT char(4000) nullif TXN_AMT=blanks 
    ,MENUID char(4000) nullif MENUID=blanks 
)