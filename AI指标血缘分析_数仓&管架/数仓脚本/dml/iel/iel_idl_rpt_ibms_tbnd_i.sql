: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_ibms_tbnd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_ibms_tbnd.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select t1.ETL_DT
,t1.i_code
,t1.a_type
,t1.m_type
,t1.sh_code
,t1.sz_code
,t1.yh_code
,t1.currency
,t1.country
,t1.q_type
,t1.b_name
,t1.p_type
,t1.p_class
,t1.b_par_value
,t1.b_issue_price
,t1.b_issue_date
,t1.b_list_date
,t1.b_start_date
,t1.b_mtr_date
,t1.b_term
,t1.b_daycount
,t1.i_code_bench
,t1.a_type_bench
,t1.m_type_bench
,t1.b_issue_mode
,t1.b_coupon_type
,t1.b_cash_times
,t1.b_embopt_type
,t1.b_amortizing
,t1.b_as_type
,t1.b_issuer
,t1.b_warrantor
,t1.b_seniority
,t1.b_fpml
,t1.b_coupon
,t1.b_name_full
,t1.b_actual_mtr_date
,t1.d_code
,t1.b_p_class
,t1.b_actual_issue_amount
,t1.chinesespell
,t1.b_coupon_prec
,t1.host_market
,t1.bj_market
,t1.issuer_id
,t1.warrantor_id
,t1.is_delete
,t1.usable_flag
,t1.memo
,t1.update_user
,t1.account_user
,t1.update_time
,t1.account_time
,t1.imp_date
,t1.imp_time
,t1.pipe_id
,t1.b_fst_pay_date
,t1.b_fst_reg_calc_start_date
,t1.b_initial_fixing_date
,t1.b_pay_freq
,t1.b_pay_bizday_convertion
,t1.b_calc_freq
,t1.b_calc_bizday_convertion
,t1.b_reset_freq
,t1.b_reset_bizday_convertion
,t1.b_fixing_dates_offset
,t1.b_fixing_bizday_convertion
,t1.b_fixing_precision
,t1.b_initial_rate
,t1.b_multiplier
,t1.b_cap_rate
,t1.b_floor_rate
,t1.b_exercise_style
,t1.b_exercise_date
,t1.b_strike_price
,t1.b_compensation_rate
,t1.p_class_act
,t1.b_issuer_code
,t1.special_desc
,t1.b_actual_amount_rate
,t1.trustenhancing_type
,t1.b_issue_list_date
,t1.issue_feerate
,t1.underwriting_type
,t1.b_extend_type
,t1.s_type
,t1.p_class_dv
,t1.p_class_ccdc
,t1.q_par_value
,t1.confirm_term
,t1.sec_code
,t1.public_issue
,t1.b_user_mtr_date
,t1.ai_daycount
,t1.ytm_daycount
,t1.b_early_mtr_date
,t1.manage_mode
,t1.bond_nature
,t1.is_city_investment
,t1.perpetual
,t1.legal_mtr_date
,t1.b_plan_issue_amount
,t1.is_default
,t1.cf_daycount
,t1.ai_daycount_back
,t1.ytm_daycount_back
,t1.cf_daycount_back
,t1.warrantor_responsibility
,t1.START_DT
,t1.END_DT
,t1.ID_MARK
from ${idl_schema}.rpt_ibms_tbnd t1 
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_ibms_tbnd.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes