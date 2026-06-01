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
infile '/mcs/data/input/${last_month_end}/msl/cass_r_rpt_rst0015.i.${last_month_end}.dat'
truncate into table ${msl_schema}.msl_edw_cass_r_rpt_rst0015
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,etl_dt_ora date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt_ora=blanks 
    ,curr_cd char(4000) nullif curr_cd=blanks 
    ,curr_name char(4000) nullif curr_name=blanks 
    ,com_line char(4000) nullif com_line=blanks 
    ,com_line_name char(4000) nullif com_line_name=blanks 
    ,index_level1_class char(4000) nullif index_level1_class=blanks 
    ,index_level2_class char(4000) nullif index_level2_class=blanks 
    ,index_level3_class char(4000) nullif index_level3_class=blanks 
    ,std_pro_no char(4000) nullif std_pro_no=blanks 
    ,std_pro_name char(4000) nullif std_pro_name=blanks 
    ,manager_org char(4000) nullif manager_org=blanks 
    ,manager_org_name char(4000) nullif manager_org_name=blanks 
    ,cust_mgr_no char(4000) nullif cust_mgr_no=blanks 
    ,cust_mgr_name char(4000) nullif cust_mgr_name=blanks 
    ,kpi_value_y char(4000) nullif kpi_value_y=blanks 
    ,kpi_value_m char(4000) nullif kpi_value_m=blanks 
    ,kpi_value_yy char(4000) nullif kpi_value_yy=blanks 
    ,kpi_value_mm char(4000) nullif kpi_value_mm=blanks 
    ,kpi_value_yoy char(4000) nullif kpi_value_yoy=blanks 
    ,kpi_value_mom char(4000) nullif kpi_value_mom=blanks 
)