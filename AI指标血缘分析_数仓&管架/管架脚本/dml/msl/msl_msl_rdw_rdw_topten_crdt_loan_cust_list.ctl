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
infile '${data_path}/mcs_topten_crdt_loan_cust_list.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,CUST_NO char(4000) nullif CUST_NO=blanks 
    ,CUST_NAME char(4000) nullif CUST_NAME=blanks 
    ,LOAN_CRDT_TYPE char(4000) nullif LOAN_CRDT_TYPE=blanks 
    ,CUST_TYPE char(4000) nullif CUST_TYPE=blanks 
    ,ORG_NO char(4000) nullif ORG_NO=blanks 
    ,ORG_NAME char(4000) nullif ORG_NAME=blanks 
    ,CURR_BAL char(4000) nullif CURR_BAL=blanks 
    ,CRDT_AMT char(4000) nullif CRDT_AMT=blanks 
    ,RATIO char(4000) nullif RATIO=blanks 
    ,COMP_LAST_YEAR char(4000) nullif COMP_LAST_YEAR=blanks 
    ,COMP_LAST_QUA char(4000) nullif COMP_LAST_QUA=blanks 
    ,COMP_LAST_MONTH char(4000) nullif COMP_LAST_MONTH=blanks 
)