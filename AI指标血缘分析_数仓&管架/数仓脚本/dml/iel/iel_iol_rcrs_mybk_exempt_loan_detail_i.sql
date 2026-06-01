: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_mybk_exempt_loan_detail_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_mybk_exempt_loan_detail.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.contract_no,chr(13),''),chr(10),'') as contract_no
,replace(replace(t.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t.exempt_date,chr(13),''),chr(10),'') as exempt_date
,t.curr_int_bal as curr_int_bal
,t.curr_ovd_int_bal as curr_ovd_int_bal
,t.curr_ovd_prin_pnlt_bal as curr_ovd_prin_pnlt_bal
,t.curr_ovd_int_pnlt_bal as curr_ovd_int_pnlt_bal
,t.exempt_amt as exempt_amt
,t.exempt_int_amt as exempt_int_amt
,t.exempt_ovd_int_amt as exempt_ovd_int_amt
,t.exempt_ovd_prin_pnlt_amt as exempt_ovd_prin_pnlt_amt
,t.exempt_ovd_int_pnlt_amt as exempt_ovd_int_pnlt_amt
,replace(replace(t.bef_accrued_status,chr(13),''),chr(10),'') as bef_accrued_status
,replace(replace(t.bef_status,chr(13),''),chr(10),'') as bef_status
,replace(replace(t.bef_asset_class,chr(13),''),chr(10),'') as bef_asset_class
,replace(replace(t.bsn_type,chr(13),''),chr(10),'') as bsn_type
from ${iol_schema}.RCRS_MYBK_EXEMPT_LOAN_DETAIL t 
where substr(replace(exempt_date,'-',''),1,8)='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_mybk_exempt_loan_detail.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes