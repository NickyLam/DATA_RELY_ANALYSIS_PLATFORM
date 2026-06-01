: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_rwas_rpt_asset_securitization_f
CreateDate: 20260127
FileName:   ${iel_data_path}/rwas_rpt_asset_securitization.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,data_date
,replace(replace(t1.loan_ref_no,chr(13),''),chr(10),'') as loan_ref_no
,replace(replace(t1.sec_items_issue_no,chr(13),''),chr(10),'') as sec_items_issue_no
,replace(replace(t1.sec_items_issue_name,chr(13),''),chr(10),'') as sec_items_issue_name
,replace(replace(t1.items_tranche_no,chr(13),''),chr(10),'') as items_tranche_no
,replace(replace(t1.items_tranche_name,chr(13),''),chr(10),'') as items_tranche_name
,replace(replace(t1.on_off_id,chr(13),''),chr(10),'') as on_off_id
,replace(replace(t1.sec_priority_rating_flag,chr(13),''),chr(10),'') as sec_priority_rating_flag
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id
,replace(replace(t1.org_cd,chr(13),''),chr(10),'') as org_cd
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,overdue_days
,replace(replace(t1.five_class_cd,chr(13),''),chr(10),'') as five_class_cd
,replace(replace(t1.five_class_name,chr(13),''),chr(10),'') as five_class_name
,replace(replace(t1.product_no,chr(13),''),chr(10),'') as product_no
,replace(replace(t1.product_name,chr(13),''),chr(10),'') as product_name
,replace(replace(t1.sec_sp_rating_cd,chr(13),''),chr(10),'') as sec_sp_rating_cd
,replace(replace(t1.sec_rating_org_cd,chr(13),''),chr(10),'') as sec_rating_org_cd
,replace(replace(t1.sec_rating_org_name,chr(13),''),chr(10),'') as sec_rating_org_name
,replace(replace(t1.sec_ecternal_rating_cd,chr(13),''),chr(10),'') as sec_ecternal_rating_cd
,items_tranche_due_day
,replace(replace(t1.items_seniority,chr(13),''),chr(10),'') as items_seniority
,issue_amt_total
,amt_cur
,replace(replace(t1.sec_stc_flag,chr(13),''),chr(10),'') as sec_stc_flag
,replace(replace(t1.anew_asset_sec_flag,chr(13),''),chr(10),'') as anew_asset_sec_flag
,sec_start_date
,sec_end_date
,sec_pool_a
,sec_pool_d
,sec_pool_t
,sec_pool_mr
,sec_rating_floor_rw
,sec_rating_ceil_rw
,sec_orig_rw
,sec_pool_rw
,sec_rw
,sec_rw_adj
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.ccy_name,chr(13),''),chr(10),'') as ccy_name
,replace(replace(t1.subject_cd,chr(13),''),chr(10),'') as subject_cd
,replace(replace(t1.subject_name,chr(13),''),chr(10),'') as subject_name
,replace(replace(t1.accrued_subject_cd,chr(13),''),chr(10),'') as accrued_subject_cd
,replace(replace(t1.accrued_subject_name,chr(13),''),chr(10),'') as accrued_subject_name
,replace(replace(t1.receivable_subject_cd,chr(13),''),chr(10),'') as receivable_subject_cd
,replace(replace(t1.receivable_subject_name,chr(13),''),chr(10),'') as receivable_subject_name
,replace(replace(t1.accrued_receiv_subject_cd,chr(13),''),chr(10),'') as accrued_receiv_subject_cd
,replace(replace(t1.accrued_receiv_subject_name,chr(13),''),chr(10),'') as accrued_receiv_subject_name
,replace(replace(t1.intadj_subject_cd,chr(13),''),chr(10),'') as intadj_subject_cd
,replace(replace(t1.intadj_subject_name,chr(13),''),chr(10),'') as intadj_subject_name
,replace(replace(t1.fairchange_subject_cd,chr(13),''),chr(10),'') as fairchange_subject_cd
,replace(replace(t1.fairchange_subject_name,chr(13),''),chr(10),'') as fairchange_subject_name
,replace(replace(t1.provision_subject_cd,chr(13),''),chr(10),'') as provision_subject_cd
,replace(replace(t1.provision_subject_name,chr(13),''),chr(10),'') as provision_subject_name
,balance
,balance_hcurr
,receivable_int
,accrued_receiv_int
,accrued_int
,int_adj
,fair_value_change
,provision
,asset_balance
,ead_orig
,ccf
,ead_afterccf
,ead_afterpro
,rwa
,after_miti_rwa
,after_adj_rwa
,replace(replace(t1.report_no,chr(13),''),chr(10),'') as report_no
,replace(replace(t1.report_line_no,chr(13),''),chr(10),'') as report_line_no
,replace(replace(t1.load_date,chr(13),''),chr(10),'') as load_date
,replace(replace(t1.book_type_id,chr(13),''),chr(10),'') as book_type_id

from ${iol_schema}.rwas_rpt_asset_securitization t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rwas_rpt_asset_securitization.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
