: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_retl_loan_adv_repay_appl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_loan_adv_repay_appl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.appl_id as appl_id
,t.lp_id as lp_id
,t.appl_flow_num as appl_flow_num
,t.dubil_id as dubil_id
,t.cont_id as cont_id
,t.cust_id as cust_id
,t.cust_name as cust_name
,t.curr_cd as curr_cd
,t.dubil_amt as dubil_amt
,t.dubil_bal as dubil_bal
,t.loan_year_int_rat as loan_year_int_rat
,t.value_dt as value_dt
,t.exp_dt as exp_dt
,t.repay_way_cd as repay_way_cd
,t.adv_repay_amt as adv_repay_amt
,t.cust_mgr_id as cust_mgr_id
,t.appl_dt as appl_dt
,t.apv_status_cd as apv_status_cd
,t.int as int
,t.adv_repay_type_cd as adv_repay_type_cd
,t.adv_repay_cap_src_cd as adv_repay_cap_src_cd
,t.adv_repay_penalty as adv_repay_penalty
,t.adv_repay_status_cd as adv_repay_status_cd
,t.adj_repay_way_cd as adj_repay_way_cd
,t.repay_acct_pt_type_cd as repay_acct_pt_type_cd
,t.repay_acct_id as repay_acct_id
,t.repay_acct_name as repay_acct_name
,t.tot_amt as tot_amt
,t.choice_blon_loan_flg as choice_blon_loan_flg
,t.stop_pay_flow_num as stop_pay_flow_num
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark
,t.job_cd 
from ${idl_schema}.agt_retl_loan_adv_repay_appl t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_loan_adv_repay_appl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes