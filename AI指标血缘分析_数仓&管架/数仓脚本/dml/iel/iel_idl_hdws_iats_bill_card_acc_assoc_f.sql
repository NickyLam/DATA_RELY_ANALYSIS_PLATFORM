: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iats_bill_card_acc_assoc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iats_bill_card_acc_assoc.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.assoc_id
,t1.billing_account_id
,t1.account_no
,t1.medium_no
,t1.medium_type_id
,t1.from_date
,t1.thru_date
,t1.customer_no
,t1.docs_type_id
,t1.status_id
,t1.is_core_created
,t1.branch_id
,t1.teller_no
,t1.authorizer
,t1.channel
,t1.trans_no_corei
,t1.trans_no_corex
,t1.last_updated_stamp
,t1.last_updated_tx_stamp
,t1.created_stamp
,t1.created_tx_stamp
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_iats_bill_card_acc_assoc t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iats_bill_card_acc_assoc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes