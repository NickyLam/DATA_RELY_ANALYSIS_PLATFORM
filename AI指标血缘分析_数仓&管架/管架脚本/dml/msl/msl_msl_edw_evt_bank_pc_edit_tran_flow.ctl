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
infile '${data_path}/evt_bank_pc_edit_tran_flow.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_evt_bank_pc_edit_tran_flow
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,evt_id char(4000) nullif evt_id=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,flow_num char(4000) nullif flow_num=blanks 
    ,tran_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif tran_tm=blanks 
    ,tran_dt date "yyyy-mm-dd hh24:mi:ss" nullif tran_dt=blanks 
    ,tran_code char(4000) nullif tran_code=blanks 
    ,tran_order char(4000) nullif tran_order=blanks 
    ,unify_cust_id char(4000) nullif unify_cust_id=blanks 
    ,user_seq_num char(4000) nullif user_seq_num=blanks 
    ,tran_chn_cd char(4000) nullif tran_chn_cd=blanks 
    ,cust_name char(4000) nullif cust_name=blanks 
    ,menu_id char(4000) nullif menu_id=blanks 
    ,tran_status_cd char(4000) nullif tran_status_cd=blanks 
    ,tran_return_code char(4000) nullif tran_return_code=blanks 
    ,fail_rs_descb char(4000) nullif fail_rs_descb=blanks 
    ,tran_acct_num char(4000) nullif tran_acct_num=blanks 
    ,tran_amt char(4000) nullif tran_amt=blanks 
    ,curr_cd char(4000) nullif curr_cd=blanks 
    ,chn_send_flow_id char(4000) nullif chn_send_flow_id=blanks 
    ,sorc_sys_flow_id char(4000) nullif sorc_sys_flow_id=blanks 
    ,core_tran_flow_id char(4000) nullif core_tran_flow_id=blanks 
    ,comm_fee char(4000) nullif comm_fee=blanks 
    ,parent_flow_id char(4000) nullif parent_flow_id=blanks 
    ,src_flow_seq_id char(4000) nullif src_flow_seq_id=blanks 
    ,auth_refuse_rs char(4000) nullif auth_refuse_rs=blanks 
    ,visit_flow_id char(4000) nullif visit_flow_id=blanks 
    ,core_tran_dt date "yyyy-mm-dd hh24:mi:ss" nullif core_tran_dt=blanks 
    ,callout_tran_code char(4000) nullif callout_tran_code=blanks 
    ,cust_ip char(4000) nullif cust_ip=blanks 
    ,curr_server_host_name char(4000) nullif curr_server_host_name=blanks 
    ,req_src_server_ip char(4000) nullif req_src_server_ip=blanks 
    ,cust_termn_mac_addr char(4000) nullif cust_termn_mac_addr=blanks 
    ,cust_termn_oper_sys char(4000) nullif cust_termn_oper_sys=blanks 
    ,cust_termn_brow char(4000) nullif cust_termn_brow=blanks 
    ,cust_termn_equip_model char(4000) nullif cust_termn_equip_model=blanks 
    ,cust_termn_equip_id char(4000) nullif cust_termn_equip_id=blanks 
    ,session_id char(4000) nullif session_id=blanks 
    ,rela_flow_id char(4000) nullif rela_flow_id=blanks 
    ,save_cert_way_cd char(4000) nullif save_cert_way_cd=blanks 
    ,auth_status_cd char(4000) nullif auth_status_cd=blanks 
    ,bank_agent_flg char(4000) nullif bank_agent_flg=blanks 
    ,auth_role_seq_num char(4000) nullif auth_role_seq_num=blanks 
    ,submit_core_dt date "yyyy-mm-dd hh24:mi:ss" nullif submit_core_dt=blanks 
    ,submit_core_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif submit_core_tm=blanks 
    ,tran_tot_qtty char(4000) nullif tran_tot_qtty=blanks 
    ,remark char(4000) nullif remark=blanks 
    ,bus_flow_num char(4000) nullif bus_flow_num=blanks 
    ,chain_way_track_no char(4000) nullif chain_way_track_no=blanks 
    ,ups_flow_num char(4000) nullif ups_flow_num=blanks 
)