: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_cap_supv_acct_bal_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cap_supv_acct_bal_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.vtual_acct_id,chr(13),''),chr(10),'') as vtual_acct_id
,t1.actl_bal as actl_bal
,t1.aval_bal as aval_bal
,t1.comm_fee_bal as comm_fee_bal
,t1.int as int
,t1.cust_tot_bal as cust_tot_bal
,t1.offs_bal as offs_bal
,t1.mdl_stl_bal as mdl_stl_bal
,t1.ret_my_bal as ret_my_bal
,t1.guar_bal as guar_bal
,t1.ld_actl_bal as ld_actl_bal
,t1.ld_aval_bal as ld_aval_bal
,t1.ld_comm_fee_bal as ld_comm_fee_bal
,t1.ld_int as ld_int
,t1.ld_cust_tot_bal as ld_cust_tot_bal
,t1.ld_offs_bal as ld_offs_bal
,t1.ld_mdl_stl_bal as ld_mdl_stl_bal
,t1.ld_ret_my_bal as ld_ret_my_bal
,t1.ld_guar_bal as ld_guar_bal
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,t1.open_tm as open_tm
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_cap_supv_acct_bal_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cap_supv_acct_bal_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes