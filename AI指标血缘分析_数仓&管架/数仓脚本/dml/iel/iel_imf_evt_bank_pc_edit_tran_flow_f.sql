: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_bank_pc_edit_tran_flow_f
CreateDate: 20250416
FileName:   ${iel_data_path}/evt_bank_pc_edit_tran_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,tran_tm
,tran_dt
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_order,chr(13),''),chr(10),'') as tran_order
,replace(replace(t1.unify_cust_id,chr(13),''),chr(10),'') as unify_cust_id
,replace(replace(t1.user_seq_num,chr(13),''),chr(10),'') as user_seq_num
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.menu_id,chr(13),''),chr(10),'') as menu_id
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.tran_return_code,chr(13),''),chr(10),'') as tran_return_code
,replace(replace(t1.fail_rs_descb,chr(13),''),chr(10),'') as fail_rs_descb
,replace(replace(t1.tran_acct_num,chr(13),''),chr(10),'') as tran_acct_num
,tran_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.chn_send_flow_id,chr(13),''),chr(10),'') as chn_send_flow_id
,replace(replace(t1.sorc_sys_flow_id,chr(13),''),chr(10),'') as sorc_sys_flow_id
,replace(replace(t1.core_tran_flow_id,chr(13),''),chr(10),'') as core_tran_flow_id
,comm_fee
,replace(replace(t1.parent_flow_id,chr(13),''),chr(10),'') as parent_flow_id
,replace(replace(t1.src_flow_seq_id,chr(13),''),chr(10),'') as src_flow_seq_id
,replace(replace(t1.auth_refuse_rs,chr(13),''),chr(10),'') as auth_refuse_rs
,replace(replace(t1.visit_flow_id,chr(13),''),chr(10),'') as visit_flow_id
,core_tran_dt
,replace(replace(t1.callout_tran_code,chr(13),''),chr(10),'') as callout_tran_code
,replace(replace(t1.cust_ip,chr(13),''),chr(10),'') as cust_ip
,replace(replace(t1.curr_server_host_name,chr(13),''),chr(10),'') as curr_server_host_name
,replace(replace(t1.req_src_server_ip,chr(13),''),chr(10),'') as req_src_server_ip
,replace(replace(t1.cust_termn_mac_addr,chr(13),''),chr(10),'') as cust_termn_mac_addr
,replace(replace(t1.cust_termn_oper_sys,chr(13),''),chr(10),'') as cust_termn_oper_sys
,replace(replace(t1.cust_termn_brow,chr(13),''),chr(10),'') as cust_termn_brow
,replace(replace(t1.cust_termn_equip_model,chr(13),''),chr(10),'') as cust_termn_equip_model
,replace(replace(t1.cust_termn_equip_id,chr(13),''),chr(10),'') as cust_termn_equip_id
,replace(replace(t1.session_id,chr(13),''),chr(10),'') as session_id
,replace(replace(t1.rela_flow_id,chr(13),''),chr(10),'') as rela_flow_id
,replace(replace(t1.save_cert_way_cd,chr(13),''),chr(10),'') as save_cert_way_cd
,replace(replace(t1.auth_status_cd,chr(13),''),chr(10),'') as auth_status_cd
,replace(replace(t1.bank_agent_flg,chr(13),''),chr(10),'') as bank_agent_flg
,replace(replace(t1.auth_role_seq_num,chr(13),''),chr(10),'') as auth_role_seq_num
,submit_core_dt
,submit_core_tm
,tran_tot_qtty
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.chain_way_track_no,chr(13),''),chr(10),'') as chain_way_track_no
,replace(replace(t1.ups_flow_num,chr(13),''),chr(10),'') as ups_flow_num

from ${iml_schema}.evt_bank_pc_edit_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bank_pc_edit_tran_flow.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
