/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_albs_bls_cust_all_aml
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_albs_bls_cust_all_aml drop partition p_${last_date};
alter table ${idl_schema}.aml_albs_bls_cust_all_aml drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_albs_bls_cust_all_aml add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_albs_bls_cust_all_aml partition for (to_date('${batch_date}','yyyymmdd')) (
    id  -- 主键ID
    ,customer_no  -- 客户号
    ,customer_name  -- 客户名称
    ,customer_address  -- 客户地址
    ,customer_type  -- 客户类型 00-对公 01-对私
    ,identity_type  -- 证件类型 A-身份证 B-外国公民护照 C-户口簿（身份证号）...
    ,identity_no  -- 证件号码
    ,state  -- 国家名称
    ,org_code  -- 所属机构号
    ,org_name  -- 所属机构名称
    ,crt_date  -- 检索日期：yyyymmdd
    ,op_user_id  -- 操作用户ID
    ,detection_name  -- 侦测等级名称
    ,input_type  -- 决议类型 01-通用格式 09-道琼斯 20-OFAC 77-银行家年鉴
    ,record_id  -- 黑名单ID（可通过该ID链接到黑名单系统查看记录的明细页面） -也就是预警id
    ,block_reason  -- 备注 也就是拦截原因
    ,black_source_type  -- 黑名单类别:0-回溯检索客户黑名单,1-全球制裁名单,2-中国制裁名单
    ,etl_dt  -- 数据日期
    ,etl_timestamp  -- ETL处理时间戳
)
select
    replace(replace(t1.id,chr(13),''),chr(10),'')  -- 主键ID
    ,replace(replace(t1.customer_no,chr(13),''),chr(10),'')  -- 客户号
    ,replace(replace(t1.customer_name,chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(t1.customer_address,chr(13),''),chr(10),'')  -- 客户地址
    ,replace(replace(t1.customer_type,chr(13),''),chr(10),'')  -- 客户类型 00-对公 01-对私
    ,replace(replace(t1.identity_type,chr(13),''),chr(10),'')  -- 证件类型 A-身份证 B-外国公民护照 C-户口簿（身份证号）...
    ,replace(replace(t1.identity_no,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.state,chr(13),''),chr(10),'')  -- 国家名称
    ,replace(replace(t1.org_code,chr(13),''),chr(10),'')  -- 所属机构号
    ,replace(replace(t1.org_name,chr(13),''),chr(10),'')  -- 所属机构名称
    ,replace(replace(t1.crt_date,chr(13),''),chr(10),'')  -- 检索日期：yyyymmdd
    ,replace(replace(t1.op_user_id,chr(13),''),chr(10),'')  -- 操作用户ID
    ,replace(replace(t1.detection_name,chr(13),''),chr(10),'')  -- 侦测等级名称
    ,replace(replace(t1.input_type,chr(13),''),chr(10),'')  -- 决议类型 01-通用格式 09-道琼斯 20-OFAC 77-银行家年鉴
    ,replace(replace(t1.record_id,chr(13),''),chr(10),'')  -- 黑名单ID（可通过该ID链接到黑名单系统查看记录的明细页面） -也就是预警id
    ,replace(replace(t1.block_reason,chr(13),''),chr(10),'')  -- 备注 也就是拦截原因
    ,replace(replace(t1.black_source_type,chr(13),''),chr(10),'')  -- 黑名单类别:0-回溯检索客户黑名单,1-全球制裁名单,2-中国制裁名单
    ,to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,t1.etl_timestamp  -- ETL处理时间戳
from ${iol_schema}.albs_bls_cust_all_aml t1    --黑名单
where t1.crt_date = '${batch_date}' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_albs_bls_cust_all_aml',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);