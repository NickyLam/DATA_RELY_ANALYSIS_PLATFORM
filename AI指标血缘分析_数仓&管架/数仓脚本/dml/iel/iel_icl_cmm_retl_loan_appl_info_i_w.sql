: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_retl_loan_appl_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_retl_loan_appl_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.loan_appl_flow_num,chr(13),''),chr(10),'') as loan_appl_flow_num
,replace(replace(t.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t.belong_brch_id,chr(13),''),chr(10),'') as belong_brch_id
,replace(replace(t.access_chn_id,chr(13),''),chr(10),'') as access_chn_id
,replace(replace(t.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd
,replace(replace(t.spec_usage,chr(13),''),chr(10),'') as spec_usage
,replace(replace(t.repay_src_cd,chr(13),''),chr(10),'') as repay_src_cd
,replace(replace(t.ghb_emply_flg,chr(13),''),chr(10),'') as ghb_emply_flg
,replace(replace(t.final_jud_advise_sucs_flg,chr(13),''),chr(10),'') as final_jud_advise_sucs_flg
,replace(replace(t.distr_advise_sucs_flg,chr(13),''),chr(10),'') as distr_advise_sucs_flg
,replace(replace(t.blip_doc_flg,chr(13),''),chr(10),'') as blip_doc_flg
,replace(replace(t.open_acct_sucs_flg,chr(13),''),chr(10),'') as open_acct_sucs_flg
,replace(replace(t.netw_vrfction_status_flg,chr(13),''),chr(10),'') as netw_vrfction_status_flg
,replace(replace(t.crdtc_que_situ_flg,chr(13),''),chr(10),'') as crdtc_que_situ_flg
,replace(replace(t.espec_loan_flg,chr(13),''),chr(10),'') as espec_loan_flg
,replace(replace(t.main_debit_ps_cert_type_cd,chr(13),''),chr(10),'') as main_debit_ps_cert_type_cd
,replace(replace(t.main_debit_ps_cert_id,chr(13),''),chr(10),'') as main_debit_ps_cert_id
,replace(replace(t.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,t.appl_amt as appl_amt
,t.crdt_amt as crdt_amt
,replace(replace(t.score_val,chr(13),''),chr(10),'') as score_val
,replace(replace(t.first_trial_apv_status_cd,chr(13),''),chr(10),'') as first_trial_apv_status_cd
,t.first_trial_appl_dt as first_trial_appl_dt
,replace(replace(t.first_trial_appl_tm,chr(13),''),chr(10),'') as first_trial_appl_tm
,t.first_trial_end_tm as first_trial_end_tm
,t.final_jud_appl_dt as final_jud_appl_dt
,replace(replace(t.final_jud_appl_tm,chr(13),''),chr(10),'') as final_jud_appl_tm
,t.final_jud_apv_lmt as final_jud_apv_lmt
,replace(replace(t.final_jud_apv_status_cd,chr(13),''),chr(10),'') as final_jud_apv_status_cd
,replace(replace(t.apv_opinion,chr(13),''),chr(10),'') as apv_opinion
,replace(replace(t.apv_concus,chr(13),''),chr(10),'') as apv_concus
,t.final_jud_end_tm as final_jud_end_tm
,replace(replace(t.refuse_rs,chr(13),''),chr(10),'') as refuse_rs
from ${icl_schema}.cmm_retl_loan_appl_info t
where etl_dt = to_date('${batch_date}','yyyymmdd')    ; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_retl_loan_appl_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes