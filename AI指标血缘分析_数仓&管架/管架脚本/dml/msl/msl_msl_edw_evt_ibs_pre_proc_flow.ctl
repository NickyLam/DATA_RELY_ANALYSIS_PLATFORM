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
infile '${data_path}/evt_ibs_pre_proc_flow.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,evt_id char(4000) nullif evt_id=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,pre_proc_id char(4000) nullif pre_proc_id=blanks 
    ,init_pre_proc_id char(4000) nullif init_pre_proc_id=blanks 
    ,bus_type_cd char(4000) nullif bus_type_cd=blanks 
    ,pre_proc_status_cd char(4000) nullif pre_proc_status_cd=blanks 
    ,tran_flow_num char(4000) nullif tran_flow_num=blanks 
    ,init_chn_cd char(4000) nullif init_chn_cd=blanks 
    ,flow_bank_proc_flow_num char(4000) nullif flow_bank_proc_flow_num=blanks 
    ,appl_dt date "yyyy-mm-dd hh24:mi:ss" nullif appl_dt=blanks 
    ,appl_org_id char(4000) nullif appl_org_id=blanks 
    ,acct_id char(4000) nullif acct_id=blanks 
    ,acct_name char(4000) nullif acct_name=blanks 
    ,cust_id char(4000) nullif cust_id=blanks 
    ,cust_name char(4000) nullif cust_name=blanks 
    ,cert_type_cd char(4000) nullif cert_type_cd=blanks 
    ,cert_no char(4000) nullif cert_no=blanks 
    ,cert_name char(4000) nullif cert_name=blanks 
    ,agent_flg char(4000) nullif agent_flg=blanks 
    ,agent_cert_type_cd char(4000) nullif agent_cert_type_cd=blanks 
    ,agent_cert_no char(4000) nullif agent_cert_no=blanks 
    ,agent_cert_name char(4000) nullif agent_cert_name=blanks 
    ,agent_cont_mode_cd char(4000) nullif agent_cont_mode_cd=blanks 
    ,mobile_no char(4000) nullif mobile_no=blanks 
    ,precon_id char(4000) nullif precon_id=blanks 
    ,wdraw_usage_and_reason char(4000) nullif wdraw_usage_and_reason=blanks 
    ,other_usage char(4000) nullif other_usage=blanks 
    ,par_type_comb char(4000) nullif par_type_comb=blanks 
    ,par_type_amt_comb char(4000) nullif par_type_amt_comb=blanks 
    ,curr_cd char(4000) nullif curr_cd=blanks 
    ,wdraw_lmt_comb char(4000) nullif wdraw_lmt_comb=blanks 
    ,tran_type_cd char(4000) nullif tran_type_cd=blanks 
    ,card_status_cd char(4000) nullif card_status_cd=blanks 
    ,bus_content_descb char(4000) nullif bus_content_descb=blanks 
    ,remark char(4000) nullif remark=blanks 
    ,create_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif create_tm=blanks 
    ,create_teller_id char(4000) nullif create_teller_id=blanks 
    ,start_dt date "yyyy-mm-dd hh24:mi:ss" nullif start_dt=blanks 
    ,end_dt date "yyyy-mm-dd hh24:mi:ss" nullif end_dt=blanks 
    ,id_mark char(4000) nullif id_mark=blanks 
)