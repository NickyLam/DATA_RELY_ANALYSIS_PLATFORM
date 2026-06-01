: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_billing_account_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_billing_account_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
billing_account_id
,billing_account_name
,account_currency_uom_id
,media_type_id
,party_id
,status_id
,account_limit
,external_account_id
,account_level
,net_check_result
,account_branch_id
,from_date
,thru_date
,contact_mech_id
,channel
,description
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
,account_type
from ${idl_schema}.odss_billing_account
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_billing_account_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes