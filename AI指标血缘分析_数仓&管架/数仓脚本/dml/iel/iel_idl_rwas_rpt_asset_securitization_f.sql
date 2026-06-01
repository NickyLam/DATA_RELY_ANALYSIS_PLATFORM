: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rwas_rpt_asset_securitization_f
CreateDate: 20241113
FileName:   ${iel_data_path}/rwas_rpt_asset_securitization.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.data_date as data_date
,t1.loan_ref_no as loan_ref_no
,t1.sec_items_issue_no as sec_items_issue_no
,t1.sec_items_issue_name as sec_items_issue_name
,t1.items_tranche_no as items_tranche_no
,t1.items_tranche_name as items_tranche_name
,t1.on_off_id as on_off_id
,t1.sec_priority_rating_flag as sec_priority_rating_flag
,t1.market_type_id as market_type_id
,t1.org_cd as org_cd
,t1.org_name as org_name
,t1.overdue_days as overdue_days
,t1.five_class_cd as five_class_cd
,t1.five_class_name as five_class_name
,t1.product_no as product_no
,t1.product_name as product_name
,t1.sec_sp_rating_cd as sec_sp_rating_cd
,t1.sec_rating_org_cd as sec_rating_org_cd
,t1.sec_rating_org_name as sec_rating_org_name
,t1.sec_ecternal_rating_cd as sec_ecternal_rating_cd
,t1.items_tranche_due_day as items_tranche_due_day
,t1.items_seniority as items_seniority
,t1.issue_amt_total as issue_amt_total
,t1.amt_cur as amt_cur
,t1.sec_stc_flag as sec_stc_flag
,t1.anew_asset_sec_flag as anew_asset_sec_flag
,t1.sec_start_date as sec_start_date
,t1.sec_end_date as sec_end_date
,t1.sec_pool_a as sec_pool_a
,t1.sec_pool_d as sec_pool_d
,t1.sec_pool_t as sec_pool_t
,t1.sec_pool_mr as sec_pool_mr
,t1.sec_rating_floor_rw as sec_rating_floor_rw
,t1.sec_rating_ceil_rw as sec_rating_ceil_rw
,t1.sec_orig_rw as sec_orig_rw
,t1.sec_pool_rw as sec_pool_rw
,t1.sec_rw as sec_rw
,t1.sec_rw_adj as sec_rw_adj
,t1.ccy_cd as ccy_cd
,t1.ccy_name as ccy_name
,t1.subject_cd as subject_cd
,t1.subject_name as subject_name
,t1.accrued_subject_cd as accrued_subject_cd
,t1.accrued_subject_name as accrued_subject_name
,t1.receivable_subject_cd as receivable_subject_cd
,t1.receivable_subject_name as receivable_subject_name
,t1.accrued_receiv_subject_cd as accrued_receiv_subject_cd
,t1.accrued_receiv_subject_name as accrued_receiv_subject_name
,t1.intadj_subject_cd as intadj_subject_cd
,t1.intadj_subject_name as intadj_subject_name
,t1.fairchange_subject_cd as fairchange_subject_cd
,t1.fairchange_subject_name as fairchange_subject_name
,t1.provision_subject_cd as provision_subject_cd
,t1.provision_subject_name as provision_subject_name
,t1.balance as balance
,t1.balance_hcurr as balance_hcurr
,t1.receivable_int as receivable_int
,t1.accrued_receiv_int as accrued_receiv_int
,t1.accrued_int as accrued_int
,t1.int_adj as int_adj
,t1.fair_value_change as fair_value_change
,t1.provision as provision
,t1.asset_balance as asset_balance
,t1.ead_orig as ead_orig
,t1.ccf as ccf
,t1.ead_afterccf as ead_afterccf
,t1.ead_afterpro as ead_afterpro
,t1.rwa as rwa
,t1.after_miti_rwa as after_miti_rwa
,t1.after_adj_rwa as after_adj_rwa
,t1.report_no as report_no
,t1.report_line_no as report_line_no
,t1.load_date as load_date
,t1.book_type_id as book_type_id

from ${idl_schema}.rwas_rpt_asset_securitization t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rwas_rpt_asset_securitization.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
