: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_loan_tran_dtl_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_loan_tran_dtl_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.seq_num,chr(13),''),chr(10),'') as seq_num
,t.tran_dt as tran_dt
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,replace(replace(t.loan_bal_compnt_type_cd,chr(13),''),chr(10),'') as loan_bal_compnt_type_cd
,replace(replace(t.acct_bill_type_cd,chr(13),''),chr(10),'') as acct_bill_type_cd
,replace(replace(t.loan_bal_seq_num,chr(13),''),chr(10),'') as loan_bal_seq_num
,replace(replace(t.loan_tran_cd,chr(13),''),chr(10),'') as loan_tran_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,t.amt as amt
,t.bal_type_ths_tm_bal as bal_type_ths_tm_bal
,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t.strk_bal_flg,chr(13),''),chr(10),'') as strk_bal_flg
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,t.ths_tm_bal as ths_tm_bal
,t.term_num as term_num
from ${iml_schema}.evt_loan_tran_dtl t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_loan_tran_dtl_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes