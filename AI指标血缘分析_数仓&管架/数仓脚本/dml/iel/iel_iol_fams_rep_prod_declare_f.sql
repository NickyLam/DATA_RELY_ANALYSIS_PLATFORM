: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_rep_prod_declare_f
CreateDate: 20240305
FileName:   ${iel_data_path}/fams_rep_prod_declare.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.rep_finprod_id,chr(13),''),chr(10),'') as rep_finprod_id
,replace(replace(t1.rep_finprod_name,chr(13),''),chr(10),'') as rep_finprod_name
,replace(replace(t1.rep_finprod_reg_id,chr(13),''),chr(10),'') as rep_finprod_reg_id
,replace(replace(t1.rep_finprod_ins_id,chr(13),''),chr(10),'') as rep_finprod_ins_id
,replace(replace(t1.rep_finprod_brand,chr(13),''),chr(10),'') as rep_finprod_brand
,rep_finprod_stage
,replace(replace(t1.rep_issue_party_id,chr(13),''),chr(10),'') as rep_issue_party_id
,replace(replace(t1.rep_approver_id,chr(13),''),chr(10),'') as rep_approver_id
,replace(replace(t1.rep_approver_name,chr(13),''),chr(10),'') as rep_approver_name
,replace(replace(t1.rep_designer_id,chr(13),''),chr(10),'') as rep_designer_id
,replace(replace(t1.rep_designer_name,chr(13),''),chr(10),'') as rep_designer_name
,replace(replace(t1.rep_manager_id,chr(13),''),chr(10),'') as rep_manager_id
,replace(replace(t1.rep_manager_name,chr(13),''),chr(10),'') as rep_manager_name
,replace(replace(t1.rep_liaison_name,chr(13),''),chr(10),'') as rep_liaison_name
,replace(replace(t1.rep_liaison_tel,chr(13),''),chr(10),'') as rep_liaison_tel
,replace(replace(t1.rep_liaison_mobile,chr(13),''),chr(10),'') as rep_liaison_mobile
,replace(replace(t1.rep_liaison_email,chr(13),''),chr(10),'') as rep_liaison_email
,replace(replace(t1.rep_profit_type,chr(13),''),chr(10),'') as rep_profit_type
,replace(replace(t1.rep_term,chr(13),''),chr(10),'') as rep_term
,replace(replace(t1.rep_investor_type,chr(13),''),chr(10),'') as rep_investor_type
,replace(replace(t1.rep_invest_area,chr(13),''),chr(10),'') as rep_invest_area
,replace(replace(t1.rep_invest_country,chr(13),''),chr(10),'') as rep_invest_country
,replace(replace(t1.rep_finan_ser_model,chr(13),''),chr(10),'') as rep_finan_ser_model
,replace(replace(t1.rep_operate_mode,chr(13),''),chr(10),'') as rep_operate_mode
,replace(replace(t1.rep_book_mode,chr(13),''),chr(10),'') as rep_book_mode
,replace(replace(t1.rep_cmmode,chr(13),''),chr(10),'') as rep_cmmode
,replace(replace(t1.rep_pmmode,chr(13),''),chr(10),'') as rep_pmmode
,replace(replace(t1.rep_mname,chr(13),''),chr(10),'') as rep_mname
,replace(replace(t1.rep_priced_mode,chr(13),''),chr(10),'') as rep_priced_mode
,replace(replace(t1.rep_inv_asset_type,chr(13),''),chr(10),'') as rep_inv_asset_type
,replace(replace(t1.rep_con_prd_traget,chr(13),''),chr(10),'') as rep_con_prd_traget
,replace(replace(t1.rep_cont_mode,chr(13),''),chr(10),'') as rep_cont_mode
,replace(replace(t1.rep_coop_name,chr(13),''),chr(10),'') as rep_coop_name
,replace(replace(t1.rep_inv_type_rat,chr(13),''),chr(10),'') as rep_inv_type_rat
,replace(replace(t1.rep_is_yield,chr(13),''),chr(10),'') as rep_is_yield
,rep_high_yield
,rep_low_yield
,replace(replace(t1.rep_is_yield_basis,chr(13),''),chr(10),'') as rep_is_yield_basis
,replace(replace(t1.rep_risk_type,chr(13),''),chr(10),'') as rep_risk_type
,replace(replace(t1.rep_sale_area,chr(13),''),chr(10),'') as rep_sale_area
,replace(replace(t1.rep_raise_ccy,chr(13),''),chr(10),'') as rep_raise_ccy
,replace(replace(t1.rep_cash_prin_ccy,chr(13),''),chr(10),'') as rep_cash_prin_ccy
,replace(replace(t1.rep_cash_prof_ccy,chr(13),''),chr(10),'') as rep_cash_prof_ccy
,rep_sale_amt_str
,rep_raise_amt_plan
,rep_raise_pstrdate
,rep_raise_penddate
,replace(replace(t1.rep_invest_prin_date,chr(13),''),chr(10),'') as rep_invest_prin_date
,replace(replace(t1.rep_invest_prof_date,chr(13),''),chr(10),'') as rep_invest_prof_date
,rep_sale_fee_rate
,replace(replace(t1.rep_in_dep_name,chr(13),''),chr(10),'') as rep_in_dep_name
,replace(replace(t1.rep_in_dep_code,chr(13),''),chr(10),'') as rep_in_dep_code
,replace(replace(t1.rep_out_dep_ctry,chr(13),''),chr(10),'') as rep_out_dep_ctry
,replace(replace(t1.rep_out_dep_name,chr(13),''),chr(10),'') as rep_out_dep_name
,rep_tru_fee_rate
,replace(replace(t1.rep_risk_level,chr(13),''),chr(10),'') as rep_risk_level
,replace(replace(t1.rep_term_right_flag,chr(13),''),chr(10),'') as rep_term_right_flag
,replace(replace(t1.rep_cus_redeem_flag,chr(13),''),chr(10),'') as rep_cus_redeem_flag
,replace(replace(t1.rep_credit_flag,chr(13),''),chr(10),'') as rep_credit_flag
,replace(replace(t1.rep_credit_type,chr(13),''),chr(10),'') as rep_credit_type
,replace(replace(t1.rep_credit_mode,chr(13),''),chr(10),'') as rep_credit_mode
,replace(replace(t1.rep_remark,chr(13),''),chr(10),'') as rep_remark
,rep_declare_date
,replace(replace(t1.rep_send_status,chr(13),''),chr(10),'') as rep_send_status
,rep_status_date
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,replace(replace(t1.exc_fin_sector,chr(13),''),chr(10),'') as exc_fin_sector
,replace(replace(t1.is_short_term,chr(13),''),chr(10),'') as is_short_term
,short_term
,replace(replace(t1.is_free_redem,chr(13),''),chr(10),'') as is_free_redem
,replace(replace(t1.customer_type,chr(13),''),chr(10),'') as customer_type
,replace(replace(t1.rep_issue_type,chr(13),''),chr(10),'') as rep_issue_type
,replace(replace(t1.rep_yield,chr(13),''),chr(10),'') as rep_yield
,replace(replace(t1.rep_invest_nature,chr(13),''),chr(10),'') as rep_invest_nature
,replace(replace(t1.rep_is_cash_manage,chr(13),''),chr(10),'') as rep_is_cash_manage
,replace(replace(t1.rep_invest_fee_rate,chr(13),''),chr(10),'') as rep_invest_fee_rate
,replace(replace(t1.rep_fiduciary_duty,chr(13),''),chr(10),'') as rep_fiduciary_duty
,replace(replace(t1.rep_fprod_id,chr(13),''),chr(10),'') as rep_fprod_id
,replace(replace(t1.buy_place,chr(13),''),chr(10),'') as buy_place
,replace(replace(t1.customer_type1,chr(13),''),chr(10),'') as customer_type1
,replace(replace(t1.customer_type2,chr(13),''),chr(10),'') as customer_type2
,replace(replace(t1.prd_spec_property,chr(13),''),chr(10),'') as prd_spec_property
,replace(replace(t1.base_info_sign,chr(13),''),chr(10),'') as base_info_sign
,replace(replace(t1.change_reason,chr(13),''),chr(10),'') as change_reason
,replace(replace(t1.rep_extension_flag,chr(13),''),chr(10),'') as rep_extension_flag
,replace(replace(t1.rep_is_in_liquidation,chr(13),''),chr(10),'') as rep_is_in_liquidation

from ${iol_schema}.fams_rep_prod_declare t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_rep_prod_declare.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
