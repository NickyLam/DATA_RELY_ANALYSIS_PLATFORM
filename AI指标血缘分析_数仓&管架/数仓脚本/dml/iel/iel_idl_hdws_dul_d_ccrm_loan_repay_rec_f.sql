: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_loan_repay_rec_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_loan_repay_rec.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.dbill_num,chr(13),''),chr(10),'') as dbill_num
,t1.total_term as total_term
,t1.bch_nbr as bch_nbr
,t1.pay_dt as pay_dt
,t1.pay_prcp as pay_prcp
,t1.pay_int as pay_int
,t1.pay_cost as pay_cost
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,replace(replace(t1.repay_flg,chr(13),''),chr(10),'') as repay_flg
,t1.final_repay_dt as final_repay_dt
,t1.actl_repay_prcp as actl_repay_prcp
,t1.actl_repay_int as actl_repay_int
,t1.actl_repay_pnlt as actl_repay_pnlt
,t1.actl_repay_compd_int as actl_repay_compd_int
,t1.actl_repay_cost as actl_repay_cost
,t1.curr_bal as curr_bal
,replace(replace(t1.adv_repay_flg,chr(13),''),chr(10),'') as adv_repay_flg
,replace(replace(t1.ovdue_repay_flg,chr(13),''),chr(10),'') as ovdue_repay_flg
from ${idl_schema}.hdws_dul_d_ccrm_loan_repay_rec t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_loan_repay_rec.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes