: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_pbc_pass_tran_flow_a
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_pbc_pass_tran_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,evt_id
,lp_id
,pay_decl_form_id
,tran_dt
,out_line_pay_tran_seq_num
,bank_int_bus_seq_num
,bus_origi_bank_no
,msg_type_id
,host_flow_num
,tran_flow_num
,send_tran_flow_num
,ova_flow_num
,host_tran_code
,midgrod_tran_code
,curr_cd
,prod_cd
,bus_kind_cd
,bus_type_cd
,proc_status_cd
,npc_proc_cd
,check_entry_status_cd
,debit_crdt_cd
,entry_code
,acct_gen_cd
,acct_type_cd
,e_acct_cd
,rec_status_cd
,mode_pay_cd
,exch_bus_tran_chn_cd
,ground_proc_status_cd
,verify_proc_status_cd
,nostro_flg
,charge_flg
,agent_flg
,intnal_acct_flg
,entr_dt
,host_dt
,clear_dt
,check_entry_dt
,modif_dt
,modif_tm
,init_entr_dt
,init_pay_tran_seq_num
,tran_amt
,comm_fee_amt
,remit_tran_fee_amt
,todos
,payer_open_bank_no
,payer_open_bank_name
,payer_acct_num
,payer_name
,payer_addr
,recver_open_bank_no
,recver_open_bank_name
,recver_acct_num
,recver_name
,recver_addr
,err_return_code
,err_info
,prior_level
,input_teller_id
,check_teller_id
,auth_teller_id
,input_check_teller_dept_id
,auth_teller_dept_id
,reg_main_acct_num
,reg_main_name
,matn_enter_acct_dt
,matn_enter_acct_teller_id
,matn_enter_acct_dept_id
,vouch_type_cd
,vouch_dt
,vouch_no
,cert_kind_cd
,cert_no
,actl_deduct_acct_num
,actl_deduct_acct_name
,rgst_addit_data_tab_name
,on_acct_rs_cd
,auto_refund_flg
,auto_refund_cnt
,vtual_bind_acct
,vtual_bind_acct_name
,vtual_open_acct_org_id from idl.aml_cmm_pbc_pass_tran_flow where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_pbc_pass_tran_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes