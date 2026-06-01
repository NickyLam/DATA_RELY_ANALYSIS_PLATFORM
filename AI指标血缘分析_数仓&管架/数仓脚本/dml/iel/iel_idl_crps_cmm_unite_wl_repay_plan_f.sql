: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crps_cmm_unite_wl_repay_plan_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crps_cmm_unite_wl_repay_plan.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,lp_id
,dubil_id
,cust_id
,prod_id
,tot_perds
,repay_perds
,repay_sub_perds
,value_dt
,repaybl_dt
,payoff_dt
,pric_turn_ovdue_dt
,int_turn_ovdue_dt
,inst_status_cd
,ovdue_flg
,repay_flg
,curr_cd
,pric_ovdue_days
,int_ovdue_days
,curr_issue_recvbl_pric
,curr_issue_int_recvbl
,curr_issue_recvbl_pric_bal
,curr_issue_int_recvbl_bal
,curr_issue_ovdue_pric_pnlt
,curr_issue_ovdue_int_pnlt
,init_tot_perds
,init_repay_perds
,init_value_dt
,grace_dt

from ${idl_schema}.crps_cmm_unite_wl_repay_plan t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_cmm_unite_wl_repay_plan.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes