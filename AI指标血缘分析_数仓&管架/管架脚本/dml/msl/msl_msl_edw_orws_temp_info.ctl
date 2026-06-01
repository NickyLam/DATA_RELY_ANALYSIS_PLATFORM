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
infile '${data_path}/orws_temp_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_orws_temp_info
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,ID char(4000) nullif ID=blanks 
    ,NAME char(4000) nullif NAME=blanks 
    ,EMPLOYEE_NO char(4000) nullif EMPLOYEE_NO=blanks 
    ,SEX char(4000) nullif SEX=blanks 
    ,FOLK char(4000) nullif FOLK=blanks 
    ,NATIVE_PLACE char(4000) nullif NATIVE_PLACE=blanks 
    ,BORN_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif BORN_DATE=blanks 
    ,ADDRESS char(4000) nullif ADDRESS=blanks 
    ,EDU_DEGREE char(4000) nullif EDU_DEGREE=blanks 
    ,IS_FULLTIME char(4000) nullif IS_FULLTIME=blanks 
    ,EMPLOYEEMENT_TYPE char(4000) nullif EMPLOYEEMENT_TYPE=blanks 
    ,CLERK_LEVEL char(4000) nullif CLERK_LEVEL=blanks 
    ,STATUS char(4000) nullif STATUS=blanks 
    ,MOBILE char(4000) nullif MOBILE=blanks 
    ,ORGAN_ID char(4000) nullif ORGAN_ID=blanks 
    ,ORGAN_NAME char(4000) nullif ORGAN_NAME=blanks 
    ,ORGAN_NUMBER char(4000) nullif ORGAN_NUMBER=blanks 
    ,TO_ORGAN char(4000) nullif TO_ORGAN=blanks 
    ,TO_GROUP char(4000) nullif TO_GROUP=blanks 
    ,EMPLOYEE_ID char(4000) nullif EMPLOYEE_ID=blanks 
    ,BECOME_DATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif BECOME_DATE=blanks 
    ,CREATE_TIME timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif CREATE_TIME=blanks 
    ,UPDATE_TIME timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif UPDATE_TIME=blanks 
    ,CREATE_USER_ID char(4000) nullif CREATE_USER_ID=blanks 
    ,UPDATE_USER_ID char(4000) nullif UPDATE_USER_ID=blanks 
    ,EMAIL char(4000) nullif EMAIL=blanks 
    ,OFFICE_CALL char(4000) nullif OFFICE_CALL=blanks 
    ,EMP_NO char(4000) nullif EMP_NO=blanks 
    ,ISMAIN char(4000) nullif ISMAIN=blanks 
    ,BELONG_EMP_NO char(4000) nullif BELONG_EMP_NO=blanks 
    ,EXTERNAL_STATUS char(4000) nullif EXTERNAL_STATUS=blanks 
    ,DOMAINID char(4000) nullif DOMAINID=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)