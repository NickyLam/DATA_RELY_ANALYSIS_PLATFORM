: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_corp_loan_repay_plan_f
CreateDate: 20221228
FileName:   ${iel_data_path}/cmm_corp_loan_repay_plan.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,tot_perds
,repay_perds
,repay_sub_perds
,value_dt
,repaybl_dt
,replace(replace(t1.exec_status_flg,chr(13),''),chr(10),'') as exec_status_flg
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,replace(replace(t1.irr_repay_plan_flg,chr(13),''),chr(10),'') as irr_repay_plan_flg
,replace(replace(t1.repay_flg,chr(13),''),chr(10),'') as repay_flg
,replace(replace(t1.is_int_set_flg,chr(13),''),chr(10),'') as is_int_set_flg
,replace(replace(t1.repay_cate_cd,chr(13),''),chr(10),'') as repay_cate_cd
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,exec_int_rat
,acru_nomal_pric
,curr_issue_recvbl_pric
,curr_issue_int_recvbl
,curr_issue_recvbl_fee
,curr_issue_int_sub_amt
,payoff_dt
,curr_issue_pric_ovdue_dt
,curr_issue_int_ovdue_dt
,curr_issue_ovdue_days
,curr_issue_ovdue_pric
,curr_issue_ovdue_int
,curr_issue_ovdue_comp_int
,curr_issue_over_int_bal
,curr_issue_pnlt_bal
,curr_issue_idle_bal
,curr_issue_bad_debt_bal
,int_ovdue_days
,pric_bal
,curr_issue_recvbl_amt
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
,replace(replace(t1.repay_amt_type_cd,chr(13),''),chr(10),'') as repay_amt_type_cd
,grace_repay_dt

from ${icl_schema}.cmm_corp_loan_repay_plan t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_loan_repay_plan.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
