: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_beps_tran_evt_a1
CreateDate: 20250508
FileName:   ${iel_data_path}/evt_beps_tran_evt.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(evt_id,chr(13),''),chr(10),'') as evt_id
,lp_id
,replace(replace(pay_decl_form_id,chr(13),''),chr(10),'') as pay_decl_form_id
,replace(replace(out_line_pay_tran_seq_num,chr(13),''),chr(10),'') as out_line_pay_tran_seq_num
,replace(replace(bank_int_bus_seq_num,chr(13),''),chr(10),'') as bank_int_bus_seq_num
,bus_type_cd
,bus_kind_cd
,replace(replace(pkg_seq_num,chr(13),''),chr(10),'') as pkg_seq_num
,pkg_entr_dt
,replace(replace(pkg_type,chr(13),''),chr(10),'') as pkg_type
,replace(replace(host_tran_code,chr(13),''),chr(10),'') as host_tran_code
,replace(replace(midgrod_tran_code,chr(13),''),chr(10),'') as midgrod_tran_code
,tran_dt
,entr_dt
,host_dt
,replace(replace(host_flow_num,chr(13),''),chr(10),'') as host_flow_num
,curr_cd
,tran_amt
,replace(replace(payer_open_bank_dept_id,chr(13),''),chr(10),'') as payer_open_bank_dept_id
,replace(replace(payer_open_bank_no,chr(13),''),chr(10),'') as payer_open_bank_no
,replace(replace(payer_acct_num,chr(13),''),chr(10),'') as payer_acct_num
,replace(replace(payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(payer_addr,chr(13),''),chr(10),'') as payer_addr
,replace(replace(recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no
,replace(replace(recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num
,replace(replace(recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(recver_addr,chr(13),''),chr(10),'') as recver_addr
,replace(replace(send_msg_center_cd,chr(13),''),chr(10),'') as send_msg_center_cd
,replace(replace(init_clear_bk_no,chr(13),''),chr(10),'') as init_clear_bk_no
,replace(replace(origi_bank_no,chr(13),''),chr(10),'') as origi_bank_no
,replace(replace(recv_msg_center_cd,chr(13),''),chr(10),'') as recv_msg_center_cd
,replace(replace(recv_clear_bk_no,chr(13),''),chr(10),'') as recv_clear_bk_no
,replace(replace(recv_bank_no,chr(13),''),chr(10),'') as recv_bank_no
,init_entr_dt
,replace(replace(init_pay_tran_seq_num,chr(13),''),chr(10),'') as init_pay_tran_seq_num
,init_bus_type_cd
,replace(replace(bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(offs_bal_node_type_cd,chr(13),''),chr(10),'') as offs_bal_node_type_cd
,offs_bal_num_site
,offs_bal_dt_or_fs_dt
,refund_rs_cd
,replace(replace(proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd
,status_rest_cd
,pbc_bus_status_cd
,replace(replace(rtn_rcpt_code,chr(13),''),chr(10),'') as rtn_rcpt_code
,proc_cd
,sys_type_cd
,node_type_cd
,rest_cd
,replace(replace(check_revs_flow_num,chr(13),''),chr(10),'') as check_revs_flow_num
,replace(replace(rtn_rcpt_tenor_cd,chr(13),''),chr(10),'') as rtn_rcpt_tenor_cd
,rtn_rcpt_dt
,replace(replace(send_revs_flow_num,chr(13),''),chr(10),'') as send_revs_flow_num
,clear_dt
,replace(replace(err_code,chr(13),''),chr(10),'') as err_code
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
,debit_crdt_cd
,replace(replace(bank_int_out_line_flg,chr(13),''),chr(10),'') as bank_int_out_line_flg
,replace(replace(draft_appl_form_num,chr(13),''),chr(10),'') as draft_appl_form_num
,replace(replace(matn_enter_acct_num,chr(13),''),chr(10),'') as matn_enter_acct_num
,replace(replace(reg_main_name,chr(13),''),chr(10),'') as reg_main_name
,matn_enter_acct_dt
,replace(replace(matn_enter_acct_teller_id,chr(13),''),chr(10),'') as matn_enter_acct_teller_id
,replace(replace(matn_enter_acct_dept_id,chr(13),''),chr(10),'') as matn_enter_acct_dept_id
,replace(replace(agent_flg,chr(13),''),chr(10),'') as agent_flg
,replace(replace(jnl_flow_num,chr(13),''),chr(10),'') as jnl_flow_num
,replace(replace(send_jnl_flow_num,chr(13),''),chr(10),'') as send_jnl_flow_num
,vouch_type_cd
,entr_vouch_dt
,replace(replace(entr_vouch_num,chr(13),''),chr(10),'') as entr_vouch_num
,cert_kind_cd
,replace(replace(cert_no,chr(13),''),chr(10),'') as cert_no
,tran_lmt
,replace(replace(tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(send_tran_flow_num,chr(13),''),chr(10),'') as send_tran_flow_num
,mode_pay_cd
,exch_bus_cors_tran_chn_cd
,recnt_modif_dt
,replace(replace(bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,comm_fee
,remit_tran_fee
,todos
,init_amt
,pay_amt
,multi_pay_amt
,replace(replace(mpr_host_flow_num,chr(13),''),chr(10),'') as mpr_host_flow_num
,mpr_host_dt
,replace(replace(mpr_teller_id,chr(13),''),chr(10),'') as mpr_teller_id
,recnt_modif_tm
,replace(replace(proc_org_id,chr(13),''),chr(10),'') as proc_org_id
,replace(replace(rec_update_edit_num,chr(13),''),chr(10),'') as rec_update_edit_num
,rec_status_cd
,replace(replace(init_pkg_type,chr(13),''),chr(10),'') as init_pkg_type
,replace(replace(init_pkg_init_clear_bk_num,chr(13),''),chr(10),'') as init_pkg_init_clear_bk_num
,init_pkg_entr_dt
,replace(replace(init_pkg_seq_num,chr(13),''),chr(10),'') as init_pkg_seq_num
,prod_cd
,replace(replace(intnal_acct_flg,chr(13),''),chr(10),'') as intnal_acct_flg
,replace(replace(actl_deduct_acct_num,chr(13),''),chr(10),'') as actl_deduct_acct_num
,replace(replace(actl_deduct_acct_name,chr(13),''),chr(10),'') as actl_deduct_acct_name
,replace(replace(bank_int_sys_edit_num,chr(13),''),chr(10),'') as bank_int_sys_edit_num
,replace(replace(cntpty_sys_edit_num,chr(13),''),chr(10),'') as cntpty_sys_edit_num
,ground_proc_status_cd
,verify_proc_status_cd
,replace(replace(rgst_addit_data_name,chr(13),''),chr(10),'') as rgst_addit_data_name
,replace(replace(rgst_addit_data_dtl_name,chr(13),''),chr(10),'') as rgst_addit_data_dtl_name
,on_acct_rs_cd
,replace(replace(pkg_bank_int_seq_num,chr(13),''),chr(10),'') as pkg_bank_int_seq_num
,replace(replace(scd_gener_msg_type_id,chr(13),''),chr(10),'') as scd_gener_msg_type_id
,scd_gener_bus_type_cd
,scd_gener_bus_kind_cd
,replace(replace(payer_open_bank_name,chr(13),''),chr(10),'') as payer_open_bank_name
,replace(replace(recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
,replace(replace(charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd
,e_acct_cd
,replace(replace(next_day_tran_flg,chr(13),''),chr(10),'') as next_day_tran_flg
,replace(replace(auto_refund_flg,chr(13),''),chr(10),'') as auto_refund_flg
,auto_refund_cnt
,replace(replace(vtual_acct_bind_acct,chr(13),''),chr(10),'') as vtual_acct_bind_acct
,replace(replace(vtual_acct_bind_acct_name,chr(13),''),chr(10),'') as vtual_acct_bind_acct_name
,acct_type_cd
,replace(replace(vtual_open_acct_org_id,chr(13),''),chr(10),'') as vtual_open_acct_org_id
,replace(replace(last_debit_rtn_rcpt_status_cd,chr(13),''),chr(10),'') as last_debit_rtn_rcpt_status_cd
,last_tran_status_cd
,acct_gen_cd
,replace(replace(lmt_order_no,chr(13),''),chr(10),'') as lmt_order_no
,replace(replace(bind_flg,chr(13),''),chr(10),'') as bind_flg
,replace(replace(ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(esb_intfc_return_code,chr(13),''),chr(10),'') as esb_intfc_return_code
,replace(replace(esb_intfc_return_info,chr(13),''),chr(10),'') as esb_intfc_return_info
,replace(replace(esb_intfc_tran_flow_num,chr(13),''),chr(10),'') as esb_intfc_tran_flow_num
,send_pbc_tm
,src_table_name
from ${iml_schema}.evt_beps_tran_evt
where etl_dt between trunc(SYSDATE,'yy') and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_beps_tran_evt.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
