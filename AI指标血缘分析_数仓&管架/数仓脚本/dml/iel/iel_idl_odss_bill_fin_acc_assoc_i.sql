: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_bill_fin_acc_assoc_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_bill_fin_acc_assoc_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
billing_account_id
,fin_account_id
,from_date
,thru_date
,party_id
,third_party_id
,product_id
,account_role_type_id
,imprinted_name
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
from ${idl_schema}.odss_bill_fin_acc_assoc
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_bill_fin_acc_assoc_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes