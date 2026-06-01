: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_cmm_corp_loan_repay_plan_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_cmm_corp_loan_repay_plan.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,lp_id
,dubil_id
,acct_id
,cust_id
,tot_perds
,repay_perds
,repay_sub_perds
,value_dt
,repaybl_dt
,exec_status_flg
,ovdue_flg
,irr_repay_plan_flg
,repay_flg
,is_int_set_flg
,repay_cate_cd
,repay_way_cd
,curr_cd
,exec_int_rat
,acru_nomal_pric
,curr_issue_recvbl_pric
,curr_issue_int_recvbl
,curr_issue_recvbl_fee
,curr_issue_int_sub_amt
from ${idl_schema}.ccrm_cmm_corp_loan_repay_plan t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_cmm_corp_loan_repay_plan.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes