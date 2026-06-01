: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_corp_loan_repay_plan_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_corp_loan_repay_plan_w.i.${batch_date}.dat
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
,t.payoff_dt as payoff_dt
,replace(replace(t.exec_status_flg,chr(13),''),chr(10),'') as exec_status_flg
,replace(replace(t.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,replace(replace(t.irr_repay_plan_flg,chr(13),''),chr(10),'') as irr_repay_plan_flg
,replace(replace(t.repay_flg,chr(13),''),chr(10),'') as repay_flg
,replace(replace(t.is_int_set_flg,chr(13),''),chr(10),'') as is_int_set_flg
,replace(replace(t.repay_cate_cd,chr(13),''),chr(10),'') as repay_cate_cd
,replace(replace(t.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.exec_int_rat as exec_int_rat
,t.acru_nomal_pric as acru_nomal_pric
,t.curr_issue_recvbl_pric as curr_issue_recvbl_pric
,t.curr_issue_int_recvbl as curr_issue_int_recvbl
,t.curr_issue_recvbl_fee as curr_issue_recvbl_fee
,t.curr_issue_int_sub_amt as curr_issue_int_sub_amt
from ${icl_schema}.cmm_corp_loan_repay_plan t
where etl_dt = to_date('${batch_date}','yyyymmdd')    ; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_loan_repay_plan_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes