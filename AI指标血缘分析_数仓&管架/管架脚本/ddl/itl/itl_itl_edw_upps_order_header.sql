/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_upps_order_header
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_upps_order_header
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_upps_order_header purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_upps_order_header(
    order_id varchar2(20) -- 
    ,order_type_id varchar2(20) -- 
    ,order_name varchar2(100) -- 
    ,external_id varchar2(20) -- 
    ,sales_channel_enum_id varchar2(20) -- 
    ,order_date timestamp -- 
    ,priority varchar2(1) -- 
    ,entry_date timestamp -- 
    ,pick_sheet_printed_date timestamp -- 
    ,visit_id varchar2(20) -- 
    ,status_id varchar2(20) -- 
    ,created_by varchar2(255) -- 
    ,first_attempt_order_id varchar2(20) -- 
    ,currency_uom varchar2(20) -- 
    ,sync_status_id varchar2(20) -- 
    ,billing_account_id varchar2(20) -- 
    ,origin_facility_id varchar2(20) -- 
    ,web_site_id varchar2(20) -- 
    ,product_store_id varchar2(20) -- 
    ,terminal_id varchar2(60) -- 
    ,transaction_id varchar2(60) -- 
    ,auto_order_shopping_list_id varchar2(20) -- 
    ,needs_inventory_issuance varchar2(1) -- 
    ,is_rush_order varchar2(1) -- 
    ,internal_code varchar2(60) -- 
    ,remaining_sub_total number(18,2) -- 
    ,grand_total number(18,2) -- 
    ,is_viewed varchar2(1) -- 
    ,last_updated_stamp timestamp -- 
    ,last_updated_tx_stamp timestamp -- 
    ,created_stamp timestamp -- 
    ,created_tx_stamp timestamp -- 
    ,product_id varchar2(20) -- 
    ,internal_note varchar2(255) -- 
    ,public_note varchar2(255) -- 
    ,amount number(18,2) -- 
    ,orig_order_id varchar2(255) -- 
    ,product_category_id varchar2(20) -- 
    ,global_trans_id varchar2(60) -- 
    ,prod_catalog_id varchar2(20) -- 
    ,stop_order_created varchar2(60) -- 
    ,stop_order_received varchar2(60) -- 
    ,do_received_fail varchar2(60) -- 
    ,do_delivery_fail varchar2(60) -- 
    ,payer_payment_method_type_id varchar2(20) -- 
    ,payer_party_id varchar2(20) -- 
    ,payer_account_number varchar2(60) -- 
    ,payer_account_name varchar2(255) -- 
    ,payer_voucher_type_id varchar2(20) -- 
    ,payer_voucher_number varchar2(60) -- 
    ,payer_cash_or_remit_flag varchar2(1) -- 
    ,payer_cert_no varchar2(60) -- 
    ,payer_mobile_phone_number varchar2(20) -- 
    ,payee_payment_method_type_id varchar2(20) -- 
    ,payee_party_id varchar2(20) -- 
    ,payee_account_number varchar2(60) -- 
    ,payee_account_name varchar2(255) -- 
    ,payee_voucher_type_id varchar2(20) -- 
    ,payee_voucher_number varchar2(60) -- 
    ,payee_cash_or_remit_flag varchar2(1) -- 
    ,payee_cert_no varchar2(60) -- 
    ,payee_mobile_phone_number varchar2(20) -- 
    ,pre_auth_cancel_trans_id varchar2(60) -- 
    ,payer_cust_no varchar2(20) -- 
    ,authr_teller_no varchar2(20) -- 
    ,ret_code varchar2(20) -- 
    ,ret_message varchar2(255) -- 
    ,is_next_day varchar2(1) -- 
    ,trans_time timestamp -- 
    ,trans_code varchar2(10) -- 
    ,checking_code varchar2(60) -- 
    ,payer_voucher_date varchar2(20) -- 
    ,payee_voucher_date varchar2(20) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_upps_order_header to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_upps_order_header is '订单信息表';
comment on column ${itl_schema}.itl_edw_upps_order_header.order_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.order_type_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.order_name is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.external_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.sales_channel_enum_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.order_date is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.priority is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.entry_date is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.pick_sheet_printed_date is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.visit_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.status_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.created_by is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.first_attempt_order_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.currency_uom is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.sync_status_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.billing_account_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.origin_facility_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.web_site_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.product_store_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.terminal_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.transaction_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.auto_order_shopping_list_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.needs_inventory_issuance is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.is_rush_order is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.internal_code is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.remaining_sub_total is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.grand_total is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.is_viewed is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.last_updated_stamp is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.last_updated_tx_stamp is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.created_stamp is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.created_tx_stamp is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.product_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.internal_note is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.public_note is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.amount is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.orig_order_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.product_category_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.global_trans_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.prod_catalog_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.stop_order_created is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.stop_order_received is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.do_received_fail is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.do_delivery_fail is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payer_payment_method_type_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payer_party_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payer_account_number is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payer_account_name is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payer_voucher_type_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payer_voucher_number is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payer_cash_or_remit_flag is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payer_cert_no is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payer_mobile_phone_number is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payee_payment_method_type_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payee_party_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payee_account_number is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payee_account_name is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payee_voucher_type_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payee_voucher_number is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payee_cash_or_remit_flag is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payee_cert_no is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payee_mobile_phone_number is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.pre_auth_cancel_trans_id is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payer_cust_no is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.authr_teller_no is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.ret_code is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.ret_message is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.is_next_day is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.trans_time is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.trans_code is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.checking_code is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payer_voucher_date is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.payee_voucher_date is '';
comment on column ${itl_schema}.itl_edw_upps_order_header.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_upps_order_header.etl_timestamp is 'ETL处理时间戳';