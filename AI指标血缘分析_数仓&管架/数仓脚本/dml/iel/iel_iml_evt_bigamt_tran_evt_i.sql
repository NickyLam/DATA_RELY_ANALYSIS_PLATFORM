: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_bigamt_tran_evt_i
CreateDate: 20230423
FileName:   ${iel_data_path}/evt_bigamt_tran_evt.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(evt_id,chr(13),''),chr(10),'') as evt_id
,lp_id
,replace(replace(pay_decl_form_id,chr(13),''),chr(10),'') as pay_decl_form_id
,tran_dt
,replace(replace(curr_cd,chr(13),''),chr(10),'') as curr_cd
,tran_amt
,replace(replace(out_line_pay_tran_seq_num,chr(13),''),chr(10),'') as out_line_pay_tran_seq_num
,replace(replace(bank_int_bus_seq_num,chr(13),''),chr(10),'') as bank_int_bus_seq_num
,replace(replace(msg_type_id,chr(13),''),chr(10),'') as msg_type_id
,replace(replace(host_tran_code,chr(13),''),chr(10),'') as host_tran_code
,replace(replace(midgrod_tran_code,chr(13),''),chr(10),'') as midgrod_tran_code
,entr_dt
,host_dt
,replace(replace(host_flow_num,chr(13),''),chr(10),'') as host_flow_num
,replace(replace(spec_prmssn_prtcptr_id,chr(13),''),chr(10),'') as spec_prmssn_prtcptr_id
,replace(replace(send_msg_center_cd,chr(13),''),chr(10),'') as send_msg_center_cd
,replace(replace(init_clear_bk_no,chr(13),''),chr(10),'') as init_clear_bk_no
,replace(replace(origi_bank_no,chr(13),''),chr(10),'') as origi_bank_no
,replace(replace(payer_open_bank_dept_id,chr(13),''),chr(10),'') as payer_open_bank_dept_id
,replace(replace(payer_open_bank_no,chr(13),''),chr(10),'') as payer_open_bank_no
,replace(replace(payer_open_bank_name,chr(13),''),chr(10),'') as payer_open_bank_name
,replace(replace(payer_acct_num,chr(13),''),chr(10),'') as payer_acct_num
,replace(replace(payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(payer_addr,chr(13),''),chr(10),'') as payer_addr
,replace(replace(recv_msg_center_cd,chr(13),''),chr(10),'') as recv_msg_center_cd
,replace(replace(recv_clear_bk_no,chr(13),''),chr(10),'') as recv_clear_bk_no
,replace(replace(recv_bank_bank_no,chr(13),''),chr(10),'') as recv_bank_bank_no
,replace(replace(recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no
,replace(replace(recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
,replace(replace(recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num
,replace(replace(recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(recver_addr,chr(13),''),chr(10),'') as recver_addr
,bus_kind_cd
,bus_type_cd
,init_entr_dt
,replace(replace(init_pay_tran_seq_num,chr(13),''),chr(10),'') as init_pay_tran_seq_num
,replace(replace(init_prtcpt_org_id,chr(13),''),chr(10),'') as init_prtcpt_org_id
,replace(replace(init_msg_type_id,chr(13),''),chr(10),'') as init_msg_type_id
,proc_status_cd
,replace(replace(pbc_bus_status_cd,chr(13),''),chr(10),'') as pbc_bus_status_cd
,replace(replace(npc_proc_cd,chr(13),''),chr(10),'') as npc_proc_cd
,sys_type_cd
,replace(replace(node_type_cd,chr(13),''),chr(10),'') as node_type_cd
,npc_rest_cd
,replace(replace(check_revs_flow_num,chr(13),''),chr(10),'') as check_revs_flow_num
,replace(replace(send_revs_flow_num,chr(13),''),chr(10),'') as send_revs_flow_num
,clear_dt
,replace(replace(err_return_code,chr(13),''),chr(10),'') as err_return_code
,replace(replace(err_info,chr(13),''),chr(10),'') as err_info
,replace(replace(prior_level,chr(13),''),chr(10),'') as prior_level
,replace(replace(input_teller_id,chr(13),''),chr(10),'') as input_teller_id
,replace(replace(check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(input_check_teller_dept_id,chr(13),''),chr(10),'') as input_check_teller_dept_id
,replace(replace(auth_teller_dept_id,chr(13),''),chr(10),'') as auth_teller_dept_id
,check_entry_status_cd
,print_cnt
,revid_tm
,send_tm
,sugst_pay_dt
,replace(replace(nostro_flg,chr(13),''),chr(10),'') as nostro_flg
,replace(replace(charge_flg,chr(13),''),chr(10),'') as charge_flg
,replace(replace(debit_crdt_cd,chr(13),''),chr(10),'') as debit_crdt_cd
,replace(replace(reg_main_acct_num,chr(13),''),chr(10),'') as reg_main_acct_num
,replace(replace(reg_main_name,chr(13),''),chr(10),'') as reg_main_name
,matn_enter_acct_dt
,replace(replace(matn_enter_acct_teller_id,chr(13),''),chr(10),'') as matn_enter_acct_teller_id
,replace(replace(matn_enter_acct_dept_id,chr(13),''),chr(10),'') as matn_enter_acct_dept_id
,replace(replace(clarify_enter_acct_num,chr(13),''),chr(10),'') as clarify_enter_acct_num
,replace(replace(clarify_flow_num,chr(13),''),chr(10),'') as clarify_flow_num
,replace(replace(agent_flg,chr(13),''),chr(10),'') as agent_flg
,replace(replace(jnl_flow_num,chr(13),''),chr(10),'') as jnl_flow_num
,replace(replace(send_jnl_flow_num,chr(13),''),chr(10),'') as send_jnl_flow_num
,replace(replace(vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
,vouch_dt
,replace(replace(vouch_no,chr(13),''),chr(10),'') as vouch_no
,replace(replace(cert_kind_cd,chr(13),''),chr(10),'') as cert_kind_cd
,replace(replace(cert_no,chr(13),''),chr(10),'') as cert_no
,tran_lmt
,replace(replace(tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(send_tran_flow_num,chr(13),''),chr(10),'') as send_tran_flow_num
,modif_tm
,replace(replace(cc_bank_draft_id,chr(13),''),chr(10),'') as cc_bank_draft_id
,replace(replace(rec_update_edit_num,chr(13),''),chr(10),'') as rec_update_edit_num
,replace(replace(rec_status_cd,chr(13),''),chr(10),'') as rec_status_cd
,replace(replace(mode_pay_cd,chr(13),''),chr(10),'') as mode_pay_cd
,replace(replace(exch_bus_tran_chn_cd,chr(13),''),chr(10),'') as exch_bus_tran_chn_cd
,modif_dt
,replace(replace(bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,comm_fee_amt
,remit_tran_fee_amt
,todos
,replace(replace(mpr_teller_id,chr(13),''),chr(10),'') as mpr_teller_id
,replace(replace(revs_tran_flow_num,chr(13),''),chr(10),'') as revs_tran_flow_num
,revs_tran_dt
,replace(replace(prod_cd,chr(13),''),chr(10),'') as prod_cd
,replace(replace(intnal_acct_flg,chr(13),''),chr(10),'') as intnal_acct_flg
,replace(replace(actl_deduct_acct_num,chr(13),''),chr(10),'') as actl_deduct_acct_num
,replace(replace(actl_deduct_acct_name,chr(13),''),chr(10),'') as actl_deduct_acct_name
,replace(replace(bank_int_sys_edit_num,chr(13),''),chr(10),'') as bank_int_sys_edit_num
,replace(replace(cntpty_sys_edit_num,chr(13),''),chr(10),'') as cntpty_sys_edit_num
,replace(replace(ground_proc_status_cd,chr(13),''),chr(10),'') as ground_proc_status_cd
,replace(replace(verify_proc_status_cd,chr(13),''),chr(10),'') as verify_proc_status_cd
,replace(replace(rgst_addit_data_name,chr(13),''),chr(10),'') as rgst_addit_data_name
,replace(replace(on_acct_rs_cd,chr(13),''),chr(10),'') as on_acct_rs_cd
,replace(replace(scd_gener_msg_type_id,chr(13),''),chr(10),'') as scd_gener_msg_type_id
,replace(replace(scd_gener_bus_type_cd,chr(13),''),chr(10),'') as scd_gener_bus_type_cd
,replace(replace(scd_gener_bus_kind_cd,chr(13),''),chr(10),'') as scd_gener_bus_kind_cd
,replace(replace(charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd
,replace(replace(e_acct_cd,chr(13),''),chr(10),'') as e_acct_cd
,replace(replace(chn_flow_num,chr(13),''),chr(10),'') as chn_flow_num
,replace(replace(next_day_tran_flg,chr(13),''),chr(10),'') as next_day_tran_flg
,replace(replace(auto_refund_flg,chr(13),''),chr(10),'') as auto_refund_flg
,auto_refund_cnt
,replace(replace(vtual_acct_bind_acct,chr(13),''),chr(10),'') as vtual_acct_bind_acct
,replace(replace(vtual_acct_bind_acct_name,chr(13),''),chr(10),'') as vtual_acct_bind_acct_name
,replace(replace(acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(vtual_open_acct_org_id,chr(13),''),chr(10),'') as vtual_open_acct_org_id
,replace(replace(acct_gen_cd,chr(13),''),chr(10),'') as acct_gen_cd
,replace(replace(lmt_order_no,chr(13),''),chr(10),'') as lmt_order_no
,replace(replace(ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(esb_intfc_return_code,chr(13),''),chr(10),'') as esb_intfc_return_code
,replace(replace(esb_intfc_return_info,chr(13),''),chr(10),'') as esb_intfc_return_info
,replace(replace(esb_intfc_tran_flow_num,chr(13),''),chr(10),'') as esb_intfc_tran_flow_num
,send_pbc_tm
,src_table_name
from ${iml_schema}.evt_bigamt_tran_evt t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt > to_date('${batch_date}','yyyymmdd')-15;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bigamt_tran_evt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
