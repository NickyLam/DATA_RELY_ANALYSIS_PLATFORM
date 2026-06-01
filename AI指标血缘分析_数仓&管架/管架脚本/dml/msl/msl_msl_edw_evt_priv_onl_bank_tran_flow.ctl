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
infile '${data_path}/evt_priv_onl_bank_tran_flow.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,evt_id char(4000) nullif evt_id=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,main_flow_num char(4000) nullif main_flow_num=blanks 
    ,tran_flow_num char(4000) nullif tran_flow_num=blanks 
    ,ova_flow_num char(4000) nullif ova_flow_num=blanks 
    ,whole_unify_cust_id char(4000) nullif whole_unify_cust_id=blanks 
    ,cust_name char(4000) nullif cust_name=blanks 
    ,user_seq_num char(4000) nullif user_seq_num=blanks 
    ,tran_code char(4000) nullif tran_code=blanks 
    ,bus_gen_cd char(4000) nullif bus_gen_cd=blanks 
    ,bus_type_cd char(4000) nullif bus_type_cd=blanks 
    ,tran_dt date "yyyy-mm-dd hh24:mi:ss" nullif tran_dt=blanks 
    ,tran_tm char(4000) nullif tran_tm=blanks 
    ,tran_acct_num char(4000) nullif tran_acct_num=blanks 
    ,curr_cd char(4000) nullif curr_cd=blanks 
    ,tran_amt char(4000) nullif tran_amt=blanks 
    ,comm_fee char(4000) nullif comm_fee=blanks 
    ,sys_id char(4000) nullif sys_id=blanks 
    ,sorc_sys_id char(4000) nullif sorc_sys_id=blanks 
    ,four_chn_cd char(4000) nullif four_chn_cd=blanks 
    ,tran_status_cd char(4000) nullif tran_status_cd=blanks 
    ,tran_err_cd char(4000) nullif tran_err_cd=blanks 
    ,tran_err_descb char(4000) nullif tran_err_descb=blanks 
    ,core_tran_flow_num char(4000) nullif core_tran_flow_num=blanks 
    ,core_tran_dt date "yyyy-mm-dd hh24:mi:ss" nullif core_tran_dt=blanks 
    ,visit_flow_num char(4000) nullif visit_flow_num=blanks 
    ,rela_flow_num char(4000) nullif rela_flow_num=blanks 
    ,proc_server_ip char(4000) nullif proc_server_ip=blanks 
    ,logon_node_id char(4000) nullif logon_node_id=blanks 
    ,substep_tran_scrt_key char(4000) nullif substep_tran_scrt_key=blanks 
    ,tran_comnt char(4000) nullif tran_comnt=blanks 
    ,tran_type_cd char(4000) nullif tran_type_cd=blanks 
    ,func_menu_id char(4000) nullif func_menu_id=blanks 
    ,client_ip char(4000) nullif client_ip=blanks 
    ,client_mac char(4000) nullif client_mac=blanks 
    ,equip_id char(4000) nullif equip_id=blanks 
    ,equip_brand_name char(4000) nullif equip_brand_name=blanks 
    ,equip_model char(4000) nullif equip_model=blanks 
    ,brow_type_cd char(4000) nullif brow_type_cd=blanks 
    ,brow_edit_num char(4000) nullif brow_edit_num=blanks 
    ,loitde char(4000) nullif loitde=blanks 
    ,dimen char(4000) nullif dimen=blanks 
    ,teller_id char(4000) nullif teller_id=blanks 
    ,teller_belong_org_id char(4000) nullif teller_belong_org_id=blanks 
    ,tran_req_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif tran_req_tm=blanks 
    ,tran_resp_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif tran_resp_tm=blanks 
    ,tran_order_no char(4000) nullif tran_order_no=blanks 
    ,chain_way_track_no char(4000) nullif chain_way_track_no=blanks 
    ,sys_flow_num char(4000) nullif sys_flow_num=blanks 
    ,chn_id char(4000) nullif chn_id=blanks 
)