: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_iats_billing_account_f
CreateDate: 20180529
FileName:   ${iel_data_path}/iats_billing_account.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.billing_account_id,chr(13),''),chr(10),'') as billing_account_id
,t.account_limit as account_limit
,replace(replace(t.account_currency_uom_id,chr(13),''),chr(10),'') as account_currency_uom_id
,replace(replace(t.contact_mech_id,chr(13),''),chr(10),'') as contact_mech_id
,t.from_date as from_date
,t.thru_date as thru_date
,replace(replace(t.description,chr(13),''),chr(10),'') as description
,replace(replace(t.external_account_id,chr(13),''),chr(10),'') as external_account_id
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,replace(replace(t.billing_account_name,chr(13),''),chr(10),'') as billing_account_name
,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t.account_level,chr(13),''),chr(10),'') as account_level
,replace(replace(t.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t.media_type_id,chr(13),''),chr(10),'') as media_type_id
,replace(replace(t.net_check_result,chr(13),''),chr(10),'') as net_check_result
,replace(replace(t.account_branch_id,chr(13),''),chr(10),'') as account_branch_id
,replace(replace(t.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t.account_type,chr(13),''),chr(10),'') as account_type
,replace(replace(t.account_category_level,chr(13),''),chr(10),'') as account_category_level
,replace(replace(t.seed_stock,chr(13),''),chr(10),'') as seed_stock
,replace(replace(t.account_trans_type,chr(13),''),chr(10),'') as account_trans_type
,replace(replace(t.private_acct_id,chr(13),''),chr(10),'') as private_acct_id
,replace(replace(t.withdrawal_method,chr(13),''),chr(10),'') as withdrawal_method
,replace(replace(t.docs_type,chr(13),''),chr(10),'') as docs_type
,replace(replace(t.docs_status,chr(13),''),chr(10),'') as docs_status
,replace(replace(t.docs_no,chr(13),''),chr(10),'') as docs_no
,replace(replace(t.card_level,chr(13),''),chr(10),'') as card_level
,replace(replace(t.operate_acct_type,chr(13),''),chr(10),'') as operate_acct_type
,replace(replace(t.cash_or_remit_id,chr(13),''),chr(10),'') as cash_or_remit_id
,replace(replace(t.cash_saving_withdw_id,chr(13),''),chr(10),'') as cash_saving_withdw_id
,replace(replace(t.chip_card_type,chr(13),''),chr(10),'') as chip_card_type
,replace(replace(t.cooperate_card_type,chr(13),''),chr(10),'') as cooperate_card_type
,replace(replace(t.channel_status,chr(13),''),chr(10),'') as channel_status
,t.flag_date as flag_date
,replace(replace(t.account_flag,chr(13),''),chr(10),'') as account_flag
,t.guilt_date as guilt_date
,replace(replace(t.data_source,chr(13),''),chr(10),'') as data_source
,replace(replace(t.verify_status,chr(13),''),chr(10),'') as verify_status
,replace(replace(t.status_update_org,chr(13),''),chr(10),'') as status_update_org
,replace(replace(t.certification_status,chr(13),''),chr(10),'') as certification_status
,replace(replace(t.freeze_status,chr(13),''),chr(10),'') as freeze_status
,replace(replace(t.business_type,chr(13),''),chr(10),'') as business_type
,replace(replace(t.supplyer_no,chr(13),''),chr(10),'') as supplyer_no
,replace(replace(t.supplyer_name,chr(13),''),chr(10),'') as supplyer_name
,replace(replace(t.image_retention_status,chr(13),''),chr(10),'') as image_retention_status
,replace(replace(t.un_account_entry_status,chr(13),''),chr(10),'') as un_account_entry_status
,t.image_retention_date as image_retention_date
,replace(replace(t.sleep_account_status,chr(13),''),chr(10),'') as sleep_account_status
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.IATS_BILLING_ACCOUNT t 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iats_billing_account.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes