: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_rwas_rpt_asset_manager_result_f
CreateDate: 20260127
FileName:   ${iel_data_path}/rwas_rpt_asset_manager_result.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,data_date
,replace(replace(t1.pk_col,chr(13),''),chr(10),'') as pk_col
,replace(replace(t1.loan_ref_no,chr(13),''),chr(10),'') as loan_ref_no
,replace(replace(t1.fund_cd,chr(13),''),chr(10),'') as fund_cd
,replace(replace(t1.fund_name,chr(13),''),chr(10),'') as fund_name
,replace(replace(t1.sa_calculate_id,chr(13),''),chr(10),'') as sa_calculate_id
,replace(replace(t1.sa_calculate_name,chr(13),''),chr(10),'') as sa_calculate_name
,replace(replace(t1.on_off_id,chr(13),''),chr(10),'') as on_off_id
,replace(replace(t1.accorg_no,chr(13),''),chr(10),'') as accorg_no
,replace(replace(t1.accorg_name,chr(13),''),chr(10),'') as accorg_name
,replace(replace(t1.product_cd,chr(13),''),chr(10),'') as product_cd
,replace(replace(t1.product_name,chr(13),''),chr(10),'') as product_name
,replace(replace(t1.five_class_name,chr(13),''),chr(10),'') as five_class_name
,overdue_days
,replace(replace(t1.std_default_flag,chr(13),''),chr(10),'') as std_default_flag
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.ccp_type_cd,chr(13),''),chr(10),'') as ccp_type_cd
,replace(replace(t1.ccp_type_name,chr(13),''),chr(10),'') as ccp_type_name
,replace(replace(t1.scale_cd,chr(13),''),chr(10),'') as scale_cd
,replace(replace(t1.scale_name,chr(13),''),chr(10),'') as scale_name
,ead_tot
,fm_asset_amt
,fm_hold_ratio
,fm_fin_product_amt
,fm_lvg
,fm_rwa_ccp
,fm_rwa_cva
,replace(replace(t1.fm_flag,chr(13),''),chr(10),'') as fm_flag
,fm_avg_rw
,fm_alvg_rw
,ccf
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
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
,replace(replace(t1.provision_subject_cd,chr(13),''),chr(10),'') as provision_subject_cd
,replace(replace(t1.provision_subject_name,chr(13),''),chr(10),'') as provision_subject_name
,provision
,provesion_ratio
,ead_orig
,ead_pen
,rwa_pen
,ead_pen_third
,rwa_pen_third
,ead_abl
,rwa_abl
,ead_pullb
,rwa_pullb
,rwa_before_adj
,rwa_after_adj
,replace(replace(t1.adj_flag,chr(13),''),chr(10),'') as adj_flag
,replace(replace(t1.g4b_r_item_code,chr(13),''),chr(10),'') as g4b_r_item_code
,replace(replace(t1.investment_vaild_flag,chr(13),''),chr(10),'') as investment_vaild_flag
,recognition_date
,replace(replace(t1.load_date,chr(13),''),chr(10),'') as load_date
,replace(replace(t1.final_weight,chr(13),''),chr(10),'') as final_weight

from ${iol_schema}.rwas_rpt_asset_manager_result t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rwas_rpt_asset_manager_result.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
