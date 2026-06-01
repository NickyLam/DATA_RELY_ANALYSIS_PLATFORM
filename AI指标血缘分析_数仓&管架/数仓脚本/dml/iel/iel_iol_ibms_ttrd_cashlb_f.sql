: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_cashlb_f
CreateDate: 20221121
FileName:   ${iel_data_path}/ibms_ttrd_cashlb.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.country,chr(13),''),chr(10),'') as country
,replace(replace(t1.q_type,chr(13),''),chr(10),'') as q_type
,replace(replace(t1.i_name,chr(13),''),chr(10),'') as i_name
,replace(replace(t1.p_class,chr(13),''),chr(10),'') as p_class
,par_value
,coupon
,replace(replace(t1.start_date,chr(13),''),chr(10),'') as start_date
,replace(replace(t1.mtr_date,chr(13),''),chr(10),'') as mtr_date
,replace(replace(t1.term,chr(13),''),chr(10),'') as term
,replace(replace(t1.daycount,chr(13),''),chr(10),'') as daycount
,replace(replace(t1.i_code_bench,chr(13),''),chr(10),'') as i_code_bench
,replace(replace(t1.a_type_bench,chr(13),''),chr(10),'') as a_type_bench
,replace(replace(t1.m_type_bench,chr(13),''),chr(10),'') as m_type_bench
,issue_mode
,coupon_type
,replace(replace(t1.payment_freq,chr(13),''),chr(10),'') as payment_freq
,replace(replace(t1.payment_conv,chr(13),''),chr(10),'') as payment_conv
,replace(replace(t1.first_regular_start_date,chr(13),''),chr(10),'') as first_regular_start_date
,replace(replace(t1.fixing_date_offset,chr(13),''),chr(10),'') as fixing_date_offset
,replace(replace(t1.fixing_date_conv,chr(13),''),chr(10),'') as fixing_date_conv
,replace(replace(t1.reset_freq,chr(13),''),chr(10),'') as reset_freq
,replace(replace(t1.reset_conv,chr(13),''),chr(10),'') as reset_conv
,initial_rate
,cap_rate
,replace(replace(t1.issuer,chr(13),''),chr(10),'') as issuer
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.fpml,chr(13),''),chr(10),'') as fpml
,replace(replace(t1.imp_time,chr(13),''),chr(10),'') as imp_time
,replace(replace(t1.chinesespell,chr(13),''),chr(10),'') as chinesespell
,is_delete
,floor_rate
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.account_user,chr(13),''),chr(10),'') as account_user
,replace(replace(t1.account_time,chr(13),''),chr(10),'') as account_time
,replace(replace(t1.initial_fixing_date,chr(13),''),chr(10),'') as initial_fixing_date
,replace(replace(t1.first_payment_date,chr(13),''),chr(10),'') as first_payment_date
,party_id
,rate_multi
,overdue_rate
,volume
,replace(replace(t1.mtr_mode,chr(13),''),chr(10),'') as mtr_mode
,replace(replace(t1.ver_id,chr(13),''),chr(10),'') as ver_id
,replace(replace(t1.beg_date,chr(13),''),chr(10),'') as beg_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.fstsettype,chr(13),''),chr(10),'') as fstsettype
,replace(replace(t1.endsettype,chr(13),''),chr(10),'') as endsettype
,fst_set_amount
,mtr_set_amount
,replace(replace(t1.p_type,chr(13),''),chr(10),'') as p_type
,issue_price
,replace(replace(t1.settled_interest,chr(13),''),chr(10),'') as settled_interest
,issuer_id
,usable_flag
,replace(replace(t1.payment_date_offset,chr(13),''),chr(10),'') as payment_date_offset
,replace(replace(t1.sell_department,chr(13),''),chr(10),'') as sell_department
,replace(replace(t1.repo_trade_variety,chr(13),''),chr(10),'') as repo_trade_variety
,acct_id
,replace(replace(t1.auto_redepo,chr(13),''),chr(10),'') as auto_redepo
,replace(replace(t1.repo_term,chr(13),''),chr(10),'') as repo_term
,replace(replace(t1.stub_period_type,chr(13),''),chr(10),'') as stub_period_type
,replace(replace(t1.m_i_code,chr(13),''),chr(10),'') as m_i_code
,replace(replace(t1.m_a_type,chr(13),''),chr(10),'') as m_a_type
,replace(replace(t1.m_m_type,chr(13),''),chr(10),'') as m_m_type
,head_coupon
,replace(replace(t1.payment,chr(13),''),chr(10),'') as payment
,replace(replace(t1.credit_promotion_way,chr(13),''),chr(10),'') as credit_promotion_way
,i_id
,replace(replace(t1.cash_date,chr(13),''),chr(10),'') as cash_date
,replace(replace(t1.ishisdata,chr(13),''),chr(10),'') as ishisdata
,replace(replace(t1.s_type,chr(13),''),chr(10),'') as s_type
,replace(replace(t1.host_market,chr(13),''),chr(10),'') as host_market
,replace(replace(t1.autoredepo,chr(13),''),chr(10),'') as autoredepo
,scale
,replace(replace(t1.final_stub,chr(13),''),chr(10),'') as final_stub
,replace(replace(t1.u_m_type,chr(13),''),chr(10),'') as u_m_type
,replace(replace(t1.u_a_type,chr(13),''),chr(10),'') as u_a_type
,replace(replace(t1.u_i_code,chr(13),''),chr(10),'') as u_i_code
,replace(replace(t1.is_occupy_bottom_credit,chr(13),''),chr(10),'') as is_occupy_bottom_credit
,credit_id
,replace(replace(t1.interest_type,chr(13),''),chr(10),'') as interest_type
,replace(replace(t1.term_spd,chr(13),''),chr(10),'') as term_spd
,replace(replace(t1.p_start_date,chr(13),''),chr(10),'') as p_start_date
,replace(replace(t1.p_mtr_date,chr(13),''),chr(10),'') as p_mtr_date
,replace(replace(t1.calcconv,chr(13),''),chr(10),'') as calcconv
,replace(replace(t1.cashing_date,chr(13),''),chr(10),'') as cashing_date
,replace(replace(t1.cashing_speed,chr(13),''),chr(10),'') as cashing_speed
,replace(replace(t1.match_code,chr(13),''),chr(10),'') as match_code
,replace(replace(t1.p_i_code,chr(13),''),chr(10),'') as p_i_code
,replace(replace(t1.special_type,chr(13),''),chr(10),'') as special_type
,weighted_coupon
,replace(replace(t1.und_asset_type,chr(13),''),chr(10),'') as und_asset_type
,replace(replace(t1.inv_order_id,chr(13),''),chr(10),'') as inv_order_id
,replace(replace(t1.guarantee_way,chr(13),''),chr(10),'') as guarantee_way
,replace(replace(t1.guarantee_infor,chr(13),''),chr(10),'') as guarantee_infor
,replace(replace(t1.actual_mtr_date,chr(13),''),chr(10),'') as actual_mtr_date
,replace(replace(t1.pre_actual_mtr_date,chr(13),''),chr(10),'') as pre_actual_mtr_date
,total_ai
,replace(replace(t1.p_status,chr(13),''),chr(10),'') as p_status
,draw_advance_rate
,post_interest_rate
,is_open_letter
,grace_day
,credit_amount
,replace(replace(t1.extordid,chr(13),''),chr(10),'') as extordid
,replace(replace(t1.is_auto_calculate,chr(13),''),chr(10),'') as is_auto_calculate
,nominal_rate
,added_rate
,slotting_addrate
,slotting_rate
,replace(replace(t1.slotting_daycounter,chr(13),''),chr(10),'') as slotting_daycounter
,trustee_rate
,replace(replace(t1.trustee_daycounter,chr(13),''),chr(10),'') as trustee_daycounter
,other_rate
,replace(replace(t1.other_daycounter,chr(13),''),chr(10),'') as other_daycounter
,replace(replace(t1.nominal_daycounter,chr(13),''),chr(10),'') as nominal_daycounter
,credit_weight
,replace(replace(t1.reply_code,chr(13),''),chr(10),'') as reply_code
,record_rate
,replace(replace(t1.accounting_type,chr(13),''),chr(10),'') as accounting_type
,replace(replace(t1.product_rate,chr(13),''),chr(10),'') as product_rate
,replace(replace(t1.rate_institution,chr(13),''),chr(10),'') as rate_institution
,replace(replace(t1.is_guaranteed,chr(13),''),chr(10),'') as is_guaranteed
,replace(replace(t1.expect_take_day,chr(13),''),chr(10),'') as expect_take_day
,replace(replace(t1.bank_group_code,chr(13),''),chr(10),'') as bank_group_code
,coupon_prec
,replace(replace(t1.apr_txn,chr(13),''),chr(10),'') as apr_txn
,fee_rate
,handlingchargetotal
,replace(replace(t1.usufruct_mtr_date,chr(13),''),chr(10),'') as usufruct_mtr_date
,shibor_coupon
,replace(replace(t1.shibor_i_code,chr(13),''),chr(10),'') as shibor_i_code
,replace(replace(t1.shibor_a_type,chr(13),''),chr(10),'') as shibor_a_type
,replace(replace(t1.shibor_m_type,chr(13),''),chr(10),'') as shibor_m_type
,replace(replace(t1.paymentinfo_type,chr(13),''),chr(10),'') as paymentinfo_type
,etl_timestamp

from ${iol_schema}.ibms_ttrd_cashlb t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_cashlb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
