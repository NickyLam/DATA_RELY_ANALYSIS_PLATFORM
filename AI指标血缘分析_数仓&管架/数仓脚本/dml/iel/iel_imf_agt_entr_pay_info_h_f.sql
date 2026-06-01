: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_entr_pay_info_h_f
CreateDate: 20250116
FileName:   ${iel_data_path}/agt_entr_pay_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.pay_flow_num,chr(13),''),chr(10),'') as pay_flow_num
,replace(replace(t1.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num
,replace(replace(t1.pay_ser_num,chr(13),''),chr(10),'') as pay_ser_num
,replace(replace(t1.plat_req_flow_num,chr(13),''),chr(10),'') as plat_req_flow_num
,replace(replace(t1.plat_tran_flow_num,chr(13),''),chr(10),'') as plat_tran_flow_num
,plat_tran_dt
,replace(replace(t1.dtl_flow_num,chr(13),''),chr(10),'') as dtl_flow_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,pay_dt
,actl_pay_dt
,pay_tm
,replace(replace(t1.tran_in_bank_name,chr(13),''),chr(10),'') as tran_in_bank_name
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,pay_amt
,replace(replace(t1.pay_status_cd,chr(13),''),chr(10),'') as pay_status_cd
,replace(replace(t1.cap_usage_descb,chr(13),''),chr(10),'') as cap_usage_descb
,replace(replace(t1.precon_entr_pay_flg,chr(13),''),chr(10),'') as precon_entr_pay_flg
,replace(replace(t1.entr_pay_id,chr(13),''),chr(10),'') as entr_pay_id
,replace(replace(t1.entr_pay_batch_no,chr(13),''),chr(10),'') as entr_pay_batch_no
,replace(replace(t1.entr_pay_seq_num,chr(13),''),chr(10),'') as entr_pay_seq_num
,replace(replace(t1.entr_pay_tot_id,chr(13),''),chr(10),'') as entr_pay_tot_id
,replace(replace(t1.onl_entr_pay_status_cd,chr(13),''),chr(10),'') as onl_entr_pay_status_cd
,replace(replace(t1.onl_entred_init_tran_plat_flow_num,chr(13),''),chr(10),'') as onl_entred_init_tran_plat_flow_num
,replace(replace(t1.onl_entred_stop_pay_tran_flow_num,chr(13),''),chr(10),'') as onl_entred_stop_pay_tran_flow_num
,replace(replace(t1.stop_pay_flow_num,chr(13),''),chr(10),'') as stop_pay_flow_num
,stop_pay_tran_dt
,replace(replace(t1.froz_flow_num,chr(13),''),chr(10),'') as froz_flow_num
,a_send_tm
,replace(replace(t1.pay_fail_rs_descb,chr(13),''),chr(10),'') as pay_fail_rs_descb
,replace(replace(t1.bank_int_acct_flg,chr(13),''),chr(10),'') as bank_int_acct_flg
,replace(replace(t1.repeat_status_cd,chr(13),''),chr(10),'') as repeat_status_cd
,replace(replace(t1.cfm_status_cd,chr(13),''),chr(10),'') as cfm_status_cd
,replace(replace(t1.move_flg,chr(13),''),chr(10),'') as move_flg
,latest_pay_dt
,replace(replace(t1.matn_idf_cd,chr(13),''),chr(10),'') as matn_idf_cd
,replace(replace(t1.cross_bor_flg,chr(13),''),chr(10),'') as cross_bor_flg
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,modif_dt

from ${iml_schema}.agt_entr_pay_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_entr_pay_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
