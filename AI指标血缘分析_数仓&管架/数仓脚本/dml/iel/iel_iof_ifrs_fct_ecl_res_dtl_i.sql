: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ifrs_fct_ecl_res_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ifrs_fct_ecl_res_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.d_date_dt as d_date_dt
,t1.n_asset_class_cd as n_asset_class_cd
,replace(replace(t1.v_id_number,chr(13),''),chr(10),'') as v_id_number
,replace(replace(t1.v_cust_cd,chr(13),''),chr(10),'') as v_cust_cd
,replace(replace(t1.v_cust_name,chr(13),''),chr(10),'') as v_cust_name
,replace(replace(t1.v_pd_internal,chr(13),''),chr(10),'') as v_pd_internal
,replace(replace(t1.v_regul_classif_cd,chr(13),''),chr(10),'') as v_regul_classif_cd
,replace(replace(t1.v_internal_rating,chr(13),''),chr(10),'') as v_internal_rating
,replace(replace(t1.v_issuer_rating,chr(13),''),chr(10),'') as v_issuer_rating
,replace(replace(t1.v_obligation_rating,chr(13),''),chr(10),'') as v_obligation_rating
,t1.n_odus_days as n_odus_days
,t1.n_phase_division_cd as n_phase_division_cd
,t1.n_cur as n_cur
,t1.n_int as n_int
,t1.n_slow as n_slow
,t1.n_ead_fin as n_ead_fin
,t1.n_pd as n_pd
,t1.n_lgd_fin as n_lgd_fin
,t1.n_ecl as n_ecl
,replace(replace(t1.v_three_stage_cd,chr(13),''),chr(10),'') as v_three_stage_cd
,replace(replace(t1.v_produck_type_cd,chr(13),''),chr(10),'') as v_produck_type_cd
,replace(replace(t1.v_produck_type_s_cd,chr(13),''),chr(10),'') as v_produck_type_s_cd
,replace(replace(t1.v_ccy_cd,chr(13),''),chr(10),'') as v_ccy_cd
,t1.d_acct_open_date as d_acct_open_date
,t1.d_acct_expire_date as d_acct_expire_date
,t1.n_residual_maturity as n_residual_maturity
,t1.n_odue_days_cur as n_odue_days_cur
,t1.n_odue_days_int as n_odue_days_int
,replace(replace(t1.v_blick,chr(13),''),chr(10),'') as v_blick
,replace(replace(t1.v_sub_cd,chr(13),''),chr(10),'') as v_sub_cd
,replace(replace(t1.v_sub_name,chr(13),''),chr(10),'') as v_sub_name
,replace(replace(t1.v_org_cd,chr(13),''),chr(10),'') as v_org_cd
,replace(replace(t1.v_org_name,chr(13),''),chr(10),'') as v_org_name
,t1.before_adjustment_coefficient as before_adjustment_coefficient
,t1.before_n_adjustment_ecl as before_n_adjustment_ecl
,t1.n_ead_fin_before as n_ead_fin_before
,t1.n_ecl_before as n_ecl_before
,replace(replace(t1.v_ccy_cd_before,chr(13),''),chr(10),'') as v_ccy_cd_before
,t1.n_cur_before as n_cur_before
,t1.n_int_before as n_int_before
,t1.n_slow_before as n_slow_before
,replace(replace(t1.v_around_sign,chr(13),''),chr(10),'') as v_around_sign
,replace(replace(t1.v_invest_indust_cd,chr(13),''),chr(10),'') as v_invest_indust_cd
,t1.n_lgd_before as n_lgd_before
,replace(replace(t1.v_account_ageing,chr(13),''),chr(10),'') as v_account_ageing
,replace(replace(t1.v_dfc_ecl_cd,chr(13),''),chr(10),'') as v_dfc_ecl_cd
,replace(replace(t1.industry_name,chr(13),''),chr(10),'') as industry_name
,t1.n_ecl_dcf as n_ecl_dcf
,t1.n_ecl_before_dcf as n_ecl_before_dcf
,replace(replace(t1.issue_bank_cn_name,chr(13),''),chr(10),'') as issue_bank_cn_name
,replace(replace(t1.rate_fin,chr(13),''),chr(10),'') as rate_fin
,replace(replace(t1.v_financial_id,chr(13),''),chr(10),'') as v_financial_id
,replace(replace(t1.v_bond_id,chr(13),''),chr(10),'') as v_bond_id
,replace(replace(t1.v_forecast_mod,chr(13),''),chr(10),'') as v_forecast_mod
,replace(replace(t1.v_bill_no,chr(13),''),chr(10),'') as v_bill_no
,replace(replace(t1.execu_org_no,chr(13),''),chr(10),'') as execu_org_no
,replace(replace(t1.execu_org_name,chr(13),''),chr(10),'') as execu_org_name
,t1.n_pv_variation as n_pv_variation
,t1.n_balance_face as n_balance_face
,t1.n_int_adj_bal as n_int_adj_bal
,t1.n_int_receivable as n_int_receivable
,t1.n_int_accrued as n_int_accrued
,replace(replace(t1.fin_instm_name,chr(13),''),chr(10),'') as fin_instm_name
,replace(replace(t1.asset_type_name,chr(13),''),chr(10),'') as asset_type_name
,replace(replace(t1.guartor_cust_name,chr(13),''),chr(10),'') as guartor_cust_name
,replace(replace(t1.v_value_model_name,chr(13),''),chr(10),'') as v_value_model_name
,t1.pv_variation as pv_variation
,replace(replace(t1.intnal_secu_acct_id,chr(13),''),chr(10),'') as intnal_secu_acct_id
,t1.n_pv_variation_lastday as n_pv_variation_lastday
,t1.pv_variation_lastday as pv_variation_lastday
,replace(replace(t1.v_serialno,chr(13),''),chr(10),'') as v_serialno
,replace(replace(t1.biz_no,chr(13),''),chr(10),'') as biz_no
,replace(replace(t1.level5_class_cd,chr(13),''),chr(10),'') as level5_class_cd
,replace(replace(t1.product_no,chr(13),''),chr(10),'') as product_no
,replace(replace(t1.v_tx_cust_name,chr(13),''),chr(10),'') as v_tx_cust_name
,replace(replace(t1.v_group_cust_no,chr(13),''),chr(10),'') as v_group_cust_no
,replace(replace(t1.v_group_cust_name,chr(13),''),chr(10),'') as v_group_cust_name
,replace(replace(t1.bill_no,chr(13),''),chr(10),'') as bill_no
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
,replace(replace(t1.glob_seq_num,chr(13),''),chr(10),'') as glob_seq_num
,replace(replace(t1.unique_seq_num,chr(13),''),chr(10),'') as unique_seq_num
from ${iol_schema}.ifrs_fct_ecl_res_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifrs_fct_ecl_res_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes