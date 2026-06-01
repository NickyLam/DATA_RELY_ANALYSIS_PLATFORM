: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ponl_bk_oper_mgmt_flow_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_ponl_bk_oper_mgmt_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.etl_dt as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.flow_num,chr(13),''),chr(10),'') as flow_num
,t.tran_tm as tran_tm
,replace(replace(t.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t.fail_rs,chr(13),''),chr(10),'') as fail_rs
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,t.tran_amt as tran_amt
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t.chn_send_flow_num,chr(13),''),chr(10),'') as chn_send_flow_num
,replace(replace(t.sorc_sys_flow_num,chr(13),''),chr(10),'') as sorc_sys_flow_num
,replace(replace(t.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,replace(replace(t.cust_ip,chr(13),''),chr(10),'') as cust_ip
,replace(replace(t.curr_server_host_name,chr(13),''),chr(10),'') as curr_server_host_name
,replace(replace(t.req_src_server_ip,chr(13),''),chr(10),'') as req_src_server_ip
,replace(replace(t.cust_termn_mac_addr,chr(13),''),chr(10),'') as cust_termn_mac_addr
,replace(replace(t.cust_termn_oper_sys,chr(13),''),chr(10),'') as cust_termn_oper_sys
,replace(replace(t.cust_termn_brow,chr(13),''),chr(10),'') as cust_termn_brow
,replace(replace(t.cust_termn_equip_model,chr(13),''),chr(10),'') as cust_termn_equip_model
,replace(replace(t.cust_termn_equip_id,chr(13),''),chr(10),'') as cust_termn_equip_id
,replace(replace(t.logon_session_id,chr(13),''),chr(10),'') as logon_session_id
,replace(replace(t.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
,replace(replace(t.tran_jnl_info,chr(13),''),chr(10),'') as tran_jnl_info
,replace(replace(t.tran_type_code,chr(13),''),chr(10),'') as tran_type_code
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.save_cert_way_cd,chr(13),''),chr(10),'') as save_cert_way_cd
,replace(replace(t.func_menu_id,chr(13),''),chr(10),'') as func_menu_id
from iml.evt_ponl_bk_oper_mgmt_flow t
where t.etl_dt >= to_date('20201201','yyyymmdd') and t.etl_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ponl_bk_oper_mgmt_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes