: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_loan_prd_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_loan_prd_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.dbill_num,chr(13),''),chr(10),'') as dbill_num
,replace(replace(t1.acct_num_id,chr(13),''),chr(10),'') as acct_num_id
,replace(replace(t1.contr_num,chr(13),''),chr(10),'') as contr_num
,replace(replace(t1.dd_org_num,chr(13),''),chr(10),'') as dd_org_num
,replace(replace(t1.oper_org_num,chr(13),''),chr(10),'') as oper_org_num
,replace(replace(t1.oper_pty_mgr_num,chr(13),''),chr(10),'') as oper_pty_mgr_num
,replace(replace(t1.ccy_encd,chr(13),''),chr(10),'') as ccy_encd
,replace(replace(t1.coa_encd,chr(13),''),chr(10),'') as coa_encd
,replace(replace(t1.loan_typ,chr(13),''),chr(10),'') as loan_typ
,replace(replace(t1.biz_breed,chr(13),''),chr(10),'') as biz_breed
,replace(replace(t1.bcs_cust_nbr,chr(13),''),chr(10),'') as bcs_cust_nbr
,replace(replace(t1.pty_name,chr(13),''),chr(10),'') as pty_name
,replace(replace(t1.loan_appln_cust_nbr,chr(13),''),chr(10),'') as loan_appln_cust_nbr
,replace(replace(t1.loan_appln_name,chr(13),''),chr(10),'') as loan_appln_name
,replace(replace(t1.categ5,chr(13),''),chr(10),'') as categ5
,replace(replace(t1.guar_mode,chr(13),''),chr(10),'') as guar_mode
,t1.loan_issue_dt as loan_issue_dt
,replace(replace(t1.dd_seq_num,chr(13),''),chr(10),'') as dd_seq_num
,t1.due_dt as due_dt
,t1.exec_rate as exec_rate
,t1.base_rate as base_rate
,t1.ovdue_loan_rate as ovdue_loan_rate
,replace(replace(t1.repay_mode,chr(13),''),chr(10),'') as repay_mode
,t1.repay_intrv_days as repay_intrv_days
,replace(replace(t1.loan_status,chr(13),''),chr(10),'') as loan_status
,t1.total_term as total_term
,t1.curr_bch_nbr as curr_bch_nbr
,t1.term_repay_amt as term_repay_amt
,replace(replace(t1.term_corp_cd,chr(13),''),chr(10),'') as term_corp_cd
,t1.loan_term as loan_term
,t1.loan_amt as loan_amt
,t1.loan_bal as loan_bal
,t1.np_loan_bal as np_loan_bal
,t1.loan_bal_mon_accum as loan_bal_mon_accum
,t1.loan_bal_qtr_accum as loan_bal_qtr_accum
,t1.loan_bal_year_accum as loan_bal_year_accum
,t1.loan_bal_mavg as loan_bal_mavg
,t1.loan_bal_qavg as loan_bal_qavg
,t1.loan_bal_yavg as loan_bal_yavg
,t1.bal_ratio_last_day as bal_ratio_last_day
,t1.bal_ratio_last_mon as bal_ratio_last_mon
,t1.bal_ratio_last_qtr as bal_ratio_last_qtr
,t1.bal_ratio_ly as bal_ratio_ly
,t1.mavg_ratio_last_day as mavg_ratio_last_day
,t1.mavg_ratio_last_mon as mavg_ratio_last_mon
,t1.mavg_ratio_last_qtr as mavg_ratio_last_qtr
,t1.mavg_ratio_ly as mavg_ratio_ly
,t1.qavg_ratio_last_day as qavg_ratio_last_day
,t1.qavg_ratio_last_mon as qavg_ratio_last_mon
,t1.qavg_ratio_last_qtr as qavg_ratio_last_qtr
,t1.qavg_ratio_ly as qavg_ratio_ly
,t1.yavg_ratio_last_day as yavg_ratio_last_day
,t1.yavg_ratio_last_mon as yavg_ratio_last_mon
,t1.yavg_ratio_last_qtr as yavg_ratio_last_qtr
,t1.yavg_ratio_ly as yavg_ratio_ly
,replace(replace(t1.dd_acct_num,chr(13),''),chr(10),'') as dd_acct_num
,replace(replace(t1.repay_acct_num,chr(13),''),chr(10),'') as repay_acct_num
,t1.norm_rate_float_ratio as norm_rate_float_ratio
,t1.ovdue_rate_float_ratio as ovdue_rate_float_ratio
,t1.curr_rate_eff_day as curr_rate_eff_day
,t1.next_rate_adj_day as next_rate_adj_day
,t1.ovdue_amt as ovdue_amt
,t1.ovdue_days as ovdue_days
,replace(replace(t1.ovdue_term,chr(13),''),chr(10),'') as ovdue_term
,t1.rcva_int as rcva_int
,t1.owe_int as owe_int
,t1.acr_intr as acr_intr
,t1.paid_prcp as paid_prcp
,t1.paid_int as paid_int
,t1.paid_pnlt as paid_pnlt
,t1.paid_compd_int as paid_compd_int
,t1.paid_cost as paid_cost
,t1.aggr_rcvable_int_amt as aggr_rcvable_int_amt
,t1.int_on_bs_bal as int_on_bs_bal
,t1.int_off_bs_bal as int_off_bs_bal
,t1.prev_adj_int_dt as prev_adj_int_dt
,t1.next_adj_int_dt as next_adj_int_dt
,replace(replace(t1.float_freq_cd,chr(13),''),chr(10),'') as float_freq_cd
,replace(replace(t1.rate_base_typ_cd,chr(13),''),chr(10),'') as rate_base_typ_cd
,replace(replace(t1.loan_typ_cd,chr(13),''),chr(10),'') as loan_typ_cd
from ${idl_schema}.hdws_dul_d_ccrm_loan_prd_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_loan_prd_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes