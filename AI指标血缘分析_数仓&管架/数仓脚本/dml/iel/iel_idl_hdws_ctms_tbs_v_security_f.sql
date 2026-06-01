: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ctms_tbs_v_security_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ctms_tbs_v_security.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.security_code
,t1.security_name
,t1.security_type
,t1.issuer
,t1.guarantee
,t1.ccy
,t1.int_ccy
,t1.issue_date
,t1.start_coupon_date
,t1.maturity_date
,t1.lot_size
,t1.day_count
,t1.rate_type
,t1.fixed_rate
,t1.floating_rate
,t1.floating_rate_ind
,t1.floating_spread
,t1.fixing_freq
,t1.ffixing_date
,t1.coupon_freq
,t1.fcoupon_date
,t1.payment_freq
,t1.compound_freq
,t1.option_type
,t1.back_amt
,t1.number_issued
,t1.aution_rate
,t1.aution_price
,t1.first_trade_date
,t1.market_type
,t1.repo_ratio
,t1.security_short_name
,t1.convertable
,t1.convert_security_code
,t1.discount_rate
,t1.cap
,t1.floor
,t1.fixing_rate_methoh
,t1.note
,t1.floating_rate_scale
,t1.stop_trade_date
,t1.collateral_id
,t1.floater_factor_op
,t1.floater_factor
,t1.fixing_rules
,t1.org_term
,t1.org_term_mult
,t1.isjx
,t1.modify_date
,t1.compound
,t1.security_type_new
,t1.start_dt
,t1.end_dt
,t1.id_mark
,t1.etl_timestamp
from ${idl_schema}.hdws_ctms_tbs_v_security t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ctms_tbs_v_security.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes