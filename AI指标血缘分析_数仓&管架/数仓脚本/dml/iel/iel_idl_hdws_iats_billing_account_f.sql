: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iats_billing_account_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iats_billing_account.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.billing_account_id
,t1.account_limit
,t1.account_currency_uom_id
,t1.contact_mech_id
,t1.from_date
,t1.thru_date
,t1.description
,t1.external_account_id
,t1.last_updated_stamp
,t1.last_updated_tx_stamp
,t1.created_stamp
,t1.created_tx_stamp
,t1.billing_account_name
,t1.party_id
,t1.account_level
,t1.status_id
,t1.media_type_id
,t1.net_check_result
,t1.account_branch_id
,t1.channel
,t1.account_type
,t1.account_category_level
,t1.seed_stock
,t1.account_trans_type
,t1.private_acct_id
,t1.withdrawal_method
,t1.docs_type
,t1.docs_status
,t1.docs_no
,t1.card_level
,t1.operate_acct_type
,t1.cash_or_remit_id
,t1.cash_saving_withdw_id
,t1.chip_card_type
,t1.cooperate_card_type
,t1.channel_status
,t1.flag_date
,t1.account_flag
,t1.guilt_date
,t1.data_source
,t1.verify_status
,t1.status_update_org
,t1.certification_status
,t1.freeze_status
,t1.business_type
,t1.supplyer_no
,t1.supplyer_name
,t1.image_retention_status
,t1.un_account_entry_status
,t1.image_retention_date
,t1.sleep_account_status
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_iats_billing_account t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iats_billing_account.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes