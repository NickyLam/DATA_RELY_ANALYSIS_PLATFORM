/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rtis_credit_operation
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
drop table ${iol_schema}.rtis_credit_operation_ex purge;
alter table ${iol_schema}.rtis_credit_operation add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rtis_credit_operation truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rtis_credit_operation_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_credit_operation where 0=1;

insert /*+ append */ into ${iol_schema}.rtis_credit_operation_ex(
    id_ -- 
    ,tenant_id -- 
    ,user_id -- 
    ,oper_no -- 
    ,oper_type -- 
    ,apply_chnl -- 
    ,oper_time -- 
    ,oper_status -- 
    ,order_id -- 
    ,col_cust_id -- 
    ,col_cust_name -- 
    ,amount -- 
    ,account_id -- 
    ,bank_id -- 
    ,bank_card_no -- 
    ,bank_card_type -- 
    ,ip_addr -- 
    ,ip_prv -- 
    ,ip_city -- 
    ,mac -- 
    ,imei -- 
    ,sim -- 
    ,device_finger -- 
    ,create_time -- 
    ,id_card -- 
    ,phone -- 
    ,phone_addr -- 
    ,phone_prv -- 
    ,phone_city -- 
    ,phone_company -- 
    ,oper_from -- 
    ,location_x -- 
    ,location_y -- 
    ,last_update_time -- 
    ,last_status -- 
    ,create_at -- 
    ,create_by -- 
    ,last_update_at -- 
    ,last_update_by -- 
    ,regiser_address -- 
    ,company_tel -- 
    ,resp_code -- 
    ,rn_auth_phone -- 
    ,rn_auth_card_no -- 
    ,user_name -- 
    ,corporate_business_no -- 
    ,product_application -- 
    ,org_rec_amount -- 
    ,registered_amount -- 
    ,id_card_type -- 
    ,id_card_number -- 
    ,acct_type -- 
    ,phone_prov -- 
    ,sex -- 
    ,latitude -- 
    ,phone_1_7 -- 
    ,id_card_number_1_4 -- 
    ,id_card_county -- 
    ,id_card_prov -- 
    ,age -- 
    ,shareholder_id_card_type -- 
    ,shareholder_id_card_no -- 
    ,cust_occu -- 
    ,cust_linkman_card_type -- 
    ,cust_linkman_card_no -- 
    ,cust_famliy_name -- 
    ,cust_delegate_card_type -- 
    ,cust_delegate_card_no -- 
    ,cust_receiptor_card_type -- 
    ,cust_receiptor_card_no -- 
    ,cust_principal_card_type -- 
    ,cust_principal_card_no -- 
    ,corporate_type -- 
    ,corporate_no -- 
    ,address_anthenticity_score -- 
    ,address_similarity -- 
    ,cust_address -- 
    ,agent_id_card_no -- 
    ,coordinate_type -- 
    ,lot_lat_city -- 
    ,longitude -- 
    ,id_card_country -- 
    ,is_false_no -- 
    ,corporate_bussiness_no -- 
    ,corporate_phone_no -- 
    ,proxy_ip_flag -- 
    ,idc_ip_flag -- 
    ,virtual_operator_no -- 
    ,oper_prov -- 
    ,oper_city -- 
    ,oper_site -- 
    ,biz_code -- 
    ,oper_county -- 
    ,finance_manager_no -- 
    ,finance_manager_business_no -- 
    ,bind_card_no -- 
    ,account_holder_name -- 
    ,business_scope -- 
    ,prove_paper_indate -- 
    ,prove_paper_no -- 
    ,corporate_name -- 
    ,oper_ip -- 
    ,cust_type -- 
    ,id_card_indate -- 
    ,open_at -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id_ -- 
    ,tenant_id -- 
    ,user_id -- 
    ,oper_no -- 
    ,oper_type -- 
    ,apply_chnl -- 
    ,oper_time -- 
    ,oper_status -- 
    ,order_id -- 
    ,col_cust_id -- 
    ,col_cust_name -- 
    ,amount -- 
    ,account_id -- 
    ,bank_id -- 
    ,bank_card_no -- 
    ,bank_card_type -- 
    ,ip_addr -- 
    ,ip_prv -- 
    ,ip_city -- 
    ,mac -- 
    ,imei -- 
    ,sim -- 
    ,device_finger -- 
    ,create_time -- 
    ,id_card -- 
    ,phone -- 
    ,phone_addr -- 
    ,phone_prv -- 
    ,phone_city -- 
    ,phone_company -- 
    ,oper_from -- 
    ,location_x -- 
    ,location_y -- 
    ,last_update_time -- 
    ,last_status -- 
    ,create_at -- 
    ,create_by -- 
    ,last_update_at -- 
    ,last_update_by -- 
    ,regiser_address -- 
    ,company_tel -- 
    ,resp_code -- 
    ,rn_auth_phone -- 
    ,rn_auth_card_no -- 
    ,user_name -- 
    ,corporate_business_no -- 
    ,product_application -- 
    ,org_rec_amount -- 
    ,registered_amount -- 
    ,id_card_type -- 
    ,id_card_number -- 
    ,acct_type -- 
    ,phone_prov -- 
    ,sex -- 
    ,latitude -- 
    ,phone_1_7 -- 
    ,id_card_number_1_4 -- 
    ,id_card_county -- 
    ,id_card_prov -- 
    ,age -- 
    ,shareholder_id_card_type -- 
    ,shareholder_id_card_no -- 
    ,cust_occu -- 
    ,cust_linkman_card_type -- 
    ,cust_linkman_card_no -- 
    ,cust_famliy_name -- 
    ,cust_delegate_card_type -- 
    ,cust_delegate_card_no -- 
    ,cust_receiptor_card_type -- 
    ,cust_receiptor_card_no -- 
    ,cust_principal_card_type -- 
    ,cust_principal_card_no -- 
    ,corporate_type -- 
    ,corporate_no -- 
    ,address_anthenticity_score -- 
    ,address_similarity -- 
    ,cust_address -- 
    ,agent_id_card_no -- 
    ,coordinate_type -- 
    ,lot_lat_city -- 
    ,longitude -- 
    ,id_card_country -- 
    ,is_false_no -- 
    ,corporate_bussiness_no -- 
    ,corporate_phone_no -- 
    ,proxy_ip_flag -- 
    ,idc_ip_flag -- 
    ,virtual_operator_no -- 
    ,oper_prov -- 
    ,oper_city -- 
    ,oper_site -- 
    ,biz_code -- 
    ,oper_county -- 
    ,finance_manager_no -- 
    ,finance_manager_business_no -- 
    ,bind_card_no -- 
    ,account_holder_name -- 
    ,business_scope -- 
    ,prove_paper_indate -- 
    ,prove_paper_no -- 
    ,corporate_name -- 
    ,oper_ip -- 
    ,cust_type -- 
    ,id_card_indate -- 
    ,open_at -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rtis_credit_operation
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rtis_credit_operation exchange partition p_${batch_date} with table ${iol_schema}.rtis_credit_operation_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rtis_credit_operation to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rtis_credit_operation_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rtis_credit_operation',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);