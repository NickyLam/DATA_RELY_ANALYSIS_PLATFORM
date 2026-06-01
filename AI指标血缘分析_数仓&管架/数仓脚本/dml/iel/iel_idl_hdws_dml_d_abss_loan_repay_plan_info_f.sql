: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dml_d_abss_loan_repay_plan_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dml_d_abss_loan_repay_plan_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.asset_src,chr(13),''),chr(10),'') as asset_src
,replace(replace(t1.asset_num,chr(13),''),chr(10),'') as asset_num
,t1.repay_term as repay_term
,t1.sub_term as sub_term
,t1.pay_int_dt as pay_int_dt
,t1.pay_prcp as pay_prcp
,t1.curr_repay_prcp as curr_repay_prcp
,t1.curr_bal as curr_bal
,t1.pay_int as pay_int
,t1.curr_repay_int as curr_repay_int
,t1.pay_prcp_pnlt as pay_prcp_pnlt
,t1.repay_prcp_pnlt as repay_prcp_pnlt
,t1.pay_int_pnlt as pay_int_pnlt
,t1.repayt_int_pnlt as repayt_int_pnlt
,t1.repay_dt as repay_dt
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,t1.setl_dt as setl_dt
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,t1.ovdue_days as ovdue_days
,replace(replace(t1.adv_repay_flg,chr(13),''),chr(10),'') as adv_repay_flg
from ${idl_schema}.hdws_dml_d_abss_loan_repay_plan_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dml_d_abss_loan_repay_plan_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes