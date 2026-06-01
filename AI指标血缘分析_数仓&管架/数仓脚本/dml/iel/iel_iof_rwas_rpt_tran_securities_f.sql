: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_rwas_rpt_tran_securities_f
CreateDate: 20260127
FileName:   ${iel_data_path}/rwas_rpt_tran_securities.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,data_date
,replace(replace(t1.loan_ref_no,chr(13),''),chr(10),'') as loan_ref_no
,replace(replace(t1.sec_no,chr(13),''),chr(10),'') as sec_no
,replace(replace(t1.sec_name,chr(13),''),chr(10),'') as sec_name
,replace(replace(t1.product_no,chr(13),''),chr(10),'') as product_no
,replace(replace(t1.product_name,chr(13),''),chr(10),'') as product_name
,replace(replace(t1.loan_ref_desc,chr(13),''),chr(10),'') as loan_ref_desc
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
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.ccp_type_cd,chr(13),''),chr(10),'') as ccp_type_cd
,replace(replace(t1.ccp_type_name,chr(13),''),chr(10),'') as ccp_type_name
,replace(replace(t1.sec_type_cd,chr(13),''),chr(10),'') as sec_type_cd
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
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.ccy_name,chr(13),''),chr(10),'') as ccy_name
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
,replace(replace(t1.rate_sec_type_cd,chr(13),''),chr(10),'') as rate_sec_type_cd
,replace(replace(t1.specific_risk_ratio,chr(13),''),chr(10),'') as specific_risk_ratio
,spec_risk_capital_amount
,replace(replace(t1.coupon_flag,chr(13),''),chr(10),'') as coupon_flag
,replace(replace(t1.mat_bucketid,chr(13),''),chr(10),'') as mat_bucketid
,replace(replace(t1.specific_risk_charge,chr(13),''),chr(10),'') as specific_risk_charge
,exposureamount
,general_risk_capital_amount
,due_date_risk
,rwaamount
,replace(replace(t1.scra_rating,chr(13),''),chr(10),'') as scra_rating
,orig_maturity
,replace(replace(t1.load_date,chr(13),''),chr(10),'') as load_date
,replace(replace(t1.final_weight,chr(13),''),chr(10),'') as final_weight

from ${iol_schema}.rwas_rpt_tran_securities t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rwas_rpt_tran_securities.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
