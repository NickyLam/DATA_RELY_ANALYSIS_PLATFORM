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
infile '${data_path}/alms_rp_alm_rrs_b01_report_result.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,as_of_date date "yyyy-mm-dd hh24:mi:ss" nullif as_of_date=blanks 
    ,n_as_of_date_skey char(4000) nullif n_as_of_date_skey=blanks 
    ,n_run_skey char(4000) nullif n_run_skey=blanks 
    ,n_entity_skey char(4000) nullif n_entity_skey=blanks 
    ,n_business_unit_skey char(4000) nullif n_business_unit_skey=blanks 
    ,n_org_unit_skey char(4000) nullif n_org_unit_skey=blanks 
    ,n_forecast_point_skey char(4000) nullif n_forecast_point_skey=blanks 
    ,n_report_scenario_skey char(4000) nullif n_report_scenario_skey=blanks 
    ,n_rep_line_cd char(4000) nullif n_rep_line_cd=blanks 
    ,v_currency_type char(4000) nullif v_currency_type=blanks 
    ,n_rep_line_value char(4000) nullif n_rep_line_value=blanks 
    ,d_created_dt date "yyyy-mm-dd hh24:mi:ss" nullif d_created_dt=blanks 
    ,n_previous_day_variation char(4000) nullif n_previous_day_variation=blanks 
    ,n_previous_month_variation char(4000) nullif n_previous_month_variation=blanks 
    ,n_previous_year_variation char(4000) nullif n_previous_year_variation=blanks 
)