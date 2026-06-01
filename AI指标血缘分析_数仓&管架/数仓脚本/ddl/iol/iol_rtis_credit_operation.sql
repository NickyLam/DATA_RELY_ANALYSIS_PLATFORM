/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rtis_credit_operation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rtis_credit_operation
whenever sqlerror continue none;
drop table ${iol_schema}.rtis_credit_operation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_credit_operation(
    id_ number(32,0) -- 
    ,tenant_id varchar2(80) -- 
    ,user_id varchar2(80) -- 
    ,oper_no varchar2(200) -- 
    ,oper_type varchar2(8) -- 
    ,apply_chnl varchar2(40) -- 
    ,oper_time timestamp -- 
    ,oper_status varchar2(4) -- 
    ,order_id varchar2(200) -- 
    ,col_cust_id varchar2(80) -- 
    ,col_cust_name varchar2(200) -- 
    ,amount number(18,0) -- 
    ,account_id varchar2(80) -- 
    ,bank_id varchar2(40) -- 
    ,bank_card_no varchar2(200) -- 
    ,bank_card_type varchar2(40) -- 
    ,ip_addr varchar2(64) -- 
    ,ip_prv varchar2(80) -- 
    ,ip_city varchar2(120) -- 
    ,mac varchar2(68) -- 
    ,imei varchar2(60) -- 
    ,sim varchar2(80) -- 
    ,device_finger varchar2(200) -- 
    ,create_time timestamp -- 
    ,id_card varchar2(1020) -- 
    ,phone varchar2(1020) -- 
    ,phone_addr varchar2(1020) -- 
    ,phone_prv varchar2(256) -- 
    ,phone_city varchar2(256) -- 
    ,phone_company varchar2(400) -- 
    ,oper_from varchar2(8) -- 
    ,location_x varchar2(200) -- 
    ,location_y varchar2(200) -- 
    ,last_update_time timestamp -- 
    ,last_status varchar2(40) -- 
    ,create_at timestamp -- 
    ,create_by varchar2(200) -- 
    ,last_update_at timestamp -- 
    ,last_update_by varchar2(200) -- 
    ,regiser_address varchar2(800) -- 
    ,company_tel varchar2(100) -- 
    ,resp_code varchar2(20) -- 
    ,rn_auth_phone varchar2(100) -- 
    ,rn_auth_card_no varchar2(100) -- 
    ,user_name varchar2(100) -- 
    ,corporate_business_no varchar2(100) -- 
    ,product_application varchar2(40) -- 
    ,org_rec_amount number(20,0) -- 
    ,registered_amount number(20,0) -- 
    ,id_card_type varchar2(100) -- 
    ,id_card_number varchar2(100) -- 
    ,acct_type varchar2(100) -- 
    ,phone_prov varchar2(100) -- 
    ,sex varchar2(100) -- 
    ,latitude varchar2(100) -- 
    ,phone_1_7 varchar2(100) -- 
    ,id_card_number_1_4 varchar2(100) -- 
    ,id_card_county varchar2(100) -- 
    ,id_card_prov varchar2(100) -- 
    ,age varchar2(100) -- 
    ,shareholder_id_card_type varchar2(100) -- 
    ,shareholder_id_card_no varchar2(100) -- 
    ,cust_occu varchar2(100) -- 
    ,cust_linkman_card_type varchar2(100) -- 
    ,cust_linkman_card_no varchar2(100) -- 
    ,cust_famliy_name varchar2(100) -- 
    ,cust_delegate_card_type varchar2(100) -- 
    ,cust_delegate_card_no varchar2(100) -- 
    ,cust_receiptor_card_type varchar2(100) -- 
    ,cust_receiptor_card_no varchar2(100) -- 
    ,cust_principal_card_type varchar2(100) -- 
    ,cust_principal_card_no varchar2(100) -- 
    ,corporate_type varchar2(100) -- 
    ,corporate_no varchar2(100) -- 
    ,address_anthenticity_score varchar2(100) -- 
    ,address_similarity varchar2(100) -- 
    ,cust_address varchar2(800) -- 
    ,agent_id_card_no varchar2(100) -- 
    ,coordinate_type varchar2(100) -- 
    ,lot_lat_city varchar2(100) -- 
    ,longitude varchar2(100) -- 
    ,id_card_country varchar2(100) -- 
    ,is_false_no varchar2(100) -- 
    ,corporate_bussiness_no varchar2(100) -- 
    ,corporate_phone_no varchar2(100) -- 
    ,proxy_ip_flag varchar2(100) -- 
    ,idc_ip_flag varchar2(100) -- 
    ,virtual_operator_no varchar2(100) -- 
    ,oper_prov varchar2(100) -- 
    ,oper_city varchar2(100) -- 
    ,oper_site varchar2(100) -- 
    ,biz_code varchar2(100) -- 
    ,oper_county varchar2(100) -- 
    ,finance_manager_no varchar2(100) -- 
    ,finance_manager_business_no varchar2(100) -- 
    ,bind_card_no varchar2(100) -- 
    ,account_holder_name varchar2(100) -- 
    ,business_scope varchar2(100) -- 
    ,prove_paper_indate varchar2(100) -- 
    ,prove_paper_no varchar2(100) -- 
    ,corporate_name varchar2(100) -- 
    ,oper_ip varchar2(100) -- 
    ,cust_type varchar2(50) -- 
    ,id_card_indate varchar2(50) -- 
    ,open_at varchar2(50) -- 
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
grant select on ${iol_schema}.rtis_credit_operation to ${iml_schema};
grant select on ${iol_schema}.rtis_credit_operation to ${icl_schema};
grant select on ${iol_schema}.rtis_credit_operation to ${idl_schema};
grant select on ${iol_schema}.rtis_credit_operation to ${iel_schema};

-- comment
comment on table ${iol_schema}.rtis_credit_operation is 'RTIS-账户操作表';
comment on column ${iol_schema}.rtis_credit_operation.id_ is '';
comment on column ${iol_schema}.rtis_credit_operation.tenant_id is '';
comment on column ${iol_schema}.rtis_credit_operation.user_id is '';
comment on column ${iol_schema}.rtis_credit_operation.oper_no is '';
comment on column ${iol_schema}.rtis_credit_operation.oper_type is '';
comment on column ${iol_schema}.rtis_credit_operation.apply_chnl is '';
comment on column ${iol_schema}.rtis_credit_operation.oper_time is '';
comment on column ${iol_schema}.rtis_credit_operation.oper_status is '';
comment on column ${iol_schema}.rtis_credit_operation.order_id is '';
comment on column ${iol_schema}.rtis_credit_operation.col_cust_id is '';
comment on column ${iol_schema}.rtis_credit_operation.col_cust_name is '';
comment on column ${iol_schema}.rtis_credit_operation.amount is '';
comment on column ${iol_schema}.rtis_credit_operation.account_id is '';
comment on column ${iol_schema}.rtis_credit_operation.bank_id is '';
comment on column ${iol_schema}.rtis_credit_operation.bank_card_no is '';
comment on column ${iol_schema}.rtis_credit_operation.bank_card_type is '';
comment on column ${iol_schema}.rtis_credit_operation.ip_addr is '';
comment on column ${iol_schema}.rtis_credit_operation.ip_prv is '';
comment on column ${iol_schema}.rtis_credit_operation.ip_city is '';
comment on column ${iol_schema}.rtis_credit_operation.mac is '';
comment on column ${iol_schema}.rtis_credit_operation.imei is '';
comment on column ${iol_schema}.rtis_credit_operation.sim is '';
comment on column ${iol_schema}.rtis_credit_operation.device_finger is '';
comment on column ${iol_schema}.rtis_credit_operation.create_time is '';
comment on column ${iol_schema}.rtis_credit_operation.id_card is '';
comment on column ${iol_schema}.rtis_credit_operation.phone is '';
comment on column ${iol_schema}.rtis_credit_operation.phone_addr is '';
comment on column ${iol_schema}.rtis_credit_operation.phone_prv is '';
comment on column ${iol_schema}.rtis_credit_operation.phone_city is '';
comment on column ${iol_schema}.rtis_credit_operation.phone_company is '';
comment on column ${iol_schema}.rtis_credit_operation.oper_from is '';
comment on column ${iol_schema}.rtis_credit_operation.location_x is '';
comment on column ${iol_schema}.rtis_credit_operation.location_y is '';
comment on column ${iol_schema}.rtis_credit_operation.last_update_time is '';
comment on column ${iol_schema}.rtis_credit_operation.last_status is '';
comment on column ${iol_schema}.rtis_credit_operation.create_at is '';
comment on column ${iol_schema}.rtis_credit_operation.create_by is '';
comment on column ${iol_schema}.rtis_credit_operation.last_update_at is '';
comment on column ${iol_schema}.rtis_credit_operation.last_update_by is '';
comment on column ${iol_schema}.rtis_credit_operation.regiser_address is '';
comment on column ${iol_schema}.rtis_credit_operation.company_tel is '';
comment on column ${iol_schema}.rtis_credit_operation.resp_code is '';
comment on column ${iol_schema}.rtis_credit_operation.rn_auth_phone is '';
comment on column ${iol_schema}.rtis_credit_operation.rn_auth_card_no is '';
comment on column ${iol_schema}.rtis_credit_operation.user_name is '';
comment on column ${iol_schema}.rtis_credit_operation.corporate_business_no is '';
comment on column ${iol_schema}.rtis_credit_operation.product_application is '';
comment on column ${iol_schema}.rtis_credit_operation.org_rec_amount is '';
comment on column ${iol_schema}.rtis_credit_operation.registered_amount is '';
comment on column ${iol_schema}.rtis_credit_operation.id_card_type is '';
comment on column ${iol_schema}.rtis_credit_operation.id_card_number is '';
comment on column ${iol_schema}.rtis_credit_operation.acct_type is '';
comment on column ${iol_schema}.rtis_credit_operation.phone_prov is '';
comment on column ${iol_schema}.rtis_credit_operation.sex is '';
comment on column ${iol_schema}.rtis_credit_operation.latitude is '';
comment on column ${iol_schema}.rtis_credit_operation.phone_1_7 is '';
comment on column ${iol_schema}.rtis_credit_operation.id_card_number_1_4 is '';
comment on column ${iol_schema}.rtis_credit_operation.id_card_county is '';
comment on column ${iol_schema}.rtis_credit_operation.id_card_prov is '';
comment on column ${iol_schema}.rtis_credit_operation.age is '';
comment on column ${iol_schema}.rtis_credit_operation.shareholder_id_card_type is '';
comment on column ${iol_schema}.rtis_credit_operation.shareholder_id_card_no is '';
comment on column ${iol_schema}.rtis_credit_operation.cust_occu is '';
comment on column ${iol_schema}.rtis_credit_operation.cust_linkman_card_type is '';
comment on column ${iol_schema}.rtis_credit_operation.cust_linkman_card_no is '';
comment on column ${iol_schema}.rtis_credit_operation.cust_famliy_name is '';
comment on column ${iol_schema}.rtis_credit_operation.cust_delegate_card_type is '';
comment on column ${iol_schema}.rtis_credit_operation.cust_delegate_card_no is '';
comment on column ${iol_schema}.rtis_credit_operation.cust_receiptor_card_type is '';
comment on column ${iol_schema}.rtis_credit_operation.cust_receiptor_card_no is '';
comment on column ${iol_schema}.rtis_credit_operation.cust_principal_card_type is '';
comment on column ${iol_schema}.rtis_credit_operation.cust_principal_card_no is '';
comment on column ${iol_schema}.rtis_credit_operation.corporate_type is '';
comment on column ${iol_schema}.rtis_credit_operation.corporate_no is '';
comment on column ${iol_schema}.rtis_credit_operation.address_anthenticity_score is '';
comment on column ${iol_schema}.rtis_credit_operation.address_similarity is '';
comment on column ${iol_schema}.rtis_credit_operation.cust_address is '';
comment on column ${iol_schema}.rtis_credit_operation.agent_id_card_no is '';
comment on column ${iol_schema}.rtis_credit_operation.coordinate_type is '';
comment on column ${iol_schema}.rtis_credit_operation.lot_lat_city is '';
comment on column ${iol_schema}.rtis_credit_operation.longitude is '';
comment on column ${iol_schema}.rtis_credit_operation.id_card_country is '';
comment on column ${iol_schema}.rtis_credit_operation.is_false_no is '';
comment on column ${iol_schema}.rtis_credit_operation.corporate_bussiness_no is '';
comment on column ${iol_schema}.rtis_credit_operation.corporate_phone_no is '';
comment on column ${iol_schema}.rtis_credit_operation.proxy_ip_flag is '';
comment on column ${iol_schema}.rtis_credit_operation.idc_ip_flag is '';
comment on column ${iol_schema}.rtis_credit_operation.virtual_operator_no is '';
comment on column ${iol_schema}.rtis_credit_operation.oper_prov is '';
comment on column ${iol_schema}.rtis_credit_operation.oper_city is '';
comment on column ${iol_schema}.rtis_credit_operation.oper_site is '';
comment on column ${iol_schema}.rtis_credit_operation.biz_code is '';
comment on column ${iol_schema}.rtis_credit_operation.oper_county is '';
comment on column ${iol_schema}.rtis_credit_operation.finance_manager_no is '';
comment on column ${iol_schema}.rtis_credit_operation.finance_manager_business_no is '';
comment on column ${iol_schema}.rtis_credit_operation.bind_card_no is '';
comment on column ${iol_schema}.rtis_credit_operation.account_holder_name is '';
comment on column ${iol_schema}.rtis_credit_operation.business_scope is '';
comment on column ${iol_schema}.rtis_credit_operation.prove_paper_indate is '';
comment on column ${iol_schema}.rtis_credit_operation.prove_paper_no is '';
comment on column ${iol_schema}.rtis_credit_operation.corporate_name is '';
comment on column ${iol_schema}.rtis_credit_operation.oper_ip is '';
comment on column ${iol_schema}.rtis_credit_operation.cust_type is '';
comment on column ${iol_schema}.rtis_credit_operation.id_card_indate is '';
comment on column ${iol_schema}.rtis_credit_operation.open_at is '';
comment on column ${iol_schema}.rtis_credit_operation.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rtis_credit_operation.etl_timestamp is 'ETL处理时间戳';
