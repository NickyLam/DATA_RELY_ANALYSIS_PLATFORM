: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tbnd_f
CreateDate: 20221105
FileName:   ${iel_data_path}/ibms_tbnd.f.${batch_date}.dat
IF_mark:    f
Logs:
   sundexin
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,i_code
,a_type
,m_type
,sh_code
,sz_code
,yh_code
,currency
,country
,q_type
,b_name
,p_type
,p_class
,b_par_value
,b_issue_price
,b_issue_date
,b_list_date
,b_start_date
,b_mtr_date
,b_term
,b_daycount
,i_code_bench
,a_type_bench
,m_type_bench
,b_issue_mode
,b_coupon_type
,b_cash_times
,b_embopt_type
,b_amortizing
,b_as_type
,b_issuer
,b_warrantor
,b_seniority
,''
,b_coupon
,replace(replace(t.b_name_full,chr(13),''),chr(10),'') as b_name_full
,b_actual_mtr_date
,d_code
,b_p_class
,b_actual_issue_amount
,chinesespell
,b_coupon_prec
,host_market
,bj_market
,issuer_id
,warrantor_id
,is_delete
,usable_flag
,memo
,update_user
,account_user
,update_time
,account_time
,imp_date
,imp_time
,pipe_id
,b_fst_pay_date
,b_fst_reg_calc_start_date
,b_initial_fixing_date
,b_pay_freq
,b_pay_bizday_convertion
,b_calc_freq
,b_calc_bizday_convertion
,b_reset_freq
,b_reset_bizday_convertion
,b_fixing_dates_offset
,b_fixing_bizday_convertion
,b_fixing_precision
,b_initial_rate
,b_multiplier
,b_cap_rate
,b_floor_rate
,b_exercise_style
,b_exercise_date
,b_strike_price
,b_compensation_rate
,p_class_act
,b_issuer_code
,special_desc
,b_actual_amount_rate
,trustenhancing_type
,b_issue_list_date
,issue_feerate
,underwriting_type
,b_extend_type
,s_type
,p_class_dv
,p_class_ccdc
,q_par_value
,confirm_term
,sec_code
,public_issue
,b_user_mtr_date
,ai_daycount
,ytm_daycount
,b_early_mtr_date
,manage_mode
,bond_nature
,is_city_investment
,perpetual
,legal_mtr_date
,b_plan_issue_amount
,is_default
,cf_daycount
,ai_daycount_back
,ytm_daycount_back
,cf_daycount_back
,is_temp
,b_ext_rating
,b_ext_rating_institution
,b_issuer_ext_rating
,b_issuer_ext_r_institution
,b_fst_ext_rating
,b_fst_ext_rating_inst
,b_fst_issuer_ext_rating
,b_fst_issuer_ext_r_inst
,b_as_asset_type_name
,ref_yield
,warrantor_responsibility
,debts_registration_date
,guarantor_rating
,start_dt
,end_dt
,id_mark
from iol.ibms_tbnd t
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tbnd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes