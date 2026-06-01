: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_evt_onl_bank_tran_flow_a
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_evt_onl_bank_tran_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select evt_id
,lp_id
,flow_num
,tran_tm
,tran_code
,onl_bank_tran_status_cd
,tran_return_code
,fail_rs
,tran_acct_num
,tran_amt
,curr_cd
,whole_unify_cust_id
,tran_chn_cd
,chn_send_flow_num
,sorc_sys_flow_num
,core_tran_flow_num
,comm_fee
,visit_flow_num
,core_tran_dt
,cust_ip_num
,curr_server_host_name
,cust_termn_mac_addr
,cust_termn_oper_sys_edit_num
,cust_termn_brow
,cust_termn_equip_model
,cust_termn_equip_id
,logon_session_id
,rela_flow_num
,tran_jnl_info
,tran_type_cd
,cust_name
,save_cert_way_cd
,splt_flow_num
,camp_job_no
,pbc_flow_num
,user_seq_id
,etl_dt
,job_cd from idl.rpt_evt_onl_bank_tran_flow where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_evt_onl_bank_tran_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes