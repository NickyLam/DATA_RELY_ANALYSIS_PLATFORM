: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_pa_fin_product_f
CreateDate: 20240228
FileName:   ${iel_data_path}/fams_pa_fin_product.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.finprod_id,chr(13),''),chr(10),'') as finprod_id
,replace(replace(t1.deal_mode,chr(13),''),chr(10),'') as deal_mode
,replace(replace(t1.asset_source,chr(13),''),chr(10),'') as asset_source
,replace(replace(t1.asset_provider,chr(13),''),chr(10),'') as asset_provider
,replace(replace(t1.cash_out_no,chr(13),''),chr(10),'') as cash_out_no
,replace(replace(t1.asset_source_unit,chr(13),''),chr(10),'') as asset_source_unit
,replace(replace(t1.load_bank,chr(13),''),chr(10),'') as load_bank
,settle_days
,replace(replace(t1.proj_invest_industry,chr(13),''),chr(10),'') as proj_invest_industry
,replace(replace(t1.proj_invest_industry2,chr(13),''),chr(10),'') as proj_invest_industry2
,replace(replace(t1.bank_trust_code,chr(13),''),chr(10),'') as bank_trust_code
,replace(replace(t1.actual_credit_provid,chr(13),''),chr(10),'') as actual_credit_provid
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,replace(replace(t1.investment_attributes,chr(13),''),chr(10),'') as investment_attributes
,replace(replace(t1.prod_series,chr(13),''),chr(10),'') as prod_series
,replace(replace(t1.prod_class,chr(13),''),chr(10),'') as prod_class
,replace(replace(t1.prod_feature,chr(13),''),chr(10),'') as prod_feature
,replace(replace(t1.exclusive_prod,chr(13),''),chr(10),'') as exclusive_prod
,replace(replace(t1.prod_manager,chr(13),''),chr(10),'') as prod_manager
,replace(replace(t1.sale_type,chr(13),''),chr(10),'') as sale_type
,replace(replace(t1.same_org,chr(13),''),chr(10),'') as same_org
,replace(replace(t1.investment_cycle,chr(13),''),chr(10),'') as investment_cycle
,replace(replace(t1.target_customer_1,chr(13),''),chr(10),'') as target_customer_1
,replace(replace(t1.target_customer_2,chr(13),''),chr(10),'') as target_customer_2
,replace(replace(t1.asset_credit_name,chr(13),''),chr(10),'') as asset_credit_name
,replace(replace(t1.is_interest,chr(13),''),chr(10),'') as is_interest
,legal_mdate
,replace(replace(t1.is_outs,chr(13),''),chr(10),'') as is_outs
,replace(replace(t1.series_name,chr(13),''),chr(10),'') as series_name
,replace(replace(t1.asset_class,chr(13),''),chr(10),'') as asset_class
,replace(replace(t1.actual_manager,chr(13),''),chr(10),'') as actual_manager
,replace(replace(t1.bank_invest_code,chr(13),''),chr(10),'') as bank_invest_code
,replace(replace(t1.rep_plan_prop,chr(13),''),chr(10),'') as rep_plan_prop
,replace(replace(t1.int_type,chr(13),''),chr(10),'') as int_type
,replace(replace(t1.data_source,chr(13),''),chr(10),'') as data_source
,replace(replace(t1.trial_no,chr(13),''),chr(10),'') as trial_no
,replace(replace(t1.base_rule,chr(13),''),chr(10),'') as base_rule
,replace(replace(t1.overallocation,chr(13),''),chr(10),'') as overallocation
,vat_tax_rate
,adt_tax_rate

from ${iol_schema}.fams_pa_fin_product t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_pa_fin_product.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
