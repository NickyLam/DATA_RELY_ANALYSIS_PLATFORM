: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_rcrs_mybk_loan_int_calc_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_rcrs_mybk_loan_int_calc.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.contract_no,chr(13),''),chr(10),'') as contract_no
,replace(replace(t1.calc_date,chr(13),''),chr(10),'') as calc_date
,replace(replace(t1.accrued_status,chr(13),''),chr(10),'') as accrued_status
,t1.prin_bal as prin_bal
,t1.ovd_prin_bal as ovd_prin_bal
,t1.ovd_int_bal as ovd_int_bal
,t1.real_rate as real_rate
,t1.pnlt_rate as pnlt_rate
,t1.int_amt as int_amt
,t1.ovd_prin_pnlt_amt as ovd_prin_pnlt_amt
,t1.ovd_int_pnlt_amt as ovd_int_pnlt_amt
,replace(replace(t1.write_off,chr(13),''),chr(10),'') as write_off
,replace(replace(t1.bsn_type,chr(13),''),chr(10),'') as bsn_type
 from iol.rcrs_mybk_loan_int_calc T1
where to_char(to_date(substr(calc_date,1,10),'yyyy-mm-dd'),'yyyymmdd')='${batch_date}' and etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_rcrs_mybk_loan_int_calc.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes