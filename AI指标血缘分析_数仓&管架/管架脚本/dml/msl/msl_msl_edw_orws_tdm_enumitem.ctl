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
infile '${data_path}/orws_tdm_enumitem.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_orws_tdm_enumitem
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,enumid char(4000) nullif enumid=blanks 
    ,enumsortid char(4000) nullif enumsortid=blanks 
    ,superenumid char(4000) nullif superenumid=blanks 
    ,enumword char(4000) nullif enumword=blanks 
    ,code char(4000) nullif code=blanks 
    ,name char(4000) nullif name=blanks 
    ,seqno char(4000) nullif seqno=blanks 
    ,status char(4000) nullif status=blanks 
    ,managetype char(4000) nullif managetype=blanks 
    ,isdefault char(4000) nullif isdefault=blanks 
    ,iscanselect char(4000) nullif iscanselect=blanks 
    ,remark char(4000) nullif remark=blanks 
)