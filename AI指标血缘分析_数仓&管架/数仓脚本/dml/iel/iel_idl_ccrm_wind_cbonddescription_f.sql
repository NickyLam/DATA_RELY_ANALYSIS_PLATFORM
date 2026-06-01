: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_cbonddescription_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_cbonddescription.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.b_info_fullname,chr(13),''),chr(10),'') as b_info_fullname
,replace(replace(t1.b_info_issuer,chr(13),''),chr(10),'') as b_info_issuer
,replace(replace(t1.b_issue_announcement,chr(13),''),chr(10),'') as b_issue_announcement
,replace(replace(t1.b_issue_firstissue,chr(13),''),chr(10),'') as b_issue_firstissue
,replace(replace(t1.b_issue_lastissue,chr(13),''),chr(10),'') as b_issue_lastissue
,t1.b_issue_amountplan as b_issue_amountplan
,t1.b_issue_amountact as b_issue_amountact
,t1.b_info_issueprice as b_info_issueprice
,t1.b_info_par as b_info_par
,t1.b_info_couponrate as b_info_couponrate
,t1.b_info_spread as b_info_spread
,replace(replace(t1.b_info_carrydate,chr(13),''),chr(10),'') as b_info_carrydate
,replace(replace(t1.b_info_enddate,chr(13),''),chr(10),'') as b_info_enddate
,replace(replace(t1.b_info_maturitydate,chr(13),''),chr(10),'') as b_info_maturitydate
,t1.b_info_term_year_ as b_info_term_year_
,t1.b_info_term_day_ as b_info_term_day_
,replace(replace(t1.b_info_paymentdate,chr(13),''),chr(10),'') as b_info_paymentdate
,t1.b_info_paymenttype as b_info_paymenttype
,replace(replace(t1.b_info_interestfrequency,chr(13),''),chr(10),'') as b_info_interestfrequency
,replace(replace(t1.b_info_form,chr(13),''),chr(10),'') as b_info_form
,t1.b_info_coupon as b_info_coupon
,t1.b_info_interesttype as b_info_interesttype
,t1.b_info_act as b_info_act
,t1.b_issue_fee as b_issue_fee
,t1.b_redemption_feeration as b_redemption_feeration
,t1.b_info_taxrate as b_info_taxrate
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,replace(replace(t1.s_info_name,chr(13),''),chr(10),'') as s_info_name
,replace(replace(t1.s_info_exchmarket,chr(13),''),chr(10),'') as s_info_exchmarket
,replace(replace(t1.b_info_guarantor,chr(13),''),chr(10),'') as b_info_guarantor
,t1.b_info_guartype as b_info_guartype
,replace(replace(t1.b_info_listdate,chr(13),''),chr(10),'') as b_info_listdate
,t1.b_info_yearsnumber as b_info_yearsnumber
,replace(replace(t1.s_div_recorddate,chr(13),''),chr(10),'') as s_div_recorddate
,replace(replace(t1.b_info_codebyplacing,chr(13),''),chr(10),'') as b_info_codebyplacing
,replace(replace(t1.b_info_delistdate,chr(13),''),chr(10),'') as b_info_delistdate
,t1.b_info_issuetype as b_info_issuetype
,replace(replace(t1.b_info_guarintroduction,chr(13),''),chr(10),'') as b_info_guarintroduction
,replace(replace(t1.b_info_bgndbyplacing,chr(13),''),chr(10),'') as b_info_bgndbyplacing
,replace(replace(t1.b_info_enddbyplacing,chr(13),''),chr(10),'') as b_info_enddbyplacing
,t1.b_info_amountbyplacing as b_info_amountbyplacing
,t1.b_info_underwritingcode as b_info_underwritingcode
,replace(replace(t1.b_info_issuercode,chr(13),''),chr(10),'') as b_info_issuercode
,replace(replace(t1.b_info_formercode,chr(13),''),chr(10),'') as b_info_formercode
,replace(replace(t1.b_info_coupontxt,chr(13),''),chr(10),'') as b_info_coupontxt
,t1.is_failure as is_failure
,t1.is_crossmarket as is_crossmarket
,replace(replace(t1.b_info_coupondatetxt,chr(13),''),chr(10),'') as b_info_coupondatetxt
,t1.b_info_subordinateornot as b_info_subordinateornot
,t1.b_tendrst_referyield as b_tendrst_referyield
,t1.b_info_curpar as b_info_curpar
,replace(replace(t1.s_info_formerwindcode,chr(13),''),chr(10),'') as s_info_formerwindcode
,t1.is_corporate_bond as is_corporate_bond
,replace(replace(t1.b_info_issuertype,chr(13),''),chr(10),'') as b_info_issuertype
,replace(replace(t1.b_info_specialbondtype,chr(13),''),chr(10),'') as b_info_specialbondtype
,replace(replace(t1.is_payadvanced,chr(13),''),chr(10),'') as is_payadvanced
,replace(replace(t1.is_callable,chr(13),''),chr(10),'') as is_callable
,replace(replace(t1.is_chooseright,chr(13),''),chr(10),'') as is_chooseright
,t1.is_netprice as is_netprice
,t1.is_act_days as is_act_days
,t1.is_incbonds as is_incbonds
,replace(replace(t1.issue_object,chr(13),''),chr(10),'') as issue_object
,replace(replace(t1.b_info_actualbenchmark,chr(13),''),chr(10),'') as b_info_actualbenchmark
,to_date('${batch_date}','yyyymmdd') as opdate
,'' as opmode
from ${iol_schema}.wind_cbonddescription t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_cbonddescription.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes