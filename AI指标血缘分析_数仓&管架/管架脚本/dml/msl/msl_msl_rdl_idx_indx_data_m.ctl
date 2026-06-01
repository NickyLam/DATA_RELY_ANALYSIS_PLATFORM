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
infile '${data_path}/rdl_idx_indx_data.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_rdl_idx_indx_data
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,INDX_NO char(4000) nullif INDX_NO=blanks 
    ,ORG_NO char(4000) nullif ORG_NO=blanks 
    ,CURR_CD char(4000) nullif CURR_CD=blanks 
    ,INDX_DIMEN_NO char(4000) nullif INDX_DIMEN_NO=blanks 
    ,INDX_DIMEN_CD char(4000) nullif INDX_DIMEN_CD=blanks 
    ,STAT_PED_CD char(4000) nullif STAT_PED_CD=blanks 
    ,INDX_VAL char(4000) nullif INDX_VAL=blanks 
    ,COMP_EAR_YEAR_VAL char(4000) nullif COMP_EAR_YEAR_VAL=blanks 
    ,COMP_SAME_TERM_VAL char(4000) nullif COMP_SAME_TERM_VAL=blanks 
    ,COMP_LAST_MON_VAL char(4000) nullif COMP_LAST_MON_VAL=blanks 
    ,COMP_LAST_QUA_VAL char(4000) nullif COMP_LAST_QUA_VAL=blanks 
    ,ETL_TIMESTAMP timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif ETL_TIMESTAMP=blanks 
    ,BIZ_STRIP_LINE_CD char(4000) nullif BIZ_STRIP_LINE_CD=blanks 
    ,INDEX_MEASURE char(4000) nullif INDEX_MEASURE=blanks 
)