: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_storage_contract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_storage_contract_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,storage_protocol_no
,contract_type
,draft_attr
,draft_type
,branch_id
,operator_id
,app_cust_id
,txn_date
,bail_acct_no
,credit_cust_no
,contract_status
,audit_status
,logic_check_status
,credit_check_status
,manager_id
,depart_id
,appno
,misc
,last_upd_oper_id
,last_upd_time
,account_flag
,account_date
,cust_account
,cust_bank_no
,cust_no
,oner_brid
,contract_sub_status
from ${idl_schema}.odss_storage_contract
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_storage_contract_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes