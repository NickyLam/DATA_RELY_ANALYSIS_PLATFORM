: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_super_olbk_tran_evt_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_super_olbk_tran_evt.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
      ,evt_id
      ,lp_id
      ,evt_dt
      ,replace(replace(front_flow_num,chr(13),''),chr(10),'') as front_flow_num
      ,replace(replace(host_tran_code,chr(13),''),chr(10),'') as host_tran_code
      ,replace(replace(front_tran_code,chr(13),''),chr(10),'') as front_tran_code
      ,replace(replace(pbc_tran_code,chr(13),''),chr(10),'') as pbc_tran_code
      ,replace(replace(bank_int_bus_seq_num,chr(13),''),chr(10),'') as bank_int_bus_seq_num
      ,replace(replace(bus_seq_num,chr(13),''),chr(10),'') as bus_seq_num
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
      ,replace(replace(host_flow_num,chr(13),''),chr(10),'') as host_flow_num
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
      ,replace(replace(submit_prior_level,chr(13),''),chr(10),'') as submit_prior_level
      ,present_wdraw_flg
      ,realtm_onl_flg
      ,charge_flg
      ,debit_crdt_cd
      ,replace(replace(recv_bank_no,chr(13),''),chr(10),'') as recv_bank_no
      ,replace(replace(recv_bank_name,chr(13),''),chr(10),'') as recv_bank_name
      ,replace(replace(recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num
      ,replace(replace(recver_name,chr(13),''),chr(10),'') as recver_name
      ,replace(replace(recver_acct_type,chr(13),''),chr(10),'') as recver_acct_type
      ,replace(replace(pay_bank_no,chr(13),''),chr(10),'') as pay_bank_no
      ,replace(replace(pay_bank_name,chr(13),''),chr(10),'') as pay_bank_name
      ,replace(replace(payer_acct_num,chr(13),''),chr(10),'') as payer_acct_num
      ,replace(replace(payer_name,chr(13),''),chr(10),'') as payer_name
      ,payer_acct_type_cd
      ,replace(replace(send_msg_bank_no,chr(13),''),chr(10),'') as send_msg_bank_no
      ,replace(replace(recv_msg_bank_no,chr(13),''),chr(10),'') as recv_msg_bank_no
      ,tran_status_cd
      ,tran_status_rest_cd
      ,chn_cd
      ,replace(replace(refuse_bus_org_bank_no,chr(13),''),chr(10),'') as refuse_bus_org_bank_no
      ,replace(replace(pay_clear_bk_no,chr(13),''),chr(10),'') as pay_clear_bk_no
      ,replace(replace(recvbl_clear_bk_no,chr(13),''),chr(10),'') as recvbl_clear_bk_no
      ,replace(replace(payer_open_bank_no,chr(13),''),chr(10),'') as payer_open_bank_no
      ,replace(replace(recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no
      ,payer_bank_belong_city_cd
      ,recver_bank_belong_city_cd
      ,replace(replace(web_tran_odd_no,chr(13),''),chr(10),'') as web_tran_odd_no
      ,cert_way_cd
      ,replace(replace(cert_info,chr(13),''),chr(10),'') as cert_info
      ,pre_auth_id
      ,mercht_id
      ,replace(replace(mercht_name,chr(13),''),chr(10),'') as mercht_name
      ,coll_comm_fee_org_id
      ,web_tran_tm
      ,open_acct_brac_id
      ,check_entry_dt
      ,check_entry_proc_flg
      ,replace(replace(tran_index_num,chr(13),''),chr(10),'') as tran_index_num
      ,e_acct_cd
      ,replace(replace(e_acct_entry_req_flow_num,chr(13),''),chr(10),'') as e_acct_entry_req_flow_num
      ,next_day_arrive_flg
      ,replace(replace(supv_acct,chr(13),''),chr(10),'') as supv_acct
      ,replace(replace(supv_acct_num,chr(13),''),chr(10),'') as supv_acct_num
      ,replace(replace(supv_acct_num_acct_name,chr(13),''),chr(10),'') as supv_acct_num_acct_name
      ,supv_acct_num_open_org_id
      ,acct_type_cd
      ,sign_type_cd
      ,refund_flg
      ,init_msg_idf_id
      ,replace(replace(init_prtcpt_org_bank_no,chr(13),''),chr(10),'') as init_prtcpt_org_bank_no
      ,replace(replace(acct_ety_code,chr(13),''),chr(10),'') as acct_ety_code
      ,acct_cate_cd
      ,resv_bd_flg
      ,cust_id
      ,replace(replace(st_msg_check_ser_num,chr(13),''),chr(10),'') as st_msg_check_ser_num
      ,replace(replace(mobile_no,chr(13),''),chr(10),'') as mobile_no
      ,replace(replace(cert_no,chr(13),''),chr(10),'') as cert_no
      ,replace(replace(super_olbk_entry_rela_seq_num,chr(13),''),chr(10),'') as super_olbk_entry_rela_seq_num
      ,replace(replace(lmt_order_no,chr(13),''),chr(10),'') as lmt_order_no
      ,bind_flg
      ,replace(replace(ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
      ,replace(replace(esb_intfc_return_code,chr(13),''),chr(10),'') as esb_intfc_return_code
      ,replace(replace(esb_intfc_return_info,chr(13),''),chr(10),'') as esb_intfc_return_info
      ,replace(replace(esb_intfc_tran_flow_num,chr(13),''),chr(10),'') as esb_intfc_tran_flow_num
from ${iml_schema}.evt_super_olbk_tran_evt t1 
where t1.send_bank_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_super_olbk_tran_evt.a.${batch_date}.dat" \
        charset=utf8
        safe=yes