: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_upps_order_header_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_upps_order_header.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select t1.order_id
,t1.order_type_id
,t1.order_name
,t1.external_id
,t1.sales_channel_enum_id
,t1.order_date
,t1.priority
,t1.entry_date
,t1.pick_sheet_printed_date
,t1.visit_id
,t1.status_id
,t1.created_by
,t1.first_attempt_order_id
,t1.currency_uom
,t1.sync_status_id
,t1.billing_account_id
,t1.origin_facility_id
,t1.web_site_id
,t1.product_store_id
,t1.terminal_id
,t1.transaction_id
,t1.auto_order_shopping_list_id
,t1.needs_inventory_issuance
,t1.is_rush_order
,t1.internal_code
,t1.remaining_sub_total
,t1.grand_total
,t1.is_viewed
,t1.last_updated_stamp
,t1.last_updated_tx_stamp
,t1.created_stamp
,t1.created_tx_stamp
,t1.product_id
,t1.internal_note
,t1.public_note
,t1.amount
,t1.orig_order_id
,t1.product_category_id
,t1.global_trans_id
,t1.prod_catalog_id
,t1.stop_order_created
,t1.stop_order_received
,t1.do_received_fail
,t1.do_delivery_fail
,t1.payer_payment_method_type_id
,t1.payer_party_id
,t1.payer_account_number
,t1.payer_account_name
,t1.payer_voucher_type_id
,t1.payer_voucher_number
,t1.payer_cash_or_remit_flag
,t1.payer_cert_no
,t1.payer_mobile_phone_number
,t1.payee_payment_method_type_id
,t1.payee_party_id
,t1.payee_account_number
,t1.payee_account_name
,t1.payee_voucher_type_id
,t1.payee_voucher_number
,t1.payee_cash_or_remit_flag
,t1.payee_cert_no
,t1.payee_mobile_phone_number
,t1.pre_auth_cancel_trans_id
,t1.payer_cust_no
,t1.authr_teller_no
,t1.ret_code
,t1.ret_message
,t1.is_next_day
,t1.trans_time
,t1.trans_code
,t1.checking_code
,t1.payer_voucher_date
,t1.payee_voucher_date
from ${idl_schema}.hdws_upps_order_header t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_upps_order_header.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes