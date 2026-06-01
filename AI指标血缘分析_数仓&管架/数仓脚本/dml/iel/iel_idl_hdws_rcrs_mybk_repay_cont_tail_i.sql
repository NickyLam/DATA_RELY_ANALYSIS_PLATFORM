: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_rcrs_mybk_repay_cont_tail_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_rcrs_mybk_repay_cont_tail.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.seq_no
,t1.contract_no
,t1.withdraw_no
,t1.repay_type
,t1.repay_date
,t1.curr_prin_bal
,t1.curr_ovd_prin_bal
,t1.curr_int_bal
,t1.curr_ovd_int_bal
,t1.curr_ovd_prin_pnlt_bal
,t1.curr_ovd_int_pnlt_bal
,t1.repay_amt
,t1.paid_prin_amt
,t1.paid_ovd_prin_amt
,t1.paid_int_amt
,t1.paid_ovd_int_amt
,t1.paid_ovd_prin_pnlt_amt
,t1.paid_ovd_int_pnlt_amt
,t1.bef_accrued_status
,t1.bef_status
,t1.bef_asset_class
,t1.bsn_type
from ${idl_schema}.hdws_rcrs_mybk_repay_cont_tail t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_rcrs_mybk_repay_cont_tail.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes