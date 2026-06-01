: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ibms_vtrd_zcywtz_f
CreateDate: 20241107
FileName:   ${iel_data_path}/ibms_vtrd_zcywtz.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.beg_date,chr(13),''),chr(10),'') as beg_date
,replace(replace(t1.trade_id,chr(13),''),chr(10),'') as trade_id
,replace(replace(t1.secu_acct_name,chr(13),''),chr(10),'') as secu_acct_name
,replace(replace(t1.dict_value,chr(13),''),chr(10),'') as dict_value
,replace(replace(t1.p_type_name,chr(13),''),chr(10),'') as p_type_name
,replace(replace(t1.p_class,chr(13),''),chr(10),'') as p_class
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.i_name,chr(13),''),chr(10),'') as i_name
,replace(replace(t1.trd_orddate,chr(13),''),chr(10),'') as trd_orddate
,replace(replace(t1.trd_party_name,chr(13),''),chr(10),'') as trd_party_name
,replace(replace(t1.trd_party_class,chr(13),''),chr(10),'') as trd_party_class
,replace(replace(t1.issue_name,chr(13),''),chr(10),'') as issue_name
,replace(replace(t1.issue_class,chr(13),''),chr(10),'') as issue_class
,replace(replace(t1.exhacc,chr(13),''),chr(10),'') as exhacc
,replace(replace(t1.party_acct_code,chr(13),''),chr(10),'') as party_acct_code
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,cp
,coupon
,replace(replace(t1.open_date,chr(13),''),chr(10),'') as open_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.inst_start_date,chr(13),''),chr(10),'') as inst_start_date
,inst_mrt_date
,replace(replace(t1.first_payment_date,chr(13),''),chr(10),'') as first_payment_date
,replace(replace(t1.pay_freq_name,chr(13),''),chr(10),'') as pay_freq_name
,replace(replace(t1.daycount_name,chr(13),''),chr(10),'') as daycount_name
,replace(replace(t1.coupon_type_name,chr(13),''),chr(10),'') as coupon_type_name
,tzye
,ai
,prft_ir
,zmye
,replace(replace(t1.business_category_name,chr(13),''),chr(10),'') as business_category_name
,replace(replace(t1.business_category_min_name,chr(13),''),chr(10),'') as business_category_min_name
,replace(replace(t1.s_grade,chr(13),''),chr(10),'') as s_grade
,replace(replace(t1.g31_plass,chr(13),''),chr(10),'') as g31_plass
,replace(replace(t1.final_invest_name,chr(13),''),chr(10),'') as final_invest_name
,replace(replace(t1.management_mode,chr(13),''),chr(10),'') as management_mode
,replace(replace(t1.raise_way,chr(13),''),chr(10),'') as raise_way
,replace(replace(t1.tzcplx,chr(13),''),chr(10),'') as tzcplx
,replace(replace(t1.under_debt_class,chr(13),''),chr(10),'') as under_debt_class
,replace(replace(t1.under_debt_rating,chr(13),''),chr(10),'') as under_debt_rating
,replace(replace(t1.hx_isgover_fund,chr(13),''),chr(10),'') as hx_isgover_fund
,replace(replace(t1.is_pioneer_invest_fund,chr(13),''),chr(10),'') as is_pioneer_invest_fund
,replace(replace(t1.hx_isdistbus,chr(13),''),chr(10),'') as hx_isdistbus
,replace(replace(t1.hx_islocfinanc,chr(13),''),chr(10),'') as hx_islocfinanc
,risk_assets_weight
,replace(replace(t1.trader,chr(13),''),chr(10),'') as trader
,replace(replace(t1.op_user_name1,chr(13),''),chr(10),'') as op_user_name1
,replace(replace(t1.op_user_name2,chr(13),''),chr(10),'') as op_user_name2
,replace(replace(t1.cp_subj_code,chr(13),''),chr(10),'') as cp_subj_code
,ai_tax_rate
,amrt_tax_rate
,trd_tax_rate
,replace(replace(t1.ibs,chr(13),''),chr(10),'') as ibs
,replace(replace(t1.hxkhh,chr(13),''),chr(10),'') as hxkhh
,replace(replace(t1.hxkhh1,chr(13),''),chr(10),'') as hxkhh1
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.mid_invest_industry_categories,chr(13),''),chr(10),'') as mid_invest_industry_categories
,replace(replace(t1.invest_industry_subcategories,chr(13),''),chr(10),'') as invest_industry_subcategories
,replace(replace(t1.funds_purpose,chr(13),''),chr(10),'') as funds_purpose
,replace(replace(t1.guarantee_method,chr(13),''),chr(10),'') as guarantee_method
,replace(replace(t1.credit_methods,chr(13),''),chr(10),'') as credit_methods
,replace(replace(t1.credit_cust,chr(13),''),chr(10),'') as credit_cust
,replace(replace(t1.datamark,chr(13),''),chr(10),'') as datamark
,replace(replace(t1.month_repay_record,chr(13),''),chr(10),'') as month_repay_record
,month_average
,year_average
,in_due_ai
,out_due_ai
,this_month_prft_ir
,this_year_prft_ir
,year_chg_fv
,month_chg_fv
,year_prft_fv_real
,year_prft_trd
,replace(replace(t1.prft_ir_subj_code,chr(13),''),chr(10),'') as prft_ir_subj_code
,replace(replace(t1.prft_trd_subj_code,chr(13),''),chr(10),'') as prft_trd_subj_code
,replace(replace(t1.chg_fv_subj_code,chr(13),''),chr(10),'') as chg_fv_subj_code
,replace(replace(t1.basic_asset_clients,chr(13),''),chr(10),'') as basic_asset_clients
,replace(replace(t1.underly_types_assets,chr(13),''),chr(10),'') as underly_types_assets
,replace(replace(t1.guarantee_description,chr(13),''),chr(10),'') as guarantee_description

from ${iol_schema}.ibms_vtrd_zcywtz t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_vtrd_zcywtz.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
