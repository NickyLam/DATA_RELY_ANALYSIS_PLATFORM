: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_instrument_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_instrument_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(i_code,chr(10),''),chr(13),'') as i_code
,replace(replace(a_type,chr(10),''),chr(13),'') as a_type
,replace(replace(m_type,chr(10),''),chr(13),'') as m_type
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(i_name,chr(10),''),chr(13),'') as i_name
,replace(replace(p_type,chr(10),''),chr(13),'') as p_type
,replace(replace(p_class,chr(10),''),chr(13),'') as p_class
,replace(replace(p_ls,chr(10),''),chr(13),'') as p_ls
,replace(replace(mtr_date,chr(10),''),chr(13),'') as mtr_date
,replace(replace(term,chr(10),''),chr(13),'') as term
,replace(replace(u_i_code,chr(10),''),chr(13),'') as u_i_code
,replace(replace(u_a_type,chr(10),''),chr(13),'') as u_a_type
,replace(replace(u_m_type,chr(10),''),chr(13),'') as u_m_type
,replace(replace(coupon_type,chr(10),''),chr(13),'') as coupon_type
,replace(replace(issue_mode,chr(10),''),chr(13),'') as issue_mode
,replace(replace(payment_freq,chr(10),''),chr(13),'') as payment_freq
,replace(replace(cash_times,chr(10),''),chr(13),'') as cash_times
,replace(replace(seniority,chr(10),''),chr(13),'') as seniority
,replace(replace(party_id,chr(10),''),chr(13),'') as party_id
,replace(replace(chinesespell,chr(10),''),chr(13),'') as chinesespell
,replace(replace(update_user,chr(10),''),chr(13),'') as update_user
,replace(replace(update_time,chr(10),''),chr(13),'') as update_time
,replace(replace(account_user,chr(10),''),chr(13),'') as account_user
,replace(replace(account_time,chr(10),''),chr(13),'') as account_time
,replace(replace(par_value,chr(10),''),chr(13),'') as par_value
,replace(replace(fwd_irc,chr(10),''),chr(13),'') as fwd_irc
,replace(replace(dis_irc,chr(10),''),chr(13),'') as dis_irc
,replace(replace(coupon,chr(10),''),chr(13),'') as coupon
,replace(replace(previous_version_mtr_date,chr(10),''),chr(13),'') as previous_version_mtr_date
,replace(replace(grp_id,chr(10),''),chr(13),'') as grp_id
,replace(replace(term_day,chr(10),''),chr(13),'') as term_day
,replace(replace(remain_term_day,chr(10),''),chr(13),'') as remain_term_day
,replace(replace(issue_volume,chr(10),''),chr(13),'') as issue_volume
,replace(replace(state,chr(10),''),chr(13),'') as state
,replace(replace(i_id,chr(10),''),chr(13),'') as i_id
,replace(replace(start_date,chr(10),''),chr(13),'') as start_date
,replace(replace(weight_limit,chr(10),''),chr(13),'') as weight_limit
,replace(replace(t_path,chr(10),''),chr(13),'') as t_path
,replace(replace(p_class_act,chr(10),''),chr(13),'') as p_class_act
,replace(replace(issuer_id,chr(10),''),chr(13),'') as issuer_id
,replace(replace(warrantor_id,chr(10),''),chr(13),'') as warrantor_id
,replace(replace(issuer_t_path,chr(10),''),chr(13),'') as issuer_t_path
,replace(replace(b_actual_mtr_date,chr(10),''),chr(13),'') as b_actual_mtr_date
,replace(replace(core_acct_code,chr(10),''),chr(13),'') as core_acct_code
,replace(replace(q_currency,chr(10),''),chr(13),'') as q_currency
,replace(replace(is_spv_asset,chr(10),''),chr(13),'') as is_spv_asset
,replace(replace(real_i_code,chr(10),''),chr(13),'') as real_i_code
,replace(replace(principal,chr(10),''),chr(13),'') as principal
,replace(replace(first_payment_date,chr(10),''),chr(13),'') as first_payment_date
,replace(replace(daycount,chr(10),''),chr(13),'') as daycount
,replace(replace(match_code,chr(10),''),chr(13),'') as match_code
,replace(replace(credit_classfy,chr(10),''),chr(13),'') as credit_classfy
,replace(replace(is_using_credit,chr(10),''),chr(13),'') as is_using_credit
,replace(replace(credit_weight,chr(10),''),chr(13),'') as credit_weight
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_ttrd_instrument
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_instrument_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes