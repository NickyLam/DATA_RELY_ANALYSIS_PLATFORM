: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_mpcs_cmm_dep_acct_tran_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_cmm_dep_acct_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,tran_flow_num
,cust_acct_id
,tran_dt
,debit_crdt_dir_cd
,type1
,tran_amt
,tran_bal
,operate
,tran_org_id
,tran_teller_id
,acct_bill_flow_num
from ${idl_schema}.mpcs_cmm_dep_acct_tran_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_cmm_dep_acct_tran_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes