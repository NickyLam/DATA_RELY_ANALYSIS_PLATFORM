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
infile '${data_path}/ref_tran_bank_code_para.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_ref_tran_bank_code_para
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,tran_code char(4000) nullif tran_code=blanks 
    ,tran_name char(4000) nullif tran_name=blanks 
    ,create_dt date "yyyy-mm-dd hh24:mi:ss" nullif create_dt=blanks 
    ,update_dt date "yyyy-mm-dd hh24:mi:ss" nullif update_dt=blanks 
    ,id_mark char(4000) nullif id_mark=blanks 
    ,fin_tran_flg char(4000) nullif fin_tran_flg=blanks 
)