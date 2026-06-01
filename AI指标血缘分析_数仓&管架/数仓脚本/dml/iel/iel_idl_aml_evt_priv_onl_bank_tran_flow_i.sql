: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_evt_priv_onl_bank_tran_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_evt_priv_onl_bank_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,evt_id
,lp_id
,main_flow_num
,tran_flow_num
,ova_flow_num
,whole_unify_cust_id
,cust_name
,user_seq_num
,tran_code
,bus_gen_cd
,bus_type_cd
,tran_dt
,tran_tm
,tran_acct_num
,curr_cd
,tran_amt
,comm_fee
,sys_id
,sorc_sys_id
,four_chn_cd
,tran_status_cd
,tran_err_cd
,tran_err_descb
,core_tran_flow_num
,core_tran_dt
,visit_flow_num
,rela_flow_num
,proc_server_ip
,logon_node_id
,substep_tran_scrt_key
,tran_comnt
,tran_type_cd
,func_menu_id
,client_ip
,client_mac
,equip_id
,equip_brand_name
,equip_model
,brow_type_cd
,brow_edit_num
,loitde
,dimen
,teller_id
,teller_belong_org_id
,tran_req_tm
,tran_resp_tm from idl.aml_evt_priv_onl_bank_tran_flow where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_evt_priv_onl_bank_tran_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes