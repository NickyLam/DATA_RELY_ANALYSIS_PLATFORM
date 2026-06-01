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
infile '${data_path}/orws_t_report_task.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_orws_t_report_task
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,id char(4000) nullif id=blanks 
    ,task_title char(4000) nullif task_title=blanks 
    ,task_status char(4000) nullif task_status=blanks 
    ,explain_advise char(4000) nullif explain_advise=blanks 
    ,verification_opinion char(4000) nullif verification_opinion=blanks 
    ,executive_organ_id char(4000) nullif executive_organ_id=blanks 
    ,task_level char(4000) nullif task_level=blanks 
    ,parent_organ_id char(4000) nullif parent_organ_id=blanks 
    ,parent_task_id char(4000) nullif parent_task_id=blanks 
    ,task_create_date timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif task_create_date=blanks 
    ,task_report_date timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif task_report_date=blanks 
    ,task_update_date timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif task_update_date=blanks 
    ,is_delete char(4000) nullif is_delete=blanks 
    ,curr_operator_id char(4000) nullif curr_operator_id=blanks 
    ,operator_entry_time timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif operator_entry_time=blanks 
    ,business_date timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif business_date=blanks 
    ,curr_node_id char(4000) nullif curr_node_id=blanks 
    ,temp_verification_opinion char(4000) nullif temp_verification_opinion=blanks 
    ,is_selected char(4000) nullif is_selected=blanks 
    ,start_dt date "yyyy-mm-dd hh24:mi:ss" nullif start_dt=blanks 
    ,end_dt date "yyyy-mm-dd hh24:mi:ss" nullif end_dt=blanks 
    ,id_mark char(4000) nullif id_mark=blanks 
)