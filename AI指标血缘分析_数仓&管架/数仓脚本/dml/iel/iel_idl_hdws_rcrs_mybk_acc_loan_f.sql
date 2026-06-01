: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_rcrs_mybk_acc_loan_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_rcrs_mybk_acc_loan.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.contract_no
,t1.fund_seq_no
,t1.prod_code
,t1.name
,t1.cert_type
,t1.cert_no
,t1.loan_status
,t1.loan_use
,t1.use_area
,t1.apply_date
,t1.encash_date
,t1.currency
,t1.encash_amt
,t1.start_date
,t1.end_date
,t1.total_terms
,t1.repay_mode
,t1.grace_day
,t1.rate_type
,t1.day_rate
,t1.prin_repay_frequency
,t1.int_repay_frequency
,t1.guarantee_type
,t1.credit_no
,t1.encash_acct_type
,t1.encash_acct_name
,t1.encash_acct_no
,t1.encash_bank_name
,t1.repay_acct_type
,t1.repay_acct_name
,t1.repay_acct_no
,t1.repay_bank_name
,t1.bsn_type
,t1.settle_date
,t1.status
,t1.clear_date
,t1.asset_class
,t1.accrued_status
,t1.next_repay_date
,t1.unclear_terms
,t1.ovd_terms
,t1.prin_ovd_days
,t1.int_ovd_days
,t1.prin_bal
,t1.ovd_prin_bal
,t1.int_bal
,t1.ovd_int_bal
,t1.ovd_prin_pnlt_bal
,t1.ovd_int_pnlt_bal
,t1.industry_type
,t1.cus_id
,t1.cus_mgr_id
,t1.ip_id
,t1.write_off
,t1.exec_rate
,t1.lpr
,t1.float_rate_bp
,t1.rate_lprtype
,t1.rate_float_mode
,t1.opt_type
,t1.asset_three_type_cd
,t1.biz_type
,t1.is_bank_rel
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_rcrs_mybk_acc_loan t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_rcrs_mybk_acc_loan.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes