: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_loan_distr_flow_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_loan_distr_flow_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.distr_dt as distr_dt
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t.distr_tm,chr(13),''),chr(10),'') as distr_tm
,replace(replace(t.distr_org_id,chr(13),''),chr(10),'') as distr_org_id
,replace(replace(t.loan_cont_id,chr(13),''),chr(10),'') as loan_cont_id
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,replace(replace(t.loan_subj_id,chr(13),''),chr(10),'') as loan_subj_id
,t.exec_int_rat as exec_int_rat
,t.exp_dt as exp_dt
,replace(replace(t.tran_cate_cd,chr(13),''),chr(10),'') as tran_cate_cd
,replace(replace(t.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t.recvbl_sub_acct_id,chr(13),''),chr(10),'') as recvbl_sub_acct_id
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.distr_amt as distr_amt
,replace(replace(t.teller_id,chr(13),''),chr(10),'') as teller_id
,replace(replace(t.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
from ${iml_schema}.evt_loan_distr_flow t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_loan_distr_flow_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes