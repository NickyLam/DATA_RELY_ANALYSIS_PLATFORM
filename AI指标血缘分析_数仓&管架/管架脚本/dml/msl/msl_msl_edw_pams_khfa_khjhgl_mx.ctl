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
infile '${data_path}/pams_khfa_khjhgl_mx.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pams_khfa_khjhgl_mx
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,mxfabh char(4000) nullif mxfabh=blanks 
    ,fabh char(4000) nullif fabh=blanks 
    ,khnf char(4000) nullif khnf=blanks 
    ,jhmc char(4000) nullif jhmc=blanks 
    ,khdx char(4000) nullif khdx=blanks 
    ,lrry char(4000) nullif lrry=blanks 
    ,lrsj timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif lrsj=blanks 
    ,jgkhdxdh char(4000) nullif jgkhdxdh=blanks 
    ,hykhdxdh char(4000) nullif hykhdxdh=blanks 
    ,khzbdh char(4000) nullif khzbdh=blanks 
    ,dw char(4000) nullif dw=blanks 
    ,dbjs char(4000) nullif dbjs=blanks 
    ,ndmbzone char(4000) nullif ndmbzone=blanks 
    ,ndmbztwo char(4000) nullif ndmbztwo=blanks 
    ,ndmbzthree char(4000) nullif ndmbzthree=blanks 
    ,zlddzone char(4000) nullif zlddzone=blanks 
    ,zlddztwo char(4000) nullif zlddztwo=blanks 
    ,zlddzthree char(4000) nullif zlddzthree=blanks 
    ,janone char(4000) nullif janone=blanks 
    ,jantwo char(4000) nullif jantwo=blanks 
    ,janthree char(4000) nullif janthree=blanks 
    ,febone char(4000) nullif febone=blanks 
    ,febtwo char(4000) nullif febtwo=blanks 
    ,febthree char(4000) nullif febthree=blanks 
    ,marone char(4000) nullif marone=blanks 
    ,martwo char(4000) nullif martwo=blanks 
    ,marthree char(4000) nullif marthree=blanks 
    ,aprone char(4000) nullif aprone=blanks 
    ,aprtwo char(4000) nullif aprtwo=blanks 
    ,aprthree char(4000) nullif aprthree=blanks 
    ,mayone char(4000) nullif mayone=blanks 
    ,maytwo char(4000) nullif maytwo=blanks 
    ,maythree char(4000) nullif maythree=blanks 
    ,junone char(4000) nullif junone=blanks 
    ,juntwo char(4000) nullif juntwo=blanks 
    ,junthree char(4000) nullif junthree=blanks 
    ,julone char(4000) nullif julone=blanks 
    ,jultwo char(4000) nullif jultwo=blanks 
    ,julthree char(4000) nullif julthree=blanks 
    ,augone char(4000) nullif augone=blanks 
    ,augtwo char(4000) nullif augtwo=blanks 
    ,augthree char(4000) nullif augthree=blanks 
    ,septone char(4000) nullif septone=blanks 
    ,septtwo char(4000) nullif septtwo=blanks 
    ,septthree char(4000) nullif septthree=blanks 
    ,octone char(4000) nullif octone=blanks 
    ,octtwo char(4000) nullif octtwo=blanks 
    ,octthree char(4000) nullif octthree=blanks 
    ,novone char(4000) nullif novone=blanks 
    ,novtwo char(4000) nullif novtwo=blanks 
    ,novthree char(4000) nullif novthree=blanks 
    ,decone char(4000) nullif decone=blanks 
    ,dectwo char(4000) nullif dectwo=blanks 
    ,decthree char(4000) nullif decthree=blanks 
)