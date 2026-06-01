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
infile '${data_path}/ref_chn_tran_cd_para.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_ref_chn_tran_cd_para
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,chn_cd char(4000) nullif chn_cd=blanks 
    ,tran_cd char(4000) nullif tran_cd=blanks 
    ,intnal_tran_cd char(4000) nullif intnal_tran_cd=blanks 
    ,msg_type_cd char(4000) nullif msg_type_cd=blanks 
    ,tran_proc_cd char(4000) nullif tran_proc_cd=blanks 
    ,tran_name char(4000) nullif tran_name=blanks 
    ,bank_int_proc_cd char(4000) nullif bank_int_proc_cd=blanks 
    ,obank_proc_cd char(4000) nullif obank_proc_cd=blanks 
    ,status_cd char(4000) nullif status_cd=blanks 
    ,fobid_flg char(4000) nullif fobid_flg=blanks 
    ,deflt_memo_cd char(4000) nullif deflt_memo_cd=blanks 
    ,memo_name char(4000) nullif memo_name=blanks 
    ,create_dt date "yyyy-mm-dd hh24:mi:ss" nullif create_dt=blanks 
    ,update_dt date "yyyy-mm-dd hh24:mi:ss" nullif update_dt=blanks 
    ,id_mark char(4000) nullif id_mark=blanks 
)