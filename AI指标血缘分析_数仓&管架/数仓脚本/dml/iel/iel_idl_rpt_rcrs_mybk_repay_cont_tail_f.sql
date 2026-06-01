: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_rcrs_mybk_repay_cont_tail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_rcrs_mybk_repay_cont_tail.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.contract_no,chr(13),''),chr(10),'') as contract_no
,replace(replace(t1.withdraw_no,chr(13),''),chr(10),'') as withdraw_no
,replace(replace(t1.repay_type,chr(13),''),chr(10),'') as repay_type
,replace(replace(t1.repay_date,chr(13),''),chr(10),'') as repay_date
,t1.curr_prin_bal as curr_prin_bal
,t1.curr_ovd_prin_bal as curr_ovd_prin_bal
,t1.curr_int_bal as curr_int_bal
,t1.curr_ovd_int_bal as curr_ovd_int_bal
,t1.curr_ovd_prin_pnlt_bal as curr_ovd_prin_pnlt_bal
,t1.curr_ovd_int_pnlt_bal as curr_ovd_int_pnlt_bal
,t1.repay_amt as repay_amt
,t1.paid_prin_amt as paid_prin_amt
,t1.paid_ovd_prin_amt as paid_ovd_prin_amt
,t1.paid_int_amt as paid_int_amt
,t1.paid_ovd_int_amt as paid_ovd_int_amt
,t1.paid_ovd_prin_pnlt_amt as paid_ovd_prin_pnlt_amt
,t1.paid_ovd_int_pnlt_amt as paid_ovd_int_pnlt_amt
,replace(replace(t1.bef_accrued_status,chr(13),''),chr(10),'') as bef_accrued_status
,replace(replace(t1.bef_status,chr(13),''),chr(10),'') as bef_status
,replace(replace(t1.bef_asset_class,chr(13),''),chr(10),'') as bef_asset_class
,replace(replace(t1.bsn_type,chr(13),''),chr(10),'') as bsn_type
 from iol.rcrs_mybk_repay_cont_tail T1
where etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_rcrs_mybk_repay_cont_tail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes