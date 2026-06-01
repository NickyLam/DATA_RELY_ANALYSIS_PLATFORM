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
infile '${data_path}/atms_rpt_open_rate_dev_date.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_atms_rpt_open_rate_dev_date
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,dev_no char(4000) nullif dev_no=blanks 
    ,date_time char(4000) nullif date_time=blanks 
    ,open_rate_year char(4000) nullif open_rate_year=blanks 
    ,open_rate_month char(4000) nullif open_rate_month=blanks 
    ,open_rate_day char(4000) nullif open_rate_day=blanks 
    ,full_fun_time char(4000) nullif full_fun_time=blanks 
    ,full_rate char(4000) nullif full_rate=blanks 
    ,half_fun_time char(4000) nullif half_fun_time=blanks 
    ,half_rate char(4000) nullif half_rate=blanks 
    ,hard_fault_time char(4000) nullif hard_fault_time=blanks 
    ,soft_fault_time char(4000) nullif soft_fault_time=blanks 
    ,maintenance_time char(4000) nullif maintenance_time=blanks 
    ,comm_failure_time char(4000) nullif comm_failure_time=blanks 
    ,close_time char(4000) nullif close_time=blanks 
    ,other_reason_time char(4000) nullif other_reason_time=blanks 
    ,work_time char(4000) nullif work_time=blanks 
    ,perfect_rate char(4000) nullif perfect_rate=blanks 
    ,service_rate char(4000) nullif service_rate=blanks 
    ,comm_rate char(4000) nullif comm_rate=blanks 
    ,stop_time char(4000) nullif stop_time=blanks 
    ,vcomm_failure_time char(4000) nullif vcomm_failure_time=blanks 
    ,suspected_crash_time char(4000) nullif suspected_crash_time=blanks 
    ,is_from_dev char(4000) nullif is_from_dev=blanks 
    ,short_paper_time char(4000) nullif short_paper_time=blanks 
    ,cash_gate_time char(4000) nullif cash_gate_time=blanks 
    ,movement_fail_time char(4000) nullif movement_fail_time=blanks 
)