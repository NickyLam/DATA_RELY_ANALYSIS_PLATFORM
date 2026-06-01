/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rtis_sd_package
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
create table ${iol_schema}.rtis_sd_package_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rtis_sd_package
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rtis_sd_package_op purge;
drop table ${iol_schema}.rtis_sd_package_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_sd_package_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_sd_package where 0=1;

create table ${iol_schema}.rtis_sd_package_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_sd_package where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rtis_sd_package_cl(
            id_ -- 主键ID
            ,pkg_id -- 规则包技术编码
            ,version_ -- 版本
            ,simulation_id -- 仿真集ID
            ,is_latest -- 是否最新版本(0-否，1-是)
            ,name_ -- 规则包名称
            ,type_ -- 规则包类型（HIT-命中规则包，DECISION-TREE-决策树，SCORECARD-评分卡）
            ,oper_scene_id -- 所属运营场景(取自CHANNEL_ID)
            ,order_index -- 标签排序
            ,status_ -- 规则包状态(0-删除; 1-可用)
            ,cate_id -- 规则包类目ID
            ,org_id -- 规则包所属机构
            ,apply_org -- 申请组织
            ,note -- 备注
            ,create_by -- 创建人
            ,update_by -- 修改人
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rtis_sd_package_op(
            id_ -- 主键ID
            ,pkg_id -- 规则包技术编码
            ,version_ -- 版本
            ,simulation_id -- 仿真集ID
            ,is_latest -- 是否最新版本(0-否，1-是)
            ,name_ -- 规则包名称
            ,type_ -- 规则包类型（HIT-命中规则包，DECISION-TREE-决策树，SCORECARD-评分卡）
            ,oper_scene_id -- 所属运营场景(取自CHANNEL_ID)
            ,order_index -- 标签排序
            ,status_ -- 规则包状态(0-删除; 1-可用)
            ,cate_id -- 规则包类目ID
            ,org_id -- 规则包所属机构
            ,apply_org -- 申请组织
            ,note -- 备注
            ,create_by -- 创建人
            ,update_by -- 修改人
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id_, o.id_) as id_ -- 主键ID
    ,nvl(n.pkg_id, o.pkg_id) as pkg_id -- 规则包技术编码
    ,nvl(n.version_, o.version_) as version_ -- 版本
    ,nvl(n.simulation_id, o.simulation_id) as simulation_id -- 仿真集ID
    ,nvl(n.is_latest, o.is_latest) as is_latest -- 是否最新版本(0-否，1-是)
    ,nvl(n.name_, o.name_) as name_ -- 规则包名称
    ,nvl(n.type_, o.type_) as type_ -- 规则包类型（HIT-命中规则包，DECISION-TREE-决策树，SCORECARD-评分卡）
    ,nvl(n.oper_scene_id, o.oper_scene_id) as oper_scene_id -- 所属运营场景(取自CHANNEL_ID)
    ,nvl(n.order_index, o.order_index) as order_index -- 标签排序
    ,nvl(n.status_, o.status_) as status_ -- 规则包状态(0-删除; 1-可用)
    ,nvl(n.cate_id, o.cate_id) as cate_id -- 规则包类目ID
    ,nvl(n.org_id, o.org_id) as org_id -- 规则包所属机构
    ,nvl(n.apply_org, o.apply_org) as apply_org -- 申请组织
    ,nvl(n.note, o.note) as note -- 备注
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
    ,nvl(n.update_by, o.update_by) as update_by -- 修改人
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 修改时间
    ,case when
            n.id_ is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id_ is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id_ is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rtis_sd_package_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rtis_sd_package where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id_ = n.id_
where (
        o.id_ is null
    )
    or (
        n.id_ is null
    )
    or (
        o.pkg_id <> n.pkg_id
        or o.version_ <> n.version_
        or o.simulation_id <> n.simulation_id
        or o.is_latest <> n.is_latest
        or o.name_ <> n.name_
        or o.type_ <> n.type_
        or o.oper_scene_id <> n.oper_scene_id
        or o.order_index <> n.order_index
        or o.status_ <> n.status_
        or o.cate_id <> n.cate_id
        or o.org_id <> n.org_id
        or o.apply_org <> n.apply_org
        or o.note <> n.note
        or o.create_by <> n.create_by
        or o.update_by <> n.update_by
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rtis_sd_package_cl(
            id_ -- 主键ID
            ,pkg_id -- 规则包技术编码
            ,version_ -- 版本
            ,simulation_id -- 仿真集ID
            ,is_latest -- 是否最新版本(0-否，1-是)
            ,name_ -- 规则包名称
            ,type_ -- 规则包类型（HIT-命中规则包，DECISION-TREE-决策树，SCORECARD-评分卡）
            ,oper_scene_id -- 所属运营场景(取自CHANNEL_ID)
            ,order_index -- 标签排序
            ,status_ -- 规则包状态(0-删除; 1-可用)
            ,cate_id -- 规则包类目ID
            ,org_id -- 规则包所属机构
            ,apply_org -- 申请组织
            ,note -- 备注
            ,create_by -- 创建人
            ,update_by -- 修改人
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rtis_sd_package_op(
            id_ -- 主键ID
            ,pkg_id -- 规则包技术编码
            ,version_ -- 版本
            ,simulation_id -- 仿真集ID
            ,is_latest -- 是否最新版本(0-否，1-是)
            ,name_ -- 规则包名称
            ,type_ -- 规则包类型（HIT-命中规则包，DECISION-TREE-决策树，SCORECARD-评分卡）
            ,oper_scene_id -- 所属运营场景(取自CHANNEL_ID)
            ,order_index -- 标签排序
            ,status_ -- 规则包状态(0-删除; 1-可用)
            ,cate_id -- 规则包类目ID
            ,org_id -- 规则包所属机构
            ,apply_org -- 申请组织
            ,note -- 备注
            ,create_by -- 创建人
            ,update_by -- 修改人
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id_ -- 主键ID
    ,o.pkg_id -- 规则包技术编码
    ,o.version_ -- 版本
    ,o.simulation_id -- 仿真集ID
    ,o.is_latest -- 是否最新版本(0-否，1-是)
    ,o.name_ -- 规则包名称
    ,o.type_ -- 规则包类型（HIT-命中规则包，DECISION-TREE-决策树，SCORECARD-评分卡）
    ,o.oper_scene_id -- 所属运营场景(取自CHANNEL_ID)
    ,o.order_index -- 标签排序
    ,o.status_ -- 规则包状态(0-删除; 1-可用)
    ,o.cate_id -- 规则包类目ID
    ,o.org_id -- 规则包所属机构
    ,o.apply_org -- 申请组织
    ,o.note -- 备注
    ,o.create_by -- 创建人
    ,o.update_by -- 修改人
    ,o.create_time -- 创建时间
    ,o.update_time -- 修改时间
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
from ${iol_schema}.rtis_sd_package_bk o
    left join ${iol_schema}.rtis_sd_package_op n
        on
            o.id_ = n.id_
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rtis_sd_package_cl d
        on
            o.id_ = d.id_
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rtis_sd_package;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rtis_sd_package') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rtis_sd_package drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rtis_sd_package add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rtis_sd_package exchange partition p_${batch_date} with table ${iol_schema}.rtis_sd_package_cl;
alter table ${iol_schema}.rtis_sd_package exchange partition p_20991231 with table ${iol_schema}.rtis_sd_package_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rtis_sd_package to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rtis_sd_package_op purge;
drop table ${iol_schema}.rtis_sd_package_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rtis_sd_package_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rtis_sd_package',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
