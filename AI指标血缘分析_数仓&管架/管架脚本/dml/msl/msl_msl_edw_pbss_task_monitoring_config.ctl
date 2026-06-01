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
infile '${data_path}/pbss_task_monitoring_config.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pbss_task_monitoring_config
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,id char(4000) nullif id=blanks 
    ,task_monitoring_code char(4000) nullif task_monitoring_code=blanks 
    ,task_monitoring_name char(4000) nullif task_monitoring_name=blanks 
    ,star char(4000) nullif star=blanks 
    ,task_monitoring_type char(4000) nullif task_monitoring_type=blanks 
    ,parent_id char(4000) nullif parent_id=blanks 
    ,ave_mission char(4000) nullif ave_mission=blanks 
    ,tache_type char(4000) nullif tache_type=blanks 
    ,start_dt date "yyyy-mm-dd hh24:mi:ss" nullif start_dt=blanks 
    ,end_dt date "yyyy-mm-dd hh24:mi:ss" nullif end_dt=blanks 
    ,id_mark char(4000) nullif id_mark=blanks 
)