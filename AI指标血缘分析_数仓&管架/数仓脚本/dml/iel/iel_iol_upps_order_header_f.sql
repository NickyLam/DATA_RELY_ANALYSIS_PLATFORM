: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_upps_order_header_f
CreateDate: 20180529
FileName:   ${iel_data_path}/upps_order_header.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.order_id,chr(13),''),chr(10),'') as order_id 
,replace(replace(t1.order_type_id,chr(13),''),chr(10),'') as order_type_id 
,replace(replace(t1.order_name,chr(13),''),chr(10),'') as order_name 
,replace(replace(t1.external_id,chr(13),''),chr(10),'') as external_id 
,replace(replace(t1.sales_channel_enum_id,chr(13),''),chr(10),'') as sales_channel_enum_id 
,t1.order_date as order_date 
,replace(replace(t1.priority,chr(13),''),chr(10),'') as priority 
,t1.entry_date as entry_date 
,t1.pick_sheet_printed_date as pick_sheet_printed_date 
,replace(replace(t1.visit_id,chr(13),''),chr(10),'') as visit_id 
,replace(replace(t1.status_id,chr(13),''),chr(10),'') as status_id 
,replace(replace(t1.created_by,chr(13),''),chr(10),'') as created_by 
,replace(replace(t1.first_attempt_order_id,chr(13),''),chr(10),'') as first_attempt_order_id 
,replace(replace(t1.currency_uom,chr(13),''),chr(10),'') as currency_uom 
,replace(replace(t1.sync_status_id,chr(13),''),chr(10),'') as sync_status_id 
,replace(replace(t1.billing_account_id,chr(13),''),chr(10),'') as billing_account_id 
,replace(replace(t1.origin_facility_id,chr(13),''),chr(10),'') as origin_facility_id 
,replace(replace(t1.web_site_id,chr(13),''),chr(10),'') as web_site_id 
,replace(replace(t1.product_store_id,chr(13),''),chr(10),'') as product_store_id 
,replace(replace(t1.terminal_id,chr(13),''),chr(10),'') as terminal_id 
,replace(replace(t1.transaction_id,chr(13),''),chr(10),'') as transaction_id 
,replace(replace(t1.auto_order_shopping_list_id,chr(13),''),chr(10),'') as auto_order_shopping_list_id 
,replace(replace(t1.needs_inventory_issuance,chr(13),''),chr(10),'') as needs_inventory_issuance 
,replace(replace(t1.is_rush_order,chr(13),''),chr(10),'') as is_rush_order 
,replace(replace(t1.internal_code,chr(13),''),chr(10),'') as internal_code 
,t1.remaining_sub_total as remaining_sub_total 
,t1.grand_total as grand_total 
,replace(replace(t1.is_viewed,chr(13),''),chr(10),'') as is_viewed 
,t1.last_updated_stamp as last_updated_stamp 
,t1.last_updated_tx_stamp as last_updated_tx_stamp 
,t1.created_stamp as created_stamp 
,t1.created_tx_stamp as created_tx_stamp 
,replace(replace(t1.product_id,chr(13),''),chr(10),'') as product_id 
,replace(replace(t1.internal_note,chr(13),''),chr(10),'') as internal_note 
,replace(replace(t1.public_note,chr(13),''),chr(10),'') as public_note 
,t1.amount as amount 
,replace(replace(t1.orig_order_id,chr(13),''),chr(10),'') as orig_order_id 
,replace(replace(t1.product_category_id,chr(13),''),chr(10),'') as product_category_id 
,replace(replace(t1.global_trans_id,chr(13),''),chr(10),'') as global_trans_id 
,replace(replace(t1.prod_catalog_id,chr(13),''),chr(10),'') as prod_catalog_id 
,replace(replace(t1.stop_order_created,chr(13),''),chr(10),'') as stop_order_created 
,replace(replace(t1.stop_order_received,chr(13),''),chr(10),'') as stop_order_received 
,replace(replace(t1.do_received_fail,chr(13),''),chr(10),'') as do_received_fail 
,replace(replace(t1.do_delivery_fail,chr(13),''),chr(10),'') as do_delivery_fail 
,replace(replace(t1.payer_payment_method_type_id,chr(13),''),chr(10),'') as payer_payment_method_type_id 
,replace(replace(t1.payer_party_id,chr(13),''),chr(10),'') as payer_party_id 
,replace(replace(t1.payer_account_number,chr(13),''),chr(10),'') as payer_account_number 
,replace(replace(t1.payer_account_name,chr(13),''),chr(10),'') as payer_account_name 
,replace(replace(t1.payer_voucher_type_id,chr(13),''),chr(10),'') as payer_voucher_type_id 
,replace(replace(t1.payer_voucher_number,chr(13),''),chr(10),'') as payer_voucher_number 
,replace(replace(t1.payer_cash_or_remit_flag,chr(13),''),chr(10),'') as payer_cash_or_remit_flag 
,replace(replace(t1.payer_cert_no,chr(13),''),chr(10),'') as payer_cert_no 
,replace(replace(t1.payer_mobile_phone_number,chr(13),''),chr(10),'') as payer_mobile_phone_number 
,replace(replace(t1.payee_payment_method_type_id,chr(13),''),chr(10),'') as payee_payment_method_type_id 
,replace(replace(t1.payee_party_id,chr(13),''),chr(10),'') as payee_party_id 
,replace(replace(t1.payee_account_number,chr(13),''),chr(10),'') as payee_account_number 
,replace(replace(t1.payee_account_name,chr(13),''),chr(10),'') as payee_account_name 
,replace(replace(t1.payee_voucher_type_id,chr(13),''),chr(10),'') as payee_voucher_type_id 
,replace(replace(t1.payee_voucher_number,chr(13),''),chr(10),'') as payee_voucher_number 
,replace(replace(t1.payee_cash_or_remit_flag,chr(13),''),chr(10),'') as payee_cash_or_remit_flag 
,replace(replace(t1.payee_cert_no,chr(13),''),chr(10),'') as payee_cert_no 
,replace(replace(t1.payee_mobile_phone_number,chr(13),''),chr(10),'') as payee_mobile_phone_number 
,replace(replace(t1.pre_auth_cancel_trans_id,chr(13),''),chr(10),'') as pre_auth_cancel_trans_id 
,replace(replace(t1.payer_cust_no,chr(13),''),chr(10),'') as payer_cust_no 
,replace(replace(t1.authr_teller_no,chr(13),''),chr(10),'') as authr_teller_no 
,replace(replace(t1.ret_code,chr(13),''),chr(10),'') as ret_code 
,replace(replace(t1.ret_message,chr(13),''),chr(10),'') as ret_message 
,replace(replace(t1.is_next_day,chr(13),''),chr(10),'') as is_next_day 
,t1.trans_time as trans_time 
,replace(replace(t1.trans_code,chr(13),''),chr(10),'') as trans_code 
,replace(replace(t1.checking_code,chr(13),''),chr(10),'') as checking_code 
,replace(replace(t1.payer_voucher_date,chr(13),''),chr(10),'') as payer_voucher_date 
,replace(replace(t1.payee_voucher_date,chr(13),''),chr(10),'') as payee_voucher_date 
from ${iol_schema}.upps_order_header t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/upps_order_header.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes