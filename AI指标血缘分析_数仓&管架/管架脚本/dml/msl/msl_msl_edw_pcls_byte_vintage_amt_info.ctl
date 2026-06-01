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
infile '${data_path}/pcls_byte_vintage_amt_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pcls_byte_vintage_amt_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,monthcreated2 char(4000) nullif monthcreated2=blanks 
    ,vintage3plus_mob1_amt char(4000) nullif vintage3plus_mob1_amt=blanks 
    ,vintage3plus_mob2_amt char(4000) nullif vintage3plus_mob2_amt=blanks 
    ,vintage3plus_mob3_amt char(4000) nullif vintage3plus_mob3_amt=blanks 
    ,vintage7plus_mob1_amt char(4000) nullif vintage7plus_mob1_amt=blanks 
    ,vintage7plus_mob2_amt char(4000) nullif vintage7plus_mob2_amt=blanks 
    ,vintage7plus_mob3_amt char(4000) nullif vintage7plus_mob3_amt=blanks 
    ,vintage30plus_mob1_amt char(4000) nullif vintage30plus_mob1_amt=blanks 
    ,vintage30plus_mob2_amt char(4000) nullif vintage30plus_mob2_amt=blanks 
    ,vintage30plus_mob3_amt char(4000) nullif vintage30plus_mob3_amt=blanks 
)