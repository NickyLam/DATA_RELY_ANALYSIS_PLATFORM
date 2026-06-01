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
infile '${data_path}/orws_t_ghbr_bv_statistics_sys.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics_sys
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,statistics_id char(4000) nullif statistics_id=blanks 
    ,sys_name char(4000) nullif sys_name=blanks 
    ,id char(4000) nullif id=blanks 
    ,sys_weight_txnvol char(4000) nullif sys_weight_txnvol=blanks 
    ,sys_txnvol char(4000) nullif sys_txnvol=blanks 
)