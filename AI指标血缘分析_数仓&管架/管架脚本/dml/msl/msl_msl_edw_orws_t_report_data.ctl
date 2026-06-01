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
infile '${data_path}/orws_t_report_data.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_orws_t_report_data
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,id char(4000) nullif id=blanks 
    ,bmc_id char(4000) nullif bmc_id=blanks 
    ,yesterday_condition char(4000) nullif yesterday_condition=blanks 
    ,sb_confirmation_feedback char(4000) nullif sb_confirmation_feedback=blanks 
    ,bb_confirmation_feedback char(4000) nullif bb_confirmation_feedback=blanks 
    ,hb_confirmation_feedback char(4000) nullif hb_confirmation_feedback=blanks 
    ,is_count char(4000) nullif is_count=blanks 
    ,mmd_id char(4000) nullif mmd_id=blanks 
    ,executive_organ_id char(4000) nullif executive_organ_id=blanks 
    ,rdata_level char(4000) nullif rdata_level=blanks 
    ,task_id char(4000) nullif task_id=blanks 
    ,rdata_status char(4000) nullif rdata_status=blanks 
    ,problem_id char(4000) nullif problem_id=blanks 
    ,flow_up_status char(4000) nullif flow_up_status=blanks 
    ,risk_level char(4000) nullif risk_level=blanks 
    ,approve_status char(4000) nullif approve_status=blanks 
    ,reportto_node_id char(4000) nullif reportto_node_id=blanks 
    ,business_date char(4000) nullif business_date=blanks 
    ,templatetype_id char(4000) nullif templatetype_id=blanks 
    ,sb_status_feedback char(4000) nullif sb_status_feedback=blanks 
    ,bb_status_feedback char(4000) nullif bb_status_feedback=blanks 
    ,hb_status_feedback char(4000) nullif hb_status_feedback=blanks 
    ,is_overdue char(4000) nullif is_overdue=blanks 
    ,upgrade_date timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif upgrade_date=blanks 
    ,approve_days char(4000) nullif approve_days=blanks 
    ,flow_up_id char(4000) nullif flow_up_id=blanks 
    ,approve_date timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif approve_date=blanks 
    ,is_manualup char(4000) nullif is_manualup=blanks 
    ,start_dt date "yyyy-mm-dd hh24:mi:ss" nullif start_dt=blanks 
    ,end_dt date "yyyy-mm-dd hh24:mi:ss" nullif end_dt=blanks 
    ,id_mark char(4000) nullif id_mark=blanks 
)