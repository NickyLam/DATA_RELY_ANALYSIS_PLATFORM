: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ppps_crdt_class_tran_flow_i
CreateDate: 20240307
FileName:   ${iel_data_path}/evt_ppps_crdt_class_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,tran_dt
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.tran_cate_cd,chr(13),''),chr(10),'') as tran_cate_cd
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.bus_status_cd,chr(13),''),chr(10),'') as bus_status_cd
,replace(replace(t1.nostro_cd,chr(13),''),chr(10),'') as nostro_cd
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.mercht_tran_flow_num,chr(13),''),chr(10),'') as mercht_tran_flow_num
,mercht_tran_dt
,tran_amt
,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,replace(replace(t1.tran_aging_type_cd,chr(13),''),chr(10),'') as tran_aging_type_cd
,replace(replace(t1.tran_proc_status_cd,chr(13),''),chr(10),'') as tran_proc_status_cd
,replace(replace(t1.tran_batch_no,chr(13),''),chr(10),'') as tran_batch_no
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.realtm_clear_flg,chr(13),''),chr(10),'') as realtm_clear_flg
,clear_dt
,replace(replace(t1.sign_agt_id,chr(13),''),chr(10),'') as sign_agt_id
,replace(replace(t1.tran_postsc,chr(13),''),chr(10),'') as tran_postsc
,replace(replace(t1.recvbl_cert_type_cd,chr(13),''),chr(10),'') as recvbl_cert_type_cd
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name
,replace(replace(t1.recvbl_acct_cate_cd,chr(13),''),chr(10),'') as recvbl_acct_cate_cd
,replace(replace(t1.recvbl_acct_belong_sys_cd,chr(13),''),chr(10),'') as recvbl_acct_belong_sys_cd
,replace(replace(t1.recvbl_mobile_no,chr(13),''),chr(10),'') as recvbl_mobile_no
,replace(replace(t1.recvbl_clear_bk_no,chr(13),''),chr(10),'') as recvbl_clear_bk_no
,replace(replace(t1.recvbl_clear_bk_name,chr(13),''),chr(10),'') as recvbl_clear_bk_name
,replace(replace(t1.pay_cert_type_cd,chr(13),''),chr(10),'') as pay_cert_type_cd
,replace(replace(t1.pay_acct_id,chr(13),''),chr(10),'') as pay_acct_id
,replace(replace(t1.pay_acct_name,chr(13),''),chr(10),'') as pay_acct_name
,replace(replace(t1.pay_acct_cate_cd,chr(13),''),chr(10),'') as pay_acct_cate_cd
,replace(replace(t1.pay_acct_belong_sys_cd,chr(13),''),chr(10),'') as pay_acct_belong_sys_cd
,replace(replace(t1.pay_bank_clear_bk_num,chr(13),''),chr(10),'') as pay_bank_clear_bk_num
,replace(replace(t1.pay_clear_bk_name,chr(13),''),chr(10),'') as pay_clear_bk_name
,replace(replace(t1.actl_pay_acct_id,chr(13),''),chr(10),'') as actl_pay_acct_id
,replace(replace(t1.actl_pay_name,chr(13),''),chr(10),'') as actl_pay_name
,replace(replace(t1.actl_pay_acct_cate_cd,chr(13),''),chr(10),'') as actl_pay_acct_cate_cd
,replace(replace(t1.actl_pay_acct_belong_sys_cd,chr(13),''),chr(10),'') as actl_pay_acct_belong_sys_cd
,replace(replace(t1.acm_lmt_type_cd,chr(13),''),chr(10),'') as acm_lmt_type_cd
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,replace(replace(t1.core_acct_status_cd,chr(13),''),chr(10),'') as core_acct_status_cd
,core_dt
,replace(replace(t1.call_pass_flow_num,chr(13),''),chr(10),'') as call_pass_flow_num
,replace(replace(t1.pass_sys_abbr,chr(13),''),chr(10),'') as pass_sys_abbr
,replace(replace(t1.pass_tran_flow_num,chr(13),''),chr(10),'') as pass_tran_flow_num
,replace(replace(t1.pass_init_status_cd,chr(13),''),chr(10),'') as pass_init_status_cd
,replace(replace(t1.pass_resp_flow_num,chr(13),''),chr(10),'') as pass_resp_flow_num
,pass_resp_dt
,replace(replace(t1.pass_resp_status_cd,chr(13),''),chr(10),'') as pass_resp_status_cd
,pass_tran_dt
,pass_cost_fee
,check_entry_dt
,replace(replace(t1.check_entry_proc_idf,chr(13),''),chr(10),'') as check_entry_proc_idf
,replace(replace(t1.check_entry_idf_type_cd,chr(13),''),chr(10),'') as check_entry_idf_type_cd
,replace(replace(t1.check_entry_rest_descb,chr(13),''),chr(10),'') as check_entry_rest_descb
,check_entry_proc_dt
,replace(replace(t1.chn_check_entry_code,chr(13),''),chr(10),'') as chn_check_entry_code
,chn_check_entry_dt
,replace(replace(t1.chn_check_entry_mode_cd,chr(13),''),chr(10),'') as chn_check_entry_mode_cd
,replace(replace(t1.pass_check_entry_proc_descb,chr(13),''),chr(10),'') as pass_check_entry_proc_descb
,replace(replace(t1.cross_bank_flg,chr(13),''),chr(10),'') as cross_bank_flg
,replace(replace(t1.coll_comm_fee_flg,chr(13),''),chr(10),'') as coll_comm_fee_flg
,comm_fee_amt
,replace(replace(t1.need_delay_tran_acct_flg,chr(13),''),chr(10),'') as need_delay_tran_acct_flg
,replace(replace(t1.delay_tm,chr(13),''),chr(10),'') as delay_tm
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.call_sys_id,chr(13),''),chr(10),'') as call_sys_id
,replace(replace(t1.sorc_sys_id,chr(13),''),chr(10),'') as sorc_sys_id
,replace(replace(t1.adv_exp_flg,chr(13),''),chr(10),'') as adv_exp_flg
,replace(replace(t1.belong_sys_id,chr(13),''),chr(10),'') as belong_sys_id
,fir_create_dt
,final_update_dt
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.evt_ppps_crdt_class_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ppps_crdt_class_tran_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
