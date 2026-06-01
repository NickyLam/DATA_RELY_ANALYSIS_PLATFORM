: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_unite_wl_repay_plan_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_unite_wl_repay_plan.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,t1.tot_perds as tot_perds
,t1.repay_perds as repay_perds
,t1.repay_sub_perds as repay_sub_perds
,t1.value_dt as value_dt
,t1.repaybl_dt as repaybl_dt
,t1.payoff_dt as payoff_dt
,t1.pric_turn_ovdue_dt as pric_turn_ovdue_dt
,t1.int_turn_ovdue_dt as int_turn_ovdue_dt
,replace(replace(t1.inst_status_cd,chr(13),''),chr(10),'') as inst_status_cd
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,replace(replace(t1.repay_flg,chr(13),''),chr(10),'') as repay_flg
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.pric_ovdue_days as pric_ovdue_days
,t1.int_ovdue_days as int_ovdue_days
,t1.curr_issue_recvbl_pric as curr_issue_recvbl_pric
,t1.curr_issue_int_recvbl as curr_issue_int_recvbl
,t1.curr_issue_recvbl_pric_bal as curr_issue_recvbl_pric_bal
,t1.curr_issue_int_recvbl_bal as curr_issue_int_recvbl_bal
,t1.curr_issue_ovdue_pric_pnlt as curr_issue_ovdue_pric_pnlt
,t1.curr_issue_ovdue_int_pnlt as curr_issue_ovdue_int_pnlt
from ${icl_schema}.cmm_unite_wl_repay_plan t1
where etl_dt = to_date('${batch_date}','yyyymmdd')-1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_unite_wl_repay_plan.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes