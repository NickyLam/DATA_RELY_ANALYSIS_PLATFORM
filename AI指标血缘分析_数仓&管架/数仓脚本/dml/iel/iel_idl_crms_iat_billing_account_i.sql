: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_iat_billing_account_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_iat_billing_account_${batch_date}_f.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
billing_account_id
,account_limit
,account_currency_uom_id
,contact_mech_id
,from_date
,thru_date
,description
,external_account_id
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
,billing_account_name
,party_id
,account_level
,status_id
,media_type_id
,net_check_result
,account_branch_id
,channel
,account_type
from ${idl_schema}.crms_iat_billing_account
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_iat_billing_account_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes