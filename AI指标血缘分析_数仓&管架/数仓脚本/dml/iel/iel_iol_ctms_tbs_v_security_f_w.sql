: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_security_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_security_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(security_code,chr(10),''),chr(13),'') as security_code
,replace(replace(security_name,chr(10),''),chr(13),'') as security_name
,replace(replace(security_type,chr(10),''),chr(13),'') as security_type
,replace(replace(issuer,chr(10),''),chr(13),'') as issuer
,replace(replace(guarantee,chr(10),''),chr(13),'') as guarantee
,replace(replace(ccy,chr(10),''),chr(13),'') as ccy
,replace(replace(int_ccy,chr(10),''),chr(13),'') as int_ccy
,replace(replace(issue_date,chr(10),''),chr(13),'') as issue_date
,replace(replace(start_coupon_date,chr(10),''),chr(13),'') as start_coupon_date
,replace(replace(maturity_date,chr(10),''),chr(13),'') as maturity_date
,replace(replace(lot_size,chr(10),''),chr(13),'') as lot_size
,replace(replace(day_count,chr(10),''),chr(13),'') as day_count
,replace(replace(rate_type,chr(10),''),chr(13),'') as rate_type
,replace(replace(fixed_rate,chr(10),''),chr(13),'') as fixed_rate
,replace(replace(floating_rate,chr(10),''),chr(13),'') as floating_rate
,replace(replace(floating_rate_ind,chr(10),''),chr(13),'') as floating_rate_ind
,replace(replace(floating_spread,chr(10),''),chr(13),'') as floating_spread
,replace(replace(fixing_freq,chr(10),''),chr(13),'') as fixing_freq
,replace(replace(ffixing_date,chr(10),''),chr(13),'') as ffixing_date
,replace(replace(coupon_freq,chr(10),''),chr(13),'') as coupon_freq
,replace(replace(fcoupon_date,chr(10),''),chr(13),'') as fcoupon_date
,replace(replace(payment_freq,chr(10),''),chr(13),'') as payment_freq
,replace(replace(compound_freq,chr(10),''),chr(13),'') as compound_freq
,replace(replace(option_type,chr(10),''),chr(13),'') as option_type
,replace(replace(back_amt,chr(10),''),chr(13),'') as back_amt
,replace(replace(number_issued,chr(10),''),chr(13),'') as number_issued
,replace(replace(aution_rate,chr(10),''),chr(13),'') as aution_rate
,replace(replace(aution_price,chr(10),''),chr(13),'') as aution_price
,replace(replace(first_trade_date,chr(10),''),chr(13),'') as first_trade_date
,replace(replace(market_type,chr(10),''),chr(13),'') as market_type
,replace(replace(repo_ratio,chr(10),''),chr(13),'') as repo_ratio
,replace(replace(security_short_name,chr(10),''),chr(13),'') as security_short_name
,replace(replace(convertable,chr(10),''),chr(13),'') as convertable
,replace(replace(convert_security_code,chr(10),''),chr(13),'') as convert_security_code
,replace(replace(discount_rate,chr(10),''),chr(13),'') as discount_rate
,replace(replace(cap,chr(10),''),chr(13),'') as cap
,replace(replace(floor,chr(10),''),chr(13),'') as floor
,replace(replace(fixing_rate_methoh,chr(10),''),chr(13),'') as fixing_rate_methoh
,replace(replace(note,chr(10),''),chr(13),'') as note
,replace(replace(floating_rate_scale,chr(10),''),chr(13),'') as floating_rate_scale
,replace(replace(stop_trade_date,chr(10),''),chr(13),'') as stop_trade_date
,replace(replace(collateral_id,chr(10),''),chr(13),'') as collateral_id
,replace(replace(floater_factor_op,chr(10),''),chr(13),'') as floater_factor_op
,replace(replace(floater_factor,chr(10),''),chr(13),'') as floater_factor
,replace(replace(fixing_rules,chr(10),''),chr(13),'') as fixing_rules
,replace(replace(org_term,chr(10),''),chr(13),'') as org_term
,replace(replace(org_term_mult,chr(10),''),chr(13),'') as org_term_mult
,replace(replace(isjx,chr(10),''),chr(13),'') as isjx
,replace(replace(modify_date,chr(10),''),chr(13),'') as modify_date
,replace(replace(compound,chr(10),''),chr(13),'') as compound
,replace(replace(security_type_new,chr(10),''),chr(13),'') as security_type_new
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ctms_tbs_v_security
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_security_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes