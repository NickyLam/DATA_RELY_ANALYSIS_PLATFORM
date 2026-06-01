: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_rwas_rpt_mr_sa_rwa_result_a
CreateDate: 20250208
FileName:   ${iel_data_path}/rwas_rpt_mr_sa_rwa_result.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,t1.data_date as data_date
,t1.loan_ref_no as loan_ref_no
,t1.loan_ref_desc as loan_ref_desc
,t1.contract_no as contract_no
,t1.src_system_id as src_system_id
,t1.accorg_no as accorg_no
,t1.accorg_name as accorg_name
,t1.five_class_cd as five_class_cd
,t1.five_class_name as five_class_name
,t1.product_cd as product_cd
,t1.product_name as product_name
,t1.bis_product_type_cd as bis_product_type_cd
,t1.bis_product_type_name as bis_product_type_name
,t1.bis_product_btype_cd as bis_product_btype_cd
,t1.bis_product_btype_name as bis_product_btype_name
,t1.buss_type_cd as buss_type_cd
,t1.buss_type_name as buss_type_name
,t1.start_date as start_date
,t1.due_date as due_date
,t1.orig_maturity as orig_maturity
,t1.overdue_days as overdue_days
,t1.std_default_flag as std_default_flag
,t1.book_type_id as book_type_id
,t1.book_type_name as book_type_name
,t1.on_off_id as on_off_id
,t1.bis_ccy_cd as bis_ccy_cd
,t1.bis_ccy_name as bis_ccy_name
,t1.exchange_rate as exchange_rate
,t1.subject_cd as subject_cd
,t1.subject_name as subject_name
,t1.pric_bal_origcurr as pric_bal_origcurr
,t1.pric_bal as pric_bal
,t1.asset_balance as asset_balance
,t1.accrued_subject_cd as accrued_subject_cd
,t1.accrued_subject_name as accrued_subject_name
,t1.accrued_int as accrued_int
,t1.receivable_subject_cd as receivable_subject_cd
,t1.receivable_subject_name as receivable_subject_name
,t1.receivable_int as receivable_int
,t1.accrued_receiv_subject_cd as accrued_receiv_subject_cd
,t1.accrued_receiv_subject_name as accrued_receiv_subject_name
,t1.accrued_receiv_int as accrued_receiv_int
,t1.intadj_subject_cd as intadj_subject_cd
,t1.intadj_subject_name as intadj_subject_name
,t1.int_adj as int_adj
,t1.fairchange_subject_cd as fairchange_subject_cd
,t1.fairchange_subject_name as fairchange_subject_name
,t1.fairvalue_changes as fairvalue_changes
,t1.depreamor_subject_cd as depreamor_subject_cd
,t1.depreamor_subject_name as depreamor_subject_name
,t1.depre_amortizat as depre_amortizat
,t1.other_subject_cd as other_subject_cd
,t1.other_subject_name as other_subject_name
,t1.other_amt as other_amt
,t1.provision_subject_cd as provision_subject_cd
,t1.provision_subject_name as provision_subject_name
,t1.provision as provision
,t1.provesion_ratio as provesion_ratio
,t1.account_classification as account_classification
,t1.cust_no as cust_no
,t1.cust_name as cust_name
,t1.ccp_type_cd as ccp_type_cd
,t1.ccp_type_name as ccp_type_name
,t1.ccp_btype_cd as ccp_btype_cd
,t1.ccp_btype_name as ccp_btype_name
,t1.spe_lending_flag as spe_lending_flag
,t1.spe_lending_type as spe_lending_type
,t1.bis_country_name as bis_country_name
,t1.sov_sp_lt_rating_cd as sov_sp_lt_rating_cd
,t1.cust_sp_lt_rating_cd as cust_sp_lt_rating_cd
,t1.scra_rating as scra_rating
,t1.int_trade_flag as int_trade_flag
,t1.solo_int_trade_flag as solo_int_trade_flag
,t1.investment_cust_flag as investment_cust_flag
,t1.ccy_mismatch_flag as ccy_mismatch_flag
,t1.accept_credit_self_flag as accept_credit_self_flag
,t1.real_estate_type_cd as real_estate_type_cd
,t1.ltv as ltv
,t1.accept_discount_self_flag as accept_discount_self_flag
,t1.operation_pf_flag as operation_pf_flag
,t1.cancel_flag as cancel_flag
,t1.off_asset_unmeasured_flag as off_asset_unmeasured_flag
,t1.unused_prl_tmeet_flag as unused_prl_tmeet_flag
,t1.ead_orig as ead_orig
,t1.ccf as ccf
,t1.ead_afterccf as ead_afterccf
,t1.ead_afterpro as ead_afterpro
,t1.rw as rw
,t1.crm_ccy_mis_flag as crm_ccy_mis_flag
,t1.crm_amt_rmb as crm_amt_rmb
,t1.crm_amt_split as crm_amt_split
,t1.crm_weighting_rw as crm_weighting_rw
,t1.rwa_ucovered as rwa_ucovered
,t1.rwa_covered as rwa_covered
,t1.rwa as rwa
,t1.c_item_e as c_item_e
,t1.c_item_f as c_item_f
,t1.c_item_g as c_item_g
,t1.c_item_h as c_item_h
,t1.c_item_i as c_item_i
,t1.c_item_j as c_item_j
,t1.c_item_k as c_item_k
,t1.c_item_l as c_item_l
,t1.c_item_m as c_item_m
,t1.c_item_n as c_item_n
,t1.c_item_o as c_item_o
,t1.c_item_p as c_item_p
,t1.c_item_q as c_item_q
,t1.c_item_r as c_item_r
,t1.c_item_s as c_item_s
,t1.c_item_t as c_item_t
,t1.c_item_u as c_item_u
,t1.c_item_v as c_item_v
,t1.c_item_w as c_item_w
,t1.c_item_x as c_item_x
,t1.c_item_y as c_item_y
,t1.c_item_z as c_item_z
,t1.report_no as report_no
,t1.report_line_no as report_line_no
,t1.report_line_name as report_line_name
,t1.crm_ccy_mis_coeff as crm_ccy_mis_coeff
,t1.crm_mat_mis_coeff as crm_mat_mis_coeff
,t1.crm_floor_mis_coeff as crm_floor_mis_coeff
,t1.investment_vaild_flag as investment_vaild_flag
,t1.recognition_date as recognition_date
,t1.load_date as load_date

from ${idl_schema}.rwas_rpt_mr_sa_rwa_result t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rwas_rpt_mr_sa_rwa_result.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
