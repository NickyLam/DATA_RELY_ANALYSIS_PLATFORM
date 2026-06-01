: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_onl_bank_tran_flow_i
CreateDate: 20240809
FileName:   ${iel_data_path}/evt_onl_bank_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,tran_dt
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.onl_bank_tran_status_cd,chr(13),''),chr(10),'') as onl_bank_tran_status_cd
,replace(replace(t1.tran_return_code,chr(13),''),chr(10),'') as tran_return_code
,replace(replace(t1.fail_rs,chr(13),''),chr(10),'') as fail_rs
,replace(replace(t1.tran_acct_num,chr(13),''),chr(10),'') as tran_acct_num
,tran_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.whole_unify_cust_id,chr(13),''),chr(10),'') as whole_unify_cust_id
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.chn_send_flow_num,chr(13),''),chr(10),'') as chn_send_flow_num
,replace(replace(t1.sorc_sys_flow_num,chr(13),''),chr(10),'') as sorc_sys_flow_num
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,comm_fee
,replace(replace(t1.visit_flow_num,chr(13),''),chr(10),'') as visit_flow_num
,core_tran_dt
,replace(replace(t1.cust_ip_num,chr(13),''),chr(10),'') as cust_ip_num
,replace(replace(t1.curr_server_host_name,chr(13),''),chr(10),'') as curr_server_host_name
,replace(replace(t1.cust_termn_mac_addr,chr(13),''),chr(10),'') as cust_termn_mac_addr
,replace(replace(t1.cust_termn_oper_sys_edit_num,chr(13),''),chr(10),'') as cust_termn_oper_sys_edit_num
,replace(replace(t1.cust_termn_brow,chr(13),''),chr(10),'') as cust_termn_brow
,replace(replace(t1.cust_termn_equip_model,chr(13),''),chr(10),'') as cust_termn_equip_model
,replace(replace(t1.cust_termn_equip_id,chr(13),''),chr(10),'') as cust_termn_equip_id
,replace(replace(t1.logon_session_id,chr(13),''),chr(10),'') as logon_session_id
,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
,replace(replace(t1.tran_jnl_info,chr(13),''),chr(10),'') as tran_jnl_info
,replace(replace(t1.tran_type_code,chr(13),''),chr(10),'') as tran_type_code
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.save_cert_way_cd,chr(13),''),chr(10),'') as save_cert_way_cd
,replace(replace(t1.splt_flow_num,chr(13),''),chr(10),'') as splt_flow_num
,replace(replace(t1.camp_job_no,chr(13),''),chr(10),'') as camp_job_no
,replace(replace(t1.pbc_flow_num,chr(13),''),chr(10),'') as pbc_flow_num
,replace(replace(t1.user_seq_id,chr(13),''),chr(10),'') as user_seq_id
,replace(replace(t1.tran_order_no,chr(13),''),chr(10),'') as tran_order_no
,replace(replace(t1.chain_way_track_no,chr(13),''),chr(10),'') as chain_way_track_no
,replace(replace(t1.sys_flow_num,chr(13),''),chr(10),'') as sys_flow_num
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id

from ${iml_schema}.evt_onl_bank_tran_flow t1
where t1.tran_dt <= to_date('${batch_date}','yyyymmdd') and t1.tran_dt >= to_date('${batch_date}','yyyymmdd') - 14" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_onl_bank_tran_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
