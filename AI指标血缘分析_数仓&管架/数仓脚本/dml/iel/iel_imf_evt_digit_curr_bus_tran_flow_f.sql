: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_digit_curr_bus_tran_flow_f
CreateDate: 20241029
FileName:   ${iel_data_path}/evt_digit_curr_bus_tran_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sys_code,chr(13),''),chr(10),'') as sys_code
,replace(replace(t1.midgrod_flow_num,chr(13),''),chr(10),'') as midgrod_flow_num
,midgrod_dt
,replace(replace(t1.midgrod_tran_code,chr(13),''),chr(10),'') as midgrod_tran_code
,replace(replace(t1.msg_id,chr(13),''),chr(10),'') as msg_id
,replace(replace(t1.msg_idf_id,chr(13),''),chr(10),'') as msg_idf_id
,replace(replace(t1.send_bank_no,chr(13),''),chr(10),'') as send_bank_no
,replace(replace(t1.origi_bank_code,chr(13),''),chr(10),'') as origi_bank_code
,replace(replace(t1.recv_bank_num,chr(13),''),chr(10),'') as recv_bank_num
,replace(replace(t1.recv_bank_code,chr(13),''),chr(10),'') as recv_bank_code
,entr_dt
,replace(replace(t1.bank_int_bus_seq_num,chr(13),''),chr(10),'') as bank_int_bus_seq_num
,replace(replace(t1.bank_int_err_cd,chr(13),''),chr(10),'') as bank_int_err_cd
,replace(replace(t1.bank_int_err_info,chr(13),''),chr(10),'') as bank_int_err_info
,replace(replace(t1.nostro_flg,chr(13),''),chr(10),'') as nostro_flg
,replace(replace(t1.fin_tran_code,chr(13),''),chr(10),'') as fin_tran_code
,fin_tran_dt
,replace(replace(t1.fin_tran_flow_num,chr(13),''),chr(10),'') as fin_tran_flow_num
,replace(replace(t1.fin_midgrod_flow_num,chr(13),''),chr(10),'') as fin_midgrod_flow_num
,fin_midgrod_dt
,replace(replace(t1.fin_check_entry_status_cd,chr(13),''),chr(10),'') as fin_check_entry_status_cd
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.payer_open_bank_num,chr(13),''),chr(10),'') as payer_open_bank_num
,replace(replace(t1.payer_open_bank_name,chr(13),''),chr(10),'') as payer_open_bank_name
,replace(replace(t1.payer_acct_type_cd,chr(13),''),chr(10),'') as payer_acct_type_cd
,replace(replace(t1.payer_acct_id,chr(13),''),chr(10),'') as payer_acct_id
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t1.pay_acct_resdnt_type_cd,chr(13),''),chr(10),'') as pay_acct_resdnt_type_cd
,replace(replace(t1.pay_acct_permt_rg_cd,chr(13),''),chr(10),'') as pay_acct_permt_rg_cd
,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
,replace(replace(t1.recver_acct_type_cd,chr(13),''),chr(10),'') as recver_acct_type_cd
,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recvbl_acct_resdnt_type_cd,chr(13),''),chr(10),'') as recvbl_acct_resdnt_type_cd
,replace(replace(t1.recvbl_acct_permt_rg_cd,chr(13),''),chr(10),'') as recvbl_acct_permt_rg_cd
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.pkg_level_cd,chr(13),''),chr(10),'') as pkg_level_cd
,replace(replace(t1.pkg_type_cd,chr(13),''),chr(10),'') as pkg_type_cd
,replace(replace(t1.pkg_name,chr(13),''),chr(10),'') as pkg_name
,replace(replace(t1.pkg_rgst_mobile_no_site_cd,chr(13),''),chr(10),'') as pkg_rgst_mobile_no_site_cd
,replace(replace(t1.bus_type_id,chr(13),''),chr(10),'') as bus_type_id
,replace(replace(t1.bus_kind_id,chr(13),''),chr(10),'') as bus_kind_id
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.bus_process_cd,chr(13),''),chr(10),'') as bus_process_cd
,bus_proc_dt
,replace(replace(t1.bus_status_cd,chr(13),''),chr(10),'') as bus_status_cd
,replace(replace(t1.bus_rtn_rcpt_status_cd,chr(13),''),chr(10),'') as bus_rtn_rcpt_status_cd
,replace(replace(t1.bus_refuse_code,chr(13),''),chr(10),'') as bus_refuse_code
,replace(replace(t1.bus_refuse_info,chr(13),''),chr(10),'') as bus_refuse_info
,replace(replace(t1.bus_check_entry_status_cd,chr(13),''),chr(10),'') as bus_check_entry_status_cd
,replace(replace(t1.tran_batch_no,chr(13),''),chr(10),'') as tran_batch_no
,tran_amt
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.tran_excep_proc_flg,chr(13),''),chr(10),'') as tran_excep_proc_flg
,replace(replace(t1.tran_rest_descb,chr(13),''),chr(10),'') as tran_rest_descb
,replace(replace(t1.tran_usage_cd,chr(13),''),chr(10),'') as tran_usage_cd
,replace(replace(t1.tran_cap_src_cd,chr(13),''),chr(10),'') as tran_cap_src_cd
,tran_effect_dt
,tran_invalid_dt
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,replace(replace(t1.comm_fee_flg,chr(13),''),chr(10),'') as comm_fee_flg
,comm_fee_amt
,proc_cnt
,replace(replace(t1.err_rs_code,chr(13),''),chr(10),'') as err_rs_code
,replace(replace(t1.err_rs_comnt,chr(13),''),chr(10),'') as err_rs_comnt
,rtn_rcpt_tran_dt
,replace(replace(t1.rtn_rcpt_msg_idf_id,chr(13),''),chr(10),'') as rtn_rcpt_msg_idf_id
,replace(replace(t1.rtn_rcpt_msg_id,chr(13),''),chr(10),'') as rtn_rcpt_msg_id
,replace(replace(t1.letter_idf_flow_num,chr(13),''),chr(10),'') as letter_idf_flow_num
,replace(replace(t1.letter_ref_flow_num,chr(13),''),chr(10),'') as letter_ref_flow_num
,init_entr_dt
,replace(replace(t1.init_msg_idf_id,chr(13),''),chr(10),'') as init_msg_idf_id
,replace(replace(t1.init_init_prtcpt_org_id,chr(13),''),chr(10),'') as init_init_prtcpt_org_id
,replace(replace(t1.init_msg_type_id,chr(13),''),chr(10),'') as init_msg_type_id
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.unify_pay_chn_flow_num,chr(13),''),chr(10),'') as unify_pay_chn_flow_num
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.intfc_return_code,chr(13),''),chr(10),'') as intfc_return_code
,replace(replace(t1.intfc_return_info,chr(13),''),chr(10),'') as intfc_return_info
,replace(replace(t1.intfc_tran_flow_num,chr(13),''),chr(10),'') as intfc_tran_flow_num
,adj_entry_amt
,replace(replace(t1.postsc,chr(13),''),chr(10),'') as postsc
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,final_update_dt

from ${iml_schema}.evt_digit_curr_bus_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_digit_curr_bus_tran_flow.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
