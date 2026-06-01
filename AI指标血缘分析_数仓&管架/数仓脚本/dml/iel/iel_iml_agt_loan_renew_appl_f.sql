: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_renew_appl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_renew_appl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.appl_id,chr(13),''),chr(10),'') as appl_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.out_acct_num,chr(13),''),chr(10),'') as out_acct_num
    ,t.out_acct_dt as out_acct_dt
    ,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
    ,replace(replace(t.loan_org_id,chr(13),''),chr(10),'') as loan_org_id
    ,t.dubil_bal as dubil_bal
    ,replace(replace(t.new_reval_way_cd,chr(13),''),chr(10),'') as new_reval_way_cd
    ,replace(replace(t.new_base_rat_cd,chr(13),''),chr(10),'') as new_base_rat_cd
    ,t.new_nomal_loan_int_rat_fl_rt as new_nomal_loan_int_rat_fl_rt
    ,t.new_ovdue_loan_int_rat_fl_rt as new_ovdue_loan_int_rat_fl_rt
    ,t.new_nomal_loan_exec_int_rat as new_nomal_loan_exec_int_rat
    ,t.new_ovdue_loan_exec_int_rat as new_ovdue_loan_exec_int_rat
    ,t.new_exp_dt as new_exp_dt
    ,t.tran_dt as tran_dt
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,replace(replace(t.out_acct_tm,chr(13),''),chr(10),'') as out_acct_tm
    ,replace(replace(t.appl_status_cd,chr(13),''),chr(10),'') as appl_status_cd
    ,t.renew_effect_dt as renew_effect_dt
    ,t.create_dt as create_dt
    ,t.update_dt as update_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_loan_renew_appl t
  where t.create_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_renew_appl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes