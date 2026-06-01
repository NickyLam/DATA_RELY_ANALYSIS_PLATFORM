: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tbnd_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_tbnd.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,replace(replace(t1.sh_code,chr(13),''),chr(10),'') as sh_code
,replace(replace(t1.sz_code,chr(13),''),chr(10),'') as sz_code
,replace(replace(t1.yh_code,chr(13),''),chr(10),'') as yh_code
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.country,chr(13),''),chr(10),'') as country
,replace(replace(t1.q_type,chr(13),''),chr(10),'') as q_type
,replace(replace(t1.b_name,chr(13),''),chr(10),'') as b_name
,replace(replace(t1.p_type,chr(13),''),chr(10),'') as p_type
,replace(replace(t1.p_class,chr(13),''),chr(10),'') as p_class
,t1.b_par_value as b_par_value
,t1.b_issue_price as b_issue_price
,replace(replace(t1.b_issue_date,chr(13),''),chr(10),'') as b_issue_date
,replace(replace(t1.b_list_date,chr(13),''),chr(10),'') as b_list_date
,replace(replace(t1.b_start_date,chr(13),''),chr(10),'') as b_start_date
,replace(replace(t1.b_mtr_date,chr(13),''),chr(10),'') as b_mtr_date
,replace(replace(t1.b_term,chr(13),''),chr(10),'') as b_term
,replace(replace(t1.b_daycount,chr(13),''),chr(10),'') as b_daycount
,replace(replace(t1.i_code_bench,chr(13),''),chr(10),'') as i_code_bench
,replace(replace(t1.a_type_bench,chr(13),''),chr(10),'') as a_type_bench
,replace(replace(t1.m_type_bench,chr(13),''),chr(10),'') as m_type_bench
,replace(replace(t1.b_issue_mode,chr(13),''),chr(10),'') as b_issue_mode
,replace(replace(t1.b_coupon_type,chr(13),''),chr(10),'') as b_coupon_type
,t1.b_cash_times as b_cash_times
,replace(replace(t1.b_embopt_type,chr(13),''),chr(10),'') as b_embopt_type
,replace(replace(t1.b_amortizing,chr(13),''),chr(10),'') as b_amortizing
,replace(replace(t1.b_as_type,chr(13),''),chr(10),'') as b_as_type
,replace(replace(t1.b_issuer,chr(13),''),chr(10),'') as b_issuer
,replace(replace(t1.b_warrantor,chr(13),''),chr(10),'') as b_warrantor
,replace(replace(t1.b_seniority,chr(13),''),chr(10),'') as b_seniority
,replace(replace(t1.b_fpml,chr(13),''),chr(10),'') as b_fpml
,t1.b_coupon as b_coupon
,replace(replace(t1.b_name_full,chr(13),''),chr(10),'') as b_name_full
,replace(replace(t1.b_actual_mtr_date,chr(13),''),chr(10),'') as b_actual_mtr_date
,replace(replace(t1.d_code,chr(13),''),chr(10),'') as d_code
,replace(replace(t1.b_p_class,chr(13),''),chr(10),'') as b_p_class
,t1.b_actual_issue_amount as b_actual_issue_amount
,replace(replace(t1.chinesespell,chr(13),''),chr(10),'') as chinesespell
,t1.b_coupon_prec as b_coupon_prec
,replace(replace(t1.host_market,chr(13),''),chr(10),'') as host_market
,replace(replace(t1.bj_market,chr(13),''),chr(10),'') as bj_market
,t1.issuer_id as issuer_id
,t1.warrantor_id as warrantor_id
,t1.is_delete as is_delete
,t1.usable_flag as usable_flag
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,replace(replace(t1.account_user,chr(13),''),chr(10),'') as account_user
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.account_time,chr(13),''),chr(10),'') as account_time
,replace(replace(t1.imp_date,chr(13),''),chr(10),'') as imp_date
,replace(replace(t1.imp_time,chr(13),''),chr(10),'') as imp_time
,t1.pipe_id as pipe_id
,replace(replace(t1.b_fst_pay_date,chr(13),''),chr(10),'') as b_fst_pay_date
,replace(replace(t1.b_fst_reg_calc_start_date,chr(13),''),chr(10),'') as b_fst_reg_calc_start_date
,replace(replace(t1.b_initial_fixing_date,chr(13),''),chr(10),'') as b_initial_fixing_date
,replace(replace(t1.b_pay_freq,chr(13),''),chr(10),'') as b_pay_freq
,replace(replace(t1.b_pay_bizday_convertion,chr(13),''),chr(10),'') as b_pay_bizday_convertion
,replace(replace(t1.b_calc_freq,chr(13),''),chr(10),'') as b_calc_freq
,replace(replace(t1.b_calc_bizday_convertion,chr(13),''),chr(10),'') as b_calc_bizday_convertion
,replace(replace(t1.b_reset_freq,chr(13),''),chr(10),'') as b_reset_freq
,replace(replace(t1.b_reset_bizday_convertion,chr(13),''),chr(10),'') as b_reset_bizday_convertion
,replace(replace(t1.b_fixing_dates_offset,chr(13),''),chr(10),'') as b_fixing_dates_offset
,replace(replace(t1.b_fixing_bizday_convertion,chr(13),''),chr(10),'') as b_fixing_bizday_convertion
,t1.b_fixing_precision as b_fixing_precision
,t1.b_initial_rate as b_initial_rate
,t1.b_multiplier as b_multiplier
,t1.b_cap_rate as b_cap_rate
,t1.b_floor_rate as b_floor_rate
,replace(replace(t1.b_exercise_style,chr(13),''),chr(10),'') as b_exercise_style
,replace(replace(t1.b_exercise_date,chr(13),''),chr(10),'') as b_exercise_date
,t1.b_strike_price as b_strike_price
,t1.b_compensation_rate as b_compensation_rate
,replace(replace(t1.p_class_act,chr(13),''),chr(10),'') as p_class_act
,replace(replace(t1.b_issuer_code,chr(13),''),chr(10),'') as b_issuer_code
,replace(replace(t1.special_desc,chr(13),''),chr(10),'') as special_desc
,t1.b_actual_amount_rate as b_actual_amount_rate
,replace(replace(t1.trustenhancing_type,chr(13),''),chr(10),'') as trustenhancing_type
,replace(replace(t1.b_issue_list_date,chr(13),''),chr(10),'') as b_issue_list_date
,t1.issue_feerate as issue_feerate
,replace(replace(t1.underwriting_type,chr(13),''),chr(10),'') as underwriting_type
,replace(replace(t1.b_extend_type,chr(13),''),chr(10),'') as b_extend_type
,replace(replace(t1.s_type,chr(13),''),chr(10),'') as s_type
,replace(replace(t1.p_class_dv,chr(13),''),chr(10),'') as p_class_dv
,replace(replace(t1.p_class_ccdc,chr(13),''),chr(10),'') as p_class_ccdc
,t1.q_par_value as q_par_value
,replace(replace(t1.confirm_term,chr(13),''),chr(10),'') as confirm_term
,replace(replace(t1.sec_code,chr(13),''),chr(10),'') as sec_code
,replace(replace(t1.public_issue,chr(13),''),chr(10),'') as public_issue
,replace(replace(t1.b_user_mtr_date,chr(13),''),chr(10),'') as b_user_mtr_date
,replace(replace(t1.ai_daycount,chr(13),''),chr(10),'') as ai_daycount
,replace(replace(t1.ytm_daycount,chr(13),''),chr(10),'') as ytm_daycount
,replace(replace(t1.b_early_mtr_date,chr(13),''),chr(10),'') as b_early_mtr_date
,replace(replace(t1.manage_mode,chr(13),''),chr(10),'') as manage_mode
,replace(replace(t1.bond_nature,chr(13),''),chr(10),'') as bond_nature
,replace(replace(t1.is_city_investment,chr(13),''),chr(10),'') as is_city_investment
,replace(replace(t1.perpetual,chr(13),''),chr(10),'') as perpetual
,replace(replace(t1.legal_mtr_date,chr(13),''),chr(10),'') as legal_mtr_date
,t1.b_plan_issue_amount as b_plan_issue_amount
,replace(replace(t1.is_default,chr(13),''),chr(10),'') as is_default
,replace(replace(t1.cf_daycount,chr(13),''),chr(10),'') as cf_daycount
,replace(replace(t1.ai_daycount_back,chr(13),''),chr(10),'') as ai_daycount_back
,replace(replace(t1.ytm_daycount_back,chr(13),''),chr(10),'') as ytm_daycount_back
,replace(replace(t1.cf_daycount_back,chr(13),''),chr(10),'') as cf_daycount_back
,t1.is_temp as is_temp
,replace(replace(t1.b_ext_rating,chr(13),''),chr(10),'') as b_ext_rating
,replace(replace(t1.b_ext_rating_institution,chr(13),''),chr(10),'') as b_ext_rating_institution
,replace(replace(t1.b_issuer_ext_rating,chr(13),''),chr(10),'') as b_issuer_ext_rating
,replace(replace(t1.b_issuer_ext_r_institution,chr(13),''),chr(10),'') as b_issuer_ext_r_institution
,replace(replace(t1.b_fst_ext_rating,chr(13),''),chr(10),'') as b_fst_ext_rating
,replace(replace(t1.b_fst_ext_rating_inst,chr(13),''),chr(10),'') as b_fst_ext_rating_inst
,replace(replace(t1.b_fst_issuer_ext_rating,chr(13),''),chr(10),'') as b_fst_issuer_ext_rating
,replace(replace(t1.b_fst_issuer_ext_r_inst,chr(13),''),chr(10),'') as b_fst_issuer_ext_r_inst
,replace(replace(t1.b_as_asset_type_name,chr(13),''),chr(10),'') as b_as_asset_type_name
,t1.ref_yield as ref_yield
,replace(replace(t1.warrantor_responsibility,chr(13),''),chr(10),'') as warrantor_responsibility
,replace(replace(t1.debts_registration_date,chr(13),''),chr(10),'') as debts_registration_date
,t1.guarantor_rating as guarantor_rating

from ${iol_schema}.ibms_tbnd t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tbnd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
