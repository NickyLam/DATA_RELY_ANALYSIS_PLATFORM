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
infile '${data_path}/u_cust_jsh_ind_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_bdws_u_cust_jsh_ind_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt char(4000) nullif etl_dt=blanks 
    ,index_no char(4000) nullif index_no=blanks 
    ,index_name char(4000) nullif index_name=blanks 
    ,execut_type char(4000) nullif execut_type=blanks 
    ,clerk_id char(4000) nullif clerk_id=blanks 
    ,clerk_name char(4000) nullif clerk_name=blanks 
    ,belong_org_id char(4000) nullif belong_org_id=blanks 
    ,belong_org_name char(4000) nullif belong_org_name=blanks 
    ,statis_cycle char(4000) nullif statis_cycle=blanks 
    ,plan_type char(4000) nullif plan_type=blanks 
    ,val char(4000) nullif val=blanks 
    ,d_sub_bal char(4000) nullif d_sub_bal=blanks 
    ,m_sub_bal char(4000) nullif m_sub_bal=blanks 
    ,q_sub_bal char(4000) nullif q_sub_bal=blanks 
    ,y_sub_bal char(4000) nullif y_sub_bal=blanks 
    ,w_sub_bal char(4000) nullif w_sub_bal=blanks 
    ,yoy_sub_bal char(4000) nullif yoy_sub_bal=blanks 
    ,d_sub_zf char(4000) nullif d_sub_zf=blanks 
    ,m_sub_zf char(4000) nullif m_sub_zf=blanks 
    ,q_sub_zf char(4000) nullif q_sub_zf=blanks 
    ,y_sub_zf char(4000) nullif y_sub_zf=blanks 
    ,w_sub_zf char(4000) nullif w_sub_zf=blanks 
    ,yoy_sub_zf char(4000) nullif yoy_sub_zf=blanks 
)