: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_eass_order_header_f
CreateDate: 20180529
FileName:   ${iel_data_path}/eass_order_header.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.order_id,chr(13),''),chr(10),'') as order_id
,replace(replace(t.order_type_id,chr(13),''),chr(10),'') as order_type_id
,replace(replace(t.order_name,chr(13),''),chr(10),'') as order_name
,replace(replace(t.external_id,chr(13),''),chr(10),'') as external_id
,replace(replace(t.sales_channel_enum_id,chr(13),''),chr(10),'') as sales_channel_enum_id
,t.order_date as order_date
,replace(replace(t.priority,chr(13),''),chr(10),'') as priority
,t.entry_date as entry_date
,t.pick_sheet_printed_date as pick_sheet_printed_date
,replace(replace(t.visit_id,chr(13),''),chr(10),'') as visit_id
,replace(replace(t.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t.created_by,chr(13),''),chr(10),'') as created_by
,replace(replace(t.first_attempt_order_id,chr(13),''),chr(10),'') as first_attempt_order_id
,replace(replace(t.currency_uom,chr(13),''),chr(10),'') as currency_uom
,replace(replace(t.sync_status_id,chr(13),''),chr(10),'') as sync_status_id
,replace(replace(t.billing_account_id,chr(13),''),chr(10),'') as billing_account_id
,replace(replace(t.origin_facility_id,chr(13),''),chr(10),'') as origin_facility_id
,replace(replace(t.web_site_id,chr(13),''),chr(10),'') as web_site_id
,replace(replace(t.product_store_id,chr(13),''),chr(10),'') as product_store_id
,replace(replace(t.terminal_id,chr(13),''),chr(10),'') as terminal_id
,replace(replace(t.transaction_id,chr(13),''),chr(10),'') as transaction_id
,replace(replace(t.auto_order_shopping_list_id,chr(13),''),chr(10),'') as auto_order_shopping_list_id
,replace(replace(t.needs_inventory_issuance,chr(13),''),chr(10),'') as needs_inventory_issuance
,replace(replace(t.is_rush_order,chr(13),''),chr(10),'') as is_rush_order
,replace(replace(t.internal_code,chr(13),''),chr(10),'') as internal_code
,t.remaining_sub_total as remaining_sub_total
,t.grand_total as grand_total
,replace(replace(t.is_viewed,chr(13),''),chr(10),'') as is_viewed
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,replace(replace(t.freeze_record_id,chr(13),''),chr(10),'') as freeze_record_id
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.summary,chr(13),''),chr(10),'') as summary
,replace(replace(t.project_id,chr(13),''),chr(10),'') as project_id
,replace(replace(t.project_code,chr(13),''),chr(10),'') as project_code
,replace(replace(t.order_detail_type,chr(13),''),chr(10),'') as order_detail_type
,replace(replace(t.billing_account_name,chr(13),''),chr(10),'') as billing_account_name
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.eass_order_header t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eass_order_header.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes