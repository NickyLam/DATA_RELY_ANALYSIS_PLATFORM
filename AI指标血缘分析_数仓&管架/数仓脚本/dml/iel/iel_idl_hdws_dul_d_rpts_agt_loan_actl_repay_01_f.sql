: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_loan_actl_repay_01_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_loan_actl_repay_01.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id 
,t1.etl_dt as etl_dt 
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id 
,t1.repay_dt as repay_dt 
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd 
,t1.curr_repay_prcp as curr_repay_prcp 
,t1.curr_repay_int as curr_repay_int 
,t1.curr_repay_pnlt as curr_repay_pnlt 
,t1.curr_repay_compd_int as curr_repay_compd_int 
,t1.curr_repay_cost as curr_repay_cost 
,t1.curr_term as curr_term 
,t1.curr_bal as curr_bal 
,replace(replace(t1.adv_repay_flg,chr(13),''),chr(10),'') as adv_repay_flg 
,replace(replace(t1.ovdue_repay_flg,chr(13),''),chr(10),'') as ovdue_repay_flg 
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd 
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg 
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id 
from ${idl_schema}.hdws_dul_d_rpts_agt_loan_actl_repay_01 t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_loan_actl_repay_01.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes