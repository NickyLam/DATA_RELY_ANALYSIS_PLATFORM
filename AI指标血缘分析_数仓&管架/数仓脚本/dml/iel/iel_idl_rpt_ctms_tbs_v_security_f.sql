: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_ctms_tbs_v_security_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_ctms_tbs_v_security.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.security_code,chr(13),''),chr(10),'') as security_code
,replace(replace(t1.security_name,chr(13),''),chr(10),'') as security_name
,replace(replace(t1.security_type,chr(13),''),chr(10),'') as security_type
,replace(replace(t1.issuer,chr(13),''),chr(10),'') as issuer
,replace(replace(t1.guarantee,chr(13),''),chr(10),'') as guarantee
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.int_ccy,chr(13),''),chr(10),'') as int_ccy
,replace(replace(t1.issue_date,chr(13),''),chr(10),'') as issue_date
,replace(replace(t1.start_coupon_date,chr(13),''),chr(10),'') as start_coupon_date
,replace(replace(t1.maturity_date,chr(13),''),chr(10),'') as maturity_date
,t1.lot_size as lot_size
,replace(replace(t1.day_count,chr(13),''),chr(10),'') as day_count
,replace(replace(t1.rate_type,chr(13),''),chr(10),'') as rate_type
,t1.fixed_rate as fixed_rate
,replace(replace(t1.floating_rate,chr(13),''),chr(10),'') as floating_rate
,t1.floating_rate_ind as floating_rate_ind
,t1.floating_spread as floating_spread
,replace(replace(t1.fixing_freq,chr(13),''),chr(10),'') as fixing_freq
,replace(replace(t1.ffixing_date,chr(13),''),chr(10),'') as ffixing_date
,replace(replace(t1.coupon_freq,chr(13),''),chr(10),'') as coupon_freq
,replace(replace(t1.fcoupon_date,chr(13),''),chr(10),'') as fcoupon_date
,replace(replace(t1.payment_freq,chr(13),''),chr(10),'') as payment_freq
,replace(replace(t1.compound_freq,chr(13),''),chr(10),'') as compound_freq
,replace(replace(t1.option_type,chr(13),''),chr(10),'') as option_type
,t1.back_amt as back_amt
,t1.number_issued as number_issued
,t1.aution_rate as aution_rate
,t1.aution_price as aution_price
,replace(replace(t1.first_trade_date,chr(13),''),chr(10),'') as first_trade_date
,replace(replace(t1.market_type,chr(13),''),chr(10),'') as market_type
,t1.repo_ratio as repo_ratio
,replace(replace(t1.security_short_name,chr(13),''),chr(10),'') as security_short_name
,replace(replace(t1.convertable,chr(13),''),chr(10),'') as convertable
,replace(replace(t1.convert_security_code,chr(13),''),chr(10),'') as convert_security_code
,replace(replace(t1.discount_rate,chr(13),''),chr(10),'') as discount_rate
,t1.cap as cap
,t1.floor as floor
,replace(replace(t1.fixing_rate_methoh,chr(13),''),chr(10),'') as fixing_rate_methoh
,replace(replace(t1.note,chr(13),''),chr(10),'') as note
,t1.floating_rate_scale as floating_rate_scale
,replace(replace(t1.stop_trade_date,chr(13),''),chr(10),'') as stop_trade_date
,replace(replace(t1.collateral_id,chr(13),''),chr(10),'') as collateral_id
,replace(replace(t1.floater_factor_op,chr(13),''),chr(10),'') as floater_factor_op
,t1.floater_factor as floater_factor
,replace(replace(t1.fixing_rules,chr(13),''),chr(10),'') as fixing_rules
,t1.org_term as org_term
,replace(replace(t1.org_term_mult,chr(13),''),chr(10),'') as org_term_mult
,replace(replace(t1.isjx,chr(13),''),chr(10),'') as isjx
,t1.modify_date as modify_date
,replace(replace(t1.compound,chr(13),''),chr(10),'') as compound
,replace(replace(t1.security_type_new,chr(13),''),chr(10),'') as security_type_new
 from iol.ctms_tbs_v_security T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_ctms_tbs_v_security.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes