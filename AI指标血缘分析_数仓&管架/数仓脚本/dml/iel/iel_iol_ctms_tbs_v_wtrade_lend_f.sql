: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_wtrade_lend_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_wtrade_lend.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.deal_id as deal_id
,replace(replace(t1.deal_tablename,chr(13),''),chr(10),'') as deal_tablename
,t1.aspclient_id as aspclient_id
,t1.portfolio_id as portfolio_id
,replace(replace(t1.portfolio_name,chr(13),''),chr(10),'') as portfolio_name
,replace(replace(t1.serial_number,chr(13),''),chr(10),'') as serial_number
,t1.user_number as user_number
,t1.branch_number as branch_number
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.buyorsell,chr(13),''),chr(10),'') as buyorsell
,t1.amount as amount
,t1.trade_rate as trade_rate
,t1.market_rate as market_rate
,replace(replace(t1.value_date,chr(13),''),chr(10),'') as value_date
,replace(replace(t1.maturity_date,chr(13),''),chr(10),'') as maturity_date
,replace(replace(t1.trade_date,chr(13),''),chr(10),'') as trade_date
,t1.trade_time as trade_time
,replace(replace(t1.ref_number,chr(13),''),chr(10),'') as ref_number
,replace(replace(t1.link_serial_number,chr(13),''),chr(10),'') as link_serial_number
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,t1.dealer as dealer
,replace(replace(t1.account,chr(13),''),chr(10),'') as account
,t1.maturity_amount as maturity_amount
,replace(replace(t1.lend_id,chr(13),''),chr(10),'') as lend_id
,replace(replace(t1.bondscode,chr(13),''),chr(10),'') as bondscode
,replace(replace(t1.lendbondscode,chr(13),''),chr(10),'') as lendbondscode
,t1.fee as fee
,t1.tax_amt as tax_amt
,t1.broker_amt as broker_amt
,t1.interest as interest
,replace(replace(t1.note,chr(13),''),chr(10),'') as note
,replace(replace(t1.day_count,chr(13),''),chr(10),'') as day_count
,replace(replace(t1.process_status,chr(13),''),chr(10),'') as process_status
,t1.realized_pl as realized_pl
,t1.unrealized_pl as unrealized_pl
,t1.total_pl as total_pl
,t1.daily_pl as daily_pl
,t1.interest_pl as interest_pl
,t1.realized_days as realized_days
,replace(replace(t1.ori_trade_date,chr(13),''),chr(10),'') as ori_trade_date
,replace(replace(t1.security_face_amount,chr(13),''),chr(10),'') as security_face_amount
,replace(replace(t1.collateral_type,chr(13),''),chr(10),'') as collateral_type
,replace(replace(t1.lend_rate,chr(13),''),chr(10),'') as lend_rate
,replace(replace(t1.settle_type,chr(13),''),chr(10),'') as settle_type
,replace(replace(t1.settle_type2,chr(13),''),chr(10),'') as settle_type2
,t1.deal_time as deal_time
,t1.modify_user as modify_user
,t1.keepfolder_id as keepfolder_id
,replace(replace(t1.keepfolder_shortname,chr(13),''),chr(10),'') as keepfolder_shortname
,replace(replace(t1.cptys_short_name,chr(13),''),chr(10),'') as cptys_short_name
,t1.cptys_id as cptys_id
,replace(replace(t1.ref_deal_sn,chr(13),''),chr(10),'') as ref_deal_sn
,replace(replace(t1.valid_source_sn,chr(13),''),chr(10),'') as valid_source_sn
,replace(replace(t1.cancel_reason,chr(13),''),chr(10),'') as cancel_reason
,replace(replace(t1.source,chr(13),''),chr(10),'') as source
,replace(replace(t1.input_from,chr(13),''),chr(10),'') as input_from
,replace(replace(t1.cstp_serial,chr(13),''),chr(10),'') as cstp_serial
,replace(replace(t1.cfets_from,chr(13),''),chr(10),'') as cfets_from
,t1.lend_days as lend_days
,replace(replace(t1.inv_type,chr(13),''),chr(10),'') as inv_type
,replace(replace(t1.inv_short,chr(13),''),chr(10),'') as inv_short
,replace(replace(t1.auto_import,chr(13),''),chr(10),'') as auto_import
,replace(replace(t1.price_flag,chr(13),''),chr(10),'') as price_flag
,replace(replace(t1.match_flag,chr(13),''),chr(10),'') as match_flag
,replace(replace(t1.is_trans_quote,chr(13),''),chr(10),'') as is_trans_quote
,t1.wtrade_lend_id_grand as wtrade_lend_id_grand
,t1.datasymbol_id as datasymbol_id
,replace(replace(t1.orig_serial_number,chr(13),''),chr(10),'') as orig_serial_number
,replace(replace(t1.impstatus,chr(13),''),chr(10),'') as impstatus
,replace(replace(t1.prostatus,chr(13),''),chr(10),'') as prostatus
,replace(replace(t1.spotfwd,chr(13),''),chr(10),'') as spotfwd
,t1.lastmodified as lastmodified
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.ctms_tbs_v_wtrade_lend t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_wtrade_lend.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes