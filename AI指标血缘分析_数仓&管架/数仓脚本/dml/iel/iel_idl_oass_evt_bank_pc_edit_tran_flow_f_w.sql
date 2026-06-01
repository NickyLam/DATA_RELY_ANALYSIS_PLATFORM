: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_evt_bank_pc_edit_tran_flow_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/oass_evt_bank_pc_edit_tran_flow_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.evt_id
,t.lp_id
,t.flow_num
,t.tran_tm
,t.tran_dt
,t.tran_code
,t.tran_order
,t.unify_cust_id
,t.user_seq_num
,t.tran_chn_cd
,t.cust_name
,t.menu_id
,t.tran_status_cd
,t.tran_return_code
,t.fail_rs_descb
,t.tran_acct_num
,t.tran_amt
,t.curr_cd
,t.chn_send_flow_id
,t.sorc_sys_flow_id
,t.core_tran_flow_id
,t.comm_fee
,t.parent_flow_id
,t.src_flow_seq_id
,t.auth_refuse_rs
,t.visit_flow_id
,t.core_tran_dt
,t.callout_tran_code
,t.cust_ip
,t.curr_server_host_name
,t.req_src_server_ip
,t.cust_termn_mac_addr
,t.cust_termn_oper_sys
,t.cust_termn_brow
,t.cust_termn_equip_model
,t.cust_termn_equip_id
,t.session_id
,t.rela_flow_id
,t.save_cert_way_cd
,t.auth_status_cd
,t.bank_agent_flg
,t.auth_role_seq_num
,t.submit_core_dt
,t.submit_core_tm
,t.tran_tot_qtty
,t.remark
,t.create_dt
,t.update_dt
,t.id_mark
from ${idl_schema}.oass_evt_bank_pc_edit_tran_flow t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_evt_bank_pc_edit_tran_flow_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes