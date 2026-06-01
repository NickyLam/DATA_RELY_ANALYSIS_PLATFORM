: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_net_bat_repay_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_net_bat_repay.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.etl_date as etl_date
,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t.bill_no,chr(13),''),chr(10),'') as bill_no
,replace(replace(t.repay_account,chr(13),''),chr(10),'') as repay_account
,replace(replace(t.r_date,chr(13),''),chr(10),'') as r_date
,t.r_amt as r_amt
,t.r_captial as r_captial
,t.r_accrual as r_accrual
,t.raccr_int_amt as raccr_int_amt
,t.debt_int_amt as debt_int_amt
,t.pntyint_amt as pntyint_amt
,t.ret_int_amt as ret_int_amt
,t.r_overdue as r_overdue
,t.balance_amt as balance_amt
,replace(replace(t.cus_id,chr(13),''),chr(10),'') as cus_id
,t.dec_cnt as dec_cnt
,replace(replace(t.if_flag,chr(13),''),chr(10),'') as if_flag
,t.plus_int_amt as plus_int_amt
,t.acct_dcamt as acct_dcamt
,t.acct_ddamt as acct_ddamt
from iol.ilss_ghb_net_bat_repay t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_net_bat_repay.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes