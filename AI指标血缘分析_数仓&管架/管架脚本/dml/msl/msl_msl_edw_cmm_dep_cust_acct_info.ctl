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
infile '${data_path}/cmm_dep_cust_acct_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_cmm_dep_cust_acct_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,cust_acct_id char(4000) nullif cust_acct_id=blanks 
    ,cust_acct_name char(4000) nullif cust_acct_name=blanks 
    ,cust_id char(4000) nullif cust_id=blanks 
    ,max_sub_acct_num char(4000) nullif max_sub_acct_num=blanks 
    ,std_prod_id char(4000) nullif std_prod_id=blanks 
    ,drawdown_way_cd char(4000) nullif drawdown_way_cd=blanks 
    ,acct_status_cd char(4000) nullif acct_status_cd=blanks 
    ,acct_drawdown_way_status char(4000) nullif acct_drawdown_way_status=blanks 
    ,froz_status_cd char(4000) nullif froz_status_cd=blanks 
    ,stop_pay_status_cd char(4000) nullif stop_pay_status_cd=blanks 
    ,acpt_pay_status_cd char(4000) nullif acpt_pay_status_cd=blanks 
    ,acct_usage_cd char(4000) nullif acct_usage_cd=blanks 
    ,vouch_kind_cd char(4000) nullif vouch_kind_cd=blanks 
    ,vouch_char_cd char(4000) nullif vouch_char_cd=blanks 
    ,vouch_form_cd char(4000) nullif vouch_form_cd=blanks 
    ,sleep_acct_flg char(4000) nullif sleep_acct_flg=blanks 
    ,dormt_acct_flg char(4000) nullif dormt_acct_flg=blanks 
    ,privavy_acct_flg char(4000) nullif privavy_acct_flg=blanks 
    ,acct_belong_org_id char(4000) nullif acct_belong_org_id=blanks 
    ,open_acct_org_id char(4000) nullif open_acct_org_id=blanks 
    ,open_acct_teller_id char(4000) nullif open_acct_teller_id=blanks 
    ,open_acct_chn_cd char(4000) nullif open_acct_chn_cd=blanks 
    ,open_acct_flow_num char(4000) nullif open_acct_flow_num=blanks 
    ,open_acct_dt date "yyyy-mm-dd hh24:mi:ss" nullif open_acct_dt=blanks 
    ,open_acct_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif open_acct_tm=blanks 
    ,close_acct_org_id char(4000) nullif close_acct_org_id=blanks 
    ,clos_acct_teller_id char(4000) nullif clos_acct_teller_id=blanks 
    ,clos_acct_flow_num char(4000) nullif clos_acct_flow_num=blanks 
    ,clos_acct_dt date "yyyy-mm-dd hh24:mi:ss" nullif clos_acct_dt=blanks 
    ,clos_acct_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif clos_acct_tm=blanks 
    ,acct_type_cd char(4000) nullif acct_type_cd=blanks 
    ,e_acct_type_cd char(4000) nullif e_acct_type_cd=blanks 
    ,e_acct_status_cd char(4000) nullif e_acct_status_cd=blanks 
    ,netw_vrfction_rest_cd char(4000) nullif netw_vrfction_rest_cd=blanks 
    ,vrif_status_cd char(4000) nullif vrif_status_cd=blanks 
    ,unvrif_rs_descb char(4000) nullif unvrif_rs_descb=blanks 
    ,disp_method_descb char(4000) nullif disp_method_descb=blanks 
    ,tran_chn_status_cd char(4000) nullif tran_chn_status_cd=blanks 
    ,corp_acct_flg char(4000) nullif corp_acct_flg=blanks 
    ,bind_acct_flg char(4000) nullif bind_acct_flg=blanks 
    ,job_cd char(4000) nullif job_cd=blanks 
    ,fiscal_dep_flg char(4000) nullif fiscal_dep_flg=blanks 
    ,curr_cd char(4000) nullif curr_cd=blanks 
    ,cust_acct_card_no char(4000) nullif cust_acct_card_no=blanks 
    ,acct_attr_cd char(4000) nullif acct_attr_cd=blanks 
    ,reg_acct_type_cd char(4000) nullif reg_acct_type_cd=blanks 
    ,src_module_type_cd char(4000) nullif src_module_type_cd=blanks 
    ,acct_id char(4000) nullif acct_id=blanks 
)