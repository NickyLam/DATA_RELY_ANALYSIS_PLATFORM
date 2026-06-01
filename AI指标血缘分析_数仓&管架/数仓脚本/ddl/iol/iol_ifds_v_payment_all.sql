/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifds_v_payment_all
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifds_v_payment_all
whenever sqlerror continue none;
drop table ${iol_schema}.ifds_v_payment_all purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifds_v_payment_all(
    payment_id varchar2(30) -- 
    ,payment_type_id varchar2(30) -- 
    ,payment_method_type_id varchar2(30) -- 
    ,payment_method_id varchar2(30) -- 
    ,payment_gateway_response_id varchar2(30) -- 
    ,payment_preference_id varchar2(30) -- 
    ,party_id_from varchar2(30) -- 
    ,party_id_to varchar2(30) -- 
    ,role_type_id_to varchar2(30) -- 
    ,status_id varchar2(30) -- 
    ,effective_date timestamp -- 
    ,payment_ref_num varchar2(96) -- 
    ,amount number(18,2) -- 
    ,currency_uom_id varchar2(30) -- 
    ,comments varchar2(1500) -- 
    ,fin_account_trans_id varchar2(30) -- 
    ,override_gl_account_id varchar2(30) -- 
    ,actual_currency_amount number(18,2) -- 
    ,actual_currency_uom_id varchar2(30) -- 
    ,last_updated_stamp timestamp -- 
    ,last_updated_tx_stamp timestamp -- 
    ,created_stamp timestamp -- 
    ,created_tx_stamp timestamp -- 
    ,opp_account_num varchar2(90) -- 
    ,opp_account_name varchar2(383) -- 
    ,opp_bank_num varchar2(90) -- 
    ,opp_bank_name varchar2(383) -- 
    ,fin_account_id varchar2(30) -- 
    ,acc_name varchar2(383) -- 
    ,trade_party_id varchar2(30) -- 
    ,all_receive_date timestamp -- 
    ,parent_payment_id varchar2(30) -- 
    ,summary_info varchar2(383) -- 
    ,postscript varchar2(383) -- 
    ,num varchar2(30) -- 
    ,re_type varchar2(30) -- 
    ,payment_trans_kind varchar2(30) -- 
    ,actual_balance number(18,2) -- 实际余额
    ,available_balance number(18,2) -- 可用余额
    ,is_show varchar2(2) -- 是否对外展示
    ,transaction_type varchar2(90) -- 
    ,transaction_serial varchar2(90) -- 
    ,merchant_code varchar2(90) -- 
    ,merchant_name varchar2(450) -- 
    ,transaction_address varchar2(450) -- 
    ,check_bill_product_id varchar2(45) -- 
    ,check_bill_date timestamp -- 
    ,customer_id varchar2(30) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifds_v_payment_all to ${iml_schema};
grant select on ${iol_schema}.ifds_v_payment_all to ${icl_schema};
grant select on ${iol_schema}.ifds_v_payment_all to ${idl_schema};
grant select on ${iol_schema}.ifds_v_payment_all to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifds_v_payment_all is '账户交易支付明细';
comment on column ${iol_schema}.ifds_v_payment_all.payment_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.payment_type_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.payment_method_type_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.payment_method_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.payment_gateway_response_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.payment_preference_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.party_id_from is '';
comment on column ${iol_schema}.ifds_v_payment_all.party_id_to is '';
comment on column ${iol_schema}.ifds_v_payment_all.role_type_id_to is '';
comment on column ${iol_schema}.ifds_v_payment_all.status_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.effective_date is '';
comment on column ${iol_schema}.ifds_v_payment_all.payment_ref_num is '';
comment on column ${iol_schema}.ifds_v_payment_all.amount is '';
comment on column ${iol_schema}.ifds_v_payment_all.currency_uom_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.comments is '';
comment on column ${iol_schema}.ifds_v_payment_all.fin_account_trans_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.override_gl_account_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.actual_currency_amount is '';
comment on column ${iol_schema}.ifds_v_payment_all.actual_currency_uom_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.last_updated_stamp is '';
comment on column ${iol_schema}.ifds_v_payment_all.last_updated_tx_stamp is '';
comment on column ${iol_schema}.ifds_v_payment_all.created_stamp is '';
comment on column ${iol_schema}.ifds_v_payment_all.created_tx_stamp is '';
comment on column ${iol_schema}.ifds_v_payment_all.opp_account_num is '';
comment on column ${iol_schema}.ifds_v_payment_all.opp_account_name is '';
comment on column ${iol_schema}.ifds_v_payment_all.opp_bank_num is '';
comment on column ${iol_schema}.ifds_v_payment_all.opp_bank_name is '';
comment on column ${iol_schema}.ifds_v_payment_all.fin_account_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.acc_name is '';
comment on column ${iol_schema}.ifds_v_payment_all.trade_party_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.all_receive_date is '';
comment on column ${iol_schema}.ifds_v_payment_all.parent_payment_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.summary_info is '';
comment on column ${iol_schema}.ifds_v_payment_all.postscript is '';
comment on column ${iol_schema}.ifds_v_payment_all.num is '';
comment on column ${iol_schema}.ifds_v_payment_all.re_type is '';
comment on column ${iol_schema}.ifds_v_payment_all.payment_trans_kind is '';
comment on column ${iol_schema}.ifds_v_payment_all.actual_balance is '实际余额';
comment on column ${iol_schema}.ifds_v_payment_all.available_balance is '可用余额';
comment on column ${iol_schema}.ifds_v_payment_all.is_show is '是否对外展示';
comment on column ${iol_schema}.ifds_v_payment_all.transaction_type is '';
comment on column ${iol_schema}.ifds_v_payment_all.transaction_serial is '';
comment on column ${iol_schema}.ifds_v_payment_all.merchant_code is '';
comment on column ${iol_schema}.ifds_v_payment_all.merchant_name is '';
comment on column ${iol_schema}.ifds_v_payment_all.transaction_address is '';
comment on column ${iol_schema}.ifds_v_payment_all.check_bill_product_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.check_bill_date is '';
comment on column ${iol_schema}.ifds_v_payment_all.customer_id is '';
comment on column ${iol_schema}.ifds_v_payment_all.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifds_v_payment_all.etl_timestamp is 'ETL处理时间戳';
