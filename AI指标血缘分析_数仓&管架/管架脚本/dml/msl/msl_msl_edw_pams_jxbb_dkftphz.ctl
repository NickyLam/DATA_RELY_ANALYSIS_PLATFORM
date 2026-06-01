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
infile '${data_path}/pams_jxbb_dkftphz.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pams_jxbb_dkftphz
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,tjrq char(4000) nullif tjrq=blanks 
    ,kmh char(4000) nullif kmh=blanks 
    ,kmmc char(4000) nullif kmmc=blanks 
    ,cpbh char(4000) nullif cpbh=blanks 
    ,cpzwmc char(4000) nullif cpzwmc=blanks 
    ,ye char(4000) nullif ye=blanks 
    ,yrj char(4000) nullif yrj=blanks 
    ,nrj char(4000) nullif nrj=blanks 
    ,jqll char(4000) nullif jqll=blanks 
    ,ylx char(4000) nullif ylx=blanks 
    ,nlx char(4000) nullif nlx=blanks 
    ,jqftpjg char(4000) nullif jqftpjg=blanks 
    ,dyftpzycb char(4000) nullif dyftpzycb=blanks 
    ,ljftpzycb char(4000) nullif ljftpzycb=blanks 
    ,dyftpjsy char(4000) nullif dyftpjsy=blanks 
    ,ljftpjsy char(4000) nullif ljftpjsy=blanks 
    ,lxkm char(4000) nullif lxkm=blanks 
    ,lxkmmc char(4000) nullif lxkmmc=blanks 
    ,khjgh char(4000) nullif khjgh=blanks 
    ,khjgmc char(4000) nullif khjgmc=blanks 
    ,ssjgh char(4000) nullif ssjgh=blanks 
    ,ssjgmc char(4000) nullif ssjgmc=blanks 
    ,yqxyss char(4000) nullif yqxyss=blanks 
    ,fxjqzcje char(4000) nullif fxjqzcje=blanks 
    ,bz char(4000) nullif bz=blanks 
    ,frje char(4000) nullif frje=blanks 
    ,hyfrje char(4000) nullif hyfrje=blanks 
)