: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_mpcs_cmm_retl_loan_dubil_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_cmm_retl_loan_dubil_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,dubil_id
,cust_name
,cert_no
,cont_id
,dubil_amt
,col_store_addr
,distr_dt
,operate
,open_acct_org_id
,mgmt_org_id
,acct_instit_id
from ${idl_schema}.mpcs_cmm_retl_loan_dubil_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_cmm_retl_loan_dubil_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes