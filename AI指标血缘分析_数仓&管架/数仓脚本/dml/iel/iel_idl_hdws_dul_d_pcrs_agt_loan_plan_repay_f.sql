: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_pcrs_agt_loan_plan_repay_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_pcrs_agt_loan_plan_repay.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,t1.repay_term as repay_term
,t1.sub_term as sub_term
,t1.etl_dt as etl_dt
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,t1.total_term as total_term
,t1.pay_dt as pay_dt
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.pay_prcp as pay_prcp
,t1.pay_int as pay_int
,t1.pay_cost as pay_cost
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,replace(replace(t1.repay_flg,chr(13),''),chr(10),'') as repay_flg
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.actl_poff_dt as actl_poff_dt
from ${idl_schema}.hdws_dul_d_pcrs_agt_loan_plan_repay t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_pcrs_agt_loan_plan_repay.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes