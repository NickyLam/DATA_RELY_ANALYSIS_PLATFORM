: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_loan_acct_bal_h_f
CreateDate: 20230823
FileName:   ${iel_data_path}/agt_loan_acct_bal_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,distr_amt
,ld_distr_amt
,nomal_pric
,ld_nomal_pric
,ovdue_pric
,ld_ovdue_pric
,ovdue_int
,ld_ovdue_int
,ovdue_pnlt
,ld_ovdue_pnlt
,ovdue_comp_int
,ld_ovdue_comp_int
,grace_period_pric
,ld_grace_period_pric
,grace_period_int
,ld_grace_period_int
,grace_period_pnlt
,ld_grace_period_pnlt
,grace_period_comp_int
,ld_grace_period_comp_int
,last_activ_acct_dt

from ${iml_schema}.agt_loan_acct_bal_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_acct_bal_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
