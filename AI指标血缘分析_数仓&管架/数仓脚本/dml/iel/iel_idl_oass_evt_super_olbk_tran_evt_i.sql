: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_evt_super_olbk_tran_evt_i
CreateDate: 20230117
FileName:   ${iel_data_path}/oass_evt_super_olbk_tran_evt.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.evt_id as evt_id
,t1.lp_id as lp_id
,t1.evt_dt as evt_dt
,t1.front_flow_num as front_flow_num
,t1.host_tran_code as host_tran_code
,t1.front_tran_code as front_tran_code
,t1.pbc_tran_code as pbc_tran_code
,t1.bank_int_bus_seq_num as bank_int_bus_seq_num
,t1.bus_seq_num as bus_seq_num
,t1.num_site as num_site
,t1.comm_fee as comm_fee
,t1.postage as postage
,t1.trdpty_org_comm_fee_amt as trdpty_org_comm_fee_amt
,t1.stl_amt as stl_amt
,t1.tran_amt as tran_amt
,t1.curr_cd as curr_cd
,t1.host_rest_cd as host_rest_cd
,t1.pbc_bus_status_cd as pbc_bus_status_cd
,t1.refuse_rs_cd as refuse_rs_cd
,t1.pbc_bus_type_cd as pbc_bus_type_cd
,t1.pbc_bus_kind_cd as pbc_bus_kind_cd
,t1.host_check_entry_status_cd as host_check_entry_status_cd
,t1.pbc_check_entry_status_cd as pbc_check_entry_status_cd
,t1.host_flow_num as host_flow_num
,t1.sumos_id as sumos_id
,t1.tran_brac_id as tran_brac_id
,t1.operr_id as operr_id
,t1.brac_print_flg as brac_print_flg
,t1.temp_print_flg as temp_print_flg
,t1.print_cnt as print_cnt
,t1.subj_id as subj_id
,t1.fac_val_recd_dt as fac_val_recd_dt
,t1.present_wdraw_dt as present_wdraw_dt
,t1.entry_dt as entry_dt
,t1.send_bank_dt as send_bank_dt
,t1.pbc_proc_dt as pbc_proc_dt
,t1.bank_int_sys_proc_tm as bank_int_sys_proc_tm
,t1.bus_init_tm as bus_init_tm
,t1.submit_prior_level as submit_prior_level
,t1.present_wdraw_flg as present_wdraw_flg
,t1.realtm_onl_flg as realtm_onl_flg
,t1.charge_flg as charge_flg
,t1.debit_crdt_cd as debit_crdt_cd
,t1.recv_bank_no as recv_bank_no
,t1.recv_bank_name as recv_bank_name
,t1.recver_acct_num as recver_acct_num
,t1.recver_name as recver_name
,t1.recver_acct_type as recver_acct_type
,t1.pay_bank_no as pay_bank_no
,t1.pay_bank_name as pay_bank_name
,t1.payer_acct_num as payer_acct_num
,t1.payer_name as payer_name
,t1.payer_acct_type_cd as payer_acct_type_cd
,t1.send_msg_bank_no as send_msg_bank_no
,t1.recv_msg_bank_no as recv_msg_bank_no
,t1.tran_status_cd as tran_status_cd
,t1.tran_status_rest_cd as tran_status_rest_cd
,t1.chn_cd as chn_cd
,t1.refuse_bus_org_bank_no as refuse_bus_org_bank_no
,t1.pay_clear_bk_no as pay_clear_bk_no
,t1.recvbl_clear_bk_no as recvbl_clear_bk_no
,t1.payer_open_bank_no as payer_open_bank_no
,t1.recver_open_bank_no as recver_open_bank_no
,t1.payer_bank_belong_city_cd as payer_bank_belong_city_cd
,t1.recver_bank_belong_city_cd as recver_bank_belong_city_cd
,t1.web_tran_odd_no as web_tran_odd_no
,t1.cert_way_cd as cert_way_cd
,t1.cert_info as cert_info
,t1.pre_auth_id as pre_auth_id
,t1.mercht_id as mercht_id
,t1.mercht_name as mercht_name
,t1.coll_comm_fee_org_id as coll_comm_fee_org_id
,t1.web_tran_tm as web_tran_tm
,t1.open_acct_brac_id as open_acct_brac_id
,t1.check_entry_dt as check_entry_dt
,t1.check_entry_proc_flg as check_entry_proc_flg
,t1.tran_index_num as tran_index_num
,t1.e_acct_cd as e_acct_cd
,t1.e_acct_entry_req_flow_num as e_acct_entry_req_flow_num
,t1.next_day_arrive_flg as next_day_arrive_flg
,t1.supv_acct as supv_acct
,t1.supv_acct_num as supv_acct_num
,t1.supv_acct_num_acct_name as supv_acct_num_acct_name
,t1.supv_acct_num_open_org_id as supv_acct_num_open_org_id
,t1.acct_type_cd as acct_type_cd
,t1.sign_type_cd as sign_type_cd
,t1.refund_flg as refund_flg
,t1.init_msg_idf_id as init_msg_idf_id
,t1.init_prtcpt_org_bank_no as init_prtcpt_org_bank_no
,t1.acct_ety_code as acct_ety_code
,t1.acct_cate_cd as acct_cate_cd
,t1.resv_bd_flg as resv_bd_flg
,t1.cust_id as cust_id
,t1.st_msg_check_ser_num as st_msg_check_ser_num
,t1.mobile_no as mobile_no
,t1.cert_no as cert_no
,t1.super_olbk_entry_rela_seq_num as super_olbk_entry_rela_seq_num
,t1.lmt_order_no as lmt_order_no
,t1.bind_flg as bind_flg
,t1.ova_flow_num as ova_flow_num
,t1.esb_intfc_return_code as esb_intfc_return_code
,t1.esb_intfc_return_info as esb_intfc_return_info
,t1.esb_intfc_tran_flow_num as esb_intfc_tran_flow_num

from ${idl_schema}.oass_evt_super_olbk_tran_evt t1
where t1.send_bank_dt <= to_date('${batch_date}','yyyymmdd') and t1.send_bank_dt >= to_date('${batch_date}','yyyymmdd') - 14" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_evt_super_olbk_tran_evt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
