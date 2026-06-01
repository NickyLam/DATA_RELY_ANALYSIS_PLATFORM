: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_iats_billing_account_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_iats_billing_account.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.billing_account_id,chr(13),''),chr(10),'') as billing_account_id
,t1.account_limit as account_limit
,replace(replace(t1.account_currency_uom_id,chr(13),''),chr(10),'') as account_currency_uom_id
,replace(replace(t1.contact_mech_id,chr(13),''),chr(10),'') as contact_mech_id
,t1.from_date as from_date
,t1.thru_date as thru_date
,replace(replace(t1.description,chr(13),''),chr(10),'') as description
,replace(replace(t1.external_account_id,chr(13),''),chr(10),'') as external_account_id
,t1.last_updated_stamp as last_updated_stamp
,t1.last_updated_tx_stamp as last_updated_tx_stamp
,t1.created_stamp as created_stamp
,t1.created_tx_stamp as created_tx_stamp
,replace(replace(t1.billing_account_name,chr(13),''),chr(10),'') as billing_account_name
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.account_level,chr(13),''),chr(10),'') as account_level
,replace(replace(t1.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t1.media_type_id,chr(13),''),chr(10),'') as media_type_id
,replace(replace(t1.net_check_result,chr(13),''),chr(10),'') as net_check_result
,replace(replace(t1.account_branch_id,chr(13),''),chr(10),'') as account_branch_id
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t1.account_type,chr(13),''),chr(10),'') as account_type
,replace(replace(t1.account_category_level,chr(13),''),chr(10),'') as account_category_level
,replace(replace(t1.seed_stock,chr(13),''),chr(10),'') as seed_stock
,replace(replace(t1.account_trans_type,chr(13),''),chr(10),'') as account_trans_type
,replace(replace(t1.private_acct_id,chr(13),''),chr(10),'') as private_acct_id
,replace(replace(t1.withdrawal_method,chr(13),''),chr(10),'') as withdrawal_method
,replace(replace(t1.docs_type,chr(13),''),chr(10),'') as docs_type
,replace(replace(t1.docs_status,chr(13),''),chr(10),'') as docs_status
,replace(replace(t1.docs_no,chr(13),''),chr(10),'') as docs_no
,replace(replace(t1.card_level,chr(13),''),chr(10),'') as card_level
,replace(replace(t1.operate_acct_type,chr(13),''),chr(10),'') as operate_acct_type
,replace(replace(t1.cash_or_remit_id,chr(13),''),chr(10),'') as cash_or_remit_id
,replace(replace(t1.cash_saving_withdw_id,chr(13),''),chr(10),'') as cash_saving_withdw_id
,replace(replace(t1.chip_card_type,chr(13),''),chr(10),'') as chip_card_type
,replace(replace(t1.cooperate_card_type,chr(13),''),chr(10),'') as cooperate_card_type
,replace(replace(t1.channel_status,chr(13),''),chr(10),'') as channel_status
,t1.flag_date as flag_date
,replace(replace(t1.account_flag,chr(13),''),chr(10),'') as account_flag
,t1.guilt_date as guilt_date
,replace(replace(t1.data_source,chr(13),''),chr(10),'') as data_source
,replace(replace(t1.verify_status,chr(13),''),chr(10),'') as verify_status
,replace(replace(t1.status_update_org,chr(13),''),chr(10),'') as status_update_org
from ${iol_schema}.iats_billing_account t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_iats_billing_account.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes