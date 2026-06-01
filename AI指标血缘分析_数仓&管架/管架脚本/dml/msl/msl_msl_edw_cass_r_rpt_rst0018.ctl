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
infile '/mcs/data/input/${last_month_end}/msl/cass_r_rpt_rst0018.i.${last_month_end}.dat'
truncate into table ${msl_schema}.msl_edw_cass_r_rpt_rst0018
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,etl_dt_ora date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt_ora=blanks 
    ,index_name char(4000) nullif index_name=blanks 
    ,curr_cd char(4000) nullif curr_cd=blanks 
    ,curr_name char(4000) nullif curr_name=blanks 
    ,manager_org char(4000) nullif manager_org=blanks 
    ,manager_org_name char(4000) nullif manager_org_name=blanks 
    ,kpi_value_mm char(4000) nullif kpi_value_mm=blanks 
    ,kpi_value_mom char(4000) nullif kpi_value_mom=blanks 
)