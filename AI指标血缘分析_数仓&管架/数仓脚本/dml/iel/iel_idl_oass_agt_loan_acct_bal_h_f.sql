: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_acct_bal_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_loan_acct_bal_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.acct_id as acct_id
,t1.cust_id as cust_id
,t1.distr_amt as distr_amt
,t1.ld_distr_amt as ld_distr_amt
,t1.nomal_pric as nomal_pric
,t1.ld_nomal_pric as ld_nomal_pric
,t1.ovdue_pric as ovdue_pric
,t1.ld_ovdue_pric as ld_ovdue_pric
,t1.ovdue_int as ovdue_int
,t1.ld_ovdue_int as ld_ovdue_int
,t1.ovdue_pnlt as ovdue_pnlt
,t1.ld_ovdue_pnlt as ld_ovdue_pnlt
,t1.ovdue_comp_int as ovdue_comp_int
,t1.ld_ovdue_comp_int as ld_ovdue_comp_int
,t1.grace_period_pric as grace_period_pric
,t1.ld_grace_period_pric as ld_grace_period_pric
,t1.grace_period_int as grace_period_int
,t1.ld_grace_period_int as ld_grace_period_int
,t1.grace_period_pnlt as grace_period_pnlt
,t1.ld_grace_period_pnlt as ld_grace_period_pnlt
,t1.grace_period_comp_int as grace_period_comp_int
,t1.ld_grace_period_comp_int as ld_grace_period_comp_int
,t1.last_activ_acct_dt as last_activ_acct_dt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_loan_acct_bal_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_acct_bal_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
