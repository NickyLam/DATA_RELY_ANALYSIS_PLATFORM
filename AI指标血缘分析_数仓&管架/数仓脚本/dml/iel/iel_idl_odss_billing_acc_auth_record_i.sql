: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_billing_acc_auth_record_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_billing_acc_auth_record_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
auth_record_id
,billing_account_id
,auth_type_id
,status_id
,auditor_id
,audit_des
,local_path
,from_date
,disabled_date
,finished_date
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
from ${idl_schema}.odss_billing_acc_auth_record
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_billing_acc_auth_record_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes