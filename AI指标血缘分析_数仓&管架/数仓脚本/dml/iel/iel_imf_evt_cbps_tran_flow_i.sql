: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_cbps_tran_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_cbps_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.midgrod_flow_num,chr(13),''),chr(10),'') as midgrod_flow_num
,t1.midgrod_tran_dt as midgrod_tran_dt
,replace(replace(t1.midgrod_tran_tm,chr(13),''),chr(10),'') as midgrod_tran_tm
,replace(replace(t1.msg_type_id,chr(13),''),chr(10),'') as msg_type_id
,replace(replace(t1.origi_bank_no,chr(13),''),chr(10),'') as origi_bank_no
,replace(replace(t1.init_clear_bk_no,chr(13),''),chr(10),'') as init_clear_bk_no
,replace(replace(t1.recv_bank_no,chr(13),''),chr(10),'') as recv_bank_no
,replace(replace(t1.recv_clear_bk_no,chr(13),''),chr(10),'') as recv_clear_bk_no
,t1.entr_dt as entr_dt
,replace(replace(t1.msg_idf_id,chr(13),''),chr(10),'') as msg_idf_id
,replace(replace(t1.dtl_idf_id,chr(13),''),chr(10),'') as dtl_idf_id
,replace(replace(t1.bank_int_bus_seq_num,chr(13),''),chr(10),'') as bank_int_bus_seq_num
,replace(replace(t1.midgrod_tran_code,chr(13),''),chr(10),'') as midgrod_tran_code
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.tran_amt as tran_amt
,replace(replace(t1.nostro_cd,chr(13),''),chr(10),'') as nostro_cd
,replace(replace(t1.debit_crdt_dir_cd,chr(13),''),chr(10),'') as debit_crdt_dir_cd
,replace(replace(t1.core_tran_code,chr(13),''),chr(10),'') as core_tran_code
,t1.core_tran_dt as core_tran_dt
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,t1.entr_tm as entr_tm
,replace(replace(t1.payer_open_belong_city_cd,chr(13),''),chr(10),'') as payer_open_belong_city_cd
,replace(replace(t1.pay_clear_bk_no,chr(13),''),chr(10),'') as pay_clear_bk_no
,replace(replace(t1.payer_open_dept_id,chr(13),''),chr(10),'') as payer_open_dept_id
,replace(replace(t1.payer_open_no,chr(13),''),chr(10),'') as payer_open_no
,replace(replace(t1.payer_open_bank_name,chr(13),''),chr(10),'') as payer_open_bank_name
,replace(replace(t1.payer_acct_type_cd,chr(13),''),chr(10),'') as payer_acct_type_cd
,replace(replace(t1.payer_acct_num,chr(13),''),chr(10),'') as payer_acct_num
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t1.payer_addr,chr(13),''),chr(10),'') as payer_addr
,replace(replace(t1.recver_open_belong_city_cd,chr(13),''),chr(10),'') as recver_open_belong_city_cd
,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no
,replace(replace(t1.recvbl_clear_bk_no,chr(13),''),chr(10),'') as recvbl_clear_bk_no
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
,replace(replace(t1.recver_acct_type_cd,chr(13),''),chr(10),'') as recver_acct_type_cd
,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recver_addr,chr(13),''),chr(10),'') as recver_addr
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.bus_kind_cd,chr(13),''),chr(10),'') as bus_kind_cd
,t1.init_entr_dt as init_entr_dt
,replace(replace(t1.init_msg_idf_id,chr(13),''),chr(10),'') as init_msg_idf_id
,replace(replace(t1.init_origi_bank_no,chr(13),''),chr(10),'') as init_origi_bank_no
,replace(replace(t1.init_msg_type_id,chr(13),''),chr(10),'') as init_msg_type_id
,replace(replace(t1.mode_pay_cd,chr(13),''),chr(10),'') as mode_pay_cd
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
,t1.vouch_dt as vouch_dt
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no
,replace(replace(t1.prior_level,chr(13),''),chr(10),'') as prior_level
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.refund_rs_descb,chr(13),''),chr(10),'') as refund_rs_descb
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,t1.tran_lmt as tran_lmt
,replace(replace(t1.err_return_code,chr(13),''),chr(10),'') as err_return_code
,replace(replace(t1.err_info_desc,chr(13),''),chr(10),'') as err_info_desc
,t1.recv_tm as recv_tm
,replace(replace(t1.rtn_rcpt_msg_idf_id,chr(13),''),chr(10),'') as rtn_rcpt_msg_idf_id
,replace(replace(t1.cbps_bus_status_cd,chr(13),''),chr(10),'') as cbps_bus_status_cd
,replace(replace(t1.offs_bal_num_site,chr(13),''),chr(10),'') as offs_bal_num_site
,t1.offs_bal_dt as offs_bal_dt
,replace(replace(t1.cbps_bus_process_cd,chr(13),''),chr(10),'') as cbps_bus_process_cd
,t1.clear_dt as clear_dt
,replace(replace(t1.bus_check_entry_status_cd,chr(13),''),chr(10),'') as bus_check_entry_status_cd
,replace(replace(t1.core_check_entry_status_cd,chr(13),''),chr(10),'') as core_check_entry_status_cd
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.tran_rest_descb,chr(13),''),chr(10),'') as tran_rest_descb
,t1.update_tm as update_tm
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.on_acct_rs_cd,chr(13),''),chr(10),'') as on_acct_rs_cd
,replace(replace(t1.on_acct_rs_comnt,chr(13),''),chr(10),'') as on_acct_rs_comnt
,t1.on_acct_dt as on_acct_dt
,replace(replace(t1.on_acct_teller_id,chr(13),''),chr(10),'') as on_acct_teller_id
,replace(replace(t1.on_acct_org_id,chr(13),''),chr(10),'') as on_acct_org_id
,replace(replace(t1.on_acct_acct_num,chr(13),''),chr(10),'') as on_acct_acct_num
,replace(replace(t1.on_acct_acct_name,chr(13),''),chr(10),'') as on_acct_acct_name
,t1.matn_enter_acct_dt as matn_enter_acct_dt
,replace(replace(t1.matn_enter_acct_teller_id,chr(13),''),chr(10),'') as matn_enter_acct_teller_id
,replace(replace(t1.matn_enter_acct_org_id,chr(13),''),chr(10),'') as matn_enter_acct_org_id
,replace(replace(t1.matn_enter_acct_num,chr(13),''),chr(10),'') as matn_enter_acct_num
,replace(replace(t1.matn_enter_name,chr(13),''),chr(10),'') as matn_enter_name
,replace(replace(t1.revs_teller_id,chr(13),''),chr(10),'') as revs_teller_id
,replace(replace(t1.revs_tran_flow_num,chr(13),''),chr(10),'') as revs_tran_flow_num
,t1.revs_dt as revs_dt
,replace(replace(t1.intnal_acct_flg,chr(13),''),chr(10),'') as intnal_acct_flg
,replace(replace(t1.actl_deduct_acct_num,chr(13),''),chr(10),'') as actl_deduct_acct_num
,replace(replace(t1.actl_deduct_acct_name,chr(13),''),chr(10),'') as actl_deduct_acct_name
,replace(replace(t1.e_acct_flg,chr(13),''),chr(10),'') as e_acct_flg
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.unify_pay_chn_flow_num,chr(13),''),chr(10),'') as unify_pay_chn_flow_num
,replace(replace(t1.happ_od_flg,chr(13),''),chr(10),'') as happ_od_flg
,t1.od_amt as od_amt
,replace(replace(t1.lmt_order_no,chr(13),''),chr(10),'') as lmt_order_no
,replace(replace(t1.e_acct_prod_acct_num,chr(13),''),chr(10),'') as e_acct_prod_acct_num
,replace(replace(t1.e_acct_entry_memo,chr(13),''),chr(10),'') as e_acct_entry_memo
,replace(replace(t1.pay_check_midgrod_flow_num,chr(13),''),chr(10),'') as pay_check_midgrod_flow_num
,t1.pay_check_midgrod_tran_dt as pay_check_midgrod_tran_dt
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
from ${iml_schema}.evt_cbps_tran_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt > to_date('${batch_date}','yyyymmdd')-15;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_cbps_tran_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes