: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_evt_cbps_tran_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_evt_cbps_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,evt_id
,lp_id
,sys_id
,midgrod_flow_num
,midgrod_tran_dt
,midgrod_tran_tm
,msg_type_id
,origi_bank_no
,init_clear_bk_no
,recv_bank_no
,recv_clear_bk_no
,entr_dt
,msg_idf_id
,dtl_idf_id
,bank_int_bus_seq_num
,midgrod_tran_code
,curr_cd
,tran_amt
,nostro_cd
,debit_crdt_dir_cd
,core_tran_code
,core_tran_dt
,core_flow_num
,entr_tm
,payer_open_belong_city_cd
,pay_clear_bk_no
,payer_open_dept_id
,payer_open_no
,payer_open_bank_name
,payer_acct_type_cd
,payer_acct_num
,payer_name
,payer_addr
,recver_open_belong_city_cd
,recver_open_bank_no
,recvbl_clear_bk_no
,recver_open_bank_name
,recver_acct_type_cd
,recver_acct_num
,recver_name
,recver_addr
,bus_type_cd
,bus_kind_cd
,init_entr_dt
,init_msg_idf_id
,init_origi_bank_no
,init_msg_type_id
,mode_pay_cd
,vouch_type_cd
,vouch_dt
,vouch_no
,prior_level
,tran_org_id
,tran_teller_id
,refund_rs_descb
,tran_chn_cd
,tran_lmt
,err_return_code
,err_info_desc
,recv_tm
,rtn_rcpt_msg_idf_id
,cbps_bus_status_cd
,offs_bal_num_site
,offs_bal_dt
,cbps_bus_process_cd
,clear_dt
,bus_check_entry_status_cd
,core_check_entry_status_cd
,tran_status_cd
,tran_rest_descb
,update_tm
,mgmt_org_id
,on_acct_rs_cd
,on_acct_rs_comnt
,on_acct_dt
,on_acct_teller_id
,on_acct_org_id
,on_acct_acct_num
,on_acct_acct_name
,matn_enter_acct_dt
,matn_enter_acct_teller_id
,matn_enter_acct_org_id
,matn_enter_acct_num
,matn_enter_name
,revs_teller_id
,revs_tran_flow_num
,revs_dt
,intnal_acct_flg
,actl_deduct_acct_num
,actl_deduct_acct_name
,e_acct_flg
,acct_type_cd
,ova_flow_num
,unify_pay_chn_flow_num
,happ_od_flg
,od_amt
,lmt_order_no
,e_acct_prod_acct_num
,e_acct_entry_memo
,pay_check_midgrod_flow_num
,pay_check_midgrod_tran_dt
,tran_type_cd
from idl.aml_evt_cbps_tran_flow
where etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_evt_cbps_tran_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes