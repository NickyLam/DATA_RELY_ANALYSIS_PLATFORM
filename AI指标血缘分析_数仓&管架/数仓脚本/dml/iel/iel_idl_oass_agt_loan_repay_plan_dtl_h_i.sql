: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_repay_plan_dtl_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_loan_repay_plan_dtl_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.repay_plan_id as repay_plan_id
,t1.acct_id as acct_id
,t1.cust_id as cust_id
,t1.curr_pd as curr_pd
,t1.amt_type_cd as amt_type_cd
,t1.value_dt as value_dt
,t1.int_set_dt as int_set_dt
,t1.plan_repay_amt as plan_repay_amt
,t1.aldy_paid_amt as aldy_paid_amt
,t1.pric_amt as pric_amt
,t1.iss_flg as iss_flg
,t1.advise_odd_no as advise_odd_no
,t1.iss_int_rat as iss_int_rat
,t1.iss_amt as iss_amt
,t1.doc_bal as doc_bal
,t1.doc_exp_dt as doc_exp_dt
,t1.grace_dt as grace_dt
,t1.tran_dt as tran_dt
,t1.stl_dt as stl_dt
,t1.full_amt_callbk_flg as full_amt_callbk_flg
,t1.doc_create_way_cd as doc_create_way_cd
,t1.tran_ref_no as tran_ref_no
,t1.tax_category_cd as tax_category_cd
,t1.tax_rat as tax_rat
,t1.tax_amt as tax_amt
,t1.doc_ld_unpaid_amt as doc_ld_unpaid_amt
,t1.ld_bal_update_dt as ld_bal_update_dt
,t1.delay_pay_int_flg as delay_pay_int_flg
,t1.wrt_off_pric as wrt_off_pric
,t1.tran_teller_id as tran_teller_id
,t1.final_modif_dt as final_modif_dt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_loan_repay_plan_dtl_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_repay_plan_dtl_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
