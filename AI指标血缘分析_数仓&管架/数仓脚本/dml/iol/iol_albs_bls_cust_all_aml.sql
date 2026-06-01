/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_albs_bls_cust_all_aml
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
drop table ${iol_schema}.albs_bls_cust_all_aml_ex purge;
alter table ${iol_schema}.albs_bls_cust_all_aml add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.albs_bls_cust_all_aml truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.albs_bls_cust_all_aml_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.albs_bls_cust_all_aml where 0=1;

insert /*+ append */ into ${iol_schema}.albs_bls_cust_all_aml_ex(
    id -- 主键ID
    ,customer_no -- 客户号
    ,customer_name -- 客户名称
    ,customer_address -- 客户地址
    ,customer_type -- 客户类型 00-对公 01-对私
    ,identity_type -- 证件类型 A-身份证 B-外国公民护照 C-户口簿（身份证号）...
    ,identity_no -- 证件号码
    ,state -- 国家名称
    ,org_code -- 所属机构号
    ,org_name -- 所属机构名称
    ,crt_date -- 检索日期：yyyymmdd
    ,op_user_id -- 操作用户ID
    ,detection_name -- 侦测等级名称
    ,input_type -- 决议类型 01-通用格式 09-道琼斯 20-OFAC 77-银行家年鉴
    ,record_id -- 黑名单ID（可通过该ID链接到黑名单系统查看记录的明细页面）  -也就是预警id
    ,block_reason -- 备注 也就是拦截原因
    ,black_source_type -- 黑名单类别:0-回溯检索客户黑名单,1-全球制裁名单,2-中国制裁名单
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 主键ID
    ,customer_no -- 客户号
    ,customer_name -- 客户名称
    ,customer_address -- 客户地址
    ,customer_type -- 客户类型 00-对公 01-对私
    ,identity_type -- 证件类型 A-身份证 B-外国公民护照 C-户口簿（身份证号）...
    ,identity_no -- 证件号码
    ,state -- 国家名称
    ,org_code -- 所属机构号
    ,org_name -- 所属机构名称
    ,crt_date -- 检索日期：yyyymmdd
    ,op_user_id -- 操作用户ID
    ,detection_name -- 侦测等级名称
    ,input_type -- 决议类型 01-通用格式 09-道琼斯 20-OFAC 77-银行家年鉴
    ,record_id -- 黑名单ID（可通过该ID链接到黑名单系统查看记录的明细页面）  -也就是预警id
    ,block_reason -- 备注 也就是拦截原因
    ,black_source_type -- 黑名单类别:0-回溯检索客户黑名单,1-全球制裁名单,2-中国制裁名单
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.albs_bls_cust_all_aml
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.albs_bls_cust_all_aml exchange partition p_${batch_date} with table ${iol_schema}.albs_bls_cust_all_aml_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.albs_bls_cust_all_aml to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.albs_bls_cust_all_aml_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'albs_bls_cust_all_aml',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);