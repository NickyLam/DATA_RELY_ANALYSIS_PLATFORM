: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_rwas_rpt_default_i
CreateDate: 20260306
FileName:   ${iel_data_path}/rwas_rpt_default.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,data_date
,replace(replace(t1.loan_ref_no,chr(13),''),chr(10),'') as loan_ref_no
,replace(replace(t1.loan_ref_desc,chr(13),''),chr(10),'') as loan_ref_desc
,replace(replace(t1.contract_no,chr(13),''),chr(10),'') as contract_no
,replace(replace(t1.src_system_id,chr(13),''),chr(10),'') as src_system_id
,replace(replace(t1.accorg_no,chr(13),''),chr(10),'') as accorg_no
,replace(replace(t1.accorg_name,chr(13),''),chr(10),'') as accorg_name
,replace(replace(t1.five_class_cd,chr(13),''),chr(10),'') as five_class_cd
,replace(replace(t1.five_class_name,chr(13),''),chr(10),'') as five_class_name
,replace(replace(t1.product_cd,chr(13),''),chr(10),'') as product_cd
,replace(replace(t1.product_name,chr(13),''),chr(10),'') as product_name
,replace(replace(t1.bis_product_type_cd,chr(13),''),chr(10),'') as bis_product_type_cd
,replace(replace(t1.bis_product_type_name,chr(13),''),chr(10),'') as bis_product_type_name
,replace(replace(t1.bis_product_btype_cd,chr(13),''),chr(10),'') as bis_product_btype_cd
,replace(replace(t1.bis_product_btype_name,chr(13),''),chr(10),'') as bis_product_btype_name
,replace(replace(t1.buss_type_cd,chr(13),''),chr(10),'') as buss_type_cd
,replace(replace(t1.buss_type_name,chr(13),''),chr(10),'') as buss_type_name
,start_date
,due_date
,orig_maturity
,overdue_days
,replace(replace(t1.std_default_flag,chr(13),''),chr(10),'') as std_default_flag
,replace(replace(t1.book_type_id,chr(13),''),chr(10),'') as book_type_id
,replace(replace(t1.book_type_name,chr(13),''),chr(10),'') as book_type_name
,replace(replace(t1.on_off_id,chr(13),''),chr(10),'') as on_off_id
,replace(replace(t1.bis_ccy_cd,chr(13),''),chr(10),'') as bis_ccy_cd
,replace(replace(t1.bis_ccy_name,chr(13),''),chr(10),'') as bis_ccy_name
,exchange_rate
,replace(replace(t1.subject_cd,chr(13),''),chr(10),'') as subject_cd
,replace(replace(t1.subject_name,chr(13),''),chr(10),'') as subject_name
,pric_bal_origcurr
,pric_bal
,asset_balance
,replace(replace(t1.accrued_subject_cd,chr(13),''),chr(10),'') as accrued_subject_cd
,replace(replace(t1.accrued_subject_name,chr(13),''),chr(10),'') as accrued_subject_name
,accrued_int
,replace(replace(t1.receivable_subject_cd,chr(13),''),chr(10),'') as receivable_subject_cd
,replace(replace(t1.receivable_subject_name,chr(13),''),chr(10),'') as receivable_subject_name
,receivable_int
,replace(replace(t1.accrued_receiv_subject_cd,chr(13),''),chr(10),'') as accrued_receiv_subject_cd
,replace(replace(t1.accrued_receiv_subject_name,chr(13),''),chr(10),'') as accrued_receiv_subject_name
,accrued_receiv_int
,replace(replace(t1.intadj_subject_cd,chr(13),''),chr(10),'') as intadj_subject_cd
,replace(replace(t1.intadj_subject_name,chr(13),''),chr(10),'') as intadj_subject_name
,int_adj
,replace(replace(t1.fairchange_subject_cd,chr(13),''),chr(10),'') as fairchange_subject_cd
,replace(replace(t1.fairchange_subject_name,chr(13),''),chr(10),'') as fairchange_subject_name
,fairvalue_changes
,replace(replace(t1.depreamor_subject_cd,chr(13),''),chr(10),'') as depreamor_subject_cd
,replace(replace(t1.depreamor_subject_name,chr(13),''),chr(10),'') as depreamor_subject_name
,depre_amortizat
,replace(replace(t1.other_subject_cd,chr(13),''),chr(10),'') as other_subject_cd
,replace(replace(t1.other_subject_name,chr(13),''),chr(10),'') as other_subject_name
,other_amt
,replace(replace(t1.provision_subject_cd,chr(13),''),chr(10),'') as provision_subject_cd
,replace(replace(t1.provision_subject_name,chr(13),''),chr(10),'') as provision_subject_name
,provision
,provesion_ratio
,replace(replace(t1.account_classification,chr(13),''),chr(10),'') as account_classification
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.ccp_type_cd,chr(13),''),chr(10),'') as ccp_type_cd
,replace(replace(t1.ccp_type_name,chr(13),''),chr(10),'') as ccp_type_name
,replace(replace(t1.ccp_btype_cd,chr(13),''),chr(10),'') as ccp_btype_cd
,replace(replace(t1.ccp_btype_name,chr(13),''),chr(10),'') as ccp_btype_name
,replace(replace(t1.spe_lending_flag,chr(13),''),chr(10),'') as spe_lending_flag
,replace(replace(t1.spe_lending_type,chr(13),''),chr(10),'') as spe_lending_type
,replace(replace(t1.bis_country_name,chr(13),''),chr(10),'') as bis_country_name
,replace(replace(t1.sov_sp_lt_rating_cd,chr(13),''),chr(10),'') as sov_sp_lt_rating_cd
,replace(replace(t1.cust_sp_lt_rating_cd,chr(13),''),chr(10),'') as cust_sp_lt_rating_cd
,replace(replace(t1.scra_rating,chr(13),''),chr(10),'') as scra_rating
,replace(replace(t1.int_trade_flag,chr(13),''),chr(10),'') as int_trade_flag
,replace(replace(t1.solo_int_trade_flag,chr(13),''),chr(10),'') as solo_int_trade_flag
,replace(replace(t1.investment_cust_flag,chr(13),''),chr(10),'') as investment_cust_flag
,replace(replace(t1.ccy_mismatch_flag,chr(13),''),chr(10),'') as ccy_mismatch_flag
,replace(replace(t1.accept_credit_self_flag,chr(13),''),chr(10),'') as accept_credit_self_flag
,replace(replace(t1.real_estate_type_cd,chr(13),''),chr(10),'') as real_estate_type_cd
,ltv
,replace(replace(t1.accept_discount_self_flag,chr(13),''),chr(10),'') as accept_discount_self_flag
,replace(replace(t1.operation_pf_flag,chr(13),''),chr(10),'') as operation_pf_flag
,replace(replace(t1.cancel_flag,chr(13),''),chr(10),'') as cancel_flag
,replace(replace(t1.off_asset_unmeasured_flag,chr(13),''),chr(10),'') as off_asset_unmeasured_flag
,replace(replace(t1.unused_prl_tmeet_flag,chr(13),''),chr(10),'') as unused_prl_tmeet_flag
,ead_orig
,ccf
,ead_afterccf
,ead_afterpro
,rw
,replace(replace(t1.crm_ccy_mis_flag,chr(13),''),chr(10),'') as crm_ccy_mis_flag
,crm_amt_rmb
,crm_amt_split
,crm_ccy_mis_coeff
,crm_mat_mis_coeff
,crm_floor_mis_coeff
,crm_weighting_rw
,rwa_ucovered
,rwa_covered
,rwa
,c_item_e
,c_item_f
,c_item_g
,c_item_h
,c_item_i
,c_item_j
,c_item_k
,c_item_l
,c_item_m
,c_item_n
,c_item_o
,c_item_p
,c_item_q
,c_item_r
,c_item_s
,c_item_t
,c_item_u
,c_item_v
,c_item_w
,c_item_x
,c_item_y
,c_item_z
,replace(replace(t1.report_no,chr(13),''),chr(10),'') as report_no
,replace(replace(t1.report_line_no,chr(13),''),chr(10),'') as report_line_no
,replace(replace(t1.report_line_name,chr(13),''),chr(10),'') as report_line_name
,replace(replace(t1.rela_default_flag,chr(13),''),chr(10),'') as rela_default_flag
,replace(replace(t1.investment_vaild_flag,chr(13),''),chr(10),'') as investment_vaild_flag
,replace(replace(t1.load_date,chr(13),''),chr(10),'') as load_date
,nvestment_rema_maturity
,replace(replace(t1.pbc_inc_loan_flg,chr(13),''),chr(10),'') as pbc_inc_loan_flg
,replace(replace(t1.chain_proj_cust_flg,chr(13),''),chr(10),'') as chain_proj_cust_flg

from ${iol_schema}.rwas_rpt_default t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rwas_rpt_default.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
