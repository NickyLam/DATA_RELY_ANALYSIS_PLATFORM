: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_iats_bill_card_acc_assoc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_iats_bill_card_acc_assoc.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.assoc_id,chr(13),''),chr(10),'') as assoc_id
,replace(replace(t1.billing_account_id,chr(13),''),chr(10),'') as billing_account_id
,replace(replace(t1.account_no,chr(13),''),chr(10),'') as account_no
,replace(replace(t1.medium_no,chr(13),''),chr(10),'') as medium_no
,replace(replace(t1.medium_type_id,chr(13),''),chr(10),'') as medium_type_id
,t1.from_date as from_date
,t1.thru_date as thru_date
,replace(replace(t1.customer_no,chr(13),''),chr(10),'') as customer_no
,replace(replace(t1.docs_type_id,chr(13),''),chr(10),'') as docs_type_id
,replace(replace(t1.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t1.is_core_created,chr(13),''),chr(10),'') as is_core_created
,replace(replace(t1.branch_id,chr(13),''),chr(10),'') as branch_id
,replace(replace(t1.teller_no,chr(13),''),chr(10),'') as teller_no
,replace(replace(t1.authorizer,chr(13),''),chr(10),'') as authorizer
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t1.trans_no_corei,chr(13),''),chr(10),'') as trans_no_corei
,replace(replace(t1.trans_no_corex,chr(13),''),chr(10),'') as trans_no_corex
,t1.last_updated_stamp as last_updated_stamp
,t1.last_updated_tx_stamp as last_updated_tx_stamp
,t1.created_stamp as created_stamp
,t1.created_tx_stamp as created_tx_stamp
 from iol.iats_bill_card_acc_assoc T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_iats_bill_card_acc_assoc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes