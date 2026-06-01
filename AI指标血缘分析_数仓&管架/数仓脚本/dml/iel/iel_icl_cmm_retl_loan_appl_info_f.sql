: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_retl_loan_appl_info_f
CreateDate: 20240425
FileName:   ${iel_data_path}/cmm_retl_loan_appl_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.loan_appl_flow_num,chr(13),''),chr(10),'') as loan_appl_flow_num
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.belong_brch_id,chr(13),''),chr(10),'') as belong_brch_id
,replace(replace(t1.access_chn_id,chr(13),''),chr(10),'') as access_chn_id
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd
,replace(replace(t1.spec_usage,chr(13),''),chr(10),'') as spec_usage
,replace(replace(t1.repay_src_cd,chr(13),''),chr(10),'') as repay_src_cd
,replace(replace(t1.ghb_emply_flg,chr(13),''),chr(10),'') as ghb_emply_flg
,replace(replace(t1.final_jud_advise_sucs_flg,chr(13),''),chr(10),'') as final_jud_advise_sucs_flg
,replace(replace(t1.distr_advise_sucs_flg,chr(13),''),chr(10),'') as distr_advise_sucs_flg
,replace(replace(t1.blip_doc_flg,chr(13),''),chr(10),'') as blip_doc_flg
,replace(replace(t1.open_acct_sucs_flg,chr(13),''),chr(10),'') as open_acct_sucs_flg
,replace(replace(t1.netw_vrfction_status_flg,chr(13),''),chr(10),'') as netw_vrfction_status_flg
,replace(replace(t1.crdtc_que_situ_flg,chr(13),''),chr(10),'') as crdtc_que_situ_flg
,replace(replace(t1.main_debit_ps_cert_type_cd,chr(13),''),chr(10),'') as main_debit_ps_cert_type_cd
,replace(replace(t1.main_debit_ps_cert_id,chr(13),''),chr(10),'') as main_debit_ps_cert_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,appl_amt
,crdt_amt
,replace(replace(t1.score_val,chr(13),''),chr(10),'') as score_val
,replace(replace(t1.first_trial_apv_status_cd,chr(13),''),chr(10),'') as first_trial_apv_status_cd
,first_trial_appl_dt
,replace(replace(t1.first_trial_appl_tm,chr(13),''),chr(10),'') as first_trial_appl_tm
,first_trial_end_tm
,final_jud_appl_dt
,replace(replace(t1.final_jud_appl_tm,chr(13),''),chr(10),'') as final_jud_appl_tm
,final_jud_apv_lmt
,replace(replace(t1.final_jud_apv_status_cd,chr(13),''),chr(10),'') as final_jud_apv_status_cd
,replace(replace(t1.apv_opinion,chr(13),''),chr(10),'') as apv_opinion
,replace(replace(t1.apv_concus,chr(13),''),chr(10),'') as apv_concus
,final_jud_end_tm
,replace(replace(t1.refuse_rs,chr(13),''),chr(10),'') as refuse_rs
,espec_loan_flg
,replace(replace(t1.tax_num,chr(13),''),chr(10),'') as tax_num
,replace(replace(t1.housing_cnt_cd,chr(13),''),chr(10),'') as housing_cnt_cd
,house_first_pay_amt
,house_tot_price
,replace(replace(t1.fir_buy_flg,chr(13),''),chr(10),'') as fir_buy_flg
,house_arch_area
,house_first_pay_ratio
,loan_ratio
,estim_price
,idtfy_price
,replace(replace(t1.acct_flg,chr(13),''),chr(10),'') as acct_flg
,replace(replace(t1.crdt_lmt_use_flg,chr(13),''),chr(10),'') as crdt_lmt_use_flg
,replace(replace(t1.camp_chn_id,chr(13),''),chr(10),'') as camp_chn_id
,replace(replace(t1.camp_corp_id,chr(13),''),chr(10),'') as camp_corp_id
,replace(replace(t1.camp_corp_name,chr(13),''),chr(10),'') as camp_corp_name
,replace(replace(t1.camp_chn_name,chr(13),''),chr(10),'') as camp_chn_name
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.enter_clear_bk_no,chr(13),''),chr(10),'') as enter_clear_bk_no
,replace(replace(t1.loan_usage_subclass_cd,chr(13),''),chr(10),'') as loan_usage_subclass_cd

from ${icl_schema}.cmm_retl_loan_appl_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_retl_loan_appl_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
