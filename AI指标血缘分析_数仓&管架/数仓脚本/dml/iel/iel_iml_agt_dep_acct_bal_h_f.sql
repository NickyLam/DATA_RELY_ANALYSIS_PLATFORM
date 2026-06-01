: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_dep_acct_bal_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_dep_acct_bal_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,curr_bal
,ld_bal
,acct_inpwn_amt
,finc_rgst_b_acct_amt
,long_hang_amt
,acct_od_amt
,od_tot_amt
,last_activ_acct_dt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id

from ${iml_schema}.agt_dep_acct_bal_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_acct_bal_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
