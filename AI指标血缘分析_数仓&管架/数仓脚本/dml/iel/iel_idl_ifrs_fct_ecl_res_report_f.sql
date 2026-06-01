: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ifrs_fct_ecl_res_report_f
CreateDate: 20250102
FileName:   ${iel_data_path}/ifrs_fct_ecl_res_report.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.d_date_dt as d_date_dt
,t1.n_asset_class_cd as n_asset_class_cd
,t1.v_id_number as v_id_number
,t1.v_cust_cd as v_cust_cd
,t1.v_cust_name as v_cust_name
,t1.v_pd_internal as v_pd_internal
,t1.v_regul_classif_cd as v_regul_classif_cd
,t1.v_internal_rating as v_internal_rating
,t1.v_issuer_rating as v_issuer_rating
,t1.v_obligation_rating as v_obligation_rating
,t1.n_odus_days as n_odus_days
,t1.n_phase_division_cd as n_phase_division_cd
,t1.n_cur as n_cur
,t1.n_int as n_int
,t1.n_slow as n_slow
,t1.n_ead_fin as n_ead_fin
,t1.n_pd as n_pd
,t1.n_lgd_fin as n_lgd_fin
,t1.n_ecl as n_ecl
,t1.v_three_stage_cd as v_three_stage_cd
,t1.v_produck_type_s_cd as v_produck_type_s_cd
,t1.d_acct_open_date as d_acct_open_date
,t1.d_acct_expire_date as d_acct_expire_date
,t1.n_residual_maturity as n_residual_maturity
,t1.n_odue_days_cur as n_odue_days_cur
,t1.n_odue_days_int as n_odue_days_int
,t1.v_sub_cd as v_sub_cd
,t1.v_sub_name as v_sub_name
,t1.v_org_cd as v_org_cd
,t1.v_org_name as v_org_name
,t1.n_ead_fin_before as n_ead_fin_before
,t1.n_ecl_before as n_ecl_before
,t1.v_ccy_cd_before as v_ccy_cd_before
,t1.n_cur_before as n_cur_before
,t1.n_int_before as n_int_before
,t1.n_slow_before as n_slow_before
,t1.v_invest_indust_cd as v_invest_indust_cd
,t1.n_ecl_dcf as n_ecl_dcf
,t1.n_ecl_before_dcf as n_ecl_before_dcf
,t1.v_dfc_ecl_cd as v_dfc_ecl_cd
,t1.rate_fin as rate_fin
,t1.v_financial_id as v_financial_id
,t1.v_bill_no as v_bill_no
,t1.execu_org_no as execu_org_no
,t1.execu_org_name as execu_org_name
,t1.n_pv_variation as n_pv_variation
,t1.n_balance_face as n_balance_face
,t1.n_int_adj_bal as n_int_adj_bal
,t1.n_int_receivable as n_int_receivable
,t1.n_int_accrued as n_int_accrued
,t1.fin_instm_name as fin_instm_name
,t1.guartor_cust_name as guartor_cust_name
,t1.v_value_model_name as v_value_model_name
,t1.n_pv_variation_lastday as n_pv_variation_lastday
,t1.level5_class_cd as level5_class_cd
,t1.v_tx_cust_name as v_tx_cust_name
,t1.v_group_cust_no as v_group_cust_no
,t1.v_group_cust_name as v_group_cust_name
,t1.v_book_val as v_book_val
,t1.v_produck_type_cd as v_produck_type_cd
,t1.asset_type_name as asset_type_name
,t1.v_bond_id as v_bond_id
,t1.intnal_secu_acct_id as intnal_secu_acct_id
,t1.separate_code as separate_code
,t1.tax_ecl as tax_ecl
,t1.tax_ecl_before as tax_ecl_before
,t1.tax_balance as tax_balance
,t1.tax_balance_before as tax_balance_before
,t1.total_ecl as total_ecl
,t1.total_ecl_before as total_ecl_before
,t1.v_pd_mode as v_pd_mode
,t1.law_ecl as law_ecl
,t1.law_ecl_before as law_ecl_before
,t1.law_balance_before as law_balance_before
,t1.law_balance as law_balance
,t1.v_serialno as v_serialno
,t1.recvbl_uncol_int as recvbl_uncol_int
,t1.n_int_receivable_before as n_int_receivable_before
,t1.recvbl_uncol_int_before as recvbl_uncol_int_before
,t1.n_int_accrued_before as n_int_accrued_before
,t1.int_recvbl_ecl as int_recvbl_ecl
,t1.recvbl_uncol_int_ecl as recvbl_uncol_int_ecl
,t1.n_int_accrued_ecl as n_int_accrued_ecl
,t1.n_int_receivable_ecl_before as n_int_receivable_ecl_before
,t1.recvbl_uncol_int_ecl_before as recvbl_uncol_int_ecl_before
,t1.n_int_accrued_ecl_before as n_int_accrued_ecl_before

from ${idl_schema}.ifrs_fct_ecl_res_report t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifrs_fct_ecl_res_report.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
