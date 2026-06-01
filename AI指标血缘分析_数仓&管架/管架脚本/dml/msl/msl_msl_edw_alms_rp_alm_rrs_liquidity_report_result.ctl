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
infile '${data_path}/alms_rp_alm_rrs_liquidity_report_result.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,v_rep_cd char(4000) nullif v_rep_cd=blanks 
    ,v_rep_line_order char(4000) nullif v_rep_line_order=blanks 
    ,n_rep_line_cd char(4000) nullif n_rep_line_cd=blanks 
    ,v_rep_line_name char(4000) nullif v_rep_line_name=blanks 
    ,v_rep_line_display_order char(4000) nullif v_rep_line_display_order=blanks 
    ,n_bold_ind char(4000) nullif n_bold_ind=blanks 
    ,n_indent_level char(4000) nullif n_indent_level=blanks 
    ,v_regulatory_level char(4000) nullif v_regulatory_level=blanks 
    ,v_index_class char(4000) nullif v_index_class=blanks 
    ,v_supervision_require char(4000) nullif v_supervision_require=blanks 
    ,v_limit_value char(4000) nullif v_limit_value=blanks 
    ,v_prewarning_value char(4000) nullif v_prewarning_value=blanks 
    ,v_index_type char(4000) nullif v_index_type=blanks 
    ,v_statistical_frequency char(4000) nullif v_statistical_frequency=blanks 
    ,v_monitor_frequency char(4000) nullif v_monitor_frequency=blanks 
    ,v_read_lvl char(4000) nullif v_read_lvl=blanks 
    ,v_department_type char(4000) nullif v_department_type=blanks 
    ,d_created_dt date "yyyy-mm-dd hh24:mi:ss" nullif d_created_dt=blanks 
)