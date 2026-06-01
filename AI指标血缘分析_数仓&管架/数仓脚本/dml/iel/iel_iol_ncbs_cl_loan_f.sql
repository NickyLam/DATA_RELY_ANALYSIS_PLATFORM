: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_cl_loan_f
CreateDate: 20221114
FileName:   ${iel_data_path}/ncbs_cl_loan.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.grace_term_type,chr(13),''),chr(10),'') as grace_term_type
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.branch,chr(13),''),chr(10),'') as branch
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.client_short,chr(13),''),chr(10),'') as client_short
,replace(replace(t1.contract_no,chr(13),''),chr(10),'') as contract_no
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.acct_status_prev,chr(13),''),chr(10),'') as acct_status_prev
,replace(replace(t1.alloc_seq_fee,chr(13),''),chr(10),'') as alloc_seq_fee
,replace(replace(t1.alloc_seq_int,chr(13),''),chr(10),'') as alloc_seq_int
,replace(replace(t1.alloc_seq_odi,chr(13),''),chr(10),'') as alloc_seq_odi
,replace(replace(t1.alloc_seq_odp,chr(13),''),chr(10),'') as alloc_seq_odp
,replace(replace(t1.alloc_seq_pri,chr(13),''),chr(10),'') as alloc_seq_pri
,replace(replace(t1.alloc_seq_type,chr(13),''),chr(10),'') as alloc_seq_type
,replace(replace(t1.analysis1,chr(13),''),chr(10),'') as analysis1
,replace(replace(t1.analysis2,chr(13),''),chr(10),'') as analysis2
,replace(replace(t1.analysis3,chr(13),''),chr(10),'') as analysis3
,replace(replace(t1.anytime_rec_flag,chr(13),''),chr(10),'') as anytime_rec_flag
,replace(replace(t1.arr_bank,chr(13),''),chr(10),'') as arr_bank
,replace(replace(t1.auto_loan_classify_flag,chr(13),''),chr(10),'') as auto_loan_classify_flag
,replace(replace(t1.auto_settle_flag,chr(13),''),chr(10),'') as auto_settle_flag
,replace(replace(t1.buy_bank,chr(13),''),chr(10),'') as buy_bank
,calc_times
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.credit_no,chr(13),''),chr(10),'') as credit_no
,replace(replace(t1.dd_inc_ind,chr(13),''),chr(10),'') as dd_inc_ind
,replace(replace(t1.entrust_settle_flag,chr(13),''),chr(10),'') as entrust_settle_flag
,replace(replace(t1.five_category,chr(13),''),chr(10),'') as five_category
,replace(replace(t1.force_grace_flag,chr(13),''),chr(10),'') as force_grace_flag
,replace(replace(t1.grace_charge_int_flag,chr(13),''),chr(10),'') as grace_charge_int_flag
,replace(replace(t1.grace_type,chr(13),''),chr(10),'') as grace_type
,replace(replace(t1.guaranty_style,chr(13),''),chr(10),'') as guaranty_style
,replace(replace(t1.int_penalty,chr(13),''),chr(10),'') as int_penalty
,replace(replace(t1.lender,chr(13),''),chr(10),'') as lender
,replace(replace(t1.loan_class,chr(13),''),chr(10),'') as loan_class
,replace(replace(t1.manager_bank,chr(13),''),chr(10),'') as manager_bank
,replace(replace(t1.marketing_prod_desc,chr(13),''),chr(10),'') as marketing_prod_desc
,max_extend_times
,replace(replace(t1.od_int_penalty_flag,chr(13),''),chr(10),'') as od_int_penalty_flag
,replace(replace(t1.od_pri_penalty_flag,chr(13),''),chr(10),'') as od_pri_penalty_flag
,replace(replace(t1.old_loan_no,chr(13),''),chr(10),'') as old_loan_no
,replace(replace(t1.pause_int_ind,chr(13),''),chr(10),'') as pause_int_ind
,replace(replace(t1.pre_rate_type,chr(13),''),chr(10),'') as pre_rate_type
,replace(replace(t1.pre_repay_deal,chr(13),''),chr(10),'') as pre_repay_deal
,replace(replace(t1.pri_penalty_flag,chr(13),''),chr(10),'') as pri_penalty_flag
,replace(replace(t1.purpose,chr(13),''),chr(10),'') as purpose
,replace(replace(t1.recourse_ind,chr(13),''),chr(10),'') as recourse_ind
,replace(replace(t1.related_loan_no,chr(13),''),chr(10),'') as related_loan_no
,replace(replace(t1.sched_mode,chr(13),''),chr(10),'') as sched_mode
,replace(replace(t1.sof_state,chr(13),''),chr(10),'') as sof_state
,replace(replace(t1.sold_ind,chr(13),''),chr(10),'') as sold_ind
,replace(replace(t1.stamp_tax_flag,chr(13),''),chr(10),'') as stamp_tax_flag
,syn_dd_times
,replace(replace(t1.sync_final_billing_flag,chr(13),''),chr(10),'') as sync_final_billing_flag
,replace(replace(t1.taxable_ind,chr(13),''),chr(10),'') as taxable_ind
,replace(replace(t1.tf_loan_type,chr(13),''),chr(10),'') as tf_loan_type
,replace(replace(t1.tf_ref_no,chr(13),''),chr(10),'') as tf_ref_no
,replace(replace(t1.trade_ref_no,chr(13),''),chr(10),'') as trade_ref_no
,replace(replace(t1.accounting_status,chr(13),''),chr(10),'') as accounting_status
,replace(replace(t1.accounting_status_prev,chr(13),''),chr(10),'') as accounting_status_prev
,replace(replace(t1.loan_status,chr(13),''),chr(10),'') as loan_status
,replace(replace(t1.hunting_status,chr(13),''),chr(10),'') as hunting_status
,accounting_status_upd_date
,acct_status_upd_date
,closed_date
,dd_end_date
,last_change_date
,maturity_date
,sign_date
,special_sign_date
,ssi_end_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.sof_country,chr(13),''),chr(10),'') as sof_country
,replace(replace(t1.acct_close_reason,chr(13),''),chr(10),'') as acct_close_reason
,replace(replace(t1.acct_close_user_id,chr(13),''),chr(10),'') as acct_close_user_id
,replace(replace(t1.close_reason,chr(13),''),chr(10),'') as close_reason
,commit_amt
,contribute_amt
,grace_period
,replace(replace(t1.last_change_user_id,chr(13),''),chr(10),'') as last_change_user_id
,replace(replace(t1.loan_no,chr(13),''),chr(10),'') as loan_no
,replace(replace(t1.marketing_prod,chr(13),''),chr(10),'') as marketing_prod
,od_grace_period_days
,orig_loan_amt
,pr_min_amt
,pre_pay_rate
,ui_min_amt
,ui_prepayment
,replace(replace(t1.grace_int_flag,chr(13),''),chr(10),'') as grace_int_flag
,replace(replace(t1.grace_pri_flag,chr(13),''),chr(10),'') as grace_pri_flag
,replace(replace(t1.auto_settle_sod_int_flag,chr(13),''),chr(10),'') as auto_settle_sod_int_flag
,replace(replace(t1.auto_settle_sod_pri_flag,chr(13),''),chr(10),'') as auto_settle_sod_pri_flag
,replace(replace(t1.before_income_flag,chr(13),''),chr(10),'') as before_income_flag
,replace(replace(t1.grace_charge_odi_flag,chr(13),''),chr(10),'') as grace_charge_odi_flag
,compensate_ratio
,replace(replace(t1.cross_period_flag,chr(13),''),chr(10),'') as cross_period_flag
,due_compensate_period
,replace(replace(t1.receive_anytime_flag,chr(13),''),chr(10),'') as receive_anytime_flag
,replace(replace(t1.corp_size,chr(13),''),chr(10),'') as corp_size
,replace(replace(t1.gear_prod_flag,chr(13),''),chr(10),'') as gear_prod_flag
,replace(replace(t1.econ_department_type,chr(13),''),chr(10),'') as econ_department_type
,replace(replace(t1.is_individual_busi,chr(13),''),chr(10),'') as is_individual_busi
,replace(replace(t1.amount_nature,chr(13),''),chr(10),'') as amount_nature
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.ncbs_cl_loan t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_cl_loan.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
