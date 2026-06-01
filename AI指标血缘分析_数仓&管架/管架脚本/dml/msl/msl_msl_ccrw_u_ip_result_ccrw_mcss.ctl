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
infile '${data_path}/U_IP_RESULT_CCRW_MCSS.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss
fields terminated by x'1b' 
trailing nullcols
(
    result_id char(4000) nullif result_id=blanks 
    ,index_mx_id char(4000) nullif index_mx_id=blanks 
    ,org_or_user_id char(4000) nullif org_or_user_id=blanks 
    ,fit_obj char(4000) nullif fit_obj=blanks 
    ,gh_type char(4000) nullif gh_type=blanks 
    ,ccy_type char(4000) nullif ccy_type=blanks 
    ,index_cycle_value char(4000) nullif index_cycle_value=blanks 
    ,index_cycle char(4000) nullif index_cycle=blanks 
    ,bk_index_id char(4000) nullif bk_index_id=blanks 
    ,run_batch_date char(4000) nullif run_batch_date=blanks 
    ,index_from char(4000) nullif index_from=blanks 
    ,value char(4000) nullif value=blanks 
    ,last_day char(4000) nullif last_day=blanks 
    ,last_week char(4000) nullif last_week=blanks 
    ,last_month char(4000) nullif last_month=blanks 
    ,last_season char(4000) nullif last_season=blanks 
    ,last_year char(4000) nullif last_year=blanks 
    ,last_year_same char(4000) nullif last_year_same=blanks 
    ,d_sub_zf char(4000) nullif d_sub_zf=blanks 
    ,w_sub_zf char(4000) nullif w_sub_zf=blanks 
    ,m_sub_zf char(4000) nullif m_sub_zf=blanks 
    ,q_sub_zf char(4000) nullif q_sub_zf=blanks 
    ,y_sub_zf char(4000) nullif y_sub_zf=blanks 
    ,yoy_sub_zf char(4000) nullif yoy_sub_zf=blanks 
    ,unit char(4000) nullif unit=blanks 
)