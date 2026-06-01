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
infile '${data_path}/pams_jxbb_kpikhdfmx_jg.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,tjrq char(4000) nullif tjrq=blanks 
    ,khdxdh char(4000) nullif khdxdh=blanks 
    ,fabh char(4000) nullif fabh=blanks 
    ,famc char(4000) nullif famc=blanks 
    ,zbmc char(4000) nullif zbmc=blanks 
    ,bzdf char(4000) nullif bzdf=blanks 
    ,dfsx char(4000) nullif dfsx=blanks 
    ,dfxx char(4000) nullif dfxx=blanks 
    ,ndmbz char(4000) nullif ndmbz=blanks 
    ,sjjdz char(4000) nullif sjjdz=blanks 
    ,js char(4000) nullif js=blanks 
    ,zbz char(4000) nullif zbz=blanks 
    ,jzz char(4000) nullif jzz=blanks 
    ,khdf char(4000) nullif khdf=blanks 
    ,ndwcl char(4000) nullif ndwcl=blanks 
    ,sjjdwcl char(4000) nullif sjjdwcl=blanks 
    ,xh char(4000) nullif xh=blanks 
)