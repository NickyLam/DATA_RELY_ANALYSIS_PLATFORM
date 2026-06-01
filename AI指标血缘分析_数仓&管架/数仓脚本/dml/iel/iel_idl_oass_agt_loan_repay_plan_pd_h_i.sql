: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_repay_plan_pd_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_loan_repay_plan_pd_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.acct_id as acct_id
,t1.curr_pd as curr_pd
,t1.cust_id as cust_id
,t1.accti_status_cd as accti_status_cd
,t1.last_accti_status_cd as last_accti_status_cd
,t1.exp_dt as exp_dt
,t1.ovdue_pric as ovdue_pric
,t1.ld_ovdue_pric as ld_ovdue_pric
,t1.ovdue_int as ovdue_int
,t1.ld_ovdue_int as ld_ovdue_int
,t1.ovdue_pnlt_bal as ovdue_pnlt_bal
,t1.ld_ovdue_pnlt as ld_ovdue_pnlt
,t1.comp_int_bal as comp_int_bal
,t1.ld_ovdue_comp_int as ld_ovdue_comp_int
,t1.grace_period_int as grace_period_int
,t1.ld_grace_period_int as ld_grace_period_int
,t1.grace_period_comp_int as grace_period_comp_int
,t1.ld_grace_period_comp_int as ld_grace_period_comp_int
,t1.grace_period_pnlt as grace_period_pnlt
,t1.ld_grace_period_pnlt as ld_grace_period_pnlt
,t1.grace_period_pric as grace_period_pric
,t1.ld_grace_period_pric as ld_grace_period_pric
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_loan_repay_plan_pd_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_repay_plan_pd_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
