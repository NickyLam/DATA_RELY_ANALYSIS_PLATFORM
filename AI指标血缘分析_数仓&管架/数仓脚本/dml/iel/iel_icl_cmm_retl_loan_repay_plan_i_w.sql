: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_retl_loan_repay_plan_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_retl_loan_repay_plan_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,t.tot_perds as tot_perds
,t.repay_perds as repay_perds
,t.repay_sub_perds as repay_sub_perds
,t.value_dt as value_dt
,t.repaybl_dt as repaybl_dt
,t.grace_repay_dt as grace_repay_dt
,t.last_repay_dt as last_repay_dt
,t.next_repay_dt as next_repay_dt
,t.modif_dt as modif_dt
,replace(replace(t.repay_type_cd,chr(13),''),chr(10),'') as repay_type_cd
,replace(replace(t.repay_status_cd,chr(13),''),chr(10),'') as repay_status_cd
,replace(replace(t.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,replace(replace(t.repay_flg,chr(13),''),chr(10),'') as repay_flg
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.exec_int_rat as exec_int_rat
,t.acru_nomal_pric as acru_nomal_pric
,t.curr_issue_recvbl_amt as curr_issue_recvbl_amt
,t.curr_issue_recvbl_pric as curr_issue_recvbl_pric
,t.curr_issue_int_recvbl as curr_issue_int_recvbl
,t.curr_issue_recvbl_acru_int as curr_issue_recvbl_acru_int
,t.curr_issue_coll_acru_int as curr_issue_coll_acru_int
,t.curr_issue_recvbl_over_int as curr_issue_recvbl_over_int
,t.curr_issue_coll_over_int as curr_issue_coll_over_int
,t.curr_issue_recvbl_acru_pnlt as curr_issue_recvbl_acru_pnlt
,t.curr_issue_coll_acru_pnlt as curr_issue_coll_acru_pnlt
,t.curr_issue_recvbl_pnlt as curr_issue_recvbl_pnlt
,t.curr_issue_coll_pnlt as curr_issue_coll_pnlt
,t.curr_issue_acru_comp_int as curr_issue_acru_comp_int
,t.curr_issue_comp_int as curr_issue_comp_int
from ${icl_schema}.cmm_retl_loan_repay_plan t
where etl_dt = to_date('${batch_date}','yyyymmdd')    ; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_retl_loan_repay_plan_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes