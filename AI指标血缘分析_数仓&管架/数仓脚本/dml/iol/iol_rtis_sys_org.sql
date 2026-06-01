/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rtis_sys_org
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
create table ${iol_schema}.rtis_sys_org_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rtis_sys_org
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rtis_sys_org_op purge;
drop table ${iol_schema}.rtis_sys_org_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_sys_org_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_sys_org where 0=1;

create table ${iol_schema}.rtis_sys_org_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_sys_org where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rtis_sys_org_cl(
            id_ -- 机构编号
            ,parent_id -- 上级机构ID
            ,full_path -- 机构路径
            ,name_ -- 机构名称
            ,type_ -- 类型 ORG-机构， DEP-部门
            ,contact -- 联系人
            ,mobile -- 负责人姓名
            ,comments -- 机构描述
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_by -- 创建人
            ,update_by -- 更新人
            ,org_area -- 管理区域
            ,handle_org -- HANDLE ORG
            ,org_level -- 机构级别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rtis_sys_org_op(
            id_ -- 机构编号
            ,parent_id -- 上级机构ID
            ,full_path -- 机构路径
            ,name_ -- 机构名称
            ,type_ -- 类型 ORG-机构， DEP-部门
            ,contact -- 联系人
            ,mobile -- 负责人姓名
            ,comments -- 机构描述
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_by -- 创建人
            ,update_by -- 更新人
            ,org_area -- 管理区域
            ,handle_org -- HANDLE ORG
            ,org_level -- 机构级别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id_, o.id_) as id_ -- 机构编号
    ,nvl(n.parent_id, o.parent_id) as parent_id -- 上级机构ID
    ,nvl(n.full_path, o.full_path) as full_path -- 机构路径
    ,nvl(n.name_, o.name_) as name_ -- 机构名称
    ,nvl(n.type_, o.type_) as type_ -- 类型 ORG-机构， DEP-部门
    ,nvl(n.contact, o.contact) as contact -- 联系人
    ,nvl(n.mobile, o.mobile) as mobile -- 负责人姓名
    ,nvl(n.comments, o.comments) as comments -- 机构描述
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
    ,nvl(n.update_by, o.update_by) as update_by -- 更新人
    ,nvl(n.org_area, o.org_area) as org_area -- 管理区域
    ,nvl(n.handle_org, o.handle_org) as handle_org -- HANDLE ORG
    ,nvl(n.org_level, o.org_level) as org_level -- 机构级别
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
from (select * from ${iol_schema}.rtis_sys_org_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rtis_sys_org where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id_ = n.id_
where (
        o.id_ is null
    )
    or (
        n.id_ is null
    )
    or (
        o.parent_id <> n.parent_id
        or o.full_path <> n.full_path
        or o.name_ <> n.name_
        or o.type_ <> n.type_
        or o.contact <> n.contact
        or o.mobile <> n.mobile
        or o.comments <> n.comments
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.create_by <> n.create_by
        or o.update_by <> n.update_by
        or o.org_area <> n.org_area
        or o.handle_org <> n.handle_org
        or o.org_level <> n.org_level
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rtis_sys_org_cl(
            id_ -- 机构编号
            ,parent_id -- 上级机构ID
            ,full_path -- 机构路径
            ,name_ -- 机构名称
            ,type_ -- 类型 ORG-机构， DEP-部门
            ,contact -- 联系人
            ,mobile -- 负责人姓名
            ,comments -- 机构描述
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_by -- 创建人
            ,update_by -- 更新人
            ,org_area -- 管理区域
            ,handle_org -- HANDLE ORG
            ,org_level -- 机构级别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rtis_sys_org_op(
            id_ -- 机构编号
            ,parent_id -- 上级机构ID
            ,full_path -- 机构路径
            ,name_ -- 机构名称
            ,type_ -- 类型 ORG-机构， DEP-部门
            ,contact -- 联系人
            ,mobile -- 负责人姓名
            ,comments -- 机构描述
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_by -- 创建人
            ,update_by -- 更新人
            ,org_area -- 管理区域
            ,handle_org -- HANDLE ORG
            ,org_level -- 机构级别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id_ -- 机构编号
    ,o.parent_id -- 上级机构ID
    ,o.full_path -- 机构路径
    ,o.name_ -- 机构名称
    ,o.type_ -- 类型 ORG-机构， DEP-部门
    ,o.contact -- 联系人
    ,o.mobile -- 负责人姓名
    ,o.comments -- 机构描述
    ,o.create_time -- 创建时间
    ,o.update_time -- 更新时间
    ,o.create_by -- 创建人
    ,o.update_by -- 更新人
    ,o.org_area -- 管理区域
    ,o.handle_org -- HANDLE ORG
    ,o.org_level -- 机构级别
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
from ${iol_schema}.rtis_sys_org_bk o
    left join ${iol_schema}.rtis_sys_org_op n
        on
            o.id_ = n.id_
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rtis_sys_org_cl d
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
--truncate table ${iol_schema}.rtis_sys_org;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rtis_sys_org') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rtis_sys_org drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rtis_sys_org add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rtis_sys_org exchange partition p_${batch_date} with table ${iol_schema}.rtis_sys_org_cl;
alter table ${iol_schema}.rtis_sys_org exchange partition p_20991231 with table ${iol_schema}.rtis_sys_org_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rtis_sys_org to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rtis_sys_org_op purge;
drop table ${iol_schema}.rtis_sys_org_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rtis_sys_org_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rtis_sys_org',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
