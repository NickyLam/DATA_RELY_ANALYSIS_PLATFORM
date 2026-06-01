: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_evt_bigamt_tran_evt_i
CreateDate: 20230117
FileName:   ${iel_data_path}/oass_evt_bigamt_tran_evt.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.evt_id as evt_id
,t1.lp_id as lp_id
,t1.pay_decl_form_id as pay_decl_form_id
,t1.tran_dt as tran_dt
,t1.curr_cd as curr_cd
,t1.tran_amt as tran_amt
,t1.out_line_pay_tran_seq_num as out_line_pay_tran_seq_num
,t1.bank_int_bus_seq_num as bank_int_bus_seq_num
,t1.msg_type_id as msg_type_id
,t1.host_tran_code as host_tran_code
,t1.midgrod_tran_code as midgrod_tran_code
,t1.entr_dt as entr_dt
,t1.host_dt as host_dt
,t1.host_flow_num as host_flow_num
,t1.spec_prmssn_prtcptr_id as spec_prmssn_prtcptr_id
,t1.send_msg_center_cd as send_msg_center_cd
,t1.init_clear_bk_no as init_clear_bk_no
,t1.origi_bank_no as origi_bank_no
,t1.payer_open_bank_dept_id as payer_open_bank_dept_id
,t1.payer_open_bank_no as payer_open_bank_no
,t1.payer_open_bank_name as payer_open_bank_name
,t1.payer_acct_num as payer_acct_num
,t1.payer_name as payer_name
,t1.payer_addr as payer_addr
,t1.recv_msg_center_cd as recv_msg_center_cd
,t1.recv_clear_bk_no as recv_clear_bk_no
,t1.recv_bank_bank_no as recv_bank_bank_no
,t1.recver_open_bank_no as recver_open_bank_no
,t1.recver_open_bank_name as recver_open_bank_name
,t1.recver_acct_num as recver_acct_num
,t1.recver_name as recver_name
,t1.recver_addr as recver_addr
,t1.bus_kind_cd as bus_kind_cd
,t1.bus_type_cd as bus_type_cd
,t1.init_entr_dt as init_entr_dt
,t1.init_pay_tran_seq_num as init_pay_tran_seq_num
,t1.init_prtcpt_org_id as init_prtcpt_org_id
,t1.init_msg_type_id as init_msg_type_id
,t1.proc_status_cd as proc_status_cd
,t1.pbc_bus_status_cd as pbc_bus_status_cd
,t1.npc_proc_cd as npc_proc_cd
,t1.sys_type_cd as sys_type_cd
,t1.node_type_cd as node_type_cd
,t1.npc_rest_cd as npc_rest_cd
,t1.check_revs_flow_num as check_revs_flow_num
,t1.send_revs_flow_num as send_revs_flow_num
,t1.clear_dt as clear_dt
,t1.err_return_code as err_return_code
,t1.err_info as err_info
,t1.prior_level as prior_level
,t1.input_teller_id as input_teller_id
,t1.check_teller_id as check_teller_id
,t1.auth_teller_id as auth_teller_id
,t1.input_check_teller_dept_id as input_check_teller_dept_id
,t1.auth_teller_dept_id as auth_teller_dept_id
,t1.check_entry_status_cd as check_entry_status_cd
,t1.print_cnt as print_cnt
,t1.revid_tm as revid_tm
,t1.send_tm as send_tm
,t1.sugst_pay_dt as sugst_pay_dt
,t1.nostro_flg as nostro_flg
,t1.charge_flg as charge_flg
,t1.debit_crdt_cd as debit_crdt_cd
,t1.reg_main_acct_num as reg_main_acct_num
,t1.reg_main_name as reg_main_name
,t1.matn_enter_acct_dt as matn_enter_acct_dt
,t1.matn_enter_acct_teller_id as matn_enter_acct_teller_id
,t1.matn_enter_acct_dept_id as matn_enter_acct_dept_id
,t1.clarify_enter_acct_num as clarify_enter_acct_num
,t1.clarify_flow_num as clarify_flow_num
,t1.agent_flg as agent_flg
,t1.jnl_flow_num as jnl_flow_num
,t1.send_jnl_flow_num as send_jnl_flow_num
,t1.vouch_type_cd as vouch_type_cd
,t1.vouch_dt as vouch_dt
,t1.vouch_no as vouch_no
,t1.cert_kind_cd as cert_kind_cd
,t1.cert_no as cert_no
,t1.tran_lmt as tran_lmt
,t1.tran_flow_num as tran_flow_num
,t1.send_tran_flow_num as send_tran_flow_num
,t1.modif_tm as modif_tm
,t1.cc_bank_draft_id as cc_bank_draft_id
,t1.rec_update_edit_num as rec_update_edit_num
,t1.rec_status_cd as rec_status_cd
,t1.mode_pay_cd as mode_pay_cd
,t1.exch_bus_tran_chn_cd as exch_bus_tran_chn_cd
,t1.modif_dt as modif_dt
,t1.bus_flow_num as bus_flow_num
,t1.mgmt_org_id as mgmt_org_id
,t1.comm_fee_amt as comm_fee_amt
,t1.remit_tran_fee_amt as remit_tran_fee_amt
,t1.todos as todos
,t1.mpr_teller_id as mpr_teller_id
,t1.revs_tran_flow_num as revs_tran_flow_num
,t1.revs_tran_dt as revs_tran_dt
,t1.prod_cd as prod_cd
,t1.intnal_acct_flg as intnal_acct_flg
,t1.actl_deduct_acct_num as actl_deduct_acct_num
,t1.actl_deduct_acct_name as actl_deduct_acct_name
,t1.bank_int_sys_edit_num as bank_int_sys_edit_num
,t1.cntpty_sys_edit_num as cntpty_sys_edit_num
,t1.ground_proc_status_cd as ground_proc_status_cd
,t1.verify_proc_status_cd as verify_proc_status_cd
,t1.rgst_addit_data_name as rgst_addit_data_name
,t1.on_acct_rs_cd as on_acct_rs_cd
,t1.scd_gener_msg_type_id as scd_gener_msg_type_id
,t1.scd_gener_bus_type_cd as scd_gener_bus_type_cd
,t1.scd_gener_bus_kind_cd as scd_gener_bus_kind_cd
,t1.charge_way_cd as charge_way_cd
,t1.e_acct_cd as e_acct_cd
,t1.chn_flow_num as chn_flow_num
,t1.next_day_tran_flg as next_day_tran_flg
,t1.auto_refund_flg as auto_refund_flg
,t1.auto_refund_cnt as auto_refund_cnt
,t1.vtual_acct_bind_acct as vtual_acct_bind_acct
,t1.vtual_acct_bind_acct_name as vtual_acct_bind_acct_name
,t1.acct_type_cd as acct_type_cd
,t1.vtual_open_acct_org_id as vtual_open_acct_org_id
,t1.acct_gen_cd as acct_gen_cd
,t1.lmt_order_no as lmt_order_no
,t1.ova_flow_num as ova_flow_num
,t1.esb_intfc_return_code as esb_intfc_return_code
,t1.esb_intfc_return_info as esb_intfc_return_info
,t1.esb_intfc_tran_flow_num as esb_intfc_tran_flow_num
,t1.send_pbc_tm as send_pbc_tm
,t1.src_table_name as src_table_name

from ${idl_schema}.oass_evt_bigamt_tran_evt t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt > to_date('${batch_date}','yyyymmdd')-15" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_evt_bigamt_tran_evt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
