: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_super_olbk_tran_evt_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_super_olbk_tran_evt_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.evt_dt as evt_dt
,replace(replace(t.front_flow_num,chr(13),''),chr(10),'') as front_flow_num
,replace(replace(t.host_tran_code,chr(13),''),chr(10),'') as host_tran_code
,replace(replace(t.front_tran_code,chr(13),''),chr(10),'') as front_tran_code
,replace(replace(t.pbc_tran_code,chr(13),''),chr(10),'') as pbc_tran_code
,replace(replace(t.bank_int_bus_seq_num,chr(13),''),chr(10),'') as bank_int_bus_seq_num
,replace(replace(t.bus_seq_num,chr(13),''),chr(10),'') as bus_seq_num
,t.num_site as num_site
,t.comm_fee as comm_fee
,t.postage as postage
,t.trdpty_org_comm_fee_amt as trdpty_org_comm_fee_amt
,t.stl_amt as stl_amt
,t.tran_amt as tran_amt
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.host_rest_cd,chr(13),''),chr(10),'') as host_rest_cd
,replace(replace(t.pbc_bus_status_cd,chr(13),''),chr(10),'') as pbc_bus_status_cd
,replace(replace(t.refuse_rs_cd,chr(13),''),chr(10),'') as refuse_rs_cd
,replace(replace(t.pbc_bus_type_cd,chr(13),''),chr(10),'') as pbc_bus_type_cd
,replace(replace(t.pbc_bus_kind_cd,chr(13),''),chr(10),'') as pbc_bus_kind_cd
,replace(replace(t.host_check_entry_status_cd,chr(13),''),chr(10),'') as host_check_entry_status_cd
,replace(replace(t.pbc_check_entry_status_cd,chr(13),''),chr(10),'') as pbc_check_entry_status_cd
,replace(replace(t.host_flow_num,chr(13),''),chr(10),'') as host_flow_num
,replace(replace(t.sumos_id,chr(13),''),chr(10),'') as sumos_id
,replace(replace(t.tran_brac_id,chr(13),''),chr(10),'') as tran_brac_id
,replace(replace(t.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t.brac_print_flg,chr(13),''),chr(10),'') as brac_print_flg
,replace(replace(t.temp_print_flg,chr(13),''),chr(10),'') as temp_print_flg
,t.print_cnt as print_cnt
,replace(replace(t.subj_id,chr(13),''),chr(10),'') as subj_id
,t.fac_val_recd_dt as fac_val_recd_dt
,t.present_wdraw_dt as present_wdraw_dt
,t.entry_dt as entry_dt
,t.send_bank_dt as send_bank_dt
,t.pbc_proc_dt as pbc_proc_dt
,t.bank_int_sys_proc_tm as bank_int_sys_proc_tm
,t.bus_init_tm as bus_init_tm
,replace(replace(t.submit_prior_level,chr(13),''),chr(10),'') as submit_prior_level
,replace(replace(t.present_wdraw_flg,chr(13),''),chr(10),'') as present_wdraw_flg
,replace(replace(t.realtm_onl_flg,chr(13),''),chr(10),'') as realtm_onl_flg
,replace(replace(t.charge_flg,chr(13),''),chr(10),'') as charge_flg
,replace(replace(t.debit_crdt_cd,chr(13),''),chr(10),'') as debit_crdt_cd
,replace(replace(t.recv_bank_no,chr(13),''),chr(10),'') as recv_bank_no
,replace(replace(t.recv_bank_name,chr(13),''),chr(10),'') as recv_bank_name
,replace(replace(t.recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num
,replace(replace(t.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t.recver_acct_type,chr(13),''),chr(10),'') as recver_acct_type
,replace(replace(t.pay_bank_no,chr(13),''),chr(10),'') as pay_bank_no
,replace(replace(t.pay_bank_name,chr(13),''),chr(10),'') as pay_bank_name
,replace(replace(t.payer_acct_num,chr(13),''),chr(10),'') as payer_acct_num
,replace(replace(t.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t.payer_acct_type_cd,chr(13),''),chr(10),'') as payer_acct_type_cd
,replace(replace(t.send_msg_bank_no,chr(13),''),chr(10),'') as send_msg_bank_no
,replace(replace(t.recv_msg_bank_no,chr(13),''),chr(10),'') as recv_msg_bank_no
,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t.tran_status_rest_cd,chr(13),''),chr(10),'') as tran_status_rest_cd
,replace(replace(t.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t.refuse_bus_org_bank_no,chr(13),''),chr(10),'') as refuse_bus_org_bank_no
,replace(replace(t.pay_clear_bk_no,chr(13),''),chr(10),'') as pay_clear_bk_no
,replace(replace(t.recvbl_clear_bk_no,chr(13),''),chr(10),'') as recvbl_clear_bk_no
,replace(replace(t.payer_open_bank_no,chr(13),''),chr(10),'') as payer_open_bank_no
,replace(replace(t.recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no
,replace(replace(t.payer_bank_belong_city_cd,chr(13),''),chr(10),'') as payer_bank_belong_city_cd
,replace(replace(t.recver_bank_belong_city_cd,chr(13),''),chr(10),'') as recver_bank_belong_city_cd
,replace(replace(t.web_tran_odd_no,chr(13),''),chr(10),'') as web_tran_odd_no
,replace(replace(t.cert_way_cd,chr(13),''),chr(10),'') as cert_way_cd
,replace(replace(t.cert_info,chr(13),''),chr(10),'') as cert_info
,replace(replace(t.pre_auth_id,chr(13),''),chr(10),'') as pre_auth_id
,replace(replace(t.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t.mercht_name,chr(13),''),chr(10),'') as mercht_name
,replace(replace(t.coll_comm_fee_org_id,chr(13),''),chr(10),'') as coll_comm_fee_org_id
,t.web_tran_tm as web_tran_tm
,replace(replace(t.open_acct_brac_id,chr(13),''),chr(10),'') as open_acct_brac_id
,t.check_entry_dt as check_entry_dt
,replace(replace(t.check_entry_proc_flg,chr(13),''),chr(10),'') as check_entry_proc_flg
,replace(replace(t.tran_index_num,chr(13),''),chr(10),'') as tran_index_num
,replace(replace(t.e_acct_cd,chr(13),''),chr(10),'') as e_acct_cd
,replace(replace(t.e_acct_entry_req_flow_num,chr(13),''),chr(10),'') as e_acct_entry_req_flow_num
,replace(replace(t.next_day_arrive_flg,chr(13),''),chr(10),'') as next_day_arrive_flg
,replace(replace(t.supv_acct,chr(13),''),chr(10),'') as supv_acct
,replace(replace(t.supv_acct_num,chr(13),''),chr(10),'') as supv_acct_num
,replace(replace(t.supv_acct_num_acct_name,chr(13),''),chr(10),'') as supv_acct_num_acct_name
,replace(replace(t.supv_acct_num_open_org_id,chr(13),''),chr(10),'') as supv_acct_num_open_org_id
,replace(replace(t.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t.sign_type_cd,chr(13),''),chr(10),'') as sign_type_cd
,replace(replace(t.refund_flg,chr(13),''),chr(10),'') as refund_flg
,replace(replace(t.init_msg_idf_id,chr(13),''),chr(10),'') as init_msg_idf_id
,replace(replace(t.init_prtcpt_org_bank_no,chr(13),''),chr(10),'') as init_prtcpt_org_bank_no
,replace(replace(t.acct_ety_code,chr(13),''),chr(10),'') as acct_ety_code
,replace(replace(t.acct_cate_cd,chr(13),''),chr(10),'') as acct_cate_cd
,replace(replace(t.resv_bd_flg,chr(13),''),chr(10),'') as resv_bd_flg
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.st_msg_check_ser_num,chr(13),''),chr(10),'') as st_msg_check_ser_num
,replace(replace(t.mobile_no,chr(13),''),chr(10),'') as mobile_no
,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t.super_olbk_entry_rela_seq_num,chr(13),''),chr(10),'') as super_olbk_entry_rela_seq_num
,replace(replace(t.lmt_order_no,chr(13),''),chr(10),'') as lmt_order_no
,replace(replace(t.bind_flg,chr(13),''),chr(10),'') as bind_flg
,replace(replace(t.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t.esb_intfc_return_code,chr(13),''),chr(10),'') as esb_intfc_return_code
,replace(replace(t.esb_intfc_return_info,chr(13),''),chr(10),'') as esb_intfc_return_info
,replace(replace(t.esb_intfc_tran_flow_num,chr(13),''),chr(10),'') as esb_intfc_tran_flow_num
from ${iml_schema}.evt_super_olbk_tran_evt t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_super_olbk_tran_evt_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes