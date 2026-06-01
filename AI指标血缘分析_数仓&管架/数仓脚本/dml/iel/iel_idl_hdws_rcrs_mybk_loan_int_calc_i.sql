: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_rcrs_mybk_loan_int_calc_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_rcrs_mybk_loan_int_calc.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.contract_no
,t1.calc_date
,t1.accrued_status
,t1.prin_bal
,t1.ovd_prin_bal
,t1.ovd_int_bal
,t1.real_rate
,t1.pnlt_rate
,t1.int_amt
,t1.ovd_prin_pnlt_amt
,t1.ovd_int_pnlt_amt
,t1.write_off
,t1.bsn_type
from ${idl_schema}.hdws_rcrs_mybk_loan_int_calc t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_rcrs_mybk_loan_int_calc.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes