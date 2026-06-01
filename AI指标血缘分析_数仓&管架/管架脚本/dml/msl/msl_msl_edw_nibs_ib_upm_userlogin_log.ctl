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
infile '${data_path}/nibs_ib_upm_userlogin_log.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,username char(4000) nullif username=blanks 
    ,note3 char(4000) nullif note3=blanks 
    ,datereg char(4000) nullif datereg=blanks 
    ,regtype char(4000) nullif regtype=blanks 
    ,deviceoid char(4000) nullif deviceoid=blanks 
    ,branchnum char(4000) nullif branchnum=blanks 
    ,loginstate char(4000) nullif loginstate=blanks 
    ,causefailure char(4000) nullif causefailure=blanks 
    ,sessionid char(4000) nullif sessionid=blanks 
    ,loginip char(4000) nullif loginip=blanks 
    ,usernum char(4000) nullif usernum=blanks 
    ,note4 char(4000) nullif note4=blanks 
    ,note5 char(4000) nullif note5=blanks 
    ,appnum char(4000) nullif appnum=blanks 
    ,note1 char(4000) nullif note1=blanks 
    ,note2 char(4000) nullif note2=blanks 
    ,hostname char(4000) nullif hostname=blanks 
    ,regtime char(4000) nullif regtime=blanks 
    ,outflag char(4000) nullif outflag=blanks 
)