/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifds_v_payment_all
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifds_v_payment_all_ex purge;
alter table ${iol_schema}.ifds_v_payment_all add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ifds_v_payment_all;

-- 2.3 insert data to ex table
create table ${iol_schema}.ifds_v_payment_all_ex nologging
compress
as
select * from ${iol_schema}.ifds_v_payment_all where 0=1;

insert /*+ append */ into ${iol_schema}.ifds_v_payment_all_ex(
    payment_id -- 
    ,payment_type_id -- 
    ,payment_method_type_id -- 
    ,payment_method_id -- 
    ,payment_gateway_response_id -- 
    ,payment_preference_id -- 
    ,party_id_from -- 
    ,party_id_to -- 
    ,role_type_id_to -- 
    ,status_id -- 
    ,effective_date -- 
    ,payment_ref_num -- 
    ,amount -- 
    ,currency_uom_id -- 
    ,comments -- 
    ,fin_account_trans_id -- 
    ,override_gl_account_id -- 
    ,actual_currency_amount -- 
    ,actual_currency_uom_id -- 
    ,last_updated_stamp -- 
    ,last_updated_tx_stamp -- 
    ,created_stamp -- 
    ,created_tx_stamp -- 
    ,opp_account_num -- 
    ,opp_account_name -- 
    ,opp_bank_num -- 
    ,opp_bank_name -- 
    ,fin_account_id -- 
    ,acc_name -- 
    ,trade_party_id -- 
    ,all_receive_date -- 
    ,parent_payment_id -- 
    ,summary_info -- 
    ,postscript -- 
    ,num -- 
    ,re_type -- 
    ,payment_trans_kind -- 
    ,actual_balance -- 实际余额
    ,available_balance -- 可用余额
    ,is_show -- 是否对外展示
    ,transaction_type -- 
    ,transaction_serial -- 
    ,merchant_code -- 
    ,merchant_name -- 
    ,transaction_address -- 
    ,check_bill_product_id -- 
    ,check_bill_date -- 
    ,customer_id -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    payment_id -- 
    ,payment_type_id -- 
    ,payment_method_type_id -- 
    ,payment_method_id -- 
    ,payment_gateway_response_id -- 
    ,payment_preference_id -- 
    ,party_id_from -- 
    ,party_id_to -- 
    ,role_type_id_to -- 
    ,status_id -- 
    ,effective_date -- 
    ,payment_ref_num -- 
    ,amount -- 
    ,currency_uom_id -- 
    ,comments -- 
    ,fin_account_trans_id -- 
    ,override_gl_account_id -- 
    ,actual_currency_amount -- 
    ,actual_currency_uom_id -- 
    ,last_updated_stamp -- 
    ,last_updated_tx_stamp -- 
    ,created_stamp -- 
    ,created_tx_stamp -- 
    ,opp_account_num -- 
    ,opp_account_name -- 
    ,opp_bank_num -- 
    ,opp_bank_name -- 
    ,fin_account_id -- 
    ,acc_name -- 
    ,trade_party_id -- 
    ,all_receive_date -- 
    ,parent_payment_id -- 
    ,summary_info -- 
    ,postscript -- 
    ,num -- 
    ,re_type -- 
    ,payment_trans_kind -- 
    ,actual_balance -- 实际余额
    ,available_balance -- 可用余额
    ,is_show -- 是否对外展示
    ,transaction_type -- 
    ,transaction_serial -- 
    ,merchant_code -- 
    ,merchant_name -- 
    ,transaction_address -- 
    ,check_bill_product_id -- 
    ,check_bill_date -- 
    ,customer_id -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifds_v_payment_all
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifds_v_payment_all exchange partition p_${batch_date} with table ${iol_schema}.ifds_v_payment_all_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifds_v_payment_all to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifds_v_payment_all_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifds_v_payment_all',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);