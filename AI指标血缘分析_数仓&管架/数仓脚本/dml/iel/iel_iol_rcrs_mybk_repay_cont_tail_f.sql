: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_mybk_repay_cont_tail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_mybk_repay_cont_tail.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t.contract_no,chr(13),''),chr(10),'') as contract_no
,replace(replace(t.withdraw_no,chr(13),''),chr(10),'') as withdraw_no
,replace(replace(t.repay_type,chr(13),''),chr(10),'') as repay_type
,replace(replace(t.repay_date,chr(13),''),chr(10),'') as repay_date
,t.curr_prin_bal as curr_prin_bal
,t.curr_ovd_prin_bal as curr_ovd_prin_bal
,t.curr_int_bal as curr_int_bal
,t.curr_ovd_int_bal as curr_ovd_int_bal
,t.curr_ovd_prin_pnlt_bal as curr_ovd_prin_pnlt_bal
,t.curr_ovd_int_pnlt_bal as curr_ovd_int_pnlt_bal
,t.repay_amt as repay_amt
,t.paid_prin_amt as paid_prin_amt
,t.paid_ovd_prin_amt as paid_ovd_prin_amt
,t.paid_int_amt as paid_int_amt
,t.paid_ovd_int_amt as paid_ovd_int_amt
,t.paid_ovd_prin_pnlt_amt as paid_ovd_prin_pnlt_amt
,t.paid_ovd_int_pnlt_amt as paid_ovd_int_pnlt_amt
,replace(replace(t.bef_accrued_status,chr(13),''),chr(10),'') as bef_accrued_status
,replace(replace(t.bef_status,chr(13),''),chr(10),'') as bef_status
,replace(replace(t.bef_asset_class,chr(13),''),chr(10),'') as bef_asset_class
,replace(replace(t.bsn_type,chr(13),''),chr(10),'') as bsn_type
from ${iol_schema}.RCRS_MYBK_REPAY_CONT_TAIL t 
where t.etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_mybk_repay_cont_tail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes