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
infile '${data_path}/orws_yygj.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_orws_yygj
fields terminated by x'1b' 
trailing nullcols
(
    id char(4000) nullif id=blanks 
    ,organnum char(4000) nullif organnum=blanks 
    ,risk_level char(4000) nullif risk_level=blanks 
    ,num char(4000) nullif num=blanks 
    ,task_date date "yyyy-mm-dd hh24:mi:ss" nullif task_date=blanks 
    ,craete_date timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif craete_date=blanks 
    ,type_name char(4000) nullif type_name=blanks 
    ,problemer_no char(4000) nullif problemer_no=blanks 
    ,problemer_name char(4000) nullif problemer_name=blanks 
)