: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_evt_bank_pc_edit_tran_flow_a
CreateDate: 20220606
FileName:   ${iel_data_path}/rpt_evt_bank_pc_edit_tran_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
   sundexin
' \
        query="select etl_dt
,evt_id
,lp_id
,flow_num
,tran_tm
,tran_dt
,tran_code
,tran_order
,unify_cust_id
,user_seq_num
,tran_chn_cd
,cust_name
,menu_id
,tran_status_cd
,tran_return_code
,fail_rs_descb
,tran_acct_num
,tran_amt
,curr_cd
,chn_send_flow_id
,sorc_sys_flow_id
,core_tran_flow_id
,comm_fee
,parent_flow_id
,src_flow_seq_id
,auth_refuse_rs
,visit_flow_id
,core_tran_dt
,callout_tran_code
,cust_ip
,curr_server_host_name
,req_src_server_ip
,cust_termn_mac_addr
,cust_termn_oper_sys
,cust_termn_brow
,cust_termn_equip_model
,cust_termn_equip_id
,session_id
,rela_flow_id
,save_cert_way_cd
,auth_status_cd
,bank_agent_flg
,auth_role_seq_num
,submit_core_dt
,submit_core_tm
,tran_tot_qtty
,remark from idl.rpt_evt_bank_pc_edit_tran_flow 
where tran_dt between to_date('${batch_date}','yyyymmdd')-30 and to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_evt_bank_pc_edit_tran_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes