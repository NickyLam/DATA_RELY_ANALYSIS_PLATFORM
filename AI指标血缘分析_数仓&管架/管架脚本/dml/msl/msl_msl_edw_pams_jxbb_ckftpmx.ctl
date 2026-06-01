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
infile '${data_path}/pams_jxbb_ckftpmx.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pams_jxbb_ckftpmx
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,tjrq char(4000) nullif tjrq=blanks 
    ,jxdxdh char(4000) nullif jxdxdh=blanks 
    ,khdxdh char(4000) nullif khdxdh=blanks 
    ,zhhm char(4000) nullif zhhm=blanks 
    ,zhdh char(4000) nullif zhdh=blanks 
    ,zzh char(4000) nullif zzh=blanks 
    ,zhbs char(4000) nullif zhbs=blanks 
    ,kh char(4000) nullif kh=blanks 
    ,khh char(4000) nullif khh=blanks 
    ,khjgdh char(4000) nullif khjgdh=blanks 
    ,khjgmc char(4000) nullif khjgmc=blanks 
    ,gsjgdh char(4000) nullif gsjgdh=blanks 
    ,gsjgmc char(4000) nullif gsjgmc=blanks 
    ,khjlgh char(4000) nullif khjlgh=blanks 
    ,khjlxm char(4000) nullif khjlxm=blanks 
    ,fpbl char(4000) nullif fpbl=blanks 
    ,kmh char(4000) nullif kmh=blanks 
    ,kmmc char(4000) nullif kmmc=blanks 
    ,qxmc char(4000) nullif qxmc=blanks 
    ,cph char(4000) nullif cph=blanks 
    ,cpejfl char(4000) nullif cpejfl=blanks 
    ,cpsjfl char(4000) nullif cpsjfl=blanks 
    ,cpsijfl char(4000) nullif cpsijfl=blanks 
    ,cpmc char(4000) nullif cpmc=blanks 
    ,zxll char(4000) nullif zxll=blanks 
    ,sjll char(4000) nullif sjll=blanks 
    ,qxrq char(4000) nullif qxrq=blanks 
    ,dqrq char(4000) nullif dqrq=blanks 
    ,xhrq char(4000) nullif xhrq=blanks 
    ,zzkzqr char(4000) nullif zzkzqr=blanks 
    ,sfzy char(4000) nullif sfzy=blanks 
    ,sfhx char(4000) nullif sfhx=blanks 
    ,bz char(4000) nullif bz=blanks 
    ,zhye char(4000) nullif zhye=blanks 
    ,zhyrjye char(4000) nullif zhyrjye=blanks 
    ,zhnrjye char(4000) nullif zhnrjye=blanks 
    ,ftplxzcylj char(4000) nullif ftplxzcylj=blanks 
    ,ftplxzcnlj char(4000) nullif ftplxzcnlj=blanks 
    ,zyjg char(4000) nullif zyjg=blanks 
    ,ftpsrylj char(4000) nullif ftpsrylj=blanks 
    ,ftpsrnlj char(4000) nullif ftpsrnlj=blanks 
    ,ftpsyylj char(4000) nullif ftpsyylj=blanks 
    ,ftpsynlj char(4000) nullif ftpsynlj=blanks 
    ,zjywsr char(4000) nullif zjywsr=blanks 
    ,ftplxzc char(4000) nullif ftplxzc=blanks 
    ,ftpsr char(4000) nullif ftpsr=blanks 
    ,ftpsy char(4000) nullif ftpsy=blanks 
    ,lxkm char(4000) nullif lxkm=blanks 
    ,lxkmmc char(4000) nullif lxkmmc=blanks 
    ,bzdm char(4000) nullif bzdm=blanks 
    ,qx char(4000) nullif qx=blanks 
    ,ydshrq char(4000) nullif ydshrq=blanks 
    ,zhjrjye char(4000) nullif zhjrjye=blanks 
    ,xhczhll char(4000) nullif xhczhll=blanks 
)