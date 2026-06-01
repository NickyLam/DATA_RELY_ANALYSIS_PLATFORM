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
infile '${data_path}/pams_jxbb_ckftphz.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pams_jxbb_ckftphz
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,tjrq char(4000) nullif tjrq=blanks 
    ,kmh char(4000) nullif kmh=blanks 
    ,kmmc char(4000) nullif kmmc=blanks 
    ,cpmc char(4000) nullif cpmc=blanks 
    ,zhye char(4000) nullif zhye=blanks 
    ,zhyrjye char(4000) nullif zhyrjye=blanks 
    ,zhnrjye char(4000) nullif zhnrjye=blanks 
    ,jqll char(4000) nullif jqll=blanks 
    ,ftplxzcylj char(4000) nullif ftplxzcylj=blanks 
    ,ftplxzcnlj char(4000) nullif ftplxzcnlj=blanks 
    ,jqftpjg char(4000) nullif jqftpjg=blanks 
    ,ftpsrylj char(4000) nullif ftpsrylj=blanks 
    ,ftpsrnlj char(4000) nullif ftpsrnlj=blanks 
    ,ftpsyylj char(4000) nullif ftpsyylj=blanks 
    ,ftpsynlj char(4000) nullif ftpsynlj=blanks 
    ,lxkm char(4000) nullif lxkm=blanks 
    ,lxkmmc char(4000) nullif lxkmmc=blanks 
    ,khjgh char(4000) nullif khjgh=blanks 
    ,khjgmc char(4000) nullif khjgmc=blanks 
    ,ssjgh char(4000) nullif ssjgh=blanks 
    ,ssjgmc char(4000) nullif ssjgmc=blanks 
    ,bz char(4000) nullif bz=blanks 
)