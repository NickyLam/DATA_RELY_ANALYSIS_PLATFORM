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
infile '${data_path}/msl_fdl_idx_index_def.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_fdl_idx_index_def
fields terminated by x'1b' 
trailing nullcols
(
    index_int_id char(4000) nullif index_int_id=blanks 
    ,index_num char(4000) nullif index_num=blanks 
    ,index_name char(4000) nullif index_name=blanks 
    ,index_desc char(4000) nullif index_desc=blanks 
    ,index_bclass char(4000) nullif index_bclass=blanks 
    ,index_level1_class char(4000) nullif index_level1_class=blanks 
    ,index_level2_class char(4000) nullif index_level2_class=blanks 
    ,index_level3_class char(4000) nullif index_level3_class=blanks 
    ,index_measure char(4000) nullif index_measure=blanks 
    ,index_deriv_measure char(4000) nullif index_deriv_measure=blanks 
    ,data_attr char(4000) nullif data_attr=blanks 
    ,index_dim char(4000) nullif index_dim=blanks 
    ,measure_unit char(4000) nullif measure_unit=blanks 
    ,stat_period char(4000) nullif stat_period=blanks 
    ,data_format char(4000) nullif data_format=blanks 
    ,prod_mode char(4000) nullif prod_mode=blanks 
    ,biz_cali char(4000) nullif biz_cali=blanks 
    ,tech_cali char(4000) nullif tech_cali=blanks 
    ,issue_range char(4000) nullif issue_range=blanks 
    ,main_sys char(4000) nullif main_sys=blanks 
    ,warn_val char(4000) nullif warn_val=blanks 
    ,alarm_val char(4000) nullif alarm_val=blanks 
    ,owner char(4000) nullif owner=blanks 
    ,write_person char(4000) nullif write_person=blanks 
    ,effect_dt date "yyyy-mm-dd hh24:mi:ss" nullif effect_dt=blanks 
    ,invalid_dt date "yyyy-mm-dd hh24:mi:ss" nullif invalid_dt=blanks 
    ,matn_person char(4000) nullif matn_person=blanks 
    ,matn_dt date "yyyy-mm-dd hh24:mi:ss" nullif matn_dt=blanks 
    ,etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
)