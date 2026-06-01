/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_upps_order_header
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--数仓增量方式供数，保存历史
--alter table ${itl_schema}.itl_edw_upps_order_header drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_upps_order_header drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_upps_order_header add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_upps_order_header partition for (to_date('${batch_date}','yyyymmdd')) (
    order_id -- 
    ,order_type_id -- 
    ,order_name -- 
    ,external_id -- 
    ,sales_channel_enum_id -- 
    ,order_date -- 
    ,priority -- 
    ,entry_date -- 
    ,pick_sheet_printed_date -- 
    ,visit_id -- 
    ,status_id -- 
    ,created_by -- 
    ,first_attempt_order_id -- 
    ,currency_uom -- 
    ,sync_status_id -- 
    ,billing_account_id -- 
    ,origin_facility_id -- 
    ,web_site_id -- 
    ,product_store_id -- 
    ,terminal_id -- 
    ,transaction_id -- 
    ,auto_order_shopping_list_id -- 
    ,needs_inventory_issuance -- 
    ,is_rush_order -- 
    ,internal_code -- 
    ,remaining_sub_total -- 
    ,grand_total -- 
    ,is_viewed -- 
    ,last_updated_stamp -- 
    ,last_updated_tx_stamp -- 
    ,created_stamp -- 
    ,created_tx_stamp -- 
    ,product_id -- 
    ,internal_note -- 
    ,public_note -- 
    ,amount -- 
    ,orig_order_id -- 
    ,product_category_id -- 
    ,global_trans_id -- 
    ,prod_catalog_id -- 
    ,stop_order_created -- 
    ,stop_order_received -- 
    ,do_received_fail -- 
    ,do_delivery_fail -- 
    ,payer_payment_method_type_id -- 
    ,payer_party_id -- 
    ,payer_account_number -- 
    ,payer_account_name -- 
    ,payer_voucher_type_id -- 
    ,payer_voucher_number -- 
    ,payer_cash_or_remit_flag -- 
    ,payer_cert_no -- 
    ,payer_mobile_phone_number -- 
    ,payee_payment_method_type_id -- 
    ,payee_party_id -- 
    ,payee_account_number -- 
    ,payee_account_name -- 
    ,payee_voucher_type_id -- 
    ,payee_voucher_number -- 
    ,payee_cash_or_remit_flag -- 
    ,payee_cert_no -- 
    ,payee_mobile_phone_number -- 
    ,pre_auth_cancel_trans_id -- 
    ,payer_cust_no -- 
    ,authr_teller_no -- 
    ,ret_code -- 
    ,ret_message -- 
    ,is_next_day -- 
    ,trans_time -- 
    ,trans_code -- 
    ,checking_code -- 
    ,payer_voucher_date -- 
    ,payee_voucher_date -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(order_id), ' ') as order_id -- 
    ,nvl(trim(order_type_id), ' ') as order_type_id -- 
    ,nvl(trim(order_name), ' ') as order_name -- 
    ,nvl(trim(external_id), ' ') as external_id -- 
    ,nvl(trim(sales_channel_enum_id), ' ') as sales_channel_enum_id -- 
    ,nvl(order_date, to_timestamp('00010101', 'yyyymmdd')) as order_date -- 
    ,nvl(trim(priority), ' ') as priority -- 
    ,nvl(entry_date, to_timestamp('00010101', 'yyyymmdd')) as entry_date -- 
    ,nvl(pick_sheet_printed_date, to_timestamp('00010101', 'yyyymmdd')) as pick_sheet_printed_date -- 
    ,nvl(trim(visit_id), ' ') as visit_id -- 
    ,nvl(trim(status_id), ' ') as status_id -- 
    ,nvl(trim(created_by), ' ') as created_by -- 
    ,nvl(trim(first_attempt_order_id), ' ') as first_attempt_order_id -- 
    ,nvl(trim(currency_uom), ' ') as currency_uom -- 
    ,nvl(trim(sync_status_id), ' ') as sync_status_id -- 
    ,nvl(trim(billing_account_id), ' ') as billing_account_id -- 
    ,nvl(trim(origin_facility_id), ' ') as origin_facility_id -- 
    ,nvl(trim(web_site_id), ' ') as web_site_id -- 
    ,nvl(trim(product_store_id), ' ') as product_store_id -- 
    ,nvl(trim(terminal_id), ' ') as terminal_id -- 
    ,nvl(trim(transaction_id), ' ') as transaction_id -- 
    ,nvl(trim(auto_order_shopping_list_id), ' ') as auto_order_shopping_list_id -- 
    ,nvl(trim(needs_inventory_issuance), ' ') as needs_inventory_issuance -- 
    ,nvl(trim(is_rush_order), ' ') as is_rush_order -- 
    ,nvl(trim(internal_code), ' ') as internal_code -- 
    ,nvl(trim(remaining_sub_total), 0) as remaining_sub_total -- 
    ,nvl(trim(grand_total), 0) as grand_total -- 
    ,nvl(trim(is_viewed), ' ') as is_viewed -- 
    ,nvl(last_updated_stamp, to_timestamp('00010101', 'yyyymmdd')) as last_updated_stamp -- 
    ,nvl(last_updated_tx_stamp, to_timestamp('00010101', 'yyyymmdd')) as last_updated_tx_stamp -- 
    ,nvl(created_stamp, to_timestamp('00010101', 'yyyymmdd')) as created_stamp -- 
    ,nvl(created_tx_stamp, to_timestamp('00010101', 'yyyymmdd')) as created_tx_stamp -- 
    ,nvl(trim(product_id), ' ') as product_id -- 
    ,nvl(trim(internal_note), ' ') as internal_note -- 
    ,nvl(trim(public_note), ' ') as public_note -- 
    ,nvl(trim(amount), 0) as amount -- 
    ,nvl(trim(orig_order_id), ' ') as orig_order_id -- 
    ,nvl(trim(product_category_id), ' ') as product_category_id -- 
    ,nvl(trim(global_trans_id), ' ') as global_trans_id -- 
    ,nvl(trim(prod_catalog_id), ' ') as prod_catalog_id -- 
    ,nvl(trim(stop_order_created), ' ') as stop_order_created -- 
    ,nvl(trim(stop_order_received), ' ') as stop_order_received -- 
    ,nvl(trim(do_received_fail), ' ') as do_received_fail -- 
    ,nvl(trim(do_delivery_fail), ' ') as do_delivery_fail -- 
    ,nvl(trim(payer_payment_method_type_id), ' ') as payer_payment_method_type_id -- 
    ,nvl(trim(payer_party_id), ' ') as payer_party_id -- 
    ,nvl(trim(payer_account_number), ' ') as payer_account_number -- 
    ,nvl(trim(payer_account_name), ' ') as payer_account_name -- 
    ,nvl(trim(payer_voucher_type_id), ' ') as payer_voucher_type_id -- 
    ,nvl(trim(payer_voucher_number), ' ') as payer_voucher_number -- 
    ,nvl(trim(payer_cash_or_remit_flag), ' ') as payer_cash_or_remit_flag -- 
    ,nvl(trim(payer_cert_no), ' ') as payer_cert_no -- 
    ,nvl(trim(payer_mobile_phone_number), ' ') as payer_mobile_phone_number -- 
    ,nvl(trim(payee_payment_method_type_id), ' ') as payee_payment_method_type_id -- 
    ,nvl(trim(payee_party_id), ' ') as payee_party_id -- 
    ,nvl(trim(payee_account_number), ' ') as payee_account_number -- 
    ,nvl(trim(payee_account_name), ' ') as payee_account_name -- 
    ,nvl(trim(payee_voucher_type_id), ' ') as payee_voucher_type_id -- 
    ,nvl(trim(payee_voucher_number), ' ') as payee_voucher_number -- 
    ,nvl(trim(payee_cash_or_remit_flag), ' ') as payee_cash_or_remit_flag -- 
    ,nvl(trim(payee_cert_no), ' ') as payee_cert_no -- 
    ,nvl(trim(payee_mobile_phone_number), ' ') as payee_mobile_phone_number -- 
    ,nvl(trim(pre_auth_cancel_trans_id), ' ') as pre_auth_cancel_trans_id -- 
    ,nvl(trim(payer_cust_no), ' ') as payer_cust_no -- 
    ,nvl(trim(authr_teller_no), ' ') as authr_teller_no -- 
    ,nvl(trim(ret_code), ' ') as ret_code -- 
    ,nvl(trim(ret_message), ' ') as ret_message -- 
    ,nvl(trim(is_next_day), ' ') as is_next_day -- 
    ,nvl(trans_time, to_timestamp('00010101', 'yyyymmdd')) as trans_time -- 
    ,nvl(trim(trans_code), ' ') as trans_code -- 
    ,nvl(trim(checking_code), ' ') as checking_code -- 
    ,nvl(trim(payer_voucher_date), ' ') as payer_voucher_date -- 
    ,nvl(trim(payee_voucher_date), ' ') as payee_voucher_date -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_upps_order_header
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_upps_order_header to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_upps_order_header',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);