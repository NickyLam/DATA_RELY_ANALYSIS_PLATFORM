: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_rwas_rwa_report_debt_info_i
CreateDate: 20230630
FileName:   ${iel_data_path}/rwas_rwa_report_debt_info.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,data_date
,replace(replace(t1.loan_ref_id,chr(13),''),chr(10),'') as loan_ref_id
,replace(replace(t1.src_loan_ref_no,chr(13),''),chr(10),'') as src_loan_ref_no
,replace(replace(t1.accountrefcd,chr(13),''),chr(10),'') as accountrefcd
,replace(replace(t1.product_name,chr(13),''),chr(10),'') as product_name
,start_date
,due_date
,replace(replace(t1.org_cd,chr(13),''),chr(10),'') as org_cd
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.ccp_type_cd,chr(13),''),chr(10),'') as ccp_type_cd
,replace(replace(t1.assettype_id,chr(13),''),chr(10),'') as assettype_id
,replace(replace(t1.subject_cd,chr(13),''),chr(10),'') as subject_cd
,replace(replace(t1.interest_receive_subject_cd,chr(13),''),chr(10),'') as interest_receive_subject_cd
,replace(replace(t1.accrual_class_subject_cd,chr(13),''),chr(10),'') as accrual_class_subject_cd
,replace(replace(t1.interest_adjust_subject_cd,chr(13),''),chr(10),'') as interest_adjust_subject_cd
,replace(replace(t1.fairvalue_changes_subject_cd,chr(13),''),chr(10),'') as fairvalue_changes_subject_cd
,replace(replace(t1.depre_amortizat_subject_cd,chr(13),''),chr(10),'') as depre_amortizat_subject_cd
,replace(replace(t1.provision_single_subject_cd,chr(13),''),chr(10),'') as provision_single_subject_cd
,asset_balance
,asset_balance_hcurr
,receivable_int
,accrued_int
,int_adj
,fair_value_change
,depre_amortizat_assets
,provision
,ead_orig
,ccf
,ccf_ead
,ead_provision
,replace(replace(t1.portfoliotypedesc,chr(13),''),chr(10),'') as portfoliotypedesc
,rwbandid
,ccy_mismatch
,allocatedcrm
,crm_rwbandid_wtd
,crm_ncover_rwaamount
,crm_cover_rwaamount
,rwaamount
,replace(replace(t1.on_off_id,chr(13),''),chr(10),'') as on_off_id

from ${iol_schema}.rwas_rwa_report_debt_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rwas_rwa_report_debt_info.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
