: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_p_onl_bank_serv_bus_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_p_onl_bank_serv_bus_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,evt_id
,lp_id
,flow_num
,tran_dt
,tran_tm
,tran_code
,tran_status_cd
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
,tran_type_code
,cust_name
,save_cert_way_cd
,camp_job_no
,pbc_flow_num
,user_seq_id from idl.aml_p_onl_bank_serv_bus_flow where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_p_onl_bank_serv_bus_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes