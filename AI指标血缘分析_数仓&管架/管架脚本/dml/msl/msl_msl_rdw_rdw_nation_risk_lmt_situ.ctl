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
infile '${data_path}/mcs_nation_risk_lmt_situ.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_rdw_rdw_nation_risk_lmt_situ
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,NATION_NAME char(4000) nullif NATION_NAME=blanks 
    ,RATING_REST char(4000) nullif RATING_REST=blanks 
    ,LMT_CTRL_TARGET_VAL char(4000) nullif LMT_CTRL_TARGET_VAL=blanks 
    ,CURRT_BAL char(4000) nullif CURRT_BAL=blanks 
    ,COMP_LAST_YEAR char(4000) nullif COMP_LAST_YEAR=blanks 
    ,COMP_LAST_QUA char(4000) nullif COMP_LAST_QUA=blanks 
    ,COMP_LAST_MONTH char(4000) nullif COMP_LAST_MONTH=blanks 
)