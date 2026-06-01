: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_iats_bill_card_acc_assoc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/iats_bill_card_acc_assoc.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.assoc_id,chr(13),''),chr(10),'') as assoc_id
,replace(replace(t.billing_account_id,chr(13),''),chr(10),'') as billing_account_id
,replace(replace(t.account_no,chr(13),''),chr(10),'') as account_no
,replace(replace(t.medium_no,chr(13),''),chr(10),'') as medium_no
,replace(replace(t.medium_type_id,chr(13),''),chr(10),'') as medium_type_id
,t.from_date as from_date
,t.thru_date as thru_date
,replace(replace(t.customer_no,chr(13),''),chr(10),'') as customer_no
,replace(replace(t.docs_type_id,chr(13),''),chr(10),'') as docs_type_id
,replace(replace(t.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t.is_core_created,chr(13),''),chr(10),'') as is_core_created
,replace(replace(t.branch_id,chr(13),''),chr(10),'') as branch_id
,replace(replace(t.teller_no,chr(13),''),chr(10),'') as teller_no
,replace(replace(t.authorizer,chr(13),''),chr(10),'') as authorizer
,replace(replace(t.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t.trans_no_corei,chr(13),''),chr(10),'') as trans_no_corei
,replace(replace(t.trans_no_corex,chr(13),''),chr(10),'') as trans_no_corex
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.iats_bill_card_acc_assoc t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iats_bill_card_acc_assoc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes