: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tbnd_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_tbnd_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(i_code,chr(10),''),chr(13),'') as i_code
,replace(replace(a_type,chr(10),''),chr(13),'') as a_type
,replace(replace(m_type,chr(10),''),chr(13),'') as m_type
,replace(replace(sh_code,chr(10),''),chr(13),'') as sh_code
,replace(replace(sz_code,chr(10),''),chr(13),'') as sz_code
,replace(replace(yh_code,chr(10),''),chr(13),'') as yh_code
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(country,chr(10),''),chr(13),'') as country
,replace(replace(q_type,chr(10),''),chr(13),'') as q_type
,replace(replace(b_name,chr(10),''),chr(13),'') as b_name
,replace(replace(p_type,chr(10),''),chr(13),'') as p_type
,replace(replace(p_class,chr(10),''),chr(13),'') as p_class
,replace(replace(b_par_value,chr(10),''),chr(13),'') as b_par_value
,replace(replace(b_issue_price,chr(10),''),chr(13),'') as b_issue_price
,replace(replace(b_issue_date,chr(10),''),chr(13),'') as b_issue_date
,replace(replace(b_list_date,chr(10),''),chr(13),'') as b_list_date
,replace(replace(b_start_date,chr(10),''),chr(13),'') as b_start_date
,replace(replace(b_mtr_date,chr(10),''),chr(13),'') as b_mtr_date
,replace(replace(b_term,chr(10),''),chr(13),'') as b_term
,replace(replace(b_daycount,chr(10),''),chr(13),'') as b_daycount
,replace(replace(i_code_bench,chr(10),''),chr(13),'') as i_code_bench
,replace(replace(a_type_bench,chr(10),''),chr(13),'') as a_type_bench
,replace(replace(m_type_bench,chr(10),''),chr(13),'') as m_type_bench
,replace(replace(b_issue_mode,chr(10),''),chr(13),'') as b_issue_mode
,replace(replace(b_coupon_type,chr(10),''),chr(13),'') as b_coupon_type
,replace(replace(b_cash_times,chr(10),''),chr(13),'') as b_cash_times
,replace(replace(b_embopt_type,chr(10),''),chr(13),'') as b_embopt_type
,replace(replace(b_amortizing,chr(10),''),chr(13),'') as b_amortizing
,replace(replace(b_as_type,chr(10),''),chr(13),'') as b_as_type
,replace(replace(b_issuer,chr(10),''),chr(13),'') as b_issuer
,replace(replace(b_warrantor,chr(10),''),chr(13),'') as b_warrantor
,replace(replace(b_seniority,chr(10),''),chr(13),'') as b_seniority
,replace(replace(substr(b_fpml,1,4000),chr(10),''),chr(13),'') as b_fpml
,replace(replace(b_coupon,chr(10),''),chr(13),'') as b_coupon
,replace(replace(b_name_full,chr(10),''),chr(13),'') as b_name_full
,replace(replace(b_actual_mtr_date,chr(10),''),chr(13),'') as b_actual_mtr_date
,replace(replace(d_code,chr(10),''),chr(13),'') as d_code
,replace(replace(b_p_class,chr(10),''),chr(13),'') as b_p_class
,replace(replace(b_actual_issue_amount,chr(10),''),chr(13),'') as b_actual_issue_amount
,replace(replace(chinesespell,chr(10),''),chr(13),'') as chinesespell
,replace(replace(b_coupon_prec,chr(10),''),chr(13),'') as b_coupon_prec
,replace(replace(host_market,chr(10),''),chr(13),'') as host_market
,replace(replace(bj_market,chr(10),''),chr(13),'') as bj_market
,replace(replace(issuer_id,chr(10),''),chr(13),'') as issuer_id
,replace(replace(warrantor_id,chr(10),''),chr(13),'') as warrantor_id
,replace(replace(is_delete,chr(10),''),chr(13),'') as is_delete
,replace(replace(usable_flag,chr(10),''),chr(13),'') as usable_flag
,replace(replace(memo,chr(10),''),chr(13),'') as memo
,replace(replace(update_user,chr(10),''),chr(13),'') as update_user
,replace(replace(account_user,chr(10),''),chr(13),'') as account_user
,replace(replace(update_time,chr(10),''),chr(13),'') as update_time
,replace(replace(account_time,chr(10),''),chr(13),'') as account_time
,replace(replace(imp_date,chr(10),''),chr(13),'') as imp_date
,replace(replace(imp_time,chr(10),''),chr(13),'') as imp_time
,replace(replace(pipe_id,chr(10),''),chr(13),'') as pipe_id
,replace(replace(b_fst_pay_date,chr(10),''),chr(13),'') as b_fst_pay_date
,replace(replace(b_fst_reg_calc_start_date,chr(10),''),chr(13),'') as b_fst_reg_calc_start_date
,replace(replace(b_initial_fixing_date,chr(10),''),chr(13),'') as b_initial_fixing_date
,replace(replace(b_pay_freq,chr(10),''),chr(13),'') as b_pay_freq
,replace(replace(b_pay_bizday_convertion,chr(10),''),chr(13),'') as b_pay_bizday_convertion
,replace(replace(b_calc_freq,chr(10),''),chr(13),'') as b_calc_freq
,replace(replace(b_calc_bizday_convertion,chr(10),''),chr(13),'') as b_calc_bizday_convertion
,replace(replace(b_reset_freq,chr(10),''),chr(13),'') as b_reset_freq
,replace(replace(b_reset_bizday_convertion,chr(10),''),chr(13),'') as b_reset_bizday_convertion
,replace(replace(b_fixing_dates_offset,chr(10),''),chr(13),'') as b_fixing_dates_offset
,replace(replace(b_fixing_bizday_convertion,chr(10),''),chr(13),'') as b_fixing_bizday_convertion
,replace(replace(b_fixing_precision,chr(10),''),chr(13),'') as b_fixing_precision
,replace(replace(b_initial_rate,chr(10),''),chr(13),'') as b_initial_rate
,replace(replace(b_multiplier,chr(10),''),chr(13),'') as b_multiplier
,replace(replace(b_cap_rate,chr(10),''),chr(13),'') as b_cap_rate
,replace(replace(b_floor_rate,chr(10),''),chr(13),'') as b_floor_rate
,replace(replace(b_exercise_style,chr(10),''),chr(13),'') as b_exercise_style
,replace(replace(b_exercise_date,chr(10),''),chr(13),'') as b_exercise_date
,replace(replace(b_strike_price,chr(10),''),chr(13),'') as b_strike_price
,replace(replace(b_compensation_rate,chr(10),''),chr(13),'') as b_compensation_rate
,replace(replace(p_class_act,chr(10),''),chr(13),'') as p_class_act
,replace(replace(b_issuer_code,chr(10),''),chr(13),'') as b_issuer_code
,replace(replace(special_desc,chr(10),''),chr(13),'') as special_desc
,replace(replace(b_actual_amount_rate,chr(10),''),chr(13),'') as b_actual_amount_rate
,replace(replace(trustenhancing_type,chr(10),''),chr(13),'') as trustenhancing_type
,replace(replace(b_issue_list_date,chr(10),''),chr(13),'') as b_issue_list_date
,replace(replace(issue_feerate,chr(10),''),chr(13),'') as issue_feerate
,replace(replace(underwriting_type,chr(10),''),chr(13),'') as underwriting_type
,replace(replace(b_extend_type,chr(10),''),chr(13),'') as b_extend_type
,replace(replace(s_type,chr(10),''),chr(13),'') as s_type
,replace(replace(p_class_dv,chr(10),''),chr(13),'') as p_class_dv
,replace(replace(p_class_ccdc,chr(10),''),chr(13),'') as p_class_ccdc
,replace(replace(q_par_value,chr(10),''),chr(13),'') as q_par_value
,replace(replace(confirm_term,chr(10),''),chr(13),'') as confirm_term
,replace(replace(sec_code,chr(10),''),chr(13),'') as sec_code
,replace(replace(public_issue,chr(10),''),chr(13),'') as public_issue
,replace(replace(b_user_mtr_date,chr(10),''),chr(13),'') as b_user_mtr_date
,replace(replace(ai_daycount,chr(10),''),chr(13),'') as ai_daycount
,replace(replace(ytm_daycount,chr(10),''),chr(13),'') as ytm_daycount
,replace(replace(b_early_mtr_date,chr(10),''),chr(13),'') as b_early_mtr_date
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_tbnd
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tbnd_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes