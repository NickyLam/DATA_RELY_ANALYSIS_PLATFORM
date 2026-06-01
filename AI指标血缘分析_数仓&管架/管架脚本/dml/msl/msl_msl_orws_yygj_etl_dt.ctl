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
infile '${data_path}/orws_yygj_etl_dt.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_orws_yygj_etl_dt
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,ETL_TIMESTAMP timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif ETL_TIMESTAMP=blanks 
    ,num char(4000) nullif num=blanks 
    ,import_way char(4000) nullif import_way=blanks 
)