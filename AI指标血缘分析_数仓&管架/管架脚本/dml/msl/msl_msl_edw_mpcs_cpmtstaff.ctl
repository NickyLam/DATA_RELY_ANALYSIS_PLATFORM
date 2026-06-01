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
infile '${data_path}/mpcs_cpmtstaff.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_mpcs_cpmtstaff
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,staffno char(4000) nullif staffno=blanks 
    ,tlrtype char(4000) nullif tlrtype=blanks 
    ,staffname char(4000) nullif staffname=blanks 
    ,sex char(4000) nullif sex=blanks 
    ,birthday char(4000) nullif birthday=blanks 
    ,idtype char(4000) nullif idtype=blanks 
    ,idno char(4000) nullif idno=blanks 
    ,ofinstno char(4000) nullif ofinstno=blanks 
    ,ofdeptno char(4000) nullif ofdeptno=blanks 
    ,stafftype char(4000) nullif stafftype=blanks 
    ,mobile char(4000) nullif mobile=blanks 
    ,email char(4000) nullif email=blanks 
    ,safemode char(4000) nullif safemode=blanks 
    ,signpswd char(4000) nullif signpswd=blanks 
    ,pswdchgdt char(4000) nullif pswdchgdt=blanks 
    ,rowstat char(4000) nullif rowstat=blanks 
    ,upddt char(4000) nullif upddt=blanks 
    ,updtm char(4000) nullif updtm=blanks 
    ,ygno char(4000) nullif ygno=blanks 
    ,motto char(4000) nullif motto=blanks 
    ,ofdeptnm char(4000) nullif ofdeptnm=blanks 
)