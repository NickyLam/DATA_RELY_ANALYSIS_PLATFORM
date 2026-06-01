: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_rcrs_mybk_exempt_loan_detail_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_rcrs_mybk_exempt_loan_detail.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.contract_no
,t1.seq_no
,t1.exempt_date
,t1.curr_int_bal
,t1.curr_ovd_int_bal
,t1.curr_ovd_prin_pnlt_bal
,t1.curr_ovd_int_pnlt_bal
,t1.exempt_amt
,t1.exempt_int_amt
,t1.exempt_ovd_int_amt
,t1.exempt_ovd_prin_pnlt_amt
,t1.exempt_ovd_int_pnlt_amt
,t1.bef_accrued_status
,t1.bef_status
, '' as write_off
,t1.bsn_type
,t1.bef_asset_class
from ${idl_schema}.hdws_rcrs_mybk_exempt_loan_detail t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_rcrs_mybk_exempt_loan_detail.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes