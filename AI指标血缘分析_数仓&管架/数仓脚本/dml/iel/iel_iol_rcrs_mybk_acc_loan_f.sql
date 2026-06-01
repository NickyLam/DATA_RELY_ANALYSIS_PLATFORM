: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_mybk_acc_loan_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_mybk_acc_loan.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.contract_no,chr(13),''),chr(10),'') as contract_no
,replace(replace(t.fund_seq_no,chr(13),''),chr(10),'') as fund_seq_no
,replace(replace(t.prod_code,chr(13),''),chr(10),'') as prod_code
,replace(replace(t.name,chr(13),''),chr(10),'') as name
,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t.loan_status,chr(13),''),chr(10),'') as loan_status
,replace(replace(t.loan_use,chr(13),''),chr(10),'') as loan_use
,replace(replace(t.use_area,chr(13),''),chr(10),'') as use_area
,replace(replace(t.apply_date,chr(13),''),chr(10),'') as apply_date
,replace(replace(t.encash_date,chr(13),''),chr(10),'') as encash_date
,replace(replace(t.currency,chr(13),''),chr(10),'') as currency
,t.encash_amt as encash_amt
,replace(replace(t.start_date,chr(13),''),chr(10),'') as start_date
,replace(replace(t.end_date,chr(13),''),chr(10),'') as end_date
,t.total_terms as total_terms
,replace(replace(t.repay_mode,chr(13),''),chr(10),'') as repay_mode
,t.grace_day as grace_day
,replace(replace(t.rate_type,chr(13),''),chr(10),'') as rate_type
,t.day_rate as day_rate
,replace(replace(t.prin_repay_frequency,chr(13),''),chr(10),'') as prin_repay_frequency
,replace(replace(t.int_repay_frequency,chr(13),''),chr(10),'') as int_repay_frequency
,replace(replace(t.guarantee_type,chr(13),''),chr(10),'') as guarantee_type
,replace(replace(t.credit_no,chr(13),''),chr(10),'') as credit_no
,replace(replace(t.encash_acct_type,chr(13),''),chr(10),'') as encash_acct_type
,replace(replace(t.encash_acct_name,chr(13),''),chr(10),'') as encash_acct_name
,replace(replace(t.encash_acct_no,chr(13),''),chr(10),'') as encash_acct_no
,replace(replace(t.encash_bank_name,chr(13),''),chr(10),'') as encash_bank_name
,replace(replace(t.repay_acct_type,chr(13),''),chr(10),'') as repay_acct_type
,replace(replace(t.repay_acct_name,chr(13),''),chr(10),'') as repay_acct_name
,replace(replace(t.repay_acct_no,chr(13),''),chr(10),'') as repay_acct_no
,replace(replace(t.repay_bank_name,chr(13),''),chr(10),'') as repay_bank_name
,replace(replace(t.bsn_type,chr(13),''),chr(10),'') as bsn_type
,replace(replace(t.settle_date,chr(13),''),chr(10),'') as settle_date
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.clear_date,chr(13),''),chr(10),'') as clear_date
,replace(replace(t.asset_class,chr(13),''),chr(10),'') as asset_class
,replace(replace(t.accrued_status,chr(13),''),chr(10),'') as accrued_status
,replace(replace(t.next_repay_date,chr(13),''),chr(10),'') as next_repay_date
,t.unclear_terms as unclear_terms
,t.ovd_terms as ovd_terms
,t.prin_ovd_days as prin_ovd_days
,t.int_ovd_days as int_ovd_days
,t.prin_bal as prin_bal
,t.ovd_prin_bal as ovd_prin_bal
,t.int_bal as int_bal
,t.ovd_int_bal as ovd_int_bal
,t.ovd_prin_pnlt_bal as ovd_prin_pnlt_bal
,t.ovd_int_pnlt_bal as ovd_int_pnlt_bal
,replace(replace(t.cus_id,chr(13),''),chr(10),'') as cus_id
,replace(replace(t.cus_mgr_id,chr(13),''),chr(10),'') as cus_mgr_id
,replace(replace(t.industry_type,chr(13),''),chr(10),'') as industry_type
,replace(replace(t.ip_id,chr(13),''),chr(10),'') as ip_id
,replace(replace(t.write_off,chr(13),''),chr(10),'') as write_off
,t.exec_rate as exec_rate
,t.lpr as lpr
,t.float_rate_bp as float_rate_bp
,replace(replace(t.rate_lprtype,chr(13),''),chr(10),'') as rate_lprtype
,replace(replace(t.rate_float_mode,chr(13),''),chr(10),'') as rate_float_mode
,replace(replace(t.opt_type,chr(13),''),chr(10),'') as opt_type
,replace(replace(t.asset_three_type_cd,chr(13),''),chr(10),'') as asset_three_type_cd
,replace(replace(t.biz_type,chr(13),''),chr(10),'') as biz_type
,replace(replace(t.is_bank_rel,chr(13),''),chr(10),'') as is_bank_rel
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.RCRS_MYBK_ACC_LOAN t 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_mybk_acc_loan.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes