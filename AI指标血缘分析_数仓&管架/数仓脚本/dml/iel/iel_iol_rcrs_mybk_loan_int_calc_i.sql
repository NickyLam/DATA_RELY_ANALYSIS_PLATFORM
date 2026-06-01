: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_mybk_loan_int_calc_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_mybk_loan_int_calc.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.contract_no,chr(13),''),chr(10),'') as contract_no
,replace(replace(t.calc_date,chr(13),''),chr(10),'') as calc_date
,replace(replace(t.accrued_status,chr(13),''),chr(10),'') as accrued_status
,t.prin_bal as prin_bal
,t.ovd_prin_bal as ovd_prin_bal
,t.ovd_int_bal as ovd_int_bal
,t.real_rate as real_rate
,t.pnlt_rate as pnlt_rate
,t.int_amt as int_amt
,t.ovd_prin_pnlt_amt as ovd_prin_pnlt_amt
,t.ovd_int_pnlt_amt as ovd_int_pnlt_amt
,replace(replace(t.write_off,chr(13),''),chr(10),'') as write_off
,replace(replace(t.bsn_type,chr(13),''),chr(10),'') as bsn_type
from ${iol_schema}.rcrs_mybk_loan_int_calc t 
where to_char(to_date(substr(CALC_DATE,1,10),'YYYY-MM-DD'),'YYYYMMDD')='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_mybk_loan_int_calc.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes