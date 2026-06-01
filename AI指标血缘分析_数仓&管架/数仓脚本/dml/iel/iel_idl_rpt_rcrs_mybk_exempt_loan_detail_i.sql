: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_rcrs_mybk_exempt_loan_detail_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_rcrs_mybk_exempt_loan_detail.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.contract_no,chr(13),''),chr(10),'') as contract_no
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.exempt_date,chr(13),''),chr(10),'') as exempt_date
,t1.curr_int_bal as curr_int_bal
,t1.curr_ovd_int_bal as curr_ovd_int_bal
,t1.curr_ovd_prin_pnlt_bal as curr_ovd_prin_pnlt_bal
,t1.curr_ovd_int_pnlt_bal as curr_ovd_int_pnlt_bal
,t1.exempt_amt as exempt_amt
,t1.exempt_int_amt as exempt_int_amt
,t1.exempt_ovd_int_amt as exempt_ovd_int_amt
,t1.exempt_ovd_prin_pnlt_amt as exempt_ovd_prin_pnlt_amt
,t1.exempt_ovd_int_pnlt_amt as exempt_ovd_int_pnlt_amt
,replace(replace(t1.bef_accrued_status,chr(13),''),chr(10),'') as bef_accrued_status
,replace(replace(t1.bef_status,chr(13),''),chr(10),'') as bef_status
,replace(replace(t1.write_off,chr(13),''),chr(10),'') as write_off
,replace(replace(t1.bsn_type,chr(13),''),chr(10),'') as bsn_type
 from iol.rcrs_mybk_exempt_loan_detail T1
where substr(replace(exempt_date,'-',''),1,8)='${batch_date}' and etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_rcrs_mybk_exempt_loan_detail.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes