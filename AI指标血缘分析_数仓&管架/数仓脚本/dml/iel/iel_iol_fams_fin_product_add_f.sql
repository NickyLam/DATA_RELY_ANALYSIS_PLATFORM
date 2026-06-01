: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_fin_product_add_f
CreateDate: 20240606
FileName:   ${iel_data_path}/fams_fin_product_add.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.finprod_id,chr(13),''),chr(10),'') as finprod_id
,replace(replace(t1.sale_department,chr(13),''),chr(10),'') as sale_department
,replace(replace(t1.sale_layer,chr(13),''),chr(10),'') as sale_layer
,sale_period
,pur_speed
,red_speed
,replace(replace(t1.is_sec_bond,chr(13),''),chr(10),'') as is_sec_bond
,replace(replace(t1.wind_id,chr(13),''),chr(10),'') as wind_id
,replace(replace(t1.is_auto_update,chr(13),''),chr(10),'') as is_auto_update
,replace(replace(t1.portfolio_id,chr(13),''),chr(10),'') as portfolio_id
,replace(replace(t1.prod_regist_code,chr(13),''),chr(10),'') as prod_regist_code
,replace(replace(t1.is_cycle,chr(13),''),chr(10),'') as is_cycle
,replace(replace(t1.is_lay,chr(13),''),chr(10),'') as is_lay
,replace(replace(t1.lay_type,chr(13),''),chr(10),'') as lay_type
,replace(replace(t1.invest_nature,chr(13),''),chr(10),'') as invest_nature
,replace(replace(t1.profit_flag,chr(13),''),chr(10),'') as profit_flag
,replace(replace(t1.sale_mode,chr(13),''),chr(10),'') as sale_mode
,replace(replace(t1.chb_id,chr(13),''),chr(10),'') as chb_id
,replace(replace(t1.tmpl_id,chr(13),''),chr(10),'') as tmpl_id
,close_days
,replace(replace(t1.issue_status,chr(13),''),chr(10),'') as issue_status
,replace(replace(t1.issue_status_remark,chr(13),''),chr(10),'') as issue_status_remark
,replace(replace(t1.is_compound_int,chr(13),''),chr(10),'') as is_compound_int
,replace(replace(t1.term_type,chr(13),''),chr(10),'') as term_type
,face_value
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,replace(replace(t1.pay_type,chr(13),''),chr(10),'') as pay_type
,replace(replace(t1.is_reconciliation,chr(13),''),chr(10),'') as is_reconciliation
,replace(replace(t1.is_cash_manage,chr(13),''),chr(10),'') as is_cash_manage
,replace(replace(t1.risk_level,chr(13),''),chr(10),'') as risk_level
,replace(replace(t1.deal_mode,chr(13),''),chr(10),'') as deal_mode
,replace(replace(t1.is_exclusive,chr(13),''),chr(10),'') as is_exclusive
,bid_date
,replace(replace(t1.board,chr(13),''),chr(10),'') as board
,replace(replace(t1.sh_or_zh,chr(13),''),chr(10),'') as sh_or_zh
,replace(replace(t1.is_margin_finprod,chr(13),''),chr(10),'') as is_margin_finprod
,replace(replace(t1.city_bond_lev,chr(13),''),chr(10),'') as city_bond_lev
,replace(replace(t1.is_city_bond,chr(13),''),chr(10),'') as is_city_bond
,replace(replace(t1.investment_cycle,chr(13),''),chr(10),'') as investment_cycle
,replace(replace(t1.prod_manager,chr(13),''),chr(10),'') as prod_manager
,replace(replace(t1.collect_type,chr(13),''),chr(10),'') as collect_type
,replace(replace(t1.regulatory_rating,chr(13),''),chr(10),'') as regulatory_rating
,toff_enddate
,replace(replace(t1.trm_fund_abbr,chr(13),''),chr(10),'') as trm_fund_abbr
,replace(replace(t1.trm_fund_type,chr(13),''),chr(10),'') as trm_fund_type
,replace(replace(t1.gra_fund_type,chr(13),''),chr(10),'') as gra_fund_type
,replace(replace(t1.pur_red_id,chr(13),''),chr(10),'') as pur_red_id
,replace(replace(t1.pur_red_abbr,chr(13),''),chr(10),'') as pur_red_abbr
,pur_start_low
,red_start_low
,replace(replace(t1.etf_type,chr(13),''),chr(10),'') as etf_type
,etf_min_prunit
,toff_strdate
,replace(replace(t1.org_code,chr(13),''),chr(10),'') as org_code
,replace(replace(t1.invest_manager,chr(13),''),chr(10),'') as invest_manager

from ${iol_schema}.fams_fin_product_add t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_fin_product_add.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
