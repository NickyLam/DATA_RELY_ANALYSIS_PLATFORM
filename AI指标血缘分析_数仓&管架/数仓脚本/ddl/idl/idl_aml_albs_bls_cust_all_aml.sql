/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_albs_bls_cust_all_aml
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_albs_bls_cust_all_aml
whenever sqlerror continue none;
drop table ${idl_schema}.aml_albs_bls_cust_all_aml purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_albs_bls_cust_all_aml(
    id varchar2(32) -- 主键ID
    ,customer_no varchar2(32) -- 客户号
    ,customer_name varchar2(1000) -- 客户名称
    ,customer_address varchar2(240) -- 客户地址
    ,customer_type varchar2(8) -- 客户类型 00-对公 01-对私
    ,identity_type varchar2(8) -- 证件类型 A-身份证 B-外国公民护照 C-户口簿（身份证号）...
    ,identity_no varchar2(200) -- 证件号码
    ,state varchar2(48) -- 国家名称
    ,org_code varchar2(32) -- 所属机构号
    ,org_name varchar2(64) -- 所属机构名称
    ,crt_date varchar2(8) -- 检索日期：yyyymmdd
    ,op_user_id varchar2(32) -- 操作用户ID
    ,detection_name varchar2(40) -- 侦测等级名称
    ,input_type varchar2(2) -- 决议类型 01-通用格式 09-道琼斯 20-OFAC 77-银行家年鉴
    ,record_id varchar2(20) -- 黑名单ID（可通过该ID链接到黑名单系统查看记录的明细页面） -也就是预警id
    ,block_reason varchar2(250) -- 备注 也就是拦截原因
    ,black_source_type varchar2(1) -- 黑名单类别:0-回溯检索客户黑名单,1-全球制裁名单,2-中国制裁名单
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
grant select on ${idl_schema}.aml_albs_bls_cust_all_aml to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_albs_bls_cust_all_aml is '黑名单';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.id is '主键ID';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.customer_no is '客户号';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.customer_name is '客户名称';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.customer_address is '客户地址';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.customer_type is '客户类型 00-对公 01-对私';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.identity_type is '证件类型 A-身份证 B-外国公民护照 C-户口簿（身份证号）...';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.identity_no is '证件号码';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.state is '国家名称';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.org_code is '所属机构号';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.org_name is '所属机构名称';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.crt_date is '检索日期：yyyymmdd';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.op_user_id is '操作用户ID';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.detection_name is '侦测等级名称';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.input_type is '决议类型 01-通用格式 09-道琼斯 20-OFAC 77-银行家年鉴';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.record_id is '黑名单ID（可通过该ID链接到黑名单系统查看记录的明细页面） -也就是预警id';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.block_reason is '备注 也就是拦截原因';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.black_source_type is '黑名单类别:0-回溯检索客户黑名单,1-全球制裁名单,2-中国制裁名单';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.aml_albs_bls_cust_all_aml.etl_timestamp is 'ETL处理时间戳';
