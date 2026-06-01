: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_ppps_debit_class_tran_flow_i
CreateDate: 20250303
FileName:   ${iel_data_path}/evt_ppps_debit_class_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.plat_flow_num,chr(13),''),chr(10),'') as plat_flow_num
,plat_tran_dt
,plat_tran_tm
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.adv_flg,chr(13),''),chr(10),'') as adv_flg
,replace(replace(t1.check_entry_idf_type_cd,chr(13),''),chr(10),'') as check_entry_idf_type_cd
,replace(replace(t1.check_entry_proc_flg,chr(13),''),chr(10),'') as check_entry_proc_flg
,check_entry_proc_tm
,replace(replace(t1.check_entry_rest_descb,chr(13),''),chr(10),'') as check_entry_rest_descb
,check_entry_dt
,replace(replace(t1.check_entry_status_cd,chr(13),''),chr(10),'') as check_entry_status_cd
,replace(replace(t1.payer_cust_acct_num,chr(13),''),chr(10),'') as payer_cust_acct_num
,replace(replace(t1.payer_mobile_no,chr(13),''),chr(10),'') as payer_mobile_no
,replace(replace(t1.payer_acct_num_cate_cd,chr(13),''),chr(10),'') as payer_acct_num_cate_cd
,replace(replace(t1.payer_acct_num_belong_core_type_cd,chr(13),''),chr(10),'') as payer_acct_num_belong_core_type_cd
,replace(replace(t1.payer_acct_name,chr(13),''),chr(10),'') as payer_acct_name
,replace(replace(t1.pay_bank_clear_bk_num,chr(13),''),chr(10),'') as pay_bank_clear_bk_num
,replace(replace(t1.pay_bank_clear_bk_name,chr(13),''),chr(10),'') as pay_bank_clear_bk_name
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.core_revs_flow_num,chr(13),''),chr(10),'') as core_revs_flow_num
,replace(replace(t1.core_check_entry_rest_descb,chr(13),''),chr(10),'') as core_check_entry_rest_descb
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,core_resp_dt
,core_resp_tm
,replace(replace(t1.fee_type_cd,chr(13),''),chr(10),'') as fee_type_cd
,replace(replace(t1.tran_remark,chr(13),''),chr(10),'') as tran_remark
,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,replace(replace(t1.tran_proc_status_cd,chr(13),''),chr(10),'') as tran_proc_status_cd
,replace(replace(t1.tran_postsc,chr(13),''),chr(10),'') as tran_postsc
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.tran_core_acct_status_cd,chr(13),''),chr(10),'') as tran_core_acct_status_cd
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,tran_amt
,replace(replace(t1.tran_cate_cd,chr(13),''),chr(10),'') as tran_cate_cd
,replace(replace(t1.tran_batch_id,chr(13),''),chr(10),'') as tran_batch_id
,tran_clear_dt
,replace(replace(t1.tran_aging_type_cd,chr(13),''),chr(10),'') as tran_aging_type_cd
,cust_comm_fee
,replace(replace(t1.cross_bank_flg,chr(13),''),chr(10),'') as cross_bank_flg
,replace(replace(t1.free_comm_fee_flg,chr(13),''),chr(10),'') as free_comm_fee_flg
,replace(replace(t1.clear_type_cd,chr(13),''),chr(10),'') as clear_type_cd
,replace(replace(t1.clear_flow_num,chr(13),''),chr(10),'') as clear_flow_num
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.chn_check_entry_prod_id,chr(13),''),chr(10),'') as chn_check_entry_prod_id
,replace(replace(t1.chn_check_entry_mode_cd,chr(13),''),chr(10),'') as chn_check_entry_mode_cd
,chn_check_entry_dt
,replace(replace(t1.chn_tran_flow_num,chr(13),''),chr(10),'') as chn_tran_flow_num
,chn_tran_dt
,chn_tran_tm
,chn_tran_comm_fee
,replace(replace(t1.chn_comm_fee_entry_flow_num,chr(13),''),chr(10),'') as chn_comm_fee_entry_flow_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.realtm_clear_flg,chr(13),''),chr(10),'') as realtm_clear_flg
,replace(replace(t1.recver_cust_acct_num,chr(13),''),chr(10),'') as recver_cust_acct_num
,replace(replace(t1.recver_mobile_no,chr(13),''),chr(10),'') as recver_mobile_no
,replace(replace(t1.recver_acct_num_cate_cd,chr(13),''),chr(10),'') as recver_acct_num_cate_cd
,replace(replace(t1.recver_acct_num_belong_core_type_cd,chr(13),''),chr(10),'') as recver_acct_num_belong_core_type_cd
,replace(replace(t1.recver_acct_name,chr(13),''),chr(10),'') as recver_acct_name
,replace(replace(t1.recv_bank_clear_bk_num,chr(13),''),chr(10),'') as recv_bank_clear_bk_num
,replace(replace(t1.recv_bank_clear_bk_name_name,chr(13),''),chr(10),'') as recv_bank_clear_bk_name_name
,replace(replace(t1.comm_fee_collect_status_cd,chr(13),''),chr(10),'') as comm_fee_collect_status_cd
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.caller_sys_id,chr(13),''),chr(10),'') as caller_sys_id
,pass_cost_fee
,replace(replace(t1.pass_check_entry_rest_descb,chr(13),''),chr(10),'') as pass_check_entry_rest_descb
,replace(replace(t1.pass_tran_flow_num,chr(13),''),chr(10),'') as pass_tran_flow_num
,pass_tran_dt
,pass_tran_tm
,replace(replace(t1.pass_sys_code,chr(13),''),chr(10),'') as pass_sys_code
,replace(replace(t1.pass_resp_flow_num,chr(13),''),chr(10),'') as pass_resp_flow_num
,pass_resp_dt
,pass_resp_tm
,replace(replace(t1.pass_resp_status_cd,chr(13),''),chr(10),'') as pass_resp_status_cd
,replace(replace(t1.nostro_cd,chr(13),''),chr(10),'') as nostro_cd
,replace(replace(t1.sys_comm_flow_num,chr(13),''),chr(10),'') as sys_comm_flow_num
,replace(replace(t1.bus_proc_status_cd,chr(13),''),chr(10),'') as bus_proc_status_cd
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.aldy_clear_flg,chr(13),''),chr(10),'') as aldy_clear_flg
,replace(replace(t1.aldy_refund_flg,chr(13),''),chr(10),'') as aldy_refund_flg
,final_update_tm
,replace(replace(t1.sorc_sys_id,chr(13),''),chr(10),'') as sorc_sys_id

from ${iml_schema}.evt_ppps_debit_class_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ppps_debit_class_tran_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
