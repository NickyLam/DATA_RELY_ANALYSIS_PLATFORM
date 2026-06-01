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
infile '${data_path}/pams_jxbb_dkftpmx.a.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pams_jxbb_dkftpmx
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,tjrq char(4000) nullif tjrq=blanks 
    ,khm char(4000) nullif khm=blanks 
    ,khh char(4000) nullif khh=blanks 
    ,khjgkhdxdh char(4000) nullif khjgkhdxdh=blanks 
    ,khjgh char(4000) nullif khjgh=blanks 
    ,khjgmc char(4000) nullif khjgmc=blanks 
    ,ssjgkhdxdh char(4000) nullif ssjgkhdxdh=blanks 
    ,ssjgh char(4000) nullif ssjgh=blanks 
    ,ssjgmc char(4000) nullif ssjgmc=blanks 
    ,khjlgh char(4000) nullif khjlgh=blanks 
    ,khjlxm char(4000) nullif khjlxm=blanks 
    ,fpbl char(4000) nullif fpbl=blanks 
    ,zhbs char(4000) nullif zhbs=blanks 
    ,xwdkbs char(4000) nullif xwdkbs=blanks 
    ,jjh char(4000) nullif jjh=blanks 
    ,jjzt char(4000) nullif jjzt=blanks 
    ,dqzxll char(4000) nullif dqzxll=blanks 
    ,jzll char(4000) nullif jzll=blanks 
    ,fdbl char(4000) nullif fdbl=blanks 
    ,fdfs char(4000) nullif fdfs=blanks 
    ,kmh char(4000) nullif kmh=blanks 
    ,kmmc char(4000) nullif kmmc=blanks 
    ,cpbh char(4000) nullif cpbh=blanks 
    ,cpejfl char(4000) nullif cpejfl=blanks 
    ,cpsjfl char(4000) nullif cpsjfl=blanks 
    ,cpsijfl char(4000) nullif cpsijfl=blanks 
    ,cpzwmc char(4000) nullif cpzwmc=blanks 
    ,sfxw char(4000) nullif sfxw=blanks 
    ,qx char(4000) nullif qx=blanks 
    ,fkr char(4000) nullif fkr=blanks 
    ,dqr char(4000) nullif dqr=blanks 
    ,bz char(4000) nullif bz=blanks 
    ,ye char(4000) nullif ye=blanks 
    ,yrj char(4000) nullif yrj=blanks 
    ,nrj char(4000) nullif nrj=blanks 
    ,ylx char(4000) nullif ylx=blanks 
    ,nlx char(4000) nullif nlx=blanks 
    ,ftpjg char(4000) nullif ftpjg=blanks 
    ,dyftpzycb char(4000) nullif dyftpzycb=blanks 
    ,ljftpzycb char(4000) nullif ljftpzycb=blanks 
    ,dyftpjsy char(4000) nullif dyftpjsy=blanks 
    ,ljftpjsy char(4000) nullif ljftpjsy=blanks 
    ,ftplxsr char(4000) nullif ftplxsr=blanks 
    ,ftpzycb char(4000) nullif ftpzycb=blanks 
    ,ftpsy char(4000) nullif ftpsy=blanks 
    ,lxkm char(4000) nullif lxkm=blanks 
    ,lxkmmc char(4000) nullif lxkmmc=blanks 
    ,pjh char(4000) nullif pjh=blanks 
    ,wjfl char(4000) nullif wjfl=blanks 
    ,yqxyss char(4000) nullif yqxyss=blanks 
    ,jrj char(4000) nullif jrj=blanks 
    ,jlx char(4000) nullif jlx=blanks 
    ,djftpzycb char(4000) nullif djftpzycb=blanks 
    ,djftpjsy char(4000) nullif djftpjsy=blanks 
    ,bwbs char(4000) nullif bwbs=blanks 
    ,gyljrywbz char(4000) nullif gyljrywbz=blanks 
	,fxjqzcje char(4000) nullif fxjqzcje=blanks 
    ,fptx char(4000) nullif fptx=blanks 
)