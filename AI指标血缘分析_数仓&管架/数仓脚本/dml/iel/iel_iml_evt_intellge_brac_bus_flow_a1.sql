: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_intellge_brac_bus_flow_a1
CreateDate: 20240812
FileName:   ${iel_data_path}/evt_intellge_brac_bus_flow.i.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,chn_dt
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.ups_flow_num,chr(13),''),chr(10),'') as ups_flow_num
,replace(replace(t1.sys_flow_num,chr(13),''),chr(10),'') as sys_flow_num
,replace(replace(t1.serv_flow_num,chr(13),''),chr(10),'') as serv_flow_num
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,chn_tm
,replace(replace(t1.chn_ip_addr,chr(13),''),chr(10),'') as chn_ip_addr
,replace(replace(t1.chn_tran_code,chr(13),''),chr(10),'') as chn_tran_code
,replace(replace(t1.chn_tran_name,chr(13),''),chr(10),'') as chn_tran_name
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_org_name,chr(13),''),chr(10),'') as tran_org_name
,replace(replace(t1.high_low_teller_flg,chr(13),''),chr(10),'') as high_low_teller_flg
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.tran_teller_name,chr(13),''),chr(10),'') as tran_teller_name
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.auth_teller_name,chr(13),''),chr(10),'') as auth_teller_name
,replace(replace(t1.auth_flow_num,chr(13),''),chr(10),'') as auth_flow_num
,replace(replace(t1.auth_mode_cd,chr(13),''),chr(10),'') as auth_mode_cd
,replace(replace(t1.long_flow_tran_flg,chr(13),''),chr(10),'') as long_flow_tran_flg
,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_num_name,chr(13),''),chr(10),'') as acct_num_name
,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,tran_amt
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,replace(replace(t1.cash_trans_flg,chr(13),''),chr(10),'') as cash_trans_flg
,replace(replace(t1.cust_netw_vrfction_rest_cd,chr(13),''),chr(10),'') as cust_netw_vrfction_rest_cd
,replace(replace(t1.face_recn_rest_cd,chr(13),''),chr(10),'') as face_recn_rest_cd
,face_recn_score
,replace(replace(t1.cntpty_cate_cd,chr(13),''),chr(10),'') as cntpty_cate_cd
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_cust_acct_num,chr(13),''),chr(10),'') as cntpty_cust_acct_num
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.agent_flg,chr(13),''),chr(10),'') as agent_flg
,replace(replace(t1.agent_name,chr(13),''),chr(10),'') as agent_name
,replace(replace(t1.agent_cert_type_cd,chr(13),''),chr(10),'') as agent_cert_type_cd
,replace(replace(t1.agent_cert_no,chr(13),''),chr(10),'') as agent_cert_no
,replace(replace(t1.agent_cont_num,chr(13),''),chr(10),'') as agent_cont_num
,replace(replace(t1.agent_nation_cd,chr(13),''),chr(10),'') as agent_nation_cd
,replace(replace(t1.agent_gender_cd,chr(13),''),chr(10),'') as agent_gender_cd
,replace(replace(t1.agent_career_cd,chr(13),''),chr(10),'') as agent_career_cd
,replace(replace(t1.agent_licen_issue_autho_addr,chr(13),''),chr(10),'') as agent_licen_issue_autho_addr
,replace(replace(t1.agent_cont_addr,chr(13),''),chr(10),'') as agent_cont_addr
,agent_cert_start_dt
,agent_cert_exp_dt
,replace(replace(t1.agent_netw_vrfction_rest_cd,chr(13),''),chr(10),'') as agent_netw_vrfction_rest_cd
,replace(replace(t1.agent_face_recn_rest_cd,chr(13),''),chr(10),'') as agent_face_recn_rest_cd
,agent_face_recn_score
,replace(replace(t1.agent_rs_descb,chr(13),''),chr(10),'') as agent_rs_descb
,vouch_matrl_qtty
,replace(replace(t1.blend_way_cd,chr(13),''),chr(10),'') as blend_way_cd
,replace(replace(t1.blend_status_cd,chr(13),''),chr(10),'') as blend_status_cd
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,tran_dt
,tran_tm
,replace(replace(t1.descb,chr(13),''),chr(10),'') as descb
,replace(replace(t1.bus_apv_flow_num,chr(13),''),chr(10),'') as bus_apv_flow_num
,replace(replace(t1.rela_bus_flow_num,chr(13),''),chr(10),'') as rela_bus_flow_num
,replace(replace(t1.high_risk_flg,chr(13),''),chr(10),'') as high_risk_flg
,replace(replace(t1.manual_blend_flg,chr(13),''),chr(10),'') as manual_blend_flg
,replace(replace(t1.spcs_turn_loc_flg,chr(13),''),chr(10),'') as spcs_turn_loc_flg
,replace(replace(t1.brch_init_appl_loc_flg,chr(13),''),chr(10),'') as brch_init_appl_loc_flg
,replace(replace(t1.spcs_appl_flg,chr(13),''),chr(10),'') as spcs_appl_flg
,replace(replace(t1.plat_flow_num,chr(13),''),chr(10),'') as plat_flow_num
,replace(replace(t1.blip_scene_code,chr(13),''),chr(10),'') as blip_scene_code
,replace(replace(t1.blip_id,chr(13),''),chr(10),'') as blip_id
,replace(replace(t1.app_num,chr(13),''),chr(10),'') as app_num
,replace(replace(t1.once_fin_serv_flg,chr(13),''),chr(10),'') as once_fin_serv_flg
,replace(replace(t1.teller_belong_org_id,chr(13),''),chr(10),'') as teller_belong_org_id
,replace(replace(t1.sorc_sys_id,chr(13),''),chr(10),'') as sorc_sys_id
,tran_effect_dt
,tran_invalid_dt

from ${iml_schema}.evt_intellge_brac_bus_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_intellge_brac_bus_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
