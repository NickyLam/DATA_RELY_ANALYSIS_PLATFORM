: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_pbc_pass_tran_flow_a1
CreateDate: 20240112
FileName:   ${iel_data_path}/cmm_pbc_pass_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.pay_decl_form_id,chr(13),''),chr(10),'') as pay_decl_form_id
,tran_dt
,replace(replace(t1.out_line_pay_tran_seq_num,chr(13),''),chr(10),'') as out_line_pay_tran_seq_num
,replace(replace(t1.bank_int_bus_seq_num,chr(13),''),chr(10),'') as bank_int_bus_seq_num
,replace(replace(t1.bus_origi_bank_no,chr(13),''),chr(10),'') as bus_origi_bank_no
,replace(replace(t1.msg_type_id,chr(13),''),chr(10),'') as msg_type_id
,replace(replace(t1.scd_gener_msg_type_id,chr(13),''),chr(10),'') as scd_gener_msg_type_id
,replace(replace(t1.host_flow_num,chr(13),''),chr(10),'') as host_flow_num
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.send_tran_flow_num,chr(13),''),chr(10),'') as send_tran_flow_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.host_tran_code,chr(13),''),chr(10),'') as host_tran_code
,replace(replace(t1.midgrod_tran_code,chr(13),''),chr(10),'') as midgrod_tran_code
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.prod_cd,chr(13),''),chr(10),'') as prod_cd
,replace(replace(t1.bus_kind_cd,chr(13),''),chr(10),'') as bus_kind_cd
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd
,replace(replace(t1.npc_proc_cd,chr(13),''),chr(10),'') as npc_proc_cd
,replace(replace(t1.check_entry_status_cd,chr(13),''),chr(10),'') as check_entry_status_cd
,replace(replace(t1.debit_crdt_cd,chr(13),''),chr(10),'') as debit_crdt_cd
,replace(replace(t1.entry_code,chr(13),''),chr(10),'') as entry_code
,replace(replace(t1.acct_gen_cd,chr(13),''),chr(10),'') as acct_gen_cd
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.e_acct_cd,chr(13),''),chr(10),'') as e_acct_cd
,replace(replace(t1.rec_status_cd,chr(13),''),chr(10),'') as rec_status_cd
,replace(replace(t1.mode_pay_cd,chr(13),''),chr(10),'') as mode_pay_cd
,replace(replace(t1.exch_bus_tran_chn_cd,chr(13),''),chr(10),'') as exch_bus_tran_chn_cd
,replace(replace(t1.ground_proc_status_cd,chr(13),''),chr(10),'') as ground_proc_status_cd
,replace(replace(t1.verify_proc_status_cd,chr(13),''),chr(10),'') as verify_proc_status_cd
,replace(replace(t1.nostro_flg,chr(13),''),chr(10),'') as nostro_flg
,replace(replace(t1.charge_flg,chr(13),''),chr(10),'') as charge_flg
,replace(replace(t1.agent_flg,chr(13),''),chr(10),'') as agent_flg
,replace(replace(t1.intnal_acct_flg,chr(13),''),chr(10),'') as intnal_acct_flg
,entr_dt
,host_dt
,clear_dt
,check_entry_dt
,modif_dt
,modif_tm
,init_entr_dt
,replace(replace(t1.init_pay_tran_seq_num,chr(13),''),chr(10),'') as init_pay_tran_seq_num
,tran_amt
,comm_fee_amt
,remit_tran_fee_amt
,todos
,replace(replace(t1.payer_open_bank_no,chr(13),''),chr(10),'') as payer_open_bank_no
,replace(replace(t1.payer_open_bank_name,chr(13),''),chr(10),'') as payer_open_bank_name
,replace(replace(t1.payer_acct_num,chr(13),''),chr(10),'') as payer_acct_num
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t1.payer_addr,chr(13),''),chr(10),'') as payer_addr
,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recver_addr,chr(13),''),chr(10),'') as recver_addr
,replace(replace(t1.err_return_code,chr(13),''),chr(10),'') as err_return_code
,replace(replace(t1.err_info,chr(13),''),chr(10),'') as err_info
,replace(replace(t1.prior_level,chr(13),''),chr(10),'') as prior_level
,replace(replace(t1.input_teller_id,chr(13),''),chr(10),'') as input_teller_id
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.input_check_teller_dept_id,chr(13),''),chr(10),'') as input_check_teller_dept_id
,replace(replace(t1.auth_teller_dept_id,chr(13),''),chr(10),'') as auth_teller_dept_id
,replace(replace(t1.reg_main_acct_num,chr(13),''),chr(10),'') as reg_main_acct_num
,replace(replace(t1.reg_main_name,chr(13),''),chr(10),'') as reg_main_name
,matn_enter_acct_dt
,replace(replace(t1.matn_enter_acct_teller_id,chr(13),''),chr(10),'') as matn_enter_acct_teller_id
,replace(replace(t1.matn_enter_acct_dept_id,chr(13),''),chr(10),'') as matn_enter_acct_dept_id
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
,vouch_dt
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no
,replace(replace(t1.cert_kind_cd,chr(13),''),chr(10),'') as cert_kind_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.actl_deduct_acct_num,chr(13),''),chr(10),'') as actl_deduct_acct_num
,replace(replace(t1.actl_deduct_acct_name,chr(13),''),chr(10),'') as actl_deduct_acct_name
,replace(replace(t1.rgst_addit_data_tab_name,chr(13),''),chr(10),'') as rgst_addit_data_tab_name
,replace(replace(t1.on_acct_rs_cd,chr(13),''),chr(10),'') as on_acct_rs_cd
,replace(replace(t1.auto_refund_flg,chr(13),''),chr(10),'') as auto_refund_flg
,auto_refund_cnt
,replace(replace(t1.vtual_bind_acct,chr(13),''),chr(10),'') as vtual_bind_acct
,replace(replace(t1.vtual_bind_acct_name,chr(13),''),chr(10),'') as vtual_bind_acct_name
,replace(replace(t1.vtual_open_acct_org_id,chr(13),''),chr(10),'') as vtual_open_acct_org_id
,replace(replace(t1.payer_open_bank_dept_id,chr(13),''),chr(10),'') as payer_open_bank_dept_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.jnl_flow_num,chr(13),''),chr(10),'') as jnl_flow_num
,replace(replace(t1.bank_int_out_line_flg,chr(13),''),chr(10),'') as bank_int_out_line_flg
,revid_tm

from ${icl_schema}.cmm_pbc_pass_tran_flow t1
where t1.tran_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_pbc_pass_tran_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
