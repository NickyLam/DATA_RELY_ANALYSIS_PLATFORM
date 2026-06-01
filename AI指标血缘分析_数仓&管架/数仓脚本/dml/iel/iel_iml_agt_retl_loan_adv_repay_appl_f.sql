: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_retl_loan_adv_repay_appl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_loan_adv_repay_appl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.dubil_amt as dubil_amt
,t.dubil_bal as dubil_bal
,t.loan_year_int_rat as loan_year_int_rat
,t.value_dt as value_dt
,t.exp_dt as exp_dt
,replace(replace(t.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
,t.adv_repay_amt as adv_repay_amt
,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,t.appl_dt as appl_dt
,replace(replace(t.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,t.int as int
,replace(replace(t.adv_repay_type_cd,chr(13),''),chr(10),'') as adv_repay_type_cd
,replace(replace(t.adv_repay_cap_src_cd,chr(13),''),chr(10),'') as adv_repay_cap_src_cd
,t.adv_repay_penalty as adv_repay_penalty
,replace(replace(t.adv_repay_status_cd,chr(13),''),chr(10),'') as adv_repay_status_cd
,replace(replace(t.adj_repay_way_cd,chr(13),''),chr(10),'') as adj_repay_way_cd
,replace(replace(t.repay_acct_pt_type_cd,chr(13),''),chr(10),'') as repay_acct_pt_type_cd
,replace(replace(t.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t.repay_acct_name,chr(13),''),chr(10),'') as repay_acct_name
,t.tot_amt as tot_amt
,replace(replace(t.choice_blon_loan_flg,chr(13),''),chr(10),'') as choice_blon_loan_flg
,replace(replace(t.stop_pay_flow_num,chr(13),''),chr(10),'') as stop_pay_flow_num
,t.create_dt as create_dt
,t.update_dt as update_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_retl_loan_adv_repay_appl t
where t.create_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_loan_adv_repay_appl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes