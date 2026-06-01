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
infile '${data_path}/evt_card_change_rgst_b.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_evt_card_change_rgst_b
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,evt_id char(4000) nullif evt_id=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,appl_dt date "yyyy-mm-dd hh24:mi:ss" nullif appl_dt=blanks 
    ,init_card_no char(4000) nullif init_card_no=blanks 
    ,tran_dt date "yyyy-mm-dd hh24:mi:ss" nullif tran_dt=blanks 
    ,tran_org_id char(4000) nullif tran_org_id=blanks 
    ,change_rs_cd char(4000) nullif change_rs_cd=blanks 
    ,modif_type_status_cd char(4000) nullif modif_type_status_cd=blanks 
    ,apot_draw_card_dt date "yyyy-mm-dd hh24:mi:ss" nullif apot_draw_card_dt=blanks 
    ,card_prod_id char(4000) nullif card_prod_id=blanks 
    ,new_card_num char(4000) nullif new_card_num=blanks 
    ,cust_id char(4000) nullif cust_id=blanks 
    ,draw_way_cd char(4000) nullif draw_way_cd=blanks 
    ,save_num_change_card_flg char(4000) nullif save_num_change_card_flg=blanks 
    ,urgent_flg char(4000) nullif urgent_flg=blanks 
    ,loss_id char(4000) nullif loss_id=blanks 
    ,cust_addr char(4000) nullif cust_addr=blanks 
    ,zip_code char(4000) nullif zip_code=blanks 
    ,remark char(4000) nullif remark=blanks 
    ,tel_num char(4000) nullif tel_num=blanks 
    ,tran_teller_id char(4000) nullif tran_teller_id=blanks 
    ,appl_teller_id char(4000) nullif appl_teller_id=blanks 
    ,tran_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif tran_tm=blanks 
    ,cust_acct_num char(4000) nullif cust_acct_num=blanks 
)