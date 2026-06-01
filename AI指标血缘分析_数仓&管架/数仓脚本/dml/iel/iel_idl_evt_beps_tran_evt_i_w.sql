: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_evt_beps_tran_evt_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_beps_tran_evt_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t.evt_id as evt_id
,t.lp_id as lp_id
,t.pay_decl_form_id as pay_decl_form_id
,t.out_line_pay_tran_seq_num as out_line_pay_tran_seq_num
,t.bank_int_bus_seq_num as bank_int_bus_seq_num
,t.bus_type_cd as bus_type_cd
,t.bus_kind_cd as bus_kind_cd
,t.pkg_seq_num as pkg_seq_num
,t.pkg_entr_dt as pkg_entr_dt
,t.pkg_type as pkg_type
,t.host_tran_code as host_tran_code
,t.midgrod_tran_code as midgrod_tran_code
,t.tran_dt as tran_dt
,t.entr_dt as entr_dt
,t.host_dt as host_dt
,t.host_flow_num as host_flow_num
,t.curr_cd as curr_cd
,t.tran_amt as tran_amt
,t.payer_open_bank_dept_id as payer_open_bank_dept_id
,t.payer_open_bank_no as payer_open_bank_no
,t.payer_acct_num as payer_acct_num
,t.payer_name as payer_name
,t.payer_addr as payer_addr
,t.recver_open_bank_no as recver_open_bank_no
,t.recver_acct_num as recver_acct_num
,t.recver_name as recver_name
,t.recver_addr as recver_addr
,t.send_msg_center_cd as send_msg_center_cd
,t.init_clear_bk_no as init_clear_bk_no
,t.origi_bank_no as origi_bank_no
,t.recv_msg_center_cd as recv_msg_center_cd
,t.recv_clear_bk_no as recv_clear_bk_no
,t.recv_bank_no as recv_bank_no
,t.init_entr_dt as init_entr_dt
,t.init_pay_tran_seq_num as init_pay_tran_seq_num
,t.init_bus_type_cd as init_bus_type_cd
,t.bill_num as bill_num
,t.offs_bal_node_type_cd as offs_bal_node_type_cd
,t.offs_bal_num_site as offs_bal_num_site
,t.offs_bal_dt_or_fs_dt as offs_bal_dt_or_fs_dt
,t.refund_rs_cd as refund_rs_cd
,t.proc_status_cd as proc_status_cd
,t.status_rest_cd as status_rest_cd
,t.pbc_bus_status_cd as pbc_bus_status_cd
,t.rtn_rcpt_code as rtn_rcpt_code
,t.proc_cd as proc_cd
,t.sys_type_cd as sys_type_cd
,t.node_type_cd as node_type_cd
,t.rest_cd as rest_cd
,t.check_revs_flow_num as check_revs_flow_num
,t.rtn_rcpt_tenor_cd as rtn_rcpt_tenor_cd
,t.rtn_rcpt_dt as rtn_rcpt_dt
,t.send_revs_flow_num as send_revs_flow_num
,t.clear_dt as clear_dt
,t.err_code as err_code
,t.err_info as err_info
,t.prior_level as prior_level
,t.input_teller_id as input_teller_id
,t.check_teller_id as check_teller_id
,t.auth_teller_id as auth_teller_id
,t.input_check_teller_dept_id as input_check_teller_dept_id
,t.auth_teller_dept_id as auth_teller_dept_id
,t.check_entry_status_cd as check_entry_status_cd
,t.print_cnt as print_cnt
,t.revid_tm as revid_tm
,t.send_tm as send_tm
,t.sugst_pay_dt as sugst_pay_dt
,t.nostro_flg as nostro_flg
,t.charge_flg as charge_flg
,t.debit_crdt_cd as debit_crdt_cd
,t.bank_int_out_line_flg as bank_int_out_line_flg
,t.draft_appl_form_num as draft_appl_form_num
,t.matn_enter_acct_num as matn_enter_acct_num
,t.reg_main_name as reg_main_name
,t.matn_enter_acct_dt as matn_enter_acct_dt
,t.matn_enter_acct_teller_id as matn_enter_acct_teller_id
,t.matn_enter_acct_dept_id as matn_enter_acct_dept_id
,t.agent_flg as agent_flg
,t.jnl_flow_num as jnl_flow_num
,t.send_jnl_flow_num as send_jnl_flow_num
,t.vouch_type_cd as vouch_type_cd
,t.entr_vouch_dt as entr_vouch_dt
,t.entr_vouch_num as entr_vouch_num
,t.cert_kind_cd as cert_kind_cd
,t.cert_no as cert_no
,t.tran_lmt as tran_lmt
,t.tran_flow_num as tran_flow_num
,t.send_tran_flow_num as send_tran_flow_num
,t.mode_pay_cd as mode_pay_cd
,t.exch_bus_cors_tran_chn_cd as exch_bus_cors_tran_chn_cd
,t.recnt_modif_dt as recnt_modif_dt
,t.bus_flow_num as bus_flow_num
,t.comm_fee as comm_fee
,t.remit_tran_fee as remit_tran_fee
,t.todos as todos
,t.init_amt as init_amt
,t.pay_amt as pay_amt
,t.multi_pay_amt as multi_pay_amt
,t.mpr_host_flow_num as mpr_host_flow_num
,t.mpr_host_dt as mpr_host_dt
,t.mpr_teller_id as mpr_teller_id
,t.recnt_modif_tm as recnt_modif_tm
,t.proc_org_id as proc_org_id
,t.rec_update_edit_num as rec_update_edit_num
,t.rec_status_cd as rec_status_cd
,t.init_pkg_type as init_pkg_type
,t.init_pkg_init_clear_bk_num as init_pkg_init_clear_bk_num
,t.init_pkg_entr_dt as init_pkg_entr_dt
,t.init_pkg_seq_num as init_pkg_seq_num
,t.prod_cd as prod_cd
,t.intnal_acct_flg as intnal_acct_flg
,t.actl_deduct_acct_num as actl_deduct_acct_num
,t.actl_deduct_acct_name as actl_deduct_acct_name
,t.bank_int_sys_edit_num as bank_int_sys_edit_num
,t.cntpty_sys_edit_num as cntpty_sys_edit_num
,t.ground_proc_status_cd as ground_proc_status_cd
,t.verify_proc_status_cd as verify_proc_status_cd
,t.rgst_addit_data_name as rgst_addit_data_name
,t.rgst_addit_data_dtl_name as rgst_addit_data_dtl_name
,t.on_acct_rs_cd as on_acct_rs_cd
,t.pkg_bank_int_seq_num as pkg_bank_int_seq_num
,t.scd_gener_msg_type_id as scd_gener_msg_type_id
,t.scd_gener_bus_type_cd as scd_gener_bus_type_cd
,t.scd_gener_bus_kind_cd as scd_gener_bus_kind_cd
,t.payer_open_bank_name as payer_open_bank_name
,t.recver_open_bank_name as recver_open_bank_name
,t.charge_way_cd as charge_way_cd
,t.e_acct_cd as e_acct_cd
,t.next_day_tran_flg as next_day_tran_flg
,t.auto_refund_flg as auto_refund_flg
,t.auto_refund_cnt as auto_refund_cnt
,t.vtual_acct_bind_acct as vtual_acct_bind_acct
,t.vtual_acct_bind_acct_name as vtual_acct_bind_acct_name
,t.acct_type_cd as acct_type_cd
,t.vtual_open_acct_org_id as vtual_open_acct_org_id
,t.last_debit_rtn_rcpt_status_cd as last_debit_rtn_rcpt_status_cd
,t.last_tran_status_cd as last_tran_status_cd
,t.acct_gen_cd as acct_gen_cd
,t.lmt_order_no as lmt_order_no
,t.bind_flg as bind_flg
,t.ova_flow_num as ova_flow_num
,t.esb_intfc_return_code as esb_intfc_return_code
,t.esb_intfc_return_info as esb_intfc_return_info
,t.esb_intfc_tran_flow_num as esb_intfc_tran_flow_num
,t.send_pbc_tm as send_pbc_tm
from ${idl_schema}.evt_beps_tran_evt t
where tran_dt <= to_date('${batch_date}','yyyymmdd') and tran_dt >= to_date('${batch_date}','yyyymmdd') -6   ;
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_beps_tran_evt_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes