: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_retl_loan_repay_plan_f
CreateDate: 20231010
FileName:   ${iel_data_path}/cmm_retl_loan_repay_plan.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,t1.tot_perds as tot_perds
,t1.repay_perds as repay_perds
,t1.repay_sub_perds as repay_sub_perds
,t1.value_dt as value_dt
,t1.repaybl_dt as repaybl_dt
,t1.grace_repay_dt as grace_repay_dt
,t1.last_repay_dt as last_repay_dt
,t1.next_repay_dt as next_repay_dt
,t1.modif_dt as modif_dt
,replace(replace(t1.repay_type_cd,chr(13),''),chr(10),'') as repay_type_cd
,replace(replace(t1.repay_status_cd,chr(13),''),chr(10),'') as repay_status_cd
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,replace(replace(t1.repay_flg,chr(13),''),chr(10),'') as repay_flg
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.exec_int_rat as exec_int_rat
,t1.acru_nomal_pric as acru_nomal_pric
,t1.curr_issue_recvbl_amt as curr_issue_recvbl_amt
,t1.curr_issue_recvbl_pric as curr_issue_recvbl_pric
,t1.curr_issue_int_recvbl as curr_issue_int_recvbl
,t1.curr_issue_recvbl_acru_int as curr_issue_recvbl_acru_int
,t1.curr_issue_coll_acru_int as curr_issue_coll_acru_int
,t1.curr_issue_recvbl_over_int as curr_issue_recvbl_over_int
,t1.curr_issue_coll_over_int as curr_issue_coll_over_int
,t1.curr_issue_recvbl_acru_pnlt as curr_issue_recvbl_acru_pnlt
,t1.curr_issue_coll_acru_pnlt as curr_issue_coll_acru_pnlt
,t1.curr_issue_recvbl_pnlt as curr_issue_recvbl_pnlt
,t1.curr_issue_coll_pnlt as curr_issue_coll_pnlt
,t1.curr_issue_acru_comp_int as curr_issue_acru_comp_int
,t1.curr_issue_comp_int as curr_issue_comp_int
,t1.pric_bal as pric_bal
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
,replace(replace(t1.repay_amt_type_cd,chr(13),''),chr(10),'') as repay_amt_type_cd
,t1.curr_issue_ovdue_pric as curr_issue_ovdue_pric
from ${icl_schema}.cmm_retl_loan_repay_plan t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_retl_loan_repay_plan.f.${batch_date}.dat" \
        charset=utf8
        safe=yes