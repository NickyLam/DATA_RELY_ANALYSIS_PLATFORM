: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rwas_rwa_report_tran_securities_f
CreateDate: 20240312
FileName:   ${iel_data_path}/rwas_rwa_report_tran_securities.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,data_date
,loan_ref_id
,replace(replace(t1.loan_ref_no,chr(13),''),chr(10),'') as loan_ref_no
,replace(replace(t1.sec_no,chr(13),''),chr(10),'') as sec_no
,replace(replace(t1.tradetypeid,chr(13),''),chr(10),'') as tradetypeid
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.s_grade,chr(13),''),chr(10),'') as s_grade
,replace(replace(t1.grade,chr(13),''),chr(10),'') as grade
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.coupon,chr(13),''),chr(10),'') as coupon
,start_date
,due_date
,next_reval_date
,rema__reval_date
,remainingmaturity
,replace(replace(t1.org_cd,chr(13),''),chr(10),'') as org_cd
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.ccp_type_cd,chr(13),''),chr(10),'') as ccp_type_cd
,replace(replace(t1.sec_type_cd,chr(13),''),chr(10),'') as sec_type_cd
,replace(replace(t1.assettype_id,chr(13),''),chr(10),'') as assettype_id
,replace(replace(t1.subject_cd,chr(13),''),chr(10),'') as subject_cd
,replace(replace(t1.interest_receive_subject_cd,chr(13),''),chr(10),'') as interest_receive_subject_cd
,replace(replace(t1.accrual_class_subject_cd,chr(13),''),chr(10),'') as accrual_class_subject_cd
,replace(replace(t1.interest_adjust_subject_cd,chr(13),''),chr(10),'') as interest_adjust_subject_cd
,replace(replace(t1.fairvalue_changes_subject_cd,chr(13),''),chr(10),'') as fairvalue_changes_subject_cd
,replace(replace(t1.provision_single_subject_cd,chr(13),''),chr(10),'') as provision_single_subject_cd
,asset_balance
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,asset_balance_hcurr
,receivable_int
,accrued_int
,int_adj
,fair_value_change
,provision
,amt
,replace(replace(t1.rate_sec_type_cd,chr(13),''),chr(10),'') as rate_sec_type_cd
,specific_risk_ratio
,spec_risk_capital_amount
,replace(replace(t1.coupon_flag,chr(13),''),chr(10),'') as coupon_flag
,replace(replace(t1.mat_bucketid,chr(13),''),chr(10),'') as mat_bucketid
,replace(replace(t1.specific_risk_charge,chr(13),''),chr(10),'') as specific_risk_charge
,exposureamount
,rwaamount
,replace(replace(t1.sec_name,chr(13),''),chr(10),'') as sec_name
,replace(replace(t1.product_name,chr(13),''),chr(10),'') as product_name
,general_risk_capital_amount

from ${iol_schema}.rwas_rwa_report_tran_securities t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rwas_rwa_report_tran_securities.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
