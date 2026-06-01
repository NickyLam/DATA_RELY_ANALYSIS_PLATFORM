: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_loan_out_acct_indv_loan_attach_info_h_f
CreateDate: 20250605
FileName:   ${iel_data_path}/agt_loan_out_acct_indv_loan_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,appl_distr_amt
,replace(replace(t1.hqd_centr_out_acct_flg,chr(13),''),chr(10),'') as hqd_centr_out_acct_flg
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
,replace(replace(t1.open_acct_bind_mobile_no,chr(13),''),chr(10),'') as open_acct_bind_mobile_no
,loan_distr_dt
,loan_actl_distr_dt
,replace(replace(t1.entr_pay_cfm_status_cd,chr(13),''),chr(10),'') as entr_pay_cfm_status_cd
,entr_pay_cfm_tm
,replace(replace(t1.entr_pay_acct_num_id,chr(13),''),chr(10),'') as entr_pay_acct_num_id
,self_pay_amt
,replace(replace(t1.pay_indent_id,chr(13),''),chr(10),'') as pay_indent_id
,replace(replace(t1.distr_chn_cd,chr(13),''),chr(10),'') as distr_chn_cd
,distr_dt
,replace(replace(t1.distr_advise_sucs_flg,chr(13),''),chr(10),'') as distr_advise_sucs_flg
,distr_end_dt
,loan_perds
,replace(replace(t1.repay_card_type_cd,chr(13),''),chr(10),'') as repay_card_type_cd
,replace(replace(t1.deflt_repay_day,chr(13),''),chr(10),'') as deflt_repay_day
,loan_termnt_dt
,blon_loan_amort_dt
,replace(replace(t1.input_stamp_tax_flg,chr(13),''),chr(10),'') as input_stamp_tax_flg
,replace(replace(t1.stamp_tax_tax_acct_id,chr(13),''),chr(10),'') as stamp_tax_tax_acct_id
,replace(replace(t1.stamp_tax_acct_name,chr(13),''),chr(10),'') as stamp_tax_acct_name
,stamp_tax_amt
,replace(replace(t1.prod_chn_idf_cd,chr(13),''),chr(10),'') as prod_chn_idf_cd
,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
,replace(replace(t1.file_int_accr_flg,chr(13),''),chr(10),'') as file_int_accr_flg
,replace(replace(t1.due_diligence_flg,chr(13),''),chr(10),'') as due_diligence_flg
,replace(replace(t1.outline_vrif_idti_flg,chr(13),''),chr(10),'') as outline_vrif_idti_flg
,replace(replace(t1.out_acct_impt_cond_descb,chr(13),''),chr(10),'') as out_acct_impt_cond_descb
,replace(replace(t1.risk_mgmt_rest_cd,chr(13),''),chr(10),'') as risk_mgmt_rest_cd
,replace(replace(t1.guar_guar_letter_id,chr(13),''),chr(10),'') as guar_guar_letter_id
,replace(replace(t1.group_cust_flg,chr(13),''),chr(10),'') as group_cust_flg
,replace(replace(t1.group_cust_name,chr(13),''),chr(10),'') as group_cust_name
,replace(replace(t1.group_cust_id,chr(13),''),chr(10),'') as group_cust_id
,group_cust_aval_open_lmt
,replace(replace(t1.brwer_and_group_rela_cd,chr(13),''),chr(10),'') as brwer_and_group_rela_cd

from ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_out_acct_indv_loan_attach_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
