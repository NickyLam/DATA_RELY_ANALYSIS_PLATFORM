/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_mb_fee_catalog
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
create table ${iol_schema}.ncbs_mb_fee_catalog_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_mb_fee_catalog
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_fee_catalog_op purge;
drop table ${iol_schema}.ncbs_mb_fee_catalog_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_fee_catalog_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_fee_catalog where 0=1;

create table ${iol_schema}.ncbs_mb_fee_catalog_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_fee_catalog where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_fee_catalog_cl(
            base_fee_name -- 基础费用名称
            ,company -- 法人
            ,fee_class -- 费用分类
            ,fee_desc -- 费用类型描述
            ,fee_type -- 费率类型
            ,system_id -- 系统id
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,fee_name -- 费用名称
            ,fee_status -- 费用状态
            ,fee_class_name -- 费用分类名称
            ,fee_sub_class -- 费用细类
            ,fee_group -- 费用分组
            ,catalog_no -- 目录序号
            ,base_fee -- 基础费用，带目录结构
            ,fee_sub_class_name -- 费用细类名称
            ,manage_dept -- 管理部门
            ,fee_group_name -- 费用分组名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_fee_catalog_op(
            base_fee_name -- 基础费用名称
            ,company -- 法人
            ,fee_class -- 费用分类
            ,fee_desc -- 费用类型描述
            ,fee_type -- 费率类型
            ,system_id -- 系统id
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,fee_name -- 费用名称
            ,fee_status -- 费用状态
            ,fee_class_name -- 费用分类名称
            ,fee_sub_class -- 费用细类
            ,fee_group -- 费用分组
            ,catalog_no -- 目录序号
            ,base_fee -- 基础费用，带目录结构
            ,fee_sub_class_name -- 费用细类名称
            ,manage_dept -- 管理部门
            ,fee_group_name -- 费用分组名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.base_fee_name, o.base_fee_name) as base_fee_name -- 基础费用名称
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.fee_class, o.fee_class) as fee_class -- 费用分类
    ,nvl(n.fee_desc, o.fee_desc) as fee_desc -- 费用类型描述
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 费率类型
    ,nvl(n.system_id, o.system_id) as system_id -- 系统id
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.expire_date, o.expire_date) as expire_date -- 失效日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.fee_name, o.fee_name) as fee_name -- 费用名称
    ,nvl(n.fee_status, o.fee_status) as fee_status -- 费用状态
    ,nvl(n.fee_class_name, o.fee_class_name) as fee_class_name -- 费用分类名称
    ,nvl(n.fee_sub_class, o.fee_sub_class) as fee_sub_class -- 费用细类
    ,nvl(n.fee_group, o.fee_group) as fee_group -- 费用分组
    ,nvl(n.catalog_no, o.catalog_no) as catalog_no -- 目录序号
    ,nvl(n.base_fee, o.base_fee) as base_fee -- 基础费用，带目录结构
    ,nvl(n.fee_sub_class_name, o.fee_sub_class_name) as fee_sub_class_name -- 费用细类名称
    ,nvl(n.manage_dept, o.manage_dept) as manage_dept -- 管理部门
    ,nvl(n.fee_group_name, o.fee_group_name) as fee_group_name -- 费用分组名称
    ,case when
            n.catalog_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.catalog_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.catalog_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_mb_fee_catalog_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_mb_fee_catalog where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.catalog_no = n.catalog_no
where (
        o.catalog_no is null
    )
    or (
        n.catalog_no is null
    )
    or (
        o.base_fee_name <> n.base_fee_name
        or o.company <> n.company
        or o.fee_class <> n.fee_class
        or o.fee_desc <> n.fee_desc
        or o.fee_type <> n.fee_type
        or o.system_id <> n.system_id
        or o.effect_date <> n.effect_date
        or o.expire_date <> n.expire_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.fee_name <> n.fee_name
        or o.fee_status <> n.fee_status
        or o.fee_class_name <> n.fee_class_name
        or o.fee_sub_class <> n.fee_sub_class
        or o.fee_group <> n.fee_group
        or o.base_fee <> n.base_fee
        or o.fee_sub_class_name <> n.fee_sub_class_name
        or o.manage_dept <> n.manage_dept
        or o.fee_group_name <> n.fee_group_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_fee_catalog_cl(
            base_fee_name -- 基础费用名称
            ,company -- 法人
            ,fee_class -- 费用分类
            ,fee_desc -- 费用类型描述
            ,fee_type -- 费率类型
            ,system_id -- 系统id
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,fee_name -- 费用名称
            ,fee_status -- 费用状态
            ,fee_class_name -- 费用分类名称
            ,fee_sub_class -- 费用细类
            ,fee_group -- 费用分组
            ,catalog_no -- 目录序号
            ,base_fee -- 基础费用，带目录结构
            ,fee_sub_class_name -- 费用细类名称
            ,manage_dept -- 管理部门
            ,fee_group_name -- 费用分组名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_fee_catalog_op(
            base_fee_name -- 基础费用名称
            ,company -- 法人
            ,fee_class -- 费用分类
            ,fee_desc -- 费用类型描述
            ,fee_type -- 费率类型
            ,system_id -- 系统id
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,fee_name -- 费用名称
            ,fee_status -- 费用状态
            ,fee_class_name -- 费用分类名称
            ,fee_sub_class -- 费用细类
            ,fee_group -- 费用分组
            ,catalog_no -- 目录序号
            ,base_fee -- 基础费用，带目录结构
            ,fee_sub_class_name -- 费用细类名称
            ,manage_dept -- 管理部门
            ,fee_group_name -- 费用分组名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.base_fee_name -- 基础费用名称
    ,o.company -- 法人
    ,o.fee_class -- 费用分类
    ,o.fee_desc -- 费用类型描述
    ,o.fee_type -- 费率类型
    ,o.system_id -- 系统id
    ,o.effect_date -- 产品生效日期
    ,o.expire_date -- 失效日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.fee_name -- 费用名称
    ,o.fee_status -- 费用状态
    ,o.fee_class_name -- 费用分类名称
    ,o.fee_sub_class -- 费用细类
    ,o.fee_group -- 费用分组
    ,o.catalog_no -- 目录序号
    ,o.base_fee -- 基础费用，带目录结构
    ,o.fee_sub_class_name -- 费用细类名称
    ,o.manage_dept -- 管理部门
    ,o.fee_group_name -- 费用分组名称
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
from ${iol_schema}.ncbs_mb_fee_catalog_bk o
    left join ${iol_schema}.ncbs_mb_fee_catalog_op n
        on
            o.catalog_no = n.catalog_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_mb_fee_catalog_cl d
        on
            o.catalog_no = d.catalog_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_mb_fee_catalog;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_mb_fee_catalog') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_mb_fee_catalog drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_mb_fee_catalog add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_mb_fee_catalog exchange partition p_${batch_date} with table ${iol_schema}.ncbs_mb_fee_catalog_cl;
alter table ${iol_schema}.ncbs_mb_fee_catalog exchange partition p_20991231 with table ${iol_schema}.ncbs_mb_fee_catalog_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_mb_fee_catalog to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_fee_catalog_op purge;
drop table ${iol_schema}.ncbs_mb_fee_catalog_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_mb_fee_catalog_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_mb_fee_catalog',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
