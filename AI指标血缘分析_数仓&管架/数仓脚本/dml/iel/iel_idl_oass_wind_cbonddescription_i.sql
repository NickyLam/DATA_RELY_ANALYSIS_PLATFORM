: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_wind_cbonddescription_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_wind_cbonddescription.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.b_info_fullname as b_info_fullname
,t1.b_info_issuer as b_info_issuer
,t1.b_issue_announcement as b_issue_announcement
,t1.b_issue_firstissue as b_issue_firstissue
,t1.b_issue_lastissue as b_issue_lastissue
,t1.b_issue_amountplan as b_issue_amountplan
,t1.b_issue_amountact as b_issue_amountact
,t1.b_info_issueprice as b_info_issueprice
,t1.b_info_par as b_info_par
,t1.b_info_couponrate as b_info_couponrate
,t1.b_info_spread as b_info_spread
,t1.b_info_carrydate as b_info_carrydate
,t1.b_info_enddate as b_info_enddate
,t1.b_info_maturitydate as b_info_maturitydate
,t1.b_info_term_year_ as b_info_term_year_
,t1.b_info_term_day_ as b_info_term_day_
,t1.b_info_paymentdate as b_info_paymentdate
,t1.b_info_paymenttype as b_info_paymenttype
,t1.b_info_interestfrequency as b_info_interestfrequency
,t1.b_info_form as b_info_form
,t1.b_info_coupon as b_info_coupon
,t1.b_info_interesttype as b_info_interesttype
,t1.b_info_act as b_info_act
,t1.b_issue_fee as b_issue_fee
,t1.b_redemption_feeration as b_redemption_feeration
,t1.b_info_taxrate as b_info_taxrate
,t1.crncy_code as crncy_code
,t1.s_info_name as s_info_name
,t1.s_info_exchmarket as s_info_exchmarket
,t1.b_info_guarantor as b_info_guarantor
,t1.b_info_guartype as b_info_guartype
,t1.b_info_listdate as b_info_listdate
,t1.b_info_yearsnumber as b_info_yearsnumber
,t1.s_div_recorddate as s_div_recorddate
,t1.b_info_codebyplacing as b_info_codebyplacing
,t1.b_info_delistdate as b_info_delistdate
,t1.b_info_issuetype as b_info_issuetype
,t1.b_info_guarintroduction as b_info_guarintroduction
,t1.b_info_bgndbyplacing as b_info_bgndbyplacing
,t1.b_info_enddbyplacing as b_info_enddbyplacing
,t1.b_info_amountbyplacing as b_info_amountbyplacing
,t1.b_info_underwritingcode as b_info_underwritingcode
,t1.b_info_issuercode as b_info_issuercode
,t1.b_info_formercode as b_info_formercode
,t1.b_info_coupontxt as b_info_coupontxt
,t1.is_failure as is_failure
,t1.is_crossmarket as is_crossmarket
,t1.b_info_coupondatetxt as b_info_coupondatetxt
,t1.b_info_subordinateornot as b_info_subordinateornot
,t1.b_tendrst_referyield as b_tendrst_referyield
,t1.b_info_curpar as b_info_curpar
,t1.s_info_formerwindcode as s_info_formerwindcode
,t1.is_corporate_bond as is_corporate_bond
,t1.b_info_issuertype as b_info_issuertype
,t1.b_info_specialbondtype as b_info_specialbondtype
,t1.is_payadvanced as is_payadvanced
,t1.is_callable as is_callable
,t1.is_chooseright as is_chooseright
,t1.is_netprice as is_netprice
,t1.is_act_days as is_act_days
,t1.is_incbonds as is_incbonds
,t1.issue_object as issue_object
,t1.b_info_actualbenchmark as b_info_actualbenchmark
,t1.register_file_type_code as register_file_type_code
,t1.register_file_number as register_file_number
,t1.list_ann_date as list_ann_date
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.object_id as object_id
,t1.id_mark as id_mark
,t1.s_info_windcode as s_info_windcode

from ${idl_schema}.oass_wind_cbonddescription t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_wind_cbonddescription.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
