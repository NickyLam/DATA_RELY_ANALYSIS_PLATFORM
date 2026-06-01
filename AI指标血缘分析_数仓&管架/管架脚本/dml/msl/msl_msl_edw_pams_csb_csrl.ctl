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
infile '${data_path}/pams_csb_csrl.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pams_csb_csrl
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,tjrq char(4000) nullif tjrq=blanks 
    ,xqj char(4000) nullif xqj=blanks 
    ,sfcs char(4000) nullif sfcs=blanks 
    ,csts char(4000) nullif csts=blanks 
    ,csqsrq char(4000) nullif csqsrq=blanks 
    ,csjsrq char(4000) nullif csjsrq=blanks 
    ,rqlx char(4000) nullif rqlx=blanks 
    ,dqcsrq char(4000) nullif dqcsrq=blanks 
    ,cszt char(4000) nullif cszt=blanks 
)