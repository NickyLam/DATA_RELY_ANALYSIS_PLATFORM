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
infile '${data_path}/orws_tmm_oper_config.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_orws_tmm_oper_config
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,ID char(4000) nullif ID=blanks 
    ,MODEL_ID char(4000) nullif MODEL_ID=blanks 
    ,MODEL_GROUP char(4000) nullif MODEL_GROUP=blanks 
    ,WARN_LEVEL char(4000) nullif WARN_LEVEL=blanks 
    ,IS_AUTO char(4000) nullif IS_AUTO=blanks 
    ,AUTO_DESCRIPTION char(4000) nullif AUTO_DESCRIPTION=blanks 
    ,AUTO_EMP_ID char(4000) nullif AUTO_EMP_ID=blanks 
    ,POWER_VALUE char(4000) nullif POWER_VALUE=blanks 
    ,BIZINFO_TEMPLATE char(4000) nullif BIZINFO_TEMPLATE=blanks 
    ,OWNER_ORGAN_ID char(4000) nullif OWNER_ORGAN_ID=blanks 
    ,RISK_LEVEL char(4000) nullif RISK_LEVEL=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)