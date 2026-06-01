: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_loan_int_rat_adj_flow_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_loan_int_rat_adj_flow_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.tran_dt as tran_dt
,replace(replace(t.tran_flow,chr(13),''),chr(10),'') as tran_flow
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.loan_org_id,chr(13),''),chr(10),'') as loan_org_id
,t.new_nomal_loan_int_rat_fl_rt as new_nomal_loan_int_rat_fl_rt
,t.new_ovdue_loan_int_rat_fl_rt as new_ovdue_loan_int_rat_fl_rt
,t.new_nomal_loan_exec_int_rat as new_nomal_loan_exec_int_rat
,t.new_ovdue_loan_exec_int_rat as new_ovdue_loan_exec_int_rat
,t.effect_dt as effect_dt
,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
from ${iml_schema}.evt_loan_int_rat_adj_flow t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_loan_int_rat_adj_flow_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes