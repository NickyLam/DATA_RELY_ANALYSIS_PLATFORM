: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_bank_draft_rgst_flow_m_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_bank_draft_rgst_flow_m.i.${batch_date}.dat
IF_mark:    m_i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.midgrod_flow_num,chr(13),''),chr(10),'') as midgrod_flow_num
,t1.tran_dt as tran_dt
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,t1.draw_dt as draw_dt
,replace(replace(t1.payer_acct_id,chr(13),''),chr(10),'') as payer_acct_id
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t1.proc_org_id,chr(13),''),chr(10),'') as proc_org_id
,replace(replace(t1.draft_type_cd,chr(13),''),chr(10),'') as draft_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.draw_amt as draw_amt
,replace(replace(t1.cash_bk_bank_no,chr(13),''),chr(10),'') as cash_bk_bank_no
,replace(replace(t1.cash_bank_name,chr(13),''),chr(10),'') as cash_bank_name
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id
,replace(replace(t1.cap_usage_cd,chr(13),''),chr(10),'') as cap_usage_cd
,replace(replace(t1.postsc,chr(13),''),chr(10),'') as postsc
,replace(replace(t1.draft_status_cd,chr(13),''),chr(10),'') as draft_status_cd
,replace(replace(t1.draft_src_cd,chr(13),''),chr(10),'') as draft_src_cd
,replace(replace(t1.final_holder_open_bank_no,chr(13),''),chr(10),'') as final_holder_open_bank_no
,replace(replace(t1.final_holder_acct_id,chr(13),''),chr(10),'') as final_holder_acct_id
,replace(replace(t1.final_holder_name,chr(13),''),chr(10),'') as final_holder_name
,t1.proc_dt as proc_dt
,replace(replace(t1.proc_flow_num,chr(13),''),chr(10),'') as proc_flow_num
,replace(replace(t1.proc_teller_id,chr(13),''),chr(10),'') as proc_teller_id
,replace(replace(t1.amt_auth_teller_id,chr(13),''),chr(10),'') as amt_auth_teller_id
,replace(replace(t1.matn_entra_teller_id,chr(13),''),chr(10),'') as matn_entra_teller_id
,replace(replace(t1.matn_enter_acct_auth_teller_id,chr(13),''),chr(10),'') as matn_enter_acct_auth_teller_id
,replace(replace(t1.print_teller_id,chr(13),''),chr(10),'') as print_teller_id
,t1.print_cnt as print_cnt
,t1.cash_dt as cash_dt
,t1.cash_amt as cash_amt
,replace(replace(t1.msg_id,chr(13),''),chr(10),'') as msg_id
,t1.entr_dt as entr_dt
,replace(replace(t1.process_cd,chr(13),''),chr(10),'') as process_cd
,t1.loss_stop_pay_dt as loss_stop_pay_dt
,replace(replace(t1.loss_stop_pay_teller_id,chr(13),''),chr(10),'') as loss_stop_pay_teller_id
,t1.unloss_or_revo_stop_pay_dt as unloss_or_revo_stop_pay_dt
,replace(replace(t1.unloss_or_revo_stop_pay_teller_id,chr(13),''),chr(10),'') as unloss_or_revo_stop_pay_teller_id
,replace(replace(t1.loss_applit_cert_type_cd,chr(13),''),chr(10),'') as loss_applit_cert_type_cd
,replace(replace(t1.loss_applit_cert_no,chr(13),''),chr(10),'') as loss_applit_cert_no
,replace(replace(t1.loss_operr_name,chr(13),''),chr(10),'') as loss_operr_name
,replace(replace(t1.loss_operr_cont_addr,chr(13),''),chr(10),'') as loss_operr_cont_addr
,replace(replace(t1.loss_operr_phone,chr(13),''),chr(10),'') as loss_operr_phone
,replace(replace(t1.lost_reason,chr(13),''),chr(10),'') as lost_reason
,t1.lost_dt as lost_dt
,replace(replace(t1.lost_site_descb,chr(13),''),chr(10),'') as lost_site_descb
,replace(replace(t1.unloss_applit_cert_type_cd,chr(13),''),chr(10),'') as unloss_applit_cert_type_cd
,replace(replace(t1.unloss_applit_cert_no,chr(13),''),chr(10),'') as unloss_applit_cert_no
,replace(replace(t1.unloss_operr_name,chr(13),''),chr(10),'') as unloss_operr_name
,replace(replace(t1.unloss_operr_cont_addr,chr(13),''),chr(10),'') as unloss_operr_cont_addr
,replace(replace(t1.unloss_operr_phone,chr(13),''),chr(10),'') as unloss_operr_phone
,replace(replace(t1.unloss_rest_descb,chr(13),''),chr(10),'') as unloss_rest_descb
,replace(replace(t1.stop_pay_proof_cate,chr(13),''),chr(10),'') as stop_pay_proof_cate
,replace(replace(t1.stop_pay_proof_id,chr(13),''),chr(10),'') as stop_pay_proof_id
,replace(replace(t1.stop_pay_rs_descb,chr(13),''),chr(10),'') as stop_pay_rs_descb
,replace(replace(t1.stop_pay_exec_org,chr(13),''),chr(10),'') as stop_pay_exec_org
,replace(replace(t1.stop_pay_exec_person_name,chr(13),''),chr(10),'') as stop_pay_exec_person_name
,replace(replace(t1.stop_pay_cert_type_cd,chr(13),''),chr(10),'') as stop_pay_cert_type_cd
,replace(replace(t1.stop_pay_cert_no,chr(13),''),chr(10),'') as stop_pay_cert_no
,replace(replace(t1.revo_stop_pay_proof_cate_cd,chr(13),''),chr(10),'') as revo_stop_pay_proof_cate_cd
,replace(replace(t1.revo_stop_pay_proof_id,chr(13),''),chr(10),'') as revo_stop_pay_proof_id
,replace(replace(t1.revo_stop_pay_rs_descb,chr(13),''),chr(10),'') as revo_stop_pay_rs_descb
,replace(replace(t1.revo_stop_pay_exec_org,chr(13),''),chr(10),'') as revo_stop_pay_exec_org
,replace(replace(t1.revo_stop_pay_exec_person_name,chr(13),''),chr(10),'') as revo_stop_pay_exec_person_name
,replace(replace(t1.revo_stop_pay_cert_type_cd,chr(13),''),chr(10),'') as revo_stop_pay_cert_type_cd
,replace(replace(t1.revo_stop_pay_cert_no,chr(13),''),chr(10),'') as revo_stop_pay_cert_no
,replace(replace(t1.issue_draft_charge_way_cd,chr(13),''),chr(10),'') as issue_draft_charge_way_cd
,replace(replace(t1.charge_flg,chr(13),''),chr(10),'') as charge_flg
,t1.comm_fee_amt as comm_fee_amt
,t1.remit_tran_fee_amt as remit_tran_fee_amt
,t1.todos_amt as todos_amt
from ${iml_schema}.evt_bank_draft_rgst_flow t1
where to_char(etl_dt,'yyyymm') = to_char(to_date('${batch_date}','yyyymmdd'),'yyyymm')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bank_draft_rgst_flow_m.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes