: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_out_acct_indv_loan_attach_info_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_loan_out_acct_indv_loan_attach_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lp_id as lp_id
,t1.appl_distr_amt as appl_distr_amt
,t1.risk_mgmt_rest_cd as risk_mgmt_rest_cd
,t1.repay_card_type_cd as repay_card_type_cd
,t1.recver_open_bank_name as recver_open_bank_name
,t1.loan_distr_dt as loan_distr_dt
,t1.loan_perds as loan_perds
,t1.loan_actl_distr_dt as loan_actl_distr_dt
,t1.deflt_repay_day as deflt_repay_day
,t1.loan_termnt_dt as loan_termnt_dt
,t1.input_stamp_tax_flg as input_stamp_tax_flg
,t1.stamp_tax_tax_acct_id as stamp_tax_tax_acct_id
,t1.stamp_tax_acct_name as stamp_tax_acct_name
,t1.stamp_tax_amt as stamp_tax_amt
,t1.open_acct_bind_mobile_no as open_acct_bind_mobile_no
,t1.out_acct_impt_cond_descb as out_acct_impt_cond_descb
,t1.entr_pay_cfm_status_cd as entr_pay_cfm_status_cd
,t1.entr_pay_cfm_tm as entr_pay_cfm_tm
,t1.self_pay_amt as self_pay_amt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.appl_id as appl_id
,t1.out_acct_flow_num as out_acct_flow_num

from ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_out_acct_indv_loan_attach_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
