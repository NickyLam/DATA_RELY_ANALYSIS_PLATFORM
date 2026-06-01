/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_mb_prod_catalog
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
create table ${iol_schema}.ncbs_mb_prod_catalog_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_mb_prod_catalog
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_prod_catalog_op purge;
drop table ${iol_schema}.ncbs_mb_prod_catalog_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_prod_catalog_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_prod_catalog where 0=1;

create table ${iol_schema}.ncbs_mb_prod_catalog_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_prod_catalog where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_prod_catalog_cl(
            prod_type -- 产品编号
            ,company -- 法人
            ,prod_desc -- 产品名称
            ,prod_status -- 产品状态
            ,system_id -- 系统id
            ,prod_class -- 产品分类
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,base_prod -- 基础产品
            ,prod_name -- 总账产品名称
            ,prod_sub_class -- 产品细类
            ,ctlg_level -- 目录层级
            ,prod_group_name -- 产品分组名称
            ,prod_group -- 产品分组
            ,prod_class_name -- 产品分类名称
            ,catalog_no -- 目录序号
            ,prod_sub_class_name -- 产品细类名称
            ,base_prod_name -- 基础产品名称
            ,manage_dept -- 管理部门
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_prod_catalog_op(
            prod_type -- 产品编号
            ,company -- 法人
            ,prod_desc -- 产品名称
            ,prod_status -- 产品状态
            ,system_id -- 系统id
            ,prod_class -- 产品分类
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,base_prod -- 基础产品
            ,prod_name -- 总账产品名称
            ,prod_sub_class -- 产品细类
            ,ctlg_level -- 目录层级
            ,prod_group_name -- 产品分组名称
            ,prod_group -- 产品分组
            ,prod_class_name -- 产品分类名称
            ,catalog_no -- 目录序号
            ,prod_sub_class_name -- 产品细类名称
            ,base_prod_name -- 基础产品名称
            ,manage_dept -- 管理部门
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.prod_desc, o.prod_desc) as prod_desc -- 产品名称
    ,nvl(n.prod_status, o.prod_status) as prod_status -- 产品状态
    ,nvl(n.system_id, o.system_id) as system_id -- 系统id
    ,nvl(n.prod_class, o.prod_class) as prod_class -- 产品分类
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.expire_date, o.expire_date) as expire_date -- 失效日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.base_prod, o.base_prod) as base_prod -- 基础产品
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 总账产品名称
    ,nvl(n.prod_sub_class, o.prod_sub_class) as prod_sub_class -- 产品细类
    ,nvl(n.ctlg_level, o.ctlg_level) as ctlg_level -- 目录层级
    ,nvl(n.prod_group_name, o.prod_group_name) as prod_group_name -- 产品分组名称
    ,nvl(n.prod_group, o.prod_group) as prod_group -- 产品分组
    ,nvl(n.prod_class_name, o.prod_class_name) as prod_class_name -- 产品分类名称
    ,nvl(n.catalog_no, o.catalog_no) as catalog_no -- 目录序号
    ,nvl(n.prod_sub_class_name, o.prod_sub_class_name) as prod_sub_class_name -- 产品细类名称
    ,nvl(n.base_prod_name, o.base_prod_name) as base_prod_name -- 基础产品名称
    ,nvl(n.manage_dept, o.manage_dept) as manage_dept -- 管理部门
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
from (select * from ${iol_schema}.ncbs_mb_prod_catalog_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_mb_prod_catalog where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.catalog_no = n.catalog_no
where (
        o.catalog_no is null
    )
    or (
        n.catalog_no is null
    )
    or (
        o.prod_type <> n.prod_type
        or o.company <> n.company
        or o.prod_desc <> n.prod_desc
        or o.prod_status <> n.prod_status
        or o.system_id <> n.system_id
        or o.prod_class <> n.prod_class
        or o.effect_date <> n.effect_date
        or o.expire_date <> n.expire_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.base_prod <> n.base_prod
        or o.prod_name <> n.prod_name
        or o.prod_sub_class <> n.prod_sub_class
        or o.ctlg_level <> n.ctlg_level
        or o.prod_group_name <> n.prod_group_name
        or o.prod_group <> n.prod_group
        or o.prod_class_name <> n.prod_class_name
        or o.prod_sub_class_name <> n.prod_sub_class_name
        or o.base_prod_name <> n.base_prod_name
        or o.manage_dept <> n.manage_dept
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_prod_catalog_cl(
            prod_type -- 产品编号
            ,company -- 法人
            ,prod_desc -- 产品名称
            ,prod_status -- 产品状态
            ,system_id -- 系统id
            ,prod_class -- 产品分类
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,base_prod -- 基础产品
            ,prod_name -- 总账产品名称
            ,prod_sub_class -- 产品细类
            ,ctlg_level -- 目录层级
            ,prod_group_name -- 产品分组名称
            ,prod_group -- 产品分组
            ,prod_class_name -- 产品分类名称
            ,catalog_no -- 目录序号
            ,prod_sub_class_name -- 产品细类名称
            ,base_prod_name -- 基础产品名称
            ,manage_dept -- 管理部门
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_prod_catalog_op(
            prod_type -- 产品编号
            ,company -- 法人
            ,prod_desc -- 产品名称
            ,prod_status -- 产品状态
            ,system_id -- 系统id
            ,prod_class -- 产品分类
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,base_prod -- 基础产品
            ,prod_name -- 总账产品名称
            ,prod_sub_class -- 产品细类
            ,ctlg_level -- 目录层级
            ,prod_group_name -- 产品分组名称
            ,prod_group -- 产品分组
            ,prod_class_name -- 产品分类名称
            ,catalog_no -- 目录序号
            ,prod_sub_class_name -- 产品细类名称
            ,base_prod_name -- 基础产品名称
            ,manage_dept -- 管理部门
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_type -- 产品编号
    ,o.company -- 法人
    ,o.prod_desc -- 产品名称
    ,o.prod_status -- 产品状态
    ,o.system_id -- 系统id
    ,o.prod_class -- 产品分类
    ,o.effect_date -- 产品生效日期
    ,o.expire_date -- 失效日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.base_prod -- 基础产品
    ,o.prod_name -- 总账产品名称
    ,o.prod_sub_class -- 产品细类
    ,o.ctlg_level -- 目录层级
    ,o.prod_group_name -- 产品分组名称
    ,o.prod_group -- 产品分组
    ,o.prod_class_name -- 产品分类名称
    ,o.catalog_no -- 目录序号
    ,o.prod_sub_class_name -- 产品细类名称
    ,o.base_prod_name -- 基础产品名称
    ,o.manage_dept -- 管理部门
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
from ${iol_schema}.ncbs_mb_prod_catalog_bk o
    left join ${iol_schema}.ncbs_mb_prod_catalog_op n
        on
            o.catalog_no = n.catalog_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_mb_prod_catalog_cl d
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
--truncate table ${iol_schema}.ncbs_mb_prod_catalog;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_mb_prod_catalog') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_mb_prod_catalog drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_mb_prod_catalog add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_mb_prod_catalog exchange partition p_${batch_date} with table ${iol_schema}.ncbs_mb_prod_catalog_cl;
alter table ${iol_schema}.ncbs_mb_prod_catalog exchange partition p_20991231 with table ${iol_schema}.ncbs_mb_prod_catalog_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_mb_prod_catalog to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_prod_catalog_op purge;
drop table ${iol_schema}.ncbs_mb_prod_catalog_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_mb_prod_catalog_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_mb_prod_catalog',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
