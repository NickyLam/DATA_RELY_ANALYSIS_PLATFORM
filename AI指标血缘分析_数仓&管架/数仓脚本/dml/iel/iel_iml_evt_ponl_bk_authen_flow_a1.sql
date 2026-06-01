: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ponl_bk_authen_flow_a1
CreateDate: 20240312
FileName:   ${iel_data_path}/evt_ponl_bk_authen_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t1.fail_rs,chr(13),''),chr(10),'') as fail_rs
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,tran_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.chn_send_flow_num,chr(13),''),chr(10),'') as chn_send_flow_num
,replace(replace(t1.sorc_sys_flow_num,chr(13),''),chr(10),'') as sorc_sys_flow_num
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,replace(replace(t1.cust_ip,chr(13),''),chr(10),'') as cust_ip
,replace(replace(t1.curr_server_host_name,chr(13),''),chr(10),'') as curr_server_host_name
,replace(replace(t1.req_src_server_ip,chr(13),''),chr(10),'') as req_src_server_ip
,replace(replace(t1.cust_termn_mac_addr,chr(13),''),chr(10),'') as cust_termn_mac_addr
,replace(replace(t1.cust_termn_oper_sys,chr(13),''),chr(10),'') as cust_termn_oper_sys
,replace(replace(t1.cust_termn_brow,chr(13),''),chr(10),'') as cust_termn_brow
,replace(replace(t1.cust_termn_equip_model,chr(13),''),chr(10),'') as cust_termn_equip_model
,replace(replace(t1.cust_termn_equip_id,chr(13),''),chr(10),'') as cust_termn_equip_id
,replace(replace(t1.logon_session_id,chr(13),''),chr(10),'') as logon_session_id
,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
,replace(replace(t1.tran_jnl_info,chr(13),''),chr(10),'') as tran_jnl_info
,replace(replace(t1.tran_type_code,chr(13),''),chr(10),'') as tran_type_code
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.save_cert_way_cd,chr(13),''),chr(10),'') as save_cert_way_cd
,replace(replace(t1.func_menu_id,chr(13),''),chr(10),'') as func_menu_id
,replace(replace(t1.tran_order_no,chr(13),''),chr(10),'') as tran_order_no
,replace(replace(t1.chain_way_track_no,chr(13),''),chr(10),'') as chain_way_track_no
,replace(replace(t1.sys_flow_num,chr(13),''),chr(10),'') as sys_flow_num
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id

from ${iml_schema}.evt_ponl_bk_authen_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('20240101','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ponl_bk_authen_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
