: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_loan_renew_appl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_renew_appl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.appl_id
,t1.lp_id
,t1.out_acct_num
,t1.out_acct_dt
,t1.dubil_id
,t1.loan_org_id
,t1.dubil_bal
,t1.new_reval_way_cd
,t1.new_base_rat_cd
,t1.new_nomal_loan_int_rat_fl_rt
,t1.new_ovdue_loan_int_rat_fl_rt
,t1.new_nomal_loan_exec_int_rat
,t1.new_ovdue_loan_exec_int_rat
,t1.new_exp_dt
,t1.tran_dt
,t1.acct_id
,t1.tran_flow_num
,t1.out_acct_tm
,t1.appl_status_cd
,t1.renew_effect_dt
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_loan_renew_appl t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_renew_appl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes