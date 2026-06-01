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
infile '${data_path}/fdl_idx_index_data_jx.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_fdl_idx_index_data_jx
fields terminated by x'1b' 
trailing nullcols
(
    index_no char(4000) nullif index_no=blanks 
    ,org_no char(4000) nullif org_no=blanks 
    ,biz_strip_line_cd char(4000) nullif biz_strip_line_cd=blanks 
    ,dim_cd1 char(4000) nullif dim_cd1=blanks 
    ,dim_cd2 char(4000) nullif dim_cd2=blanks 
    ,dim_cd3 char(4000) nullif dim_cd3=blanks 
    ,batch_freq char(4000) nullif batch_freq=blanks 
    ,index_measure char(4000) nullif index_measure=blanks 
    ,curr_cd char(4000) nullif curr_cd=blanks 
    ,index_val char(4000) nullif index_val=blanks 
    ,etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
)