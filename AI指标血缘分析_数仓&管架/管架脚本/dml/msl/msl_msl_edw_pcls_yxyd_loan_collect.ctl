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
infile '${data_path}/pcls_yxyd_loan_collect.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pcls_yxyd_loan_collect
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,month_due char(4000) nullif month_due=blanks 
    ,prin_amt char(4000) nullif prin_amt=blanks 
    ,prin_cnt char(4000) nullif prin_cnt=blanks 
    ,dpd1_amt char(4000) nullif dpd1_amt=blanks 
    ,dpd4_amt char(4000) nullif dpd4_amt=blanks 
    ,dpd8_amt char(4000) nullif dpd8_amt=blanks 
    ,dpd1_cnt char(4000) nullif dpd1_cnt=blanks 
    ,dpd4_cnt char(4000) nullif dpd4_cnt=blanks 
    ,dpd8_cnt char(4000) nullif dpd8_cnt=blanks 
    ,delinquency_rate char(4000) nullif delinquency_rate=blanks 
    ,delinquency_3_rate char(4000) nullif delinquency_3_rate=blanks 
    ,delinquency_7_rate char(4000) nullif delinquency_7_rate=blanks 
)