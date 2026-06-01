: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_instrument_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_ttrd_instrument.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.i_name,chr(13),''),chr(10),'') as i_name
,replace(replace(t1.p_type,chr(13),''),chr(10),'') as p_type
,replace(replace(t1.p_class,chr(13),''),chr(10),'') as p_class
,replace(replace(t1.p_ls,chr(13),''),chr(10),'') as p_ls
,replace(replace(t1.mtr_date,chr(13),''),chr(10),'') as mtr_date
,replace(replace(t1.term,chr(13),''),chr(10),'') as term
,replace(replace(t1.u_i_code,chr(13),''),chr(10),'') as u_i_code
,replace(replace(t1.u_a_type,chr(13),''),chr(10),'') as u_a_type
,replace(replace(t1.u_m_type,chr(13),''),chr(10),'') as u_m_type
,t1.coupon_type as coupon_type
,t1.issue_mode as issue_mode
,replace(replace(t1.payment_freq,chr(13),''),chr(10),'') as payment_freq
,t1.cash_times as cash_times
,replace(replace(t1.seniority,chr(13),''),chr(10),'') as seniority
,t1.party_id as party_id
,replace(replace(t1.chinesespell,chr(13),''),chr(10),'') as chinesespell
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.account_user,chr(13),''),chr(10),'') as account_user
,replace(replace(t1.account_time,chr(13),''),chr(10),'') as account_time
,t1.par_value as par_value
,replace(replace(t1.fwd_irc,chr(13),''),chr(10),'') as fwd_irc
,replace(replace(t1.dis_irc,chr(13),''),chr(10),'') as dis_irc
,t1.coupon as coupon
,replace(replace(t1.previous_version_mtr_date,chr(13),''),chr(10),'') as previous_version_mtr_date
,replace(replace(t1.grp_id,chr(13),''),chr(10),'') as grp_id
,t1.term_day as term_day
,t1.remain_term_day as remain_term_day
,t1.issue_volume as issue_volume
,replace(replace(t1.state,chr(13),''),chr(10),'') as state
,t1.i_id as i_id
,replace(replace(t1.start_date,chr(13),''),chr(10),'') as start_date
,t1.weight_limit as weight_limit
,replace(replace(t1.t_path,chr(13),''),chr(10),'') as t_path
,replace(replace(t1.p_class_act,chr(13),''),chr(10),'') as p_class_act
,t1.issuer_id as issuer_id
,t1.warrantor_id as warrantor_id
,replace(replace(t1.issuer_t_path,chr(13),''),chr(10),'') as issuer_t_path
,replace(replace(t1.b_actual_mtr_date,chr(13),''),chr(10),'') as b_actual_mtr_date
,replace(replace(t1.core_acct_code,chr(13),''),chr(10),'') as core_acct_code
,replace(replace(t1.q_currency,chr(13),''),chr(10),'') as q_currency
,replace(replace(t1.is_spv_asset,chr(13),''),chr(10),'') as is_spv_asset
,replace(replace(t1.real_i_code,chr(13),''),chr(10),'') as real_i_code
,t1.principal as principal
,replace(replace(t1.first_payment_date,chr(13),''),chr(10),'') as first_payment_date
,replace(replace(t1.daycount,chr(13),''),chr(10),'') as daycount
,replace(replace(t1.match_code,chr(13),''),chr(10),'') as match_code
,replace(replace(t1.credit_classfy,chr(13),''),chr(10),'') as credit_classfy
,replace(replace(t1.is_using_credit,chr(13),''),chr(10),'') as is_using_credit
,t1.credit_weight as credit_weight
,replace(replace(t1.apr_txn,chr(13),''),chr(10),'') as apr_txn
,replace(replace(t1.reply_code,chr(13),''),chr(10),'') as reply_code
,replace(replace(t1.acting_code,chr(13),''),chr(10),'') as acting_code
,replace(replace(t1.prod_code,chr(13),''),chr(10),'') as prod_code
,replace(replace(t1.tax_code,chr(13),''),chr(10),'') as tax_code
,replace(replace(t1.charge_item,chr(13),''),chr(10),'') as charge_item
,replace(replace(t1.fee_number,chr(13),''),chr(10),'') as fee_number

from ${iol_schema}.ibms_ttrd_instrument t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_instrument.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
