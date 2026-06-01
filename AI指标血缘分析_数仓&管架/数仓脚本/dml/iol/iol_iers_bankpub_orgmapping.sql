/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_bankpub_orgmapping
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
create table ${iol_schema}.iers_bankpub_orgmapping_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_bankpub_orgmapping
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bankpub_orgmapping_op purge;
drop table ${iol_schema}.iers_bankpub_orgmapping_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bankpub_orgmapping_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_bankpub_orgmapping where 0=1;

create table ${iol_schema}.iers_bankpub_orgmapping_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_bankpub_orgmapping where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bankpub_orgmapping_cl(
            pk_orgmapping -- 主键
            ,pk_src_system -- 来源信息主键
            ,pk_group -- 主键
            ,pk_org -- 主键
            ,pk_accountingbook -- 主键
            ,pk_org_v -- 主键
            ,pk_dept -- 主键
            ,mapping_orgcode -- 编码
            ,mapping_orgname -- 名称
            ,mapping_deptcode -- 编码
            ,mapping_deptname -- 名称
            ,mapping_parent_deptcode -- 编码
            ,isorgmapping -- 
            ,creator -- 创建人
            ,creationtime -- 创建时间
            ,modifier -- 修改者
            ,modifiedtime -- 修改时间
            ,def1 -- 自定义项
            ,def2 -- 自定义项
            ,def3 -- 自定义项
            ,def4 -- 自定义项
            ,def5 -- 自定义项
            ,def6 -- 自定义项
            ,def7 -- 自定义项
            ,def8 -- 自定义项
            ,def9 -- 自定义项
            ,def10 -- 自定义项
            ,ts -- 时间戳
            ,dr -- 删除标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bankpub_orgmapping_op(
            pk_orgmapping -- 主键
            ,pk_src_system -- 来源信息主键
            ,pk_group -- 主键
            ,pk_org -- 主键
            ,pk_accountingbook -- 主键
            ,pk_org_v -- 主键
            ,pk_dept -- 主键
            ,mapping_orgcode -- 编码
            ,mapping_orgname -- 名称
            ,mapping_deptcode -- 编码
            ,mapping_deptname -- 名称
            ,mapping_parent_deptcode -- 编码
            ,isorgmapping -- 
            ,creator -- 创建人
            ,creationtime -- 创建时间
            ,modifier -- 修改者
            ,modifiedtime -- 修改时间
            ,def1 -- 自定义项
            ,def2 -- 自定义项
            ,def3 -- 自定义项
            ,def4 -- 自定义项
            ,def5 -- 自定义项
            ,def6 -- 自定义项
            ,def7 -- 自定义项
            ,def8 -- 自定义项
            ,def9 -- 自定义项
            ,def10 -- 自定义项
            ,ts -- 时间戳
            ,dr -- 删除标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pk_orgmapping, o.pk_orgmapping) as pk_orgmapping -- 主键
    ,nvl(n.pk_src_system, o.pk_src_system) as pk_src_system -- 来源信息主键
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 主键
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 主键
    ,nvl(n.pk_accountingbook, o.pk_accountingbook) as pk_accountingbook -- 主键
    ,nvl(n.pk_org_v, o.pk_org_v) as pk_org_v -- 主键
    ,nvl(n.pk_dept, o.pk_dept) as pk_dept -- 主键
    ,nvl(n.mapping_orgcode, o.mapping_orgcode) as mapping_orgcode -- 编码
    ,nvl(n.mapping_orgname, o.mapping_orgname) as mapping_orgname -- 名称
    ,nvl(n.mapping_deptcode, o.mapping_deptcode) as mapping_deptcode -- 编码
    ,nvl(n.mapping_deptname, o.mapping_deptname) as mapping_deptname -- 名称
    ,nvl(n.mapping_parent_deptcode, o.mapping_parent_deptcode) as mapping_parent_deptcode -- 编码
    ,nvl(n.isorgmapping, o.isorgmapping) as isorgmapping -- 
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改者
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 修改时间
    ,nvl(n.def1, o.def1) as def1 -- 自定义项
    ,nvl(n.def2, o.def2) as def2 -- 自定义项
    ,nvl(n.def3, o.def3) as def3 -- 自定义项
    ,nvl(n.def4, o.def4) as def4 -- 自定义项
    ,nvl(n.def5, o.def5) as def5 -- 自定义项
    ,nvl(n.def6, o.def6) as def6 -- 自定义项
    ,nvl(n.def7, o.def7) as def7 -- 自定义项
    ,nvl(n.def8, o.def8) as def8 -- 自定义项
    ,nvl(n.def9, o.def9) as def9 -- 自定义项
    ,nvl(n.def10, o.def10) as def10 -- 自定义项
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,case when
            n.pk_orgmapping is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_orgmapping is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_orgmapping is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_bankpub_orgmapping_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_bankpub_orgmapping where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_orgmapping = n.pk_orgmapping
where (
        o.pk_orgmapping is null
    )
    or (
        n.pk_orgmapping is null
    )
    or (
        o.pk_src_system <> n.pk_src_system
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.pk_accountingbook <> n.pk_accountingbook
        or o.pk_org_v <> n.pk_org_v
        or o.pk_dept <> n.pk_dept
        or o.mapping_orgcode <> n.mapping_orgcode
        or o.mapping_orgname <> n.mapping_orgname
        or o.mapping_deptcode <> n.mapping_deptcode
        or o.mapping_deptname <> n.mapping_deptname
        or o.mapping_parent_deptcode <> n.mapping_parent_deptcode
        or o.isorgmapping <> n.isorgmapping
        or o.creator <> n.creator
        or o.creationtime <> n.creationtime
        or o.modifier <> n.modifier
        or o.modifiedtime <> n.modifiedtime
        or o.def1 <> n.def1
        or o.def2 <> n.def2
        or o.def3 <> n.def3
        or o.def4 <> n.def4
        or o.def5 <> n.def5
        or o.def6 <> n.def6
        or o.def7 <> n.def7
        or o.def8 <> n.def8
        or o.def9 <> n.def9
        or o.def10 <> n.def10
        or o.ts <> n.ts
        or o.dr <> n.dr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bankpub_orgmapping_cl(
            pk_orgmapping -- 主键
            ,pk_src_system -- 来源信息主键
            ,pk_group -- 主键
            ,pk_org -- 主键
            ,pk_accountingbook -- 主键
            ,pk_org_v -- 主键
            ,pk_dept -- 主键
            ,mapping_orgcode -- 编码
            ,mapping_orgname -- 名称
            ,mapping_deptcode -- 编码
            ,mapping_deptname -- 名称
            ,mapping_parent_deptcode -- 编码
            ,isorgmapping -- 
            ,creator -- 创建人
            ,creationtime -- 创建时间
            ,modifier -- 修改者
            ,modifiedtime -- 修改时间
            ,def1 -- 自定义项
            ,def2 -- 自定义项
            ,def3 -- 自定义项
            ,def4 -- 自定义项
            ,def5 -- 自定义项
            ,def6 -- 自定义项
            ,def7 -- 自定义项
            ,def8 -- 自定义项
            ,def9 -- 自定义项
            ,def10 -- 自定义项
            ,ts -- 时间戳
            ,dr -- 删除标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bankpub_orgmapping_op(
            pk_orgmapping -- 主键
            ,pk_src_system -- 来源信息主键
            ,pk_group -- 主键
            ,pk_org -- 主键
            ,pk_accountingbook -- 主键
            ,pk_org_v -- 主键
            ,pk_dept -- 主键
            ,mapping_orgcode -- 编码
            ,mapping_orgname -- 名称
            ,mapping_deptcode -- 编码
            ,mapping_deptname -- 名称
            ,mapping_parent_deptcode -- 编码
            ,isorgmapping -- 
            ,creator -- 创建人
            ,creationtime -- 创建时间
            ,modifier -- 修改者
            ,modifiedtime -- 修改时间
            ,def1 -- 自定义项
            ,def2 -- 自定义项
            ,def3 -- 自定义项
            ,def4 -- 自定义项
            ,def5 -- 自定义项
            ,def6 -- 自定义项
            ,def7 -- 自定义项
            ,def8 -- 自定义项
            ,def9 -- 自定义项
            ,def10 -- 自定义项
            ,ts -- 时间戳
            ,dr -- 删除标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pk_orgmapping -- 主键
    ,o.pk_src_system -- 来源信息主键
    ,o.pk_group -- 主键
    ,o.pk_org -- 主键
    ,o.pk_accountingbook -- 主键
    ,o.pk_org_v -- 主键
    ,o.pk_dept -- 主键
    ,o.mapping_orgcode -- 编码
    ,o.mapping_orgname -- 名称
    ,o.mapping_deptcode -- 编码
    ,o.mapping_deptname -- 名称
    ,o.mapping_parent_deptcode -- 编码
    ,o.isorgmapping -- 
    ,o.creator -- 创建人
    ,o.creationtime -- 创建时间
    ,o.modifier -- 修改者
    ,o.modifiedtime -- 修改时间
    ,o.def1 -- 自定义项
    ,o.def2 -- 自定义项
    ,o.def3 -- 自定义项
    ,o.def4 -- 自定义项
    ,o.def5 -- 自定义项
    ,o.def6 -- 自定义项
    ,o.def7 -- 自定义项
    ,o.def8 -- 自定义项
    ,o.def9 -- 自定义项
    ,o.def10 -- 自定义项
    ,o.ts -- 时间戳
    ,o.dr -- 删除标志
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
from ${iol_schema}.iers_bankpub_orgmapping_bk o
    left join ${iol_schema}.iers_bankpub_orgmapping_op n
        on
            o.pk_orgmapping = n.pk_orgmapping
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_bankpub_orgmapping_cl d
        on
            o.pk_orgmapping = d.pk_orgmapping
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_bankpub_orgmapping;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_bankpub_orgmapping') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_bankpub_orgmapping drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_bankpub_orgmapping add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_bankpub_orgmapping exchange partition p_${batch_date} with table ${iol_schema}.iers_bankpub_orgmapping_cl;
alter table ${iol_schema}.iers_bankpub_orgmapping exchange partition p_20991231 with table ${iol_schema}.iers_bankpub_orgmapping_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_bankpub_orgmapping to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bankpub_orgmapping_op purge;
drop table ${iol_schema}.iers_bankpub_orgmapping_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_bankpub_orgmapping_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_bankpub_orgmapping',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
