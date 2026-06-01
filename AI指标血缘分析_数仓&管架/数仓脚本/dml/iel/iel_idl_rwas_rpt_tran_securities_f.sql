: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rwas_rpt_tran_securities_f
CreateDate: 20241128
FileName:   ${iel_data_path}/rwas_rpt_tran_securities.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.data_date as data_date
,t1.loan_ref_no as loan_ref_no
,t1.sec_no as sec_no
,t1.sec_name as sec_name
,t1.product_no as product_no
,t1.product_name as product_name
,t1.loan_ref_desc as loan_ref_desc
,t1.tradetypeid as tradetypeid
,t1.asset_thd_cls_cd as asset_thd_cls_cd
,t1.s_grade as s_grade
,t1.grade as grade
,t1.int_rat_adj_way_cd as int_rat_adj_way_cd
,t1.coupon as coupon
,t1.start_date as start_date
,t1.due_date as due_date
,t1.next_reval_date as next_reval_date
,t1.rema__reval_date as rema__reval_date
,t1.remainingmaturity as remainingmaturity
,t1.org_cd as org_cd
,t1.org_name as org_name
,t1.cust_no as cust_no
,t1.cust_name as cust_name
,t1.ccp_type_cd as ccp_type_cd
,t1.ccp_type_name as ccp_type_name
,t1.sec_type_cd as sec_type_cd
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
,t1.ccy_cd as ccy_cd
,t1.ccy_name as ccy_name
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
,t1.rate_sec_type_cd as rate_sec_type_cd
,t1.specific_risk_ratio as specific_risk_ratio
,t1.spec_risk_capital_amount as spec_risk_capital_amount
,t1.coupon_flag as coupon_flag
,t1.mat_bucketid as mat_bucketid
,t1.specific_risk_charge as specific_risk_charge
,t1.exposureamount as exposureamount
,t1.general_risk_capital_amount as general_risk_capital_amount
,t1.due_date_risk as due_date_risk
,t1.rwaamount as rwaamount
,t1.scra_rating as scra_rating
,t1.orig_maturity as orig_maturity
,t1.load_date as load_date

from ${idl_schema}.rwas_rpt_tran_securities t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rwas_rpt_tran_securities.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
