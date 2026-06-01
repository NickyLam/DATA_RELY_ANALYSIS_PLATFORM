: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_evt_onl_bank_tran_flow_i
CreateDate: 20230117
FileName:   ${iel_data_path}/oass_evt_onl_bank_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.evt_id as evt_id
,t1.lp_id as lp_id
,t1.flow_num as flow_num
,t1.tran_dt as tran_dt
,t1.tran_tm as tran_tm
,t1.tran_code as tran_code
,t1.onl_bank_tran_status_cd as onl_bank_tran_status_cd
,t1.tran_return_code as tran_return_code
,t1.fail_rs as fail_rs
,t1.tran_acct_num as tran_acct_num
,t1.tran_amt as tran_amt
,t1.curr_cd as curr_cd
,t1.whole_unify_cust_id as whole_unify_cust_id
,t1.tran_chn_cd as tran_chn_cd
,t1.chn_send_flow_num as chn_send_flow_num
,t1.sorc_sys_flow_num as sorc_sys_flow_num
,t1.core_tran_flow_num as core_tran_flow_num
,t1.comm_fee as comm_fee
,t1.visit_flow_num as visit_flow_num
,t1.core_tran_dt as core_tran_dt
,t1.cust_ip_num as cust_ip_num
,t1.curr_server_host_name as curr_server_host_name
,t1.cust_termn_mac_addr as cust_termn_mac_addr
,t1.cust_termn_oper_sys_edit_num as cust_termn_oper_sys_edit_num
,t1.cust_termn_brow as cust_termn_brow
,t1.cust_termn_equip_model as cust_termn_equip_model
,t1.cust_termn_equip_id as cust_termn_equip_id
,t1.logon_session_id as logon_session_id
,t1.rela_flow_num as rela_flow_num
,t1.tran_jnl_info as tran_jnl_info
,t1.tran_type_code as tran_type_code
,t1.cust_name as cust_name
,t1.save_cert_way_cd as save_cert_way_cd
,t1.splt_flow_num as splt_flow_num
,t1.camp_job_no as camp_job_no
,t1.pbc_flow_num as pbc_flow_num
,t1.user_seq_id as user_seq_id
,t1.tran_order_no as tran_order_no
,t1.chain_way_track_no as chain_way_track_no
,t1.sys_flow_num as sys_flow_num
,t1.chn_id as chn_id

from ${idl_schema}.oass_evt_onl_bank_tran_flow t1
where substr(t.tran_dt,1,8) <= '${batch_date}' and iml.dateformat_max(substr(t.tran_dt,1,8)) >= to_date('${batch_date}','yyyymmdd') - 14" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_evt_onl_bank_tran_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
