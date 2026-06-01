: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_evt_super_olbk_tran_evt_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_evt_super_olbk_tran_evt.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,evt_id
,lp_id
,evt_dt
,front_flow_num
,host_tran_code
,front_tran_code
,pbc_tran_code
,bank_int_bus_seq_num
,bus_seq_num
,num_site
,comm_fee
,postage
,trdpty_org_comm_fee_amt
,stl_amt
,tran_amt
,curr_cd
,host_rest_cd
,pbc_bus_status_cd
,refuse_rs_cd
,pbc_bus_type_cd
,pbc_bus_kind_cd
,host_check_entry_status_cd
,pbc_check_entry_status_cd
,host_flow_num
,sumos_id
,tran_brac_id
,operr_id
,brac_print_flg
,temp_print_flg
,print_cnt
,subj_id
,fac_val_recd_dt
,present_wdraw_dt
,entry_dt
,send_bank_dt
,pbc_proc_dt
,bank_int_sys_proc_tm
,bus_init_tm
,submit_prior_level
,present_wdraw_flg
,realtm_onl_flg
,charge_flg
,debit_crdt_cd
,recv_bank_no
,recv_bank_name
,recver_acct_num
,recver_name
,recver_acct_type
,pay_bank_no
,pay_bank_name
,payer_acct_num
,payer_name
,payer_acct_type_cd
,send_msg_bank_no
,recv_msg_bank_no
,tran_status_cd
,tran_status_rest_cd
,chn_cd
,refuse_bus_org_bank_no
,pay_clear_bk_no
,recvbl_clear_bk_no
,payer_open_bank_no
,recver_open_bank_no
,payer_bank_belong_city_cd
,recver_bank_belong_city_cd
,web_tran_odd_no
,cert_way_cd
,cert_info
,pre_auth_id
,mercht_id
,mercht_name
,coll_comm_fee_org_id
,web_tran_tm
,open_acct_brac_id
,check_entry_dt
,check_entry_proc_flg
,tran_index_num
,e_acct_cd
,e_acct_entry_req_flow_num
,next_day_arrive_flg
,supv_acct
,supv_acct_num
,supv_acct_num_acct_name
,supv_acct_num_open_org_id
,acct_type_cd
,sign_type_cd
,refund_flg
,init_msg_idf_id
,init_prtcpt_org_bank_no
,acct_ety_code
,acct_cate_cd
,resv_bd_flg
,cust_id
,st_msg_check_ser_num
,mobile_no
,cert_no
,super_olbk_entry_rela_seq_num
,lmt_order_no
,bind_flg
,ova_flow_num
,esb_intfc_return_code
,esb_intfc_return_info
,esb_intfc_tran_flow_num from idl.aml_evt_super_olbk_tran_evt where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_evt_super_olbk_tran_evt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes