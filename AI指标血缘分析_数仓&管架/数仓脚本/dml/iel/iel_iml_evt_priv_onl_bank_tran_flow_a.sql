: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_priv_onl_bank_tran_flow_a
CreateDate: 20221020
FileName:   ${iel_data_path}/evt_priv_onl_bank_tran_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
    etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.main_flow_num,chr(13),''),chr(10),'') as main_flow_num
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,replace(replace(t.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
    ,replace(replace(t.whole_unify_cust_id,chr(13),''),chr(10),'') as whole_unify_cust_id
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.user_seq_num,chr(13),''),chr(10),'') as user_seq_num
    ,replace(replace(t.tran_code,chr(13),''),chr(10),'') as tran_code
    ,replace(replace(t.bus_gen_cd,chr(13),''),chr(10),'') as bus_gen_cd
    ,replace(replace(t.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
    ,t.tran_dt as tran_dt
    ,replace(replace(t.tran_tm,chr(13),''),chr(10),'') as tran_tm
    ,replace(replace(t.tran_acct_num,chr(13),''),chr(10),'') as tran_acct_num
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.tran_amt as tran_amt
    ,t.comm_fee as comm_fee
    ,replace(replace(t.sys_id,chr(13),''),chr(10),'') as sys_id
    ,replace(replace(t.sorc_sys_id,chr(13),''),chr(10),'') as sorc_sys_id
    ,replace(replace(t.four_chn_cd,chr(13),''),chr(10),'') as four_chn_cd
    ,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
    ,replace(replace(t.tran_err_cd,chr(13),''),chr(10),'') as tran_err_cd
    ,replace(replace(t.tran_err_descb,chr(13),''),chr(10),'') as tran_err_descb
    ,replace(replace(t.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
    ,t.core_tran_dt as core_tran_dt
    ,replace(replace(t.visit_flow_num,chr(13),''),chr(10),'') as visit_flow_num
    ,replace(replace(t.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
    ,replace(replace(t.proc_server_ip,chr(13),''),chr(10),'') as proc_server_ip
    ,replace(replace(t.logon_node_id,chr(13),''),chr(10),'') as logon_node_id
    ,replace(replace(t.substep_tran_scrt_key,chr(13),''),chr(10),'') as substep_tran_scrt_key
    ,replace(replace(t.tran_comnt,chr(13),''),chr(10),'') as tran_comnt
    ,replace(replace(t.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
    ,replace(replace(t.func_menu_id,chr(13),''),chr(10),'') as func_menu_id
    ,replace(replace(t.client_ip,chr(13),''),chr(10),'') as client_ip
    ,replace(replace(t.client_mac,chr(13),''),chr(10),'') as client_mac
    ,replace(replace(t.equip_id,chr(13),''),chr(10),'') as equip_id
    ,replace(replace(t.equip_brand_name,chr(13),''),chr(10),'') as equip_brand_name
    ,replace(replace(t.equip_model,chr(13),''),chr(10),'') as equip_model
    ,replace(replace(t.brow_type_cd,chr(13),''),chr(10),'') as brow_type_cd
    ,replace(replace(t.brow_edit_num,chr(13),''),chr(10),'') as brow_edit_num
    ,replace(replace(t.loitde,chr(13),''),chr(10),'') as loitde
    ,replace(replace(t.dimen,chr(13),''),chr(10),'') as dimen
    ,replace(replace(t.teller_id,chr(13),''),chr(10),'') as teller_id
    ,replace(replace(t.teller_belong_org_id,chr(13),''),chr(10),'') as teller_belong_org_id
    ,t.tran_req_tm as tran_req_tm
    ,t.tran_resp_tm as tran_resp_tm
    ,replace(replace(t.tran_order_no,chr(13),''),chr(10),'') as tran_order_no
    ,replace(replace(t.chain_way_track_no,chr(13),''),chr(10),'') as chain_way_track_no
    ,replace(replace(t.sys_flow_num,chr(13),''),chr(10),'') as sys_flow_num
    ,replace(replace(t.chn_id,chr(13),''),chr(10),'') as chn_id
from ${iml_schema}.evt_priv_onl_bank_tran_flow t
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_priv_onl_bank_tran_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
