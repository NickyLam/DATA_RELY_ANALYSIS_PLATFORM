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
infile '${data_path}/wind_financialbalancesheetdetails.a.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_wind_financialbalancesheetdetails
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,OBJECT_ID char(4000) nullif OBJECT_ID=blanks 
    ,S_INFO_COMPCODE char(4000) nullif S_INFO_COMPCODE=blanks 
    ,STATEMENT_TYPE char(4000) nullif STATEMENT_TYPE=blanks 
    ,REPORT_PERIOD char(4000) nullif REPORT_PERIOD=blanks 
    ,ANN_DT char(4000) nullif ANN_DT=blanks 
    ,CRNCY_CODE char(4000) nullif CRNCY_CODE=blanks 
    ,SUBJECT_NAME char(4000) nullif SUBJECT_NAME=blanks 
    ,ITEM_AMOUNT char(4000) nullif ITEM_AMOUNT=blanks 
    ,CLASSIFICATION_NUMBER char(4000) nullif CLASSIFICATION_NUMBER=blanks 
    ,PUBLISH_VALUE char(4000) nullif PUBLISH_VALUE=blanks 
    ,PUBLISH_COUNITDIMENSION char(4000) nullif PUBLISH_COUNITDIMENSION=blanks 
    ,IS_LISTING_DATA char(4000) nullif IS_LISTING_DATA=blanks 
    ,ACC_STA_CODE char(4000) nullif ACC_STA_CODE=blanks 
)