: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_evt_retl_loan_acct_tran_dtl_a
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_evt_retl_loan_acct_tran_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,evt_id
,lp_id
,tran_dt
,dtl_id
,acct_id
,dubil_id
,prod_id
,acctnt_cate_cd
,cust_id
,curr_cd
,tran_dir_cd
,tran_amt
,acct_bal
,bal_field_name
,bal_field_cn_name
,tran_org_id
,tran_teller_id
,tran_flow_num
,tran_evt_cd
,evt_descb
,tran_cd
,revs_flg
,brevs_flg
from ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_evt_retl_loan_acct_tran_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes