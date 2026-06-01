/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rpss_related_product
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.rpss_related_product_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rpss_related_product
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rpss_related_product_op purge;
drop table ${iol_schema}.rpss_related_product_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rpss_related_product_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rpss_related_product where 0=1;

create table ${iol_schema}.rpss_related_product_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rpss_related_product where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rpss_related_product_cl(
            related_id -- 关联方编号
            ,person_name -- 关联方名称
            ,certificate_type_id -- 证件类型
            ,certificate_no -- 证件号码
            ,domestic_or_foreign -- 证件类型境内外1
            ,shareholding_ratio -- 持股比例
            ,organization -- 所属机构
            ,department -- 所属部门
            ,belong_org -- 归属机构
            ,mainten_org -- 维护机构
            ,certificate_type_id_t -- 证件类型2
            ,certificate_no_t -- 证件号码2
            ,domestic_or_foreign_t -- 证件类型境内外2
            ,product_name -- 金融产品全称
            ,product_issue_no -- 产品批准/注册/备案号
            ,product_register_no -- 产品代码
            ,product_type -- 产品分类
            ,register_org -- 产品登记机构
            ,product_owner -- 产品管理人全称
            ,product_owner_unisc_code -- 产品管理人统一社会信用代码
            ,product_custodian -- 产品托管人全称
            ,product_custodian_unisc_code -- 产品托管人统一社会信用代码
            ,comments -- 备注
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rpss_related_product_op(
            related_id -- 关联方编号
            ,person_name -- 关联方名称
            ,certificate_type_id -- 证件类型
            ,certificate_no -- 证件号码
            ,domestic_or_foreign -- 证件类型境内外1
            ,shareholding_ratio -- 持股比例
            ,organization -- 所属机构
            ,department -- 所属部门
            ,belong_org -- 归属机构
            ,mainten_org -- 维护机构
            ,certificate_type_id_t -- 证件类型2
            ,certificate_no_t -- 证件号码2
            ,domestic_or_foreign_t -- 证件类型境内外2
            ,product_name -- 金融产品全称
            ,product_issue_no -- 产品批准/注册/备案号
            ,product_register_no -- 产品代码
            ,product_type -- 产品分类
            ,register_org -- 产品登记机构
            ,product_owner -- 产品管理人全称
            ,product_owner_unisc_code -- 产品管理人统一社会信用代码
            ,product_custodian -- 产品托管人全称
            ,product_custodian_unisc_code -- 产品托管人统一社会信用代码
            ,comments -- 备注
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.related_id, o.related_id) as related_id -- 关联方编号
    ,nvl(n.person_name, o.person_name) as person_name -- 关联方名称
    ,nvl(n.certificate_type_id, o.certificate_type_id) as certificate_type_id -- 证件类型
    ,nvl(n.certificate_no, o.certificate_no) as certificate_no -- 证件号码
    ,nvl(n.domestic_or_foreign, o.domestic_or_foreign) as domestic_or_foreign -- 证件类型境内外1
    ,nvl(n.shareholding_ratio, o.shareholding_ratio) as shareholding_ratio -- 持股比例
    ,nvl(n.organization, o.organization) as organization -- 所属机构
    ,nvl(n.department, o.department) as department -- 所属部门
    ,nvl(n.belong_org, o.belong_org) as belong_org -- 归属机构
    ,nvl(n.mainten_org, o.mainten_org) as mainten_org -- 维护机构
    ,nvl(n.certificate_type_id_t, o.certificate_type_id_t) as certificate_type_id_t -- 证件类型2
    ,nvl(n.certificate_no_t, o.certificate_no_t) as certificate_no_t -- 证件号码2
    ,nvl(n.domestic_or_foreign_t, o.domestic_or_foreign_t) as domestic_or_foreign_t -- 证件类型境内外2
    ,nvl(n.product_name, o.product_name) as product_name -- 金融产品全称
    ,nvl(n.product_issue_no, o.product_issue_no) as product_issue_no -- 产品批准/注册/备案号
    ,nvl(n.product_register_no, o.product_register_no) as product_register_no -- 产品代码
    ,nvl(n.product_type, o.product_type) as product_type -- 产品分类
    ,nvl(n.register_org, o.register_org) as register_org -- 产品登记机构
    ,nvl(n.product_owner, o.product_owner) as product_owner -- 产品管理人全称
    ,nvl(n.product_owner_unisc_code, o.product_owner_unisc_code) as product_owner_unisc_code -- 产品管理人统一社会信用代码
    ,nvl(n.product_custodian, o.product_custodian) as product_custodian -- 产品托管人全称
    ,nvl(n.product_custodian_unisc_code, o.product_custodian_unisc_code) as product_custodian_unisc_code -- 产品托管人统一社会信用代码
    ,nvl(n.comments, o.comments) as comments -- 备注
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 
    ,case when
            n.related_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.related_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.related_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rpss_related_product_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rpss_related_product where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.related_id = n.related_id
where (
        o.related_id is null
    )
    or (
        n.related_id is null
    )
    or (
        o.person_name <> n.person_name
        or o.certificate_type_id <> n.certificate_type_id
        or o.certificate_no <> n.certificate_no
        or o.domestic_or_foreign <> n.domestic_or_foreign
        or o.shareholding_ratio <> n.shareholding_ratio
        or o.organization <> n.organization
        or o.department <> n.department
        or o.belong_org <> n.belong_org
        or o.mainten_org <> n.mainten_org
        or o.certificate_type_id_t <> n.certificate_type_id_t
        or o.certificate_no_t <> n.certificate_no_t
        or o.domestic_or_foreign_t <> n.domestic_or_foreign_t
        or o.product_name <> n.product_name
        or o.product_issue_no <> n.product_issue_no
        or o.product_register_no <> n.product_register_no
        or o.product_type <> n.product_type
        or o.register_org <> n.register_org
        or o.product_owner <> n.product_owner
        or o.product_owner_unisc_code <> n.product_owner_unisc_code
        or o.product_custodian <> n.product_custodian
        or o.product_custodian_unisc_code <> n.product_custodian_unisc_code
        or o.comments <> n.comments
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rpss_related_product_cl(
            related_id -- 关联方编号
            ,person_name -- 关联方名称
            ,certificate_type_id -- 证件类型
            ,certificate_no -- 证件号码
            ,domestic_or_foreign -- 证件类型境内外1
            ,shareholding_ratio -- 持股比例
            ,organization -- 所属机构
            ,department -- 所属部门
            ,belong_org -- 归属机构
            ,mainten_org -- 维护机构
            ,certificate_type_id_t -- 证件类型2
            ,certificate_no_t -- 证件号码2
            ,domestic_or_foreign_t -- 证件类型境内外2
            ,product_name -- 金融产品全称
            ,product_issue_no -- 产品批准/注册/备案号
            ,product_register_no -- 产品代码
            ,product_type -- 产品分类
            ,register_org -- 产品登记机构
            ,product_owner -- 产品管理人全称
            ,product_owner_unisc_code -- 产品管理人统一社会信用代码
            ,product_custodian -- 产品托管人全称
            ,product_custodian_unisc_code -- 产品托管人统一社会信用代码
            ,comments -- 备注
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rpss_related_product_op(
            related_id -- 关联方编号
            ,person_name -- 关联方名称
            ,certificate_type_id -- 证件类型
            ,certificate_no -- 证件号码
            ,domestic_or_foreign -- 证件类型境内外1
            ,shareholding_ratio -- 持股比例
            ,organization -- 所属机构
            ,department -- 所属部门
            ,belong_org -- 归属机构
            ,mainten_org -- 维护机构
            ,certificate_type_id_t -- 证件类型2
            ,certificate_no_t -- 证件号码2
            ,domestic_or_foreign_t -- 证件类型境内外2
            ,product_name -- 金融产品全称
            ,product_issue_no -- 产品批准/注册/备案号
            ,product_register_no -- 产品代码
            ,product_type -- 产品分类
            ,register_org -- 产品登记机构
            ,product_owner -- 产品管理人全称
            ,product_owner_unisc_code -- 产品管理人统一社会信用代码
            ,product_custodian -- 产品托管人全称
            ,product_custodian_unisc_code -- 产品托管人统一社会信用代码
            ,comments -- 备注
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.related_id -- 关联方编号
    ,o.person_name -- 关联方名称
    ,o.certificate_type_id -- 证件类型
    ,o.certificate_no -- 证件号码
    ,o.domestic_or_foreign -- 证件类型境内外1
    ,o.shareholding_ratio -- 持股比例
    ,o.organization -- 所属机构
    ,o.department -- 所属部门
    ,o.belong_org -- 归属机构
    ,o.mainten_org -- 维护机构
    ,o.certificate_type_id_t -- 证件类型2
    ,o.certificate_no_t -- 证件号码2
    ,o.domestic_or_foreign_t -- 证件类型境内外2
    ,o.product_name -- 金融产品全称
    ,o.product_issue_no -- 产品批准/注册/备案号
    ,o.product_register_no -- 产品代码
    ,o.product_type -- 产品分类
    ,o.register_org -- 产品登记机构
    ,o.product_owner -- 产品管理人全称
    ,o.product_owner_unisc_code -- 产品管理人统一社会信用代码
    ,o.product_custodian -- 产品托管人全称
    ,o.product_custodian_unisc_code -- 产品托管人统一社会信用代码
    ,o.comments -- 备注
    ,o.last_updated_stamp -- 
    ,o.last_updated_tx_stamp -- 
    ,o.created_stamp -- 
    ,o.created_tx_stamp -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.rpss_related_product_bk o
    left join ${iol_schema}.rpss_related_product_op n
        on
            o.related_id = n.related_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rpss_related_product_cl d
        on
            o.related_id = d.related_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rpss_related_product;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rpss_related_product') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rpss_related_product drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rpss_related_product add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rpss_related_product exchange partition p_${batch_date} with table ${iol_schema}.rpss_related_product_cl;
alter table ${iol_schema}.rpss_related_product exchange partition p_20991231 with table ${iol_schema}.rpss_related_product_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rpss_related_product to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rpss_related_product_op purge;
drop table ${iol_schema}.rpss_related_product_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rpss_related_product_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rpss_related_product',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
