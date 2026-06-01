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
infile '${data_path}/pams_jxbb_tycdmx_recal.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pams_jxbb_tycdmx_recal
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,tjrq char(4000) nullif tjrq=blanks 
    ,jxdxdh char(4000) nullif jxdxdh=blanks 
    ,khdxdh char(4000) nullif khdxdh=blanks 
    ,jgkhdxdh char(4000) nullif jgkhdxdh=blanks 
    ,jgdh char(4000) nullif jgdh=blanks 
    ,jgmc char(4000) nullif jgmc=blanks 
    ,hydh char(4000) nullif hydh=blanks 
    ,hymc char(4000) nullif hymc=blanks 
    ,ywbh char(4000) nullif ywbh=blanks 
    ,cddm char(4000) nullif cddm=blanks 
    ,cdjc char(4000) nullif cdjc=blanks 
    ,ssjgkhdxdh char(4000) nullif ssjgkhdxdh=blanks 
    ,ssjgdh char(4000) nullif ssjgdh=blanks 
    ,ssjgmc char(4000) nullif ssjgmc=blanks 
    ,fxrq char(4000) nullif fxrq=blanks 
    ,qxrq char(4000) nullif qxrq=blanks 
    ,dqrq char(4000) nullif dqrq=blanks 
    ,dfrq char(4000) nullif dfrq=blanks 
    ,qx char(4000) nullif qx=blanks 
    ,jxts char(4000) nullif jxts=blanks 
    ,fxjg char(4000) nullif fxjg=blanks 
    ,nll char(4000) nullif nll=blanks 
    ,fxl char(4000) nullif fxl=blanks 
    ,fxje char(4000) nullif fxje=blanks 
    ,bqye char(4000) nullif bqye=blanks 
    ,sjtzrkhh char(4000) nullif sjtzrkhh=blanks 
    ,sjtzrqc char(4000) nullif sjtzrqc=blanks 
    ,fxjgmc char(4000) nullif fxjgmc=blanks 
    ,xsjgmc char(4000) nullif xsjgmc=blanks 
    ,nrj char(4000) nullif nrj=blanks 
    ,yrj char(4000) nullif yrj=blanks 
    ,nzc char(4000) nullif nzc=blanks 
    ,yzc char(4000) nullif yzc=blanks 
    ,ftpll char(4000) nullif ftpll=blanks 
    ,dyftpjsr char(4000) nullif dyftpjsr=blanks 
    ,ljftpjsr char(4000) nullif ljftpjsr=blanks 
    ,fpbl char(4000) nullif fpbl=blanks 
    ,fpjs char(4000) nullif fpjs=blanks 
    ,ftplxsrylj char(4000) nullif ftplxsrylj=blanks 
    ,ftplxsrnlj char(4000) nullif ftplxsrnlj=blanks 
    ,rzc char(4000) nullif rzc=blanks 
    ,drftpjsr char(4000) nullif drftpjsr=blanks 
    ,dnftpjsr char(4000) nullif dnftpjsr=blanks 
    ,ftplxsr char(4000) nullif ftplxsr=blanks 
    ,xsjgmczh char(4000) nullif xsjgmczh=blanks 
    ,xsjgmczb char(4000) nullif xsjgmczb=blanks 
    ,gsjgmczh char(4000) nullif gsjgmczh=blanks 
    ,gsjgmczb char(4000) nullif gsjgmczb=blanks 
    ,cpdm char(4000) nullif cpdm=blanks 
    ,fptx char(4000) nullif fptx=blanks 
    ,txfpbl char(4000) nullif txfpbl=blanks 
    ,cjdrgjgkhh char(4000) nullif cjdrgjgkhh=blanks 
    ,cjdrgjg char(4000) nullif cjdrgjg=blanks 
    ,sjrgfkhh char(4000) nullif sjrgfkhh=blanks 
    ,sjrgfqc char(4000) nullif sjrgfqc=blanks 
    ,tycb char(4000) nullif tycb=blanks 
    ,recal_dt char(4000) nullif recal_dt=blanks 
)